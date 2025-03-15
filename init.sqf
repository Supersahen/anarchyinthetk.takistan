#define ExecSQF(FILE) [] call compile preprocessFileLineNumbers FILE
#define ExecSQFspawnpass(PASS, FILE) PASS spawn compile preprocessFileLineNumbers FILE
#define ExecSQFspawn(FILE) ExecSQFspawnpass([], FILE)
#define ExecSQFwait(FILE) private["_handler"]; _handler = [] spawn (compile (preprocessFileLineNumbers FILE)); waitUntil{scriptDone _handler};
#define ExecSQFwaitPass(PASS, FILE) private["_handler"]; _handler = PASS spawn (compile (preprocessFileLineNumbers FILE)); waitUntil{scriptDone _handler};
#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

ALL_LOADING_DONE = false;
enableSaving [false, false];
taki_init_finished = false;

isClient = !isServer || (isServer && !isDedicated);

if(isServer) then
{
	
	call compile preProcessFile "\iniDB\init.sqf";
	diag_log "iniDB\init.sqf COMPLETE";
	titleText ["Database Initialising","PLAIN"]; // Displays text
	execVM "RG\serverGather.sqf";
};

// [] execvm "scripts\monitor_init.sqf";
// diag_log "scripts\monitor_init.sqf COMPLETE";

ExecSQFwait("Awesome\BIS\init.sqf")
RG_fnc_iSave = compile preprocessFileLineNumbers "RG\iSave.sqf";
diag_log "RG\iSave.sqf COMPLETE";

ExecSQF("Awesome\Functions\debug.sqf");
ExecSQF("Awesome\Functions\uid_lists.sqf");
ExecSQF("Awesome\Functions\encodingfunctions.sqf");
ExecSQF("Awesome\Functions\music.sqf");
ExecSQF("Awesome\MyStats\persist.sqf");
ExecSQF("Awesome\Functions\time_functions.sqf");
ExecSQF("Awesome\Functions\player_functions.sqf");
ExecSQF("Awesome\Rappel\init.sqf");
ExecSQF("Awesome\MyStats\functions.sqf");

ExecSQF("Awesome\Functions\server_functions.sqf");
ExecSQF("Awesome\Functions\list_functions.sqf");
ExecSQF("Awesome\Functions\vehicle_storage_functions.sqf");

if (isClient) then {
		[] call stats_client_start_loading;
		["Loading - Stage 1/14"] call stats_client_update_loading_title;
		[0] call stats_client_update_loading_progress;
		
//		[] execFSM "Awesome\Performance\fpsManagerDynamic.fsm";
//		[] execFSM "Awesome\Client\afkCheck.fsm";
	};

WEST setFriend [EAST, 0];
WEST setFriend [RESISTANCE, 0];
EAST setFriend [WEST, 0];
EAST setFriend [RESISTANCE, 0];
RESISTANCE setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 0];
CIVILIAN setFriend [WEST, 0];
CIVILIAN setFriend [EAST, 0];
CIVILIAN setFriend [RESISTANCE, 0];

ExecSQF("Awesome\Scripts\optimize_1.sqf");

["init"] spawn A_SCRIPT_BOMBS;
ExecSQF("Awesome\Functions\interaction.sqf");
ExecSQF("triggers.sqf");

if (isClient) then {
		[0.2] call stats_client_update_loading_progress;
		["Loading - Stage 2/14"] call stats_client_update_loading_title;
	};

ExecSQF("customfunctions.sqf");
ExecSQF("strfuncs.sqf");
["Loading - Stage 3/14"] call stats_client_update_loading_title;
ExecSQF("1007210.sqf");
ExecSQF("4422894.sqf");
["Loading - Stage 4/14"] call stats_client_update_loading_title;
ExecSQF("miscfunctions.sqf");
ExecSQF("Awesome\Functions\quicksort.sqf");
["Loading - Stage 5/14"] call stats_client_update_loading_title;
ExecSQF("INVvars.sqf");
ExecSQF("Awesome\Shops\functions.sqf");
["Loading - Stage 6/14"] call stats_client_update_loading_title;
ExecSQF("Awesome\Functions\bankfunctions.sqf");
ExecSQFwait("bankvariables.sqf");
["Loading - Stage 7/14"] call stats_client_update_loading_title;
ExecSQF("execlotto.sqf");
ExecSQF("initWPmissions.sqf");
["Loading - Stage 8/14"] call stats_client_update_loading_title;
ExecSQF("gfx.sqf");
ExecSQF("animList.sqf");
["Loading - Stage 9/14"] call stats_client_update_loading_title;
ExecSQF("variables.sqf");
ExecSQF("Awesome\Functions\money_functions.sqf");
["Loading - Stage 10/14"] call stats_client_update_loading_title;
ExecSQF("Awesome\Functions\gang_functions.sqf");
ExecSQF("Awesome\Functions\convoy_functions.sqf");
["Loading - Stage 11/14"] call stats_client_update_loading_title;
ExecSQF("Awesome\Functions\factory_functions.sqf");
ExecSQFwait("Awesome\MountedSlots\functions.sqf");
["Loading - Stage 12/14"] call stats_client_update_loading_title;

if (isClient) then {
		[0.6] call stats_client_update_loading_progress;
		["Loading - Stage 3/14"] call stats_client_update_loading_title;
	};

// Starts up Awesome scripts
ExecSQF("Awesome\init.sqf");

if(isClient) then {
	[0.8] call stats_client_update_loading_progress;
	["Loading - Stage 13/14"] call stats_client_update_loading_title;
	
	ExecSQFspawn("briefing.sqf");
	
	ExecSQFwait("Awesome\Functions\camera_functions.sqf")
	ExecSQFwait("Awesome\Functions\admin_functions.sqf")
	ExecSQFwait("Awesome\Functions\markers.sqf");
	ExecSQFwait("Awesome\Functions\holster.sqf");
	ExecSQFspawn("clientloop.sqf");
	[] spawn gangs_loop;
	ExecSQFspawn("respawn.sqf");
	ExecSQFspawn("petrolactions.sqf");
	ExecSQFspawn("nametags.sqf");
	ExecSQFspawn("Awesome\Functions\salary.sqf");
	ExecSQFspawn("motd.sqf");
	ExecSQFspawnpass(["client"], "bombs.sqf");
	
	ExecSQFwait("onKeyPress.sqf")
	
	[1] call stats_client_update_loading_progress;
	["Loading - Stage 14/14"] call stats_client_update_loading_title;
	[] execVM "RG\cLoad.sqf";
	[] execvm "mpframework\rise_framework_init.sqf"; 
	waitUntil {!isNil "rise_framework_initialized"};
	[] call stats_client_stop_loading;
	
	[] call music_stop;
	
	SleepWait(30)
	[] spawn ftf_init;
	
};

ALL_LOADING_DONE = true;
taki_init_finished = true;

if (isServer) then {
	[0,0,0,["serverloop"]] spawn compile preprocessfilelineNumbers "mayorserverloop.sqf";
	[0,0,0,["serverloop"]] spawn compile preprocessfilelineNumbers "chiefserverloop.sqf";

	ExecSQFspawn("targets.sqf");
	ExecSQFspawn("druguse.sqf");
	ExecSQFspawn("drugreplenish.sqf");
	ExecSQFspawn("Awesome\Scripts\hunting.sqf");
	ExecSQFspawn("stationrobloop.sqf");
};

