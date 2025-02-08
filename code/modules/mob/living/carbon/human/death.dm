/mob/living/carbon/human/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	var/is_a_synth = issynth(src)
	ghostize()
	for(var/obj/limb/E in limbs)
		if(istype(E, /obj/limb/chest))
			continue
		if(istype(E, /obj/limb/groin) && is_a_synth)
			continue
		// Only make the limb drop if it's not too damaged
		if(prob(100 - E.get_damage()))
			// Override the current limb status
			E.droplimb(0, 0, cause)



	GLOB.data_core.manifest_modify(real_name, WEAKREF(src), null, null, "*Deceased*")

	if(is_a_synth)
		spawn_gibs()
		return

	undefibbable = TRUE

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
		if(HAS_TRAIT(src, TRAIT_HARDCORE) || MODE_HAS_MODIFIER(/datum/gamemode_modifier/permadeath))
			if(!(species.flags & IS_SYNTHETIC)) // Synths wont perma
				status_flags |= PERMANENTLY_DEAD
		if(HAS_TRAIT(src, TRAIT_INTENT_EYES)) //their eyes need to be 'offline'
			r_eyes = 0
			g_eyes = 0
			b_eyes = 0
		disable_special_flags()
		disable_lights()
		disable_special_items()
		disable_headsets() //Disable radios for dead people to reduce load

	if(pulledby && isxeno(pulledby)) // Xenos lose grab on dead humans
		pulledby.stop_pulling()

	//Handle species-specific deaths.
	if(species)
		species.handle_death(src, gibbed)
	update_body() //if species handle_death or other procs change body in some way after death, this is what will update the body.

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MARINE_DEATH, src, gibbed)

	give_action(src, /datum/action/ghost)

	if(!should_block_game_interaction(src) && istype(SSticker.mode, /datum/game_mode/colonialmarines) && !(datum_flags & DF_VAR_EDITED) && ckey)
		var/datum/entity/marine_death/death_entry = DB_ENTITY(/datum/entity/marine_death)
		death_entry.load_data(src, cause)

	if(!gibbed && species.death_sound)
		playsound(loc, species.death_sound, 50, 1)

	// Finding the last guy for anti-delay.
	if(SSticker.mode && SSticker.mode.is_in_endgame && SSticker.current_state != GAME_STATE_FINISHED && is_mainship_level(z))
		var/mob/last_living_human
		var/shipside_humans_count = 0
		var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
		var/see_humans_on_tacmap = main_hive.see_humans_on_tacmap
		for(var/mob/living/carbon/human/cur_human as anything in GLOB.alive_human_list)
			if(!is_mainship_level(cur_human.z))
				continue
			shipside_humans_count++
			if(last_living_human && see_humans_on_tacmap)
				last_living_human = null
				break
			last_living_human = cur_human

		if(!see_humans_on_tacmap && shipside_humans_count < (main_hive.get_real_total_xeno_count() * HIJACK_RATIO_FOR_TACMAP))
			xeno_announcement("There is only a handful of tallhosts left, they are now visible on our hive mind map.", XENO_HIVE_NORMAL, SPAN_ANNOUNCEMENT_HEADER_BLUE("[QUEEN_MOTHER_ANNOUNCE]"))
			main_hive.see_humans_on_tacmap = TRUE
		if(last_living_human && shipside_humans_count <= 1 && (GLOB.last_qm_callout + 2 MINUTES) < world.time)
			GLOB.last_qm_callout = world.time
			// Tell the xenos where the human is.
			xeno_announcement("I sense the last tallhost hiding in [get_area_name(last_living_human)].", XENO_HIVE_NORMAL, SPAN_ANNOUNCEMENT_HEADER_BLUE("[QUEEN_MOTHER_ANNOUNCE]"))
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
			notify_ghosts(header = "Last Human", message = "There is only one person left: [last_living_human.real_name]!", source = last_living_human, action = NOTIFY_ORBIT)

	var/death_message = species.death_message
	if(HAS_TRAIT(src, TRAIT_HARDCORE))
		death_message = "valiantly falls to the ground, dead, unable to continue."

	. = ..(cause, gibbed, death_message)

	// stat is now set
	var/datum/cause_data/death_data = cause
	if(!gibbed && death_data?.cause_name != "gibbing")
		// Hilariously the gibbing proc causes death via droplimb which means gibbed is false...
		AddComponent(/datum/component/weed_food)
	else if(death_data?.cause_name == "existing")
		// Corpses spawn as gibbed true to avoid sfx, even though they aren't actually gibbed...
		AddComponent(/datum/component/weed_food)

	update_execute_hud()
