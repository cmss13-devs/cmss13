/datum/xeno_strain/designer
	name = HIVELORD_DESIGNER
	description = "Test"
	flavor_description = "what"
	icon_state_prefix = "Designer"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/design, //third macro
		/datum/action/xeno_action/onclick/toggle_long_range/designer, //fourth macro
		/datum/action/xeno_action/activable/transfer_plasma/hivelord, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/active_toggle/toggle_speed, // readding it so it gets at the end of the ability list
	)

/datum/xeno_strain/designer/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.viewsize = WHISPERER_VIEWRANGE
	hivelord.health_modifier -= XENO_HEALTH_MOD_LARGE
	hivelord.plasmapool_modifier = 0.5 // -50% plasma pool
	hivelord.extra_build_dist = 12 // 1 + 12 = 13 tile build range
	hivelord.can_stack_builds = TRUE
	hivelord.phero_modifier += XENO_PHERO_MOD_LARGE
	hivelord.recalculate_health()
	hivelord.recalculate_plasma()
	hivelord.recalculate_pheromones()
	ADD_TRAIT(hivelord, TRAIT_ABILITY_SIGHT_IGNORE_REST, TRAIT_SOURCE_STRAIN)

	hivelord.set_resin_build_order(GLOB.resin_build_order_hivelord_designer)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(hivelord.selected_resin)
				break // Don't need to keep looking

/*
 * Coerce Resin ability
 */

// Remote resin building
/datum/action/xeno_action/activable/secrete_resin/design
	name = "Design Resin Construction (50)"
	action_icon_state = "secrete_resin"
	ability_name = "design resin"
	xeno_cooldown = 1 SECONDS
	thick = FALSE
	make_message = FALSE

	no_cooldown_msg = TRUE

	build_speed_mod = 2 // the actual building part takes twice as long

	macro_path = /datum/action/xeno_action/verb/verb_design_resin
	action_type = XENO_ACTION_CLICK

	var/last_use = 0
	var/care_about_adjacency = TRUE

/datum/action/xeno_action/activable/secrete_resin/design/use_ability(atom/target_atom, mods)
	if(!action_cooldown_check())
		return

	if(mods["click_catcher"])
		return

	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		return

	if(care_about_adjacency && !(target_turf in view(10, owner)))
		to_chat(owner, SPAN_XENONOTICE("We must have a direct line of sight!"))
		return

	// since actions are instanced per hivelord, and only one construction can be made at a time, tweaking the datum on the fly here is fine. you're going to have to figure something out if these conditions change, though
	if(care_about_adjacency)
		if(owner.Adjacent(target_turf))
			build_speed_mod = 1
		else
			build_speed_mod = initial(build_speed_mod)

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

/datum/action/xeno_action/verb/verb_design_resin()
	set category = "Alien"
	set name = "Design Resin"
	set hidden = TRUE
	var/action_name = "Design Resin (50)"
	handle_xeno_macro(src, action_name)

/obj/effect/alien/weeds/node/designer
	desc = "A wierd node, it look mutated."
	weed_strength = WEED_LEVEL_CONSTRUCT
	hibernate = TRUE

/obj/effect/alien/weeds/node/designer/speed
	name = "Flexible Design Node"
	icon_state = "weednode"

/obj/effect/alien/weeds/node/designer/cost
	name = "Optimized Design Node"
	icon_state = "weednode"

// farsight
/datum/action/xeno_action/onclick/toggle_long_range/designer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4
	delay = 0
