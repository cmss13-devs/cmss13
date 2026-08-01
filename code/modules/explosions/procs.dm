// Legacy proc spawning cellular automata explosions repurposed for our use. This should eventually go somewhere else and be cleaned up.
/proc/cell_explosion(turf/epicenter, power, falloff, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, datum/cause_data/explosion_cause_data, enviro=FALSE)
	if(!istype(explosion_cause_data))
		if(explosion_cause_data)
			stack_trace("cell_explosion called with string cause ([explosion_cause_data]) instead of datum")
			explosion_cause_data = create_cause_data(explosion_cause_data)
		else
			stack_trace("cell_explosion called without cause_data.")
			explosion_cause_data = create_cause_data("Explosion")

	falloff = max(falloff, power/100) // Clamp to make sure someone doesn't make an infinite explosion

	var/obj/causing_obj = explosion_cause_data?.resolve_cause()
	var/mob/causing_mob = explosion_cause_data?.resolve_mob()
	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff], Shape: [falloff_shape],[causing_obj ? " from [causing_obj]" : ""][causing_mob ? " by [key_name(causing_mob)]" : ""] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", epicenter.x, epicenter.y, epicenter.z)

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1))

	if(power >= 300) //Make BIG BOOMS
		playsound(epicenter, "bigboom", 80, 1, max(round(power,1),7))
	else
		playsound(epicenter, "explosion", 90, 1, max(round(power,1),7))

	// We make one common list for all of this explosions' blastwaves to refer to so that all of them can only explode each atom once
	var/list/exploded_list = list()

	if(direction)
		new /datum/explosion_wave(epicenter, dir = direction, power = power, falloff = falloff, falloff_shape = falloff_shape, cause_data = explosion_cause_data, exploded_list = exploded_list)
	else
		for(var/dir in GLOB.cardinals)
			new /datum/explosion_wave(epicenter, dir = dir, power = power, falloff = falloff, falloff_shape = falloff_shape, cause_data = explosion_cause_data, exploded_list = exploded_list)

	if(power >= 150) //shockwave for anything over 150 power
		new /obj/effect/shockwave(epicenter, power/50)

	if(power >= 100) // powerful explosions send out some special effects
		epicenter = get_turf(epicenter) // the ex_acts might have changed the epicenter
		new /obj/shrapnel_effect(epicenter)

	var/effect_radius = power / falloff
	if(power >= 300) // constructor is small, large, tiny. idk why TGMC didn't make this an enum?
		new /obj/effect/temp_visual/explosion(epicenter, effect_radius, FALSE, TRUE, FALSE)
	else if(power >= 200)
		new /obj/effect/temp_visual/explosion(epicenter, effect_radius, FALSE, FALSE, FALSE)
	else if (power >= 150)
		new /obj/effect/temp_visual/explosion(epicenter, effect_radius, TRUE, FALSE, FALSE)
	else
		new /obj/effect/temp_visual/explosion(epicenter, effect_radius, FALSE, FALSE, TRUE)

	// Possibly you can add screenshake on top of all that but you'll need to scan nearby mobs for that and it sucks


/// Handle all logging for an automata_cell explosion.
/proc/log_explosion(mob/living/affected, datum/automata_cell/explosion/explosion)
	if(!istype(affected))
		return

	var/turf/location = get_turf(affected)

	if(QDELETED(affected) || !location)
		return

	affected.last_damage_data = explosion.explosion_cause_data
	var/explosion_source = explosion.explosion_cause_data?.cause_name
	var/mob/firing_mob = explosion.explosion_cause_data?.resolve_mob()

	if(!firing_mob)
		log_attack("[key_name(affected)] was harmed by unknown explosion in [location.loc.name] at ([location.x],[location.y],[location.z])")
		return

	log_attack("[key_name(affected)] was harmed by explosion in [location.loc.name] caused by [explosion_source] at ([location.x],[location.y],[location.z])")
	if(!ismob(firing_mob))
		CRASH("Statistics attempted to track a source mob incorrectly: [firing_mob] ([explosion_source])")

	var/area/thearea = get_area(affected)
	if(affected == firing_mob)
		affected.attack_log += "\[[time_stamp()]\] <b>[key_name(affected)]</b> blew themself up with \a <b>[explosion_source]</b> in [get_area(location)]."
	// One human blew up another, be worried about it but do everything basically the same
	else if(ishuman(firing_mob) && ishuman(affected) && affected.faction == firing_mob.faction && !thearea?.statistic_exempt)
		affected.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(affected)]</b> with \a <b>[explosion_source]</b> in [get_area(location)]."
		firing_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(affected)]</b> with \a <b>[explosion_source]</b> in [get_area(location)]."

		var/ff_msg = "[key_name(firing_mob)] blew up [key_name(affected)] with \a [explosion_source] in [get_area(location)] [ADMIN_JUMP_COORDS(location.x, location.y, location.z)] [ADMIN_JMP_USER(firing_mob)] [ADMIN_PM(firing_mob)]"
		var/ff_living = TRUE
		if(affected.stat == DEAD)
			ff_living = FALSE
		msg_admin_ff(ff_msg, ff_living, firing_mob.loc.z)

		if(ishuman(firing_mob))
			var/mob/living/carbon/human/attacking_human = firing_mob
			attacking_human.track_friendly_fire(explosion_source)
	else
		affected.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(affected)]</b> with \a <b>[explosion_source]</b> in [get_area(location)]."
		firing_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(affected)]</b> with \a <b>[explosion_source]</b> in [get_area(location)]."
		msg_admin_attack("[key_name(firing_mob)] blew up [key_name(affected)] with \a [explosion_source] in [get_area(location)] ([location.x],[location.y],[location.z]).", location.x, location.y, location.z)
