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

with Databases.Generics;

package Databases.Instantiations is

   procedure Set
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
      Image       : String);
   --  Set the value for the data associated with the given Data_ID.
   --  The value is given as a string and is then converted using the
   --  associated Value function (see databases-generics.ads).
   --  Should be used by the Communication module.

   function Get
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type) return String;
   --  Get the value for the data associated with the given Data_ID.
   --  The value is returned as a string, using the associated Image function
   --  for the conversion (see databases-generics.ads).
   --  Should be used by the Communication module

   function Get_IDs
     (Data_Name   : Data_Name_Type;
      Database_ID : out Database_ID_Type;
      Data_ID     : out Data_ID_Type) return Boolean;
   --  Get the database ID and the data ID associated with the given Data_Name,
   --  if any.
   --  Return True if the IDs have been found, False otherwise.

   task Logging_Task;
   --  A task used to log all the data contained in all the instantiated
   --  databases.

   package Integer_Databases is new Databases.Generics
     (Integer,
      Image       => Integer'Image,
      Value       => Integer'Value,
      Init_Data   => 0,
      Max_Nb_Data => 10);
   package Float_Databases is new Databases.Generics
     (Float,
      Image       => Float'Image,
      Value       => Float'Value,
      Init_Data   => 0.0,
      Max_Nb_Data => 20);
   package Boolean_Databases is new Databases.Generics
     (Boolean,
      Image       => Boolean'Image,
      Value       => Boolean'Value,
      Init_Data   => False,
      Max_Nb_Data => 10);

private
   First_ID : constant Database_ID_Type := First_Database_ID;
   Last_ID  : constant Database_ID_Type := Get_Last_Database_ID;

   Databases : constant Root_Database_Array (First_ID .. First_ID + 2) :=
                 (First_ID     => Root_Database_Access
                    (Integer_Databases.Get_Database_Instance),
                  First_ID + 1 => Root_Database_Access
                    (Float_Databases.Get_Database_Instance),
                  First_ID + 2 => Root_Database_Access
                    (Boolean_Databases.Get_Database_Instance));

end Databases.Instantiations;
