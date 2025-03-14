/// Start Config ///

// min
irl_daytime_lenght = 45;
irl_nightime_lenght = 20;




// min
// ex:
// 7:30 am = 7*60+30
// 7:30 pm = 20*60+30

serv_time_increment = 15;
serv_day_start_initial = 330;
serv_day_start_final = 840;
serv_night_start_initial = 1000;
serv_night_start_final = 1320;
serv_current_time = 0;



serv_year = 2014;
serv_month = 3;
serv_day = 2;

/// End Config ///


mp_sync_time =
{
	[[], "mp_sync_time", [[serv_year, serv_month, serv_day, 0, serv_current_time]]] call mp_send;
	setdate [serv_year, serv_month, serv_day, 0, serv_current_time];
};

mp_time_trans_dtn =
{
	[[], "mp_time_trans_dtn", [[serv_year, serv_month, serv_day, serv_night_start_initial, serv_night_start_final, serv_time_increment]]] call mp_send;
	setdate [serv_year, serv_month, serv_day, 0, serv_night_start_final];
};

mp_time_trans_ntd =
{
	[[], "mp_time_trans_ntd", [[serv_year, serv_month, serv_day, serv_day_start_initial, serv_day_start_final, serv_time_increment]]] call mp_send;
	setdate [serv_year, serv_month, serv_day, 0, serv_day_start_final];
};

while {true} do
{
	// Sync the time to the clients
	serv_current_time = 840;
	[] call mp_sync_time;

	// Stay daytime for the preset time
	for "_x" from 1 to irl_daytime_lenght do
	{
		_t = diag_ticktime;
		waituntil {sleep 0.2; diag_ticktime - _t >= 60};
		[[], "mp_group_chat_message", [format["%1 minutes left till night", str(irl_daytime_lenght - _x)]]] call mp_send;
	};

	// Sync the time to the clients
	serv_current_time = 1320;
	[] call mp_sync_time;

	// Stay nighttime for the preset time
	for "_x" from 1 to irl_nightime_lenght do
	{
		_t = diag_ticktime;
		waituntil {sleep 0.2; diag_ticktime - _t >= 60};
		[[], "mp_group_chat_message", [format["%1 minutes left till day", str(irl_nightime_lenght - _x)]]] call mp_send;
	};
};


