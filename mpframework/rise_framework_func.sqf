mp_group_chat_message =
{
	_message = _this select 0;
	player groupchat _message;
};

mp_play_sound =
{
	_source = _this select 0;
	_distance = _this select 1;
	_sound = _this select 2;
	
	if (player distance _source <= _distance) then {
		_source say3D _sound;
	};
};
mp_side_chat_message =
{
	_message = _this select 0;
	player sideChat _message;
};

mp_global_chat_message =
{
	_message = _this select 0;
	server globalchat _message;
};

mp_server_message =
{
	_message = _this select 0;
	server globalchat _message;
	titleText [format["%1", _message], "PLAIN DOWN"];
};
mp_hint =
{
	_text = _this select 0;
	hint _text;
};
mp_anim_sync =
{
	private ["_unit","_mode","_animation"];
	_unit = _this select 0;
	_mode = _this select 1;
	_animation = _this select 2;

	if (_mode == "switchmove") then {_unit switchMove _animation};
	if (_mode == "playmove") then {_unit playmove _animation};
};

mp_compile_code =
{	
	
	_code = _this select 0;
	call compile _code;
};

mp_screen_message =
{
	_message = _this select 0;
	titleText [format["%1", _message], "PLAIN DOWN"];
};


mp_start_force_ts =
{
	player enablesimulation false;
	titletext ["You are required to join our teamspeak server! The address is TS3.RISE-GAMING.COM", "black"];
};

mp_stop_force_ts =
{
	player enablesimulation true;
	titletext ["", "PLAIN DOWN", 0];
};


mp_staff_init =
{
	_staff_level = _this select 0;
	switch (_staff_level) do
	{
		case "dev": {isdeveloper = true;};
		case "snadmin": {issnadmin = true;};
		case "admin": {isadmin = true;};
		case "mod": {ismod = true;};
		case "tsh": {istsh = true;};
		default {};
	};
	isstaff = (isdeveloper or issnadmin or isadmin or ismod);
	if (isstaff) then {osf=true; srt=true;pmc=true;vice=true;
		_message = format ["%1 logged onto the server",name player];
		[_message, "Admin Login"] call mp_log;
	};
	if((_slot in adminslots) && not(isStaff)) then {   player groupChat "You are not in the whitelist for this slot."; uiSleep 8; failMission "END1";};
};

mp_pmc_init =
{
	_pmc = _this select 0;
	switch (_pmc) do
	{
		case "pmc": {pmc = true;};
		default {};
	};
};
mp_srt_init =
{
	_srt = _this select 0;
	switch (_srt) do
	{
		case "srt": {srt = true;};
		default {};
	};
};
mp_supervisor_init =
{
	_super = _this select 0;
	switch (_super) do
	{
		case "super": {supervisor = true;};
		default {};
	};
};
mp_osf_init =
{
	_osf = _this select 0;
	switch (_osf) do
	{
		case "osf": {osf = true;};
		default {};
	};
};
mp_vice_init =
{
	_vice = _this select 0;
	switch (_vice) do
	{
		case "vice": {vice = true;};
		default {};
	};
};
mp_donor_init =
{
	_donor = _this select 0;
	switch (_donor) do
	{
		case "1": {isdon = true; donator1 = true;
			startmoneh = 550000;
		};
		case "2": {isdon = true; donator2 = true;
			startmoneh = 600000;
			INV_CarryingCapacity = 100;
			INV_CarryingCapacityOld = 100;
		};
		case "3": {isdon = true; donator3 = true;
			startmoneh = 750000;
			INV_CarryingCapacity = 200;
			INV_CarryingCapacityOld = 200;
		};
		case "4": {isdon = true; donator4 = true;
			INV_CarryingCapacity = 300;
			INV_CarryingCapacityOld = 300;
			startmoneh = 1000000;
		};
		case "vip": {isdon = true; isvip = true;
			startmoneh = 1500000;
			INV_CarryingCapacity = 500;
			INV_CarryingCapacityOld = 500;
		};
		default {};
	};
};


