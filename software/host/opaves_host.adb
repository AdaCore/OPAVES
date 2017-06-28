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

with GNAT.Serial_Communications; use GNAT.Serial_Communications;
with Ada.Streams; use Ada.Streams;

package body Opaves_Host is
   Port : Serial_Port;

   type Packet_Type (Max_Len : Stream_Element_Offset) is record
      Len : Stream_Element_Offset;
      Pkt : Stream_Element_Array (1 .. Max_Len);
   end record;

   procedure Append_Raw (Pkt : in out Packet_Type; B : Stream_Element);
   --  Append B to PKT

   procedure Append (Pkt : in out Packet_Type; B : Stream_Element);
   --  Append B to PKT but escape it if needed.

   procedure Init_Send
     (Pkt : out Packet_Type; Cmd : Stream_Element; Len : Stream_Element);
   --  Initialize PKT with CMD and LEN.

   procedure Send_Recv (In_Pkt : Packet_Type;
                        Out_Pkt : out Packet_Type);

   Pkt_Start : constant := 16#7d#;
   --  Start of packet

   Pkt_End   : constant := 16#7e#;
   --  End of packet

   Pkt_Esc   : constant := 16#7f#;
   --  Next byte is escaped

   Pkt_Xor   : constant := 16#80#;
   --  Escape value (xor with value)

   subtype Pkt_Invalid is Stream_Element range Pkt_Start .. Pkt_Esc;
   --  Bytes that have to be escaped

   Cmd_Ping : constant := 2;
   Rep_Ping : constant := 3;

   procedure Init (Comm : String) is
   begin
      Open (Port, Port_Name (Comm));
      Set (Port,
           Rate => B115200,
           Bits => CS8, Stop_Bits => One, Parity => None);
   end Init;

   procedure Append_Raw (Pkt : in out Packet_Type; B : Stream_Element) is
   begin
      Pkt.Len := Pkt.Len + 1;
      Pkt.Pkt (Pkt.Len) := B;
   end Append_Raw;

   procedure Append (Pkt : in out Packet_Type; B : Stream_Element) is
   begin
      if B in Pkt_Start .. Pkt_Esc then
         Append_Raw (Pkt, Pkt_Esc);
         Append_Raw (Pkt, B xor Pkt_Xor);
      else
         Append_Raw (Pkt, B);
      end if;
   end Append;

   procedure Init_Send
     (Pkt : out Packet_Type; Cmd : Stream_Element; Len : Stream_Element) is
   begin
      Pkt.Len := 0;
      Append_Raw (Pkt, Pkt_Start);
      Append (Pkt, Len + 2);
      Append (Pkt, Cmd);
   end Init_Send;

   procedure Send_Recv (In_Pkt : Packet_Type;
                        Out_Pkt : out Packet_Type)
   is
      R : Stream_Element;
      Len : Stream_Element;

      procedure Read_Raw (B : out Stream_Element);
      procedure Read_1 (B : out Stream_Element);

      procedure Read_Raw (B : out Stream_Element)
      is
         Buf : Stream_Element_Array (1 .. 1);
         Last : Stream_Element_Offset;
      begin
         Read (Port, Buf, Last);
         if Last /= 1 then
            raise Serial_Error;
         end if;
         B := Buf (1);
      end Read_Raw;

      procedure Read_1 (B : out Stream_Element) is
      begin
         Read_Raw (B);
         if B = Pkt_Esc then
            Read_Raw (B);
            if B in Pkt_Invalid then
               raise Serial_Error;
            end if;
            B := B xor Pkt_Xor;
         elsif B in Pkt_Invalid then
            raise Serial_Error;
         end if;
      end Read_1;
   begin
      --  Send
      Write (Port, In_Pkt.Pkt (1 .. In_Pkt.Len));

      --  Get reply
      loop
         Read_Raw (R);
         exit when R = Pkt_Start;
      end loop;

      Out_Pkt.Len := 0;
      Read_1 (Len);
      Append_Raw (Out_Pkt, Len);
      for I in 2 .. Len loop
         Read_1 (R);
         if Out_Pkt.Len >= Out_Pkt.Max_Len then
            raise Serial_Error;
         end if;
         Append_Raw (Out_Pkt, R);
      end loop;

      Read_Raw (R);
      if R /= Pkt_End then
         raise Serial_Error;
      end if;
   end Send_Recv;

   procedure Ping (In_Msg : String;
                   Out_Msg : out String;
                   Out_Len : out Natural)
   is
      In_Pkt : Packet_Type (2 * In_Msg'Length + 4);
      Out_Pkt : Packet_Type (1 + Out_Msg'Length);
   begin
      Init_Send (In_Pkt, Cmd => Cmd_Ping, Len => In_Msg'Length);
      for I in In_Msg'Range loop
         Append (In_Pkt, Character'Pos (In_Msg (I)));
      end loop;
      Append_Raw (In_Pkt, Pkt_End);

      Send_Recv (In_Pkt, Out_Pkt);
      if Out_Pkt.Len < 2 or else Out_Pkt.Pkt (2) /= Rep_Ping then
         raise Serial_Error;
      end if;
      for I in 3 .. Out_Pkt.Len loop
         Out_Msg (Out_Msg'First + Natural (I - 3)) :=
           Character'Val (Out_Pkt.Pkt (I));
      end loop;
      Out_Len := Natural (Out_Pkt.Len - 1);
   end Ping;
end Opaves_Host;
