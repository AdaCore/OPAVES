with STM32.Board; use STM32.Board;
with Ada.Real_Time; use Ada.Real_Time;
with STM32.USARTs; use STM32.USARTs;
with BLE;

procedure Blink
is
   Step : constant Time_Span := Milliseconds (50);
   Cycle : constant Time_Span := Milliseconds (500);
   T : Time;

   Msg : BLE.Speed_Msg_Type;
   Tog : Boolean := True;
begin
   Initialize_LEDS;
   BLE.Init;

   T := Clock;
   loop
      delay until T;

      Msg := BLE.Get_Speed;

      if Msg.Timestamp + Cycle < T then
         --  Error: sensor data are too old
         Turn_On (Red_Led);
         Turn_On (Green_Led);
         T := T + Cycle;
      else
         --  Adjust cycle
         T := T + (15 - Msg.Speed / 2**12) * Step;

         Tog := not Tog;
         if Tog then
            Turn_On (Green_Led);
            Turn_Off (Red_Led);
         else
            Turn_Off (Green_Led);
            Turn_On (Red_Led);
         end if;
      end if;
   end loop;
end Blink;
