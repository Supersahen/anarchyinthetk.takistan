broadcast_make_key = {
	private["_id"];
	_id = _this select 0;
	if (isNil "_id") exitWith {};
	if (typeName _id != "SCALAR") exitWith{};
	format["ISSE_pub_Pstr_%1",_id];
};

broadcast_receive = {
	private["_value","_code"];
	_code = _this select 1;
	if (isNil "_code") exitWith{};
	if (typeName _code != "STRING") exitWith {};
	[] call compile _code;
};

broadcast = {
	private["_code"];
	_code = _this;
	if (isNil "_code") exitWith {};
	if (typeName _code != "STRING") exitWith {};
	
	missionNamespace setVariable [player_broadcast_buffer, _code];
	publicVariable player_broadcast_buffer;
	[] call compile _code;
};

broadcast_server = {
	private["_code"];
	_code = _this;
	if (isNil "_code") exitWith {};
	if (typeName _code != "STRING") exitWith {};
	if (isServer) then {
		[] call compile _code;
	}else{
		missionNamespace setVariable [player_broadcast_buffer, _code];
		publicVariableServer player_broadcast_buffer;
	};
};

broadcast_client = {
	private["_code", "_client"];
	_code = _this select 0;
	_client = _this select 1;
	if (isNil "_code") exitWith {};
	if (typeName _code != "STRING") exitWith {};
	missionNamespace setVariable [c2c_server_broadcast_buffer, [_code, str(_client)]];
	publicVariableServer c2c_server_broadcast_buffer;
};

broadcast_receive_c2c = {
	private["_value","_code","_clientS","_client","_owner"];
	_code = (_this select 1) select 0;
	_clientS = (_this select 1) select 1;
	if (isNil "_code") exitWith{};
	if (typeName _code != "STRING") exitWith {};
	_client = missionNamespace getVariable [_clientS, objNull];
	if (isNull _client) exitwith {};
	_owner = owner _client;
	
	missionNamespace setVariable [player_broadcast_buffer, _code];
	_owner publicVariableClient player_broadcast_buffer;
};

broadcast_setup = {
	private["_player_number", "_player_count"];
	
	_player_number = _this select 0;
	_player_count = _this select 1;
	
	if (isNil "_player_number") exitWith {};
	if (isNil "_player_count") exitWith {};
	if (typeName _player_number != "SCALAR") exitWith {};
	if (typeName _player_count != "SCALAR") exitWith {};
	
	
	player_broadcast_buffer = [_player_number] call broadcast_make_key;
	
	c2c_server_broadcast_buffer = "c2c_server";
	c2c_server_broadcast_buffer addPublicVariableEventHandler {_this call broadcast_receive_c2c;};
	
	private["_i"];
	_i = 0;
	while { _i < _player_count } do {
		private["_variable_name"];
		_variable_name = [_i] call broadcast_make_key;
		missionNamespace setVariable [_variable_name, ""];
		_variable_name addPublicVariableEventHandler { _this call broadcast_receive;};
		_i = _i + 1;
	};
};

[rolenumber, (count playerstringarray)] call broadcast_setup;
