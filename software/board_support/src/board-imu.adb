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

with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.I2C;     use STM32.I2C;

with Board.LEDs;

package body Board.IMU is

   ------------------------
   -- Delay_Milliseconds --
   ------------------------

   procedure Delay_Milliseconds (Count : Positive)
   is
   begin
      delay until Clock + Milliseconds (Count);
   end Delay_Milliseconds;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      use BNO055;
      I2C2_SCL      : GPIO_Point renames STM32.Device.PB6;
      I2C2_SDA      : GPIO_Point renames STM32.Device.PB7;
      I2C_Conf      : I2C_Configuration;
      Points        : constant GPIO_Points := (I2C2_SDA, I2C2_SCL);
      System_Status : BNO055.System_Status_Values;
      Self_Test     : BNO055.Self_Test_Results;
      System_Error  : BNO055.System_Error_Values;
      Start         : Time;

   begin
      Board.LEDs.Turn_On (Board.LEDs.Green);
      --  First: Init the I2C
      Enable_Clock (Points);

      Configure_IO (Points,
                    (Speed       => Speed_High,
                     Mode        => Mode_AF,
                     Output_Type => Open_Drain,
                     Resistors   => Floating));
      Configure_Alternate_Function (Points, GPIO_AF_I2C1_4);
      Lock (Points);

      Enable_Clock (IMU_I2C);
      Reset (IMU_I2C);

      delay until Clock + Milliseconds (200);

      I2C_Conf.Own_Address := 16#00#;
      I2C_Conf.Addressing_Mode := Addressing_Mode_7bit;
      I2C_Conf.General_Call_Enabled := False;
      I2C_Conf.Clock_Stretching_Enabled := True;

      I2C_Conf.Clock_Speed := 100_000;

      IMU_I2C.Configure (I2C_Conf);

      --  Now confingure the IMU itself
      if Device.Device_Id /= I_Am_BNO055 then
         raise IMU_Error with "IMU is missing";
      end if;

      --  Configure with default values:
      --  NDOF mode
      --  Power mode normal
      --  With external crystal
      Device.Configure
        (Operating_Mode => Operating_Mode_IMU);

      Device.Set_Acceleration_Units (Meters_Second_Squared);
      Device.Set_Angular_Rate_Units (Radians_Second);
      Device.Set_Euler_Angle_Units  (Radians);
      Device.Set_Temperature_Units  (Celsius);
      Device.Set_Pitch_Rotation     (Clockwise_Decreasing);

      Device.Get_Status
        (System_Status,
         Self_Test,
         System_Error);

      if Self_Test /= All_Tests_Passed then
         raise IMU_Error with "Not all tests passed";
      end if;

      if System_Error /= No_Error then
         raise IMU_Error with "IMU: System error " & System_Error'Img;
      end if;

      --  Wait for the gyroscope to calibrate:
      --  it requires a stable position
      Start := Clock;
      while not Device.Calibration_Complete
        ((1 => Gyroscope))
      loop
         if Clock - Start > Milliseconds (200) then
            Board.LEDs.Toggle (Board.LEDs.Green);
         end if;
      end loop;

      Board.LEDs.Turn_Off (Board.LEDs.Green);
   end Initialize;

   ----------
   -- Read --
   ----------

   function Read return IMU_Data
   is
      use BNO055;
      Angles  : BNO055.Sensor_Data;
      Acc     : BNO055.Sensor_Data;

   begin
      Angles  := Device.Output (Euler_Orientation);
      Acc     := Device.Output (Linear_Acceleration_Data);

      return (Orientation  => (Angles (X), Angles (Y), Angles (Z)),
              Acceleration => (Acc (X), Acc (Y), Acc (Z)));
   end Read;

end Board.IMU;
