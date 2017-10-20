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
with STM32.Timers; use STM32.Timers;
with STM32.PWM;    use STM32.PWM;
with STM32.Device; use STM32.Device;

package body Board.Motor is

   Init_Done   : Boolean := False;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      IO_Conf : GPIO_Port_Configuration;
   begin
      --  Check if already initialized
      if Initialized then
         return;
      end if;

      --  GPIOs  --
      Enable_Clock (In1_Pin);
      Enable_Clock (In2_Pin);
      Enable_Clock (Standby_Pin);
      Enable_Clock (PWM_1_Pin);
      Enable_Clock (PWM_2_Pin);

      IO_Conf.Mode        := Mode_Out;
      IO_Conf.Output_Type := Push_Pull;
      IO_Conf.Speed       := Speed_Low;
      IO_Conf.Resistors   := Floating;

      In1_Pin.Configure_IO (IO_Conf);
      In1_Pin.Set;
      In2_Pin.Configure_IO (IO_Conf);
      In2_Pin.Set;

      Standby_Pin.Configure_IO (IO_Conf);
      Standby_Pin.Clear;

      --  Timer  --
      Configure_PWM_Timer (PWM_Timer'Access, PWM_Frequency);

      Modulator_1.Attach_PWM_Channel
        (PWM_Timer'Access,
         PWM_1_Channel,
         PWM_1_Pin,
         PWM_Pin_AF);

      Modulator_2.Attach_PWM_Channel
        (PWM_Timer'Access,
         PWM_2_Channel,
         PWM_2_Pin,
         PWM_Pin_AF);

      Modulator_1.Enable_Output;
      Modulator_2.Enable_Output;

      Init_Done := True;

      --  Initial state
      Disable;
      Set_Throttle (0.0);
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
   is (Standby_Pin.Set);

   ------------
   -- Enable --
   ------------

   procedure Enable is
   begin
      Standby_Pin.Set;
   end Enable;

   -------------
   -- Disable --
   -------------

   procedure Disable is
   begin
      Standby_Pin.Clear;
   end Disable;

   ------------------
   -- Set_Throttle --
   ------------------

   procedure Set_Throttle (Throt : Throttle) is
   begin
      if Throt >= 0.0 then
         --  Forward
         In2_Pin.Set;
         In1_Pin.Clear;
      else
         --  Backward
         In2_Pin.Clear;
         In1_Pin.Set;
      end if;

      Modulator_1.Set_Duty_Cycle (Percentage (abs Throt));
      Modulator_2.Set_Duty_Cycle (Percentage (abs Throt));
   end Set_Throttle;

end Board.Motor;
