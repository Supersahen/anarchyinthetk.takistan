remove_tracker =
{
	private ["_i","_uid"];
	_i = _this select 0;
	_uid = _this select 1;
	
	trackers_arr set [_i,0];
	trackers_arr = trackers_arr - [0];
	deletemarkerlocal (_x select 0);
};


trackers_arr = [];
trackers_active = false;

start_tracker_loop =
{
	while {trackers_active} do
	{
		uiSleep 0.5;
		_i = 0;
		{
			_id = _x select 0;
			_vehicle = _x select 1;
			_name = _x select 2;
			if ((damage _vehicle) >= 1) exitwith {player groupChat format["CONNECTION LOST TO TRACKER %1", _name]; [_i,_uid] call remove_tracker;};
			_id setMarkerPosLocal (getpos _vehicle);
			_i = _i + 1;
		} foreach trackers_arr;
	};
};