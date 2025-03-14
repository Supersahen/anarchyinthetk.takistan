/*
	Name: ac130.sqf;
	Author: [RISE] Sp3ctr3
	Property Of [RISE] Gaming Community
	Contact before using
	Modified by Jim. Almost there!
	Note - For some reason when you fire one of the guns, it blows up the C130. Might be a good idea to just use
	one KA-137
*/

	_vehicle = _this select 0;
	

	_gunner1 = "Ka137_MG_PMC" createVehicle (getpos _vehicle);
	_gunner1 attachto [_vehicle,[0,2,-4.5]];
	_gunner1 lock false;
	[player,_gunner1] call vehicle_add;
	_gunner1 addWeapon "2A46M";
    _gunner1 addMagazine "22Rnd_125mmHE_T72";
    _gunner1 addMagazine "22Rnd_125mmHE_T72";
	_gunner1 addMagazine "23Rnd_125mmSABOT_T72";
	_gunner1 addMagazine "23Rnd_125mmSABOT_T72";
	_gunner1 addMagazine "23Rnd_125mmSABOT_T72";
	_gunner1 addMagazine "23Rnd_125mmSABOT_T72";
	_gunner1 addMagazine "22Rnd_125mmHE_T72";
    _gunner1 addMagazine "22Rnd_125mmHE_T72";
	
	_gunner1 addWeapon "M242";
    _gunner1 addMagazine "210Rnd_25mm_M242_HEI";
    _gunner1 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner1 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner1 addMagazine "210Rnd_25mm_M242_HEI";
	_gunner1 addMagazine "210Rnd_25mm_M242_HEI";
    _gunner1 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner1 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner1 addMagazine "210Rnd_25mm_M242_HEI";
	
	_gunner1 addWeapon "GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
	_gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
	_gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
    _gunner1 addMagazine "300Rnd_25mm_GAU12";
	
	
	_gunner1 setVariable ["car_save",true,true];
	ac130_gunners = [_gunner1];
	//_veh = ac130_gunners select 0;
	//player moveInGunner _veh;
	
	/*
	_veh = ac130_gunners select 0;
	
	_gunner2 = "Ka137_MG_PMC" createVehicle (getpos _vehicle);
	_gunner2 attachto [_vehicle,[0,0,-4.5]];
	_gunner2 lock false;
	[player,_gunner2] call vehicle_add;

	_gunner2 addWeapon "M242";
    _gunner2 addMagazine "210Rnd_25mm_M242_HEI";
    _gunner2 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner2 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner2 addMagazine "210Rnd_25mm_M242_HEI";
	_gunner2 addMagazine "210Rnd_25mm_M242_HEI";
    _gunner2 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner2 addMagazine "210Rnd_25mm_M242_APDS";
    _gunner2 addMagazine "210Rnd_25mm_M242_HEI";
	
	_gunner3 = "Ka137_MG_PMC" createVehicle (getpos _vehicle);
	_gunner3 attachto [_vehicle,[0,-2,-4.5]];
	_gunner3 lock false;
	[player,_gunner3] call vehicle_add;

	_gunner3 addWeapon "GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
	_gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
	_gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
    _gunner3 addMagazine "300Rnd_25mm_GAU12";
	
	ac130_gunners = [_gunner1,_gunner2,_gunner3];
