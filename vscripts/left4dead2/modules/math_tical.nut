/* //------------------------------------------------------
//		Module Author: mac
//		https://github.com/mac-O-mc
//------------------------------------------------------

// Alright, we had our fun with modules, that's enough

//if (!("Math_tical" in getroottable()))
//{
	
	::Math_tical <- {}

	::Math_tical.Round <- function(floatnum)
	{
		local floornum = floor(floatnum)
		local ceilnum = ceil(floatnum)
		if(floatnum - floornum >= 0.5)
			return ceilnum
		else
			return floatnum
	}
	
	::Math_tical.IsMultipleOf <- function(num, factor)
	{
		if(::Math_tical.Round(num) % factor == 0)
			return true
	}
	
	::Math_tical.ToClosestMultipleOf <- function(num, factor)
	{
	// modulo is nice but there's a better way, see this magic I've been taught... see: creator of P3, by NPSim...
	//// The second field acts as the multipler
	// 6.5 / 4 = 1.625
	// ROUND 1.625, we get 2
	// take 4, multiple it by 2, wallah, 8!
		return factor * (::Math_tical.Round(num / factor))
	}
//} */