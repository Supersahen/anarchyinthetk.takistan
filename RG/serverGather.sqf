_saveToDB =
"
	_array = _this;
	if (isNil '_array' || typeName _array != 'ARRAY' || count _array < 4) exitWith {
		diag_log format['iniDB Error: Invalid save array: %1', _array];
	};
	
	_file = _array select 0;
	_uid = _array select 1;
	_varName = _array select 2;
	_varValue = _array select 3;
	
	if (isNil '_file' || isNil '_uid' || isNil '_varName' || isNil '_varValue') exitWith {
		diag_log format['iniDB Error: Missing required parameters: file=%1, uid=%2, varName=%3, value=%4', _file, _uid, _varName, _varValue];
	};
	
	_saveArray = [_file, _uid, _varName, _varValue];
	_saveArray call iniDB_write;
";

saveToDB = compile _saveToDB;

_loadFromDB =
"
	_array = _this;
	if (isNil '_array' || typeName _array != 'ARRAY' || count _array < 4) exitWith {
		diag_log format['iniDB Error: Invalid load array: %1', _array];
		nil
	};
	
	_file = _array select 0;
	_uid = _array select 1;
	_varName = _array select 2;
	_type = _array select 3;
	_cid = _array select 4;
	_cid = owner _cid;
	
	if (isNil '_file' || isNil '_uid' || isNil '_varName' || isNil '_type') exitWith {
		diag_log format['iniDB Error: Missing required parameters: file=%1, uid=%2, varName=%3, type=%4', _file, _uid, _varName, _type];
		nil
	};
	
	_loadArray = [_file, _uid, _varName, _type];
	_result = _loadArray call iniDB_read;
	
	if (isNil '_result') then {
		diag_log format['iniDB Warning: No data found for %1.%2.%3', _uid, _varName, _type];
		_result = switch (_type) do {
			case 'NUMBER': {
				if (_varName in ['moneyAccountWest', 'moneyAccountEast', 'moneyAccountRes', 'moneyAccountCiv']) then {
					diag_log format['iniDB: Using default money value for %1', _varName];
					startmoneh
				} else {
					0
				};
			};
			case 'ARRAY': {[]};
			case 'STRING': {''};
			default {nil}
		};
	};
	
	if (_type == 'NUMBER' && _varName in ['moneyAccountWest', 'moneyAccountEast', 'moneyAccountRes', 'moneyAccountCiv']) then {
		_result = parseNumber str _result;
		diag_log format['iniDB: Sending money value %1 for %2', _result, _varName];
	};
	
	accountToClient = [_uid, _varName, _result];
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