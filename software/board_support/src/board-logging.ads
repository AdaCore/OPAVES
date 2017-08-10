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

with Board.Comm;

package Board.Logging is

   type Log_Category is (Info, Debug, Warning, Error);

   procedure Log_Line (Cat : Log_Category; Str : String);
   --  Log under the given category

   procedure Log_Line (Str : String);
   --  Log under the default category

   procedure Enable (Cat : Log_Category);
   --  Enable logging for the given category.

   procedure Disable (Cat : Log_Category);
   --  Disable logging for the given category.

   -------------------
   -- Configuration --
   -------------------

   Default_Category : constant Log_Category := Info;

   Enabled_At_Init : constant array (Log_Category) of Boolean :=
     (Info    => True,
      Debug   => True,
      Warning => True,
      Error   => True);

   Insert_Prefix : constant array (Log_Category) of Boolean :=
     (Info    => False,
      Debug   => True,
      Warning => True,
      Error   => True);

   Priority : constant array (Log_Category) of Board.Comm.Message_Priority :=
     (Info    => 0,
      Debug   => 1,
      Warning => 2,
      Error   => 3);

end Board.Logging;
