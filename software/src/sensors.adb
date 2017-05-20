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
with Board.LEDs;    use Board.LEDs;
with Board.Time_Of_Flight;     use Board.Time_Of_Flight;
with Board.IMU;     use Board.IMU;

with Ada.Text_IO;

package body Sensors is

   Initialized   : Boolean := False;
   IMU_Delay     : constant Time_Span :=
                     Seconds (1) / IMU_Read_Frequency;

   type Time_Of_Flight_Distances is array (Sensor_Location) of Millimeter;

   protected Database is
      procedure Set_Distance_Value
        (Location : Sensor_Location;
         Distance : Millimeter);

      procedure Set_IMU_Value
        (Attitude : IMU_Data);

      procedure Print_Values;

   private
      The_Distances : Time_Of_Flight_Distances;
      The_Attitude  : IMU_Data;
   end Database;

   protected body Database is

      ------------------------
      -- Set_Distance_Value --
      ------------------------

      procedure Set_Distance_Value
        (Location : Sensor_Location;
         Distance : Millimeter)
      is
      begin
         The_Distances (Location) := Distance;
      end Set_Distance_Value;

      -------------------
      -- Set_IMU_Value --
      -------------------

      procedure Set_IMU_Value
        (Attitude : IMU_Data)
      is
      begin
         The_Attitude := Attitude;
      end Set_IMU_Value;

      ------------------
      -- Print_Values --
      ------------------

      procedure Print_Values
      is
         procedure Put (Val : Integer);
         procedure Put (Val : String);
         procedure New_Line;

         function Degree (Rad : Float) return Integer
         is (Integer (Rad * 180.0 / 3.141592654));

         Buffer : String (1 .. 50);
         B_Idx  : Natural := Buffer'First;

         ---------
         -- Put --
         ---------

         procedure Put (Val : String)
         is
         begin
            Buffer (B_Idx .. B_Idx + Val'Length - 1) := Val;
            B_Idx := B_Idx + Val'Length;
         end Put;

         ---------
         -- Put --
         ---------

         procedure Put (Val : Integer)
         is
            S    : String (1 .. 5);
            Idx  : Natural := S'Last;
            C    : Character;
            V, N : Integer;
            Zero : constant := Character'Enum_Rep ('0');

         begin
            if Val < 0 then
               V := -Val;
            else
               V := Val;
            end if;

            loop
               N := V mod 10;
               C := Character'Val (N + Zero);
               S (Idx) := C;
               V := V / 10;
               exit when V = 0;
               Idx := Idx - 1;
            end loop;

            if Val < 0 then
               Idx := Idx - 1;
               S (Idx) := '-';
            end if;

            Put (S (Idx .. S'Last));
         end Put;

         --------------
         -- New_Line --
         --------------

         procedure New_Line is
         begin
            Ada.Text_IO.Put_Line (Buffer (1 .. B_Idx - 1));
            B_Idx := 1;
         end New_Line;

      begin
         Toggle (Green);
         --  Clear the screen
         Put (ASCII.ESC & "[2J" & ASCII.ESC & "[H");
         Put ("FL: ");
         Put (The_Distances (Front_Left));
         Put ("mm");
         New_Line;
         Put ("FC: ");
         Put (The_Distances (Front));
         Put ("mm");
         New_Line;
         Put ("FR: ");
         Put (The_Distances (Front_Right));
         Put ("mm");
         New_Line;
         Put ("SR: ");
         Put (The_Distances (Side_Right));
         Put ("mm");
         New_Line;
         Put ("RC: ");
         Put (The_Distances (Rear));
         Put ("mm");
         New_Line;
         Put ("Euler X: ");
         Put (Degree (The_Attitude.Orientation.X));
         Put (" deg.");
         New_Line;
         Put ("Euler Y: ");
         Put (Degree (The_Attitude.Orientation.Y));
         Put (" deg.");
         New_Line;
         Put ("Euler Z: ");
         Put (Degree (The_Attitude.Orientation.Z));
         Put (" deg.");
         New_Line;
      end Print_Values;
   end Database;

   task Sensor_Reader
     with Storage_Size => 16 * 1024;

   -------------------
   -- Sensor_Reader --
   -------------------

   task body Sensor_Reader
   is
      ToF_Read_Time   : Time;
      ToF_Next_Sensor : Sensor_Id;
      Distance        : Millimeter;

      IMU_Read_Time   : Time;
      IMU_Values      : IMU_Data;

      Print_Time      : Time;

   begin
      Board.Time_Of_Flight.Initialize;
      Board.IMU.Initialize;

      Initialized := True;
      IMU_Read_Time := Clock;
      Next (ToF_Next_Sensor, ToF_Read_Time);
      Print_Time := Clock + Seconds (1);

      if ToF_Next_Sensor = Invalid then
         raise Constraint_Error with "No Time of Fligh sensor";
      end if;

      loop
         if IMU_Read_Time < ToF_Read_Time
           and then IMU_Read_Time < Print_Time
         then
            delay until IMU_Read_Time;

            IMU_Values    := Board.IMU.Read;
            IMU_Read_Time := IMU_Read_Time + IMU_Delay;

            Database.Set_IMU_Value (IMU_Values);

         elsif ToF_Read_Time < Print_Time then
            delay until ToF_Read_Time;

            Distance := Read (ToF_Next_Sensor);
            Database.Set_Distance_Value (ToF_Next_Sensor, Distance);

            Board.Time_Of_Flight.Next (ToF_Next_Sensor, ToF_Read_Time);

         else
            Database.Print_Values;
            Print_Time := Clock + Seconds (1);
         end if;
      end loop;
   end Sensor_Reader;

   ------------------------
   -- Initialize_Sensors --
   ------------------------

   function Sensors_Initialized return Boolean is
   begin
      return Initialized;
   end Sensors_Initialized;

end Sensors;
