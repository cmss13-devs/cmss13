/datum/xeno_strain/sapper
	name = BURROWER_SAPPER
	description = "Lose half of your plasma, a bit of armor and your abilities to burrow, trap and construct, and your ability to lock direction in exchange for directional armor, knockback resistance, more explosive resistance, and new abilities. You can slash holes in normal walls and expand any hole to completely destroy the wall, as well as being able to fully destroy APCs. Your new Demolish ability sends you into a frenzy, increasing your attack speed and slash damage, giving you immunity to some explosive stuns, and allows you to slash holes in reinforced walls, but has a long cooldown. Your upgraded tail stab allows you to instantly break certain windows, attack via AOE targetting, knock hit targets back, and deals extra damage on a direct hit."
	flavor_description = "No matter how stalwart their defences may be, remind our enemies that nothing endures the hive."
	icon_state_prefix = "Sapper"

	actions_to_remove = list (
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/burrow,
		)

	actions_to_add = list (
		/datum/action/xeno_action/onclick/demolish,
		/datum/action/xeno_action/activable/tail_axe,
	)

	behavior_delegate_type = /datum/behavior_delegate/burrower_sapper

/datum/xeno_strain/sapper/apply_strain(mob/living/carbon/xenomorph/burrower/burrower)
	burrower.plasmapool_modifier = 0.5
	burrower.armor_modifier -= XENO_ARMOR_MOD_SMALL
	burrower.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_MED
	burrower.claw_type = CLAW_TYPE_SHARP
	burrower.mob_size = MOB_SIZE_BIG

	burrower.recalculate_everything()
/datum/behavior_delegate/burrower_sapper
	name = "Sapper Burrower Behavior Delegate"

	var/frontal_armor = 25
	var/side_armor = 15

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
