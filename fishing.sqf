// this is the fishing.sqf file, called when using fishing pole

private ["_fishingarray", "_art"];

_art = _this select 0;

if(iscop)exitwith{};

if (_art == "use") then {
	if(working) exitwith {};
	
	private["_item","_anzahl","_isInArea"];
	_item   = _this select 1;
	_anzahl = _this select 2;

	working=true;
	_isInArea=false;

	{
		if (player distance (getMarkerPos ((_x select 0) select 0)) < ((_x select 0) select 1)) then {
			_isInArea = true; 
			_fishingarray = _x
		};
	} forEach fishingarray;
	
	private["_resource", "_max", "_infos", "_name"];
	_resource = _fishingarray select 1;
	_max      = _fishingarray select 2;
	_infos    = _resource call INV_GetItemArray;
	_name     = (_infos call INV_GetItemName);

	if (!_isInArea) exitwith {
		player groupChat "You are not where the fish are.";
		working = false;
	};

	if(_item == "fishingpole") then {
		private["_i", "_amount", "_avail"];
		totalamount=0;
		_max = 3;
		(format ["%1 switchmove ""%2"";", player, "AwopPercMstpSgthWnonDnon_end"]) call broadcast;
		for [{_i=0}, {_i < 4}, {_i=_i+1}] do {
			_amount = round (random _max);
			titletext ["Fishing...", "PLAIN DOWN", 0.1];

			sleep 1.5;
			player switchmove "normal";

			_avail = floor (INV_CarryingCapacity - (call INV_GetOwnWeight));

			totalamount = totalamount + _amount;
			if((totalamount*2) >= _avail)exitwith{totalamount = (_avail/2); player groupchat "maximum weight reached"; _i=6;};
			player groupchat format["You got %1 %2.", _amount, _name];
		};
		
		totalamount = (floor (totalamount));
		[player, _resource, totalamount] call INV_AddInventoryItem;
	};

	working=false;
};