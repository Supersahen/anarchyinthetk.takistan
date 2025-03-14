
_mode = _this select 0;

_vehicle = _this select 1;

_obj = _this select 2;

if (_mode == 1) then {

	_class = typeof _vehicle;

	switch (_class) do {
	
		case "SUV_UN_EP1" : {_obj = "Land_CncBlock_Stripes" createvehicle (getpos _vehicle); _obj attachto [_vehicle,[0,2.5,-1]]};
	
		case "HMMWV_DES_EP1" : {_obj = "Land_CncBlock_Stripes" createvehicle (getpos _vehicle); _obj attachto [_vehicle,[0,2.35,-1.8]];};
	
		case "" : {};
	
		case "" : {};
	
		case "" : {};
	
		case "" : {};
	
		case "" : {};

	};

	[2,_vehicle,_obj] execvm "Scripts\modify_vehicle.sqf";
	
};

