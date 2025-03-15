[] spawn {
	private["_uid", "_id", "_playtime"];
	_uid = getPlayerUID player;
	playerUID = getPlayerUID player;
	_cid = player;
	
	// Initialize variables with default values
	if (isNil "player_logins") then {player_logins = 0};
	if (isNil "player_total_playtime") then {player_total_playtime = 0};
	if (isNil "police_agreement") then {police_agreement = false};
	
	// Initialize sendToServer function if not defined
	if (isNil "sendToServer") then {
		sendToServer = {
			accountToServerLoad = _this;
			publicVariableServer 'accountToServerLoad';
		};
	};
	
	// Wait for bank functions to be available
	waitUntil {!isNil "bank_functions_defined"};
	
	uiSleep 2;
	titleText ["Loading Stats","PLAIN"]; // Displays text
	
	if (isNil "iscop" or isNil "isopf" or isNil "isins" or isNil "isciv") exitWith {
		player groupChat "You are glitched. Stats will not be saved";
		statsLoaded = 0;
		stats_loaded = false;
	};
	_playTime = ([player] call ftf_getPlayTime) / 60;
	
	if(iscop) then
	{
		[_uid, _uid, "moneyAccountWest", "NUMBER", _cid] call sendToServer;
		[_uid, _uid, "WeaponsPlayerWest", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "MagazinesPlayerWest", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "LicensesWest", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "InventoryWest", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "privateStorageWest", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "FactoryWest", "ARRAY", _cid] call sendToServer;
		[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "JailTime", "NUMBER", _cid] call sendToServer;
	};

	if(isopf) then
	{
		[_uid, _uid, "moneyAccountEast", "NUMBER", _cid] call sendToServer;
		[_uid, _uid, "WeaponsPlayerEast", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "MagazinesPlayerEast", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "LicensesEast", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "InventoryEast", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "privateStorageEast", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "FactoryEast", "ARRAY", _cid] call sendToServer;
		[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "JailTime", "NUMBER", _cid] call sendToServer;
	};
	if(isins) then
	{
		[_uid, _uid, "moneyAccountRes", "NUMBER", _cid] call sendToServer;
		[_uid, _uid, "WeaponsPlayerRes", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "MagazinesPlayerRes", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "LicensesRes", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "InventoryRes", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "privateStorageRes", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "FactoryRes", "ARRAY", _cid] call sendToServer;
		[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "JailTime", "NUMBER", _cid] call sendToServer;
	};
	
	if(isciv) then
	{
		[_uid, _uid, "moneyAccountCiv", "NUMBER", _cid] call sendToServer;
		[_uid, _uid, "WeaponsPlayerCiv", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "MagazinesPlayerCiv", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "LicensesCiv", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "InventoryCiv", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "privateStorageCiv", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "Fabrikablage1_storage", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "AircraftFactory1_storage", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "Fabrikablage3_storage", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "Fabrikablage4_storage", "ARRAY", _cid] call sendToServer;
		[_uid, _uid, "FactoryCiv", "ARRAY", _cid] call sendToServer;
		[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "JailTime", "NUMBER", _cid] call sendToServer;
	};
	
	[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "logins", "NUMBER", _cid] call sendToServer;
	[format ["%1_persistent",_uid], format ["%1_persistent",_uid], _playTime, "NUMBER", _cid] call sendToServer;
	//END
	
	private["_bank_amount"];
	_bank_amount = [_cid] call bank_get_value;
	if (_bank_amount == 0 ) then {
			diag_log format ["cLoad.sqf"];
			diag_log "Setting Money to default as no stat loaded";
			diag_log format ["Initial Money: %1", _bank_amount];
			[player, startmoneh] call bank_set_value;
			_bank_amount = [player] call bank_get_value;
			diag_log format ["Updated Money: %1", _bank_amount];
	} else {
		diag_log "Money loaded succesfully";
		diag_log format ["Money: %1", _bank_amount]
	};
	
	statsLoaded = 1;
	stats_loaded = true;

	// Wait for all stats to be properly loaded
	waitUntil {!isNil "player_logins" && !isNil "player_total_playtime"};
	
	player_logins = player_logins + 1;
	[format ["%1_persistent",getplayeruid player], format ["%1_persistent",getplayeruid player], "logins", player_logins] call fn_SaveToServer;
	_message = format ["%1 logged into the server. They have logged in %2 times",name player,player_logins];
	[_message,"Login"] call mp_log;
	
	if (isNil "accountToClient") then { accountToClient = []; };

	"accountToClient" addPublicVariableEventHandler {
		_array = _this select 1;
		if (isNil "_array" || typeName _array != "ARRAY" || count _array < 3) exitWith {
			diag_log format["Client Load Error: Invalid data received: %1", _array];
		};
		
		_uid = _array select 0;
		_varName = _array select 1;
		_varValue = _array select 2;
		
		if (isNil "_uid" || isNil "_varName" || isNil "_varValue") exitWith {
			diag_log format["Client Load Error: Missing required data: uid=%1, varName=%2, value=%3", _uid, _varName, _varValue];
		};
		
		// Check if this is a persistent variable
		_isPersistent = _varName in ["JailTime", "logins"];
		_expectedUID = if (_isPersistent) then {
			format["%1_persistent", getPlayerUID player]
		} else {
			getPlayerUID player
		};
		
		if (_uid != _expectedUID) exitWith {
			diag_log format["Client Load Error: UID mismatch for %1. Expected %2, got %3", _varName, _expectedUID, _uid];
		};
		
		diag_log format["Client Load: Setting %1 to %2 for player %3", _varName, _varValue, name player];
		
		switch (_varName) do {
			case "moneyAccountWest";
			case "moneyAccountEast";
			case "moneyAccountRes";
			case "moneyAccountCiv": {
				if (isNil "_varValue" || _varValue == 0) then {
					_varValue = startmoneh;
					diag_log format["Client Load: Using default money %1 for %2", _varValue, _varName];
				};
				diag_log format["Client Load: Setting money value to %1", _varValue];
				[player, parseNumber str _varValue] call bank_set_value;
			};
			default {
				// Handle other variables like inventory, weapons, etc.
				if (_varName in ["WeaponsPlayerCiv", "MagazinesPlayerCiv", "LicensesCiv", "InventoryCiv", 
								"privateStorageCiv", "FactoryCiv", "Fabrikablage1_storage", 
								"AircraftFactory1_storage", "Fabrikablage3_storage", "Fabrikablage4_storage"]) then {
					// These are expected array variables, no need to warn
					diag_log format["Client Load: Setting %1 array data", _varName];
				} else {
					diag_log format["Client Load Warning: Unhandled variable %1", _varName];
				};
			};
		};
	};
};







