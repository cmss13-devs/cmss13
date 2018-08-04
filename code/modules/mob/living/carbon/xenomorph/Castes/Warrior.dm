/datum/caste_datum/warrior
	caste_name = "Warrior"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 30
	melee_damage_upper = 35
	evolves_to = list("Praetorian", "Crusher")
	tackle_chance = 40
	plasma_gain = 8
	plasma_max = 100
	upgrade_threshold = 500
	evolution_threshold = 500
	caste_desc = "A powerful front line combatant."
	armor_deflection = 30
	max_health = 200
	speed = -0.4
	agility_speed_increase = -0.5
	can_vent_crawl = 0

/datum/caste_datum/warrior/mature

	upgrade_name = "Mature"
	tier = 2
	upgrade = 1
	melee_damage_lower = 35
	melee_damage_upper = 40
	upgrade_threshold = 800
	caste_desc = "An alien with an armored carapace. It looks a little more dangerous."
	armor_deflection = 35
	max_health = 225
	speed = -0.5

/datum/caste_datum/warrior/elder

	upgrade_name = "Elder"
	tier = 2
	upgrade = 2
	melee_damage_lower = 40
	melee_damage_upper = 45
	upgrade_threshold = 1600
	caste_desc = "An alien with an armored carapace. It looks pretty strong."
	armor_deflection = 40
	max_health = 250
	speed = -0.6

/datum/caste_datum/warrior/ancient

	upgrade_name = "Ancient"
	tier = 2
	upgrade = 3
	melee_damage_lower = 45
	melee_damage_upper = 50
	caste_desc = "An hulking beast capable of effortlessly breaking and tearing through its enemies."
	armor_deflection = 45
	max_health = 275
	speed = -0.7

/mob/living/carbon/Xenomorph/Warrior
	caste_name = "Warrior"
	name = "Warrior"
	desc = "A beefy, alien with an armored carapace."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Warrior Walking"
	health = 200
	maxHealth = 200
	plasma_stored = 100
	pixel_x = -16
	old_x = -16
	tier = 2
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/toggle_agility,
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/punch
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

	if(!isXeno(AM))
		if (used_lunge && !lunge)
			src << "<span class='xenowarning'>You must gather your strength before neckgrabbing again.</span>"
			return FALSE

		if (!check_plasma(10))
			return FALSE

	. = ..(AM, lunge, TRUE) //no_msg = true because we don't want to show the defaul pull message

	if(.) //successful pull
		if(!isXeno(AM))
			use_plasma(10)

		if(!lunge)
			used_lunge = 1

		if(!isXeno(L) && !isYautja(L))
			round_statistics.warrior_grabs++
			grab_level = GRAB_NECK
			L.drop_held_items()
			L.Stun(5)
			visible_message("<span class='xenowarning'>\The [src] grabs [L] by the throat!</span>", \
			"<span class='xenowarning'>You grab [L] by the throat!</span>")

	if(!lunge && !isXeno(AM))
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
