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

private with STM32.GPIO;
private with STM32.Timers;
private with STM32.Device;
with HAL;

package Board.Motor_Encoder is

   procedure Initialize
     with Post => Initialized;
   --  Initialize hardware for motor encoder

   function Initialized return Boolean;
   --  Return True if the hardware is initialized and motor encoder ready to
   --  use.

   function Encoder_Count return HAL.UInt32
     with Pre => Initialized;

   type Direction is (Forward, Backward);

   function Current_Direction return Direction
     with Pre => Initialized;

private

   Encoder_Tach1 : constant STM32.GPIO.GPIO_Point := STM32.Device.PE9;
   Encoder_Tach2 : constant STM32.GPIO.GPIO_Point := STM32.Device.PE11;

   Encoder_Timer : STM32.Timers.Timer renames STM32.Device.Timer_1;

   Encoder_AF : constant STM32.GPIO_Alternate_Function := STM32.Device.GPIO_AF_TIM1_1;

end Board.Motor_Encoder;
