#include "Awesome\Functions\dikcodes.h"

private["_handled", "_dikCode", "_shift", "_ctrl", "_alt"];
_dikCode = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;
_handled = false;

switch (_dikCode) do {
    case DIK_ESCAPE: {
        if (!dialog) then {
            // Only handle escape if no dialog is open
            [] execVM "abort.sqf";
            _handled = true;
        };
    };
};

_handled 