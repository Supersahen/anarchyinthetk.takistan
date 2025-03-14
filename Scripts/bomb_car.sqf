
_vehicle = vehicle player;

_unit = player;

if (_active) exitWith {player groupchat "DETONATION IMIENENT!"};

if (insafezone) exitWith {player groupChat "Cannot Do this near a spawn\safezone"};

if !([player, _vehicle] call vehicle_owner) exitwith {player groupChat "You do not have the code to the bomb"};

_vehicle removeaction bomb;

_active = true;

format["

_vehicle = %1;
_distance = player distance _vehicle;

if ( _distance <= 100 ) then
{
	[_vehicle, player] say3D ""car_bomb"";
};

", _vehicle] call broadcast;

uiSleep 3;

_vehiclePos = getpos _vehicle;

_bomb = "Bo_GBU12_LGB" createVehicle _vehiclePos;