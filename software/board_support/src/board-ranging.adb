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

with Ada.Unchecked_Conversion;
with Ada.Real_Time; use Ada.Real_Time;
with HAL.I2C;       use HAL.I2C;
with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.I2C;     use STM32.I2C;
with STM32.Setup;

with Board.Logging; use Board.Logging;

package body Board.Ranging is

   function I2C_Write
     (This   : access VL53L0x_Device;
      Data   : HAL.UInt8_Array) return VL53L0x_Error;

   function I2C_Read
     (This   : access VL53L0x_Device;
      Data   : out HAL.UInt8_Array) return VL53L0x_Error;

   function Read_ID (This : access VL53L0x_Device) return UInt16;

   procedure Init_I2C;

   procedure Init_Sensors
     with Pre => I2C_ToF.Port_Enabled;

   function Set_Parameters
     (Sensor       : Sensor_Location;
      Timing       : Ada.Real_Time.Time_Span;
      Signal_Limit : Fix_Point_16_16;
      Sigma_Limit  : Fix_Point_16_16;
      Pre_Range    : UInt8;
      Final_Range  : UInt8) return Boolean;

   -------------
   -- Read_ID --
   -------------

   function Read_ID (This : access VL53L0x_Device) return UInt16
   is
      REG_IDENTIFICATION_MODEL_ID : constant := 16#00c0#;
      Ret    : UInt16;
      Status : Boolean with Unreferenced;
   begin
      Status :=
        Read_Word (This, REG_IDENTIFICATION_MODEL_ID, Ret) = Error_None;
      return Ret;
   end Read_ID;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin
      Init_I2C;
      Init_Sensors;
   end Initialize;

   --------------
   -- Init_I2C --
   --------------

   procedure Init_I2C
   is
   begin
      STM32.Setup.Setup_I2C_Master (Port        => I2C_ToF,
                                    SDA         => I2C_ToF_SDA,
                                    SCL         => I2C_ToF_SCL,
                                    SDA_AF      => I2C_ToF_SDA_AF,
                                    SCL_AF      => I2C_ToF_SCL_AF,
                                    Clock_Speed => 400_000);
   end Init_I2C;

   ------------------
   -- Init_Sensors --
   ------------------

   procedure Init_Sensors
   is
      Dev              : access VL53L0x_Device;
      Final_Addr       : I2C_Address;
      Dev_Id           : UInt16;
      Status           : Boolean := True;
      Pins             : constant STM32.GPIO.GPIO_Points :=
                           (Reset (Front),
                            Reset (Front_Left),
                            Reset (Front_Right),
                            Reset (Side_Right),
                            Reset (Rear));
      VHV_Settings     : UInt8;
      Phase_Cal        : UInt8;
      Ref_Spad_Count   : UInt32;
      Is_Aperture_Spad : UInt8;

      --  Calibration values retrieved from a manual Offset calibration
      Offset_Micro     : constant array (Sensor_Location) of Integer_32 :=
                           (Front       => 47_000,
                            Front_Left  => 39_000,
                            Front_Right => 32_000,
                            Side_Right  => 36_000,
                            Rear        => 42_000);

   begin
      Logging.Log_Line (Debug, "Initializing range sensors...");

      --  Initialize the Reset lines
      STM32.Device.Enable_Clock (Pins);
      STM32.GPIO.Configure_IO
        (Pins,
         (Mode => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_Low,
          Resistors   => Pull_Up));

      for Pin of Reset loop
         Pin.Clear;
      end loop;

      --  Base sensor i2c address
      --  Here, we don't start with 16#52#, as this would lead to the first
      --  sensor being assigned 16#54#, which is the address of the touch
      --  panel on the STM32F469-disco board (on the same I2C bus).
      Final_Addr := 16#54#;

      for Id in Sensors'Range loop
         Dev := Sensors (Id)'Access;
         Dev.I2C_Address := 16#52#; --  Value at startup

         --  activate the sensor
         Reset (Id).Set;

         delay until Clock + Ada.Real_Time.Milliseconds (2);
         Final_Addr := Final_Addr + 2;

         --  Set I2C standard mode
         Status := Write_Byte (Dev, 16#88#, 16#00#) = Error_None;

         Dev_Id := Read_ID (Dev);

         if Dev_Id = 16#EEAA# then
            --  Found a sensor: set the new I2C address
            Status := Set_Device_Address
              (Dev, UInt8 (Final_Addr)) = Error_None;

            if Status then
               Dev.I2C_Address := Final_Addr;
            end if;
         else
            Logging.Log_Line (Error, "Cannot get ID of range sensor " & Id'Img);
            Status := False;
         end if;

         if Status then
            --  Now check that the sensor is at the new address
            Dev_Id := Read_ID (Dev);

            if Dev_Id /= 16#EEAA# then
               Logging.Log_Line (Error,
                                 "Address change failed for range sensor " &
                                   Id'Img);
               Status := False;
            end if;
         end if;

         Status := Data_Init (Dev) = Error_None;

         if Status then
            Status := Static_Init (Dev) = Error_None;
         end if;

         if Status then
            Status := Perform_Ref_Spad_Management
              (Dev               => Dev,
               Ref_Spad_Count    => Ref_Spad_Count,
               Is_Aperture_Spads => Is_Aperture_Spad) = Error_None;
         end if;

         if Status then
            Status := Perform_Ref_Calibration
              (Dev          => Dev,
               VHV_Settings => VHV_Settings,
               Phase_Cal    => Phase_Cal) = Error_None;
         end if;

         if Status then
--              Status := Perform_Offset_Calibration
--                (Dev, 90.0, Offset_Micro (Id)) = Error_None;
--              case Id is
--                 when Front =>
--                    Ada.Text_IO.Put_Line ("Front:");
--                 when Front_Left =>
--                    Ada.Text_IO.Put_Line ("Front Left:");
--                 when Front_Right =>
--                    Ada.Text_IO.Put_Line ("Front Right:");
--                 when Side_Right =>
--                    Ada.Text_IO.Put_Line ("Side Right:");
--                 when Rear =>
--                    Ada.Text_IO.Put_Line ("Rear:");
--              end case;
--              Ada.Text_IO.Put_Line (Offset_Micro (Id)'Img);
            Status := Set_Offset_Calibration_Data_Micro_Meter
              (Dev, Offset_Micro (Id)) = Error_None;
         end if;

         if Status then
            Status := Set_Device_Mode
              (Dev  => Dev,
               Mode => Single_Ranging) = Error_None;
         end if;

         if Status then
            Status := Set_Limit_Check_Enable
              (Dev,
               Check_Enable_Sigma_Final_Range,
               1) = Error_None;
         end if;

         if Status then
            Status := Set_Limit_Check_Enable
              (Dev,
               Check_Enable_Signal_Rate_Final_Range,
               1) = Error_None;
         end if;

         if Status then
            Set_Detection_Mode (Id, Accurate);
            S_Status (Id) := Ready;
            Logging.Log_Line (Debug, "Range sensor " & Id'Img & " ready.");
         else
            Reset (Id).Clear;
            S_Status (Id) := Uninitialized;
            Logging.Log_Line (Error, "Range sensor " & Id'Img & " init failed.");
         end if;

      end loop;
   end Init_Sensors;

   --------------------
   -- Set_Parameters --
   --------------------

   function Set_Parameters
     (Sensor       : Sensor_Location;
      Timing       : Ada.Real_Time.Time_Span;
      Signal_Limit : Fix_Point_16_16;
      Sigma_Limit  : Fix_Point_16_16;
      Pre_Range    : UInt8;
      Final_Range  : UInt8) return Boolean
   is
      Status       : Boolean;
      VHV_Settings : UInt8;
      Phase_Cal    : UInt8;

   begin
      Status := Set_Limit_Check_Value
        (Sensors (Sensor)'Access,
         Check_Enable_Signal_Rate_Final_Range,
         Signal_Limit) = Error_None;

      if Status then
         Status := Set_Limit_Check_Value
           (Sensors (Sensor)'Access,
            Check_Enable_Sigma_Final_Range,
            Sigma_Limit) = Error_None;
      end if;

      Delays (Sensor) := Timing;
      Timings (Sensor) := Clock;

      if Status then
         Status := Set_Measurement_Timing_Budget_Microseconds
           (Sensors (Sensor)'Access,
            UInt32 (Timing / Microseconds (1))) = Error_None;
      end if;

      if Status then
         Status := Set_VCSel_Pulse_Period
           (Sensors (Sensor)'Access, VCSel_Period_Pre_Range,
            Pre_Range) = Error_None;
      end if;

      if Status then
         Status := Set_VCSel_Pulse_Period
           (Sensors (Sensor)'Access,
            VCSel_Period_Final_Range,
            Final_Range) = Error_None;
      end if;

      if Status then
         Status := Perform_Ref_Calibration
           (Dev          => Sensors (Sensor)'Access,
            VHV_Settings => VHV_Settings,
            Phase_Cal    => Phase_Cal) = Error_None;
      end if;

      if not Status then
         Delays (Sensor) := Time_Span_Zero;
         Timings (Sensor) := Time_Last;
         S_Status (Sensor) := Error;
      end if;

      return Status;
   end Set_Parameters;

   ------------------------
   -- Set_Detection_Mode --
   ------------------------

   procedure Set_Detection_Mode
     (Sensor : Sensor_Location;
      Mode   : Sensor_Detection_Mode)
   is
      Status : Boolean with Unreferenced;
   begin
      if Modes (Sensor) = Mode then
         return;
      end if;

      case Mode is
         when Long_Range =>
            pragma Warnings
              (Off, "static fixed-point value is not a multiple of Small");
            Status := Set_Parameters
              (Sensor,
               Timing       => Milliseconds (33),
               Signal_Limit => 0.1,
               Sigma_Limit  => 60.0,
               Pre_Range    => 18,
               Final_Range  => 14);
            pragma Warnings
              (On, "static fixed-point value is not a multiple of Small");
         when Fast =>
            Status := Set_Parameters
              (Sensor,
               Timing       => Milliseconds (20),
               Signal_Limit => 0.25,
               Sigma_Limit  => 18.0,
               Pre_Range    => 14,
               Final_Range  => 10);
         when Accurate =>
            Status := Set_Parameters
              (Sensor,
               Timing       => Milliseconds (200),
               Signal_Limit => 0.25,
               Sigma_Limit  => 32.0,
               Pre_Range    => 14,
               Final_Range  => 10);
      end case;
   end Set_Detection_Mode;

   ----------------
   -- Next_Delay --
   ----------------

   procedure Next
     (Sensor : out Range_Sensor_Id;
      Time   : out Ada.Real_Time.Time)
   is
      Status : Boolean;
   begin
      Time   := Time_Last;
      Sensor := Invalid;

      for Id in Timings'Range loop
         if S_Status (Id) in Valid_Status then
            if S_Status (Id) = Ready then
               Status :=
                 Perform_Single_Measurement (Sensors (Id)'Access) = Error_None;

               if not Status then
                  S_Status (Id) := Error;
               else
                  Timings (Id) := Clock + Delays (Id);
                  S_Status (Id) := Reading;
               end if;
            end if;

            if Timings (Id) < Time then
               Time   := Timings (Id);
               Sensor := Id;
            end if;
         end if;
      end loop;
   end Next;

   ----------
   -- Read --
   ----------

   function Read (Sensor : Sensor_Location) return Millimeter
   is
      Dev     : constant access VL53L0x_Device := Sensors (Sensor)'Access;
      Err     : VL53L0x_Error;
      Val     : UInt8;
      Measure : Ranging_Measurement_Data;
   begin
      loop
         Err := Get_Measurement_Data_Ready (Dev, Val);
         exit when Val /= 0;
         if Err /= Error_None then
            return Infinity;
         end if;
      end loop;

      Err := Get_Ranging_Measurement_Data (Dev, Measure);
      S_Status (Sensor) := Ready;

      if Err /= Error_None then
         return Infinity;
      end if;

      Err := Clear_Interrupt_Mask (Sensors (Sensor)'Access, 0);

      if Measure.Range_Millimeter > UInt16 (Infinity) then
         return Infinity;
      else
         return Millimeter (Measure.Range_Millimeter);
      end if;
   end Read;

   --------------------------
   -- Lock_Sequence_Access --
   --------------------------

   function Lock_Sequence_Access
     (Dev : access VL53L0x_Device) return VL53L0x_Error
   is
      pragma Unreferenced (Dev);
   begin
      return Error_None;
   end Lock_Sequence_Access;

   ----------------------------
   -- Unlock_Sequence_Access --
   ----------------------------

   function Unlock_Sequence_Access
     (Dev : access VL53L0x_Device) return VL53L0x_Error
   is
      pragma Unreferenced (Dev);
   begin
      return Error_None;
   end Unlock_Sequence_Access;

   ---------------
   -- I2C_Write --
   ---------------

   function I2C_Write
     (This   : access VL53L0x_Device;
      Data   : HAL.UInt8_Array) return VL53L0x_Error
   is
      Ret : HAL.I2C.I2C_Status;
   begin
      I2C_ToF.Master_Transmit
        (Addr    => This.I2C_Address,
         Data    => Data,
         Status  => Ret);
      if Ret = HAL.I2C.Ok then
         return Error_None;
      else
         return -1;
      end if;
   end I2C_Write;

   --------------
   -- I2C_Read --
   --------------

   function I2C_Read
     (This   : access VL53L0x_Device;
      Data   : out HAL.UInt8_Array) return VL53L0x_Error
   is
      Ret : HAL.I2C.I2C_Status;
   begin
      I2C_ToF.Master_Receive
        (Addr    => This.I2C_Address,
         Data    => Data,
         Status  => Ret);
      if Ret = HAL.I2C.Ok then
         return Error_None;
      else
         return -1;
      end if;
   end I2C_Read;

   -----------------
   -- Write_Multi --
   -----------------

   function Write_Multi
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      PData : System.Address;
      Count : UInt32) return VL53L0x_Error
   is
      subtype The_Data is UInt8_Array (1 .. Integer (Count));
      Ada_View : The_Data with Address => PData;
      Buf      : constant HAL.UInt8_Array := (1 => Index) & Ada_View;
   begin
      return I2C_Write (Dev, Buf);
   end Write_Multi;

   ----------------
   -- Read_Multi --
   ----------------

   function Read_Multi
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      PData : System.Address;
      Count : UInt32) return VL53L0x_Error
   is
      subtype The_Data is UInt8_Array (1 .. Integer (Count));
      Ada_View : The_Data with Address => PData;
      Err      : VL53L0x_Error;
   begin
      Err := I2C_Write (Dev, (1 => Index));
      if Err /= Error_None then
         return Err;
      end if;

      Err := I2C_Read (Dev, Ada_View);

      return Err;
   end Read_Multi;

   ----------------
   -- Write_Byte --
   ----------------

   function Write_Byte
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : UInt8) return VL53L0x_Error
   is
   begin
      return I2C_Write (Dev,
                        (1 => Index,
                         2 => Data));
   end Write_Byte;

   ----------------
   -- Write_Word --
   ----------------

   function Write_Word
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : UInt16) return VL53L0x_Error
   is
   begin
      return I2C_Write
        (Dev,
         (1 => Index,
          2 => UInt8 (Shift_Right (Data, 8)),
          3 => UInt8 (Data and 16#FF#)));
   end Write_Word;

   -----------------
   -- Write_DWord --
   -----------------

   function Write_DWord
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : UInt32) return VL53L0x_Error
   is
   begin
      return I2C_Write
        (Dev,
         (1 => Index,
          2 => UInt8 (Shift_Right (Data, 24)),
          3 => UInt8 (Shift_Right (Data, 16) and 16#FF#),
          4 => UInt8 (Shift_Right (Data, 8) and 16#FF#),
          5 => UInt8 (Data and 16#FF#)));
   end Write_DWord;

   ---------------
   -- Read_Byte --
   ---------------

   function Read_Byte
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : out UInt8) return VL53L0x_Error
   is
      Buf : UInt8_Array (1 .. 1);
      Err : VL53L0x_Error;
   begin
      Err := I2C_Write (Dev, (1 => Index));
      if Err /= Error_None then
         return Err;
      end if;

      Err := I2C_Read (Dev, Buf);
      Data := Buf (1);

      return Err;
   end Read_Byte;

   ---------------
   -- Read_Word --
   ---------------

   function Read_Word
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : out UInt16) return VL53L0x_Error
   is
      Buf : UInt8_Array (1 .. 2);
      Err : VL53L0x_Error;
   begin
      Err := I2C_Write (Dev, (1 => Index));
      if Err /= Error_None then
         return Err;
      end if;

      Err := I2C_Read (Dev, Buf);
      Data := Shift_Left (UInt16 (Buf (1)), 8) or UInt16 (Buf (2));

      return Err;
   end Read_Word;

   ----------------
   -- Read_DWord --
   ----------------

   function Read_DWord
     (Dev   : access VL53L0x_Device;
      Index : UInt8;
      Data  : out UInt32) return VL53L0x_Error
   is
      Buf : UInt8_Array (1 .. 4);
      Err : VL53L0x_Error;
   begin
      Err := I2C_Write (Dev, (1 => Index));
      if Err /= Error_None then
         return Err;
      end if;

      Err := I2C_Read (Dev, Buf);
      Data := Shift_Left (UInt32 (Buf (1)), 24) or
        Shift_Left (UInt32 (Buf (2)), 16) or
        Shift_Left (UInt32 (Buf (3)), 8) or
        UInt32 (Buf (4));

      return Err;
   end Read_DWord;

   -----------------
   -- Update_Byte --
   -----------------

   function Update_Byte
     (Dev      : access VL53L0x_Device;
      Index    : UInt8;
      And_Data : UInt8;
      Or_Data  : UInt8) return VL53L0x_Error
   is
      Val : UInt8;
      Err : VL53L0x_Error;
   begin
      Err := Read_Byte (Dev, Index, Val);

      if Err /= Error_None then
         return Err;
      end if;

      Val := (Val and And_Data) or Or_Data;

      Err := Write_Byte (Dev, Index, Val);

      return Err;
   end Update_Byte;

   -------------------
   -- Polling_Delay --
   -------------------

   function Polling_Delay
     (Dev      : access VL53L0x_Device) return VL53L0x_Error
   is
      pragma Unreferenced (Dev);
   begin
      return Error_None;
   end Polling_Delay;

end Board.Ranging;
