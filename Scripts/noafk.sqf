button_pressed_evnt =
{
	button_pressed = true;
};

button_pressed = false;

while {true} do
{
	if (isstaff or istsh) exitwith {};
	_t1 = diag_ticktime;
	_dir = direction player;
	while {(!button_pressed) and (_dir == (direction player))} do
	{
		_afk_time = (diag_ticktime - _t1);
		if (_afk_time >= 400) then
		{
			cutText ["You're AFK! Move or get kicked!", "PLAIN DOWN"];
			if (_afk_time >= 420) exitwith {[player,"You were kicked for being afk!"] call kick_player;};
		};
		uiSleep 1;
	};
	button_pressed = false;
	uiSleep 10;
};







