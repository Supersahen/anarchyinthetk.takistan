_f = execvm "mpframework\rise_framework_func.sqf";
_b = execvm "mpframework\rise_framework_base.sqf";

waituntil {(scriptdone _f) and (scriptdone _b)};

rise_framework_initialized = true;