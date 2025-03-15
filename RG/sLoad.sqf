//===========================================================================
_loadFromDBClient =
"
	_array = _this;
	_uid = _array select 0;
	_uid_persist = format ['%1_persistent',getplayeruid player];
	
	if ((_uid != getplayeruid player) and (_uid != _uid_persist)) exitWith {};
	
	_varName = _array select 1;
	_varValue = _array select 2;
	if(isNil '_varValue') exitWith {};
	diag_log format['STAT INFO -> UID: %1 - VARNAME: %2 - VARVALUE: %3',_uid,_varName,_varValue];

	if (isNil 'iscop' or isNil 'isopf' or isNil 'isins' or isNil 'isciv') exitWith {};
	
	// Function to handle inventory setting
	_handle_inventory = {
		private['_value'];
		_value = _this;
		if (typeName _value == 'ARRAY') then {
			private['_formatted_inventory'];
			_formatted_inventory = [];
			{
				if (typeName _x == 'ARRAY' && count _x >= 2) then {
					private['_item', '_amount'];
					_item = _x select 0;
					_amount = if (typeName (_x select 1) == 'SCALAR') then {
						[_x select 1] call encode_number
					} else {
						_x select 1
					};
					_formatted_inventory pushBack [_item, _amount];
				};
			} forEach _value;
			[player, _formatted_inventory] call player_set_inventory;
			diag_log format['Inventory set for %1: %2', name player, _formatted_inventory];
		};
	};

	// Function to handle storage setting
	_handle_storage = {
		private['_value', '_storage_name'];
		_value = _this select 0;
		_storage_name = _this select 1;
		if (typeName _value == 'ARRAY') then {
			[player, _storage_name, _value] call player_set_array;
			diag_log format['Storage %1 set for %2: %3', _storage_name, name player, _value];
		};
	};
	
	if(iscop) then {
		if(_varName == 'moneyAccountWest') then {
			if(_varValue == 0) then {
				[player, startmoneh] call bank_set_value;
			} else {
				[player, _varValue] call bank_set_value;
			};
		};
		if(_varName == 'WeaponsplayerWest') then {{player addWeapon _x} forEach _varValue;};
		if(_varName == 'MagazinesplayerWest') then {{player addMagazine _x} forEach _varValue;};
		if(_varName == 'LicensesWest') then {INV_LicenseOwner = _varValue;};
		if(_varName == 'InventoryWest') then {_varValue call _handle_inventory;};
		if(_varName == 'privateStorageWest') then {[_varValue, 'private_storage'] call _handle_storage;};
		if(_varName == 'FactoryWest') then {INV_Fabrikowner = _varValue;};
		if(_varName == 'JailTime') then {player_jailtime = _varValue;};
	};
	
	if(isopf) then {
		if(_varName == 'moneyAccountEast') then {
			if(_varValue == 0) then {
				[player, startmoneh] call bank_set_value;
			} else {
				[player, _varValue] call bank_set_value;
			};
		};
		if(_varName == 'WeaponsplayerEast') then {{player addWeapon _x} forEach _varValue;};
		if(_varName == 'MagazinesplayerEast') then {{player addMagazine _x} forEach _varValue;};
		if(_varName == 'LicensesEast') then {INV_LicenseOwner = _varValue;};
		if(_varName == 'InventoryEast') then {_varValue call _handle_inventory;};
		if(_varName == 'privateStorageEast') then {[_varValue, 'private_storage'] call _handle_storage;};
		if(_varName == 'FactoryEast') then {INV_Fabrikowner = _varValue;};
		if(_varName == 'JailTime') then {player_jailtime = _varValue;};
	};
	
	if(isins) then {
		if(_varName == 'moneyAccountRes') then {
			if(_varValue == 0) then {
				[player, startmoneh] call bank_set_value;
			} else {
				[player, _varValue] call bank_set_value;
			};
		};
		if(_varName == 'WeaponsplayerRes') then {{player addWeapon _x} forEach _varValue;};
		if(_varName == 'MagazinesplayerRes') then {{player addMagazine _x} forEach _varValue;};
		if(_varName == 'LicensesRes') then {INV_LicenseOwner = _varValue;};
		if(_varName == 'InventoryRes') then {_varValue call _handle_inventory;};
		if(_varName == 'privateStorageRes') then {[_varValue, 'private_storage'] call _handle_storage;};
		if(_varName == 'FactoryRes') then {INV_Fabrikowner = _varValue;};
		if(_varName == 'lineIncrement') then {player setVariable ['lineNumber',_varValue,true];};
		if(_varName == 'gear_un') then {load_gear = _varValue};
		if(_varName == 'JailTime') then {player_jailtime = _varValue;};
	};
	
	if(isciv) then {
		if(_varName == 'moneyAccountCiv') then {
			if(_varValue == 0) then {
				[player, startmoneh] call bank_set_value;
			} else {
				[player, _varValue] call bank_set_value;
			};
		};
		if(_varName == 'WeaponsplayerCiv') then {{player addWeapon _x} forEach _varValue;};
		if(_varName == 'MagazinesplayerCiv') then {{player addMagazine _x} forEach _varValue;};
		if(_varName == 'LicensesCiv') then {INV_LicenseOwner = _varValue;};
		if(_varName == 'InventoryCiv') then {_varValue call _handle_inventory;};
		if(_varName == 'privateStorageCiv') then {[_varValue, 'private_storage'] call _handle_storage;};
		if(_varName == 'Fabrikablage1_storage') then {[_varValue, 'Fabrikablage1'] call _handle_storage;};
		if(_varName == 'AircraftFactory1_storage') then {[_varValue, 'AircraftFactory1'] call _handle_storage;};
		if(_varName == 'Fabrikablage3_storage') then {[_varValue, 'Fabrikablage3'] call _handle_storage;};
		if(_varName == 'Fabrikablage4_storage') then {[_varValue, 'Fabrikablage4'] call _handle_storage;};
		if(_varName == 'FactoryCiv') then {INV_Fabrikowner = _varValue;};
		if(_varName == 'JailTime') then {player_jailtime = _varValue;};
	};
	
	if(_varName == 'logins') then {player_logins = _varValue};
	if(_varName == 'player_total_playtime') then {player_total_playtime = _varValue};
	if(_varName == 'online_during_hacker') then {online_during_hacker = _varValue};
";

loadFromDBClient = compile _loadFromDBClient;
//===========================================================================
_sendToServer =
"
	accountToServerLoad = _this;
	publicVariableServer 'accountToServerLoad';
";

sendToServer = compile _sendToServer;
//===========================================================================
"accountToClient" addPublicVariableEventHandler
{
	(_this select 1) spawn loadFromDBClient;
};
//===========================================================================

statFunctionsLoaded = 1;
