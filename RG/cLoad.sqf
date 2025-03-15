/*
 * cLoad.sqf - Client Load Script
 * 
 * This script handles loading and initializing player data on the client side.
 * It works in conjunction with sLoad.sqf (server load) and SaveVar.sqf.
 * 
 * Loading Process:
 * 1. Initializes basic variables (playtime)
 * 2. Loads persistent variables first (logins, playtime, online_during_hacker)
 * 3. Updates and saves current session playtime
 * 4. Loads faction-specific data based on player type (cop, opf, ins, civ):
 *    - Money account
 *    - Weapons and magazines
 *    - Licenses
 *    - Inventory
 *    - Private storage
 *    - Factory ownership
 *    - Jail time (if applicable)
 * 5. Handles special storage for civilians (factory storage)
 * 6. Updates login count and saves it
 * 
 * Key Features:
 * - Validates loaded data before applying
 * - Initializes empty/default values if data is missing
 * - Maintains faction-specific variable separation
 * - Comprehensive error logging
 * - Proper type checking for all variables
 * 
 * Variables Handled:
 * - player_total_playtime: Total time played
 * - player_logins: Number of times logged in
 * - INV_LicenseOwner: Player's licenses
 * - private_storage: Player's private storage
 * - INV_Fabrikowner: Factory ownership
 * - player_jailtime: Time remaining in jail
 * - online_during_hacker: Hacker presence flag
 * 
 * Dependencies:
 * - bank_functions_defined
 * - ftf_getPlayTime
 * - player_set_inventory
 * - player_set_array
 * - fn_SaveToServer
 */

