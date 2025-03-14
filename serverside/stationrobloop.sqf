for "_x" from 1 to 9 do 
{
	call compile format["station%1money = 5000;", str(_x)];
};

// Stores
pharmacymoney = 15000;

while {true} do
{
	for "_x" from 1 to 9 do 
	{
		call compile format["if (station%1money < maxstationmoney) then {station%1money = station%1money + %2;};", str(_x), ceil ((random 250) + 250)];
		publicvariable format["station%1money", str(_x)];
	};
	_randomNum = ceil ((random 250) + 250);
	pharmacymoney = pharmacymoney + _randomNum;
	if (pharmacymoney > maxstoremoney) then {pharmacymoney = maxstoremoney};
	publicvariable "pharmacymoney";
	
	_t = diag_ticktime;
	waituntil {sleep 0.2; diag_ticktime - _t >= 30};
};