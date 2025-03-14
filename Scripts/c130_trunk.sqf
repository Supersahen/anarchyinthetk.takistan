

	_vehicle = (getpos player nearEntities [["C130J","C130J_US_EP1"], 15] select 0);
	_player = player;

	if(not([player, _vehicle] call vehicle_owner)) exitWith {
		player groupchat "You do not have the keys to this vehicle.";
		false
	};
	
	private["_inside_vehicle"];
	_inside_vehicle = not((vehicle player) == player);
	
	if (_inside_vehicle) exitWith {
		player groupChat format["You must be outside the vehicle to use the trunk"];
	};
	
	if (([_vehicle] call trunk_in_use)) exitWith {
		player groupChat format["This vehicle's trunk is being used by %1", ([_vehicle] call trunk_user)];
		false
	};
	[_vehicle] call trunk_open;
	[_player,_vehicle] call interact_vehicle_storage_menu