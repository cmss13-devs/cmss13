//Xenomorph Evolution Code - Colonial Marines - Apophis775 - Last Edit: 11JUN16

//Recoded and consolidated by Abby -- ALL evolutions come from here now. It should work with any caste, anywhere
//All castes need an evolves_to() list in their defines
//Such as evolves_to = list(XENO_CASTE_WARRIOR, XENO_CASTE_SENTINEL, XENO_CASTE_RUNNER, "Badass") etc

/mob/living/carbon/Xenomorph/verb/Evolve()
	set name = "Evolve"
	set desc = "Evolve into a higher form."
	set category = "Alien"
	var/potential_queens = 0

	if (!evolve_checks())
		return

	//Debugging that should've been done

	var/castepick = tgui_input_list(usr, "You are growing into a beautiful alien! It is time to choose a caste.", "Evolve", caste.evolves_to)
	if(!castepick) //Changed my mind
		return

	if(!isturf(loc)) //qdel'd or inside something
		return

	if (!evolve_checks())
		return

	if((!hive.living_xeno_queen) && castepick != XENO_CASTE_QUEEN && !isXenoLarva(src) && !hive.allow_no_queen_actions)
		to_chat(src, SPAN_WARNING("The Hive is shaken by the death of the last Queen. You can't find the strength to evolve."))
		return

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow you to evolve."))
		return

	if(castepick == XENO_CASTE_QUEEN) //Special case for dealing with queenae
		if(!hardcore)
			if(SSticker.mode && hive.xeno_queen_timer > world.time)
				to_chat(src, SPAN_WARNING("You must wait about [DisplayTimeText(hive.xeno_queen_timer - world.time, 1)] for the hive to recover from the previous Queen's death."))
				return

			if(plasma_stored >= 500)
				if(hive.living_xeno_queen)
					to_chat(src, SPAN_WARNING("There already is a living Queen."))
					return
			else
				to_chat(src, SPAN_WARNING("You require more plasma! Currently at: [plasma_stored] / 500."))
				return
		else
			to_chat(src, SPAN_WARNING("Nuh-uhh."))
			return
	if(evolution_threshold && castepick != XENO_CASTE_QUEEN) //Does the caste have an evolution timer? Then check it
		if(evolution_stored < evolution_threshold)
			to_chat(src, SPAN_WARNING("You must wait before evolving. Currently at: [evolution_stored] / [evolution_threshold]."))
			return

	// Used for restricting benos to evolve to drone/queen when they're the only potential queen
	for(var/mob/living/carbon/Xenomorph/M in GLOB.living_xeno_list)
		if(hivenumber != M.hivenumber)
			continue

		switch(M.tier)
			if(0)
				if(isXenoLarvaStrict(M))
					if(M.client && M.ckey)
						potential_queens++
				continue
			if(1)
				if(isXenoDrone(M))
					if(M.client && M.ckey)
						potential_queens++

	var/mob/living/carbon/Xenomorph/M = null

	//Better to use a get_caste_by_text proc but ehhhhhhhh. Lazy.
	switch(castepick) //ADD NEW CASTES HERE!
		if(XENO_CASTE_LARVA) //Not actually possible, but put here for insanity's sake
			M = /mob/living/carbon/Xenomorph/Larva
		if(XENO_CASTE_RUNNER)
			M = /mob/living/carbon/Xenomorph/Runner
		if(XENO_CASTE_DRONE)
			M = /mob/living/carbon/Xenomorph/Drone
		if(XENO_CASTE_CARRIER)
			M = /mob/living/carbon/Xenomorph/Carrier
		if(XENO_CASTE_HIVELORD)
			M = /mob/living/carbon/Xenomorph/Hivelord
		if(XENO_CASTE_BURROWER)
			M = /mob/living/carbon/Xenomorph/Burrower
		if(XENO_CASTE_PRAETORIAN)
			M = /mob/living/carbon/Xenomorph/Praetorian
		if(XENO_CASTE_RAVAGER)
			M = /mob/living/carbon/Xenomorph/Ravager
		if(XENO_CASTE_SENTINEL)
			M = /mob/living/carbon/Xenomorph/Sentinel
		if(XENO_CASTE_SPITTER)
			M = /mob/living/carbon/Xenomorph/Spitter
		if(XENO_CASTE_LURKER)
			M = /mob/living/carbon/Xenomorph/Lurker
		if (XENO_CASTE_WARRIOR)
			M = /mob/living/carbon/Xenomorph/Warrior
		if (XENO_CASTE_DEFENDER)
			M = /mob/living/carbon/Xenomorph/Defender
		if(XENO_CASTE_QUEEN)
			M = /mob/living/carbon/Xenomorph/Queen
		if(XENO_CASTE_CRUSHER)
			M = /mob/living/carbon/Xenomorph/Crusher
		if(XENO_CASTE_BOILER)
			M = /mob/living/carbon/Xenomorph/Boiler
		if(XENO_CASTE_PREDALIEN)
			M = /mob/living/carbon/Xenomorph/Predalien

	if(isnull(M))
		to_chat(usr, SPAN_WARNING("[castepick] is not a valid caste! If you're seeing this message, tell a coder!"))
		return

	if(!can_evolve(castepick, potential_queens))
		return
	to_chat(src, SPAN_XENONOTICE("It looks like the hive can support your evolution to [SPAN_BOLD(castepick)]!"))

	visible_message(SPAN_XENONOTICE("\The [src] begins to twist and contort."), \
	SPAN_XENONOTICE("You begin to twist and contort."))
	xeno_jitter(25)
	evolving = TRUE

	if(!do_after(src, 2.5 SECONDS, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE)) // Can evolve while moving
		to_chat(src, SPAN_WARNING("You quiver, but nothing happens. Hold still while evolving."))
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
			to_chat(src, SPAN_WARNING("You can't find the strength to evolve into a Queen"))
			return
	else if(!can_evolve(castepick, potential_queens))
		return

	//From there, the new xeno exists, hopefully
	var/mob/living/carbon/Xenomorph/new_xeno = new M(get_turf(src), src)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(usr, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		stack_trace("Xeno evolution failed: [src] attempted to evolve into \'[castepick]\'")
		if(new_xeno)
			qdel(new_xeno)
		return

	switch(new_xeno.tier) //They have evolved, add them to the slot count
		if(2)
			hive.tier_2_xenos |= new_xeno
		if(3)
			hive.tier_3_xenos |= new_xeno

	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = src.key
		if(new_xeno.client)
			new_xeno.client.change_view(world_view_size)

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()

	if(new_xeno.health - getBruteLoss(src) - getFireLoss(src) > 0) //Cmon, don't kill the new one! Shouldnt be possible though
		new_xeno.bruteloss = src.bruteloss //Transfers the damage over.
		new_xeno.fireloss = src.fireloss //Transfers the damage over.
		new_xeno.updatehealth()

	if(plasma_max == 0)
		new_xeno.plasma_stored = new_xeno.plasma_max
	else
		new_xeno.plasma_stored = new_xeno.plasma_max*(plasma_stored/plasma_max) //preserve the ratio of plasma

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [src]."), \
	SPAN_XENODANGER("You emerge in a greater form from the husk of your old body. For the hive!"))

	if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
		hive.living_xeno_queen.overwatch(new_xeno)

	qdel(src)
	new_xeno.xeno_jitter(25)

	if (new_xeno.client)
		new_xeno.client.mouse_pointer_icon = initial(new_xeno.client.mouse_pointer_icon)

	if(new_xeno.mind && round_statistics)
		round_statistics.track_new_participant(new_xeno.faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)

/mob/living/carbon/Xenomorph/proc/evolve_checks()
	if(evolving)
		to_chat(src, SPAN_WARNING("You are already evolving!"))
		return FALSE

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("This place is too constraining to evolve."))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't evolve here."))
		return FALSE

	if(hardcore)
		to_chat(src, SPAN_WARNING("Nuh-uh."))
		return FALSE

	if(jobban_isbanned(src, "Alien"))
		to_chat(src, SPAN_WARNING("You are jobbanned from aliens and cannot evolve. How did you even become an alien?"))
		return FALSE

	if(is_mob_incapacitated(TRUE))
		to_chat(src, SPAN_WARNING("You can't evolve in your current state."))
		return FALSE

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow you to evolve."))
		return FALSE

	if(isXenoLarva(src)) //Special case for dealing with larvae
		if(amount_grown < max_grown)
			to_chat(src, SPAN_WARNING("You are not yet fully grown. Currently at: [amount_grown] / [max_grown]."))
			return FALSE

	if(isnull(caste.evolves_to))
		to_chat(src, SPAN_WARNING("You are already the apex of form and function. Go forth and spread the hive!"))
		return FALSE

	if(health < maxHealth)
		to_chat(src, SPAN_WARNING("You must be at full health to evolve."))
		return FALSE

	if (agility || fortify || crest_defense)
		to_chat(src, SPAN_WARNING("You cannot evolve while in this stance."))
		return FALSE

	if(is_mob_incapacitated(TRUE))
		to_chat(src, SPAN_WARNING("You can't evolve in your current state."))
		return FALSE

	if(!isturf(loc)) //qdel'd or inside something
		return FALSE

	return TRUE

