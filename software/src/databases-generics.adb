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

with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Databases.Generics is

   New_Data_ID : Data_ID_Type := First_Data_ID;

   protected Database_PO is
      pragma Interrupt_Priority;

      procedure Set
        (Data_ID : Data_ID_Type;
         Data    : Data_Type);

      function Get
        (Data_ID : Data_ID_Type) return Data_Type;

      function Get_Timestamp
        (Data_ID  : Data_ID_Type) return Time;

   end Database_PO;

   -----------------
   -- Database_PO --
   -----------------

   protected body Database_PO is

      ---------
      -- Set --
      ---------

      procedure Set
        (Data_ID : Data_ID_Type;
         Data    : Data_Type)
      is
      begin
         Database_Instance.Data_Objects_Map (Data_ID).Timestamp := Clock;
         Database_Instance.Data_Objects_Map (Data_ID).Data := Data;
      end Set;

      ---------
      -- Get --
      ---------

      function Get
        (Data_ID : Data_ID_Type) return Data_Type is
      begin
         return Database_Instance.Data_Objects_Map (Data_ID).Data;
      end Get;

      -------------------
      -- Get_Timestamp --
      -------------------

      function Get_Timestamp
        (Data_ID  : Data_ID_Type) return Ada.Real_Time.Time is
      begin
         return Database_Instance.Data_Objects_Map (Data_ID).Timestamp;
      end Get_Timestamp;

   end Database_PO;

   ---------------------------
   -- Get_Database_Instance --
   ---------------------------

   function Get_Database_Instance return Database_Access is
   begin
      return Database_Instance'Access;
   end Get_Database_Instance;

   --------------
   -- Register --
   --------------

   overriding function Register
     (Database  : in out Database_Type;
      Data_Name : Data_Name_Type) return Data_ID_Type
   is
      Data_ID : constant Data_ID_Type := New_Data_ID;
   begin
      --  Verify that no data has been registered with the same name

      for Name of Database.Data_Names loop
         if Data_Name = Name then
            raise Constraint_Error
              with "Data has already been registered with the given name: "
              & Data_Name;
         end if;
      end loop;

      Database.Data_Names (Data_ID) := Data_Name;
      Database.Data_Objects_Map (Data_ID) := Data_Object'
        (Data      => Init_Data,
         Timestamp => Time_First);

      New_Data_ID := New_Data_ID + 1;

      return Data_ID;
   end Register;

   ------------
   -- Get_ID --
   ------------

   overriding function Get_ID
     (Database : Database_Type) return Database_ID_Type is
   begin
      return Database.ID;
   end Get_ID;

   -----------------
   -- Get_Data_ID --
   -----------------

   overriding function Get_Data_ID
     (Database  : Database_Type;
      Data_Name : Data_Name_Type) return Data_ID_Type is
   begin
      for Data_ID in Database.Data_Names'Range loop
         if Data_Name = Database.Data_Names (Data_ID) then
            return Data_ID;
         end if;
      end loop;

      return Null_Data_ID;
   end Get_Data_ID;

   ---------
   -- Set --
   ---------

   overriding procedure Set
     (Database : in out Database_Type;
      Data_ID  : Data_ID_Type;
      Image    : String)
   is
      Data : constant Data_Type := Value (Image);
   begin
      Database.Set
        (Data_ID => Data_ID,
         Data    => Data);
   end Set;

   ---------
   -- Get --
   ---------

   overriding function Get
     (Database : Database_Type;
      Data_ID  : Data_ID_Type) return String
   is
      Data : constant Data_Type := Database.Get (Data_ID);
   begin
      return Image (Data);
   end Get;

   ------------------
   -- Log_All_Data --
   ------------------

   overriding procedure Log_All_Data (Database : Database_Type) is
   begin
      if New_Data_ID = Data_ID_Type'First then
         Put_Line ("No data registered");
      else
         for Data_ID in Database.Data_Objects_Map'First .. New_Data_ID - 1 loop
            Put_Line
              (Trim (Database.Data_Names (Data_ID), Right) & ": "
               & Image (Database.Data_Objects_Map (Data_ID).Data));
         end loop;
      end if;

      Ada.Text_IO.New_Line;
   end Log_All_Data;

   --------------------
   -- Clear_All_Data --
   --------------------

   overriding procedure Clear_All_Data (Database : in out Database_Type) is
   begin
      for Data_ID in Database.Data_Objects_Map'First .. New_Data_ID - 1 loop
         Database.Data_Objects_Map (Data_ID) := Data_Object'
           (Data      => Init_Data,
            Timestamp => Time_First);
         Database.Data_Names (Data_ID) := (others => ' ');
      end loop;

      New_Data_ID := First_Data_ID;
   end Clear_All_Data;

   ---------
   -- Get --
   ---------

   function Get
     (Database : Database_Type;
      Data_ID  : Data_ID_Type) return Data_Type
   is
      pragma Unreferenced (Database);
   begin
      return Database_PO.Get (Data_ID => Data_ID);
   end Get;

   ---------
   -- Set --
   ---------

   procedure Set
     (Database : in out Database_Type;
      Data_ID  : Data_ID_Type;
      Data     : Data_Type)
   is
      pragma Unreferenced (Database);
   begin
      Database_PO.Set
        (Data_ID => Data_ID,
         Data    => Data);
   end Set;

   -------------------
   -- Get_Timestamp --
   -------------------

   function Get_Timestamp
     (Database : Database_Type;
      Data_ID  : Data_ID_Type) return Time
   is
      pragma Unreferenced (Database);
   begin
      return Database_PO.Get_Timestamp (Data_ID => Data_ID);
   end Get_Timestamp;

end Databases.Generics;
