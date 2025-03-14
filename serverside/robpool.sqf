for "_x" from 1 to 3 do 
{
	call compile format["robpoolsafe%1 = 150000;", str(_x)];
};

while{true} do
{
	for "_x" from 1 to 3 do 
	{
		call compile format["if (robpoolsafe%1 < maxinsafe) then {robpoolsafe%1 = robpoolsafe%1 + %2;};", str(_x), ceil (random 4000)];
		publicvariable format["robpoolsafe%1", str(_x)];
	};
	
	_t = diag_ticktime;
	waituntil {sleep 0.2; diag_ticktime - _t >= 30};
};

