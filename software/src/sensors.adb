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

with Board.Ranging; use Board.Ranging;
with Board.IMU;     use Board.IMU;

with Databases;                use Databases;
with Databases.Instantiations; use Databases.Instantiations;

package body Sensors is

   type IMU_Data_Identifier is
     (Angle_X,
      Angle_Y,
      Angle_Z,
      Acc_X,
      Acc_Y,
      Acc_Z);

   Initialized         : Boolean := False;
   IMU_Delay           : constant Time_Span :=
                           Seconds (1) / IMU_Read_Frequency;

   Ranging_Read_Time   : Time;
   Ranging_Next_Sensor : Range_Sensor_Id;
   IMU_Read_Time       : Time;

   The_DB              : constant Float_Databases.Database_Access :=
                           Float_Databases.Get_Database_Instance;

   Ranging_Data_IDs    : array (Sensor_Location) of Data_ID_Type;
   IMU_Data_IDs        : array (IMU_Data_Identifier) of Data_ID_Type;

   function Data_Name (Ranging_Location : Sensor_Location) return String
   is (case Ranging_Location is
          when Front_Left  => "ranging_front_left",
          when Front       => "ranging_front_center",
          when Front_Right => "ranging_front_right",
          when Side_Right  => "ranging_side_right",
          when Rear        => "ranging_rear_center");

   function Data_Name (IMU_Data_ID : IMU_Data_Identifier) return String
   is (case IMU_Data_ID is
          when Angle_X => "imu_angle_x",
          when Angle_Y => "imu_angle_y",
          when Angle_Z => "imu_angle_z",
          when Acc_X   => "imu_acceleration_x",
          when Acc_Y   => "imu_acceleration_y",
          when Acc_Z   => "imu_acceleration_z");

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
   begin

      Board.Ranging.Initialize;
      Board.IMU.Initialize;

      --  Initialize the databases
      for ID in Sensor_Location'Range loop
         Ranging_Data_IDs (ID) := The_DB.Register (Data_Name (ID));
      end loop;

      for ID in IMU_Data_Identifier'Range loop
         IMU_Data_IDs (ID)     := The_DB.Register (Data_Name (ID));
      end loop;

      --  Initialize the read timings
      IMU_Read_Time := Clock + IMU_Delay;
      Next (Ranging_Next_Sensor, Ranging_Read_Time);

      Initialized := True;
   end Initialize;

   ------------------------
   -- Initialize_Sensors --
   ------------------------

   function Sensors_Initialized return Boolean is
   begin
      return Initialized;
   end Sensors_Initialized;

   --------------------
   -- Next_Read_Time --
   --------------------

   function Next_Read_Time return Time is
   begin
      if IMU_Read_Time < Ranging_Read_Time then
         return IMU_Read_Time;
      else
         return Ranging_Read_Time;
      end if;
   end Next_Read_Time;

   --------------------
   -- Update_Sensors --
   --------------------

   procedure Update_Sensors
   is
      Now : constant Time := Clock;
   begin
      if IMU_Read_Time <= Now then
         declare
            IMU_Values : Board.IMU.IMU_Data;
         begin
            IMU_Values    := Board.IMU.Read;
            IMU_Read_Time := Now + IMU_Delay;

            for Id in IMU_Data_Identifier'Range loop
               case Id is
                  when Angle_X =>
                     The_DB.Set
                       (Data_ID => IMU_Data_IDs (Id),
                        Data    => IMU_Values.Orientation.X);
                  when Angle_Y =>
                     The_DB.Set
                       (Data_ID => IMU_Data_IDs (Id),
                        Data    => IMU_Values.Orientation.Y);
                  when Angle_Z =>
                     The_DB.Set
                       (Data_ID => IMU_Data_IDs (Id),
                        Data    => IMU_Values.Orientation.Z);
                  when Acc_X =>
                     The_DB.Set
                       (Data_ID => IMU_Data_IDs (Id),
                        Data    => IMU_Values.Acceleration.X);
                  when Acc_Y =>
                     The_DB.Set
                       (Data_ID => IMU_Data_IDs (Id),
                        Data    => IMU_Values.Acceleration.Y);
                  when Acc_Z =>
                     The_DB.Set
                       (Data_ID => IMU_Data_IDs (Id),
                        Data    => IMU_Values.Acceleration.Z);
               end case;
            end loop;
         end;
      end if;

      loop
         exit when Ranging_Read_Time > Now;

         declare
            Distance : constant Millimeter := Read (Ranging_Next_Sensor);
         begin
            The_DB.Set
              (Data_ID => Ranging_Data_IDs (Ranging_Next_Sensor),
               Data    => Float (Distance) / 1000.0);
         end;

         Next (Ranging_Next_Sensor, Ranging_Read_Time);
      end loop;
   end Update_Sensors;

end Sensors;
