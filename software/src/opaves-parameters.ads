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

with Board.Parameters;

with Dimension_Types; use Dimension_Types;

with Ada.Numerics;

package OPAVES.Parameters with SPARK_Mode is

   ----------------------
   -- Board Parameters --
   ----------------------

   --  Redefinition of board parameters with apropriate types

   Wheel_Diameter : constant Length := Length (Board.Parameters.Wheel_Diameter);

   Wheel_Circumference : constant Length := Ada.Numerics.Pi * Wheel_Diameter;

   Motor_To_Wheel_Gear_Ratio : constant Dimensionless :=
     Dimensionless (Board.Parameters.Motor_To_Wheel_Gear_Ratio);

   Encoder_Tick_Per_Revolution : constant Dimensionless :=
     Dimensionless (Board.Parameters.Encoder_Tick_Per_Revolution);

   Encoder_Count_Wrap_Threshold : constant Dimensionless :=
     Dimensionless (Board.Parameters.Encoder_Count_Wrap_Threshold);

   ----------------------
   -- Speed Boundaries --
   ----------------------

   Max_Absolute_Car_Speed : constant Speed := Speed (4.0);
   --  Empirical absolute maximum speed of the car

   Max_Wheel_RPS : constant Revolution_Per_Second := Max_Absolute_Car_Speed / Wheel_Circumference;
   --  Maximum revolution per second of the wheel shaft

   Max_Motor_RPS : constant Revolution_Per_Second := Max_Wheel_RPS * Motor_To_Wheel_Gear_Ratio;
   --  Maximum revolution per second of the motor shaft

   Max_Encoder_Ticks_Per_Second : constant Frequency := Max_Wheel_RPS * Encoder_Tick_Per_Revolution;
   --  Maximum number of encoder ticks per second

   Max_Encoder_Read_Interval : constant Time := Encoder_Count_Wrap_Threshold / Max_Encoder_Ticks_Per_Second;
   --  Maximum time between two reading of the encoder to ensure a valid value

end OPAVES.Parameters;
