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
		/datum/action/xeno_action/activable/secrete_resin/remote/whisperer, //third macro
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


// farsight
/datum/action/xeno_action/onclick/toggle_long_range/whisperer
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4
	delay = 0
