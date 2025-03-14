#include "constants.h"

class RscTextC {
	type = 0;
	idc = -1;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 0x100; 
	font = Zeppelin32;
	SizeEx = 0.03921;
	colorText[] = {1,1,1,1};
	colorBackground[] = {0, 0, 0, 0};
	linespacing = 1;
};

class customLoadingScreen { 
	idd = customLoadingScreen_idc ;
	duration = 10e10;
	fadein = 0;
	fadeout = 0;
	
	controlsBackground[] = {blackBG};
	objects[] = { };
	controls[] = { Title, Progress, ProgressText, ProgressReverse };
	
	onLoad="uiNamespace setVariable ['DFML_LOAD', _this select 0]";
	
	class blackBG : RscTextC {
		
		x = safezoneX;
		y = safezoneY;
		w = safezoneW;
		h = safezoneH;
		text = "";
		colorText[] = {0,0,0,0};
		colorBackground[] = {0,0,0,1};
	};

	class Title: RscTextC  {
		idc = loadingTitle_idc;
		x = 0.05; y = 0.029412;
		w = 0.9; h = 0.04902;
		text = "";
		sizeEx = 0.05;
		colorText[] = {0.543,0.5742,0.4102,1.0};
	};
	
	class Progress  {
		idc = loadingProgress_idc;
		x = 0.344; y = 0.619;
		w = 0.313726; h = 0.0261438;
		texture = "\ca\ui\data\loadscreen_progressbar_ca.paa";
		colorFrame[] = {0,0,0,0};
		colorBar[] = {1,1,1,1};
		type = 8; 
		style = 0; 
	};
		
	class ProgressText : RscTextC {
		idc = loadingProgressText_idc;
		style = 2;
		x = 0.323532; y = 0.666672;
		w = 0.352944; h = 0.039216;
		sizeEx = 0.03921;
		colorText[] = {0.543,0.5742,0.4102,1.0};
		text = ""; 
	};
		
	class ProgressReverse  {
		idc = loadingProgressReverse_idc;
		type = 45;
		style = 0;
		x = 0.022059; y = 0.911772; 
		w = 0.029412; h = 0.039216;
		texture = "#(argb,8,8,3)color(0,0,0,0)";
	};
};
