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

   procedure Set_Raw_Data
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
      Raw_Data    : UInt8_Array);
   --  Should be used by the Communication module.

   function Get_Raw_Data
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type) return UInt8_Array;
   --  Should be used by the Communication module

   package Integer_Databases is new Databases.Generics
     (Integer,
      Init_Data   => 0,
      Max_Nb_Data => 10);
   package Float_Databases is new Databases.Generics
     (Float,
      Init_Data   => 0.0,
      Max_Nb_Data => 10);

private
   First_ID : constant Database_ID_Type := Database_ID_Type'First;
   Last_ID  : constant Database_ID_Type := Get_Last_Database_ID;

   Databases : constant Root_Database_Array (First_ID .. First_ID + 1) :=
                 (First_ID     => Root_Database_Access
                    (Integer_Databases.Get_Database_Instance),
                  First_ID + 1 => Root_Database_Access
                    (Float_Databases.Get_Database_Instance));

end Databases.Instantiations;
