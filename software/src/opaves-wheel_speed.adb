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

with Board.Motor_Encoder; use Board.Motor_Encoder;

with OPAVES.Parameters;   use OPAVES.Parameters;
with Dimension_Types;     use Dimension_Types;

with Ada.Real_Time;       use Ada.Real_Time;
with System;

package body OPAVES.Wheel_Speed is

   Saved_Motor_RPS   : Motor_Revolution_Per_Second := Frequency (0.0);
   Saved_Wheel_RPS   : Wheel_Revolution_Per_Second := Frequency (0.0);
   Saved_Wheel_Speed : Car_Speed := Speed (0.0);

   --  We use a protected object at maximum priority to ensure atomic read of
   --  time and encoder value.
   protected Atomic_Reading
     with Priority => System.Priority'Last
   is
      procedure Read (Last_Date  : out Ada.Real_Time.Time;
                      Last_Count : out Encoder_Count;
                      Now        : out Ada.Real_Time.Time;
                      Count      : out Encoder_Count);

   private
      Last_Count : Encoder_Count      := 0;
      Timestamp  : Ada.Real_Time.Time := Time_First;
   end Atomic_Reading;

   --------------------
   -- Atomic_Reading --
   --------------------

   protected body Atomic_Reading is

      ----------
      -- Read --
      ----------

      procedure Read (Last_Date  : out Ada.Real_Time.Time;
                      Last_Count : out Encoder_Count;
                      Now        : out Ada.Real_Time.Time;
                      Count      : out Encoder_Count)
      is
      begin
         --  Get values from last reading
         Read.Last_Date := Atomic_Reading.Timestamp;
         Read.Last_Count := Atomic_Reading.Last_Count;

         --  Get values for new reading
         Read.Now := Ada.Real_Time.Clock;
         Read.Count := Board.Motor_Encoder.Current_Count;

         --  Update stored values
         Atomic_Reading.Timestamp := Read.Now;
         Atomic_Reading.Last_Count := Read.Count;
      end Read;
   end Atomic_Reading;

   -------------
   -- Capture --
   -------------

   procedure Capture is
      Now, Last_Date : Ada.Real_Time.Time;
      Count, Last_Count : Encoder_Count;
      Elapsed  : Dimension_Types.Time;

      Diff  : Encoder_Count;
      Dir   : Direction;
      Tmp_Wheel_Speed : Car_Speed;
      Tmp_Wheel_RPS : Wheel_Revolution_Per_Second;
      Tmp_Motor_RPS : Motor_Revolution_Per_Second;
   begin

      --  Read encoder values and dates
      Atomic_Reading.Read (Last_Date,
                           Last_Count,
                           Now,
                           Count);

      --  How much time between the two readings
      Elapsed := Dimension_Types.Time (To_Duration (Now - Last_Date));

      if Elapsed > Max_Encoder_Read_Interval then
         raise Program_Error with "Encoder read interval time exceeded";
      end if;

      Diff := Count - Last_Count;

      --  If the count difference is above a given threshold, we consider that
      --  the counter went backwards. This can only be true if the time between
      --  two consecutive read of the counter is below a safe amount of time
      --  defined by the constant Max_Encoder_Read_Interval (see check above).
      if Dimensionless (Diff) > Encoder_Count_Wrap_Threshold then
         Diff := Last_Count - Count;
         Dir := Backward;
      else
         Dir := Forward;
      end if;

      Tmp_Motor_RPS :=
        Dimensionless (Diff) / Encoder_Tick_Per_Revolution / Elapsed;

      Tmp_Wheel_RPS := Tmp_Motor_RPS / Motor_To_Wheel_Gear_Ratio;

      Tmp_Wheel_Speed := Tmp_Wheel_RPS * Wheel_Circumference;

      if Dir = Forward then
         Saved_Wheel_Speed := Tmp_Wheel_Speed;
         Saved_Wheel_RPS   := Tmp_Wheel_RPS;
         Saved_Motor_RPS   := Tmp_Motor_RPS;
      else
         Saved_Wheel_Speed := -Tmp_Wheel_Speed;
         Saved_Wheel_RPS   := -Tmp_Wheel_RPS;
         Saved_Motor_RPS   := -Tmp_Motor_RPS;
      end if;
   end Capture;

   -----------------
   -- Wheel_Speed --
   -----------------

   function Wheel_Speed return Car_Speed
   is (Saved_Wheel_Speed);

   ---------------
   -- Motor_RPS --
   ---------------

   function Motor_RPS return Motor_Revolution_Per_Second
   is (Saved_Motor_RPS);

   ---------------
   -- Wheel_RPS --
   ---------------

   function Wheel_RPS return Motor_Revolution_Per_Second
   is (Saved_Wheel_RPS);

end OPAVES.Wheel_Speed;
