/datum/xeno_mutator/resinwhisperer
	name = "STRAIN: Hivelord - Resin Whisperer"
	description = "You lose the ability to make thick resin and offer up some of your acid and plasma reserves to enhance your vision and gain a stronger connection to the resin. You can now remotely place resin structures!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_HIVELORD)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/onclick/toggle_speed
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/remote, //third macro
		/datum/action/xeno_action/activable/transfer_plasma/hivelord, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/onclick/toggle_speed // readding it so it gets at the end of the ability list
	)
	keystone = TRUE

/datum/xeno_mutator/resinwhisperer/apply_mutator(var/datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/Xenomorph/Hivelord/xeno = mutator_set.xeno
	xeno.plasmapool_modifier = 0.8 // -20% plasma pool
	xeno.extra_build_dist = 12 // 1 + 12 = 13 tile build range
	xeno.can_stack_builds = TRUE

	xeno.client.change_view(10, src)

	xeno.mutation_type = HIVELORD_RESIN_WHISPERER
	mutator_update_actions(xeno)
	mutator_set.recalculate_actions(description, flavor_description)
	xeno.recalculate_plasma()

	xeno.set_resin_build_order(GLOB.resin_build_order_drone)
	for(var/datum/action/xeno_action/action in xeno.actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(xeno.selected_resin)
				break // Don't need to keep looking

/*
 *    Coerce Resin ability
 */

// Remote resin building
/datum/action/xeno_action/activable/secrete_resin/remote
	name = "Coerce Resin (100)"
	action_icon_state = "secrete_resin"
	ability_name = "coerce resin"
	var/last_use = 0
	xeno_cooldown = 1 SECONDS
	thick = FALSE
	make_message = FALSE

	no_cooldown_msg = TRUE

	var/care_about_adjacency = TRUE
	build_speed_mod = 2 // the actual building part takes twice as long

	macro_path = /datum/action/xeno_action/verb/verb_coerce_resin
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/secrete_resin/remote/use_ability(atom/A, mods)
	if(!action_cooldown_check())
		return

	if(mods["click_catcher"])
		return

	var/turf/T = get_turf(A)
	if(!T)
		return

	// since actions are instanced per xeno, and only one construction can be made at a time, tweaking the datum on the fly here is fine. you're going to have to figure something out if these conditions change, though
	if(care_about_adjacency)
		if(owner.Adjacent(T))
			build_speed_mod = 1
		else
			build_speed_mod = initial(build_speed_mod)

	var/mob/living/carbon/Xenomorph/X = owner
	if(!..())
		return

	if(!X.selected_resin)
		return

	var/datum/resin_construction/RC = GLOB.resin_constructions_list[X.selected_resin]
	T.visible_message(SPAN_XENONOTICE("The weeds begin pulsating wildly and secrete resin in the shape of \a [RC.construction_name]!"), null, 5)
	to_chat(owner, SPAN_XENONOTICE("You focus your plasma into the weeds below you and force the weeds to secrete resin in the shape of \a [RC.construction_name]."))
	playsound(T, "alien_resin_build", 25)

/datum/action/xeno_action/verb/verb_coerce_resin()
	set category = "Alien"
	set name = "Coerce Resin"
	set hidden = 1
	var/action_name = "Coerce Resin (150)"
	handle_xeno_macro(src, action_name)
