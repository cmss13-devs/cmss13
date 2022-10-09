/datum/caste_datum/warrior
	caste_type = XENO_CASTE_WARRIOR
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_TIER_5
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	behavior_delegate_type = /datum/behavior_delegate/warrior_base

	evolves_to = list(XENO_CASTE_PRAETORIAN, XENO_CASTE_CRUSHER)
	deevolves_to = list(XENO_CASTE_DEFENDER)
	caste_desc = "A powerful front line combatant."
	can_vent_crawl = 0

	tackle_min = 2
	tackle_max = 4

	agility_speed_increase = -0.9

	heal_resting = 1.4

/mob/living/carbon/Xenomorph/Warrior
	caste_type = XENO_CASTE_WARRIOR
	name = XENO_CASTE_WARRIOR
	desc = "A beefy, alien with an armored carapace."
	icon = 'icons/mob/hostiles/warrior.dmi'
	icon_size = 64
	icon_state = "Warrior Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -16
	old_x = -16
	tier = 2
	pull_speed = 2.0 // about what it was before, slightly faster

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
	)

	mutation_type = WARRIOR_NORMAL
	claw_type = CLAW_TYPE_SHARP
	icon_xeno = 'icons/mob/hostiles/warrior.dmi'
	icon_xenonid = 'icons/mob/xenonids/warrior.dmi'

	var/lunging = FALSE // whether or not the warrior is currently lunging (holding) a target
/mob/living/carbon/Xenomorph/Warrior/throw_item(atom/target)
	toggle_throw_mode(THROW_MODE_OFF)

/mob/living/carbon/Xenomorph/Warrior/stop_pulling()
	if(isliving(pulling) && lunging)
		lunging = FALSE // To avoid extreme cases of stopping a lunge then quickly pulling and stopping to pull someone else
		var/mob/living/lunged = pulling
		lunged.SetStunned(0)
		lunged.SetKnockeddown(0)
	return ..()

/mob/living/carbon/Xenomorph/Warrior/start_pulling(atom/movable/AM, lunge)
	if (!check_state() || agility)
		return FALSE

	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	var/should_neckgrab = !(src.can_not_harm(L)) && lunge

	if(!QDELETED(L) && !QDELETED(L.pulledby) && L != src ) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [L.pulledby]'s grip on [L]!"), null, null, 5)
		L.pulledby.stop_pulling()

	. = ..(L, lunge, should_neckgrab)

	if(.) //successful pull
		if(isXeno(L))
			var/mob/living/carbon/Xenomorph/X = L
			if(X.tier >= 2) // Tier 2 castes or higher immune to warrior grab stuns
				return .

		if(should_neckgrab && L.mob_size < MOB_SIZE_BIG)
			L.drop_held_items()
			L.KnockDown(get_xeno_stun_duration(L, 2))
			L.pulledby = src
			visible_message(SPAN_XENOWARNING("\The [src] grabs [L] by the throat!"), \
			SPAN_XENOWARNING("You grab [L] by the throat!"))
			lunging = TRUE
			addtimer(CALLBACK(src, .proc/stop_lunging), get_xeno_stun_duration(L, 2) SECONDS + 1 SECONDS)

/mob/living/carbon/Xenomorph/Warrior/proc/stop_lunging(var/world_time)
	lunging = FALSE

/mob/living/carbon/Xenomorph/Warrior/hitby(atom/movable/AM)
	if(ishuman(AM))
		return
	..()

/datum/behavior_delegate/warrior_base
	name = "Base Warrior Behavior Delegate"

	var/stored_shield_max = 100
	var/stored_shield_per_slash = 25
	var/datum/component/shield_component

/datum/behavior_delegate/warrior_base/New()
	. = ..()

/datum/behavior_delegate/warrior_base/add_to_xeno()
	. = ..()
	if(!shield_component)
		shield_component = bound_xeno.AddComponent(\
			/datum/component/shield_slash,\
			stored_shield_max,\
			stored_shield_per_slash,\
			"Warrior Shield")
	else
		bound_xeno.TakeComponent(shield_component)

/datum/behavior_delegate/warrior_base/remove_from_xeno()
	bound_xeno.remove_xeno_shield()
	shield_component.RemoveComponent()
	return ..()

/datum/behavior_delegate/warrior_base/Destroy(force, ...)
	qdel(shield_component)
	return ..()
