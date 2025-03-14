gangsarray = [];
pmccontracts= [];
LawsArray = [
	"Always Drive on the RIGHT side of the road", 
	"Always Holster weapons in Towns 1k/1min jail.",
	"Completing an assassination mission is murder.",
	"Failure to pull over is a crime.",
	"Being near a methlab\gangarea\sell point is reasonable suspicion to search.",
	"You may be searched at will on the NAF.",
	"Occupying a police vehicle is KOS.",
	"Blank Law",
	"Blank Law"
];
elections = [
	["",[],[]], // President
	["",[],[]], // Blufor Chief
	["",[],[]], // Opfor Commander
	["",[],[]] // Insurgent Caliph
];

fuel_consumed = 0;
terrorists = 0;
dispatch_database = [];
dogsarray = [];
martiallaw = false;
warfare = false;
maxinsafe = 1000000;
maxstoremoney = 50000;
maxstationmoney = 35000;
chiefNumber = -1;
commanderNumber = -1;
MayorNumber = -1;
bank_gold_bars = 1;
esu_mission_object = nil;
esu_mission_details = [];
esu_mission_active = false;
chiefaccepted = false;
commanderaccepted = false;
jointops = false;