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

with Ada.Real_Time; use Ada.Real_Time;
with Databases;     use Databases;

generic
   type Data_Type is private;
   --  The data type that should be stored in the database

   Init_Data   : Data_Type;
   --  The value that should be set just after the data registration

   Max_Nb_Data : Positive;
   --  The maximun number of data that can be stored in the database

   with function Image (Data : Data_Type) return String;

package Databases.Generics is

   type Database_Type is new Root_Database_Type with private;
   type Database_Access is access all Database_Type'Class;
   --  Database types for the given Data_Type.

   function Get_Database_Instance return Database_Access;
   --  Return the unique database instance for this package.
   --  Use this function in order to get/set values of the given Data_Type.

   function ID (Database : Database_Type) return Database_ID_Type;
   --  Return the ID of the database

   function Get
     (Database : Database_Type;
      Data_ID  : Data_ID_Type) return Data_Type;
   --  Get the currently set value for given Data_ID

   function Get_Timestamp
     (Database : Database_Type;
      Data_ID  : Data_ID_Type) return Time;

   procedure Set
     (Database : in out Database_Type;
      Data_ID  : Data_ID_Type;
      Data     : Data_Type);
   --  Set a value for the given Data_ID

   overriding function Register
     (Database  : in out Database_Type;
      Data_Name : Data_Name_Type) return Data_ID_Type;

   overriding function Get_Data_ID
     (Database  : Database_Type;
      Data_Name : Data_Name_Type) return Data_ID_Type;

   overriding function Get
     (Database : Database_Type;
      Data_ID  : Data_ID_Type) return UInt8_Array;

   overriding procedure Set
     (Database : in out Database_Type;
      Data_ID  : Data_ID_Type;
      Raw_Data : UInt8_Array);

   overriding procedure Log_All_Data (Database : Database_Type);

   overriding procedure Clear_All_Data (Database : in out Database_Type);

private

   type Data_Object is record
      Data      : Data_Type;
      Timestamp : Ada.Real_Time.Time;
   end record;

   type Data_Object_Array is
     array (First_Data_ID .. Data_ID_Type (Max_Nb_Data)) of Data_Object;

   type Data_Name_Array is
     array (First_Data_ID .. Data_ID_Type (Max_Nb_Data)) of Data_Name_Type;

   type Database_Type is new Root_Database_Type with record
      ID               : Database_ID_Type := Get_New_Database_ID;
      Data_Objects_Map : Data_Object_Array;
      Data_Names       : Data_Name_Array;
   end record;

   Database_Instance : aliased Database_Type;

end Databases.Generics;
