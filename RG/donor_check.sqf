if (isvip) then {
			INV_LicenseOwner = INV_LicenseOwner + ["viplicense"];
			server globalchat "VIP DONATOR ACCOUNT DETECTED: VIP Donator License Added";
};

if (isdon) then {
			INV_LicenseOwner = INV_LicenseOwner + ["donator"];
			server globalchat "DONOR ACCOUNT DETECTED: DONOR TRAINING Added";	
};
