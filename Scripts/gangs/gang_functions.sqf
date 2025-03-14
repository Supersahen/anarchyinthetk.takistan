gang_create = {

	private ["_gang","_name","_id","_c","_members","_leader","_gangarray","_player_name"];
	_gang_name = _this select 0;
	_player_name = name player;
	_money = [player,"money"] call INV_GetItemAmount;
	gangs_restricted_names = ["cops","niggers"];

	
	if(_money < gangcreatecost) exitWith {
		player groupchat format ["Not enough shekels, $%1 is required",gangcreatcost];
	};
	
	
	if (_gang_name in gangs_restricted_names) exitWith {player groupChat "That name is not allowed"};
	
	if (gangmember) exitWith {player groupChat "You are already in a gang"};
	
	for "_c" from 0 to (count gangsarray - 1) do {
		if (((gangsarray select _c) select 0) == _gang_name) exitWith {player groupChat "That name is taken"};
	};
	
	if ((_gang_name call ISSE_str_Length) > 30 or (_gang_name call ISSE_str_Length) < 3) exitWith {
		player groupChat "Name too long or too short";
	};
	
	[player, 'money', - gangcreatecost] call INV_AddInventoryItem;
	
	format['gangsarray = gangsarray + [["%1",["%2"], ["%3"], true, []]]', _gang_name,_player_name, _player_name] call broadcast;

	player groupChat "Gang created!";
	gangwar = false;
	gangmember = true; gangleader = true;
	
};


gang_kick = {

	_civ = call compile format["%1", _this select 0];

	
	if(player == _civ) exitWith {
		player groupchat "you cannot kick yourself!"
	};

	for "_c" from 0 to (count gangsarray - 1) do {
		_gangarray = gangsarray select _c;
		_gang	   = _gangarray select 0;
		_members   = _gangarray select 2;
		_name	   = name player;

		if(_name in _members)then {
			_members = _members - [(name _civ)];
			_gangarray set[2, _members];
			format['if(player == %3)then{player groupchat "you have been kicked out of your gang!"; gangmember = false;}; gangsarray set[%1, %2]', _c, _gangarray, _civ] call broadcast;
		};

		player groupchat format["you kicked %1 from your gang!", name _civ];
	};

	
};

gang_join = {

	_gang = _this select 0;
	_name = name player;
	_id   = -1;
	private ["_gang","_name","_id","_c","_members","_leader","_gangarray"];

	
	if (gangmember) exitWith {player groupChat "You are already in a gang"};

	for "_c" from 0 to (count gangsarray - 1) do {
		if (((gangsarray select _c) select 0) == _gang) exitWith {
			_id = _c;
		};
	};

	if(_id == -1) exitWith {
		player groupchat "this gang no longer exists!"
	};

	_gangarray = gangsarray select _id;
	_leader = _gangarray select 1;
	_members   = _gangarray select 2;
	_bool   = _gangarray select 3;
	
	if !(_bool) exitWith {player groupChat "This gang is private"};
	if (_name in _members) exitWIth {player groupChat "You are already in this gang!"};
	
	_members   = _members + [_name];
	_gangarray set[2, _members];

	format['gangsarray set[%1, %2]', _id, _gangarray] call broadcast;

	player groupchat format["You have joined %1!", _gang];
	
	gangmember = true;
	
};


gang_leave = {
	
	if(!gangmember)exitwith{player groupchat "you are not in a gang!"};
	private ["_gang","_name","_id","_c","_members","_leader","_gangarray"];

	
	for "_c" from 0 to (count gangsarray - 1) do {
		_gangarray = gangsarray select _c;
		_gang	   = _gangarray select 0;
		_leader    = _gangarray select 1;
		_members   = _gangarray select 2;
		_name	   = name player;
		_bool = _name in _members;
		
		
		if(_name in _members)then {
			_members = _members - [_name];
			_gangarray set[2, _members];
			format['gangsarray set[%1, %2]', _c, _gangarray] call broadcast;
			player groupchat "you left your gang!";
			gangmember = false;
			gangwar = false;
	
		};
		if(_name in _leader)then {
			_leader = _leader - [_name];
			_gangarray set[1, _leader];
			format['gangsarray set[%1, %2]', _c, _gangarray] call broadcast;
			player groupchat "you left your gang without a leader! A new one will be appointed.";
			gangleader = false;
			
	
		};
	};
};

