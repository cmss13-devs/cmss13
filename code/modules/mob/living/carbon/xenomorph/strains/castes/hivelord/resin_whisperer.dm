/datum/xeno_strain/resin_whisperer
	name = HIVELORD_RESIN_WHISPERER
	description = "You lose your corrosive acid, your ability to secrete thick resin, your ability to reinforce resin secretions, sacrifice your ability to plant weed nodes outside of weeds, and you sacrifice a fifth of your plasma reserves to enhance your vision and gain a stronger connection to the resin. You can now remotely place resin secretions including weed nodes up to a distance of twelve paces!"
	flavor_description = "We let the resin guide us. It whispers, so listen closely."
	icon_state_prefix = "Resin Whisperer"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/remote, //third macro
		/datum/action/xeno_action/onclick/toggle_long_range/whisperer, //fourth macro
		/datum/action/xeno_action/activable/transfer_plasma/hivelord, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/active_toggle/toggle_speed, // readding it so it gets at the end of the ability list
	)

/datum/xeno_strain/resin_whisperer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.plasmapool_modifier = 0.8 // -20% plasma pool
	hivelord.extra_build_dist = 12 // 1 + 12 = 13 tile build range
	hivelord.can_stack_builds = TRUE
	hivelord.recalculate_plasma()
	ADD_TRAIT(hivelord, TRAIT_ABILITY_SIGHT_IGNORE_REST, TRAIT_SOURCE_STRAIN)

	hivelord.set_resin_build_order(GLOB.resin_build_order_hivelord_whisperer)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			choose_resin_ability.update_button_icon(hivelord.selected_resin)
			break // Don't need to keep looking

/*
 * Coerce Resin ability
 */

// Remote resin building
/datum/action/xeno_action/activable/secrete_resin/remote
	name = "Coerce Resin (100)"
	action_icon_state = "secrete_resin"
	xeno_cooldown = 2.5 SECONDS
	thick = FALSE
	make_message = FALSE

	no_cooldown_msg = TRUE

	build_speed_mod = 2.5 // the actual building part takes twice as long

	macro_path = /datum/action/xeno_action/verb/verb_coerce_resin
	action_type = XENO_ACTION_CLICK

	var/last_use = 0
	var/care_about_adjacency = TRUE

/datum/action/xeno_action/activable/secrete_resin/remote/use_ability(atom/target_atom, mods)
	if(!can_remote_build())
		to_chat(owner, SPAN_XENONOTICE("We must be standing on weeds to establish a connection to the resin."))
		return

	if(!action_cooldown_check())
		return

	if(mods[CLICK_CATCHER])
		return

	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		return

	if(care_about_adjacency && !(target_turf in view(10, owner)))
		to_chat(owner, SPAN_XENONOTICE("We must have a direct line of sight!"))
		return

	/// Check if the target is a resin door and open or close it

	if(istype(target_atom, /obj/structure/mineral_door/resin))
		// Either we can't remotely reinforce the door, or its already reinforced
		if(!thick || istype(target_atom, /obj/structure/mineral_door/resin/thick))
			var/obj/structure/mineral_door/resin/resin_door = target_atom
			if(resin_door.TryToSwitchState(owner))
				if(resin_door.open)
					to_chat(owner, SPAN_XENONOTICE("We focus our connection to the resin and remotely close the resin door."))
				else
					to_chat(owner, SPAN_XENONOTICE("We focus our connection to the resin and remotely open the resin door."))
			return

	// since actions are instanced per hivelord, and only one construction can be made at a time, tweaking the datum on the fly here is fine. you're going to have to figure something out if these conditions change, though
	if(care_about_adjacency)
		if(owner.Adjacent(target_turf))
			build_speed_mod = 1
			xeno_cooldown = 1 SECONDS
		else
			build_speed_mod = initial(build_speed_mod)
			xeno_cooldown = initial(xeno_cooldown)

	var/mob/living/carbon/xenomorph/hivelord = owner
	if(!..())
		return

	if(!hivelord.selected_resin)
		return

	var/datum/resin_construction/resing_construction = GLOB.resin_constructions_list[hivelord.selected_resin]
	target_turf.visible_message(SPAN_XENONOTICE("The weeds begin pulsating wildly and secrete resin in the shape of \a [resing_construction.construction_name]!"), null, 5)
	to_chat(owner, SPAN_XENONOTICE("We focus our plasma into the weeds below us and force the weeds to secrete resin in the shape of \a [resing_construction.construction_name]."))
	playsound(target_turf, "alien_resin_build", 25)
	return TRUE

// By default, the xeno must be on a weed tile in order to build from a distance.
/datum/action/xeno_action/activable/secrete_resin/remote/proc/can_remote_build()
	if(!locate(/obj/effect/alien/weeds) in get_turf(owner))
		return FALSE
	return TRUE

/datum/action/xeno_action/verb/verb_coerce_resin()
	set category = "Alien"
	set name = "Coerce Resin"
	set hidden = TRUE
	var/action_name = "Coerce Resin (150)"
	handle_xeno_macro(src, action_name)

// farsight
/datum/action/xeno_action/onclick/toggle_long_range/whisperer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4
	delay = 0
