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

with Board.Comm;               use Board.Comm;
with Board.Logging;            use Board.Logging;
with Databases;                use Databases;
with Databases.Instantiations; use Databases.Instantiations;

package body OPAVES.Comm.Serial is

   Write_Value_Cmd : constant String := "WRITE_VALUE:";
   Read_Value_Cmd : constant String := "READ_VALUE:";
   Get_IDs_Cmd     : constant String := "GET_IDS:";

   -----------
   -- Utils --
   -----------

   function Start_With (Str, Prefix : String) return Boolean;
   --  Return True if Str starts with Prefix

   function Extract_IDs
     (Str          : String;
      Database_ID  : out Database_ID_Type;
      Data_ID      : out Data_ID_Type) return Boolean;
   --  Return the Database_ID and the Data_ID contained in the formatted string
   --  Str. The format should be "<database_ID>;<data_ID>".
   --  Return True if it succeed, False otherwise.

   --------------
   -- Commands --
   --------------

   procedure Process_Incomming_Message (Msg : String);
   --  Process the incoming message, dispatching to the proper procedure if a
   --  command is recognized.

   procedure Write_Value (Str : String);
   --  Handler for the WRITE_VALUE command

   procedure Read_Value (Str : String);
   --  Handler for the READ_VALUE command

   procedure Get_IDs (Str : String);
   --  Handler for the GET_IDS command

   -----------------
   -- Extract_IDs --
   -----------------

   function Extract_IDs
     (Str          : String;
      Database_ID  : out Database_ID_Type;
      Data_ID      : out Data_ID_Type) return Boolean
   is
      Sep_Index : Natural := Str'First;
   begin
      while Sep_Index in Str'Range
        and then Str (Sep_Index) /= ';'
      loop
         Sep_Index := Sep_Index + 1;
      end loop;

      if Sep_Index not in Str'First + 1 .. Str'Last - 1 then
         return False;
      end if;

      Database_ID :=
        Database_ID_Type'Value
          (Str (Str'First .. Sep_Index - 1));
      Data_ID :=
           Data_ID_Type'Value
          (Str (Sep_Index + 1 .. Str'Last));

      return True;

   exception
      when others =>
         return False;
   end Extract_IDs;

   -----------------
   -- Write_Value --
   -----------------

   procedure Write_Value (Str : String) is
      Equal_Index : Integer := Str'First;
      Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
      Success     : Boolean;
   begin
      while Equal_Index in Str'Range
        and then Str (Equal_Index) /= '='
      loop
         Equal_Index := Equal_Index + 1;
      end loop;

      if Equal_Index not in Str'First + 3 .. Str'Last - 1 then
         Log_Line (Warning, "Invalid write value cmd: '" & Str & "'");
         return;
      end if;

      Success := Extract_IDs
        (Str          => Str (Str'First .. Equal_Index - 1),
         Database_ID  => Database_ID,
         Data_ID      => Data_ID);

      if not Success then
         Log_Line (Warning, "Invalid write value cmd: '" & Str & "'");
         return;
      end if;

      declare
         Image : constant String := Str (Equal_Index + 1 .. Str'Last);
      begin
         Log_Line
           (Debug,
            "Write request ID:'" & Database_ID_Type'Image (Database_ID)
            & ';' & Data_ID_Type'Image (Data_ID)
            & "' Value:'" & Image & "'");
         Set
           (Database_ID => Database_ID,
            Data_ID     => Data_ID,
            Image       => Image);
      exception
         when others =>
            Log_Line (Warning, "Invalid write value cmd: '" & Str & "'");
      end;
   end Write_Value;

   ----------------
   -- Read_Value --
   ----------------

   procedure Read_Value (Str : String) is
      Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
      Success     : Boolean;
   begin
      Success := Extract_IDs
        (Str          => Str,
         Database_ID  => Database_ID,
         Data_ID      => Data_ID);

      if not Success then
         Log_Line (Warning, "Invalid read value cmd: '" & Str & "'");
         return;
      end if;

      declare
         Image : constant String := Get
           (Database_ID => Database_ID,
            Data_ID     => Data_ID);
      begin
         Board.Comm.Send ("Here is the value for ID:'" & Image & "'",
                          Board.Comm.Message_Priority'Last);
      end;
   end Read_Value;

   -------------
   -- Get_IDs --
   -------------

   procedure Get_IDs (Str : String) is
      Success     : Boolean;
      Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
   begin
      Success := Get_IDs
        (Data_Name   => Create (Str),
         Database_ID => Database_ID,
         Data_ID     => Data_ID);

      if Success then
         Log_Line
           (Debug, "IDs for " & Str & ": "
            & Database_ID_Type'Image (Database_ID) & ';'
            & Data_ID_Type'Image (Data_ID));
      else
         Log_Line (Warning, "IDs not found for name: '" & Str & "'");
      end if;
   exception
      when others =>
         Log_Line (Warning, "IDs not found for name: '" & Str & "'");
   end Get_IDs;

   -------------------------------
   -- Process_Incomming_Message --
   -------------------------------

   procedure Process_Incomming_Message (Msg : String) is
   begin
      Log_Line ("Received: '" & Msg & "'");

      if Start_With (Msg, Write_Value_Cmd) then
         Write_Value (Msg (Msg'First + Write_Value_Cmd'Length .. Msg'Last));
      elsif Start_With (Msg, Read_Value_Cmd) then
         Read_Value (Msg (Msg'First + Read_Value_Cmd'Length .. Msg'Last));
      elsif Start_With (Msg, Get_IDs_Cmd) then
         Get_IDs (Msg (Msg'First + Get_IDs_Cmd'Length .. Msg'Last));
      else
         Log_Line ("Not processed");
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
      Msg : String (1 .. Board.Comm.Max_Message_Length);
      Len : Natural;
   begin
      loop
         Board.Comm.Receive (Msg, Len);
         Process_Incomming_Message (Msg (Msg'First .. Msg'First + Len - 1));
      end loop;
   end Communication_Task;

end OPAVES.Comm.Serial;
