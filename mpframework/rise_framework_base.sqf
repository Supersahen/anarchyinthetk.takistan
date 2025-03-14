waituntil {uiSleep 3; !isnull player};

"mp_execute" addpublicvariableeventhandler
{
	_t = _this select 1;
	_function = _t select 0;
	_args = _t select 1;
	
	call compile format ["%1 call %2",_args,_function];
};

mp_aware_me =
{
	mp_aware = _this;
	publicvariableserver "mp_aware";
};


mp_player = player;
publicvariableserver "mp_player";

RG_time_init_globals = {
	if (!isServer || (isServer && !isDedicated)) then { 
		call time_init_globals;
	};
};

RG_time_exitloop_fnc = {
	if (!isServer || (isServer && !isDedicated)) then {
		time_loop_exit = true;
	};
};

RG_time_loop_func = {
	if (!isServer || (isServer && !isDedicated)) then { 
		[true] spawn time_loop;
	};
};