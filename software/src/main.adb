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

with Board.Logging;

with LEDS; use LEDS;
with OPAVES.Comm.CRTP;
with OPAVES.Commander;

with Board.Motor;
with Board.Steering;

procedure Main is
   COMMANDS_PERIOD_MS : constant Time_Span := Milliseconds (2);
   Next_Period        : Time;
begin
   LEDS.LEDS_Init;

   Board.Logging.Log_Line
     ("O'PAVES: Open Platform for Autonomous Vehicle Systems");

   LEDS.Set_System_State (Ready);

   Board.Motor.Initialize;
   Board.Motor.Enable;

   Board.Steering.Initialize;
   Board.Steering.Enable;

   OPAVES.Comm.CRTP.Initialize;
   OPAVES.Commander.Initialize;

   Next_Period := Clock + COMMANDS_PERIOD_MS;

   loop
      delay until Next_Period;

      Board.Motor.Set_Throttle (OPAVES.Commander.Get_Throttle_Command);
      Board.Steering.Set_Steering (OPAVES.Commander.Get_Steering_Command);

      Next_Period := Next_Period + COMMANDS_PERIOD_MS;
   end loop;
end Main;
