/*
	File: misc_funcs.sqf
	Author: Montel Williams

	Description:
	Initializes any misc functions
*/

test_db_read = {
	private["_uid","_return","_result"];

	_uid = [_this,0,"",[""]] call BIS_fnc_param;
	_query = format["getPlayerName:%1", _uid];
	_result = [_query, 2] call fn_async;
	//_return = format["NAME: %1", ((_result select 1) select 0)];
	_return = format["NAME: %1", _result];

	_return
};