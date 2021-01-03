//------------------------------------------------------
//     Author : Goben
//     https://steamcommunity.com/id/gobe_niuoll
//------------------------------------------------------

if (!("Left4Timers" in getroottable()))
{
	::Left4Timers <-
	{
		DummyEnt = null
		Timers = {}
	}

	::Left4Timers.AddTimer <- function(name, delay, func, params = {}, repeat = false)
	{
		if (!name || name == "")
			name = UniqueString();
		else if (name in ::Left4Timers.Timers)
		{
			printl("Left4Timers.AddTimer - A timer with this name already exists: " + name);
			return false;
		}
		
		local timer = { Delay = delay, Func = func, params = params, Repeat = repeat, LastTime = Time() };
		::Left4Timers.Timers[name] <- timer;
		
		return true;
	}

	::Left4Timers.RemoveTimer <- function(name)
	{
		if (!(name in ::Left4Timers.Timers))
		{
			printl("Left4Timers.RemoveTimer - A timer with this name does not exist: " + name);
			return false;
		}
		
		delete ::Left4Timers.Timers[name];
		
		return true;
	}

	::Left4Timers.ThinkFunc <- function()
	{
		local curtime = Time();
		local toDelete = [];
		
		foreach (timerName, timer in ::Left4Timers.Timers)
		{
			if ((curtime - timer.LastTime) >= timer.Delay)
			{
				try
				{
					timer.Func(timer.params);
				}
				catch(exception)
				{
					printl("Left4Timers.ThinkFunc - Exception: " + exception);
				}
				
				if (timer.Repeat)
					timer.LastTime = curtime;
				else
					toDelete.push(timerName);
			}
		}
		
		foreach (timerName in toDelete)
		{
			if (timerName in ::Left4Timers.Timers)
				delete ::Left4Timers.Timers[timerName];
		}
	}
}

if (!::Left4Timers.DummyEnt || !::Left4Timers.DummyEnt.IsValid())
{
	::Left4Timers.DummyEnt = SpawnEntityFromTable("info_target", { targetname = "left4timers" });
	if (::Left4Timers.DummyEnt)
	{
		::Left4Timers.DummyEnt.ValidateScriptScope();
		local scope = ::Left4Timers.DummyEnt.GetScriptScope();
		scope["L4TThinkFunc"] <- ::Left4Timers.ThinkFunc;
		AddThinkToEnt(::Left4Timers.DummyEnt, "L4TThinkFunc");
			
		printl("Left4Timers - Spawned dummy entity");
	}
	else
		printl("Left4Timers - Failed to spawn dummy entity!");
}
else
	printl("Left4Timers - Dummy entity already spawned");
