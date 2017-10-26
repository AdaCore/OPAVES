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

with Ada.Real_Time;            use Ada.Real_Time;

with CRTP;                     use CRTP;
with Databases;                use Databases;
with Databases.Instantiations; use Databases.Instantiations;
with HAL;                      use HAL;
with Types;                    use Types;

package body OPAVES.Commander is

   MIN_CRTP_ROLL : constant := -20.0;
   MAX_CRTP_ROLL : constant := 20.0;

   MIN_CRTP_THRUST : constant := -52_000.0;
   MAX_CRTP_THRUST : constant := 52_000.0;

   MAX_INACTIVITY_PERIOD : constant Time_Span := Milliseconds (500);
   Last_Update           : Time;

   Float_DB : constant Float_Databases.Database_Access :=
                       Float_Databases.Get_Database_Instance;

   Throttle_Data_ID : Data_ID_Type;
   Steering_Data_ID : Data_ID_Type;

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

   function Get_Inactivity_Time return Time_Span;
   --  Get the inactivity time between the last time we received commands and
   --  the current time.

   procedure Watchdog;
   --  Used to reset the commands when we did not receive any commands during
   --  a certain time.

   procedure Watchdog_Reset;
   --  Reset the watchdog.

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
      Last_Update := Clock;

      Throttle_Data_ID := Float_DB.Register (Data_Name => Create ("THROTTLE"));
      Steering_Data_ID := Float_DB.Register (Data_Name => Create ("STEERING"));

      CRTP_Register_Callback
        (CRTP_PORT_COMMANDER, Commander_CRTP_Handler'Access);
   end Initialize;

   --------------------------
   -- Get_Throttle_Command --
   --------------------------

   function Get_Throttle_Command return Throttle is
      Throt_F : constant Float :=
                  Float_DB.all.Get (Data_ID => Throttle_Data_ID);
   begin
      Watchdog;

      return Throttle (Throt_F);
   end Get_Throttle_Command;

   --------------------------
   -- Get_Steering_Command --
   --------------------------

   function Get_Steering_Command return Steering_Value is
      Steering_F : constant Float :=
                     Float_DB.all.Get (Data_ID => Steering_Data_ID);
   begin
      return Steering_Value (Steering_F);
   end Get_Steering_Command;

   -------------------------
   -- Get_Inactivity_Time --
   -------------------------

   function Get_Inactivity_Time return Time_Span
   is
      Current_Time : constant Time := Clock;
   begin
      return Current_Time - Last_Update;
   end Get_Inactivity_Time;

   --------------
   -- Watchdog --
   --------------

   procedure Watchdog is
      Time_Since_Last_Update : Time_Span;
   begin
      Time_Since_Last_Update := Get_Inactivity_Time;

      if Time_Since_Last_Update > MAX_INACTIVITY_PERIOD then
         CRTP_Set_Is_Connected (False);

         Float_DB.Set
           (Data_ID => Throttle_Data_ID,
            Data    => 0.0);
         Float_DB.Set
           (Data_ID => Steering_Data_ID,
            Data    => 0.0);
      end if;
   end Watchdog;

   --------------------
   -- Watchdog_Reset --
   --------------------

   procedure Watchdog_Reset is
   begin
      CRTP_Set_Is_Connected (True);

      Last_Update := Clock;
   end Watchdog_Reset;

   ----------------------
   -- Convert_Commands --
   ----------------------

   function Convert_Commands
     (CRTP_Commands : CRTP_Commands_Type) return OPAVES_Commands_Type
   is
      OPAVES_Commands : OPAVES_Commands_Type;

      --  Invert the pitch to get the throttle direction (backward or forward)
      Throtlle_Dir    : constant Throttle :=
                          (if CRTP_Commands.Pitch < 0.001 then -1.0 else 1.0);
   begin
      --  We should invert the roll received from CRTP
      OPAVES_Commands.Steering := Get_Mapped_Value
        (Input      => -CRTP_Commands.Roll,
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

      OPAVES_Commands := Convert_Commands (CRTP_Commands);

      Float_DB.Set
        (Data_ID => Throttle_Data_ID,
         Data    => OPAVES_Commands.Throt);
      Float_DB.Set
        (Data_ID => Steering_Data_ID,
         Data    => OPAVES_Commands.Steering);

      Watchdog_Reset;
   end Commander_CRTP_Handler;

end OPAVES.Commander;
