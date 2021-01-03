// Author: mac
// L4D1 Survivors, and no ammo piles for weapon variety

//------------------------------------------------------------------------------------------------------
// Script keeps randomly crashing the game, I already planned to ditch this script as its taking a toll on my life, anyways
printl("Running c6m3_port_survival.nut;macky's addon script")
// IncludeScript( "left4bots_timers.nut" )	// quite a solid timer system; Auto deletes timers. Only annoyance is how the params system works; Hard to do functions without params
//IncludeScript("modules/await.nut")

const zoey_model = "models/survivors/survivor_teenangst.mdl"
const francis_model = "models/survivors/survivor_biker.mdl"
const louis_model = "models/survivors/survivor_manager.mdl"

const ZOMBIE_TANK = 8

const Beign = "\x01"	// default color
const BrightGreen = "\x03"
const Orange = "\x04"
const OliveGreen = "\x05"

PrecacheModel(zoey_model.tostring())
PrecacheModel(francis_model.tostring())
PrecacheModel(louis_model.tostring())

function OnGameEvent_round_start_post_nav( params )
{
	/* local info_target_scriptran;
	if( !info_target_scriptran = Entities.FindByName(info_target_scriptran, "info_target_scriptran"))
	{
		SpawnEntityFromTable("info_target", { targetname = "info_target_scriptran" } )
	} */
/* 
	local l4d1survivor_relay = null;
	while( l4d1survivor_relay = Entities.FindByName(l4d1survivor_relay, "l4d1_survivors_relay" )) {
		DoEntFire("!self","Enable", null, 0.1, null, l4d1survivor_relay);
		DoEntFire("!self","Trigger", null, 0.1, null, l4d1survivor_relay);
	} */

//	EntFire("prop_mounted_machine_gun", "Kill", 0.2)
	EntFire("l4d1_nav_blocker", "UnBlockNav", null, 0.2)

	EntFire("!zoey","TeleportToSurvivorPosition","zoey_station",0.3)
	EntFire("!francis","TeleportToSurvivorPosition","francis_station",0.3)

	local director_ent;
	director_ent = Entities.FindByClassname(director_ent, "info_director");
	DoEntFire("!self","ReleaseSurvivorPositions",null,0.5,null,director_ent)

	local ammospawn_ent = null;
	local ammospawn_count = 0;
	while( ammospawn_ent = Entities.FindByClassname(ammospawn_ent, "weapon_ammo_spawn" ))
	{
		ammospawn_count += 1;
		printl("FOUND #" + ammospawn_count.tostring() + " WEAPON_AMMO_SPAWN")
		if( ammospawn_count == 1)
		{
		//	ammospawn_ent.SetModel("models/props/terror/incendiary_ammo.mdl") // lol
			ammospawn_ent.SetOrigin(Vector(280, -1040, 414))
	//		ammospawn_ent.ConnectOutput("OnPlayerTouch", "DebugTest")
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

// == Game Events ==
// Make L4D1 Survivors give items when a Tank is incapacitated, so they're more involved
function OnGameEvent_player_incapacitated( params )
{
	local Chance = RandomInt(1,3)
	if( Chance >= 2)
	{
		local player = GetPlayerFromUserID( params.userid )
		if( player.GetZombieType() == ZOMBIE_TANK )
			Director.L4D1SurvivorGiveItem();
	}
}
// Need to delete info_target_scriptran
function OnGameEvent_round_end( params )
{
	
}
