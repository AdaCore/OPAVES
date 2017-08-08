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

with STM32.GPIO;                 use STM32.GPIO;
with STM32.Device;               use STM32.Device;
with STM32.USARTs;               use STM32.USARTs;
with HAL;                        use HAL;
with Logging_With_Priority;

package body Board.Comm is

   package Log_Prio is new Logging_With_Priority
     (Priorities                 => Message_Priority,
      Maximum_Message_Length     => Max_Message_Lenght,
      Maximum_Number_Of_Messages => Message_Queue_Length);

   procedure Initialize;

   type Message is record
      Prio : Message_Priority;
      Data : String (1 .. Max_Message_Lenght);
      Len  : Natural;
   end record;

   type Message_Access is access all Message;

   type Error_Conditions is new UInt8;

   No_Error_Detected      : constant Error_Conditions := 2#0000_0000#;
   Parity_Error_Detected  : constant Error_Conditions := 2#0000_0001#;
   Noise_Error_Detected   : constant Error_Conditions := 2#0000_0010#;
   Frame_Error_Detected   : constant Error_Conditions := 2#0000_0100#;
   Overrun_Error_Detected : constant Error_Conditions := 2#0000_1000#;

   protected Controller is

      pragma Interrupt_Priority;

      procedure Send (Str : String; Prio : Message_Priority);

      function Errors_Detected return Error_Conditions
        with Unreferenced;


      procedure Start_Receiving (Msg : not null Message_Access)
        with Unreferenced;

   private

      procedure Handle_Transmission with Inline;

      procedure Handle_Reception with Inline;

      procedure Detect_Errors with Inline;

      procedure Start_Sending;

      Next_Out          : Positive;
      Outgoing_Msg      : String (1 .. Max_Message_Lenght);
      Outgoing_Msg_Len  : Natural := 0;

      Next_In           : Positive;
      Incoming_Msg      : Message_Access;

      Errors            : Error_Conditions := No_Error_Detected;

      procedure IRQ_Handler;
      pragma Attach_Handler (IRQ_Handler, Transceiver_Interrupt_Id);

   end Controller;

   procedure Initialize is
      Configuration : GPIO_Port_Configuration;
   begin

      Enable_Clock (Device);
      Enable_Clock (RX_Pin & TX_Pin);

      Configuration.Mode := Mode_AF;
      Configuration.Speed := Speed_50MHz;
      Configuration.Output_Type := Push_Pull;
      Configuration.Resistors := Pull_Up;

      Configure_IO (RX_Pin & TX_Pin, Config => Configuration);

      Configure_Alternate_Function (RX_Pin & TX_Pin,  AF => Transceiver_AF);
      Disable (Device);

      Set_Baud_Rate    (Device, Baud_Rate);
      Set_Mode         (Device, Tx_Rx_Mode);
      Set_Stop_Bits    (Device, Stopbits_1);
      Set_Word_Length  (Device, Word_Length_8);
      Set_Parity       (Device, No_Parity);
      Set_Flow_Control (Device, No_Flow_Control);

      Enable (Device);
   end Initialize;

   ----------------
   -- Controller --
   ----------------

   protected body Controller is

      ----------
      -- Send --
      ----------

      procedure Send (Str : String; Prio : Message_Priority) is
      begin
         Log_Prio.Log_Line (Str, Prio);
         Start_Sending;
      end Send;
      ---------------------
      -- Errors_Detected --
      ---------------------

      function Errors_Detected return Error_Conditions is
      begin
         return Errors;
      end Errors_Detected;

      -------------------
      -- Detect_Errors --
      -------------------

      procedure Detect_Errors is
      begin
         --  check for parity error
         if Status (Device, Parity_Error_Indicated) and
           Interrupt_Enabled (Device, Parity_Error)
         then
            Clear_Status (Device, Parity_Error_Indicated);
            Errors := Errors or Parity_Error_Detected;
         end if;

         --  check for framing error
         if Status (Device, Framing_Error_Indicated) and
           Interrupt_Enabled (Device, Error)
         then
            Clear_Status (Device, Framing_Error_Indicated);
            Errors := Errors or Frame_Error_Detected;
         end if;

         --  check for noise error
         if Status (Device, USART_Noise_Error_Indicated) and
           Interrupt_Enabled (Device, Error)
         then
            Clear_Status (Device, USART_Noise_Error_Indicated);
            Errors := Errors or Noise_Error_Detected;
         end if;

         --  check for overrun error
         if Status (Device, Overrun_Error_Indicated) and
           Interrupt_Enabled (Device, Error)
         then
            Clear_Status (Device, Overrun_Error_Indicated);
            Errors := Errors or Overrun_Error_Detected;
         end if;
      end Detect_Errors;

      -------------------------
      -- Handle_Transmission --
      -------------------------

      procedure Handle_Transmission is
         Prio : Message_Priority;
      begin
         if Outgoing_Msg_Len /= 0 then
            Transmit (Device, Character'Pos (Outgoing_Msg (Next_Out)));
            Next_Out := Next_Out + 1;

            --  Check if we finished to transmit the current message
            if Next_Out > Outgoing_Msg_Len then

               --  Try to get the next message
               Log_Prio.Pop (Outgoing_Msg, Outgoing_Msg_Len, Prio);
               if Outgoing_Msg_Len = 0 then

                  --  There's no more messages to transmit
                  Disable_Interrupts (Device, Source => Transmit_Data_Register_Empty);
               else
                  Next_Out := Outgoing_Msg'First;
               end if;
            end if;
         end if;
      end Handle_Transmission;

      ----------------------
      -- Handle_Reception --
      ----------------------

      procedure Handle_Reception is
         Received_Char : constant Character := Character'Val (Current_Input (Device));
         pragma Unreferenced (Received_Char);
      begin
--           Incoming_Msg.Content (Next_In) := Received_Char;
--           if Received_Char = Incoming_Msg.Terminator or
--              Next_In = Incoming_Msg.Physical_Size
--           then --  reception complete
--              Incoming_Msg.Logical_Size := Next_In;
--              loop
--                 exit when not Status (Device, Read_Data_Register_Not_Empty);
--              end loop;
--              Disable_Interrupts (Device, Source => Received_Data_Not_Empty);
--              Set_True (Incoming_Msg.Reception_Complete);
--           else
--              Next_In := Next_In + 1;
--           end if;
         null;
      end Handle_Reception;

      -----------------
      -- IRQ_Handler --
      -----------------

      procedure IRQ_Handler is
      begin
         Detect_Errors;

         --  check for data arrival
         if Status (Device, Read_Data_Register_Not_Empty) and
           Interrupt_Enabled (Device, Received_Data_Not_Empty)
         then
            Handle_Reception;
            Clear_Status (Device, Read_Data_Register_Not_Empty);
         end if;

         --  check for transmission ready
         if Status (Device, Transmit_Data_Register_Empty) and
           Interrupt_Enabled (Device, Transmit_Data_Register_Empty)
         then
            Handle_Transmission;
            Clear_Status (Device, Transmit_Data_Register_Empty);
         end if;
      end IRQ_Handler;

      -------------------
      -- Start_Sending --
      -------------------

      procedure Start_Sending is
         Prio : Message_Priority;
      begin
         if Outgoing_Msg_Len /= 0 then
            --  We already started to transmit
            return;
         end if;

         Log_Prio.Pop (Outgoing_Msg, Outgoing_Msg_Len, Prio);

         if Outgoing_Msg_Len = 0 then
            --  There's nothing to transmit
            return;
         end if;

         Next_Out := Outgoing_Msg'First;

         Enable_Interrupts (Device, Source => Parity_Error);
         Enable_Interrupts (Device, Source => Error);
         Enable_Interrupts (Device, Source => Transmit_Data_Register_Empty);
      end Start_Sending;

      ---------------------
      -- Start_Receiving --
      ---------------------

      procedure Start_Receiving (Msg : not null Message_Access) is
      begin
         Incoming_Msg := Msg;
         Next_In := Incoming_Msg.Data'First;

         Enable_Interrupts (Device, Source => Parity_Error);
         Enable_Interrupts (Device, Source => Error);
         Enable_Interrupts (Device, Source => Received_Data_Not_Empty);
      end Start_Receiving;

   end Controller;

   ----------
   -- Send --
   ----------

   procedure Send (Str : String; Prio : Message_Priority) is
   begin
      Controller.Send (Str & ASCII.CR & ASCII.LF, Prio);
   end Send;

   procedure Receive (Str : out String) is
   begin
      if Str'Length = 0 then
         return;
      else
         Str := "";
      end if;
   end Receive;

begin
   Initialize;
end Board.Comm;
