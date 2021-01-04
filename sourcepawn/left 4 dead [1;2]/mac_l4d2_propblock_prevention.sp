#define PLUGIN_NAME           "L4D2 - Prop Softlock Patch"
#define PLUGIN_AUTHOR         "mac"
#define PLUGIN_DESCRIPTION    "Prevents prop_physics from softlocking the survivors at some map areas"
#define PLUGIN_VERSION        "v0.2_TEST"
#define PLUGIN_URL            ""

#include <sourcemod>
#include <sdktools>

#pragma semicolon 1

public Plugin myinfo =
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};


public void OnPluginStart()
{
	char mapname[32];
	if(GetCurrentMap(mapname,sizeof(mapname) > 0))
	{
		PrecacheModel("models/props_fortifications/traffic_barrier001.mdl", false);
		ManualPropBlockPrevention();
		CheckpointPropBlockPrevention();
	}
	else
	{
		PrintToServer("Hey Nick, that was my ass you shot. (Propblock plugin started when there's no map right now)");
	}
}

public void OnMapStart()
{
	PrecacheModel("models/props_fortifications/traffic_barrier001.mdl", false);
	ManualPropBlockPrevention();
	CheckpointPropBlockPrevention();
}

void CheckpointPropBlockPrevention()
{
	float brushorigin[3];
	float minbounds[3] = {-80.0, -80.0, -80.0};
	float maxbounds[3] = { 80.0,  80.0,  80.0};
	
//	Want the while loop to keep finding fresh ones (Am I doing this right?)
	int CheckpointDoor = FindEntityByClassname(-1, "prop_door_rotating_checkpoint");
	while (CheckpointDoor)
	{
		int checkpoint_entindex = EntRefToEntIndex(CheckpointDoor);
		int clip_vphysics_entindex = CreateEntityByName("func_clip_vphysics");

		DispatchSpawn(clip_vphysics_entindex);
		ActivateEntity(clip_vphysics_entindex);

		GetEntPropVector(checkpoint_entindex, Prop_Send, "m_vecOrigin", brushorigin);
		TeleportEntity(clip_vphysics_entindex, brushorigin, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(clip_vphysics_entindex, "models/props_fortifications/traffic_barrier001.mdl");

		SetEntPropVector(clip_vphysics_entindex, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(clip_vphysics_entindex, Prop_Send, "m_vecMaxs", maxbounds);

		SetEntProp(clip_vphysics_entindex, Prop_Send, "m_nSolidType", 2);

		int enteffects = GetEntProp(clip_vphysics_entindex, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(clip_vphysics_entindex, Prop_Send, "m_fEffects", enteffects);
	}	
}

void ManualPropBlockPrevention()
{
	float brushorigin[3];
	float minbounds[3];
	float maxbounds[3];
	char mapname[16];
	GetCurrentMap(mapname, sizeof(mapname));
	// These might be the only maps where I would do a manual patch?
	if (StrEqual(mapname, "c5m3_cemetery", false))
	{
		brushorigin[0] = 5944.0;
		brushorigin[1] = 376.0;
		brushorigin[2] = 32.0;
		
		minbounds[0] = -40.0;
		minbounds[1] = -40.0;
		minbounds[2] = -32.0;

		maxbounds[0] = 40.0;
		maxbounds[1] = 40.0;
		maxbounds[2] = 32.0;
	}	
	else if (StrEqual(mapname, "c8m3_sewers", false))
	{
		brushorigin[0] = 14272.0;
		brushorigin[1] = 11616.0;
		brushorigin[2] = 24.0;
		
		minbounds[0] = -32.0;
		minbounds[1] = -32.0;
		minbounds[2] = -24.0;

		maxbounds[0] = 32.0;
		maxbounds[1] = 32.0;
		maxbounds[2] = 24.0;
	}
	
	if (brushorigin[1])
	{
		int entindex = CreateEntityByName("func_clip_vphysics");

		DispatchSpawn(entindex);
		ActivateEntity(entindex);

		TeleportEntity(entindex, brushorigin, NULL_VECTOR, NULL_VECTOR);
		SetEntityModel(entindex, "models/props_fortifications/traffic_barrier001.mdl");

		SetEntPropVector(entindex, Prop_Send, "m_vecMins", minbounds);
		SetEntPropVector(entindex, Prop_Send, "m_vecMaxs", maxbounds);

		SetEntProp(entindex, Prop_Send, "m_nSolidType", 2);

		int enteffects = GetEntProp(entindex, Prop_Send, "m_fEffects");
		enteffects |= 32;
		SetEntProp(entindex, Prop_Send, "m_fEffects", enteffects);
	}	
}
/* 	if (entindex != -1)
	{
		DispatchKeyValue(entindex, "spawnflags", "64");
	} */