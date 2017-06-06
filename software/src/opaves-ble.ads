with Ada.Real_Time; use Ada.Real_Time;

package OPAVES.BLE is
   procedure Initialize;

   type Speed_Msg_Type is record
      Speed : Natural; --  0 .. 16#cccc#
      Timestamp : Time;
   end record;

   function Get_Speed return Speed_Msg_Type;
end OPAVES.BLE;
