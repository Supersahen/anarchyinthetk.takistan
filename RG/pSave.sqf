if (isNil "statsLoaded") then {statsLoaded = 0;};
waitUntil {statsLoaded == 1;};
while {true} do
{
	uisleep 100;
	if (statsLoaded == 1) then {
		
		if (isNil "iscop" or isNil "isopf" or isNil "isins" or isNil "isciv") exitWith {player groupChat "You are glitched. Stats will not be saved"};
		if (iscop) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountWest", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerWest", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerWest", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesWest", ([player, "INV_LicenseOwner"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryWest", ([player] call player_get_inventory)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageWest", ([player, "private_storage"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryWest", INV_Fabrikowner] call fn_SaveToServer;
		};
		if (isopf) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountEast", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerEast", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerEast", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesEast", ([player, "INV_LicenseOwner"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryEast", ([player] call player_get_inventory)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageEast", ([player, "private_storage"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryEast", INV_Fabrikowner] call fn_SaveToServer;
		};
		
		if (isins) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountRes", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerRes", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerRes", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesRes", ([player, "INV_LicenseOwner"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryRes", ([player] call player_get_inventory)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageRes", ([player, "private_storage"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryRes", INV_Fabrikowner] call fn_SaveToServer;
		};
		
		if (isciv) then {
			[getPlayerUID player, getPlayerUID player, "moneyAccountCiv", ([player] call bank_get_value)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "WeaponsPlayerCiv", weapons player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "MagazinesPlayerCiv", magazines player] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "LicensesCiv", ([player, "INV_LicenseOwner"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "InventoryCiv", ([player] call player_get_inventory)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "privateStorageCiv", ([player, "private_storage"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage1_storage", ([player, "Fabrikablage1"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "AircraftFactory1_storage", ([player, "AircraftFactory1"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage3_storage", ([player, "Fabrikablage3_storage"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "Fabrikablage4_storage", ([player, "Fabrikablage4_storage"] call player_get_array)] call fn_SaveToServer;
			[getPlayerUID player, getPlayerUID player, "FactoryCiv", INV_Fabrikowner] call fn_SaveToServer;
		};
	};
	systemChat "[STATS SAVED]";
	uisleep 20;
};
