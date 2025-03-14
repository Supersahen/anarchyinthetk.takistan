private ["_obj", "_pitch", "_bank", "_rotate"];

_obj = _this select 0;
_pitch = _this select 1;
_bank = _this select 2;

_rotate = {
    private ["_d"];
    _d = _this select 0;
    _obj setDir _d;
    _obj setPitchBank [_pitch, _bank, 0];
};

[_obj getDir player] call _rotate; 