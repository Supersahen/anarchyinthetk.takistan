private["_art","_item","_anzahl","_unit"];
_art = _this select 0;

if (_art == "use") then {

	_item   = _this select 1;
	_anzahl = _this select 2;
	_unit = _this select 4;

	if ((player distance _unit) > 3) exitwith {player groupchat format["You are to far away from %1-%2", _unit, name(_unit)]};
	if(vehicle player != player)exitwith{player groupchat "you cannot use this in a vehicle"};
	if(!(_unit call INV_Heal))exitwith{};
	[player, _item, -1] call INV_AddInventoryItem;
};

