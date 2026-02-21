//Stun targets when you reach 3 shots
/datum/component/heavy_buildup
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/heavy_shots = 0
	var/stun_threshold = 3
	var/dissipation_rate = 0.5 // Let it decay ig

/datum/component/heavy_buildup/Initialize(shots = 1, threshold = 3)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	heavy_shots = shots
	stun_threshold = threshold

	to_chat(parent, SPAN_XENOHIGHDANGER("We struggle to remain on our feet!"))
	START_PROCESSING(SSdcs, src)

/datum/component/heavy_buildup/InheritComponent(datum/component/heavy_buildup/component_var, increment_shot, increment_threshold)
	heavy_shots += (component_var ? component_var.heavy_shots : increment_shot)

	if(heavy_shots >= stun_threshold)
		var/mob/living/carbon/xenomorph/target_shot = parent

		if(target_shot.mob_size >= MOB_SIZE_BIG)
			return
		else
			to_chat(target_shot, SPAN_XENOHIGHDANGER("The massive impact knocks us off balance!"))
			target_shot.KnockDown(0.5)// Did you know i spent 2 hours trying to see what the issue was here using apply_effect(3, stun)? and for some reason stun doesnt knock people down, thanks harryob.

		qdel(src)
	return

/datum/component/heavy_buildup/process(delta_time)
	heavy_shots -= dissipation_rate * delta_time
	if(heavy_shots <= 0)
		qdel(src)

/datum/component/heavy_buildup/Destroy()
	STOP_PROCESSING(SSdcs, src)
	return ..()
