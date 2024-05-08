//Xenomorph Evolution Code - Colonial Marines - Apophis775 - Last Edit: 11JUN16

//Recoded and consolidated by Abby -- ALL evolutions come from here now. It should work with any caste, anywhere
//All castes need an evolves_to() list in their defines
//Such as evolves_to = list(XENO_CASTE_WARRIOR, XENO_CASTE_SENTINEL, XENO_CASTE_RUNNER, "Badass") etc

/mob/living/carbon/xenomorph/verb/Evolve()
	set name = "Evolve"
	set desc = "Evolve into a higher form."
	set category = "Alien"

	do_evolve()

/mob/living/carbon/xenomorph/proc/do_evolve()
	var/potential_queens = 0

	if (!evolve_checks())
		return

	var/castes_available = caste.evolves_to.Copy()

	for(var/caste in castes_available)
		if(GLOB.xeno_datum_list[caste].minimum_evolve_time > ROUND_TIME)
			castes_available -= caste

	if(!length(castes_available))
		to_chat(src, SPAN_WARNING("The Hive is not capable of supporting any castes we can evolve to yet."))
		return
	var/castepick
	if((client.prefs && client.prefs.no_radials_preference) || !hive.evolution_menu_images)
		castepick = tgui_input_list(usr, "You are growing into a beautiful alien! It is time to choose a caste.", "Evolve", castes_available, theme="hive_status")
	else
		var/list/fancy_caste_list = list()
		for(var/caste in castes_available)
			fancy_caste_list[caste] = hive.evolution_menu_images[caste]

		castepick = show_radial_menu(src, src.client?.eye, fancy_caste_list)
	if(!castepick) //Changed my mind
		return

	var/datum/caste_datum/caste_datum = GLOB.xeno_datum_list[castepick]
	if(caste_datum && caste_datum.minimum_evolve_time > ROUND_TIME)
		to_chat(src, SPAN_WARNING("The Hive cannot support this caste yet! ([round((caste_datum.minimum_evolve_time - ROUND_TIME) / 10)] seconds remaining)"))
		return

	if(!evolve_checks())
		return

	if((!hive.living_xeno_queen) && castepick != XENO_CASTE_QUEEN && !islarva(src) && !hive.allow_no_queen_evo)
		to_chat(src, SPAN_WARNING("The Hive is shaken by the death of the last Queen. We can't find the strength to evolve."))
		return

	if(castepick == XENO_CASTE_QUEEN) //Special case for dealing with queenae
		if(!hardcore && hive.allow_queen_evolve)
			if(SSticker.mode && hive.xeno_queen_timer > world.time)
				to_chat(src, SPAN_WARNING("We must wait about [DisplayTimeText(hive.xeno_queen_timer - world.time, 1)] for the hive to recover from the previous Queen's death."))
				return

			if(plasma_stored >= 500)
				if(hive.living_xeno_queen)
					to_chat(src, SPAN_WARNING("There already is a living Queen."))
					return
			else
				to_chat(src, SPAN_WARNING("We require more plasma! Currently at: [plasma_stored] / 500."))
				return
		else
			to_chat(src, SPAN_WARNING("Nuh-uhh."))
			return
	if(evolution_threshold && castepick != XENO_CASTE_QUEEN) //Does the caste have an evolution timer? Then check it
		if(evolution_stored < evolution_threshold)
			to_chat(src, SPAN_WARNING("We must wait before evolving. Currently at: [evolution_stored] / [evolution_threshold]."))
			return

	// Used for restricting benos to evolve to drone/queen when they're the only potential queen
	for(var/mob/living/carbon/xenomorph/M in GLOB.living_xeno_list)
		if(hivenumber != M.hivenumber)
			continue

		switch(M.tier)
			if(0)
				if(islarva(M) && !ispredalienlarva(M))
					if(M.client && M.ckey)
						potential_queens++
				continue
			if(1)
				if(isdrone(M))
					if(M.client && M.ckey)
						potential_queens++

	var/mob/living/carbon/xenomorph/M = null

	M = GLOB.RoleAuthority.get_caste_by_text(castepick)

	if(isnull(M))
		to_chat(usr, SPAN_WARNING("[castepick] is not a valid caste! If you're seeing this message, tell a coder!"))
		return

	if(!can_evolve(castepick, potential_queens))
		return
	to_chat(src, SPAN_XENONOTICE("It looks like the hive can support our evolution to [SPAN_BOLD(castepick)]!"))

	visible_message(SPAN_XENONOTICE("\The [src] begins to twist and contort."), \
	SPAN_XENONOTICE("We begin to twist and contort."))
	xeno_jitter(25)
	evolving = TRUE
	var/level_to_switch_to = get_vision_level()

	if(!do_after(src, 2.5 SECONDS, INTERRUPT_INCAPACITATED|INTERRUPT_CHANGED_LYING, BUSY_ICON_HOSTILE)) // Can evolve while moving, resist or rest to cancel it.
		to_chat(src, SPAN_WARNING("We quiver, but nothing happens. Our evolution has ceased for now..."))

		evolving = FALSE
		return

	evolving = FALSE

	if(!isturf(loc)) //qdel'd or moved into something
		return
	if(castepick == XENO_CASTE_QUEEN) //Do another check after the tick.
		if(jobban_isbanned(src, XENO_CASTE_QUEEN))
			to_chat(src, SPAN_WARNING("You are jobbanned from the Queen role."))
			return
		if(hive.living_xeno_queen)
			to_chat(src, SPAN_WARNING("There already is a Queen."))
			return
		if(!hive.allow_queen_evolve)
			to_chat(src, SPAN_WARNING("We can't find the strength to evolve into a Queen"))
			return
	else if(!can_evolve(castepick, potential_queens))
		return

	// subtract the threshold, keep the stored amount
	evolution_stored -= evolution_threshold

	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/xenomorph/new_xeno = new M(get_turf(src), src)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(usr, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		stack_trace("Xeno evolution failed: [src] attempted to evolve into \'[castepick]\'")
		if(new_xeno)
			qdel(new_xeno)
		return

	var/area/xeno_area = get_area(new_xeno)
	if(!should_block_game_interaction(new_xeno) || (xeno_area.flags_atom & AREA_ALLOW_XENO_JOIN))
		switch(new_xeno.tier) //They have evolved, add them to the slot count IF they are in regular game space
			if(2)
				hive.tier_2_xenos |= new_xeno
			if(3)
				hive.tier_3_xenos |= new_xeno

	log_game("EVOLVE: [key_name(src)] evolved into [new_xeno].")
	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = src.key
		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	if(new_xeno.health - getBruteLoss(src) - getFireLoss(src) > 0) //Cmon, don't kill the new one! Shouldnt be possible though
		new_xeno.bruteloss = src.bruteloss //Transfers the damage over.
		new_xeno.fireloss = src.fireloss //Transfers the damage over.
		new_xeno.updatehealth()

	if(plasma_max == 0)
		new_xeno.plasma_stored = new_xeno.plasma_max
	else
		new_xeno.plasma_stored = new_xeno.plasma_max*(plasma_stored/plasma_max) //preserve the ratio of plasma

	new_xeno.built_structures = built_structures.Copy()

	built_structures = null

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [src]."), \
	SPAN_XENODANGER("We emerge in a greater form from the husk of our old body. For the hive!"))

	if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
		hive.living_xeno_queen.overwatch(new_xeno)

	src.transfer_observers_to(new_xeno)

	qdel(src)
	new_xeno.xeno_jitter(25)

	if (new_xeno.client)
		new_xeno.client.mouse_pointer_icon = initial(new_xeno.client.mouse_pointer_icon)

	if(new_xeno.mind && GLOB.round_statistics)
		GLOB.round_statistics.track_new_participant(new_xeno.faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)

/mob/living/carbon/xenomorph/proc/evolve_checks()
	if(!check_state(TRUE))
		return FALSE

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("This place is too constraining to evolve."))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("We can't evolve here."))
		return FALSE

	if(hardcore)
		to_chat(src, SPAN_WARNING("Nuh-uh."))
		return FALSE

	if(lock_evolve)
		if(banished)
			to_chat(src, SPAN_WARNING("We are banished and cannot reach the hivemind."))
		else
			to_chat(src, SPAN_WARNING("We can't evolve."))
		return FALSE

	if(jobban_isbanned(src, JOB_XENOMORPH))//~who so genius to do this is?
		to_chat(src, SPAN_WARNING("You are jobbanned from aliens and cannot evolve. How did you even become an alien?"))
		return FALSE

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow us to evolve."))
		return FALSE

	if(isnull(caste.evolves_to))
		to_chat(src, SPAN_WARNING("We are already the apex of form and function. Go forth and spread the hive!"))
		return FALSE

	if(health < maxHealth)
		to_chat(src, SPAN_WARNING("We must be at full health to evolve."))
		return FALSE

	if(agility || fortify || crest_defense)
		to_chat(src, SPAN_WARNING("We cannot evolve while in this stance."))
		return FALSE

	if(world.time < (SSticker.mode.round_time_lobby + XENO_ROUNDSTART_PROGRESS_TIME_2))
		if(caste_type == XENO_CASTE_LARVA || caste_type == XENO_CASTE_PREDALIEN_LARVA)
			var/turf/evoturf = get_turf(src)
			if(!locate(/obj/effect/alien/weeds) in evoturf)
				to_chat(src, SPAN_WARNING("The hive hasn't developed enough yet for you to evolve off weeds!"))
				return FALSE

	return TRUE

