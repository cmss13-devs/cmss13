/datum/xeno_strain/royal_charger
	name = ROYAL_CHARGER
	description = "In exchange for your ability to screech, you gain ability to run over talls and gain additional armor, you becoming a moving fortress"
	flavor_description = "Ancient legends say, long time ago this chungus train ran over long corridors and annihilated every tall."

	actions_to_remove = list(
		/datum/action/xeno_action/activable/secrete_resin/queen_macro,
		/datum/action/xeno_action/onclick/screech,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/secrete_resin/hivelord/queen_macro,
		/datum/action/xeno_action/onclick/charger_charge/queen,
		/datum/action/xeno_action/activable/fling/charger/queen,
	)

	behavior_delegate_type = /datum/behavior_delegate/royal_charger

/datum/xeno_strain/royal_charger/apply_strain(mob/living/carbon/xenomorph/queen/queen)
	queen.health_modifier += XENO_HEALTH_MOD_VERY_LARGE

	queen.mobile_aged_abilities -= /datum/action/xeno_action/onclick/screech
	queen.mobile_abilities -= /datum/action/xeno_action/activable/secrete_resin/queen_macro
	queen.mobile_abilities -= /datum/action/xeno_action/onclick/screech
	queen.immobile_abilities -= /datum/action/xeno_action/activable/secrete_resin/remote/queen

	queen.mobile_aged_abilities += /datum/action/xeno_action/onclick/charger_charge/queen
	queen.mobile_aged_abilities += /datum/action/xeno_action/activable/fling/charger/queen
	queen.mobile_abilities  += /datum/action/xeno_action/activable/secrete_resin/hivelord/queen_macro
	queen.mobile_abilities += /datum/action/xeno_action/onclick/charger_charge/queen
	queen.mobile_abilities += /datum/action/xeno_action/activable/fling/charger/queen
	queen.immobile_abilities += /datum/action/xeno_action/activable/secrete_resin/hivelord/queen_macro

	queen.mobile_build_order = GLOB.resin_build_order_hivelord
	queen.immobile_build_order = GLOB.resin_build_order_hivelord

	queen.set_resin_build_order(queen.mobile_build_order)

	queen.extra_build_dist += 1
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

/mob/living/carbon/xenomorph/queen
	var/prev_extra_build_dist
	var/mobile_build_order
	var/immobile_build_order

	var/list/immobile_abilities = list(
		// These already have their placement locked in:
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/place_construction/not_primary,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/queen_word,
		/datum/action/xeno_action/onclick/choose_resin/queen_macro, //fourth macro
		/datum/action/xeno_action/onclick/manage_hive,
		/datum/action/xeno_action/onclick/send_thoughts,
		/datum/action/xeno_action/activable/info_marker/queen,
		// Screech is typically new for this list, but its possible they never ovi and it then is forced here:
		/datum/action/xeno_action/onclick/screech, //custom macro, Screech
		// These are new and their arrangement matters:
		/datum/action/xeno_action/onclick/remove_eggsac,
		/datum/action/xeno_action/onclick/set_xeno_lead,
		/datum/action/xeno_action/activable/queen_heal, //first macro
		/datum/action/xeno_action/activable/queen_give_plasma, //second macro
		/datum/action/xeno_action/activable/expand_weeds, //third macro
		/datum/action/xeno_action/activable/secrete_resin/remote/queen, //fifth macro
		/datum/action/xeno_action/onclick/queen_tacmap,
		/datum/action/xeno_action/onclick/eye,
		/datum/action/xeno_action/onclick/give_tech_points,
	)
