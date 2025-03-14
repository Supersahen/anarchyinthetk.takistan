_saveToDB =
"
	_array = _this;
	_file = _array select 0;
	_uid = _array select 1;
	_varName = _array select 2;
	_varValue = _array select 3;
	_saveArray = [_file, _uid, _varName, _varValue];
	_saveArray call iniDB_write;
";

saveToDB = compile _saveToDB;

_loadFromDB =
"
	_array = _this;
	_file = _array select 0;
	_uid = _array select 1;
	_varName = _array select 2;
	_type = _array select 3;
	_loadArray = [_file, _uid, _varName, _type];
	accountToClient = [_uid, _varName, _loadArray call iniDB_read];
	publicVariable 'accountToClient';
";

loadFromDB = compile _loadFromDB;

"accountToServerSave" addPublicVariableEventHandler 
{
	(_this select 1) spawn saveToDB;
};

"accountToServerLoad" addPublicVariableEventHandler 
{
	(_this select 1) spawn loadFromDB;
};