#define SleepWait(timeA) private["_waittt"]; _waittt = time + timeA; waitUntil {time >= _waittt};

cgate99 setPosATL [(getPosATL cgate99 select 0),(getPosATL cgate99 select 1),-5];
cgate98 setPosATL [(getPosATL cgate98 select 0),(getPosATL cgate98 select 1),-5];
cgate97 setPosATL [(getPosATL cgate97 select 0),(getPosATL cgate97 select 1),-5];
SleepWait(20)
cgate99 setPosATL [(getPosATL cgate99 select 0),(getPosATL cgate99 select 1),0];
cgate98 setPosATL [(getPosATL cgate98 select 0),(getPosATL cgate98 select 1),0];
cgate97 setPosATL [(getPosATL cgate97 select 0),(getPosATL cgate97 select 1),0];

//Opfor Base Gate
