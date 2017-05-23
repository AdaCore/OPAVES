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

package body Databases.Instantiations is

   ------------------
   -- Set_Raw_Data --
   ------------------

   procedure Set_Raw_Data
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
      Raw_Data    : UInt8_Array) is
   begin
      Databases (Database_ID).Set
        (Data_ID  => Data_ID,
         Raw_Data => Raw_Data);
   end Set_Raw_Data;

   ------------------
   -- Get_Raw_Data --
   ------------------

   function Get_Raw_Data
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type)
      return UInt8_Array
   is
   begin
      return Databases (Database_ID).Get (Data_ID);
   end Get_Raw_Data;

end Databases.Instantiations;
