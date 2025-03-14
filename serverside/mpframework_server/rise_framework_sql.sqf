sql_test =
{
	_player = _this select 0;
	
	_id = owner _player;
	
	
	_name = name _player;
	_side = side _player;
	_uid = getPlayerUID _player;
	
	"Arma2Net.Unmanaged" callExtension format["Arma2NETMySQLCommand ['arma2taki', 'REPLACE INTO players (uid, name, faction) VALUES ('%1', '%2', '%3')']", _uid, _name, _side];
};

sql_insert_new_player = 
{
	_player = _this select 0;
	_uid = getPlayerUID _player;
	"Arma2Net.Unmanaged" callExtension format["Arma2NETMySQLCommand ['arma2taki', 'INSERT INTO players (uid) VALUES ('%1')']", _uid];
};
/*

USE THIS CLIENT SIDE TO TEST IT KTHNX

format["if (!isserver) exitwith {}; [%1] call sql_insert_new_player;", player] call broadcast; 
format ["if(!isserver) exitwith{}; [%1] call sql_test;", player ] call broadcast;
*/