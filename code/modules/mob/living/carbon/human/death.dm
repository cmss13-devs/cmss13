/mob/living/carbon/human/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	var/is_a_synth = issynth(src)
	for(var/obj/limb/E in limbs)
		if(istype(E, /obj/limb/chest))
			continue
		if(istype(E, /obj/limb/groin) && is_a_synth)
			continue
		// Only make the limb drop if it's not too damaged
		if(prob(100 - E.get_damage()))
			// Override the current limb status
			E.droplimb(0, 0, cause)

	undefibbable = TRUE

	GLOB.data_core.manifest_modify(real_name, WEAKREF(src), null, null, "*Deceased*")

	if(is_a_synth)
		spawn_gibs()
		return
	..()

/mob/living/carbon/human/gib_animation()
	new /obj/effect/overlay/temp/gib_animation(loc, src, species ? species.gibbed_anim : "gibbed-h")

/mob/living/carbon/human/spawn_gibs()
	if(species)
		hgibs(loc, viruses, src, species.flesh_color, species.blood_color)
	else
		hgibs(loc, viruses, src)

/mob/living/carbon/human/spawn_dust_remains()
	if(species)
		new species.remains_type(loc)
	else
		new /obj/effect/decal/cleanable/ash(loc)

/mob/living/carbon/human/dust_animation()
	new /obj/effect/overlay/temp/dust_animation(loc, src, "dust-h")

/mob/living/carbon/human/death(cause, gibbed)
	if(stat == DEAD)
		species?.handle_dead_death(src, gibbed)
		return
	GLOB.alive_human_list -= src
	if(!gibbed)
		disable_special_flags()
		disable_lights()
		disable_special_items()
		disable_headsets() //Disable radios for dead people to reduce load
	if(pulledby && isxeno(pulledby)) // Xenos lose grab on dead humans
		pulledby.stop_pulling()
	//Handle species-specific deaths.
	if(species)
		species.handle_death(src, gibbed)

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MARINE_DEATH, src, gibbed)

	give_action(src, /datum/action/ghost)

	if(!gibbed && species.death_sound)
		playsound(loc, species.death_sound, 50, 1)

	// Finding the last guy for anti-delay.
	if(SSticker.mode && SSticker.mode.is_in_endgame && SSticker.current_state != GAME_STATE_FINISHED && is_mainship_level(z))
		var/mob/last_living_human
		for(var/mob/living/carbon/human/H as anything in GLOB.alive_human_list)
			if(!is_mainship_level(H.z))
				continue
			if(last_living_human)
				last_living_human = null
				break
			last_living_human = H
		if(last_living_human)
			if((last_qm_callout + 2 MINUTES) > world.time)
				return
			last_qm_callout = world.time
			// Tell the xenos where the human is.
			xeno_announcement("I sense the last tallhost hiding in [get_area(last_living_human)].", XENO_HIVE_NORMAL, SPAN_ANNOUNCEMENT_HEADER_BLUE("[QUEEN_MOTHER_ANNOUNCE]"))
			// Tell the human he is the last guy.
			if(last_living_human.client)
				to_chat(last_living_human, SPAN_ANNOUNCEMENT_HEADER_BLUE("Panic creeps up your spine. You realize that you are the last survivor."))
			//disable delaycloaks
			var/mob/living/carbon/human/delayer = last_living_human
			if(istype(delayer.back, /obj/item/storage/backpack/marine/satchel/scout_cloak))
				var/obj/item/storage/backpack/marine/satchel/scout_cloak/delayer_cloak = delayer.back
				if(delayer_cloak.camo_active)
					delayer_cloak.deactivate_camouflage(delayer)
				delayer_cloak.cloak_cooldown = world.time + 1 HOURS //fuck you
				to_chat(delayer, SPAN_WARNING("Your [delayer_cloak] fizzles out and breaks!"))
			if(istype(delayer.wear_suit, /obj/item/clothing/suit/storage/marine/ghillie))
				var/obj/item/clothing/suit/storage/marine/ghillie/delayer_armour = delayer.wear_suit
				if(delayer_armour.camo_active)
					delayer_armour.deactivate_camouflage(delayer)
				delayer_armour.can_camo = FALSE //fuck you
				to_chat(delayer, SPAN_WARNING("Your [delayer_armour]'s camo system breaks!"))
			//tell the ghosts
			announce_dchat("There is only one person left: [last_living_human.real_name].", last_living_human)
	return ..(cause, gibbed, species.death_message)
