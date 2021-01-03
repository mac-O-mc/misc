//Author: mac
// Open up the inaccessible area, then move survivors's spawns away from the single good choke in the entire map.
//---------------------------------------------------------

// What we need to do:
// - Remove the rock debris
// - Move survivor's spawns
// - Scatter some weapon spawns.
////
//  Strangely, the VMF shows no entitie that manage the survival part of this map,
//  and I couldn't find them in vscripts either... Forget about continuing that though! We can inspect them in-game.
//---------------------------------------------------------
printl("Running c13m4_cutthroatcreek_survival.nut")
//IncludeScript("modules/mac_timers.nut")

function PostTimer()
{
	// Delete the blocking survival rock props
	local RockDebrisProp_SurvivorBlock = Entities.FindByClassnameNearest("prop_dynamic", Vector(-311, 2092, -202), 85);
	// Why this though? Couldn't the manhole just be sealed up?
	local RockDebrisProp_InfectedBlock = Entities.FindByClassnameNearest("prop_dynamic", Vector(-800, 1376, -315), 85);
	if(!RockDebrisProp_SurvivorBlock || !RockDebrisProp_InfectedBlock)
	{
		// we should not throw an exception here or it'll brick scriptedmode.
		ClientPrint(null, DirectorScript.HUD_PRINTTALK, "\x04OI MATE, RockDebrisProp_SurvivorBlock or RockDebrisProp_InfectedBlock is invalid!")
		return false;
	}
	Assert(RockDebrisProp_SurvivorBlock, "Invalid script handle for 'RockDebrisProp_SurvivorBlock'.");
	Assert(RockDebrisProp_InfectedBlock, "Invalid script handle for 'RockDebrisProp_InfectedBlock'.");
	DoEntFire("!self","Kill", null, null, null, RockDebrisProp_SurvivorBlock)
	DoEntFire("!self","Kill", null, null, null, RockDebrisProp_InfectedBlock)

	// UnBlock the Survival only 'func_nav_blocker', which is one big overscaled brush for some reason
	//- TODO: Is there any extra hidden 'func_nav_blocker' brushes in the map?
	// local FUNCNAVBLOCKER = Entities.FindByClassnameNearest("func_nav_blocker", Vector(-676, 1376, -315), 85); // see TODO
	EntFire("func_nav_blocker","UnBlockNav")

	//---------------------------------------------------------
	// -- New Weapon Spawns --
	//---------------------------------------------------------
}