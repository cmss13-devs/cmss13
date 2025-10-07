/datum/reagents/vessel/New(maximum)
	if(!maximum)
		maximum = 1000
	..()

/// Injects all contents into an object
/datum/reagents/vessel/proc/inject_vessel(atom/target, interaction = NONE, reactions = TRUE, delay, method = NO_DELIVERY)
	var/delivery_method = method
	reaction(target, method, reactions)
	if(delay)
		sleep(delay)
	trans_to(target, total_volume, method = delivery_method) //yes, method = delivery_method is required
	qdel(src)
