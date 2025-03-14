while {true} do
{
	sleep 30;

	{
		{
			deletevehicle _x;
		}
		foreach allMissionObjects _x;
	} foreach ["craterlong", "Wreck_Base"];
};




