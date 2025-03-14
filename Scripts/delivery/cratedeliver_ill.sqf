
	if (active) exitWith {player groupChat "You already have a delivery scheduled."};
	
	if !(isciv) exitWith {player groupChat "This is a civilian job."};
	
	_class = "Fort_Crate_wood";
	
	_num =  round random 100;
	
	_payment = 75000;
	
	_contents = "";
	
	if (_num <= 30) then {_class = "Misc_cargo_cont_net2"; _payment = 450000};
	
	if ((_num > 30) && (_num < 80)) then {_class = "Fort_Crate_wood"; _payment = 250000};
	
	if (_num > 80 ) then {_class = "Misc_cargo_cont_net1"; _payment = 350000};
	
	_crate = _class createVehicle (getMarkerPos "crate_spawn_1");
	
	format[' _crate addaction ["Check Crate Contents","Scripts\delivery\crate_notify.sqf",true,1,false,true,"",""];'] call broadcast;
	
	_crate setpos (getMarkerPos "crate_spawn_1");

	crate_extension = vehicleVarName player;

	_cratename = ["crate_ill_%1", crate_extension];

	
	_time = 1200;

	player groupChat format [ "A cargo crate worth $%1 is ready for delivery. Get it to the southern shipping depot on the airfield in under 20 minutes.",_payment];

	active = true;
	
	
	while {active} do {

		if (_crate distance (getMarkerPos "crate_delivery_1" ) <= 10 ) exitwith {

			player groupChat format ["You have delivered your cargo to the destination. Your payment was $%1.",_payment];

			deletevehicle _crate;

			active = false;

			[player, "money" , _payment] call INV_AddInventoryItem;
			
			
		};
		
		_time = _time - 1;
			
			
		uiSleep 1;
		
		if (_time == 900) then {player groupchat "You have 15 minutes left to deliver your cargo. This is easy."};
		
		if (_time == 600) then {player groupchat "You have 10 minutes left to deliver your cargo. Don't worry you have time."};
		
		if (_time == 300) then {player groupchat "You have 5 minutes left to deliver your cargo. You're cutting it close."};
		
		if (_time == 120) then {player groupchat "You have 2 minutes left to deliver your cargo. Do hurry!"};
		
		if (_time == 0) exitwith {
		
		
			player groupChat "You have not delivered the cargo in the time alloted. You do not receive payment.";
 
			deletevehicle _crate;

			active = false;
		
		
		};
		
		
	};
