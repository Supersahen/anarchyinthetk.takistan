lampaarray = [
	[[5667.36,9076.91,3.3],266.186],
	[[5659.83,9219.33,3.3],274.265],
	[[5508.4,9308.19,3.3],84.1829],
	[[5501.46,9382.55,3.3],91.2047],
	[[5518.3,9552.69,3.3],103.116],
	[[5565.8,9720.38,3.3],106.276],
	[[5743.63,10045.7,3.3],126.02],
	[[5836.3,10198.7,3.3],112.805],
	[[5906.95,10389.4,3.3],109.249],
	[[5966.68,10542.8,3.3],112.122],
	[[5998.11,10620,3.3],106.374],
	
	// General Store Compound Lights
	[[6151.14,11035.4,3.3],119.332],
	[[6130.39,10992.5,3.3],85.9774],
	[[6083.76,11012.1,3.3],59.805],
	[[6132.7,11047.4,3.3],216.372]
];

if (isServer) then
{

	building2 = "Land_Hangar_2" createVehicle [5977.2, 11426.4,  0];
	building2 setDir 131.523;
	building2 setVehicleInit format["this allowDamage false;"];
	building2 allowDamage false;

	// Bank Glitch Barriers
	block1 = createVehicle ["Land_CncBlock_Stripes", [6556.33,11381.5,0], [], 0, "CAN_COLLIDE"];
	block1 setDir 139.481;
	block1 setVehicleInit format["this allowDamage false;"];


	block2 = createVehicle ["Land_CncBlock_Stripes", [6558.5,11383.5,0], [], 0, "CAN_COLLIDE"];
	block2 setDir 138.791;
	block2 setVehicleInit format["this allowDamage false;"];

	{
		_lamp = _x;
		_pos = _lamp select 0;
		_dir = _lamp select 1;
		_obj = createVehicle ["Land_Lamp_Street1_EP1", _pos, [], 0, "CAN_COLLIDE"];
		_obj setDir _dir;
		call compile format['_obj setvehicleinit "this addEventHandler [""HandleDamage"", {false}]; this switchlight ""on""; this enableSimulation false"; processinitcommands'];
		processinitcommands
		
		
	} foreach lampaarray;


	// Takistan Mine
	mine_main = "Land_Ind_Coltan_Main_EP1" createvehicle [4092.79,9226.97,141.718]; mine_main setdir 84.1201;
	mine_hopper = "Land_Ind_Coltan_Hopper_EP1" createvehicle [4078.15,9240.52,141.338]; mine_hopper setdir 84.8587;
	mine_conveyor = "Land_Ind_Coltan_Conv2_EP1" createvehicle [4120,9218.29,142.379]; mine_conveyor setdir 348.805;
	mine_heap = "Land_Misc_Coltan_Heap_EP1" createvehicle [4132.15,9213.04,142.866]; mine_heap setdir 245.712;
	processInitCommands;
	
	// LHD OSF
	
	_attachedvehicle = "";
	_first = false;
	_attachedinteger = 0;
	_LHDspawn = "LHDSPAWNOSF";
	_LHDspawnpoint = getmarkerpos _LHDspawn;
	_LHD = 	"Land_LHD_1" createVehicle _LHDspawnpoint;
	_LHD setPos [(getPos _LHD) select 0,(getPos _LHD) select 1,8];
	_LHD setVectorUp [0,0,-1];
	_LHD setDir -10;
	_LHD1 = "Land_LHD_2" createVehicle _LHDspawnpoint;
	_LHD2 = "Land_LHD_3" createVehicle _LHDspawnpoint;
	_LHD3 = "Land_LHD_4" createVehicle _LHDspawnpoint;
	_LHD4 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra1 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra2 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra3 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra4 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra5 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra6 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra7 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra8 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra9 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHDextra10 = "Land_LHD_5" createVehicle _LHDspawnpoint;
	_LHD5 = "Land_LHD_6" createVehicle _LHDspawnpoint;
	_LHD1 attachTo [_LHD,[-0.6,-60,0]];
	_LHD2 attachTo [_LHD1,[1.2,-21,0.65]];
	_LHD3 attachTo [_LHD2,[-2.1,-40,1]];
	_LHDextra1 attachTo [_LHD3,[-0.4,-35,-0.65]];
	_LHDextra2 attachTo [_LHDextra1,[0,-35,0]];
	_LHDextra3 attachTo [_LHDextra2,[0,-35,0]];
	_LHDextra4 attachTo [_LHDextra3,[0,-35,0]];
	_LHDextra5 attachTo [_LHDextra4,[0,-35,0]];
	_LHDextra6 attachTo [_LHDextra5,[0,-35,0]];
	_LHDextra7 attachTo [_LHDextra6,[0,-35,0]];
	_LHDextra8 attachTo [_LHDextra7,[0,-35,0]];
	_LHDextra9 attachTo [_LHDextra8,[0,-35,0]];
	_LHDextra10 attachTo [_LHDextra9,[0,-35,0]];
	_LHD4 attachTo [_LHDextra5,[0,0,0]];
	_LHD5 attachTo [_LHD4,[0.4,-40,0]];

};