gang_manage = {

	private ["_gang","_name","_id","_c","_members","_leader","_gangarray"];


	if(_this select 0 == "") exitWith {
		player groupchat "you must select either yes or no!"
	};

	_bool = call compile format["%1", _this select 0];

	for "_c" from 0 to (count gangsarray - 1) do {
		_gangarray = gangsarray select _c;
		_gang	   = _gangarray select 0;
		_members   = _gangarray select 2;
		_name	   = name player;

		if(_name in _members)then {
			_gangarray set[3, _bool];
			format['gangsarray set[%1, %2]', _c, _gangarray] call broadcast;
			if(_bool)then{player groupchat "civilians can now join your gang"}else{player groupchat "civilians can no longer join your gang"};
		};
	};

};
gangs_war_dialog = {
	if !(createDialog "gangswar") exitWith {hint "Dialog Error!"};
	
	for "_i" from 0 to (count gangsarray -1) do {
		_gang = gangsarray select _i;
		_name = _gang select 0;
		_index = lbAdd [3, format ["%1",_name]];
		lbSetData [3, _index,_name];
	};
};

gangs_declare_war = {
	_gangname = _this select 0;
	if !(typename _gangname == "STRING") then {
		_gangname = format ["%1",_gangname];
	};
	
	for "_i" from 0 to (count gangsarray - 1) do {
		_gangarray = gangsarray select _i;
		_gangname1 = _gangarray select 0;
		_members = _gangarray select 2;
		_gangwars = _gangarray select 4;
		_name = name player;
		
		if (_name in _members) then {
			if (gangwar) exitWith {player groupChat "You have already declared gang war on a gang"};
			if (_gangname == _gangname1) exitWith {player groupChat "You cannot declare gang war on your own gang"};
			if !(_gangname in _gangwars) then {
				_gangwars = _gangwars + [_gangname];
				_gangarray set[4, _gangwars];
				format['gangsarray set[%1, %2]', _i, _gangarray] call broadcast;
				[[], "mp_global_chat_message", [format ["%1 has declared gang war on %2", _gangname1, _gangname]]] call mp_aware_me;
				[[], "mp_screen_message", [format ["%1 has declared gang war on %2", _gangname1, _gangname]]] call mp_aware_me;
				gangwar = true;
			};
		};
	};
};
gangs_end_war = {
			if !(gangwar) exitWith {player groupChat "You are not at gang war"};
			if !(gangleader) exitWith {player groupChat "You are not the gang leader"};
			_gangwars = _gangarray select 4;
			_gangnumber = _this select 0;
			_gangname = gangname420blazeit;
			_gangname1 = gangname1420blazeit;
			_gangwarsremove = _gangwars - [_gangname];
			_gangarray set[4, _gangwarsremove];
			[[], "mp_global_chat_message", [format ["%1 has ended gang war with %2", gangname1420blazeit, gangname420blazeit]]] call mp_aware_me;
			[[], "mp_screen_message", [format ["%1 has ended gang war with %2", gangname1420blazeit, gangname420blazeit]]] call mp_aware_me;
			gangwar = false;
	};
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
	for "_i" from 0 to  ((count gangsarray) - 1) do {
		_gangarray = gangsarray select _i;
		if (isNil "_gangarray") exitWith {};
		_gang_members   = _gangarray select 2;
		{
			_player = [_x] call player_get_player_by_name;
		}foreach _gang_members;
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