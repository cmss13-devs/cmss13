/datum/xeno_strain/sculptor
	name = HIVELORD_SCULPTOR
	description = "You lose your corrosive acid, your ability to secrete thick resin, your ability to reinforce resin secretions, sacrifice your ability to plant weed nodes outside of weeds, and you sacrifice a fifth of your plasma reserves to enhance your vision and gain a stronger connection to the resin. You can now remotely place resin secretions including weed nodes up to a distance of twelve paces!"
	flavor_description = "We let the resin guide us. It whispers, so listen closely."
	icon_state_prefix = "Sculptor"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/active_toggle/toggle_speed,
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/sculptor, //third macro
		/datum/action/xeno_action/activable/corrosive_acid/weak, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/activable/transfer_plasma/hivelord, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/active_toggle/toggle_speed, // readding it so it gets at the end of the ability list
		/datum/action/xeno_action/active_toggle/toggle_meson_vision, // readding it so it gets at the end of the ability list
	)

/datum/xeno_strain/sculptor/apply_strain(mob/living/carbon/xenomorph/hivelord/hivelord)
	hivelord.plasmapool_modifier = 0.6 // -40% plasma pool
	hivelord.plasmagain_modifier = XENO_PLASMA_GAIN_TIER_10 // 20% faster plasma regen
	hivelord.health_modifier -= XENO_HEALTH_MOD_SCULPTOR
	hivelord.speed_modifier += XENO_SPEED_FASTMOD_TIER_8
	hivelord.damage_modifier += XENO_DAMAGE_MOD_SMALL

	hivelord.recalculate_everything()
	hivelord.set_resin_build_order(GLOB.resin_build_order_hivelord_sculptor)
	for(var/datum/action/xeno_action/action in hivelord.actions)
		// Also update the choose_resin icon since it resets
		if(istype(action, /datum/action/xeno_action/onclick/choose_resin))
			var/datum/action/xeno_action/onclick/choose_resin/choose_resin_ability = action
			if(choose_resin_ability)
				choose_resin_ability.update_button_icon(hivelord.selected_resin)
				break // Don't need to keep looking
