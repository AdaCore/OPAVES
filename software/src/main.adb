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
with STM32.Device;  use STM32.Device;
with STM32.GPIO;
with HAL.GPIO;      use HAL.GPIO;

procedure Main is
   Red   : STM32.GPIO.GPIO_Point renames PC2;
   Green : STM32.GPIO.GPIO_Point renames PC3;
   Unref : Boolean with Unreferenced;
begin

   Enable_Clock (Red);
   Enable_Clock (Green);
   Unref := Red.Set_Mode (Output);
   Unref := Green.Set_Mode (Output);

   Red.Set;
   Green.Clear;

   loop
      Red.Toggle;
      Green.Toggle;
      delay until Clock + Milliseconds (500);
   end loop;
end Main;
