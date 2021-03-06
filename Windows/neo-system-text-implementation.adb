--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
with
  Neo.Windows;
use
  Neo.Windows;
separate(Neo.System.Text)
package body Implementation_For_Operating_System
  is
  ---------------
  -- Constants --
  ---------------
    DO_TEST_FOR_END_OF_FILE : constant Boolean := True;
  -------------------
  -- Set_Clipboard --
  -------------------
    procedure Set_Clipboard(
      Text : in String_2)
      is
      Data     : Address                     := NULL_ADDRESS;
      Accessor : Access_Integer_2_Unsigned_C := null;
      begin
        Data := Global_Allocate(MEMORY_MOVEABLE or MEMORY_DDE_SHARE, (Text'Length + 1) * 2);
        if Data = NULL_ADDRESS then
          raise System_Call_Failure;
        end if;
        Accessor := To_Access_Integer_2_Unsigned_C(Global_Lock(Data));
        if Accessor = null then
          raise System_Call_Failure;
        end if;
        for I in 1..Text'Length loop
          Accessor.All := Integer_2_Unsigned_C(Character_2'Pos(Text(I)));
          Accessor     := To_Access_Integer_2_Unsigned_C(To_Integer_4_Unsigned(Accessor) + 2);
        end loop;
        Accessor.All := 0;
        if Global_Unlock(Data) /= Integer_4_Signed_C(NO_ERROR) then
          raise System_Call_Failure;
        end if;
        if Open_Clipboard(NULL_ADDRESS) = FAILED and then Global_Free(Data) /= NULL_ADDRESS then
          raise System_Call_Failure;
        end if;
        if Empty_Clipboard = FAILED then
          raise System_Call_Failure;
        end if;
        if Set_Clipboard_Data(CLIPBOARD_UNICODE_TEXT, Data) = NULL_ADDRESS then
          raise System_Call_Failure;
        end if;
        if Close_Clipboard = FAILED then
          raise System_Call_Failure;
        end if;
      end Set_Clipboard;
  -------------------
  -- Get_Clipboard --
  -------------------
    function Get_Clipboard
      return String_2
      is
      Data     : Address                       := NULL_ADDRESS;
      Accessor : Access_Constant_Character_2_C := null;
      begin
        if Open_Clipboard(NULL_ADDRESS) = FAILED then
          raise System_Call_Failure;
        end if;
        Data := Get_Clipboard_Data(CLIPBOARD_UNICODE_TEXT);
        if Data = NULL_ADDRESS then
          raise System_Call_Failure;
        end if;
        Accessor := To_Access_Constant_Character_2_C(Global_Lock(Data));
        if Accessor = null then
          raise System_Call_Failure;
        end if;
        ---------------
        Compose_Result:
        ---------------
          declare
          Result : String_2 := To_String_2(Accessor);
          begin
            if Global_Unlock(Data) /= Integer_4_Signed_C(NO_ERROR) then 
              null;--raise System_Call_Failure;
            end if;
            if Close_Clipboard = FAILED then
              raise System_Call_Failure;
            end if;
            return Result;
          end Compose_Result;
      end Get_Clipboard;
  end Implementation_For_Operating_System;
