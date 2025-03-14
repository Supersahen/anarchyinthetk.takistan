call compile preprocessFile "\iniDB\init.sqf";
execvm "ServerSide\Oracle-Core.sqf";
_h = execvm "serverside\variables.sqf";
waituntil {scriptdone _h};

execvm "serverside\stationrobloop.sqf";
execvm "serverside\robpool.sqf";
execvm "serverside\targets.sqf";
execvm "serverside\group_cleaner.sqf";
execvm "serverside\street_cleaner.sqf";
execvm "serverside\mpframework_server\rise_framework_init.sqf";