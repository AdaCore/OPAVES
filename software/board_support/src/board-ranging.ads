------------------------------------------------------------------------------
--                                                                          --
--                                  O'PAVES                                 --
--                                                                          --
--                        Copyright (C) 2017, AdaCore                       --
--                                                                          --
-- This program is free software; you can redistribute it and/or modify it  --
-- under terms of the GNU General Public License as published by the  Free  --
-- Software  Foundation;  either version 3,  or (at your option) any later  --
-- version. This software is distributed in the hope that it will be useful --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------

with Interfaces; use Interfaces;
with System;
with Ada.Real_Time;

with HAL;
with HAL.I2C;
with STM32.I2C;
with STM32.Device;
with STM32.GPIO;

package Board.Ranging is

   Sensor_Error : exception;

   type Range_Sensor_Id is
     (Invalid,
      Front,
      Front_Left,
      Front_Right,
      Side_Right,
      Rear);
   --  Identifier for the various range sensors present on-board

   subtype Sensor_Location is Range_Sensor_Id range Front .. Rear;
   --  The valid values for Sensor_Id

   type Sensor_Status is
     (Uninitialized,
      Error,
      Ready,
      Reading);

   type Sensor_Detection_Mode is
     (Fast,       --  Fast short range detection
      Long_Range, --  A bit slower but more powerful long range detection
      Accurate);  --  Slow and accurate measurement mode

   type Millimeter is new Natural range 0 .. 4000;
   Infinity : constant Millimeter := Millimeter'Last;

   type Herz is new Natural;

   procedure Initialize
   with Post => (for all S in Sensor_Location => Status (S) = Ready);

   procedure Set_Detection_Mode
     (Sensor : Sensor_Location;
      Mode   : Sensor_Detection_Mode);

   function Status (Sensor : Sensor_Location) return Sensor_Status;

   procedure Next
     (Sensor : out Range_Sensor_Id;
      Time   : out Ada.Real_Time.Time)
     with Pre => (for all S in Sensor_Location => Status (S) = Ready);
   --  Return the minimal delay between two consecutive sensor updates

   function Read (Sensor : Sensor_Location) return Millimeter
     with Pre => Status (Sensor) = Reading;
   --  Return the value measured by the sensor.