mp_blacklist_init =
{
	blacklists = _this;
	
	_cop = blacklists select 0;
	_opf = blacklists select 1;
	_indy = blacklists select 2;
	_civ = blacklists select 3;
	
	if (_cop and playerSide == west) then {player groupChat "You are blacklisted from this faction"; uiSleep 2; failMission "END1"};
	if (_opf and playerSide == east) then {player groupChat "You are blacklisted from this faction"; uiSleep 2; failMission "END1"};
	if (_indy and playerSide == resistance) then {player groupChat "You are blacklisted from this faction"; uiSleep 2; failMission "END1"};
	if (_civ and playerSide == civilian) then {player groupChat "You are blacklisted from this faction"; uiSleep 2; failMission "END1"};
	
};
mp_online_during_hacker = {

	online_during_hacker = online_during_hacker + 1;
	[format ["%1_persistent",getplayeruid player], format ["%1_persistent",getplayeruid player], "online_during_hacker", online_during_hacker] call fn_SaveToServer;
	
};
mp_admin_query = {
	_sender = _this select 0;
	_name = name player;
	_uid = getplayeruid player;
	_info = [_name,_uid, player];
	_time =  player_playtime;
	_logins = player_logins;
	_hackings = online_during_hacker;
	_totaltime = player_total_playtime;
	_flags = 0;
	
	// stuff to send to admin
	// play time - Money - Weapons - Login Times - Red Flags - Staff Var -
	
	if (_logins < 15) then {
		_flags = _flags + 1;
	};
	
	if (_time <= 3600) then {
		_flags = _flags + 1;
	};
	
	if (_hackings >= 2) then {
		_flags = _flags + 1;
	};	
	
	if (_totaltime <= 7200) then {
		_flags = _flags + 1;
	};
	

	_info2 = [_info,[_time,_logins,isStaff,_flags,_hackings,_totaltime]];
	[[_sender],"mp_admin_query_response",[_info2]] call mp_aware_me;

};

