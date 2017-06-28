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

with STM32.GPIO; use STM32.GPIO;
with STM32.Device; use STM32.Device;
with STM32.USARTs; use STM32.USARTs;

package body Board.Comm is

   procedure Initialize_Comm_UART is
      Configuration : GPIO_Port_Configuration;
      TX_Pin : GPIO_Point renames PC6;
      RX_Pin : GPIO_Point renames PC7;
   begin
      Enable_Clock (Comm_UART);
      Enable_Clock (RX_Pin & TX_Pin);

      Configuration.Mode := Mode_AF;
      Configuration.Speed := Speed_50MHz;
      Configuration.Output_Type := Push_Pull;
      Configuration.Resistors := Pull_Up;

      Configure_IO (RX_Pin & TX_Pin, Config => Configuration);

      Configure_Alternate_Function (RX_Pin & TX_Pin,  AF => GPIO_AF_USART6_8);

      STM32.USARTs.Disable (Comm_UART);

      Set_Word_Length (Comm_UART, Word_Length_8);
      Set_Stop_Bits (Comm_UART, Stopbits_1);
      Set_Parity (Comm_UART, No_Parity);
      Set_Oversampling_Mode (Comm_UART, Oversampling_By_16);
      Set_Baud_Rate (Comm_UART, 115200);
      Set_Mode (Comm_UART, Tx_Rx_Mode);
      Set_Flow_Control (Comm_UART, No_Flow_Control);

      Enable (Comm_UART);
   end Initialize_Comm_UART;
end Board.Comm;
