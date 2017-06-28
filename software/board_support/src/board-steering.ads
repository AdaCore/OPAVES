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

package Board.Steering is

   subtype Steering_Value is Float range -1.0 .. 1.0;

   procedure Initialize
     with Post => Initialized and then not Enabled;
   --  Initialize hardware for steering control

   function Initialized return Boolean;
   --  Return True if the hardware is initialized and steering ready to use.

   function Enabled return Boolean
     with Pre => Initialized;
   --  Return True if steering is enabled

   procedure Enable
     with Pre  => Initialized,
          Post => Enabled;

   procedure Disable
     with Pre  => Initialized,
          Post => not Enabled;

   procedure Set_Steering (Value : Steering_Value)
     with Pre => Initialized;
private

   PWM_Pin     : STM32.GPIO.GPIO_Point         renames STM32.Device.PB5;
   PWM_Pin_AF  : STM32.GPIO_Alternate_Function renames STM32.Device.GPIO_AF_TIM3_2;

   PWM_Timer   : STM32.Timers.Timer            renames STM32.Device.Timer_3;
   PWM_Channel : STM32.Timers.Timer_Channel         := STM32.Timers.Channel_2;
   PWM_Period  : constant                           := 1000;

   PWM_Frequency : constant := 20; -- Hertz
   Modulator     : STM32.PWM.PWM_Modulator;

   Min_Pulse_MS : constant := 1.0;
   --  Minimum uptime for the PWM pulse. Corresponds to servo's maximum
   --  counter-clockwise movement.
   Max_Pulse_Ms : constant := 2.0;
   --  Maximum uptime for the PWM pulse. Corresponds to servo's maximum
   --  clockwise movement.

   Range_Pulse_MS : constant := Max_Pulse_Ms - Min_Pulse_MS;
   --  Difference between the max and min PWM pulse

   Center_Pulse_MS : constant := Min_Pulse_MS + Range_Pulse_MS / 2.0;
   --  PWM uptime to set the servo in its center posistion

end Board.Steering;
