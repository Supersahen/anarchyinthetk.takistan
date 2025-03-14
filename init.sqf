cutText ["", "BLACK OUT"];
enableSaving [false, false];
taki_init_finished = false;

isClient = !isServer || (isServer && !isDedicated);

sleep 0.5;

if(isServer) then
{
	
	call compile preProcessFile "\iniDB\init.sqf";
	diag_log "iniDB\init.sqf COMPLETE";
	titleText ["Database Initialising","PLAIN"]; // Displays text
	execVM "RG\serverGather.sqf";
};

_h = [] execVM "Awesome\Functions\encodingfunctions.sqf";
waitUntil{scriptDone _h};

if (isServer) then {
	_h = [] execVM "Awesome\MyStats\persist.sqf";
	waitUntil{scriptDone _h};
};

_h = [] execVM "Awesome\Functions\time_functions.sqf";
waitUntil{scriptDone _h};

_h = [] execVM "RG\iSave.sqf";
waitUntil{scriptDone _h};
diag_log "RG\iSave.sqf COMPLETE";

// Add a small delay to ensure proper initialization
sleep 1;

_h = [] execVM "Awesome\MyStats\functions.sqf";
waitUntil{scriptDone _h};
diag_log "MyStats functions.sqf COMPLETE";

// Load vehicle functions before player functions since player functions depends on vehicle_storage_name
_h = [] execVM "Awesome\Functions\vehicle_functions.sqf";
waitUntil{scriptDone _h};
diag_log "vehicle_functions.sqf COMPLETE";

// Load core libraries first
_h = [] execVM "Awesome\Functions\player_functions.sqf";
waitUntil{scriptDone _h};
diag_log "player_functions.sqf COMPLETE";

// Load stun functions
_h = [] execVM "Awesome\Functions\stun_functions.sqf";
waitUntil{scriptDone _h};
diag_log "stun_functions.sqf COMPLETE";

// Load bank and money functions next since they depend on player_functions
_h = [] execVM "Awesome\Functions\bankfunctions.sqf";
waitUntil{scriptDone _h};
diag_log "bankfunctions.sqf COMPLETE";

_h = [] execVM "Awesome\Functions\money_functions.sqf";
waitUntil{scriptDone _h};
diag_log "money_functions.sqf COMPLETE";

// Load masterarray first since INVvars depends on it
_h = [] execVM "masterarray.sqf";
waitUntil{scriptDone _h};
diag_log "masterarray.sqf COMPLETE";

// Load INVfunctions before INVvars since INVvars depends on it
_h = [] execVM "INVfunctions.sqf";
waitUntil{scriptDone _h};
diag_log "INVfunctions.sqf COMPLETE";

// Load inventory and shop functions with timeout and error handling
diag_log "Starting INVvars.sqf load...";
_h = [] execVM "INVvars.sqf";
_timeout = time + 30; // 30 second timeout
waitUntil{scriptDone _h || time > _timeout};
if (time > _timeout) then {
    diag_log "ERROR: INVvars.sqf load timed out after 30 seconds";
} else {
    diag_log "INVvars.sqf COMPLETE";
};

_h = [] execVM "Awesome\Functions\quicksort.sqf";
waitUntil{scriptDone _h};
diag_log "quicksort.sqf COMPLETE";

// Load miscfunctions before shops since shops depends on format_integer
_h = [] execVM "miscfunctions.sqf";
waitUntil{scriptDone _h};
diag_log "miscfunctions.sqf COMPLETE";

_h = [] execVM "Awesome\Shops\functions.sqf";
waitUntil{scriptDone _h};
diag_log "Shops functions.sqf COMPLETE";

// Load targets first since variables.sqf depends on them
if(isServer) then {
	execVM "targets.sqf";
	waitUntil{scriptDone _h};
	diag_log "targets.sqf COMPLETE";
};

// Load variables and other scripts that use stats functions
_h = [] execVM "variables.sqf";
waitUntil{scriptDone _h};
diag_log "variables.sqf COMPLETE";

_h = [] execVM "bankexec.sqf";
waitUntil{scriptDone _h};
diag_log "bankexec.sqf COMPLETE";

_h = [] execVM "Awesome\Functions\factory_functions.sqf";
waitUntil{scriptDone _h};
diag_log "factory_functions.sqf COMPLETE";

WEST setFriend [EAST, 0];
WEST setFriend [RESISTANCE, 0];
EAST setFriend [WEST, 0];
EAST setFriend [RESISTANCE, 0];
RESISTANCE setFriend [EAST, 0];
RESISTANCE setFriend [WEST, 0];
CIVILIAN setFriend [WEST, 0];
CIVILIAN setFriend [EAST, 0];
CIVILIAN setFriend [RESISTANCE, 0];
diag_log "setFriends Section COMPLETE";

_h = [] execVM "Awesome\Scripts\optimize_1.sqf";
waitUntil{scriptDone _h};
	
debug  = false;

enableSaving [false, false];
diag_log "Taki Init - 3";

["init"] execVM "bombs.sqf";
diag_log "bombs.sqf COMPLETE";

if (isServer) then {
	["server"] execVM "bombs.sqf";
};

_h = [] execVM "Awesome\Functions\interaction.sqf";
waitUntil{scriptDone _h};

call compile preprocessfile "triggers.sqf";
diag_log "triggers.sqf COMPLETE";

