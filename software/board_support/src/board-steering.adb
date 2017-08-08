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

with STM32.PWM;    use STM32.PWM;
with HAL;          use HAL;

package body Board.Steering is

   Init_Done : Boolean := False;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      --  Check if already initialized
      if Initialized then
         return;
      end if;

      Configure_PWM_Timer (PWM_Timer'Access, PWM_Frequency);

      Modulator.Attach_PWM_Channel
        (PWM_Timer'Access,
         PWM_Channel,
         PWM_Pin,
         PWM_Pin_AF);

      Init_Done := True;

      --  Initial state
      Disable;
      Set_Steering (0.0);
   end Initialize;

   -----------------
   -- Initialized --
   -----------------

   function Initialized return Boolean
   is (Init_Done);

   -------------
   -- Enabled --
   -------------

   function Enabled return Boolean
   is (Modulator.Output_Enabled);

   ------------
   -- Enable --
   ------------

   procedure Enable is
   begin
      Modulator.Enable_Output;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable is
   begin
      Modulator.Disable_Output;
   end Disable;

   ------------------
   -- Set_Steering --
   ------------------

   procedure Set_Steering (Value : Steering_Value) is
      Ms : constant Float := Center_Pulse_MS +
        (Float (Value) / 100.0) * Range_Pulse_MS / 2.0;
   begin
      Modulator.Set_Duty_Time (Microseconds (Ms * 1000.0));
   end Set_Steering;
end Board.Steering;
