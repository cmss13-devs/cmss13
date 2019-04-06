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
		src << "<span class='warning'>This place is too constraining to evolve.</span>"
		return

	if(!isturf(loc))
		src << "<span class='warning'>You can't evolve here.</span>"
		return

	if(hardcore)
		src << "<span class='warning'>Nuh-uh.</span>"
		return

	if(jobban_isbanned(src, "Alien"))
		src << "<span class='warning'>You are jobbanned from aliens and cannot evolve. How did you even become an alien?</span>"
		return

	if(is_mob_incapacitated(TRUE))
		src << "<span class='warning'>You can't evolve in your current state.</span>"
		return

	if(handcuffed || legcuffed)
		src << "<span class='warning'>The restraints are too restricting to allow you to evolve.</span>"
		return

	if(isXenoLarva(src)) //Special case for dealing with larvae
		if(amount_grown < max_grown)
			src << "<span class='warning'>You are not yet fully grown. Currently at: [amount_grown] / [max_grown].</span>"
			return

	if(isnull(caste.evolves_to))
		src << "<span class='warning'>You are already the apex of form and function. Go forth and spread the hive!</span>"
		return

	if(health < maxHealth)
		src << "<span class='warning'>You must be at full health to evolve.</span>"
		return

	if (agility || fortify || crest_defense)
		src << "<span class='warning'>You cannot evolve while in this stance.</span>"
		return

	//Debugging that should've been done
	// world << "[tierA] Tier 1"
	// world << "[tierB] Tier 2"
	// world << "[tierC] Tier 3"
	// world << "[totalXenos] Total"

	var/castepick = input("You are growing into a beautiful alien! It is time to choose a caste.") as null|anything in caste.evolves_to
	if(!castepick) //Changed my mind
		return

	if(!isturf(loc)) //qdel'd or inside something
		return

	if(is_mob_incapacitated(TRUE))
		src << "<span class='warning'>You can't evolve in your current state.</span>"
		return

	if((!hive.living_xeno_queen) && castepick != "Queen" && !isXenoLarva(src))
		src << "<span class='warning'>The Hive is shaken by the death of the last Queen. You can't find the strength to evolve.</span>"
		return

	if(handcuffed || legcuffed)
		src << "<span class='warning'>The restraints are too restricting to allow you to evolve.</span>"
		return

	if(castepick == "Queen") //Special case for dealing with queenae
		if(!hardcore)
			if(plasma_stored >= 500)
				if(hive.living_xeno_queen)
					src << "<span class='warning'>There already is a living Queen.</span>"
					return
			else
				src << "<span class='warning'>You require more plasma! Currently at: [plasma_stored] / 500.</span>"
				return

			if(hivenumber == 1 && ticker && ticker.mode && hive.xeno_queen_timer>world.time)
				src << "<span class='warning'>You must wait about [round((hive.xeno_queen_timer-world.time) / (60 SECONDS))] minutes for the hive to recover from the previous Queen's death.<span>"
				return
		else
			src << "<span class='warning'>Nuh-uhh.</span>"
			return

