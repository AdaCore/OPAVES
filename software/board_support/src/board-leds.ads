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

private with STM32.GPIO;
private with STM32.Device;

package Board.LEDs is

   type LED_Id is (Red, Green);

   procedure Initialize
     with Post => Initialized;
   --  Initialize hardware for LEDs

   function Initialized return Boolean;
   --  Return True if the hardware is initialized

   procedure Turn_On (LED : LED_Id)
     with Pre => Initialized;
   procedure Turn_Off (LED : LED_Id)
     with Pre => Initialized;
   procedure Toggle (LED : LED_Id)
     with Pre => Initialized;

private
   LED_Pins : array (LED_Id) of STM32.GPIO.GPIO_Point :=
     (Red   => STM32.Device.PC2,
      Green => STM32.Device.PC3);
end Board.LEDs;
