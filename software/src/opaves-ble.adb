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

with Board.BLE; use Board.BLE;
with STM32.USARTs; use STM32.USARTs;
with HAL; use HAL;
with Ada.Unchecked_Conversion;
with Interfaces;
with Databases.Instantiations;
--  with OPAVES.Comm;

package body OPAVES.BLE is
   function Hex2Byte (C : Character) return UInt8;
   --   Convert a character (0-9, A-F) to its hexadecimal value.  Return
   --   Bad_Byte if the character is not valid.

   Bad_Byte : constant UInt8 := 16#FF#;
   --  Error result for Hex2Byte

   procedure To_Bytes (S : String; Arr : out UInt8_Array; Valid : out Boolean);
   --  Convert an hexadecimal string S to its value ARR

   procedure Setup_4871;
   --  Setup the BLE 4871 chip: set name and services

   type Rx_State_Type is (Data_Unsync, Data_Sync, Command);

   procedure Send (S : String);
   --  Send a string to the BLE. Blocking operation.

   Db_Int : Databases.Instantiations.Integer_Databases.Database_Access;

   Db_Speed_Id : Databases.Data_ID_Type;
   Db_Dir_Id : Databases.Data_ID_Type;
   --  Database identifiers

   protected Tx_Prot is
      pragma Interrupt_Priority;

      procedure Send (C : Character);
      --  Send one character on the UART

      entry Wait;
      --  Wait until the character is sent. Must be called after Send.

      procedure Tx_Interrupt;
      --  Called in case of interrupt
   private
      Ready : Boolean := False;
   end Tx_Prot;

   protected body Tx_Prot is
      procedure Tx_Interrupt is
      begin
         --  A character has been sent. Ack interrupt.
         Clear_Status (BLE_UART, Transmit_Data_Register_Empty);

         Disable_Interrupts (BLE_UART, Transmit_Data_Register_Empty);

         Ready := True;
      end Tx_Interrupt;

      procedure Send (C : Character) is
      begin
         pragma Assert (Ready = False);

         --  Start to transmit
         Transmit (BLE_UART, Character'Pos (C));
         Enable_Interrupts (BLE_UART, Transmit_Data_Register_Empty);
      end Send;

      entry Wait when Ready is
      begin
         Ready := False;
      end Wait;
   end Tx_Prot;

   protected Prot is
      pragma Interrupt_Priority;

      function Get_Speed return Speed_Msg_Type;

      procedure Handler;
      pragma Attach_Handler (Handler, BLE_UART_Interrupt_Id);

      procedure Set_Command_Mode;
      procedure Set_Data_Mode;
      --  Set internal mode for the receiver mechanism (but send nothing)

      entry Wait;
      --  Wait until a prompt was received

      procedure Read_Reply (S : out String; Len : out Natural);
   private
      Msg : String (1 .. 60);
      Len : Natural := 0;
      --  Input buffer

      Rx_State : Rx_State_Type := Data_Unsync;
      --  True if waiting for '%' (start of message)

      Wait_Flag : Boolean := False;
      --  Flag for barrier

      Speed : Speed_Msg_Type := (0, 0, Time_First);
      --  Result
   end Prot;

   function Hex2Byte (C : Character) return UInt8 is
   begin
      if C >= '0' and C <= '9' then
         return Character'Pos (C) - Character'Pos ('0');
      elsif C >= 'A' and C <= 'F' then
         return Character'Pos (C) - Character'Pos ('A') + 10;
      else
         return Bad_Byte;
      end if;
   end Hex2Byte;

   procedure To_Bytes (S : String; Arr : out UInt8_Array; Valid : out Boolean)
   is
      P : Natural;
      R : Natural;
      L, H : UInt8;
   begin
      Valid := False;
      P := S'First;
      R := Arr'First;

      --  Convert byte per byte
      while P + 1 <= S'Last loop
         H := Hex2Byte (S (P + 0));
         L := Hex2Byte (S (P + 1));
         if H = Bad_Byte or L = Bad_Byte then
            return;
         end if;
         Arr (R) := H * 16 + L;
         R := R + 1;
         P := P + 2;
      end loop;

      --  Check matching length
      if P = S'Last + 1 and R = Arr'Last + 1 then
         Valid := True;
      end if;
   end To_Bytes;

   protected body Prot is
      procedure Handle_Packet is
         use Interfaces;

         --  Packet like: WV,0072,300000000000000080000000000000
         --  uint8_t header;  (0x30)  [1]
         --  float roll;              [2 - 5]
         --  float pitch;             [6 - 9]
         --  float yaw;               [10 - 13]
         --  uint16_t thrust;         [14 - 15]

         subtype Uint8_Array_4 is UInt8_Array (1 .. 4);
         function To_Float32 is new Ada.Unchecked_Conversion
           (Uint8_Array_4, IEEE_Float_32);
         Res : UInt8_Array (1 .. 15);
         Yaw : IEEE_Float_32;
         Ok : Boolean;

         Speed_Int : Natural;
         Dir_Int : Integer;
      begin
         if Len /= 38 then
            return;
         end if;
         To_Bytes (Msg (9 .. 38), Res, Ok);
         if not Ok then
            return;
         end if;
         if Res (1) /= 16#30# then
            return;
         end if;

         --  Assuming same endianness (LE)
         Yaw := To_Float32 (Res (10 .. 13));
         if not Yaw'Valid or else Yaw not in -100.0 .. 100.0 then
            return;
         end if;

--         OPAVES.Comm.Write (IEEE_Float_32'Image (Yaw));

         Speed_Int := Natural (Res (15)) * 256 + Natural (Res (14));
         Dir_Int := Integer (Yaw);

         Speed := (Speed => Speed_Int, Dir => Dir_Int, Timestamp => Clock);

         --  Write to the database
         Db_Int.Set (Db_Dir_Id, Dir_Int);
         Db_Int.Set (Db_Speed_Id, Speed_Int);
      end Handle_Packet;

      procedure Handle_Message is
      begin
         if Len > 7 and then Msg (1 .. 7) = "CONNECT" then
            --  Connected
            null;
         elsif Len > 3 and then Msg (1 .. 3) = "WC," then
            --  Start/end notification request
            null;
         elsif Len > 3 and then Msg (1 .. 3) = "WV," then
            --  Write request
            Handle_Packet;
         elsif Len > 10 and then Msg (1 .. 10) = "DISCONNECT" then
            --  Connected
            null;
         else
            null;
         end if;
      end Handle_Message;

      entry Wait when Wait_Flag is
      begin
         Wait_Flag := False;
      end Wait;

      procedure Read_Reply (S : out String; Len : out Natural) is
      begin
         Len := Prot.Len;
         if Len > S'Length then
            S := Msg (Msg'First .. Msg'First + S'Length - 1);
         else
            S (S'First .. S'First + Len - 1) :=
              Msg (Msg'First .. Msg'First + Len - 1);
         end if;
         Prot.Len := 0;
      end Read_Reply;

      procedure Set_Command_Mode is
      begin
         Len := 0;
         Rx_State := Command;
         Wait_Flag := False;
      end Set_Command_Mode;

      procedure Set_Data_Mode is
      begin
         Len := 0;
         Rx_State := Data_Unsync;
         Wait_Flag := False;
      end Set_Data_Mode;

      procedure Rx_Add (C : Character) is
      begin
         --  Add to buffer
         Len := Len + 1;
         if Len < Msg'Last then
            Msg (Len) := C;
         end if;
      end Rx_Add;

      procedure Receive (C : Character) is
      begin
         case Rx_State is
            when Data_Unsync =>
               if C = '%' then
                  --  Start of message
                  Len := 0;
                  Rx_State := Data_Sync;
               else
                  --  Discard character
                  null;
               end if;
            when Data_Sync =>
               if C = '%' then
                  if Len = 0 then
                     --  Two in a raw, that's a real start
                     null;
                  else
                     --  End of message
                     Handle_Message;
                     Rx_State := Data_Unsync;
                  end if;
               else
                  Rx_Add (C);
               end if;
            when Command =>
               Rx_Add (C);
               if C = '>' and then Len > 3
                 and then Msg (Len - 3 .. Len - 1) = "CMD"
               then
                  Wait_Flag := True;
               end if;
         end case;
      end Receive;

      procedure Handler is
      begin
         if Status (BLE_UART, Read_Data_Register_Not_Empty) then
            declare
               C : constant Character :=
                 Character'Val (Current_Input (BLE_UART));
            begin
               Clear_Status (BLE_UART, Read_Data_Register_Not_Empty);
               Receive (C);
            end;
         end if;
         if Status (BLE_UART, Transmit_Data_Register_Empty)
           and then Interrupt_Enabled (BLE_UART, Transmit_Data_Register_Empty)
         then
            Tx_Prot.Tx_Interrupt;
         end if;
      end Handler;

      function Get_Speed return Speed_Msg_Type is
      begin
         return Speed;
      end Get_Speed;
   end Prot;

   procedure Send (S : String) is
   begin
      for I in S'Range loop
         Tx_Prot.Send (S (I));
         Tx_Prot.Wait;
      end loop;
   end Send;

   procedure Setup_4871 is
      T : Time;
      Reply : String (1 .. 80);
      Reply_Len : Natural;
   begin
      --  Switch to data mode if already in command mode
      Send ((1 => ASCII.CR));
      Send ("---" & ASCII.CR);

      --  Enter command mode
      T := Clock;
      delay until T + Milliseconds (200);
      Prot.Set_Command_Mode;
      Send ("$$$");

      --  Wait prompt
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);

      --  Get name
      Send ("GN" & ASCII.CR);

      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);
      if Reply_Len >= 11
        and then Reply (1 .. 11) = " Crazyflie" & ASCII.CR
      then
         if False then
            --  Factory reset
            Send ("SF,1" & ASCII.CR);
            return;
         end if;

         --  Already configured
         Send ("---" & ASCII.CR);
         Prot.Set_Data_Mode;

         return;
      end if;

      Send ("SS,00" & ASCII.CR);
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);

      Send ("PS,000002011C7F4F9E947B43B7C00A9A08" & ASCII.CR);
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);
      Send ("PC,000002021C7F4F9E947B43B7C00A9A08,1A,14" & ASCII.CR);
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);
      Send ("PC,000002031C7F4F9E947B43B7C00A9A08,14,14" & ASCII.CR);
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);
      Send ("PC,000002041C7F4F9E947B43B7C00A9A08,12,14" & ASCII.CR);
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);
      Send ("SN,Crazyflie" & ASCII.CR);
      Prot.Wait;
      Prot.Read_Reply (Reply, Reply_Len);

      --  Reboot
      Send ("R,1" & ASCII.CR);
      Prot.Set_Data_Mode;
   end Setup_4871;

   procedure Initialize is
      use Databases.Instantiations;
   begin
      --  Allocate database entries
      Db_Int := Integer_Databases.Get_Database_Instance;
      Db_Dir_Id := Db_Int.Register ("RC_DIR          ");
      Db_Speed_Id := Db_Int.Register ("RC_SPEED        ");

      Initialize_BLE_UART;
      Clear_Status (BLE_UART, Read_Data_Register_Not_Empty);
      Enable_Interrupts (BLE_UART, Source => Received_Data_Not_Empty);
      Setup_4871;
   end Initialize;

   function Get_Speed return Speed_Msg_Type is
   begin
      return Prot.Get_Speed;
   end Get_Speed;

end OPAVES.BLE;
