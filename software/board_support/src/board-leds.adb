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

with STM32.GPIO;   use STM32.GPIO;
with STM32.Device; use STM32.Device;

package body Board.LEDs is

   Init_Done : Boolean := False;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      IO_Conf : GPIO_Port_Configuration;
   begin
      IO_Conf.Mode        := Mode_Out;
      IO_Conf.Output_Type := Push_Pull;
      IO_Conf.Speed       := Speed_Low;
      IO_Conf.Resistors   := Floating;

      for Pin of LED_Pins loop
         Enable_Clock (Pin);
         Pin.Configure_IO (IO_Conf);
         Pin.Clear;
      end loop;

      Init_Done := True;
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean
   is (Init_Done);

   -------------
   -- Turn_On --
   -------------

   procedure Turn_On (LED : LED_Id) is
   begin
      LED_Pins (LED).Set;
   end Turn_On;

   --------------
   -- Turn_Off --
   --------------

   procedure Turn_Off (LED : LED_Id) is
   begin
      LED_Pins (LED).Clear;
   end Turn_Off;

   ------------
   -- Toggle --
   ------------

   procedure Toggle (LED : LED_Id) is
   begin
      LED_Pins (LED).Toggle;
   end Toggle;
end Board.LEDs;
