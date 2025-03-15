/*
 * pSave.sqf - Periodic Save functionality
 * 
 * This script handles automatic periodic saving of all player stats.
 * The 'p' in pSave stands for "periodic".
 * 
 * How it works:
 * 1. Runs in a continuous loop every 120 seconds
 * 2. For each stat, calls fn_SaveToServer with data
 * 3. fn_SaveToServer sends the data to the server via 'accountToServerSave'
 * 4. The server then saves the data to the database using iniDB
 * 
 * The script runs in a continuous loop:
 * - Waits for stats to be loaded (statsLoaded == 1)
 * - Every 120 seconds (100 + 20 sleep) saves all player stats
 * - Shows "[STATS SAVED]" message to player when saving occurs
 * 
 * Parameters passed to fn_SaveToServer:
 * [playerUID, playerUID, variableName, value]
 * 
 * This is different from iSave.sqf which handles immediate on-demand saving.
 */

if (isNil "statsLoaded") then {statsLoaded = 0;};
waitUntil {statsLoaded == 1;};
while {true} do
{
	uisleep 100;
	systemChat "[STATS SAVED]";
	uisleep 20;
	
	if (statsLoaded == 1) then {
		
		if (isNil "iscop" or isNil "isopf" or isNil "isins" or isNil "isciv") exitWith {player groupChat "You are glitched. Stats will not be saved"};

		// Helper function to format inventory data
		_format_inventory = {
			private["_inventory"];
			_inventory = [player] call player_get_inventory;
			{
				if (typeName _x == "ARRAY" && count _x >= 2) then {
					_x set [1, [_x select 1] call encode_number];
				};
			} forEach _inventory;
			diag_log format["Periodic save - Saving inventory for %1: %2", name player, _inventory];
			_inventory
		};

		// Helper function to format storage data
		_format_storage = {
			private["_storage_name", "_storage"];
			_storage_name = _this;
			_storage = [player, _storage_name] call player_get_array;
			diag_log format["Periodic save - Saving storage %1 for %2: %3", _storage_name, name player, _storage];
			_storage
		};
		
		if (iscop) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountWest", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerWest", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerWest", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesWest", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryWest", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageWest", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryWest", INV_Fabrikowner] call fn_SaveToServer;
		};
		if (isopf) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountEast", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerEast", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerEast", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesEast", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryEast", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageEast", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryEast", INV_Fabrikowner] call fn_SaveToServer;
		};
		
		if (isins) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountRes", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerRes", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerRes", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesRes", INV_LicenseOwner] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryRes", call _format_inventory] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageRes", "private_storage" call _format_storage] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryRes", INV_Fabrikowner] call fn_SaveToServer;
		};
		
		if (isciv) then {
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
