/*
	File: init.sqf
	Author: Montel Williams

	Description:
	Initializes all stat/HC related systems
*/

_dbConnected = ["TAKIDB","SQL_CUSTOM","rise_taki"] call compile PreprocessFileLineNumbers "functions\init_db.sqf";
if (_dbConnected) then {
    systemChat "DB init successful!";
};

DB_FN_ASYNC = compile PreprocessFileLineNumbers "functions\fn_async.sqf";
compile PreprocessFileLineNumbers "functions\misc_funcs.sqf";