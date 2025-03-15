hint "Please read the TLR tabs on map before playing";
server globalchat "[MoTD] Welcome to RISE Gaming Takistan Life: Revolution!";
custom_motd = nil;
while {true} do {	
	{server globalChat format["[MoTD] %1", _x]} forEach [
			"Discord: https://discord.gg/dVWvxEZJBj",
			"All Blufor, Opfor, and Independent factions are required to be on Discord"
		];
	
	if (not(isNil "custom_motd")) then { if (typeName custom_motd == "STRING") then { if (custom_motd != "") then {
		server globalChat format["[MoTD] %1", custom_motd];
	};};};
	sleep (3 * motdwaittime);
};
