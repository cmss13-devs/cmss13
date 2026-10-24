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



	GLOB.data_core.manifest_modify(real_name, WEAKREF(src), null, null, "Deceased")

	if(is_a_synth)
		spawn_gibs()
		return

	var/turf/death_turf = get_turf(src)
	if(!should_block_game_interaction(src, TRUE) && (is_ground_level(death_turf.z) || is_mainship_level(death_turf.z) || is_reserved_level(death_turf.z)))
		new /mob/dead/mob_marker(death_turf, src)

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
			if(!(species.flags & IS_SYNTHETIC)) // Synths won't perma
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

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	main_hive?.check_antidelay(src)

	var/death_message = species.death_message
	if(HAS_TRAIT(src, TRAIT_HARDCORE))
		death_message = "valiantly falls to the ground, dead, unable to continue."

	. = ..(cause, gibbed, death_message)

	// Update dropship HUD overlays to show dead state
	init_dropship_hud_overlays()

	// stat is now set
	var/datum/cause_data/death_data = cause
	if(!gibbed && death_data?.cause_name != "gibbing")
		// Hilariously the gibbing proc causes death via droplimb which means gibbed is false...
		AddComponent(/datum/component/weed_food)
	else if(death_data?.cause_name == "existing")
		// Corpses spawn as gibbed true to avoid sfx, even though they aren't actually gibbed...
		AddComponent(/datum/component/weed_food)

	update_execute_hud()
