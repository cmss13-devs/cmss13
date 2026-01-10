/datum/reagents/vessel/New(maximum)
	if(!maximum)
		maximum = 1000
	..()

/// Injects all contents into an object
/datum/reagents/vessel/proc/inject_vessel(atom/target, interaction = NONE, reactions = TRUE, delay)
	reaction(target, interaction, reactions)
	if(delay)
		sleep(delay)
	trans_to(target, total_volume)
	qdel(src)
