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

with Board.Comm;    use Board.Comm;
with Board.Logging; use Board.Logging;

package body OPAVES.Comm is

   Write_Value_Cmd : constant String := "WRITE_VALUE:";
   Read_Value_Cmd : constant String := "READ_VALUE:";

   procedure Process_Incomming_Message (Msg : String);
   function Start_With (Str, Prefix : String) return Boolean;
   procedure Write_Value (Str : String);
   procedure Read_Value (ID : String);

   -----------------
   -- Write_Value --
   -----------------

   procedure Write_Value (Str : String) is
      Index : Natural := Str'First;
   begin
      while Index in Str'Range and then Str (Index) /= '=' loop
         Index := Index + 1;
      end loop;

      if Index in Str'Range
        or else
          Index = Str'First
        or else
          Index = Str'Last
      then
         declare
            ID    : constant String := Str (Str'First .. Index - 1);
            Value : constant String := Str (Index + 1 .. Str'Last);
         begin
            Log_Line (Debug, "Write request ID:'" & ID & "' Value:'" & Value & "'");
         end;
      else
         Log_Line (Warning, "Invalid write value cmd: '" & Str & "'");
      end if;
   end Write_Value;

   ----------------
   -- Read_Value --
   ----------------

   procedure Read_Value (ID : String) is
   begin
      Board.Comm.Send ("Here is the value for ID:'" & ID & "'",
                       Board.Comm.Message_Priority'Last);
   end Read_Value;

   -------------------------------
   -- Process_Incomming_Message --
   -------------------------------

   procedure Process_Incomming_Message (Msg : String) is
   begin
      Board.Logging.Log_Line ("Received: '" & Msg & "'");

      if Start_With (Msg, Write_Value_Cmd) then
         Write_Value (Msg (Msg'First + Write_Value_Cmd'Length .. Msg'Last));
      elsif Start_With (Msg, Read_Value_Cmd) then
         Read_Value (Msg (Msg'First + Read_Value_Cmd'Length .. Msg'Last));
      end if;
   end Process_Incomming_Message;

   ----------------
   -- Start_With --
   ----------------

   function Start_With (Str, Prefix : String) return Boolean is
   begin
      if Str'Length < Prefix'Length then
         return False;
      else
         return Str (Str'First .. Str'First + Prefix'Length - 1) = Prefix;
      end if;
   end Start_With;

   ------------------------
   -- Communication_Task --
   ------------------------

   task body Communication_Task is
      Msg : String (1 .. Board.Comm.Max_Message_Lenght);
      Len : Natural;
   begin
      loop
         Board.Comm.Receive (Msg, Len);
         Process_Incomming_Message (Msg (Msg'First .. Msg'First + Len - 1));
      end loop;
   end Communication_Task;
end OPAVES.Comm;