// The queen de-evo, but on yourself. Only usable once
/mob/living/carbon/xenomorph/verb/Deevolve()
	set name = "De-Evolve"
	set desc = "De-evolve into a lesser form."
	set category = "Alien"

	if(!check_state())
		return

	if(is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("You can't deevolve here."))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_XENOWARNING("You can't deevolve here."))
		return

	if(health < maxHealth)
		to_chat(src, SPAN_XENOWARNING("We are too weak to deevolve, we must regain our health first."))
		return

	if(length(caste.deevolves_to) < 1)
		to_chat(src, SPAN_XENOWARNING("We can't deevolve any further."))
		return

	if(lock_evolve)
		if(banished)
			to_chat(src, SPAN_WARNING("We are banished and cannot reach the hivemind."))
		else
			to_chat(src, SPAN_WARNING("We can't deevolve."))
		return FALSE


	var/newcaste

	if(length(caste.deevolves_to) == 1)
		newcaste = caste.deevolves_to[1]
	else if(length(caste.deevolves_to) > 1)
		newcaste = tgui_input_list(src, "Choose a caste you want to de-evolve to.", "De-evolve", caste.deevolves_to, theme="hive_status")

	if(!newcaste)
		return

	var/confirm = tgui_alert(src, "Are you sure you want to de-evolve from [caste.caste_type] to [newcaste]?", "Deevolution", list("Yes", "No"))
	if(confirm != "Yes")
		return

	if(!check_state())
		return

	if(is_ventcrawling)
		return

	if(!isturf(loc))
		return

	if(health <= 0)
		return

	if(lock_evolve)
		to_chat(src, SPAN_WARNING("You are banished and cannot reach the hivemind."))
		return FALSE

	var/xeno_type
	var/level_to_switch_to = get_vision_level()
	switch(newcaste)
		if("Larva")
			xeno_type = /mob/living/carbon/xenomorph/larva
		if(XENO_CASTE_RUNNER)
			xeno_type = /mob/living/carbon/xenomorph/runner
		if(XENO_CASTE_DRONE)
			xeno_type = /mob/living/carbon/xenomorph/drone
		if(XENO_CASTE_SENTINEL)
			xeno_type = /mob/living/carbon/xenomorph/sentinel
		if(XENO_CASTE_SPITTER)
			xeno_type = /mob/living/carbon/xenomorph/spitter
		if(XENO_CASTE_LURKER)
			xeno_type = /mob/living/carbon/xenomorph/lurker
		if(XENO_CASTE_WARRIOR)
			xeno_type = /mob/living/carbon/xenomorph/warrior
		if(XENO_CASTE_DEFENDER)
			xeno_type = /mob/living/carbon/xenomorph/defender
		if(XENO_CASTE_BURROWER)
			xeno_type = /mob/living/carbon/xenomorph/burrower

	var/mob/living/carbon/xenomorph/new_xeno = new xeno_type(get_turf(src), src)

	new_xeno.built_structures = built_structures.Copy()

	built_structures = null

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(src, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		if(new_xeno)
			qdel(new_xeno)
		return

	log_game("EVOLVE: [key_name(src)] de-evolved into [new_xeno].")
	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = key
		if(new_xeno.client)
			new_xeno.client.change_view(GLOB.world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()
	if(new_xeno.client)
		new_xeno.set_lighting_alpha(level_to_switch_to)
	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [src]."), \
	SPAN_XENODANGER("We regress into our previous form."))

	if(GLOB.round_statistics && !new_xeno.statistic_exempt)
		GLOB.round_statistics.track_new_participant(faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)

	src.transfer_observers_to(new_xeno)

	qdel(src)

/mob/living/carbon/xenomorph/proc/can_evolve(castepick, potential_queens)
	var/selected_caste = GLOB.xeno_datum_list[castepick]?.type
	var/free_slot = LAZYACCESS(hive.free_slots, selected_caste)
	var/used_slot = LAZYACCESS(hive.used_slots, selected_caste)
	if(free_slot > used_slot)
		return TRUE

	var/used_tier_2_slots = length(hive.tier_2_xenos)
	var/used_tier_3_slots = length(hive.tier_3_xenos)
	for(var/caste_path in hive.free_slots)
		var/slots_free = hive.free_slots[caste_path]
		var/slots_used = hive.used_slots[caste_path]
		if(!slots_used)
			continue
		var/datum/caste_datum/current_caste = caste_path
		switch(initial(current_caste.tier))
			if(2)
				used_tier_2_slots -= min(slots_used, slots_free)
			if(3)
				used_tier_3_slots -= min(slots_used, slots_free)

	var/burrowed_factor = min(hive.stored_larva, sqrt(4*hive.stored_larva))
	var/totalXenos = round(burrowed_factor)
	for(var/mob/living/carbon/xenomorph/xeno as anything in hive.totalXenos)
		if(xeno.counts_for_slots)
			totalXenos++

	if(tier == 1 && (((used_tier_2_slots + used_tier_3_slots) / totalXenos) * hive.tier_slot_multiplier) >= 0.5 && castepick != XENO_CASTE_QUEEN)
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 2, wait for either more aliens to be born or someone to die."))
		return FALSE
	else if(tier == 2 && ((used_tier_3_slots / totalXenos) * hive.tier_slot_multiplier) >= 0.20 && castepick != XENO_CASTE_QUEEN)
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 3, wait for either more aliens to be born or someone to die."))
		return FALSE
	else if(hive.allow_queen_evolve && !hive.living_xeno_queen && potential_queens == 1 && islarva(src) && castepick != XENO_CASTE_DRONE)
		to_chat(src, SPAN_XENONOTICE("The hive currently has no sister able to become Queen! The survival of the hive requires you to be a Drone!"))
		return FALSE

	return TRUE
