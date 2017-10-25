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

with CRTP; use CRTP;
with HAL;  use HAL;
with Board.Logging; use Board.Logging;
with Board.Steering; use Board.Steering;
with Board.Motor; use Board.Motor;
with LEDS; use LEDS;
with Types; use Types;

package body OPAVES.Commander is

   MIN_CRTP_ROLL : constant := -20.0;
   MAX_CRTP_ROLL : constant := 20.0;

   MIN_CRTP_THRUST : constant := -52_000.0;
   MAX_CRTP_THRUST : constant := 52_000.0;

   type CRTP_Commands_Type is record
      Roll   : T_Degrees;
      Pitch  : T_Degrees;
      Thrust : UInt16;
   end record;

   type OPAVES_Commands_Type is record
      Steering : Steering_Value;
      Throt    : Throttle;
   end record;

   procedure Commander_CRTP_Handler (Packet : CRTP_Packet);
   --  The handler called each time we receive a CRTP packet related to
   --  commands.

   procedure CRTP_Get_Float_Data is new CRTP_Get_Data (Float);
   --  Get Float data from a CRTP Packet.

   procedure CRTP_Get_UInt16_Data is new CRTP_Get_Data (UInt16);
   --  Get UInt16 data from a CRTP Packet.

   function Convert_Commands
     (CRTP_Commands : CRTP_Commands_Type) return OPAVES_Commands_Type;
   --  Convert the CRTP commands to OPAVES commands

   function Get_Mapped_Value
     (Input      : Float;
      Input_Min  : Float;
      Input_Max  : Float;
      Output_Min : Float;
      Output_Max : Float) return Float;
   --  Map Input from the range Input_Min .. Input_Max to the range
   --  Output_Min .. Output_Max.

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      CRTP_Register_Callback
        (CRTP_PORT_COMMANDER, Commander_CRTP_Handler'Access);
   end Initialize;

   ----------------------
   -- Convert_Commands --
   ----------------------

   function Convert_Commands
     (CRTP_Commands : CRTP_Commands_Type) return OPAVES_Commands_Type
   is
      OPAVES_Commands : OPAVES_Commands_Type;

      --  Invert the pitch to get the throttle direction (backward or forward)
      Throtlle_Dir    : constant Throttle :=
                          (if CRTP_Commands.Pitch < 0.0 then 1.0 else -1.0);
   begin
      OPAVES_Commands.Steering := Get_Mapped_Value
        (Input      => CRTP_Commands.Roll,
         Input_Min  => MIN_CRTP_ROLL,
         Input_Max  => MAX_CRTP_ROLL,
         Output_Min => Steering_Value'First,
         Output_Max => Steering_Value'Last);

      OPAVES_Commands.Throt := Get_Mapped_Value
        (Input      => Float (CRTP_Commands.Thrust) * Throtlle_Dir,
         Input_Min  => MIN_CRTP_THRUST,
         Input_Max  => MAX_CRTP_THRUST,
         Output_Min => Throttle'First,
         Output_Max => Throttle'Last);

      return OPAVES_Commands;
   end Convert_Commands;

   ----------------------
   -- Get_Mapped_Value --
   ----------------------

   function Get_Mapped_Value
     (Input      : Float;
      Input_Min  : Float;
      Input_Max  : Float;
      Output_Min : Float;
      Output_Max : Float) return Float
   is
      Input_Range  : constant Float := Input_Max - Input_Min;
      Output_Range : constant Float := Output_Max - Output_Min;
      Output       : Float;
   begin
      if Input_Range = 0.0 then
         Output := Output_Min;
      else
         Output :=
           (Input - Input_Min) * Output_Range / Input_Range + Output_Min;
      end if;

      return Output;
   end Get_Mapped_Value;

   ----------------------------
   -- Commander_CRTP_Handler --
   ----------------------------

   procedure Commander_CRTP_Handler (Packet : CRTP_Packet) is
      CRTP_Commands   : CRTP_Commands_Type := (Thrust => 0, others => 0.0);
      Handler         : CRTP_Packet_Handler;
      Has_Succeed     : Boolean;
      OPAVES_Commands : OPAVES_Commands_Type;
   begin
      Handler := CRTP_Get_Handler_From_Packet (Packet);

      CRTP_Get_Float_Data (Handler, 1, CRTP_Commands.Roll, Has_Succeed);
      CRTP_Get_Float_Data (Handler, 5, CRTP_Commands.Pitch, Has_Succeed);
      CRTP_Get_UInt16_Data (Handler, 13, CRTP_Commands.Thrust, Has_Succeed);

      Log_Line ("Thrust = " & CRTP_Commands.Thrust'Img);
      Log_Line ("Pitch = " & CRTP_Commands.Pitch'Img);
      Log_Line ("Roll = " & CRTP_Commands.Roll'Img);

      OPAVES_Commands := Convert_Commands (CRTP_Commands);

      Log_Line ("Throt = " & OPAVES_Commands.Throt'Img);
      Log_Line ("Steering = " & OPAVES_Commands.Steering'Img);
      Log_Line ("");

      Board.Motor.Set_Throttle (OPAVES_Commands.Throt);
      Board.Steering.Set_Steering (OPAVES_Commands.Steering);

      Toggle_LED (LEDS.LED_Green_L);
   end Commander_CRTP_Handler;

end OPAVES.Commander;
