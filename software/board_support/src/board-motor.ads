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
private with STM32.PWM;
private with STM32.Device;

package Board.Motor is

   type Direction is (Forward, Backward);
   subtype Throttle is Float range 0.0 .. 100.0;

   procedure Initialize
     with Post => Initialized and then not Enabled;
   --  Initialize hardware for motor control

   function Initialized return Boolean;
   --  Return True if the hardware is initialized and motor control ready to
   --  use.

   function Enabled return Boolean
     with Pre => Initialized;
   --  Return True if the motor is enabled

   procedure Enable
     with Pre => Initialized;
   --  Enable the motor. This doesn't mean that the motor will start, e.g. when
   --  the throttle is at zero.

   procedure Disable
     with Pre => Initialized;
   --  Disable the motor. This coresponds to the standby mode on the motor
   --  driver chip.

   procedure Set_Direction (Dir : Direction)
     with Pre => Initialized;
   --  Set direction of the motor Forwards means that the motor will make the
   --  car move forward.

   procedure Set_Throttle (Throt : Throttle)
     with Pre => Initialized;
   --  Set throttle value

private
   In1_Pin     : STM32.GPIO.GPIO_Point         renames STM32.Device.PB4;
   In2_Pin     : STM32.GPIO.GPIO_Point         renames STM32.Device.PB8;

   Standby_Pin : STM32.GPIO.GPIO_Point         renames STM32.Device.PB5;
   --  Standby is active low

   PWM_1_Pin   : STM32.GPIO.GPIO_Point         renames STM32.Device.PA2;
   PWM_2_Pin   : STM32.GPIO.GPIO_Point         renames STM32.Device.PA3;
   PWM_Pin_AF  : STM32.GPIO_Alternate_Function renames STM32.Device.GPIO_AF_TIM9_3;

   PWM_Timer      : STM32.Timers.Timer         renames STM32.Device.Timer_9;
   PWM_1_Channel  : STM32.Timers.Timer_Channel      := STM32.Timers.Channel_1;
   PWM_2_Channel  : STM32.Timers.Timer_Channel      := STM32.Timers.Channel_2;
   PWM_Frequency  : constant                        := 25_000; -- Hertz
   Modulator_1    : STM32.PWM.PWM_Modulator;
   Modulator_2    : STM32.PWM.PWM_Modulator;
end Board.Motor;
