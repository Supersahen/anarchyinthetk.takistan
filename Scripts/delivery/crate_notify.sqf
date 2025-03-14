
_illegal = _this select 3;
if (_illegal) then {
player groupChat format ["This crate contains illegal contents."];
if not(iscop or isopf) exitWith {};

};

if  !(_illegal) exitWith {player groupChat "This crate contains legal contents."};