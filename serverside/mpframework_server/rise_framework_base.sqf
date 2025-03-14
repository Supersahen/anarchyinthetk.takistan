/*
FORMATTING
[[players_arr_or_nothing], function, [params]]

putting the players_array to [] will result in the function being executed on all players




incoming (mp_aware):
[["mp_aware"], [[players_array_or_nothing], "function name", ["params_array"]]]
*/

mp_send =
{
	_p = _this select 0;
	_f = _this select 1;
	_args = _this select 2;
	
	mp_execute = [_f, _args];
	
	if (count(_p) == 0) then
	{
		publicvariable "mp_execute";
	}
	else
	{
		{
			_id = owner _x;
			_id publicvariableclient "mp_execute";
		} foreach _p;
	};
};

"mp_aware" addpublicvariableeventhandler
{
	_t = _this select 1;

	_p = _t select 0;
	_f = _t select 1;
	_args = _t select 2;

	[_p,_f,_args] call mp_send;
};


"dronesUpdate" addpublicvariableeventhandler
{
	_array = _this;
	if (isNil "drones_array") then {
		drones_array = [_array];
		[] spawn drones_monitor;
	} else {
		drones_array = drones_array + [_array];
	};
	
};

mp_drones_monitor = {
	waitUntil {!isNil "drones_array"};
	while {true} do {
		uiSleep 360;
		{
			_player = _x select 0;
			_units = _x select 1;
			
			if (isNil "_player" or isNull _player) then {
				{
					deletevehicle _x;
				} foreach _units;
			};
		} foreach drones_array;
	};
};

"db_write" addpublicvariableeventhandler
{
	_file = _this select 0;
	_key = _this select 1;
	_sec = _this select 2;
	_data = _this select 3;
	
	if (isNil "_file") exitWith {};
	if (isNil "_key") exitWith {};
	if (isNil "_sec") exitWith {};
	if (isNil "_data") exitWith {};
	
	[_file,_key,_sec,_data] call iniDB_write;
};



"mp_player" addpublicvariableeventhandler
{
	_player = _this select 1;
	_id = owner _player;
	_uid = getplayeruid _player;

	_id publicvariableclient "LawsArray";
	_id publicvariableclient "INV_ItemTypenArray";
	_id publicvariableclient "INV_ItemStocks";
	_id publicvariableclient "gangsarray";
	_id publicvariableclient "pmccontracts";
	_id publicvariableClient "dogsarray";
	
	_id publicvariableClient "chiefNumber";
	_id publicvariableClient "commanderNumber";
	_id publicvariableClient "MayorNumber";
	_id publicvariableClient "dispatch_database";
	_id publicvariableClient "martiallaw";
	_id publicvariableClient "warfare";
	
	_id publicvariableClient "chiefaccepted";
	_id publicvariableClient "commanderaccepted";
	_id publicvariableClient "jointops";
	
	_id publicvariableClient "esu_mission_object";
	_id publicvariableClient "esu_mission_details";
	_id publicvariableClient "esu_mission_active";
	
	_id publicvariableClient "opf_convoy_has_cash";
	_id publicvariableClient "convoy_has_cash";
	_id publicvariableClient "fuel_consumed";
	
	_id publicvariableClient "elections";
	_id publicvariableClient "stock_markets";
	
	[_player, _uid] call staff_init;
	[_player, _uid] call donor_init;
	[_player, _uid] call pmc_init;
	[_player, _uid] call srt_init;
	[_player, _uid] call osf_init;
	[_player, _uid] call vice_init;
	[_player, _uid] call blacklist_init;
	[_player, _uid] call supervisor_init;
	
	[[_player],"mp_framework_init_fnc",[]] call mp_send;
	//[_player] call anti_hack_init;
};

staff_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	
	_staff_status = ["whitelist", _uid, "staff"] call iniDB_read;
	[[_player], "mp_staff_init", [_staff_status]] call mp_send;
	
	if ((_staff_status != "") or !(isnil "_staff_status")) then
	{
		switch (_staff_status) do {
			case "dev": {[[_player], "mp_global_chat_message", ["Apex Keks/Shekels Loaded"]] call mp_send;};
			case "boss": {[[_player], "mp_global_chat_message", ["Boss Shekels Loaded"]] call mp_send;};
			case "admin": {[[_player], "mp_global_chat_message", ["Admin Shekels Loaded"]] call mp_send;};
			case "mod": {[[_player], "mp_global_chat_message", ["Mod Shekels Loaded"]] call mp_send;};
			case "tsh": {[[_player], "mp_global_chat_message", ["TSH Shekels Loaded"]] call mp_send;};
		};
	};
};


pmc_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	
	_pmc_status = ["whitelist", _uid, "pmc"] call iniDB_read;
	[[_player], "mp_pmc_init", [_pmc_status]] call mp_send;
	
	if ((_pmc_status != "") or !(isnil "_pmc_status")) then
	{
		[[_player], "mp_global_chat_message", ["Welcome PMC!"]] call mp_send;
	};
	

};
srt_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	
	_srt_status = ["whitelist", _uid, "srt"] call iniDB_read;
	[[_player], "mp_srt_init", [_srt_status]] call mp_send;
	
	if ((_srt_status != "") or !(isnil "_srt_status")) then
	{
		[[_player], "mp_global_chat_message", ["SRT Detected"]] call mp_send;
	};
	

};
supervisor_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	
	_super_status = ["whitelist", _uid, "supervisor"] call iniDB_read;
	[[_player], "mp_supervisor_init", [_super_status]] call mp_send;
	
	if ((_super_status != "") or !(isnil "_super_status")) then
	{
		[[_player], "mp_global_chat_message", ["Supervisor Detected"]] call mp_send;
	};
	

};
osf_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	_status = ["whitelist", _uid, "osf"] call iniDB_read;
	[[_player], "mp_osf_init", [_status]] call mp_send;
	
	if ((_status != "") or !(isnil "_status")) then
	{
		[[_player], "mp_global_chat_message", ["OSF Detected"]] call mp_send;
	};
	

};

vice_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	
	_vice_status = ["whitelist", _uid, "vice"] call iniDB_read;
	[[_player], "mp_vice_init", [_vice_status]] call mp_send;
	
	if ((_vice_status != "") or !(isnil "_vice_status")) then
	{
		[[_player], "mp_global_chat_message", ["VICE Detected"]] call mp_send;
	};
	

};

donor_init =
{
	_player = _this select 0;
	_uid = _this select 1;
	
	_donor_status = ["donators", _uid, "donor"] call iniDB_read;
	[[_player], "mp_donor_init", [_donor_status]] call mp_send;
	
	if ((_donor_status != "") or !(isnil "_donor_status")) then
	{
		[[_player], "mp_global_chat_message", ["Donor Perks Loaded!"]] call mp_send;
	};
	

};

anti_hack_init = {

	_player = _this select 0;
	private ["_anti"];
	
	_anti = format ['
		diag_log "DEBUG: test complete";
	
	'];
	
	[[_player],"mp_remote_code",[_anti]] call mp_send;
};

blacklist_init = {

	_player = _this select 0;
	_uid = _this select 1;
	
	_blacklist = [format ["%1_persistent",_uid], format ["%1_persistent",_uid], "blacklists"] call iniDB_read;
	if (isNil "_blacklist") exitWith {};
	if (typeName _blacklist != "ARRAY") then {_blacklist = call compile _blacklist};
	if (typeName _blacklist == "ARRAY") then {
		[[_player], "mp_blacklist_init", _blacklist] call mp_send;	
	};
};

