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

with Ada.Real_Time;            use Ada.Real_Time;
with Ada.Synchronous_Task_Control;

with Board.Ranging;            use Board.Ranging;
with Board.IMU;

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

   Wait_Init           : Ada.Synchronous_Task_Control.Suspension_Object;

   Initialized         : Boolean := False;
   IMU_Delay           : constant Time_Span :=
                           Seconds (1) / IMU_Read_Frequency;

   The_DB              : constant Float_Databases.Database_Access :=
                           Float_Databases.Get_Database_Instance;
   Status_DB           : constant Boolean_Databases.Database_Access :=
                           Boolean_Databases.Get_Database_Instance;

   Sensor_Status_IDs   : array (On_Board_Sensors) of Data_ID_Type;
   Ranging_Data_IDs    : array (Sensor_Location) of Data_ID_Type;
   IMU_Data_IDs        : array (IMU_Data_Identifier) of Data_ID_Type;

   function Data_Name
     (Sensor : On_Board_Sensors) return Data_Name_Type
   is (case Sensor is
          when Ranging_Front_Left   => Create ("ranging_fl"),
          when Ranging_Front_Center => Create ("ranging_fc"),
          when Ranging_Front_Right  => Create ("ranging_fr"),
          when Ranging_Side_Right   => Create ("ranging_sr"),
          when Ranging_Rear         => Create ("ranging_rc"),
          when IMU                  => Create ("imu"),
          when VBat                 => Create ("vbat"));

   function Data_Name
     (Ranging_Location : Sensor_Location) return Data_Name_Type
   is (case Ranging_Location is
          when Front_Left  => Create ("ranging_fl"),
          when Front       => Create ("ranging_fc"),
          when Front_Right => Create ("ranging_fr"),
          when Side_Right  => Create ("ranging_sr"),
          when Rear        => Create ("ranging_rc"));

   function Data_Name
     (IMU_Data_ID : IMU_Data_Identifier) return Data_Name_Type
   is (case IMU_Data_ID is
          when Angle_X => Create ("imu_angle_x"),
          when Angle_Y => Create ("imu_angle_y"),
          when Angle_Z => Create ("imu_angle_z"),
          when Acc_X   => Create ("imu_acc_x"),
          when Acc_Y   => Create ("imu_acc_y"),
          when Acc_Z   => Create ("imu_acc_z"));

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
   is
      use type Board.IMU.IMU_Status;
   begin

      Board.Ranging.Initialize;
      Board.IMU.Initialize;

      --  Initialize the databases
      for ID in On_Board_Sensors'Range loop
         Sensor_Status_IDs (ID) := Status_DB.Register (Data_Name (ID));
      end loop;

      for ID in Sensor_Location'Range loop
         Ranging_Data_IDs (ID) := The_DB.Register (Data_Name (ID));
      end loop;

      for ID in IMU_Data_Identifier'Range loop
         IMU_Data_IDs (ID)     := The_DB.Register (Data_Name (ID));
      end loop;

      Status_DB.Set
        (Sensor_Status_IDs (Ranging_Front_Center),
         Board.Ranging.Status (Board.Ranging.Front) = Board.Ranging.Ready);
      Status_DB.Set
        (Sensor_Status_IDs (Ranging_Front_Left),
         Board.Ranging.Status (Board.Ranging.Front_Left) = Board.Ranging.Ready);
      Status_DB.Set
        (Sensor_Status_IDs (Ranging_Front_Right),
         Board.Ranging.Status (Board.Ranging.Side_Right) = Board.Ranging.Ready);
      Status_DB.Set
        (Sensor_Status_IDs (Ranging_Side_Right),
         Board.Ranging.Status (Board.Ranging.Front_Right) = Board.Ranging.Ready);
      Status_DB.Set
        (Sensor_Status_IDs (Ranging_Rear),
         Board.Ranging.Status (Board.Ranging.Rear) = Board.Ranging.Ready);
      Status_DB.Set
        (Sensor_Status_IDs (IMU),
         Board.IMU.Status = Board.IMU.Ready);
      Status_DB.Set
        (Sensor_Status_IDs (VBat), False); --  Not there yet

      Initialized := True;
      Ada.Synchronous_Task_Control.Set_True (Wait_Init);
   end Initialize;

   ------------------------
   -- Initialize_Sensors --
   ------------------------

   function Sensors_Initialized return Boolean is
   begin
      return Initialized;
   end Sensors_Initialized;

   task body Sensors_Task
   is
      use type Board.IMU.IMU_Status;
      Ranging_Read_Time   : Time;
      IMU_Read_Time       : Time;
      IMU_Values          : Board.IMU.IMU_Data;
      Distance            : Millimeter;

   begin
      --  Wait for the sensors to be initialized
      Ada.Synchronous_Task_Control.Suspend_Until_True (Wait_Init);

      if Board.IMU.Status = Board.IMU.Ready then
         IMU_Read_Time := Clock + IMU_Delay;
      else
         IMU_Read_Time := Ada.Real_Time.Time_Last;
      end if;

      Next (Ranging_Read_Time);

      loop
         --  Initialize the read timings
         if IMU_Read_Time < Ranging_Read_Time then
            delay until IMU_Read_Time;

            IMU_Values    := Board.IMU.Read;
            IMU_Read_Time := Clock + IMU_Delay;

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

            IMU_Read_Time := IMU_Read_Time + IMU_Delay;
         else
            delay until Ranging_Read_Time;

            for S in Board.Ranging.Sensor_Location'Range loop
               if Status (S) = Ready then
                  Distance := Read (S);

                  The_DB.Set
                    (Data_ID => Ranging_Data_IDs (S),
                     Data    => Float (Distance) / 1000.0);
               end if;
            end loop;

            Board.Ranging.Next (Ranging_Read_Time);
         end if;
      end loop;
   end Sensors_Task;

end Sensors;
