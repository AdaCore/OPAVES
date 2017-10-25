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
with Last_Chance_Handler;
pragma Unreferenced (Last_Chance_Handler);

with Board.LEDs;    use Board.LEDs;
with Board.Logging;

with LEDS; use LEDS;
with OPAVES.Comm.CRTP;
with OPAVES.Commander;

with Board.Motor;
with Board.Steering;

procedure Main is
begin
   LEDS.LEDS_Init;

   Board.Logging.Log_Line
     ("O'PAVES: Open Platform for Autonomous VEhicle Systems");

   Board.LEDs.Initialize;
   LEDS.Set_System_State (Ready);

   Board.Motor.Initialize;
   Board.Motor.Enable;

   Board.Steering.Initialize;
   Board.Steering.Enable;

   OPAVES.Comm.CRTP.Initialize;
   OPAVES.Commander.Initialize;

   delay until Ada.Real_Time.Time_Last;

   Last_Chance_Handler.Last_Chance_Handler (Msg  => System.Null_Address,
                                            Line => 0);
end Main;
