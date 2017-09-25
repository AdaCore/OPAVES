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

package body Databases.Instantiations is

   LOGGING_TASK_PERIOD : constant Time_Span := Seconds (2);

   ---------
   -- Set --
   ---------

   procedure Set
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type;
      Image       : String) is
   begin
      Databases (Database_ID).Set
        (Data_ID => Data_ID,
         Image   => Image);
   end Set;

   ---------
   -- Get --
   ---------

   function Get
     (Database_ID : Database_ID_Type;
      Data_ID     : Data_ID_Type)
      return String
   is
   begin
      return Databases (Database_ID).Get (Data_ID);
   end Get;

   -------------
   -- Get_IDs --
   -------------

   function Get_IDs
     (Data_Name   : Data_Name_Type;
      Database_ID : out Database_ID_Type;
      Data_ID     : out Data_ID_Type) return Boolean
   is
      Cur_Data_ID : Data_ID_Type;
   begin
      for Database of Databases loop
         Cur_Data_ID := Database.Get_Data_ID (Data_Name);

         if Cur_Data_ID /= Null_Data_ID then
            Database_ID := Database.Get_ID;
            Data_ID := Cur_Data_ID;

            return True;
         end if;
      end loop;

      return False;
   end Get_IDs;

   ------------------
   -- Logging_Task --
   ------------------

   task body Logging_Task is
      Next_Period : Time;
   begin
      Next_Period := Clock + LOGGING_TASK_PERIOD;

      loop
         delay until Next_Period;

         for Database of Databases loop
            Database.Log_All_Data;
         end loop;

         Next_Period := Next_Period + LOGGING_TASK_PERIOD;
      end loop;
   end Logging_Task;

end Databases.Instantiations;
