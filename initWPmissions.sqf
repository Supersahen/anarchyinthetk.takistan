private["_handler"];
_handler = [] execVM "workplacesettings.sqf";
waitUntil {scriptDone _handler};

if (isServer) then {
	[0,0,0,["serverloop"]] execVM "taxi.sqf";
	[0,0,0,["serverloop"]] execVM "assassination.sqf";
	[0,0,0,["serverloop"]] execVM "hostage.sqf";
};

