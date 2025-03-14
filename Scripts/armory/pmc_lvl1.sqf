
_box = _this select 3;


_pmc = pmc;

if !(_pmc) exitWith {player groupChat "You are not PMC"};

_currMoney = [player ,"money"] call INV_GetItemAmount;

_neededMoney = 130000;

if (_neededMoney > _currMoney) exitWith {player groupChat "You do not have enough shekels to stock this armory"};

[player ,"money",-_neededMoney] call INV_AddInventoryItem;


	_box  addWeaponCargoGlobal ["MP5A5",5];
 
	_box  addMagazineCargoGlobal ["30rnd_9x19_MP5",60];
	
	_box  addWeaponCargoGlobal ["M1014",1];
	
	_box addMagazineCargoGlobal ["8Rnd_B_Beneli_74Slug",12];
 
	_box addWeaponCargoGlobal ["M9",5];
 
	_box addMagazineCargoGlobal ["15Rnd_9x19_M9",40];
	
	player groupChat "You have stocked an ammo box with Level 1 weapons";