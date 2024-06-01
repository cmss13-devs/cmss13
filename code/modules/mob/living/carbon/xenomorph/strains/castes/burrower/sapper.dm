/datum/xeno_strain/sapper
	name = BURROWER_SAPPER
	description = ""
	flavor_description = "No matter how stalwart their defences may be, remind our enemies that nothing endures the hive."
	icon_state_prefix = "Sapper"

	actions_to_remove = list (
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/burrow,
		/datum/action/xeno_action/onclick/tremor,
		)

	actions_to_add = list (
		/datum/action/xeno_action/activable/sapper_punch,
		/datum/action/xeno_action/onclick/demolish,
		/datum/action/xeno_action/onclick/earthquake,
		/datum/action/xeno_action/activable/boulder_toss,
	)

	behavior_delegate_type = /datum/behavior_delegate/burrower_sapper

/datum/xeno_strain/sapper/apply_strain(mob/living/carbon/xenomorph/burrower/burrower)
	burrower.plasmapool_modifier = 0.5
	burrower.armor_modifier -= XENO_ARMOR_MOD_SMALL
	burrower.claw_type = CLAW_TYPE_SHARP
	burrower.mob_size = MOB_SIZE_BULKY

	burrower.recalculate_everything()
/datum/behavior_delegate/burrower_sapper
	name = "Sapper Burrower Behavior Delegate"

	var/frontal_armor = 20
	var/side_armor = 10

	var/tension = 0
	var/max_tension = 1000
	var/tension_on_slash = 20
	var/passive_tension = 1

	var/demolish_cost = 300
	var/earthquake_cost = 200
	var/boulder_cost = 500

/datum/behavior_delegate/burrower_sapper/proc/modify_tension(amount)
	tension += amount
	if(tension > max_tension)
		tension = max_tension
	if(tension < 0)
		tension = 0

/datum/behavior_delegate/burrower_sapper/append_to_stat()
	. = list()
	. += "Tension: [tension]"

/datum/behavior_delegate/burrower_sapper/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	modify_tension(tension_on_slash)

/datum/behavior_delegate/burrower_sapper/on_life()
	modify_tension(passive_tension)
	if(!bound_xeno)
		return
	if(bound_xeno.stat == DEAD)
		return

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_tension = round((tension / max_tension) * 100, 10)
	if(percentage_tension)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_tension]")

/datum/behavior_delegate/burrower_sapper/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_MOB_SET_FACE_DIR, PROC_REF(cancel_dir_lock))
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(apply_directional_armor))

/datum/behavior_delegate/burrower_sapper/proc/cancel_dir_lock()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_SET_FACE_DIR

/datum/behavior_delegate/burrower_sapper/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(xeno.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += side_armor
				return
