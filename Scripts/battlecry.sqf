
if !([player] call player_insurgent) exitWith {player groupChat "you cannot battlecry"};

if !(allow_battlecry) exitWith {player groupChat "Your throat feels sore, you cannot battlecry atm"};

_unit = player;

allow_battlecry = false;

format["

_unit = %1;
_distance = player distance _unit;

if ( _distance <= 200 ) then
{
	[_unit, player] say3D ""battle_cry_ins"";
};

", player] call broadcast;

uiSleep 60;

allow_battlecry = true;

