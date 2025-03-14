/*
[RISE] Sp3ctr3
terror_bombing.sqf;
*/

if !([player] call player_insurgent) exitWith {player groupChat "You are not an insurgent"};

if (bombing_active) exitWith {player groupChat "A bombing mission is already active!"};

if !(allow_bombing) exitWith {player groupChat "You must wait 5 Minutes between attempts to bomb a target!"};

bombing_active = true;
publicvariable "bombing_active";

_bombing_sites = ["bombsite1","bombsite2","bombsite3","bombsite4","bombsite5","bombsite6"];

_bomb_site =  _bombing_sites select floor random count _bombing_sites;

_bomb_pos = getMarkerPos _bomb_site;

player groupChat "You have been designated to bomb a target! Get to the location marked on your map and place the bomb!";
player groupChat "The bomb is in your inventory";

	_bomb_marker = createMarker [ "bomb_marker" , _bomb_pos ];
	"bomb_marker" setMarkerShape "ICON";
	"bomb_marker" setMarkerType "DOT";
	"bomb_marker" setMarkerColor "ColorRed";
	"bomb_marker" setMarkerText "Bombing Target";
	
(format ['server globalChat "UN Intelligience reports terrorists are currently trying to bomb a building in takistan! Police must prevent this from occuring!";']) call broadcast;

[player, "bomb_mission", 1] call INV_AddInventoryItem ;

[player , "(bomb threats)",150000] call player_update_warrants;

_time = 900;

while {bombing_active} do {

if ((_time == 0) or  (!alive player)) then {

	bombing_active = false;
	
	publicvariable "bombing_active";
	
	(format ['server globalChat "The terrorist has failed his mission!";']) call broadcast;
	
	player groupChat "You have failed your mission!"; 
	
	deleteMarker "bomb_marker";
	
	bombing_active = false;
	
	publicvariable "bombing_active";
};
	_time = _time - 1;

uiSleep 1;
};









