
_box = _this select 3;


_pmc =pmc;

if !(_pmc) exitWith {player groupChat "You are not PMC"};

_currMoney = [player ,"money"] call INV_GetItemAmount;

_neededMoney = 200000;

if (_neededMoney > _currMoney) exitWith {player groupChat "You do not have enough shekels to stock this armory"};

[player ,"money",-_neededMoney] call INV_AddInventoryItem;


	_box  addWeaponCargoGlobal ["M4A3_CCO_EP1",5];
 
	_box  addMagazineCargoGlobal ["30Rnd_556x45_Stanag",60];
 
	_box addWeaponCargoGlobal ["glock17_ep1",3];
 
	_box addMagazineCargoGlobal ["15Rnd_9x19_M9",24];
	
	player groupChat "You have stocked an ammo box with Level 2 weapons";