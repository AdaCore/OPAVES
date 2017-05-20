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

with HAL.I2C;

with STM32.Device;
with STM32.I2C;

with BNO055_I2C_IO;
with Bosch_BNO055;

package Board.IMU is

   IMU_Error : exception;

   type Value_3D is record
      X, Y, Z : Float;
   end record;

   type IMU_Data is record
      Orientation  : Value_3D;
      Acceleration : Value_3D;
   end record;

   procedure Initialize;

   function Read return IMU_Data;

private

   IMU_I2C : STM32.I2C.I2C_Port renames STM32.Device.I2C_1;

   --  COM3 low => Address is 16#28# (+ the r/w bit as bit0)
   IO      : aliased BNO055_I2C_IO.IO_Port :=
               (Port   => IMU_I2C'Access,
                Device => 16#50#);

   procedure Delay_Milliseconds (Count : Positive);

   package BNO055 is new Bosch_BNO055
     (IO_Port            => BNO055_I2C_IO.IO_Port,
      Any_IO_Port        => BNO055_I2C_IO.Any_IO_Port,
      Read               => BNO055_I2C_IO.Read,
      Write              => BNO055_I2C_IO.Write,
      Sensor_Data_Buffer => HAL.I2C.I2C_Data,
      Read_Buffer        => BNO055_I2C_IO.Read_Buffer,
      Delay_Milliseconds => Delay_Milliseconds);

   Device : aliased BNO055.BNO055_9DOF_IMU (IO'Access);

end Board.IMU;
