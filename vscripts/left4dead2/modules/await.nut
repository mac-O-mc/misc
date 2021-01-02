//------------------------------------------------------
//		Inspired by eryn's Promise for ROBLOX.
//		... although not for accomplishing the same thing.
//		https://github.com/evaera/roblox-lua-promise
//
//		Await Author: mac
//		https://github.com/mac-O-mc
//------------------------------------------------------

const Beign = "\x01"	// default color
const BrightGreen = "\x03"
const Orange = "\x04"
const OliveGreen = "\x05"

if (!("Await" in getroottable()))
{
	printl("Loading module: Await.nut")
	::Await <-
	{
	//	ThinkEnt = null	// Model #2 version
		CoroutineTasks = {}
	}

	::Await.Delay <- function(seconds, func)
	{	
		if(type(seconds) == "integer" || type(seconds) == "float")
			throw "Bad argument #1 to Await.Delay; Value was not integer or float.";
		// If seconds is less than 1 / 100, assume seconds is 1 / 100.
		// Think functions rethink every 100 ms
		if (!seconds >= 1 / 100) // || seconds == RAND_MAX
			seconds = 1 / 100;
			
		local coroutine = newthread(func);
		local createTime = Time();
		local goalTime = startTime + seconds
		
		local tasknode = {
			coroutine = newthread(func),
			beginTime = createTime,
			goalTime = goalTime;
		}

		if(!::Await.CoroutineTasks._newslot == null) {
			::Await.CoroutineTasks._newslot <- function()
			{	
				::Await.CoroutineTasks
			}
		}	

		CoroutineTasks <- tasknode;
	//	CoroutineTasks <- [coroutine, seconds, CreatedTime];  // does this array format really work?
	//	CoroutineTasks <- {coroutine = coroutine, seconds = seconds, CreatedTime = Time()};
	}

	// for a different model
	/* ::Await.ThinkFunc <- function()
	{
		local cur_time = Time();
		
		foreach (key, coroutine in ::Await.CoroutineTasks)
		{
		//	if ((curtime - CoroutineTasks[idx][3]) >= CoroutineTasks[idx][2])  // does this array format really work?
		//	if ((curtime - val[3]) >= val[2])  // what about this? will this work?
		//// A table's better than using an Array; One's more readable than the other's Premature Optimizing
			if ((curtime - coroutine.CreatedTime) >= coroutine.seconds)
			{
				// no real code yet
				/* try
				{
					timer.Func(timer.params);
				}
				catch(exception)
				{
					printl("Await.ThinkFunc - Exception occured!");
					printl(Orange+"EXCEPTION:"+exception);
				} */
			}
		}
	} */
}
else
	ClientPrint(null, DirectorScript.HUD_PRINTTALK, Orange+"Await.nut attempting to load, when an 'Await' module already is loaded?")
