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

with Ada.Real_Time; use Ada.Real_Time;

with HAL;           use HAL;
with HAL.I2C;       use HAL.I2C;
with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.I2C;     use STM32.I2C;

package body Board.Time_Of_Flight is

   function Set_Parameters
     (Sensor      : Sensor_Location;
      Timing      : UInt32;
      Rate        : VL53L0X.Fix_Point_16_16;
      Pre_Range   : UInt8;
      Final_Range : UInt8) return Boolean;

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
      I2C2_SDA : GPIO_Point renames STM32.Device.PB11;
      I2C2_SCL : GPIO_Point renames STM32.Device.PB10;
      I2C_Conf : I2C_Configuration;
      Points   : constant GPIO_Points := (I2C2_SDA, I2C2_SCL);
   begin
      Enable_Clock (Points);

      Configure_IO (Points,
                    (Speed       => Speed_High,
                     Mode        => Mode_AF,
                     Output_Type => Open_Drain,
                     Resistors   => Floating));
      Configure_Alternate_Function (Points, GPIO_AF_I2C2_4);
      Lock (Points);

      Enable_Clock (I2C_ToF);
      STM32.Device.Reset (I2C_ToF);

      delay until Clock + Milliseconds (200);

      I2C_Conf.Own_Address := 16#00#;
      I2C_Conf.Addressing_Mode := Addressing_Mode_7bit;
      I2C_Conf.General_Call_Enabled := False;
      I2C_Conf.Clock_Stretching_Enabled := True;

      I2C_Conf.Clock_Speed := 400_000;

      I2C_ToF.Configure (I2C_Conf);
   end Init_I2C;

   ------------------
   -- Init_Sensors --
   ------------------

   procedure Init_Sensors
   is
      Final_Addr : I2C_Address;
      Dev_Id     : UInt16;
      Status     : Boolean := True;
      Pins       : constant STM32.GPIO.GPIO_Points :=
                     (Reset (Front),
                      Reset (Front_Left),
                      Reset (Front_Right),
                      Reset (Side_Right),
                      Reset (Rear));

   begin
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
         Initialize (Sensors (Id));
         Reset (Id).Set;

         delay until Clock + Ada.Real_Time.Milliseconds (2);

         Final_Addr := Final_Addr + 2;

         Dev_Id := Read_Id (Sensors (Id));

         if Dev_Id = 16#EEAA# then
            --  Found a sensor: set the new I2C address
            Set_Device_Address (Sensors (Id), Final_Addr, Status);
         else
            Status := False;
         end if;

         if Status then
            --  Now check that the sensor is at the new address
            Dev_Id := Read_Id (Sensors (Id));

            if Dev_Id /= 16#EEAA# then
               Status := False;
            end if;
         end if;

         Data_Init (Sensors (Id), Status);
         if Status then
            Static_Init (Sensors (Id), VL53L0X.New_Sample_Ready, Status);
         end if;
         if Status then
            Perform_Ref_Calibration (Sensors (Id), Status);
         end if;

         if Status then
            Set_Detection_Mode (Id, Long_Range);
            S_Status (Id) := Ready;
         else
            Reset (Id).Clear;
            S_Status (Id) := Uninitialized;
         end if;
      end loop;
   end Init_Sensors;

   --------------------
   -- Set_Parameters --
   --------------------

   function Set_Parameters
     (Sensor      : Sensor_Location;
      Timing      : UInt32;
      Rate        : VL53L0X.Fix_Point_16_16;
      Pre_Range   : UInt8;
      Final_Range : UInt8) return Boolean
   is
      Status : Boolean;

   begin
      Set_Signal_Rate_Limit (Sensors (Sensor), Rate);

      Delays (Sensor) := Microseconds (Integer (Timing)) - Milliseconds (1);
      Timings (Sensor) := Clock;
      Set_Measurement_Timing_Budget (Sensors (Sensor), Timing, Status);

      if Status then
         Set_VCSEL_Pulse_Period_Pre_Range (Sensors (Sensor), Pre_Range, Status);
      end if;

      if Status then
         Set_VCSEL_Pulse_Period_Final_Range (Sensors (Sensor), Final_Range, Status);
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
               Timing      => 33_000,
               Rate        => 0.1,
               Pre_Range   => 18,
               Final_Range => 14);
            pragma Warnings
              (On, "static fixed-point value is not a multiple of Small");
         when Fast =>
            Status := Set_Parameters
              (Sensor,
               Timing      => 20_000,
               Rate        => 0.25,
               Pre_Range   => 14,
               Final_Range => 10);
         when Accurate =>
            Status := Set_Parameters
              (Sensor,
               Timing      => 200_000,
               Rate        => 0.25,
               Pre_Range   => 14,
               Final_Range => 10);
      end case;
   end Set_Detection_Mode;

   ----------------
   -- Next_Delay --
   ----------------

   procedure Next
     (Sensor : out Sensor_Id;
      Time   : out Ada.Real_Time.Time)
   is
      Status : Boolean;
   begin
      Time   := Time_Last;
      Sensor := Invalid;

      for Id in Timings'Range loop
         if S_Status (Id) in Valid_Status then
            if S_Status (Id) = Ready then
               Start_Range_Single_Millimeters (Sensors (Id), Status);

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
      Measure : HAL.UInt16;
   begin
      while not Range_Value_Available (Sensors (Sensor)) loop
         null;
      end loop;

      Measure := Read_Range_Millimeters (Sensors (Sensor));
      S_Status (Sensor) := Ready;

      if Measure > HAL.UInt16 (Infinity) then
         return Infinity;
      else
         return Millimeter (Measure);
      end if;
   end Read;

end Board.Time_Of_Flight;
