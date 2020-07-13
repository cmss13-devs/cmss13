//Xenomorph Evolution Code - Colonial Marines - Apophis775 - Last Edit: 11JUN16

//Recoded and consolidated by Abby -- ALL evolutions come from here now. It should work with any caste, anywhere
//All castes need an evolves_to() list in their defines
//Such as evolves_to = list("Warrior", "Sentinel", "Runner", "Badass") etc

/mob/living/carbon/Xenomorph/verb/Evolve()
	set name = "Evolve"
	set desc = "Evolve into a higher form."
	set category = "Alien"
	var/potential_queens = 0

	if(is_ventcrawling)
		to_chat(src, SPAN_WARNING("This place is too constraining to evolve."))
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't evolve here."))
		return

	if(hardcore)
		to_chat(src, SPAN_WARNING("Nuh-uh."))
		return

	if(jobban_isbanned(src, "Alien"))
		to_chat(src, SPAN_WARNING("You are jobbanned from aliens and cannot evolve. How did you even become an alien?"))
		return

	if(is_mob_incapacitated(TRUE))
		to_chat(src, SPAN_WARNING("You can't evolve in your current state."))
		return

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow you to evolve."))
		return

	if(isXenoLarva(src)) //Special case for dealing with larvae
		if(amount_grown < max_grown)
			to_chat(src, SPAN_WARNING("You are not yet fully grown. Currently at: [amount_grown] / [max_grown]."))
			return

	if(isnull(caste.evolves_to))
		to_chat(src, SPAN_WARNING("You are already the apex of form and function. Go forth and spread the hive!"))
		return

	if(health < maxHealth)
		to_chat(src, SPAN_WARNING("You must be at full health to evolve."))
		return

	if (agility || fortify || crest_defense)
		to_chat(src, SPAN_WARNING("You cannot evolve while in this stance."))
		return

	//Debugging that should've been done

	var/castepick = input("You are growing into a beautiful alien! It is time to choose a caste.") as null|anything in caste.evolves_to
	if(!castepick) //Changed my mind
		return

	if(!isturf(loc)) //qdel'd or inside something
		return

	if(is_mob_incapacitated(TRUE))
		to_chat(src, SPAN_WARNING("You can't evolve in your current state."))
		return

	if((!hive.living_xeno_queen) && castepick != "Queen" && !isXenoLarva(src))
		to_chat(src, SPAN_WARNING("The Hive is shaken by the death of the last Queen. You can't find the strength to evolve."))
		return

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("The restraints are too restricting to allow you to evolve."))
		return

	if(castepick == "Queen") //Special case for dealing with queenae
		if(!hardcore)
			if(plasma_stored >= 500)
				if(hive.living_xeno_queen)
					to_chat(src, SPAN_WARNING("There already is a living Queen."))
					return
			else
				to_chat(src, SPAN_WARNING("You require more plasma! Currently at: [plasma_stored] / 500."))
				return

			if(ticker && ticker.mode && hive.xeno_queen_timer>world.time)
				to_chat(src, SPAN_WARNING("You must wait about [round((hive.xeno_queen_timer-world.time) / (60 SECONDS))] minutes for the hive to recover from the previous Queen's death."))
				return
		else
			to_chat(src, SPAN_WARNING("Nuh-uhh."))
			return

