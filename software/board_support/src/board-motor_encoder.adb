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

with HAL;          use HAL;
with STM32.GPIO;   use STM32.GPIO;
with STM32.Device; use STM32.Device;
with STM32.Timers; use STM32.Timers;

package body Board.Motor_Encoder is

   Init_Done : Boolean := False;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Configuration : GPIO_Port_Configuration;
   begin
      Enable_Clock (Encoder_Tach1);
      Enable_Clock (Encoder_Tach2);

      Enable_Clock (Encoder_Timer);

      Configuration.Mode        := Mode_AF;
      Configuration.Output_Type := Push_Pull;
      Configuration.Resistors   := Pull_Up;
      Configuration.Speed       := Speed_100MHz;

      Configure_IO (Encoder_Tach1, Configuration);
      Configure_Alternate_Function (Encoder_Tach1, Encoder_AF);

      Configure_IO (Encoder_Tach2, Configuration);
      Configure_Alternate_Function (Encoder_Tach2, Encoder_AF);

      Configure_Encoder_Interface
        (Encoder_Timer,
         Mode         => Encoder_Mode_TI1_TI2,
         IC1_Polarity => Rising,
         IC2_Polarity => Rising);

      Configure
        (Encoder_Timer,
         Prescaler     => 0,
         Period        => UInt32 (UInt16'Last),
         Clock_Divisor => Div1,
         Counter_Mode  => Up);

      Configure_Channel_Input
        (Encoder_Timer,
         Channel   => Channel_1,
         Polarity  => Rising,
         Selection => Direct_TI,
         Prescaler => Div1,
         Filter    => 0);

      Configure_Channel_Input
        (Encoder_Timer,
         Channel   => Channel_2,
         Polarity  => Rising,
         Selection => Direct_TI,
         Prescaler => Div1,
         Filter    => 0);

      Enable_Channel (Encoder_Timer, Channel_1);
      Enable_Channel (Encoder_Timer, Channel_2);

      Set_Counter (Encoder_Timer, UInt16'(0));

      Enable (Encoder_Timer);

      Init_Done := True;
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean
   is (Init_Done);

   -----------------------
   -- Current_Direction --
   -----------------------

   function Current_Direction return Direction is
   begin
      case Current_Counter_Mode (Encoder_Timer) is
         when Up     => return Forward;
         when Down   => return Backward;
         when others => raise Program_Error;
      end case;
   end Current_Direction;

   -------------------
   -- Encoder_Count --
   -------------------

   function Encoder_Count return UInt32 is
   begin
      return Current_Counter (Encoder_Timer);
   end Encoder_Count;

end Board.Motor_Encoder;
