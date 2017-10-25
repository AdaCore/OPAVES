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

with CRTP;    use CRTP;
with Syslink; use Syslink;

package OPAVES.Comm.CRTP is

   CRTP_Rx_Task : CRTP_Rx_Task_Type (CRTP_Task_Priority);
   CRTP_Tx_Task : CRTP_Tx_Task_Type (CRTP_Task_Priority);

   Syslink_Task : Syslink_Task_Type (Syslink_Task_Priority);

   procedure Initialize;

end OPAVES.Comm.CRTP;
