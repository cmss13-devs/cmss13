/datum/powernet
	var/list/nodes = list() // all APCs & sources
	var/powernet_name = ""

	var/newload = 0
	var/load = 0
	var/newavail = 0
	var/avail = 0
	var/viewload = 0
	var/number = 0

	var/perapc = 0 // per-apc avilability
	var/perapc_excess = 0
	var/netexcess = 0

/datum/powernet/process()
	load = newload
	newload = 0
	avail = newavail
	newavail = 0


	viewload = 0.8*viewload + 0.2*load

	viewload = floor(viewload)

	var/numapc = 0

	if(LAZYLEN(nodes)) // Added to fix a bad list bug -- TLE
		for(var/obj/structure/machinery/power/terminal/term in nodes)
			if( istype( term.master, /obj/structure/machinery/power/apc ) )
				numapc++

	netexcess = avail - load

	if(numapc)
		//very simple load balancing. If there was a net excess this tick then it must have been that some APCs used less than perapc, since perapc*numapc = avail
		//Therefore we can raise the amount of power rationed out to APCs on the assumption that those APCs that used less than perapc will continue to do so.
		//If that assumption fails, then some APCs will miss out on power next tick, however it will be rebalanced for the tick after.
		if (netexcess >= 0)
			perapc_excess = max(0, perapc_excess + min(netexcess/numapc, (avail - perapc) - perapc_excess))
		else
			perapc_excess = 0

		perapc = avail/numapc + perapc_excess

	if( netexcess > 100) // if there was excess power last cycle
		if(LAZYLEN(nodes))
			for(var/obj/structure/machinery/power/smes/S in nodes) // find the SMESes in the network
				if(S.powernet == src)
					S.restore() // and restore some of the power that was used
				else
					error("[S.name] (\ref[S]) had a [S.powernet ? "different (\ref[S.powernet])" : "null"] powernet to our powernet (\ref[src]).")
					nodes.Remove(S)


//Returns the amount of available power
/datum/powernet/proc/surplus()
	return max(avail - newload, 0)

//Returns the amount of excess power (before refunding to SMESs) from last tick.
//This is for machines that might adjust their power consumption using this data.
/datum/powernet/proc/last_surplus()
	return max(avail - load, 0)

//Attempts to draw power from a powernet. Returns the actual amount of power drawn
/datum/powernet/proc/draw_power(requested_amount)
	var/surplus = max(avail - newload, 0)
	var/actual_draw = min(requested_amount, surplus)
	newload += actual_draw

	return actual_draw

/datum/powernet/proc/get_electrocute_damage()
	switch(avail)
		if (1000000 to INFINITY)
			return min(rand(50,85),rand(50,85))
		if (200000 to 1000000)
			return min(rand(25,75),rand(25,75))
		if (100000 to 200000)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000)
			return min(rand(10,20),rand(10,20))
		else
			return 0
