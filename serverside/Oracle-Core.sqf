_saveToDB =
"
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_varValue = _array select 3;
	_saveArray = [_uid, _uid, _varName, _varValue];
	_saveArray call iniDB_write;
";

saveToDB = compile _saveToDB;


_loadFromDB =
"
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_type = _array select 3;
	_cid = _array select 4;
	_cid = owner _cid;
	_loadArray = [_uid, _uid, _varName, _type];
	accountToClient = [_uid,_varName,_loadArray call iniDB_read];
	_cid publicVariableClient 'accountToClient';
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