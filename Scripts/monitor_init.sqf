if (taki_init_finished) exitWith {};
_max_time = 60;
_time = 0;
while {true} do {
	if (taki_init_finished) exitWith {};
	
	if (isNil "taki_init_finished") then {
		diag_log "Taki: Init did not run, attempting to run it now";
		systemChat format ["Taki: Init did not run, attempting to run it now"];
		[] execvm "init.sqf";
	};
	
	if (_time >= _max_time and !(taki_init_finished)) then {
		diag_log "Taki: Init did not run, attempting to run it now";
		systemChat format ["Taki: Init did not run, attempting to run it now"];
		
		[] execvm "init.sqf";
	};

	_time = _time + 1;
	uiSleep 1;
};