mp_admin_query_response = {
	_input = _this select 0;
	if (typeName _input != "ARRAY") exitWith {};
	
	_basic = _input select 0;
	_advanced = _input select 1;
	
	
	_name = _basic select 0;
	_uid = _basic select 1;
	_player = _basic select 2;
	
	diag_log _input;
	call compile format ['
		admin_query_response_%1 = %2;
		systemChat "Response Received from %3";
	',_player,_input,_name];

	
};
mp_admin_notify = {
	
	if (!isStaff) exitWith {};
	
	_string = _this select 0;
	
	hint _string;
	systemChat _string;
	titletext [_string, "PLAIN DOWN"];
};

mp_admin_query_refresh = {

	disableSerialization;
	_dialog = findDisplay 2200;
	_list = _dialog displayCtrl 1400;
	_text = _dialog displayCtrl 1000;

	_info = _list lbData (lbCurSel _list);
	_info = call compile _info;
	
	_basic = _info select 0;
	_advanced = _info select 1;
		
	_name = _basic select 0;
	_uid = _basic select 1;
	_unit = _basic select 2;
	
	if (isNil "_unit") then {_unit = "No Unit / Respawing"};
	
	_playtime =  _advanced select 0;
	_logins = _advanced select 1;
	_staff = _advanced select 2;
	_flags = _advanced select 3;
	_hackings = _advanced select 4;
	_totaltime = _advanced select 5;

	//[_playtime, "_playtime"] call debug;
	//[_logins, "_logins"] call debug;
	//[_staff, "_staff"] call debug;
	//[_flags, "_flags"] call debug;
	//[_hackings, "_hackings"] call debug;
	//[_totaltime, "_totaltime"] call debug;
	
	_text ctrlSetStructuredText parseText format ["
			<t align='left' font='Zeppelin32' size='1'>Player NAME: %1 </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player UID: %2 </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player UNIT: %3 </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player PLAYTIME: %4 (mins) </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player TOTAL PLAYTIME: %5 (mins) </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player LOGINS: %6 </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player STAFF: %7 </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player FLAGS: %8 </t> <br/>
			<t align='left' font='Zeppelin32' size='1'>Player Online During Hacker Count: %9 </t> <br/>
		",_name,_uid,_unit,
		round (_playtime / 60),
		round (_totaltime / 60),
		_logins,
		_staff,
		_flags,
		_hackings
	];
};

mp_admin_query_open = {

	if !(createDialog "player_query_dialog") exitWith {hint "Dialog Error"};
	{
		call compile format ['
			disableSerialization;
			
			if !(isNil "admin_query_response_%1") then {
				_dialog = findDisplay 2200;
				_list = _dialog displayCtrl 1400;
				_text = _dialog displayCtrl 1000;
				
				_info = admin_query_response_%1;
				_basic = admin_query_response_%1 select 0;
				_advanced = admin_query_response_%1 select 1;
				
				_name = _basic select 0;
				_uid = _basic select 1;
				_unit = _basic select 2;
				
				_playtime =  _advanced select 0;
				_logins = _advanced select 1;
				_staff = _advanced select 2;
				_flags = _advanced select 3;
									
				_index = _list lbAdd _name;
				_list lbSetData [_index,"admin_query_response_%1"];
				
				
				if (_flags == 0) then {
					_list lbSetColor [_index, [0, 1, 0, 1]]; 
				};	
				if (_flags >= 1) then {
					_list lbSetColor [_index, [1, 1, 0, 1]];
				};	
				
				if (_flags >= 2) then {
					_list lbSetColor [_index, [1, 0.2, 0, 1]];
				};	
				
				if (_flags >= 3) then {
					_list lbSetColor [_index, [1, 0, 0, 1]];
				};
			};
			
		',_x];
	} foreach playerstringarray;
};


mp_playerinfo = {
	_sender = _this select 0;
	_info = [];

	_player = player;
	_uid = getPlayerUID player;
	_name = name player;
	_primary = primaryweapon player;
	_bank = [player] call bank_get_value;
	_cash = [player, "money"] call INV_GetItemAmount;

	_pmc_status = "No";
	_srt_status = "No";
	_vice_status = "No";
	_donor = "No";

	if (donator1) then {_donor = "Level 1"};
	if (donator2) then {_donor = "Level 2"};
	if (donator3) then {_donor = "Level 3"};
	if (donator4) then {_donor = "Level 4"};
	if (isvip) then {_donor = "VIP"};

	if (pmc) then {_pmc_status = "Yes"};
	if (srt) then {_srt_status = "Yes"};
	if (vice) then {_vice_status = "Yes"};

	_inventory = [player] call player_get_inventory;

	_info = [_player,_uid,_name,_primary,_bank,_cash,_pmc_status,_srt_status,_vice_status,_donor,_inventory];
	[[_sender], "mp_playerinfo_response", _info] call mp_aware_me;
};

mp_playerinfo_response = {

	_player = _this select 0;
	_uid = _this select 1;
	_name = _this select 2;
	_primary = _this select 3;
	_bank = _this select 4;
	_cash = _this select 5;
	_pmc_status = _this select 6;
	_srt_status = _this select 7;
	_vice_status = _this select 8;
	_donor = _this select 9;
	_inventory = _this select 10;

	systemChat format ["Response Received"];
	closedialog 0;
	createDialog "player_info";
	_trennlinie = "=======================================================================";


	_DFML = findDisplay 2000;
	lbClear (_DFML displayCtrl 2001);
	(_DFML displayCtrl 2001)	lbAdd format ["Player Slot: %1",_player];
	(_DFML displayCtrl 2001)	lbAdd format ["Player UID: %1",_uid];
	(_DFML displayCtrl 2001)	lbAdd format ["Player Name: %1",_name];
	(_DFML displayCtrl 2001)	lbAdd format ["Primary Weapon: %1",_primary];
	(_DFML displayCtrl 2001)	lbAdd format ["Bank Account: %1",_bank];
	(_DFML displayCtrl 2001)	lbAdd format ["Player Cash: %1",_cash];
	(_DFML displayCtrl 2001)	lbAdd format ["Whitelisted PMC: %1",_pmc_status];
	(_DFML displayCtrl 2001)	lbAdd format ["Whitelisted SRT: %1",_srt_status];
	(_DFML displayCtrl 2001)	lbAdd format ["Whitelisted VICE: %1",_vice_status];
	(_DFML displayCtrl 2001)	lbAdd format ["Donor Level: %1",_donor];

	(_DFML displayCtrl 2001)	lbAdd _trennlinie;
	(_DFML displayCtrl 2001)	lbAdd "I N V E N T O R Y";
	(_DFML displayCtrl 2001)	lbAdd _trennlinie;
	{
		_item = _x;
		_class = _item select 0;
		_name = (_class call INV_GetItemName);
		_amount = [(_item select 1)] call decode_number;
		(_DFML displayCtrl 2001)	lbAdd format ["--%1 Amount: %2",_name,_amount];
	} foreach _inventory;
};
mp_system_chat_message =
{
	_message = _this select 0;
	systemChat _message;
};