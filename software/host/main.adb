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

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Opaves_Host;

procedure Main is
begin
   if Argument_Count /= 1 then
      Put_Line ("usage: " & Command_Name & " serial-port");
      Set_Exit_Status (Failure);
      return;
   end if;

   Opaves_Host.Init (Argument (1));

   loop
      declare
         Buf : String (1 .. 16);
         Len : Natural;
      begin
         Opaves_Host.Ping ("Ping", Buf, Len);
         Put_Line (Buf (1 .. Len));
         delay 1.0;
      end;
   end loop;
end Main;
