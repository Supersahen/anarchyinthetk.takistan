// Save all player stats before exiting
private["_uid"];
_uid = getPlayerUID player;

// Save persistent variables
{
    [format ["%1_persistent",_uid], format ["%1_persistent",_uid], _x select 0, _x select 1] call fn_SaveToServer;
} forEach [
    ["player_total_playtime", player_total_playtime],
    ["logins", player_logins],
    ["online_during_hacker", online_during_hacker],
    ["JailTime", player_jailtime]
];

// Determine player's faction
_faction = switch (true) do {
    case (iscop): {"West"};
    case (isopf): {"East"};
    case (isins): {"Res"};
    case (isciv): {"Civ"};
    default {""};
};

if (_faction != "") then {
    // Save faction-specific variables
    {
        [_uid, _uid, format[_x select 0, _faction], _x select 1] call fn_SaveToServer;
    } forEach [
        ["moneyAccount%1", [player] call bank_get_value],
        ["WeaponsPlayer%1", weapons player],
        ["MagazinesPlayer%1", magazines player],
        ["Licenses%1", INV_LicenseOwner],
        ["Inventory%1", [player] call player_get_inventory],
        ["privateStorage%1", player getVariable ["private_storage", []]],
        ["Factory%1", INV_Fabrikowner]
    ];

    // Save civilian-specific storage
    if (isciv) then {
        {
            [_uid, _uid, _x, player getVariable [_x, []]] call fn_SaveToServer;
        } forEach [
            "Fabrikablage1_storage",
            "AircraftFactory1_storage",
            "Fabrikablage3_storage",
            "Fabrikablage4_storage"
        ];
    };
};

diag_log format["Stats saved for %1 (%2) before exit", name player, _uid]; 