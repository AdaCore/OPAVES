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

with Console;          use Console;
with CRTP_Service;     use CRTP_Service;
with Platform_Service; use Platform_Service;
with Link_Interface;   use Link_Interface;

package body OPAVES.Comm.CRTP is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      --  Initialize the link layer (Radiolink by default in Config.ads).
      Link_Init;

      --  Initialize low and high level services.
      CRTP_Service_Init;
      Platform_Service_Init;

      --  Initialize the console module.
      Console_Init;
   end Initialize;

end OPAVES.Comm.CRTP;
