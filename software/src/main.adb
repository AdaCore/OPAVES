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

with Last_Chance_Handler;

with System;

with Ada.Real_Time; use Ada.Real_Time;
with Board.LEDs;    use Board.LEDs;
with Board.Logging;

procedure Main is
begin

   Board.Logging.Log_Line
     ("O'PAVES: Open Platform for Autonomous VEhicle Systems");

   Board.LEDs.Initialize;

   Turn_On (Green);

   for Cnt in 1 .. 1_000 loop
      Toggle (Green);
      delay until Clock + Milliseconds (500);
   end loop;

   delay until Ada.Real_Time.Time_Last;

   Last_Chance_Handler.Last_Chance_Handler (Msg  => System.Null_Address,
                                            Line => 0);
end Main;
