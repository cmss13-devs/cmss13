/proc/empulse(turf/epicenter, heavy_range, light_range, mob/causer, log=TRUE)
	if(!epicenter)
		return FALSE

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(log)
		msg_admin_attack("EMP with size ([heavy_range], [light_range]) in area [epicenter.loc.name] at ([epicenter.x],[epicenter.y],[epicenter.z])")

	if(heavy_range > 1)
		new /obj/effect/overlay/temp/emp_pulse(epicenter)

	playsound(epicenter, 'sound/effects/EMPulse.ogg', sound_range=light_range)

	var/datum/cause_data/cause_data = create_cause_data("EMP", causer)

	var/size = max(light_range, heavy_range)
	for(var/atom/thing in range(size, epicenter))
		var/distance = max(get_dist(epicenter, thing), 0)
		if(distance < heavy_range)
			thing.emp_act(1, cause_data)
		else if(distance == heavy_range)
			if(prob(50))
				thing.emp_act(1, cause_data)
			else
				thing.emp_act(2, cause_data)
		else if(distance <= light_range)
			thing.emp_act(2, cause_data)
	return TRUE

/// Handle all logging for an EMP attack. Only call this if its actually detrimental.
/proc/log_emp(mob/living/affected, datum/cause_data/cause_data)
	if(!istype(affected))
		return

	var/turf/location = get_turf(affected)

	if(QDELETED(affected) || !location)
		return

	if(cause_data)
		affected.last_damage_data = cause_data
	var/source = cause_data?.cause_name
	var/mob/firing_mob = cause_data?.resolve_mob()

	if(!firing_mob)
		log_attack("[key_name(affected)] was harmed by unknown EMP in [location.loc.name] at ([location.x],[location.y],[location.z])")
		return

	log_attack("[key_name(affected)] was harmed by EMP in [location.loc.name] caused by [source] at ([location.x],[location.y],[location.z])")
	if(!ismob(firing_mob))
		CRASH("Statistics attempted to track a source mob incorrectly: [firing_mob] ([source])")

	var/area/thearea = get_area(affected)
	if(affected == firing_mob)
		affected.attack_log += "\[[time_stamp()]\] <b>[key_name(affected)]</b> EMP'd themselves with \a <b>[source]</b> in [get_area(location)]."
	// One human EMP'd another, be worried about it but do everything basically the same
	else if(ishuman(firing_mob) && ishuman(affected) && affected.faction == firing_mob.faction && !thearea?.statistic_exempt)
		affected.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> EMP'd <b>[key_name(affected)]</b> with \a <b>[source]</b> in [get_area(location)]."
		firing_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> EMP'd <b>[key_name(affected)]</b> with \a <b>[source]</b> in [get_area(location)]."

		var/ff_msg = "[key_name(firing_mob)] EMP'd [key_name(affected)] with \a [source] in [get_area(location)] (<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[location.x];Y=[location.y];Z=[location.z]'>JMP LOC</a>) [ADMIN_JMP_USER(firing_mob)] [ADMIN_PM(firing_mob)]"
		var/ff_living = TRUE
		if(affected.stat == DEAD)
			ff_living = FALSE
		msg_admin_ff(ff_msg, ff_living)

		if(ishuman(firing_mob))
			var/mob/living/carbon/human/attacking_human = firing_mob
			attacking_human.track_friendly_fire(source)
	else
		affected.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> EMP'd <b>[key_name(affected)]</b> with \a <b>[source]</b> in [get_area(location)]."
		firing_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> EMP'd <b>[key_name(affected)]</b> with \a <b>[source]</b> in [get_area(location)]."
		msg_admin_attack("[key_name(firing_mob)] EMP'd [key_name(affected)] with \a [source] in [get_area(location)] ([location.x],[location.y],[location.z]).", location.x, location.y, location.z)
