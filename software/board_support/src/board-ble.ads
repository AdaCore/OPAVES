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
with Ada.Interrupts.Names; use Ada.Interrupts;

package Board.BLE is

   BLE_UART_Interrupt_Id : constant Interrupt_ID :=
     Ada.Interrupts.Names.USART3_Interrupt;
   BLE_UART : STM32.USARTs.USART renames STM32.Device.USART_3;

   procedure Initialize_BLE_UART;
end Board.BLE;