// The queen de-evo, but on yourself. Only usable once
/mob/living/carbon/Xenomorph/verb/Deevolve()
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
		to_chat(src, SPAN_XENOWARNING("You are too weak to deevolve, regain your health first."))
		return

	if(!caste.deevolves_to)
		to_chat(src, SPAN_XENOWARNING("You can't deevolve any further."))
		return

	var/newcaste = caste.deevolves_to

	var/confirm = alert(src, "Are you sure you want to deevolve from [caste.caste_type] to [newcaste]? You can only do this once.", , "Yes", "No")
	if(confirm == "No")
		return

	if(!check_state())
		return

	if(is_ventcrawling)
		return

	if(!isturf(loc))
		return

	if(health <= 0)
		return

	var/xeno_type

	switch(newcaste)
		if("Larva")
			xeno_type = /mob/living/carbon/Xenomorph/Larva
		if(XENO_CASTE_RUNNER)
			xeno_type = /mob/living/carbon/Xenomorph/Runner
		if(XENO_CASTE_DRONE)
			xeno_type = /mob/living/carbon/Xenomorph/Drone
		if(XENO_CASTE_SENTINEL)
			xeno_type = /mob/living/carbon/Xenomorph/Sentinel
		if(XENO_CASTE_SPITTER)
			xeno_type = /mob/living/carbon/Xenomorph/Spitter
		if(XENO_CASTE_LURKER)
			xeno_type = /mob/living/carbon/Xenomorph/Lurker
		if(XENO_CASTE_WARRIOR)
			xeno_type = /mob/living/carbon/Xenomorph/Warrior
		if(XENO_CASTE_DEFENDER)
			xeno_type = /mob/living/carbon/Xenomorph/Defender
		if(XENO_CASTE_BURROWER)
			xeno_type = /mob/living/carbon/Xenomorph/Burrower

	var/mob/living/carbon/Xenomorph/new_xeno = new xeno_type(get_turf(src), src)

	if(!istype(new_xeno))
		//Something went horribly wrong!
		to_chat(src, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
		if(new_xeno)
			qdel(new_xeno)
		return

	if(mind)
		mind.transfer_to(new_xeno)
	else
		new_xeno.key = key
		if(new_xeno.client)
			new_xeno.client.change_view(world_view_size)
			new_xeno.client.pixel_x = 0
			new_xeno.client.pixel_y = 0

	//Regenerate the new mob's name now that our player is inside
	new_xeno.generate_name()

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_type] emerges from the husk of \the [src]."), \
	SPAN_XENODANGER("You regress into your previous form."))

	if(round_statistics && !new_xeno.statistic_exempt)
		round_statistics.track_new_participant(faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)
	qdel(src)

