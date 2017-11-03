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

package Sensors is

   IMU_Read_Frequency : constant := 100;
   --  Read the IMU at 100Hz

   task Sensors_Task;

   procedure Initialize
     with Post => Sensors_Initialized;

   function Sensors_Initialized return Boolean;

private

   type On_Board_Sensors is
     (Ranging_Front_Left,
      Ranging_Front_Center,
      Ranging_Front_Right,
      Ranging_Side_Right,
      Ranging_Rear,
      IMU,
      VBat);

end Sensors;
