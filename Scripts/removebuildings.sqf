	_buildings = [
		61157,
		61125,
		61834,
		61156,
		61154,
		61882,
		224928,
		61843,
		61875
	];

	{
		_b = getmarkerpos "respawn_civilian" nearestobject _x;
		_b attachto [dummyobj,[0,0,-500]];
	} foreach _buildings;
