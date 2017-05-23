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

with HAL; use HAL;

package Databases is

   subtype Data_Name_Type is String (1 .. 16);
   --  16-Characters names used to register the data stored in databases

   type Database_ID_Type is private;
   --  Non-string based IDs for databases.
   --  Created when creating a new database instance.

   type Data_ID_Type is new Positive;
   --  Non-string based IDs for data stored in databases.
   --  Created when registering data in databases.

   type Root_Database_Type is interface;
   type Root_Database_Access is access all Root_Database_Type'Class;
   --  The root abstract type for all databases

   function Register
     (Database  : in out Root_Database_Type;
      Data_Name : Data_Name_Type) return Data_ID_Type is abstract;
   --  Register data to store in the given Database, associating it with
   --  Data_Name.
   --  The returned ID should be used for later transactions.

   function Get
     (Database : Root_Database_Type;
      Data_ID  : Data_ID_Type) return UInt8_Array is abstract;
   --  Get the currently set value for given Data_ID in a raw data format

   procedure Set
     (Database : in out Root_Database_Type;
      Data_ID  : Data_ID_Type;
      Raw_Data : UInt8_Array) is abstract;
   --  Set a raw data value for the given Data_ID

private

   type Database_ID_Type is new Positive;

   type Root_Database_Array is
     array (Database_ID_Type range <>) of Root_Database_Access;

   type Data_Name_Array is array (Data_ID_Type'First .. 16) of Data_Name_Type;

   function Get_New_Database_ID return Database_ID_Type;
   --  Used to get a new database ID each time a databse is instantiated

   function Get_Last_Database_ID return Database_ID_Type;
   --  Return the lastly created database ID

end Databases;