//Used for restricting benos to evolve to drone/queen when they're the only potential queen
	for(var/mob/living/carbon/Xenomorph/M in living_xeno_list)
		if(hivenumber == M.hivenumber)
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

	var/pooled_factor = min(hive.stored_larva, sqrt(4*hive.stored_larva))
	pooled_factor = round(pooled_factor)

	var/totalXenos = hive.totalXenos.len + pooled_factor

	if(tier == 1 && (((hive.tier_2_xenos.len + hive.tier_3_xenos.len) / totalXenos) * hive.tier_slot_multiplier) >= 0.5 && castepick != "Queen")
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 2, wait for either more aliens to be born or someone to die."))
		return

	else if(tier == 2 && ((hive.tier_3_xenos.len / hive.totalXenos.len) * hive.tier_slot_multiplier) >= 0.25 && castepick != "Queen")
		to_chat(src, SPAN_WARNING("The hive cannot support another Tier 3, wait for either more aliens to be born or someone to die."))
		return

	else if(!hive.living_xeno_queen && potential_queens == 1 && isXenoLarva(src) && castepick != "Drone")
		to_chat(src, SPAN_XENONOTICE("The hive currently has no sister able to become Queen! The survival of the hive requires you to be a Drone!"))
		return

	else
		to_chat(src, SPAN_XENONOTICE("It looks like the hive can support your evolution to <span style='font-weight: bold'>[castepick]!</span>"))

	var/mob/living/carbon/Xenomorph/M = null

	//Better to use a get_caste_by_text proc but ehhhhhhhh. Lazy.
	switch(castepick) //ADD NEW CASTES HERE!
		if("Larva" || "Bloody Larva") //Not actually possible, but put here for insanity's sake
			M = /mob/living/carbon/Xenomorph/Larva
		if("Runner")
			M = /mob/living/carbon/Xenomorph/Runner
		if("Drone")
			M = /mob/living/carbon/Xenomorph/Drone
		if("Carrier")
			M = /mob/living/carbon/Xenomorph/Carrier
		if("Hivelord")
			M = /mob/living/carbon/Xenomorph/Hivelord
		if("Burrower")
			M = /mob/living/carbon/Xenomorph/Burrower
		if("Praetorian")
			M = /mob/living/carbon/Xenomorph/Praetorian
		if("Ravager")
			M = /mob/living/carbon/Xenomorph/Ravager
		if("Sentinel")
			M = /mob/living/carbon/Xenomorph/Sentinel
		if("Spitter")
			M = /mob/living/carbon/Xenomorph/Spitter
		if("Lurker")
			M = /mob/living/carbon/Xenomorph/Lurker
		if ("Warrior")
			M = /mob/living/carbon/Xenomorph/Warrior
		if ("Defender")
			M = /mob/living/carbon/Xenomorph/Defender
		if("Queen")
			M = /mob/living/carbon/Xenomorph/Queen
		if("Crusher")
			M = /mob/living/carbon/Xenomorph/Crusher
		if("Boiler")
			M = /mob/living/carbon/Xenomorph/Boiler
		if("Predalien")
			M = /mob/living/carbon/Xenomorph/Predalien

	if(isnull(M))
		to_chat(usr, SPAN_WARNING("[castepick] is not a valid caste! If you're seeing this message, tell a coder!"))
		return

	if(evolution_threshold && castepick != "Queen") //Does the caste have an evolution timer? Then check it
		if(evolution_stored < evolution_threshold)
			to_chat(src, SPAN_WARNING("You must wait before evolving. Currently at: [evolution_stored] / [evolution_threshold]."))
			return

	visible_message(SPAN_XENONOTICE("\The [src] begins to twist and contort."), \
	SPAN_XENONOTICE("You begin to twist and contort."))
	xeno_jitter(25)
	if(do_after(src, 25, INTERRUPT_INCAPACITATED, BUSY_ICON_HOSTILE)) // Can evolve while moving
		if(!isturf(loc)) //qdel'd or moved into something
			return
		if(castepick == "Queen") //Do another check after the tick.
			if(jobban_isbanned(src, "Queen"))
				to_chat(src, SPAN_WARNING("You are jobbanned from the Queen role."))
				return
			if(hive.living_xeno_queen)
				to_chat(src, SPAN_WARNING("There already is a Queen."))
				return
		else
			if(tier == 1 && (((hive.tier_2_xenos.len + hive.tier_3_xenos.len) / totalXenos) * hive.tier_slot_multiplier) >= 0.5)
				to_chat(src, SPAN_WARNING("The hive cannot support another Tier 2, wait for either more aliens to be born or someone to die."))
				return

			else if(tier == 2 && ((hive.tier_3_xenos.len / hive.totalXenos.len) * hive.tier_slot_multiplier) >= 0.25)
				to_chat(src, SPAN_WARNING("The hive cannot support another Tier 3, wait for either more aliens to be born or someone to die."))
				return

		//From there, the new xeno exists, hopefully
		var/mob/living/carbon/Xenomorph/new_xeno = new M(get_turf(src), src)

		if(!istype(new_xeno))
			//Something went horribly wrong!
			to_chat(usr, SPAN_WARNING("Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!"))
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

		// If the player has self-deevolved before, don't allow them to do it again
		if(!(/mob/living/carbon/Xenomorph/verb/Deevolve in verbs))
			new_xeno.verbs -= /mob/living/carbon/Xenomorph/verb/Deevolve

		if(new_xeno.health - getBruteLoss(src) - getFireLoss(src) > 0) //Cmon, don't kill the new one! Shouldnt be possible though
			new_xeno.bruteloss = src.bruteloss //Transfers the damage over.
			new_xeno.fireloss = src.fireloss //Transfers the damage over.
			new_xeno.updatehealth()

		new_xeno.plasma_stored = new_xeno.plasma_max*(plasma_stored/plasma_max) //preserve the ratio of plasma

		new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_name] emerges from the husk of \the [src]."), \
		SPAN_XENODANGER("You emerge in a greater form from the husk of your old body. For the hive!"))

		if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
			hive.living_xeno_queen.set_queen_overwatch(new_xeno)
		qdel(src)
		new_xeno.xeno_jitter(25)

		if (new_xeno.client)
			new_xeno.client.mouse_pointer_icon = initial(new_xeno.client.mouse_pointer_icon)
		
		if(new_xeno.mind && round_statistics)
			round_statistics.track_new_participant(new_xeno.faction, -1) //so an evolved xeno doesn't count as two.
		SSround_recording.recorder.track_player(new_xeno)

	else
		to_chat(src, SPAN_WARNING("You quiver, but nothing happens. Hold still while evolving."))

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

	var/confirm = alert(src, "Are you sure you want to deevolve from [caste.caste_name] to [newcaste]? You can only do this once.", , "Yes", "No")
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
		if("Runner")
			xeno_type = /mob/living/carbon/Xenomorph/Runner
		if("Drone")
			xeno_type = /mob/living/carbon/Xenomorph/Drone
		if("Sentinel")
			xeno_type = /mob/living/carbon/Xenomorph/Sentinel
		if("Spitter")
			xeno_type = /mob/living/carbon/Xenomorph/Spitter
		if("Lurker")
			xeno_type = /mob/living/carbon/Xenomorph/Lurker
		if("Warrior")
			xeno_type = /mob/living/carbon/Xenomorph/Warrior
		if("Defender")
			xeno_type = /mob/living/carbon/Xenomorph/Defender
		if("Burrower")
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

	// Self-deevolve is only usable once
	new_xeno.verbs -= /mob/living/carbon/Xenomorph/verb/Deevolve

	new_xeno.visible_message(SPAN_XENODANGER("A [new_xeno.caste.caste_name] emerges from the husk of \the [src]."), \
	SPAN_XENODANGER("You regress into your previous form."))

	INVOKE_ASYNC(new_xeno, /mob/living/carbon/Xenomorph.proc/age_xeno, age) // no bone for self-deevolve

	if(round_statistics && !new_xeno.statistic_exempt)
		round_statistics.track_new_participant(faction, -1) //so an evolved xeno doesn't count as two.
	SSround_recording.recorder.track_player(new_xeno)
	qdel(src)