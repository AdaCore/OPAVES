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

with OPAVES.Parameters; use OPAVES.Parameters;

with Dimension_Types;   use Dimension_Types;

package OPAVES.Types with SPARK_Mode is

   subtype Car_Speed is Speed range
     -Max_Absolute_Car_Speed .. Max_Absolute_Car_Speed;
   --  A value below zero means that the car is going backwards

   subtype Motor_Revolution_Per_Second is Revolution_Per_Second range
     -Max_Motor_RPS .. Max_Motor_RPS;
   --  A value below zero means that the motor is spining backwards

   subtype Wheel_Revolution_Per_Second is Revolution_Per_Second range
     -Max_Wheel_RPS .. Max_Wheel_RPS;
   --  A value below zero means that the wheel is spining backwards

end OPAVES.Types;
