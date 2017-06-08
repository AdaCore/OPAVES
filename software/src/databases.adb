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

package body Databases is

   New_DB_ID : Database_ID_Type := 1;

   ------------
   -- Create --
   ------------

   function Create (Name : String) return Data_Name_Type is
   begin
      if Name'Length in 1 .. 16 then
         declare
            Data_Name : Data_Name_Type := (others => ' ');
         begin
            Data_Name (Data_Name'First .. Data_Name'First + Name'Length -1) :=
              Name;

            return Data_Name;
         end;
      else
         raise Constraint_Error
           with "Name should have between 1 and 16 characters";
      end if;
   end Create;

   -------------------------
   -- Get_New_Database_ID --
   -------------------------

   function Get_New_Database_ID return Database_ID_Type
   is
      DB_ID : constant Database_ID_Type := New_DB_ID;
   begin
      New_DB_ID := New_DB_ID + 1;

      return DB_ID;
   end Get_New_Database_ID;

   --------------------------
   -- Get_Last_Database_ID --
   --------------------------

   function Get_Last_Database_ID return Database_ID_Type is
   begin
      return New_DB_ID;
   end Get_Last_Database_ID;

end Databases;
