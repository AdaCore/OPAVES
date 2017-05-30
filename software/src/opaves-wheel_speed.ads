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

with Board.Motor_Encoder;
with OPAVES.Types;        use OPAVES.Types;

package OPAVES.Wheel_Speed is

   procedure Capture
     with Pre => Board.Motor_Encoder.Initialized;
   --  Measure and save Wheel_Speed, Motor_RPS and Wheel_RPS

   function Wheel_Speed return Car_Speed;
   --  Mean wheels speed between the last two captures. Note that the wheels
   --  may be sliping so this does not indicate the speed of the car.

   function Motor_RPS return Motor_Revolution_Per_Second;
   --  Mean revolution per second of the motor shaft between the last two
   --  captures.

   function Wheel_RPS return Motor_Revolution_Per_Second;
   --  Mean revolution per second of the wheel shaft between the last two
   --  captures.
end OPAVES.Wheel_Speed;
