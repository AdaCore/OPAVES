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

with Logging_With_Categories;

package body Board.Logging is

   package Log is new Logging_With_Categories
     (Categories                    => Log_Category,
      Priorities                    => Board.Comm.Message_Priority,
      Default_Category              => Default_Category,
      Default_Priority              => 0,
      Categories_Enabled_By_Default => False,
      Prefix_Enabled_By_Default     => False,
      Log_Line_Backend              => Board.Comm.Send);

   procedure Log_Line (Cat : Log_Category; Str : String) renames Log.Log_Line;
   procedure Log_Line (Str : String) renames Log.Log_Line;
   procedure Enable (Cat : Log_Category) renames Log.Enable;
   procedure Disable (Cat : Log_Category) renames Log.Disable;

begin

   for Cat in Log_Category loop
      if Insert_Prefix (Cat) then
         Log.Enable_Prefix (Cat);
      end if;

      if Enabled_At_Init (Cat) then
         Log.Enable (Cat);
      end if;

      Log.Set_Priority (Cat, Priority (Cat));
   end loop;
end Board.Logging;
