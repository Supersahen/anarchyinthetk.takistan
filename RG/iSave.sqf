/*
 * iSave.sqf - Immediate Save functionality
 * 
 * This script handles immediate (on-demand) saving of player stats.
 * The 'i' in iSave stands for "immediate".
 * 
 * How it works:
 * 1. When called, it packages player data using fn_SaveToServer
 * 2. fn_SaveToServer sends the data to the server via 'accountToServerSave'
 * 3. The server then saves the data to the database using iniDB
 * 
 * Usage:
 * ["money"] call RG_fnc_iSave;     - Saves only money
 * ["inventory"] call RG_fnc_iSave;  - Saves only inventory
 * ["all"] call RG_fnc_iSave;       - Saves all player stats
 * 
 * Parameters passed to fn_SaveToServer:
 * [playerUID, playerUID, variableName, value]
 * 
 * This is different from pSave.sqf which handles periodic automatic saving.
 */

RG_fnc_iSave = {
	if (isNil "statsLoaded") then {statsLoaded = 0;};
	if (not(statsLoaded == 1)) exitWith
	{
		hint "Your stats have not loaded and thus will not be saved!";
	};

	if (isNil "_this" || typeName _this != "STRING") exitWith {};
	_varName = _this;

	// Helper function to format inventory data
	_format_inventory = {
		private["_inventory"];
		_inventory = [player] call player_get_inventory;
		{
			if (typeName _x == "ARRAY" && count _x >= 2) then {
				_x set [1, [_x select 1] call encode_number];
			};
		} forEach _inventory;
		diag_log format["Saving inventory for %1: %2", name player, _inventory];
		_inventory
	};

	// Helper function to format storage data
	_format_storage = {
		private["_storage_name", "_storage"];
		_storage_name = _this;
		_storage = [player, _storage_name] call player_get_array;
		diag_log format["Saving storage %1 for %2: %3", _storage_name, name player, _storage];
		_storage
	};

	// Add notification for what's being saved
	private["_saveMsg"];
	_saveMsg = switch(_varName) do {
		case "money": {"Money"};
		case "weapons": {"Weapons"};
		case "magazines": {"Magazines"};
		case "licenses": {"Licenses"};
		case "inventory": {"Inventory"};
		case "privateStorage": {"Private Storage"};
		case "factory": {"Factory"};
		case "all": {"All Stats"};
		default {_varName};
	};
	systemChat format["[STATS SAVED] %1", _saveMsg];

	if(playerSide == west) then
	{
		if (_varName == "money") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountWest", ([player] call bank_get_value)] call fn_SaveToServer;
		};
		if (_varName == "weapons") then {
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerWest", weapons player] call fn_SaveToServer;
		};
		if (_varName == "magazines") then {
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerWest", magazines player] call fn_SaveToServer;
		};
		if (_varName == "licenses") then {
			[getPlayerUID player, getPlayerUID player, "LicensesWest", INV_LicenseOwner] call fn_SaveToServer;
		};
		if (_varName == "inventory") then {
			[getPlayerUID player, getPlayerUID player, "InventoryWest", call _format_inventory] call fn_SaveToServer;
		};
		if (_varName == "privateStorage") then {
			[getPlayerUID player, getPlayerUID player, "privateStorageWest", "private_storage" call _format_storage] call fn_SaveToServer;
		};
		if (_varName == "factory") then {
			[getPlayerUID player, getPlayerUID player, "FactoryWest", INV_Fabrikowner] call fn_SaveToServer;
		};
		if (_varName == "all") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountWest", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerWest", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerWest", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesWest", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryWest", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageWest", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryWest", INV_Fabrikowner] call fn_SaveToServer;
		};
	};
	if(playerSide == east) then
	{
		if (_varName == "money") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountEast", ([player] call bank_get_value)] call fn_SaveToServer;
		};
		if (_varName == "weapons") then {
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerEast", weapons player] call fn_SaveToServer;
		};
		if (_varName == "magazines") then {
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerEast", magazines player] call fn_SaveToServer;
		};
		if (_varName == "licenses") then {
			[getPlayerUID player, getPlayerUID player, "LicensesEast", INV_LicenseOwner] call fn_SaveToServer;
		};
		if (_varName == "inventory") then {
			[getPlayerUID player, getPlayerUID player, "InventoryEast", call _format_inventory] call fn_SaveToServer;
		};
		if (_varName == "privateStorage") then {
			[getPlayerUID player, getPlayerUID player, "privateStorageEast", "private_storage" call _format_storage] call fn_SaveToServer;
		};
		if (_varName == "factory") then {
			[getPlayerUID player, getPlayerUID player, "FactoryEast", INV_Fabrikowner] call fn_SaveToServer;
		};
		if (_varName == "all") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountEast", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerEast", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerEast", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesEast", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryEast", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageEast", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryEast", INV_Fabrikowner] call fn_SaveToServer;
		};
	};
	if(playerSide == resistance) then
	{
		if (_varName == "money") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountRes", ([player] call bank_get_value)] call fn_SaveToServer;
		};
		if (_varName == "weapons") then {
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerRes", weapons player] call fn_SaveToServer;
		};
		if (_varName == "magazines") then {
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerRes", magazines player] call fn_SaveToServer;
		};
		if (_varName == "licenses") then {
			[getPlayerUID player, getPlayerUID player, "LicensesRes", INV_LicenseOwner] call fn_SaveToServer;
		};
		if (_varName == "inventory") then {
			[getPlayerUID player, getPlayerUID player, "InventoryRes", call _format_inventory] call fn_SaveToServer;
		};
		if (_varName == "privateStorage") then {
			[getPlayerUID player, getPlayerUID player, "privateStorageRes", "private_storage" call _format_storage] call fn_SaveToServer;
		};
		if (_varName == "factory") then {
			[getPlayerUID player, getPlayerUID player, "FactoryRes", INV_Fabrikowner] call fn_SaveToServer;
		};
		if (_varName == "all") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountRes", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerRes", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerRes", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesRes", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryRes", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageRes", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryRes", INV_Fabrikowner] call fn_SaveToServer;
		};
	};
	if(playerSide == civilian) then
	{
		if (_varName == "money") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountCiv", ([player] call bank_get_value)] call fn_SaveToServer;
		};
		if (_varName == "weapons") then {
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerCiv", weapons player] call fn_SaveToServer;
		};
		if (_varName == "magazines") then {
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerCiv", magazines player] call fn_SaveToServer;
		};
		if (_varName == "licenses") then {
			[getPlayerUID player, getPlayerUID player, "LicensesCiv", INV_LicenseOwner] call fn_SaveToServer;
		};
		if (_varName == "inventory") then {
			[getPlayerUID player, getPlayerUID player, "InventoryCiv", call _format_inventory] call fn_SaveToServer;
		};
		if (_varName == "privateStorage") then {
			[getPlayerUID player, getPlayerUID player, "privateStorageCiv", "private_storage" call _format_storage] call fn_SaveToServer;
		};
		if (_varName == "factory") then {
			[getPlayerUID player, getPlayerUID player, "Fabrikablage1_storage", "Fabrikablage1" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "AircraftFactory1_storage", "AircraftFactory1" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage3_storage", "Fabrikablage3" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage4_storage", "Fabrikablage4" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryCiv", INV_Fabrikowner] call fn_SaveToServer;
		};
		if (_varName == "all") then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountCiv", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerCiv", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerCiv", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesCiv", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryCiv", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageCiv", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage1_storage", "Fabrikablage1" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "AircraftFactory1_storage", "AircraftFactory1" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage3_storage", "Fabrikablage3" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage4_storage", "Fabrikablage4" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryCiv", INV_Fabrikowner] call fn_SaveToServer;
		};
	};
};

publicVariable "RG_fnc_iSave";
