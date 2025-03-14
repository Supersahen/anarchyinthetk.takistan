player groupChat format ["%1","Gang_loop"];

	player groupChat "Loop Spawned";
	private["_counter", "_sleep_time"];
	_counter = 0;
	_sleep_time = 60;
	while {true} do {

		private["_i"];
		_i =   ((count gangsarray) - 1);	
		while { _i >= 0 } do {
			private["_gangarray", "_members", "_gang_name"];
			
			_gangarray = gangsarray select _i;
			_gang_name = _gangarray select 0;
			_gang_leader = _gangarray select 1;
			_members   = _gangarray select 2;
			
			if ((isNil "_gang_leader") or (_gang_leader == "")) then {
			
				_gang_leader = _members select 0;
				_gangarray set[1, _gang_leader];
				player groupChat "New Gang Leader Set";
				
			};
			
			
			private["_j", "_original_size"];
			_original_size = count _members;
			_j = (count _members) - 1;
			while { _j >= 0 } do {
				private["_player_name", "_player"];
				_player_name = _members select _j;
				_player = [_player_name] call player_get_player_by_name;
				[_player,"gangmember",false] call player_set_bool;
				if(isNil "_player" )then {
					_members = _members - [_player_name];
					_gangarray set[2, _members];
				};
				_j = _j - 1;
			};
			
			
			if(_counter >= gangdeltime && (count _members) == 0) then {
				format['
				gangsarray set[%1, 0]; 
				gangsarray = gangsarray - [0];
				', _i] call broadcast;
			}
			else { if (_original_size != (count _members)) then {
				format['gangsarray set[%1, %2]', _i, _gangarray] call broadcast;
			};};
			
			_i = _i - 1;
		};
			
	};

	uiSleep 45;