/mob/living/carbon/Xenomorph/proc/can_evolve(castepick, potential_queens)
	var/selected_caste = GLOB.xeno_datum_list[castepick]?.type
	var/free_slots = LAZYACCESS(hive.free_slots, selected_caste)
	if(free_slots)
		return TRUE

	var/pooled_factor = min(hive.stored_larva, sqrt(4*hive.stored_larva))
	pooled_factor = round(pooled_factor)

	var/used_tier_2_slots = length(hive.tier_2_xenos)
	var/used_tier_3_slots = length(hive.tier_3_xenos)
	for(var/caste_path in hive.used_free_slots)
		if(!hive.used_free_slots[caste_path])
			continue
		var/datum/caste_datum/C = caste_path
		switch(initial(C.tier))
			if(2) used_tier_2_slots--
			if(3) used_tier_3_slots--

	var/totalXenos = length(hive.totalXenos) + pooled_factor

	if(tier == 1 && (((used_tier_2_slots + used_tier_3_slots) / totalXenos) * hive.tier_slot_multiplier) >= 0.5 && castepick != XENO_CASTE_QUEEN)
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 2, wait for either more aliens to be born or someone to die."))
		return FALSE
	else if(tier == 2 && ((used_tier_3_slots / length(hive.totalXenos)) * hive.tier_slot_multiplier) >= 0.20 && castepick != XENO_CASTE_QUEEN)
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 3, wait for either more aliens to be born or someone to die."))
		return FALSE
	else if(hive.allow_queen_evolve && !hive.living_xeno_queen && potential_queens == 1 && isXenoLarva(src) && castepick != XENO_CASTE_DRONE)
		to_chat(src, SPAN_XENONOTICE("The hive currently has no sister able to become Queen! The survival of the hive requires you to be a Drone!"))
		return FALSE

	return TRUE
