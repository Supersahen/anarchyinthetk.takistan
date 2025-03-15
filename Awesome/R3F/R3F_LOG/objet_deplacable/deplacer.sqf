if (R3F_LOG_mutex_local_verrou) then {
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
} else {
	R3F_LOG_mutex_local_verrou = true;
	
	R3F_LOG_objet_selectionne = objNull;
	
	private ["_objet", "_est_calculateur", "_arme_principale", "_action_menu", "_azimut_canon"];
	
	_objet = _this select 0;
	
	// Si l'objet est un calculateur d'artillerie, on laisse le script sp�cialis� g�rer
	_est_calculateur = _objet getVariable "R3F_ARTY_est_calculateur";
	if !(isNil "_est_calculateur") then {
		R3F_LOG_mutex_local_verrou = false;
		[_objet] execVM "Awesome\R3F\R3F_ARTY\poste_commandement\deplacer_calculateur.sqf";
	} else {
		_objet setVariable ["R3F_LOG_est_deplace_par", player, true];
		
		R3F_LOG_joueur_deplace_objet = _objet;
		
		// Sauvegarde et retrait de l'arme primaire
		_arme_principale = primaryWeapon player;
		if (_arme_principale != "") then {
			player playMove "AidlPercMstpSnonWnonDnon04";
			sleep 2;
			//player removeWeapon _arme_principale;
		} else {sleep 0.5;};
		
		// Si le joueur est mort pendant le sleep, on remet tout comme avant
		if (!alive player) then {
			R3F_LOG_joueur_deplace_objet = objNull;
			_objet setVariable ["R3F_LOG_est_deplace_par", objNull, true];
			// Car attachTo de "charger" positionne l'objet en altitude :
			_objet setPosATL [getPosATL _objet select 0, getPosATL _objet select 1, 0];
			_objet setVelocity [0, 0, 0];
			
			R3F_LOG_mutex_local_verrou = false;
		} else {
			_objet attachTo [player, [
				0,
				(((boundingBox _objet select 1 select 1) max (-(boundingBox _objet select 0 select 1))) max ((boundingBox _objet select 1 select 0) max (-(boundingBox _objet select 0 select 0)))) + 1,
				1]
			];
			
			if (count (weapons _objet) > 0) then {
				// Le canon doit pointer devant nous (sinon on a l'impression de se faire empaler)
				_azimut_canon = ((_objet weaponDirection (weapons _objet select 0)) select 0) atan2 ((_objet weaponDirection (weapons _objet select 0)) select 1);
				
				// On est oblig� de demander au serveur de tourner le canon pour nous
				R3F_ARTY_AND_LOG_PUBVAR_setDir = [_objet, (getDir _objet)-_azimut_canon];
				if (isServer) then {
					["R3F_ARTY_AND_LOG_PUBVAR_setDir", R3F_ARTY_AND_LOG_PUBVAR_setDir] spawn R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
				} else {
					publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setDir";
				};
			};
			
			R3F_LOG_mutex_local_verrou = false;
			
			_action_menu = player addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_relacher_objet + "</t>"), "Awesome\R3F\R3F_LOG\objet_deplacable\relacher.sqf", nil, 5, true, true, "", ""];
			
			// On limite la vitesse de marche et on interdit de monter dans un v�hicule tant que l'objet est port�
			
			keyblock = true; 
			
			while {!(isNull R3F_LOG_joueur_deplace_objet) && (alive player) && !([player, "isstunned"] call player_get_bool) && !([player, "restrained"] call player_get_bool)} do {
				if (vehicle player != player) then {
					player globalChat STR_R3F_LOG_ne_pas_monter_dans_vehicule;
					player action ["eject", vehicle player];
					sleep 1;
				};
				
				if ([0,0,0] distance (velocity player) > 2.8) then {
					player globalChat STR_R3F_LOG_courir_trop_vite;
					player playMove "AmovPpneMstpSnonWnonDnon";
					sleep 1;
				};
				
				sleep 0.25;
			};
			
			keyblock = false; 
			
			// L'objet n'est plus port�, on le repose
			detach _objet;
			_objet setPosATL [getPosATL _objet select 0, getPosATL _objet select 1, 0];
			_objet setVelocity [0, 0, 0];
			
			player removeAction _action_menu;
			R3F_LOG_joueur_deplace_objet = objNull;
			
			_objet setVariable ["R3F_LOG_est_deplace_par", objNull, true];
			
			// Restauration de l'arme primaire
			if (alive player && _arme_principale != "") then {
				player addWeapon _arme_principale;
				player selectWeapon _arme_principale;
				player selectWeapon (getArray (configFile >> "cfgWeapons" >> _arme_principale >> "muzzles") select 0);
			};
		};
	};
};