private
   use HAL;

   I2C_ToF        : STM32.I2C.I2C_Port renames STM32.Device.I2C_2;
   I2C_ToF_SDA    : STM32.GPIO.GPIO_Point renames STM32.Device.PB11;
   I2C_ToF_SCL    : STM32.GPIO.GPIO_Point renames STM32.Device.PB10;
   I2C_ToF_SDA_AF : STM32.GPIO_Alternate_Function renames STM32.Device.GPIO_AF_I2C2_4;
   I2C_ToF_SCL_AF : STM32.GPIO_Alternate_Function renames STM32.Device.GPIO_AF_I2C2_4;

   -----------------------------
   -- Wrapper to the C object --
   -----------------------------

   --  No easy way to map the C opaque structure to an Ada value.
   --  so we statically determined the size of the C structure, and report it
   --  here
   type Opaque_Dev_Data is array (1 .. 348) of UInt8
     with Alignment => 4;

   type VL53L0x_Device is record
      Data        : Opaque_Dev_Data;
      I2C_Address : HAL.I2C.I2C_Address := 16#52#;
   end record with Alignment => 4;

   -----------------
   -- Global data --
   -----------------

   Sensors : array (Sensor_Location) of aliased VL53L0x_Device :=
               (others => <>);
   Reset   : array (Sensor_Location) of STM32.GPIO.GPIO_Point :=
               (Front       => STM32.Device.PC15,
                Front_Left  => STM32.Device.PC13,
                Front_Right => STM32.Device.PC14,
                Side_Right  => STM32.Device.PB12,
                Rear        => STM32.Device.PE12);
   Modes   : array (Sensor_Location) of Sensor_Detection_Mode :=
               (others => Accurate);
   --  Default value is changed at initialisation

   subtype Invalid_Status is Sensor_Status range Uninitialized .. Error;
   subtype Valid_Status is Sensor_Status range Ready .. Reading;

   Delays  : array (Sensor_Location) of Ada.Real_Time.Time_Span :=
               (others => Ada.Real_Time.Time_Span_Zero);
   Timings : array (Sensor_Location) of Ada.Real_Time.Time :=
               (others => Ada.Real_Time.Time_Last);
   S_Status : array (Sensor_Location) of Sensor_Status :=
                (others => Uninitialized);

   function Status (Sensor : Sensor_Location) return Sensor_Status
   is (S_Status (Sensor));

   --------------------------------
   -- Interface to the C library --
   --------------------------------

   subtype VL53L0x_Error is Interfaces.Integer_8;

   Error_None : constant VL53L0x_Error := 0;
   Error_Calibration_Warning : constant VL53L0x_Error := -1;
   Error_Min_Clipped         : constant VL53L0x_Error := -2;
   Error_Undefined           : constant VL53L0x_Error := -3;

   Fix_Point_16_16_Delta : constant := 1.0 / (2.0 ** 16);

   type Fix_Point_16_16 is
     delta Fix_Point_16_16_Delta
     range -2.0 ** 15 .. 2.0 ** 15 - Fix_Point_16_16_Delta
     with Size => 32;

   -------------------
   -- Exported to C --
   -------------------

   function Lock_Sequence_Access
     (Dev : access VL53L0x_Device) return VL53L0x_Error;
   pragma Export (C, Lock_Sequence_Access, "VL53L0x_Lock_Sequence_Access");

   function Unlock_Sequence_Access
     (Dev : access VL53L0x_Device) return VL53L0x_Error;
   pragma Export (C, Unlock_Sequence_Access, "VL53L0X_UnlockSequenceAccess");

   function Write_Multi
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      PData : System.Address;
      Count : UInt32) return VL53L0x_Error;
   pragma Export (C, Write_Multi, "VL53L0X_WriteMulti");

   function Read_Multi
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      PData : System.Address;
      Count : UInt32) return VL53L0x_Error;
   pragma Export (C, Read_Multi, "VL53L0X_ReadMulti");

   function Write_Byte
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : UInt8) return VL53L0x_Error;
   pragma Export (C, Write_Byte, "VL53L0X_WrByte");

   function Write_Word
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : UInt16) return VL53L0x_Error;
   pragma Export (C, Write_Word, "VL53L0X_WrWord");

   function Write_DWord
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : UInt32) return VL53L0x_Error;
   pragma Export (C, Write_DWord, "VL53L0X_WrDWord");

   function Read_Byte
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : out UInt8) return VL53L0x_Error;
   pragma Export (C, Read_Byte, "VL53L0X_RdByte");

   function Read_Word
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : out UInt16) return VL53L0x_Error;
   pragma Export (C, Read_Word, "VL53L0X_RdWord");

   function Read_DWord
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : out UInt32) return VL53L0x_Error;
   pragma Export (C, Read_DWord, "VL53L0X_RdDWord");

   function Update_Byte
     (Dev      : access VL53L0x_Device;
      Index    : UInt8;
      And_Data : UInt8;
      Or_Data  : UInt8) return VL53L0x_Error;
   pragma Export (C, Update_Byte, "VL53L0X_UpdateByte");

   function Polling_Delay
     (Dev      : access VL53L0x_Device) return VL53L0x_Error;
   pragma Export (C, Polling_Delay, "VL53L0X_PollingDelay");

   ---------------------
   -- Imported from C --
   ---------------------

   function Data_Init
     (Dev : access VL53L0x_Device) return VL53L0x_Error;
   pragma Import (C, Data_Init, "VL53L0X_DataInit");

   function Set_Device_Address
     (Dev : access VL53L0x_Device;
      Addr : UInt8) return VL53L0x_Error;
   pragma Import (C, Set_Device_Address, "VL53L0X_SetDeviceAddress");

   function Static_Init
     (Dev : access VL53L0x_Device) return VL53L0x_Error;
   pragma Import (C, Static_Init, "VL53L0X_StaticInit");

   function Perform_Ref_Calibration
     (Dev : access VL53L0x_Device;
      VHV_Settings : out UInt8;
      Phase_Cal    : out UInt8) return VL53L0x_Error;
   pragma Import (C, Perform_Ref_Calibration, "VL53L0X_PerformRefCalibration");

   function Perform_Ref_Spad_Management
     (Dev               : access VL53L0x_Device;
      Ref_Spad_Count    : out UInt32;
      Is_Aperture_Spads : out UInt8) return VL53L0x_Error;
   pragma Import (C, Perform_Ref_Spad_Management,
                  "VL53L0X_PerformRefSpadManagement");

   function Perform_Offset_Calibration
     (Dev      : access VL53L0x_Device;
      Expected : Fix_Point_16_16;
      Offset   : out Interfaces.Integer_32) return VL53L0x_Error;
   pragma Import (C, Perform_Offset_Calibration,
                  "VL53L0X_PerformOffsetCalibration");

   function Set_Offset_Calibration_Data_Micro_Meter
     (Dev   : access VL53L0x_Device;
      Value : Interfaces.Integer_32) return VL53L0x_Error;
   pragma Import (C, Set_Offset_Calibration_Data_Micro_Meter,
                  "VL53L0X_SetOffsetCalibrationDataMicroMeter");

   type Device_Mode is
     (Single_Ranging,
      Continuous_Ranging,
      Single_Histogram,
      Continuous_Timed_Ranging,
      Single_ALS,
      GPIO_Drive,
      GPIO_OSC) with Size => 8, Convention => C;

   for Device_Mode use
     (Single_Ranging           => 0,
      Continuous_Ranging       => 1,
      Single_Histogram         => 2,
      Continuous_Timed_Ranging => 3,
      Single_ALS               => 10,
      GPIO_Drive               => 20,
      GPIO_OSC                 => 21);

   function Set_Device_Mode
     (Dev  : access VL53L0x_Device;
      Mode : Device_Mode) return VL53L0x_Error;
   pragma Import (C, Set_Device_Mode, "VL53L0X_SetDeviceMode");

   function Set_Measurement_Timing_Budget_Microseconds
     (Dev    : access VL53L0x_Device;
      Budget : UInt32) return VL53L0x_Error;
   pragma Import (C, Set_Measurement_Timing_Budget_Microseconds,
                  "VL53L0X_SetMeasurementTimingBudgetMicroSeconds");

   type VCSel_Period is
     (VCSel_Period_Pre_Range,
      VCSel_Period_Final_Range) with Size => 8, Convention => C;

   function Set_VCSel_Pulse_Period
     (Dev          : access VL53L0x_Device;
      Period_Type  : VCSel_Period;
      Pulse_Period : UInt8) return VL53L0x_Error;
   pragma Import (C, Set_VCSel_Pulse_Period, "VL53L0X_SetVcselPulsePeriod");

   type Check_Enable_Type is
     (Check_Enable_Sigma_Final_Range,
      Check_Enable_Signal_Rate_Final_Range,
      Check_Enable_Signal_Ref_Clip,
      Check_Enable_Range_Ignore_Threshold,
      Check_Enable_Signal_Rate_MSRC,
      Check_Enable_Signal_Rate_Pre_Range) with Size => 16, Convention => C;

   function Set_Limit_Check_Enable
     (Dev        : access VL53L0x_Device;
      Check_Type : Check_Enable_Type;
      Value      : UInt8) return VL53L0x_Error;
   pragma Import (C, Set_Limit_Check_Enable, "VL53L0X_SetLimitCheckEnable");

   function Set_Limit_Check_Value
     (Dev        : access VL53L0x_Device;
      Check_Type : Check_Enable_Type;
      Value      : Fix_Point_16_16) return VL53L0x_Error;
   pragma Import (C, Set_Limit_Check_Value, "VL53L0X_SetLimitCheckValue");

   function Perform_Single_Measurement
     (Dev : access VL53L0x_Device) return VL53L0x_Error;
   pragma Import (C, Perform_Single_Measurement,
                  "VL53L0X_PerformSingleMeasurement");

   function Get_Measurement_Data_Ready
     (Dev        : access VL53L0x_Device;
      Data_Ready : out UInt8) return VL53L0x_Error;
   pragma Import
     (C, Get_Measurement_Data_Ready, "VL53L0X_GetMeasurementDataReady");

   type Ranging_Measurement_Data is record
      Time_Stamp                : UInt32;
      Measurement_Time_USec     : UInt32;
      Range_Millimeter          : UInt16;
      Range_D_Max_Millimeter    : UInt16;
      Signal_Rate_Rtn_Mega_Cps  : Fix_Point_16_16;
      Ambient_Rate_Rtn_Mega_Cps : Fix_Point_16_16;
      Effective_Spad_Rtn_Count  : UInt16;
      Zone_Id                   : UInt8;
      Range_Fractional_Part     : UInt8;
      Range_Status              : UInt8;
   end record with Convention => C;

   function Get_Ranging_Measurement_Data
     (Dev              : access VL53L0x_Device;
      Measurement_Data : out Ranging_Measurement_Data) return VL53L0x_Error;
   pragma Import (C, Get_Ranging_Measurement_Data,
                  "VL53L0X_GetRangingMeasurementData");

   function Clear_Interrupt_Mask
     (Dev  : access VL53L0x_Device;
      Mask : UInt32) return VL53L0x_Error;
   pragma Import (C, Clear_Interrupt_Mask, "VL53L0X_ClearInterruptMask");

end Board.Ranging;
