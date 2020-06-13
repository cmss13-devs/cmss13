/datum/caste_datum/warrior
	caste_name = "Warrior"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_MEDIUMLOW
	melee_damage_upper = XENO_DAMAGE_MEDIUMHIGH
	max_health = XENO_HEALTH_LOWHIGH
	plasma_gain = XENO_PLASMA_GAIN_VERYHIGH
	plasma_max = XENO_PLASMA_LOW
	xeno_explosion_resistance = XENO_HEAVY_EXPLOSIVE_ARMOR
	armor_deflection = XENO_LOW_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_MEDIUM
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_HIGH
	speed_mod = XENO_SPEED_MOD_LARGE

	behavior_delegate_type = /datum/behavior_delegate/warrior_base

	evolves_to = list("Praetorian", "Crusher")
	deevolves_to = "Defender"
	tackle_chance = 30
	caste_desc = "A powerful front line combatant."
	agility_speed_increase = -0.7
	can_vent_crawl = 0

/datum/caste_datum/warrior/mature
	upgrade_name = "Mature"
	caste_desc = "An alien with an armored carapace. It looks a little more dangerous."
	upgrade = 1

	tackle_chance = 30
	agility_speed_increase = -0.8

/datum/caste_datum/warrior/elder
	upgrade_name = "Elder"
	caste_desc = "An alien with an armored carapace. It looks pretty strong."
	upgrade = 2

	tackle_chance = 35
	agility_speed_increase = -0.9

/datum/caste_datum/warrior/ancient
	upgrade_name = "Ancient"
	caste_desc = "An hulking beast capable of effortlessly breaking and tearing through its enemies."
	upgrade = 3

	tackle_chance = 40
	agility_speed_increase = -0.9

/datum/caste_datum/warrior/primordial
	upgrade_name = "Primordial"
	caste_desc = "10G punches right in your groin."
	upgrade = 4
	melee_damage_lower = 70
	melee_damage_upper = 80
	tackle_chance = 48
	plasma_gain = 0.1
	plasma_max = 300
	agility_speed_increase = -0.7
	max_health = 300
	speed = -0.7
	armor_deflection = 50

/mob/living/carbon/Xenomorph/Warrior
	caste_name = "Warrior"
	name = "Warrior"
	desc = "A beefy, alien with an armored carapace."
	icon = 'icons/mob/xenos/warrior.dmi'
	icon_size = 64
	icon_state = "Warrior Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -16
	old_x = -16
	tier = 2

	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/toggle_agility,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/warrior_punch
	)
	
	mutation_type = WARRIOR_NORMAL

/mob/living/carbon/Xenomorph/Warrior/update_icons()
	if (stat == DEAD)
		icon_state = "[mutation_type] Warrior Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] Warrior Sleeping"
		else
			icon_state = "[mutation_type] Warrior Knocked Down"
	else if (agility)
		icon_state = "[mutation_type] Warrior Agility"
	else
		icon_state = "[mutation_type] Warrior Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.

/mob/living/carbon/Xenomorph/Warrior/throw_item(atom/target)
	toggle_throw_mode(THROW_MODE_OFF)


/mob/living/carbon/Xenomorph/Warrior/stop_pulling()
	if(isliving(pulling))
		var/mob/living/L = pulling
		L.SetStunned(0)
	..()


/mob/living/carbon/Xenomorph/Warrior/start_pulling(atom/movable/AM, lunge)
	if (!check_state() || agility)
		return FALSE

	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	var/should_neckgrab = isHumanStrict(L)

	if(!isnull(L) && !isnull(L.pulledby) && L != src ) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [L.pulledby]'s grip on [L]!"), null, null, 5)
		L.pulledby.stop_pulling()

	. = ..(L, lunge, should_neckgrab)

	if(.) //successful pull
		if(should_neckgrab)
			grab_level = GRAB_NECK
			L.drop_held_items()
			L.Stun(0.5)
			L.pulledby = src
			visible_message(SPAN_XENOWARNING("\The [src] grabs [L] by the throat!"), \
			SPAN_XENOWARNING("You grab [L] by the throat!"))

/mob/living/carbon/Xenomorph/Warrior/hitby(atom/movable/AM)
	if(ishuman(AM))
		return
	..()

/datum/behavior_delegate/warrior_base
	name = "Base Warrior Behavior Delegate"
	
	var/stored_shield_max = 160
	var/stored_shield_per_slash = 40
	var/stored_shield = 0

/datum/behavior_delegate/warrior_base/melee_attack_additional_effects_self()
	if (stored_shield == stored_shield_max)
		bound_xeno.add_xeno_shield(stored_shield, XENO_SHIELD_SOURCE_GENERIC)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You feel your rage increase your resiliency to damage!"))
		stored_shield = 0
	else
		stored_shield += stored_shield_per_slash

/datum/behavior_delegate/warrior_base/append_to_stat()
	stat("Stored Shield", "[stored_shield]/[stored_shield_max]")