//Used for restricting benos to evolve to drone/queen when they're the only potential queen
	for(var/mob/living/carbon/Xenomorph/M in living_xeno_list)
		if(hivenumber == M.hivenumber)
			switch(M.tier)
				if(0)
					if(isXenoLarva(M,1))
						if(M.client && M.ckey)
							potential_queens++
					continue
				if(1)
					if(isXenoDrone(M))
						if(M.client && M.ckey)
							potential_queens++

	if(tier == 1 && (((hive.tier_2_xenos.len + hive.tier_3_xenos.len) / hive.totalXenos.len) * hive.tier_slot_multiplier)> 0.5 && castepick != "Queen")
		src << "<span class='warning'>The hive cannot support another Tier 2, wait for either more aliens to be born or someone to die.</span>"
		return

	else if(tier == 2 && ((hive.tier_3_xenos.len / hive.totalXenos.len) * hive.tier_slot_multiplier)> 0.25 && castepick != "Queen")
		src << "<span class='warning'>The hive cannot support another Tier 3, wait for either more aliens to be born or someone to die.</span>"
		return

	else if(!hive.living_xeno_queen && potential_queens == 1 && isXenoLarva(src) && castepick != "Drone")
		src << "<span class='xenonotice'>The hive currently has no sister able to become Queen! The survival of the hive requires you to be a Drone!</span>"
		return

	else
		src << "<span class='xenonotice'>It looks like the hive can support your evolution to <span style='font-weight: bold'>[castepick]!</span></span>"

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
			switch(hivenumber) // because it causes issues otherwise
				if(XENO_HIVE_NORMAL)
					M = /mob/living/carbon/Xenomorph/Queen
				if(XENO_HIVE_CORRUPTED)
					M = /mob/living/carbon/Xenomorph/Queen/Corrupted
				if(XENO_HIVE_ALPHA)
					M = /mob/living/carbon/Xenomorph/Queen/Alpha
				if(XENO_HIVE_BETA)
					M = /mob/living/carbon/Xenomorph/Queen/Beta
				if(XENO_HIVE_ZETA)
					M = /mob/living/carbon/Xenomorph/Queen/Zeta
		if("Crusher")
			M = /mob/living/carbon/Xenomorph/Crusher
		if("Boiler")
			M = /mob/living/carbon/Xenomorph/Boiler
		if("Predalien")
			M = /mob/living/carbon/Xenomorph/Predalien

	if(isnull(M))
		usr << "<span class='warning'>[castepick] is not a valid caste! If you're seeing this message, tell a coder!</span>"
		return

	if(evolution_threshold && castepick != "Queen") //Does the caste have an evolution timer? Then check it
		if(evolution_stored < evolution_threshold)
			src << "<span class='warning'>You must wait before evolving. Currently at: [evolution_stored] / [evolution_threshold].</span>"
			return

	visible_message("<span class='xenonotice'>\The [src] begins to twist and contort.</span>", \
	"<span class='xenonotice'>You begin to twist and contort.</span>")
	xeno_jitter(25)
	if(do_after(src, 25, FALSE, 5, BUSY_ICON_HOSTILE))
		if(!isturf(loc)) //qdel'd or moved into something
			return
		if(castepick == "Queen") //Do another check after the tick.
			if(jobban_isbanned(src, "Queen"))
				src << "<span class='warning'>You are jobbanned from the Queen role.</span>"
				return
			if(hive.living_xeno_queen)
				src << "<span class='warning'>There already is a Queen.</span>"
				return

		//From there, the new xeno exists, hopefully
		var/mob/living/carbon/Xenomorph/new_xeno = new M(get_turf(src), src)

		if(!istype(new_xeno))
			//Something went horribly wrong!
			usr << "<span class='warning'>Something went terribly wrong here. Your new xeno is null! Tell a coder immediately!</span>"
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
			if(new_xeno.client) new_xeno.client.change_view(world.view)

		//Regenerate the new mob's name now that our player is inside
		generate_name()

		if(new_xeno.health - getBruteLoss(src) - getFireLoss(src) > 0) //Cmon, don't kill the new one! Shouldnt be possible though
			new_xeno.bruteloss = src.bruteloss //Transfers the damage over.
			new_xeno.fireloss = src.fireloss //Transfers the damage over.
			new_xeno.updatehealth()

		new_xeno.plasma_stored = new_xeno.plasma_max*(plasma_stored/plasma_max) //preserve the ratio of plasma

		new_xeno.visible_message("<span class='xenodanger'>A [new_xeno.caste.caste_name] emerges from the husk of \the [src].</span>", \
		"<span class='xenodanger'>You emerge in a greater form from the husk of your old body. For the hive!</span>")

		round_statistics.total_xenos_created-- //so an evolved xeno doesn't count as two.

		if(hive.living_xeno_queen && hive.living_xeno_queen.observed_xeno == src)
			hive.living_xeno_queen.set_queen_overwatch(new_xeno)
		qdel(src)
		new_xeno.xeno_jitter(25)
	else
		src << "<span class='warning'>You quiver, but nothing happens. Hold still while evolving.</span>"
