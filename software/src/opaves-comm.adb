with Board.Comm; use Board.Comm;
with STM32.USARTs; use STM32.USARTs;
with HAL; use HAL;
with Ada.Unchecked_Conversion;

package body OPAVES.Comm is
   type State_Type is
     (
      State_Start,
      --  Wait for start.

      State_Data,
      --  Wait for data to be added.

      State_Escape,
      --  Next character is escaped

      State_End
      --  Wait end
     );

   Pkt_Start : constant := 16#7d#;
   --  Start of packet

   Pkt_End   : constant := 16#7e#;
   --  End of packet

   Pkt_Esc   : constant := 16#7f#;
   --  Next byte is escaped

   Pkt_Xor   : constant := 16#80#;
   --  Escape value (xor with value)

   subtype Pkt_Invalid is UInt8 range Pkt_Start .. Pkt_Esc;

   Cmd_Ping : constant := 2;
   Rep_Ping : constant := 3;

   procedure Write (C : Character);

   procedure Write (C : Character) is
   begin
      while not Status (Comm_UART, Transmit_Data_Register_Empty) loop
         null;
      end loop;

      Transmit (Comm_UART, Character'Pos (C));
   end Write;

   procedure Write (S : String) is
   begin
      for I in S'Range loop
         Write (S (I));
      end loop;
      Write (ASCII.CR);
   end Write;

   protected Prot is
      pragma Interrupt_Priority;

      procedure Handler;
      pragma Attach_Handler (Handler, Comm_UART_Interrupt_Id);
   private
      Rx_Buf : UInt8_Array (1 .. 128);
      Rx_Len : Natural;
      Rx_Pkt_Len : Natural;
      Rx_State : State_Type := State_Start;

      Tx_Buf : UInt8_Array (1 .. 128);
      Tx_Len : Natural;
      Tx_Off : Natural; --  Next byte to send
      Tx_State : State_Type;
   end Prot;

   pragma Unreferenced (Prot);

   protected body Prot is
      procedure Send (B : UInt8) is
      begin
         Transmit (Comm_UART, UInt9 (B));
      end Send;

      procedure Start_Tx is
      begin
         Tx_Off := 1;
         Tx_State := State_Start;
         Send (Pkt_Start);
         Enable_Interrupts (Comm_UART, Transmit_Data_Register_Empty);
      end Start_Tx;

      procedure Send is
      begin
         case Tx_State is
            when State_Start | State_Data =>
               if Tx_Buf (Tx_Off) in Pkt_Invalid then
                  Send (Pkt_Esc);
                  Tx_State := State_Escape;
               else
                  Send (Tx_Buf (Tx_Off));
                  if Tx_Off = Tx_Len then
                     Tx_State := State_End;
                  else
                     Tx_Off := Tx_Off + 1;
                     Tx_State := State_Data;
                  end if;
               end if;
            when State_Escape =>
               Send (Tx_Buf (Tx_Off) xor Pkt_Esc);
               if Tx_Off = Tx_Len then
                  Tx_State := State_End;
               else
                  Tx_Off := Tx_Off + 1;
               end if;
            when State_End =>
               if Tx_Off = 0 then
                  Disable_Interrupts (Comm_UART, Transmit_Data_Register_Empty);
               else
                  Send (Pkt_End);
                  Tx_Off := 0;
               end if;
         end case;
      end Send;

      procedure Do_Ping is
      begin
         Tx_Buf (1) := Rx_Buf (1);
         Tx_Buf (2) := Rep_Ping;
         for I in 3 .. Rx_Pkt_Len loop
            Tx_Buf (I) := Rx_Buf (I) + 1;
         end loop;
         Tx_Len := Rx_Pkt_Len;
         Start_Tx;
      end Do_Ping;

      procedure Receive_Packet is
      begin
         --  Got a full packet, decode it and reply.
         case Rx_Buf (2) is
            when Cmd_Ping =>
               Do_Ping;
            when others =>
               --  Ignore invalid packet
               null;
         end case;
      end Receive_Packet;

      procedure Receive (C : UInt8) is
      begin
         case Rx_State is
            when State_Start =>
               if C = Pkt_Start then
                  Rx_Len := 0;
                  Rx_State := State_Data;
               end if;
            when State_Data | State_Escape =>
               if Rx_State = State_Data and then C = Pkt_Esc then
                  Rx_State := State_Escape;
               elsif C = Pkt_Start then
                  Rx_Len := 0;
                  Rx_State := State_Data;
               elsif C in Pkt_Invalid then
                  Rx_State := State_Start;
               else
                  if Rx_Len >= Rx_Buf'Last then
                     Rx_State := State_Start;
                  else
                     Rx_Len := Rx_Len + 1;
                     if Rx_State = State_Escape then
                        Rx_Buf (Rx_Len) := C xor Pkt_Xor;
                        Rx_State := State_Data;
                     else
                        Rx_Buf (Rx_Len) := C;
                     end if;
                     if Rx_Len = 1 then
                        Rx_Pkt_Len := Natural (Rx_Buf (Rx_Len));
                     elsif Rx_Len = Rx_Pkt_Len then
                        rx_State := State_End;
                     end if;
                  end if;
               end if;
            when State_End =>
               if C = Pkt_End then
                  Receive_Packet;
               end if;
               rx_State := State_Start;
         end case;
      end Receive;

      procedure Handler is
      begin
         if Status (Comm_UART, Read_Data_Register_Not_Empty) then
            declare
               C : constant UInt8 := UInt8 (Current_Input (Comm_UART));
            begin
               Clear_Status (Comm_UART, Read_Data_Register_Not_Empty);
               Receive (C);
            end;
         end if;
         if Status (Comm_UART, Transmit_Data_Register_Empty)
           and then Interrupt_Enabled (Comm_UART, Transmit_Data_Register_Empty)
         then
            --  A character has been sent. Ack interrupt.
            Clear_Status (Comm_UART, Transmit_Data_Register_Empty);
            Send;
         end if;
      end Handler;
   end Prot;
end OPAVES.Comm;
