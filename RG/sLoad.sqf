/*
 * sLoad.sqf - Server Load functionality
 * 
 * This script handles loading player stats from the database to the client.
 * It works in conjunction with cLoad.sqf (client load) and SaveVar.sqf.
 * 
 * The loading process:
 * 1. Client requests stats via cLoad.sqf using sendToServer function
 * 2. Server receives request via accountToServerLoad variable
 * 3. Server loads data from database using iniDB
 * 4. Server sends data back to client via accountToClient variable
 * 5. This script (sLoad.sqf) receives the data and processes it
 * 
 * For each faction (cop, opf, ins, civ) it loads:
 * - Money account
 * - Weapons and magazines
 * - Licenses
 * - Inventory (with proper encoding of amounts)
 * - Private storage
 * - Factory ownership
 * 
 * The script includes helper functions:
 * - _handle_inventory: Formats and validates inventory data
 * - _handle_storage: Formats and validates storage data
 * 
 * All operations are logged for debugging purposes.
 */

//===========================================================================
_loadFromDBClient = "
    private['_array','_uid','_uid_persist','_varName','_varValue'];
    _array = _this;
    _uid = _array select 0;
    _uid_persist = format['%1_persistent',getplayeruid player];
    if((_uid != getplayeruid player) && (_uid != _uid_persist)) then {
        diag_log format['Client Load Error: UID mismatch for %1. Expected %2, got %3',name player,getplayeruid player,_uid];
        exitWith {};
    };
    _varName = _array select 1;
    _varValue = _array select 2;
    if(isNil '_varValue') then {
        diag_log format['Client Load Warning: Nil value for %1, initializing empty',_varName];
        _varValue = switch(_varName) do {
            case 'privateStorageWest';
            case 'privateStorageEast';
            case 'privateStorageRes';
            case 'privateStorageCiv': {[]};
            case 'InventoryWest';
            case 'InventoryEast';
            case 'InventoryRes';
            case 'InventoryCiv': {[]};
            default {_varValue};
        };
    };
    diag_log format['STAT INFO -> UID: %1 - VARNAME: %2 - VARVALUE: %3',_uid,_varName,_varValue];
    if(isNil 'iscop' || isNil 'isopf' || isNil 'isins' || isNil 'isciv') exitWith {
        diag_log 'Client Load Error: Faction variables not defined';
    };
    _handle_inventory = {
        private['_value'];
        _value = _this;
        if(typeName _value == 'ARRAY') then {
            private['_formatted_inventory'];
            _formatted_inventory = [];
            {
                if(typeName _x == 'ARRAY' && count _x >= 2) then {
                    private['_item','_amount'];
                    _item = _x select 0;
                    _amount = if(typeName(_x select 1) == 'SCALAR') then {
                        [_x select 1] call encode_number
                    } else {
                        _x select 1
                    };
                    _formatted_inventory set[count _formatted_inventory,[_item,_amount]];
                };
            } forEach _value;
            [player,_formatted_inventory] call player_set_inventory;
            diag_log format['Inventory set for %1: %2',name player,_formatted_inventory];
        };
    };
    _handle_storage = {
        private['_value','_storage_name'];
        _value = _this select 0;
        _storage_name = _this select 1;
        if(typeName _value == 'ARRAY') then {
            player setVariable[_storage_name,_value,true];
            diag_log format['Storage %1 set for %2: %3',_storage_name,name player,_value];
        } else {
            player setVariable[_storage_name,[],true];
            diag_log format['Storage %1 initialized empty for %2',_storage_name,name player];
        };
    };
    _handle_common_vars = {
        private['_faction','_varName','_varValue'];
        _faction = _this select 0;
        _varName = _this select 1;
        _varValue = _this select 2;
        if(_varName == format['moneyAccount%1',_faction]) then {
            if(_varValue == 0) then {
                [player,startmoneh] call bank_set_value;
            } else {
                [player,_varValue] call bank_set_value;
            };
            diag_log format['Set money account for %1: %2',name player,_varValue];
        };
        if(_varName == format['WeaponsPlayer%1',_faction]) then {
            {player addWeapon _x} forEach _varValue;
            diag_log format['Added weapons for %1: %2',name player,_varValue];
        };
        if(_varName == format['MagazinesPlayer%1',_faction]) then {
            {player addMagazine _x} forEach _varValue;
            diag_log format['Added magazines for %1: %2',name player,_varValue];
        };
        if(_varName == format['Licenses%1',_faction]) then {
            if(isNil 'INV_LicenseOwner') then {INV_LicenseOwner = []};
            if(typeName _varValue == 'ARRAY') then {
                [player,'INV_LicenseOwner',_varValue] call player_set_array;
                diag_log format['Set licenses for %1: %2',name player,_varValue];
            } else {
                diag_log format['Invalid license data for %1: %2',name player,_varValue];
            };
        };
        if(_varName == format['Inventory%1',_faction]) then {
            _varValue call _handle_inventory;
        };
        if(_varName == format['privateStorage%1',_faction]) then {
            [_varValue,'private_storage'] call _handle_storage;
        };
        if(_varName == format['Factory%1',_faction]) then {
            INV_Fabrikowner = _varValue;
            diag_log format['Set factory ownership for %1: %2',name player,_varValue];
        };
        if(_varName == 'JailTime') then {
            player_jailtime = _varValue;
            diag_log format['Set jail time for %1: %2',name player,_varValue];
        };
        if(_varName == 'logins') then {
            if(typeName _varValue == 'SCALAR') then {
                player_logins = _varValue;
                diag_log format['Set login count for %1: %2',name player,_varValue];
            } else {
                diag_log format['Invalid login count data for %1: %2',name player,_varValue];
                player_logins = 0;
            };
        };
    };
    _handle_special_vars = {
        private['_faction','_varName','_varValue'];
        _faction = _this select 0;
        _varName = _this select 1;
        _varValue = _this select 2;
        if(_faction == 'Res') then {
            if(_varName == 'lineIncrement') then {
                player setVariable['lineNumber',_varValue,true];
                diag_log format['Set line number for %1: %2',name player,_varValue];
            };
            if(_varName == 'gear_un') then {
                load_gear = _varValue;
                diag_log format['Set UN gear for %1: %2',name player,_varValue];
            };
        };
        if(_faction == 'Civ') then {
            if(_varName in ['Fabrikablage1_storage','AircraftFactory1_storage','Fabrikablage3_storage','Fabrikablage4_storage']) then {
                [_varValue,_varName] call _handle_storage;
            };
        };
    };
    if(iscop) then {
        ['West',_varName,_varValue] call _handle_common_vars;
        ['West',_varName,_varValue] call _handle_special_vars;
    };
    if(isopf) then {
        ['East',_varName,_varValue] call _handle_common_vars;
        ['East',_varName,_varValue] call _handle_special_vars;
    };
    if(isins) then {
        ['Res',_varName,_varValue] call _handle_common_vars;
        ['Res',_varName,_varValue] call _handle_special_vars;
    };
    if(isciv) then {
        ['Civ',_varName,_varValue] call _handle_common_vars;
        ['Civ',_varName,_varValue] call _handle_special_vars;
    };
    if(_varName == 'player_total_playtime') then {
        player_total_playtime = _varValue;
    };
    if(_varName == 'online_during_hacker') then {
        online_during_hacker = _varValue;
    };
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
