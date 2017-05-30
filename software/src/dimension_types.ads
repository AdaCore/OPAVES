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

--  Common types with static dimensionality checking

package Dimension_Types is

   type Mks_Type is new Float
     with
       Dimension_System => (
        (Unit_Name => Meter,    Unit_Symbol => 'm',   Dim_Symbol => 'L'),
        (Unit_Name => Kilogram, Unit_Symbol => "kg",  Dim_Symbol => 'M'),
        (Unit_Name => Second,   Unit_Symbol => 's',   Dim_Symbol => 'T'),
        (Unit_Name => Ampere,   Unit_Symbol => 'A',   Dim_Symbol => 'I'),
        (Unit_Name => Kelvin,   Unit_Symbol => 'K',   Dim_Symbol => '@'),
        (Unit_Name => Mole,     Unit_Symbol => "mol", Dim_Symbol => 'N'),
        (Unit_Name => Candela,  Unit_Symbol => "cd",  Dim_Symbol => 'J'));

   subtype Length is Mks_Type
     with
       Dimension => (Symbol => 'm',
                     Meter  => 1,
                     others => 0);

   subtype Speed is Mks_Type
     with
      Dimension => (Symbol => "m/s",
                    Meter  => 1,
                    Second => -1,
                    others => 0);

   subtype Time is Mks_Type
     with
       Dimension => (Symbol => "s",
                     Second => 1,
                     others => 0);

   subtype Dimentionless is Mks_Type;

   subtype Frequency is Mks_Type
     with
       Dimension => (Symbol => "Hz",
                     Second => -1,
                     others => 0);

   subtype Revolution_Per_Second is Frequency;

end Dimension_Types;
