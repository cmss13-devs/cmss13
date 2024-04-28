/datum/xeno_strain/oppressor
	// Dread it, run from it, destiny still arrives... or should I say, I do
	name = PRAETORIAN_OPPRESSOR
	description = "You abandon all of your acid-based abilities, your dash, some speed, and a bit of your slash damage for some resistance against small explosives, slashes that deal extra damage to prone targets, and a powerful hook ability that pulls up to three enemies towards you, slows them, and has varying effects depending on how many enemies you pull. You also gain a powerful punch that reduces your other abilities' cooldowns, pierces through armor, and does double damage in addition to rooting slowed targets. You can also knock enemies back and slow them with your new Tail Lash and quickly grab a tall, slow it, and pull it towards you with your unique Tail Stab."
	flavor_description = "My reach is endless, this one will pull down the heavens."
	icon_state_prefix = "Oppressor"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_seize,
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/tail_lash,
	)

	behavior_delegate_type = /datum/behavior_delegate/oppressor_praetorian

/datum/xeno_strain/oppressor/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	prae.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	prae.small_explosives_stun = FALSE
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_CHITIN)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/oppressor_praetorian
	name = "Oppressor Praetorian Behavior Delegate"
	var/tearing_damage = 15

/datum/behavior_delegate/oppressor_praetorian/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(target_carbon.stat == DEAD)
		return

	// impaired in some capacity
	if(!(target_carbon.mobility_flags & MOBILITY_STAND) || !(target_carbon.mobility_flags & MOBILITY_MOVE) || target_carbon.slowed)
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, tearing_damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected ? bound_xeno.zone_selected : "chest")
		target_carbon.visible_message(SPAN_DANGER("[bound_xeno] tears into [target_carbon]!"))
		playsound(bound_xeno, 'sound/weapons/alien_tail_attack.ogg', 25, TRUE)
