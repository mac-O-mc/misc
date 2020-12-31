// Author: mac
// L4D1 Survivors, and no ammo piles for weapon variety

//------------------------------------------------------------------------------------------------------
printl("Running c6m3_port_survival.nut;macky's addon script")
IncludeScript( "left4bots_timers.nut" )	// quite a solid timer system; Auto deletes timers. Only annoyance is how the params system works. I fucking hate it, won't let me do functions without params

const zoey_model = "models/survivors/survivor_teenangst.mdl"
const francis_model = "models/survivors/survivor_biker.mdl"
const louis_model = "models/survivors/survivor_manager.mdl"
const Beign = "\x01"	// default color
const BrightGreen = "\x03"
const Orange = "\x04"
const OliveGreen = "\x05"

// == These are just so the script won't run again, apparently it reruns itself again when survival mode itself starts ==
function HasScriptAlreadyRan()
{
	local info_target_scriptran;
	if( info_target_scriptran = Entities.FindByName(info_target_scriptran, "info_target_scriptran"))
		return true;
	else
		return false;
}
AlreadyRan <- HasScriptAlreadyRan();
function SpawnScriptRanEntity()
{
	local info_target_scriptran;
	if( !info_target_scriptran = Entities.FindByName(info_target_scriptran, "info_target_scriptran"))
	{
		SpawnEntityFromTable("info_target", { targetname = "info_target_scriptran" } )
	}
}
//---------------------------------------------------------------------------------------------
// == L4D1 SURVIVORS RELATED START ==
// Prep L4D1 Survivors and their firearms
function SetupL4D1Survivors()
{
	/* local l4d1survivor_spawn = null;
	while( l4d1survivor_spawn = Entities.FindByClassname(l4d1survivor_spawn, "info_l4d1_survivor_spawn" ))
		EntFire(l4d1survivor_spawn.GetName(),"SpawnSurvivor"); */

	local l4d1survivor_relay = null;
	while( l4d1survivor_relay = Entities.FindByName(l4d1survivor_relay, "l4d1_survivors_relay" ))
		EntFire(l4d1survivor_spawn.GetName(),"Enable");
		DoEntFire(l4d1survivor_spawn.GetName(),"Trigger", null, 0.1, null, null);
}
// This needs a delay, as spawning l4d1 survivors takes some time
//// Isn't actualy just teleporting as it also setups Louis's minigun
/* function TeleportL4D1Survivors()
{
	local player;
	while( player = Entities.FindByClassnameNearest("player", Vector(-240, -1078, 458), 50); )
	{
		if( player.GetModelName() == zoey_model) {
			local infosurvivorposition = Entities.FindByName(infosurvivorposition, "zoey_station")
			player.SetOrigin(infosurvivorposition.GetOrigin())
			DoEntFire(!self,"SetGlowEnabled","0",null,null,player)
			SpawnScriptRanEntity();
		}
		if( player.GetModelName() == francis_model) {
			local infosurvivorposition = Entities.FindByName(infosurvivorposition, "francis_station")
			player.SetOrigin(infosurvivorposition.GetOrigin())
			DoEntFire(!self,"SetGlowEnabled","0",null,null,player)
			SpawnScriptRanEntity();
		}
		if( player.GetModelName() == louis_model) {
			EntFire("prop_mounted_machine_gun", "Kill")
			EntFire("l4d1_nav_blocker", "UnBlockNav")
			DoEntFire(!self,"SetGlowEnabled","0",null,null,player)
			SpawnScriptRanEntity();
		}
	}
} */
// Setups all but Louis's minigun
function SetupL4D1SurvivorsLoot()
{
  // Manage ammo spawn entity: Move some to the appropriate survivor locations, then delete the rest
	local ammospawn_ent = null;
	local ammospawn_count = 0;
	while( ammospawn_ent = Entities.FindByClassname(ammospawn_ent, "weapon_ammo_spawn" ))
	{
		ammospawn_count += 1;
		printl("FOUND #" + ammospawn_count.tostring() + " WEAPON_AMMO_SPAWN")
		if( ammospawn_count == 1)
		{
			ammospawn_ent.DebugTest <- function()
			{
				printl("OMPLAYERTOUCH")
			}
			ammospawn_ent.SetModel("models/props/terror/incendiary_ammo.mdl")
			ammospawn_ent.SetOrigin(Vector(280, -1040, 414))
			ammospawn_ent.ConnectOutput("OnPlayerTouch", "DebugTest")
			printl("L4D1 LOUIS FIRE AMMO SET")
		}
		else if( ammospawn_count == 2)
		{
			ammospawn_ent.SetAngles(QAngle(0, 47, 0))
			ammospawn_ent.SetOrigin(Vector(332, -364, 184))
			printl("L4D1 ZOEY / FRANCIS AMMO SET")
		}
		else
		{
			ammospawn_ent.Kill();
			printl("EXTRA AMMO DELETED")
		}
	}
}

function FireAllL4D1SurvivorRelated(testing)
{
	SetupL4D1Survivors(testing);
	SetupL4D1SurvivorsLoot(testing);
	SpawnScriptRanEntity(testing);
//	Left4Timers.AddTimer(null, 0.1, TeleportL4D1Survivors, null, false);
}

if( !AlreadyRan ) {
	Left4Timers.AddTimer(null, 0.6, FireAllL4D1SurvivorRelated, {testing = "null"}, false);
	AlreadyRan <- true;
}

// == Game Events ==
// Make L4D1 Survivors give items when a Tank is incapacitated, so they're more involved
function OnGameEvent_player_incapacitated( params )
{
	local Chance = RandomInt(1,3)
	if( Chance >= 2)
	{
		local player = GetPlayerFromUserID( params.userid )
		if( player.GetZombieType() == 8 )
			Director.L4D1SurvivorGiveItem();
	}
}
// Need to delete info_target_scriptran
function OnGameEvent_round_end( params )
{
	local info_target_scriptran;
	if( info_target_scriptran = Entities.FindByName(info_target_scriptran, "info_target_scriptran"))
		info_target_scriptran.Kill();
}
