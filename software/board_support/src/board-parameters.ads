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

--  Board parameters provides raw physical dimensions or harware specification
--  of the board.

package Board.Parameters is

   -------------
   -- Encoder --
   -------------

   Encoder_Tick_Per_Revolution : constant := 12.0;
   --  Number of encoder count for one revolution of the motor shaft

   Encoder_Count_Wrap_Threshold : constant := 2**16 / 2;
   --  Threshold to detect that the encoder count wrapped around. This is an
   --  empirical value. It's probably possible to compute a more precise
   --  threshold from maximum car speed and parameters of the drive train.

   -------------
   -- Gearbox --
   -------------

   Motor_To_Wheel_Gear_Ratio : constant := 11.6;
   --  Gear ratio of the Tamiya High Speed Gear Box in B configuration

   ------------
   -- Wheels --
   ------------

   Wheel_Diameter : constant := 0.044; -- In meter

end Board.Parameters;
