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

	evolves_to = list("Praetorian", "Crusher")
	deevolves_to = "Defender"
	tackle_chance = 40
	caste_desc = "A powerful front line combatant."
	agility_speed_increase = -0.7
	can_vent_crawl = 0

/datum/caste_datum/warrior/mature
	upgrade_name = "Mature"
	caste_desc = "An alien with an armored carapace. It looks a little more dangerous."
	upgrade = 1

	tackle_chance = 40
	agility_speed_increase = -0.8

/datum/caste_datum/warrior/elder
	upgrade_name = "Elder"
	caste_desc = "An alien with an armored carapace. It looks pretty strong."
	upgrade = 2

	tackle_chance = 45
	agility_speed_increase = -0.9

/datum/caste_datum/warrior/ancient
	upgrade_name = "Ancient"
	caste_desc = "An hulking beast capable of effortlessly breaking and tearing through its enemies."
	upgrade = 3

	tackle_chance = 48
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
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
	icon_size = 64
	icon_state = "Warrior Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -16
	old_x = -16
	tier = 2

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/toggle_agility,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/punch
		)

	new_actions = list(
		/datum/action/xeno_action/activable/jab,
	)
	mutation_type = WARRIOR_NORMAL

/mob/living/carbon/Xenomorph/Warrior/update_icons()
	if (stat == DEAD)
		icon_state = "Warrior Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Warrior Sleeping"
		else
			icon_state = "Warrior Knocked Down"
	else if (agility)
		icon_state = "Warrior Agility"
	else
		if (m_intent == MOVE_INTENT_RUN)
			icon_state = "Warrior Running"
		else
			icon_state = "Warrior Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.

/mob/living/carbon/Xenomorph/Warrior/throw_item(atom/target)
	toggle_throw_mode(THROW_MODE_OFF)


/mob/living/carbon/Xenomorph/Warrior/stop_pulling()
	if(isliving(pulling))
		var/mob/living/L = pulling
		L.SetStunned(0)
	..()


/mob/living/carbon/Xenomorph/Warrior/start_pulling(atom/movable/AM, lunge, no_msg)
	if (!check_state() || agility)
		return FALSE

	if(!isliving(AM))
		return FALSE
	var/mob/living/L = AM
	var/should_neckgrab = isHumanStrict(L)

	if(L.pulledby && L) //override pull of other mobs
		visible_message(SPAN_WARNING("[src] has broken [L.pulledby]'s grip on [L]!"), null, null, 5)
		L.pulledby.stop_pulling()

	if(!isXeno(L))
		if (used_lunge && !lunge)
			to_chat(src, SPAN_XENOWARNING("You must gather your strength before neckgrabbing again."))
			return FALSE

		if (!check_plasma(10))
			return FALSE

	. = ..(L, lunge, should_neckgrab) //no_msg = true because we don't want to show the defaul pull message

	if(.) //successful pull
		if(should_neckgrab)
			use_plasma(10)
			used_lunge = 1
			grab_level = GRAB_NECK
			L.drop_held_items()
			L.Stun(2.5)
			L.pulledby = src
			visible_message(SPAN_XENOWARNING("\The [src] grabs [L] by the throat!"), \
			SPAN_XENOWARNING("You grab [L] by the throat!"))

	if(used_lunge)
		used_lunge = 2 // sanity checking
		add_timer(CALLBACK(src, .proc/lunge_cooldown), caste.lunge_cooldown)

/mob/living/carbon/Xenomorph/Warrior/proc/lunge_cooldown()
	used_lunge = 0
	to_chat(src, SPAN_NOTICE("You get ready to lunge again."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()

/mob/living/carbon/Xenomorph/Warrior/hitby(atom/movable/AM)
	if(ishuman(AM))
		return
	..()
