gangs_delete_inactive = {
	for "_i" from 0 to  ((count gangsarray) - 1) do {
		_gangarray = gangsarray select _i;
		if (isNil "_gangarray") exitWith {};
		_gang_members   = _gangarray select 2;
		
		if ((count _gang_members) <= 0) then {	
			format['
				gangsarray set[%1, 0]; 
				gangsarray = gangsarray - [0];
				', _i] call broadcast;
		};
	};
};
gangs_refresh_members = {
	for "_i" from 0 to (  ((count gangsarray) - 1)) do {
		_gangarray = gangsarray select _i;
		if (isNil "_gangarray") exitWith {};
		_gang_members   = _gangarray select 2;
		{
			_string = format ['%1',_x];
			_player = [_string] call player_get_player_by_name;
			if (isNil "_player") then {
				_gang_members = _gang_members - [_x];
				_gangarray set[2, _gang_members];
				format['gangsarray set[%1, %2]', _i, _gangarray] call broadcast;
			};
		} foreach _gang_members;
	};
};
gangs_refresh_leader = {
	for "_i" from 0 to  ((count gangsarray) - 1) do {
		_gangarray = gangsarray select _i;
		if (isNil "_gangarray") exitWith {};
		_gang_leader = (_gangarray select 1) select 0;
		_gang_members   = _gangarray select 2;

		if ((isnil "_gang_leader") and ((count _gang_members) > 0)) then {
		
			_gang_leader = _gang_members select 0;
			_gangarray set[1, [_gang_leader]];
			format['gangsarray set[%1, %2]', _i, _gangarray] call broadcast;
		};
	};
};
gangs_logic_check = {
	for "_i" from 0 to  ((count gangsarray) - 1) do {
		_gangarray = gangsarray select _i;
		if (isNil "_gangarray") exitWith {};
		_gang_leader = (_gangarray select 1) select 0;
		_gang_members   = _gangarray select 2;
		_player_name = name player;
		
		if (_player_name == _gang_leader) then {gangleader = true};
		if (_player_name in _gang_members) then {gangmember = true};
	};
};
ganglooprun = true;
while {ganglooprun} do {	
	
		waituntil {!isnil "gangsarray"}
		call gangs_delete_inactive;
		call gangs_refresh_leader;
		call gangs_refresh_members;
		["[] spawn gangs_logic_check"] call broadcast ;
		uiSleep 30;
};