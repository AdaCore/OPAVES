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

with STM32.Device;
with STM32.USARTs;
with STM32.GPIO;
with Ada.Interrupts;
with Ada.Interrupts.Names;
with Interfaces;

package Board.Comm
with Elaborate_Body
is
   Max_Message_Length : constant := 1024;

   subtype Message_Priority is Interfaces.Unsigned_8;
   procedure Send (Str  : String;
                   Prio : Message_Priority)
     with Pre => Str'Length <= Max_Message_Length;

   procedure Receive (Str : out String;
                      Len : out Natural)
   with Pre => Str'Length <= Max_Message_Length;

private

   Out_Message_Queue_Length : constant := 20;
   In_Message_Queue_Length : constant := 10;

   Baud_Rate : constant STM32.USARTs.Baud_Rates := 115_200;
   Device : STM32.USARTs.USART renames STM32.Device.USART_6;

   TX_Pin : STM32.GPIO.GPIO_Point renames STM32.Device.PC6;
   RX_Pin : STM32.GPIO.GPIO_Point renames STM32.Device.PC7;

   Transceiver_Interrupt_Id : Ada.Interrupts.Interrupt_ID renames
     Ada.Interrupts.Names.USART6_Interrupt;

   Transceiver_AF : STM32.GPIO_Alternate_Function renames
     STM32.Device.GPIO_AF_USART6_8;

end Board.Comm;
