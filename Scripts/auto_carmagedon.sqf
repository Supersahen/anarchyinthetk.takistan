
if (carmagedon) exitWith {};

["An admin has initiated an automatic global carmagedon, you have 5 minutes to occupy your vehicle or it will be removed! Everyone is reminded you may scroll wheel on your vehicle to prevent it from being deleted!"] call server_message;

carmagedon = true;

_time = 300;
while {true} do {
_time = _time - 1;

if (_time == 240) then {["AUTO CARMAGEDON: You have 4 minute(s) to occupy your vehicle or it will be removed!"] call server_message;};

if (_time == 180) then {["AUTO CARMAGEDON: You have 3 minute(s) to occupy your vehicle or it will be removed!"] call server_message;};

if (_time == 120) then {["AUTO CARMAGEDON: You have 2 minute(s) to occupy your vehicle or it will be removed!"] call server_message;};

if (_time == 60) then {["AUTO CARMAGEDON: You have 1 minute(s) to occupy your vehicle or it will be removed!"] call server_message;};

if (_time == 30) then {["AUTO CARMAGEDON: You have 30 second(s) to occupy your vehicle or it will be removed!"] call server_message;};

if (_time == 15) then {["AUTO CARMAGEDON: You have 15 second(s) to occupy your vehicle or it will be removed!"] call server_message};

if (_time == 0) then {
				_distance = 30000;
				
							player groupchat format["Starting Carmagedon at a range of %1 meters", _distance];
						{
							{
								if ({alive _x} count crew _x == 0) then {
									_var = _x getVariable ["car_save",false];
									if (_var) exitWith {};
									deletevehicle _x;
								};
							} foreach((getpos player) nearObjects [_x, _distance]);
						} forEach (droppableitems + ["LandVehicle", "Air", "Car", "Motorcycle", "Bicycle", "UAV", "Wreck", "Wreck_Base", "HelicopterWreck", "UH1Wreck", "UH1_Base", "UH1H_base", "AH6_Base_EP1","CraterLong", "Ka60_Base_PMC", "Ka137_Base_PMC", "A10"]);

	["Auto Carmagedon has concluded! It is safe to leave your vehicles!"] call server_message;
	carmagedon = false;
	};
uiSleep 1;
};