[] spawn {
	private["_uid", "_id", "_playtime"];
	_uid = getPlayerUID player;
	playerUID = getPlayerUID player;
	_cid = player;
	
	// Initialize variables with default values
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

	// Request global persistent variables first
	{
		[format ["%1_persistent",_uid], format ["%1_persistent",_uid], _x, "NUMBER", _cid] call sendToServer;
	} forEach ["logins", "player_total_playtime", "online_during_hacker"];
	
	// Wait for playtime to be loaded
	waitUntil {!isNil "player_total_playtime"};
	
	// Update and save playtime
	player_total_playtime = player_total_playtime + _playTime;
	[format ["%1_persistent",getplayeruid player], format ["%1_persistent",getplayeruid player], "player_total_playtime", player_total_playtime] call fn_SaveToServer;
	diag_log format["Updated total playtime for %1 to %2", name player, player_total_playtime];

	_request_common_vars = {
		private["_faction", "_uid", "_cid"];
		_faction = _this select 0;
		_uid = _this select 1;
		_cid = _this select 2;

		// Request money account
		[_uid, _uid, format["moneyAccount%1", _faction], "NUMBER", _cid] call sendToServer;
		
		// Request weapons
		[_uid, _uid, format["WeaponsPlayer%1", _faction], "ARRAY", _cid] call sendToServer;
		
		// Request magazines
		[_uid, _uid, format["MagazinesPlayer%1", _faction], "ARRAY", _cid] call sendToServer;
		
		// Request licenses
		[_uid, _uid, format["Licenses%1", _faction], "ARRAY", _cid] call sendToServer;
		
		// Request inventory
		[_uid, _uid, format["Inventory%1", _faction], "ARRAY", _cid] call sendToServer;
		
		// Request private storage
		[_uid, _uid, format["privateStorage%1", _faction], "ARRAY", _cid] call sendToServer;
		
		// Request factory ownership
		[_uid, _uid, format["Factory%1", _faction], "ARRAY", _cid] call sendToServer;
		
		// Request jail time (persistent)
		[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "JailTime", "NUMBER", _cid] call sendToServer;
	};

	_request_special_vars = {
		private["_faction", "_uid", "_cid"];
		_faction = _this select 0;
		_uid = _this select 1;
		_cid = _this select 2;

		// Handle civilian-specific storage
		if (_faction == "Civ") then {
			{
				[_uid, _uid, _x, "ARRAY", _cid] call sendToServer;
			} forEach [
				"Fabrikablage1_storage",
				"AircraftFactory1_storage",
				"Fabrikablage3_storage",
				"Fabrikablage4_storage"
			];
		};
	};
	
	// Request faction-specific variables
	if(iscop) then {
		["West", _uid, _cid] call _request_common_vars;
		["West", _uid, _cid] call _request_special_vars;
	};
	
	if(isopf) then {
		["East", _uid, _cid] call _request_common_vars;
		["East", _uid, _cid] call _request_special_vars;
	};
	
	if(isins) then {
		["Res", _uid, _cid] call _request_common_vars;
		["Res", _uid, _cid] call _request_special_vars;
	};
	
	if(isciv) then {
		["Civ", _uid, _cid] call _request_common_vars;
		["Civ", _uid, _cid] call _request_special_vars;
	};
	
	diag_log format ["cLoad.sqf: Loading stats for %1 (%2)", name player, _uid];
	
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
	
	// Request persistent logins first
	[format ["%1_persistent",_uid], format ["%1_persistent",_uid], "logins", "NUMBER", _cid] call sendToServer;
	
	// Wait a bit for the login count to be received
	uiSleep 1;
	
	// Initialize login count if it wasn't loaded
	if (isNil "player_logins") then {
		player_logins = 0;
		diag_log "No previous login count found, starting from 0";
	};
	
	// Increment and save the login count
	player_logins = player_logins + 1;
	[format ["%1_persistent",getplayeruid player], format ["%1_persistent",getplayeruid player], "logins", player_logins] call fn_SaveToServer;
	_message = format ["%1 logged into the server. They have logged in %2 times",name player,player_logins];
	[_message,"Login"] call mp_log;
	diag_log format["Updated login count for %1 to %2", name player, player_logins];
	
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
		_isPersistent = _varName in ["JailTime", "logins", "player_total_playtime", "online_during_hacker"];
		_expectedUID = if (_isPersistent) then {
			format["%1_persistent", getPlayerUID player]
		} else {
			getPlayerUID player
		};
		
		if (_uid != _expectedUID) exitWith {
			diag_log format["Client Load Error: UID mismatch for %1. Expected %2, got %3", _varName, _expectedUID, _uid];
		};
		
		diag_log format["Client Load: Setting %1 to %2 for player %3", _varName, _varValue, name player];

		// Determine player's faction suffix
		_playerFaction = switch (true) do {
			case (iscop): {"West"};
			case (isopf): {"East"};
			case (isins): {"Res"};
			case (isciv): {"Civ"};
			default {""};
		};

		// Check if this variable belongs to the player's faction
		_isFactionVar = false;
		if (_playerFaction != "") then {
			_isFactionVar = (_varName find _playerFaction) != -1;
		};

		// Only process faction-specific variables if they match the player's faction
		if (_isPersistent || _isFactionVar) then {
			switch (true) do {
				// Handle money accounts
				case (_varName == format["moneyAccount%1", _playerFaction]): {
					if (isNil "_varValue" || _varValue == 0) then {
						_varValue = startmoneh;
						diag_log format["Client Load: Using default money %1 for %2", _varValue, _varName];
					};
					diag_log format["Client Load: Setting money value to %1", _varValue];
					[player, parseNumber str _varValue] call bank_set_value;
				};
				
				// Handle weapons
				case (_varName == format["WeaponsPlayer%1", _playerFaction]): {
					removeAllWeapons player;
					{
						player addWeapon _x;
					} forEach _varValue;
					diag_log format["Client Load: Added weapons for %1: %2", name player, _varValue];
				};
				
				// Handle magazines
				case (_varName == format["MagazinesPlayer%1", _playerFaction]): {
					{
						player addMagazine _x;
					} forEach _varValue;
					diag_log format["Client Load: Added magazines for %1: %2", name player, _varValue];
				};
				
				// Handle licenses
				case (_varName == format["Licenses%1", _playerFaction]): {
					INV_LicenseOwner = _varValue;
					diag_log format["Client Load: Set licenses for %1: %2", name player, _varValue];
				};
				
				// Handle inventory
				case (_varName == format["Inventory%1", _playerFaction]): {
					if (typeName _varValue == "ARRAY") then {
						[player, _varValue] call player_set_inventory;
						diag_log format["Client Load: Set inventory for %1: %2", name player, _varValue];
					};
				};
				
				// Handle private storage
				case (_varName == format["privateStorage%1", _playerFaction]): {
					if (typeName _varValue == "ARRAY") then {
						player setVariable ["private_storage", _varValue, true];
						diag_log format["Client Load: Set private storage for %1: %2", name player, _varValue];
					} else {
						player setVariable ["private_storage", [], true];
						diag_log format["Client Load: Initialized empty private storage for %1", name player];
					};
				};
				
				// Handle factory ownership
				case (_varName == format["Factory%1", _playerFaction]): {
					INV_Fabrikowner = _varValue;
					diag_log format["Client Load: Set factory ownership for %1: %2", name player, _varValue];
				};

				// Handle civilian-specific storage
				case (isciv && (_varName in ["Fabrikablage1_storage", "AircraftFactory1_storage", "Fabrikablage3_storage", "Fabrikablage4_storage"])): {
					if (typeName _varValue == "ARRAY") then {
						player setVariable [_varName, _varValue, true];
						diag_log format["Client Load: Set storage %1 for %2: %3", _varName, name player, _varValue];
					} else {
						player setVariable [_varName, [], true];
						diag_log format["Client Load: Initialized empty storage %1 for %2", _varName, name player];
					};
				};
				
				// Handle jail time
				case (_varName == "JailTime"): {
					player_jailtime = _varValue;
					diag_log format["Client Load: Set jail time for %1: %2", name player, _varValue];
				};
				
				// Handle logins
				case (_varName == "logins"): {
					player_logins = _varValue;
					diag_log format["Client Load: Set logins for %1: %2", name player, _varValue];
				};
				
				// Handle play time
				case (_varName == "player_total_playtime"): {
					player_total_playtime = _varValue;
					diag_log format["Client Load: Set total play time for %1: %2", name player, _varValue];
				};
				
				// Handle online during hacker
				case (_varName == "online_during_hacker"): {
					online_during_hacker = _varValue;
					diag_log format["Client Load: Set online during hacker for %1: %2", name player, _varValue];
				};
				
				default {
					diag_log format["Client Load Warning: Unhandled variable %1", _varName];
				};
			};
		} else {
			diag_log format["Client Load Warning: Ignoring variable %1 - does not match player faction %2", _varName, _playerFaction];
		};
	};
};







