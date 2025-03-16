[] spawn {
	private["_uid", "_id", "_playtime"];
	_uid = getPlayerUID player;
	playerUID = getPlayerUID player;
	_cid = player;
	
	// Initialize variables with default values
	if (isNil "player_logins") then {player_logins = 0};
	if (isNil "player_total_playtime") then {player_total_playtime = 0};
	
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
			diag_log format ["Setting Money to default as no stat loaded - Initial Money: %1", _bank_amount];
			[player, startmoneh] call bank_set_value;
			_bank_amount = [player] call bank_get_value;
			diag_log format ["Updated Money: %1", _bank_amount];
	} else {
		diag_log format ["Money loaded succesfully: %1", _bank_amount]
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
					diag_log format["Client Load: Using default money %1", _varValue];
				};
				diag_log format["Client Load: Setting money value to %1", _varValue];
				[player, parseNumber str _varValue] call bank_set_value;
			};
			
			case "WeaponsPlayerWest";
			case "WeaponsPlayerEast";
			case "WeaponsPlayerRes";
			case "WeaponsPlayerCiv": {
				removeAllWeapons player;
				{
					player addWeapon _x;
					diag_log format["Client Load: Added weapon %1", _x];
				} forEach _varValue;
			};
			
			case "MagazinesPlayerWest";
			case "MagazinesPlayerEast";
			case "MagazinesPlayerRes";
			case "MagazinesPlayerCiv": {
				// Clear existing magazines one by one
				{
					player removeMagazine _x;
				} forEach (magazines player);
				
				// Add new magazines
				if (!isNil "_varValue" && typeName _varValue == "ARRAY") then {
					{
						if (!isNil "_x" && typeName _x == "STRING") then {
							player addMagazine _x;
							diag_log format["Client Load: Added magazine %1", _x];
						};
					} forEach _varValue;
					
					// Verify magazines were actually added
					private "_loadedMags";
					_loadedMags = magazines player;
					diag_log format["Client Load: Final magazine count: %1", count _loadedMags];
					diag_log format["Client Load: Final magazines: %1", _loadedMags];
				} else {
					diag_log format["Client Load Error: Invalid magazine data: %1", _varValue];
				};
			};
			
			case "LicensesWest";
			case "LicensesEast";
			case "LicensesRes";
			case "LicensesCiv": {
				if (!isNil "_varValue" && typeName _varValue == "ARRAY") then {
					private "_oldLicenses";
					_oldLicenses = [player, "INV_LicenseOwner"] call player_get_array;
					
					[player, "INV_LicenseOwner", _varValue] call player_set_array;
					diag_log format["Client Load: Setting licenses from %1 to %2", _oldLicenses, _varValue];
					
					// Verify licenses were set correctly
					private "_newLicenses";
					_newLicenses = [player, "INV_LicenseOwner"] call player_get_array;
					if (str _newLicenses != str _varValue) then {
						diag_log format["Client Load Error: License verification failed. Expected %1, got %2", _varValue, _newLicenses];
					} else {
						diag_log format["Client Load: Licenses set successfully to %1", _newLicenses];
					};
				} else {
					diag_log format["Client Load Error: Invalid license data: %1", _varValue];
				};
			};
			
			case "InventoryWest";
			case "InventoryEast";
			case "InventoryRes";
			case "InventoryCiv": {
				[player, _varValue] call player_set_inventory;
				diag_log format["Client Load: Set inventory to %1", _varValue];
			};
			
			case "privateStorageWest";
			case "privateStorageEast";
			case "privateStorageRes";
			case "privateStorageCiv": {
				[player, "private_storage", _varValue] call player_set_array;
				diag_log format["Client Load: Set private storage to %1", _varValue];
			};
			
			case "FactoryWest";
			case "FactoryEast";
			case "FactoryRes";
			case "FactoryCiv": {
				INV_Fabrikowner = _varValue;
				diag_log format["Client Load: Set factory ownership to %1", _varValue];
			};
			
			case "Fabrikablage1_storage";
			case "AircraftFactory1_storage";
			case "Fabrikablage3_storage";
			case "Fabrikablage4_storage": {
				private "_storageName";
				_storageName = switch (_varName) do {
					case "Fabrikablage1_storage": {"Fabrikablage1"};
					case "AircraftFactory1_storage": {"AircraftFactory1"};
					case "Fabrikablage3_storage": {"Fabrikablage3"};
					case "Fabrikablage4_storage": {"Fabrikablage4"};
					default {""}
				};
				if (_storageName != "") then {
					[player, _storageName, _varValue] call player_set_array;
					diag_log format["Client Load: Set %1 to %2", _storageName, _varValue];
				};
			};
			
			case "JailTime": {
				player_jailtime = _varValue;
				diag_log format["Client Load: Set jail time to %1", _varValue];
			};
			
			case "logins": {
				player_logins = _varValue;
				diag_log format["Client Load: Set login count to %1", _varValue];
			};
			
			default {
				diag_log format["Client Load Warning: Unhandled variable %1", _varName];
			};
		};
	};
};







