/datum/caste_datum/warrior
	caste_name = "Warrior"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 35
	melee_damage_upper = 40
	evolves_to = list("Praetorian", "Crusher")
	deevolves_to = "Defender"
	tackle_chance = 40
	plasma_gain = 0.08
	plasma_max = 100
	caste_desc = "A powerful front line combatant."
	armor_deflection = 30
	max_health = 235
	speed = -0.5
	agility_speed_increase = -0.5
	can_vent_crawl = 0
	xeno_explosion_resistance = 40

/datum/caste_datum/warrior/mature
	upgrade_name = "Mature"
	caste_desc = "An alien with an armored carapace. It looks a little more dangerous."
	upgrade = 1
	melee_damage_lower = 35
	melee_damage_upper = 40
	tackle_chance = 40
	plasma_gain = 0.08
	plasma_max = 100
	armor_deflection = 35
	agility_speed_increase = -0.6
	max_health = 250
	speed = -0.6

/datum/caste_datum/warrior/elder
	upgrade_name = "Elder"
	caste_desc = "An alien with an armored carapace. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 40
	melee_damage_upper = 45
	tackle_chance = 45
	plasma_gain = 0.09
	plasma_max = 125
	agility_speed_increase = -0.7
	max_health = 265
	speed = -0.7
	armor_deflection = 40

/datum/caste_datum/warrior/ancient
	upgrade_name = "Ancient"
	caste_desc = "An hulking beast capable of effortlessly breaking and tearing through its enemies."
	upgrade = 3
	melee_damage_lower = 45
	melee_damage_upper = 50
	tackle_chance = 48
	plasma_gain = 0.1
	plasma_max = 150
	agility_speed_increase = -0.8
	max_health = 280
	speed = -0.8
	armor_deflection = 45

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
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Warrior Walking"
	pixel_x = -16
	old_x = -16
	tier = 2


	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/toggle_agility,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/punch
		)

	new_actions = list(
		/datum/action/xeno_action/activable/jab,
	)

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
	throw_mode_off()


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

	if(!isXeno(L))
		if (used_lunge && !lunge)
			src << "<span class='xenowarning'>You must gather your strength before neckgrabbing again.</span>"
			return FALSE

		if (!check_plasma(10))
			return FALSE

	. = ..(L, lunge, should_neckgrab) //no_msg = true because we don't want to show the defaul pull message

	if(.) //successful pull
		if(should_neckgrab)
			use_plasma(10)
			round_statistics.warrior_grabs++
			used_lunge = 1
			grab_level = GRAB_NECK
			L.drop_held_items()
			L.Stun(5)
			visible_message("<span class='xenowarning'>\The [src] grabs [L] by the throat!</span>", \
			"<span class='xenowarning'>You grab [L] by the throat!</span>")

	if(used_lunge)
		used_lunge = 2 // sanity checking
		spawn(caste.lunge_cooldown)
			used_lunge = 0
			src << "<span class='notice'>You get ready to lunge again.</span>"
			for(var/X in actions)
				var/datum/action/act = X
				act.update_button_icon()

/mob/living/carbon/Xenomorph/Warrior/hitby(atom/movable/AM as mob|obj,var/speed = 5)
	if(ishuman(AM))
		return
	..()
