
_vcl = (nearestobjects [position player,["Air", "Ship","LandVehicle"], 5] select 0);

if !([player, _vcl] call vehicle_owner) exitWith {player groupChat "You must own this vehicle in order to save it."};

player groupChat "Your vehicle is safe from carmagedons for the next 5 minutes!";

_vcl setVariable ["car_save",true,true];

uiSleep 600;

_vcl setVariable ["car_save",false,true];

player groupChat "A vehicle of yours is no longer safe from carmagedons";

