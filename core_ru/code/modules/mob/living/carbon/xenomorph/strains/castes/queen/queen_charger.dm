/datum/xeno_strain/royal_charger
	name = ROYAL_CHARGER
	description = "In exchange for your ability to screech, you gain ability to run over talls and gain additional armor, you becoming a moving fortress"
	flavor_description = "Ancient legends say, long time ago this chungus train ran over long corridors and annihilated every tall."

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/screech,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/charger_charge/queen,
		/datum/action/xeno_action/activable/fling/charger/queen,
	)

	behavior_delegate_type = /datum/behavior_delegate/royal_charger

/datum/xeno_strain/royal_charger/apply_strain(mob/living/carbon/xenomorph/queen/queen)
	queen.health_modifier += XENO_HEALTH_MOD_VERY_LARGE

	queen.mobile_aged_abilities -= /datum/action/xeno_action/onclick/screech
	queen.mobile_abilities -= /datum/action/xeno_action/onclick/screech

	queen.mobile_aged_abilities += /datum/action/xeno_action/onclick/charger_charge/queen
	queen.mobile_aged_abilities += /datum/action/xeno_action/activable/fling/charger/queen
	queen.mobile_abilities += /datum/action/xeno_action/onclick/charger_charge/queen
	queen.mobile_abilities += /datum/action/xeno_action/activable/fling/charger/queen

	queen.recalculate_everything()

/datum/behavior_delegate/royal_charger
	name = "Queen Crusher Behavior Delegate"

	var/frontal_armor = 25
	var/side_armor = 15

/datum/behavior_delegate/royal_charger/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_MOB_SET_FACE_DIR, PROC_REF(cancel_dir_lock))
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(apply_directional_armor))

/datum/behavior_delegate/royal_charger/proc/cancel_dir_lock()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_SET_FACE_DIR

/datum/behavior_delegate/royal_charger/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno.dir & REVERSE_DIR(projectile_direction))
		// During the charge windup, crusher gets an extra 15 directional armor in the direction its charging
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(xeno.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += side_armor
				return

/datum/behavior_delegate/royal_charger/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	var/mob/living/carbon/xenomorph/queen/queen = bound_xeno
	if(queen.ovipositor)
		queen.icon = queen.queen_ovipositor_icon
		queen.icon_state = "[queen.get_strain_icon()] Queen Ovipositor"
		return TRUE

	if(HAS_TRAIT(bound_xeno, TRAIT_CHARGING) && queen.body_position == STANDING_UP)
		bound_xeno.icon_state = "[queen.get_strain_icon()] Queen Charging"
		return TRUE

	// Switch icon back and then let normal icon behavior happen
	queen.icon = queen.queen_standing_icon