if (isClient) then {
	[] execVM "briefing.sqf";
	diag_log "briefing.sqf COMPLETE";
};

_h = [] execVM "broadcast.sqf";
waitUntil{scriptDone  _h};
diag_log "broadcast.sqf COMPLETE";

_h = []	execVM "customfunctions.sqf";
waitUntil{scriptDone  _h};

_h = []	execVM "strfuncs.sqf";
waitUntil{scriptDone  _h};
diag_log "strfuncs.sqf COMPLETE";

_h = []	execVM "1007210.sqf";
waitUntil{scriptDone  _h};

_h = [] execVM "4422894.sqf";
waitUntil{scriptDone _h};

_h = []	execVM "execlotto.sqf";
waitUntil{scriptDone _h};

_h = [] execVM "initWPmissions.sqf";
waitUntil{scriptDone  _h};

_h = [] execVM "gfx.sqf";
waitUntil{scriptDone  _h};

_h = [] execVM "animList.sqf";
waitUntil{scriptDone  _h};

_h = [] execVM "Awesome\Functions\gang_functions.sqf";
waitUntil{scriptDone _h};

// Starts up Awesome scripts
_h = [] execVM "Awesome\init.sqf";
waitUntil{scriptDone _h};

_h = [] execVM "setPitchBank.sqf";
waitUntil {scriptDone _h};

publicvariable "station1robbed";
publicvariable "station2robbed";
publicvariable "station3robbed";
publicvariable "station4robbed";
publicvariable "station5robbed";
publicvariable "station6robbed";
publicvariable "station7robbed";
publicvariable "station8robbed";
publicvariable "station9robbed";


if(isClient) then {
		titleText ["Preparing Client","PLAIN"]; // Displays text
	server globalChat "Loading - Please Wait";
	[] execVM "Awesome\Functions\holster.sqf";
	[] execVM "clientloop.sqf";
	[] spawn gangs_loop;
	[] execVM "respawn.sqf";
	[] execVM "petrolactions.sqf";
	[] execVM "nametags.sqf";
	server globalChat "Loading - Complete";
	[] execVM "Awesome\Functions\markers.sqf";
	[] execVM "Awesome\Functions\salary.sqf";
	[] execVM "motd.sqf";
	[] ExecVM "Awesome\MountedSlots\functions.sqf";
	["client"] execVM "bombs.sqf";
	player addEventHandler ["fired", {_this execVM "Awesome\EH\EH_fired.sqf"}];
	player addEventHandler ["handleDamage", {_this execVM "Awesome\EH\EH_handledamage.sqf"}];
	player addEventHandler ["WeaponAssembled", {_this execVM "Awesome\EH\EH_weaponassembled.sqf"}];
	[] execVM "onKeyPress.sqf";
	[] execVM "govconvoy_functions.sqf"; 
	[] execVM "RG\cLoad.sqf";
	diag_log "Taki Life Init - Client Loaded";
	titleText ["Client Initalized","PLAIN"];
};

if (isServer) then {
	//[60,180,true] execVM "cly_removedead.sqf";
	[0, 0, 0, ["serverloop"]] execVM "mayorserverloop.sqf";
	[0, 0, 0, ["serverloop"]] execVM "chiefserverloop.sqf";
	[] execVM "druguse.sqf";
	[] execVM "drugreplenish.sqf";
	[] execVM "robpool.sqf";
	[] execVM "Awesome\Scripts\hunting.sqf";
	[] execVM "setObjectPitches.sqf";
	[] execVM "governmentconvoy.sqf";

//=======================rob gas station init and variables================
	[] execVM "stationrobloop.sqf";
	station1money = 5000;
	publicvariable "station1money";
	station2money = 5000;
	publicvariable "station2money";
	station3money = 5000;
	publicvariable "station3money";
	station4money = 5000;
	publicvariable "station4money";
	station5money = 5000;
	publicvariable "station5money";
	station6money = 5000;
	publicvariable "station6money";
	station7money = 5000;
	publicvariable "station7money";
	station8money = 5000;
	publicvariable "station8money";
	station9money = 5000;
	publicvariable "station9money";
};


// Define Variables

gcrsrope1 = "none";
gcrsrope2 = "none";
gcrsrope3 = "none";
gcrsrope4 = "none";
gcrsrope5 = "none";
gcrsrope6 = "none";
gcrsrope7 = "none";
gcrsrope8 = "none";
gcrsrope9 = "none";
gcrsrope10 = "none";
gcrsrope11 = "none";
gcrsrope12 = "none";
gcrsrope13 = "none";
gcrsrope14 = "none";
gcrsrope15 = "none";
gcrsrepelvehicle = "none";
gcrsropedeployed = "false";
gcrsdeployropeactionid = 0;
gcrsdropropeactionid = 0;
gcrsplayerrepelactionid = 0;
gcrsplayerveh = "none";
gcrspilotvehicle = "none";
gcrsrapelvehiclearray = ["MH6J_EP1", "UH1H_TK_GUE_EP1", "UH60M_EP1", "BAF_Merlin_HC3_D", "CH_47F_EP1", "Mi17_UN_CDF_EP1", "Ka60_PMC"];
gcrsrapelheloarray = [];
gcrsplayerveharray = [];

// End GeneralCarver's Rapel Script Init Scripting

//// Start the Drop Cargo Script
execVM "BTK\Cargo Drop\Start.sqf";

taki_init_finished = true;
