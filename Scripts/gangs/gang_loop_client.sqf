	uiSleep 10;
	private ["_mygang", "_mymembers", "_enmembers"];

	while {isciv} do {

			for "_c" from 0 to (count gangareas - 1) do {
			private ["_pos"];
			_gangarea = gangareas select _c;
			_control  = _gangarea getvariable "control";
			
			_offset = [_gangarea] call flag_gang_get_offset;
			if (!isNil "_offset") then
			{
				if(player distance _gangarea < 10 and (_offset select 2) < 0 and _control == (call INV_MyGang))then {
					_new_offset = [_gangarea, [0,0,0.1]] call flag_gang_set_offset;
					if ((_new_offset select 2) > 0) then {
						[_gangarea, [0,0,0]] call flag_gang_reset_offset;
					};
				};
			};
		};
		uiSleep 3;
	};