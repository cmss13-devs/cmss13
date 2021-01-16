/datum/xeno_mutator/resinwhisperer
	name = "STRAIN: Hivelord - Resin Whisperer"
	description = "You lose the ability to make thick resin and offer up some of your acid and plasma reserves to enhance your vision and gain a stronger connection to the resin. You can now remotely place resin structures!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Hivelord")
	mutator_actions_to_remove = list("Secrete Thick Resin", "Corrosive Acid (100)", "Resin Walker (50)")
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/remote, //third macro
		/datum/action/xeno_action/onclick/toggle_speed, //fourth macro
		/datum/action/xeno_action/onclick/toggle_long_range,
	)
	keystone = TRUE

/datum/xeno_mutator/resinwhisperer/apply_mutator(var/datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/Xenomorph/Hivelord/H = MS.xeno
	H.plasmapool_modifier = 0.8 // -20% plasma pool
	H.extra_build_dist = 12 // 1 + 12 = 13 tile build range

	H.tileoffset = 3
	H.viewsize = 10 // +3 tiles ahead

	H.mutation_type = HIVELORD_RESIN_WHISPERER
	mutator_update_actions(H)
	MS.recalculate_actions(description, flavor_description)
	H.recalculate_plasma()

	H.resin_build_order = GLOB.resin_build_order_default

/*
 *    Coerce Resin ability
 */

// Remote resin building
/datum/action/xeno_action/activable/secrete_resin/remote
	name = "Coerce Resin (100)"
	action_icon_state = "secrete_resin"
	ability_name = "coerce resin"
	var/last_use = 0
	cooldown = 20
	thick = FALSE
	make_message = FALSE

	macro_path = /datum/action/xeno_action/verb/verb_coerce_resin
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/secrete_resin/remote/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/X = owner
	if(!X)
		return FALSE

	// Account for the do_after in the resin building proc when checking cooldown
	var/datum/resin_construction/RC = GLOB.resin_constructions_list[X.resin_build_order[X.selected_resin]]
	var/total_build_time = RC.build_time*X.caste.build_time_mult
	return (world.time >= last_use + (total_build_time + cooldown))

/datum/action/xeno_action/activable/secrete_resin/remote/use_ability(atom/A)
	if(!action_cooldown_check())
		return

	var/turf/T = get_turf(A)
	if(!T)
		return
	var/list/line_turfs = getline(get_turf(owner), T)

	for(var/turf/LT in line_turfs)
		if(LT.density)
			to_chat(owner, "You need a clear line of sight to do this!")
			return

	var/mob/living/carbon/Xenomorph/X = owner
	if(!..())
		return

	last_use = world.time

	var/datum/resin_construction/RC = GLOB.resin_constructions_list[X.resin_build_order[X.selected_resin]]
	T.visible_message(SPAN_XENONOTICE("The weeds begin pulsating wildly and secrete resin in the shape of \a [RC.construction_name]!"), null, 5)
	to_chat(owner, SPAN_XENONOTICE("You focus your plasma into the weeds below you and force the weeds to secrete resin in the shape of \a [RC.construction_name]."))
	playsound(T, "alien_resin_build", 25)

/datum/action/xeno_action/verb/verb_coerce_resin()
	set category = "Alien"
	set name = "Coerce Resin"
	set hidden = 1
	var/action_name = "Coerce Resin (150)"
	handle_xeno_macro(src, action_name)
