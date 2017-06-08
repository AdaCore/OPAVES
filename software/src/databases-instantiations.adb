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
