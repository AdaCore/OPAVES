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

with Ada.Real_Time;

with STM32.I2C;
with STM32.Device;
with STM32.GPIO;

with VL53L0X;

package Board.Time_Of_Flight is

   Sensor_Error : exception;

   type Sensor_Id is
     (Invalid,
      Front,
      Front_Left,
      Front_Right,
      Side_Right,
      Rear);

   type Sensor_Status is
     (Uninitialized,
      Error,
      Ready,
      Reading);

   type Sensor_Detection_Mode is
     (Fast,       --  Fast short range detection
      Long_Range, --  A bit slower but more powerful long range detection
      Accurate);  --  Slow and accurate measurement mode

   subtype Sensor_Location is Sensor_Id range Front .. Rear;

   subtype Millimeter is Natural range 0 .. 4000;
   Infinity : constant Millimeter := 4000;

   subtype Herz is Natural;

   I2C_ToF : STM32.I2C.I2C_Port renames STM32.Device.I2C_2;

   procedure Initialize;

   procedure Set_Detection_Mode
     (Sensor : Sensor_Location;
      Mode   : Sensor_Detection_Mode);

   function Status (Sensor : Sensor_Location) return Sensor_Status;

   procedure Next
     (Sensor : out Sensor_Id;
      Time   : out Ada.Real_Time.Time);
   --  Return the minimal delay between two consecutive sensor updates

   function Read (Sensor : Sensor_Location) return Millimeter
     with Pre => Status (Sensor) = Reading;
   --  Return the value measured by the sensor.

private

   procedure Init_I2C;

   procedure Init_Sensors
     with Pre => I2C_ToF.Port_Enabled;

   type ToF_Sensor is new VL53L0X.VL53L0X_Ranging_Sensor
     (Port => I2C_ToF'Access);

   Sensors : array (Sensor_Location) of ToF_Sensor;
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

end Board.Time_Of_Flight;
