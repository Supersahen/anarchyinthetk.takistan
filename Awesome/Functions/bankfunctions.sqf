if (!isNil "bank_functions_defined") exitWith {};

bank_get_value = {
	private["_player"];
	_player = _this select 0;
	if (not([_player] call player_human)) exitWith {0};
	
	private ["_value"];
	_value = [_player, "bankaccount"] call player_get_array;
	_value = ([_value] call decode_number);
	//diag_log format["bank_get_value: bankaccount = %1, _value = %2", bankaccount, _value];
	_value
};

bank_set_value = {
	private["_player", "_value"];
	_player = _this select 0;
	_value = _this select 1;
	
	diag_log format["bank_set_value called with player: %1, value: %2", _player, _value];
	
	if (not([_player] call player_human)) exitWith {
		diag_log "bank_set_value: player check failed";
	};
	if (isNil "_value") exitWith {
		diag_log "bank_set_value: value is nil";
	};
	if (typeName _value != "SCALAR") exitWith {
		diag_log format["bank_set_value: value is wrong type: %1", typeName _value];
	};
	
	if (_value < 0) then {_value = 0};
	_value = [_value] call encode_number;
	[_player, "bankaccount", _value] call player_set_array;
	diag_log format["bank_set_value: bankaccount = %1, _value = %2", bankaccount, _value];
};


bank_transaction = {
	private["_player", "_value"];
	_player = _this select 0;
	_value = _this select 1;
	
	if (not([_player] call player_human)) exitWith {0};
	if (isNil "_value") exitWith {0};
	if (typeName _value != "SCALAR") exitWith {0};
	

	private["_cvalue"];
	_cvalue = [_player] call bank_get_value;
	_cvalue = _cvalue + (if(_value < 0)then{_value min _cvalue}else{_value});
	[_player, _cvalue] call bank_set_value;
	_cvalue
};

bank_functions_defined = true;