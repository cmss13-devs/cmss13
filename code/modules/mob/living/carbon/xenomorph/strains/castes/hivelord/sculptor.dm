/datum/xeno_strain/sculptor
	name = HIVELORD_SCULPTOR
	description = "You lose weight, become more frail. Your resin will become less thick, your acid glands morph into plasma glands, and you will be able to use plasma to create gelatin and use plasma to enhance your psysical capabilities."
	flavor_description = "With the mastery of plasma, you will become the guardian of the hive."
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
		/datum/action/xeno_action/onclick/crystallized_plasma, //fourth macro
		/datum/action/xeno_action/activable/spray_acid/sculptor, //fifth macro
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

/datum/action/xeno_action/onclick/crystallized_plasma
	name = "Crystallized Plasma (400)"
	action_icon_state = "crystal_plasma"
	macro_path = /datum/action/xeno_action/verb/crystal_plasma
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 400
	xeno_cooldown = 30 SECONDS

	// Config
	var/duration = 15 SECONDS
	var/armor_buff_amount = 30
	var/explosive_armor_buff_amount = 50
	var/attack_speed_buff_amount = 2

/datum/action/xeno_action/onclick/crystallized_plasma/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/hivelord/zenomorf = owner

	if (!action_cooldown_check())
		return

	if (!istype(zenomorf) || !zenomorf.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	zenomorf.armor_active = TRUE
	zenomorf.update_plasma_overlays()
	to_chat(zenomorf, SPAN_XENOWARNING("We attack slightly faster and are more armored for a small amount of time."))
	zenomorf.balloon_alert(zenomorf, "secreting plasma", text_color = "#d378ec")
	zenomorf.attack_speed_modifier -= attack_speed_buff_amount
	zenomorf.armor_deflection_buff += armor_buff_amount
	zenomorf.armor_explosive_buff += explosive_armor_buff_amount
	zenomorf.recalculate_armor()

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	return ..()


/datum/action/xeno_action/onclick/crystallized_plasma/proc/remove_effects()
	var/mob/living/carbon/xenomorph/hivelord/zenomorf = owner

	if (!istype(zenomorf))
		return

	zenomorf.armor_active = FALSE
	zenomorf.update_plasma_overlays()
	zenomorf.attack_speed_modifier += attack_speed_buff_amount
	zenomorf.armor_deflection_buff -= armor_buff_amount
	zenomorf.armor_explosive_buff -= explosive_armor_buff_amount
	zenomorf.recalculate_armor()
	to_chat(zenomorf, SPAN_XENOHIGHDANGER("We cannot sustain the plasma!"))

// Acid pilar replacement
/datum/action/xeno_action/activable/spray_acid/sculptor
	name = "Spray Plasma (160)"
	action_icon_state = "spray_plasma"
	action_text = "spray plasma"
	macro_path = /datum/action/xeno_action/verb/verb_spray_plasma
	ability_primacy = XENO_PRIMARY_ACTION_5
	action_type = XENO_ACTION_CLICK

	plasma_cost = 160
	xeno_cooldown = 4 SECONDS

	spray_type = ACID_SPRAY_LINE
	spray_distance = 6
	spray_effect_type = /obj/effect/xenomorph/spray/plasma
	activation_delay = FALSE
