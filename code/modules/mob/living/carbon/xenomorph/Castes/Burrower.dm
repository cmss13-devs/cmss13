/datum/caste_datum/burrower
	caste_name = "Burrower"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_chance = 40
	plasma_gain = 8
	plasma_max = 250
	upgrade_threshold = 800
	evolution_allowed = FALSE
	caste_desc = "A digger and shaper."
	max_health = 175
	speed = 0.0
	armor_deflection = 10
	xeno_explosion_resistance = 60
	burrow_cooldown = 50
	tunnel_cooldown = 100
	widen_cooldown = 100

/datum/caste_datum/burrower/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 25
	melee_damage_upper = 35
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	plasma_gain = 10
	plasma_max = 300
	armor_deflection = 15
	caste_desc = "A digger and shaper. It looks a little more dangerous."
	max_health = 200
	speed = -0.1
	burrow_cooldown = 40
	tunnel_cooldown = 90
	widen_cooldown = 90

/datum/caste_datum/burrower/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 30
	melee_damage_upper = 40
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	plasma_gain = 12
	plasma_max = 350
	armor_deflection = 20
	caste_desc = "A digger and shaper. It looks pretty strong."
	max_health = 225
	speed = -0.2
	burrow_cooldown = 30
	tunnel_cooldown = 80
	widen_cooldown = 80

/datum/caste_datum/burrower/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 35
	melee_damage_upper = 45
	tacklemin = 5
	tacklemax = 6
	tackle_chance = 55
	plasma_gain = 15
	plasma_max = 400
	armor_deflection = 25
	caste_desc = "A digger and shaper. It looks extremely strong."
	max_health = 250
	speed = -0.3
	burrow_cooldown = 20
	tunnel_cooldown = 70
	widen_cooldown = 70

/mob/living/carbon/Xenomorph/Burrower
	caste_name = "Burrower"
	name = "Burrower"
	desc = "A beefy, alien with sharp claws."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Burrower Walking"
	health = 175
	maxHealth = 175
	plasma_stored = 100
	pixel_x = -12
	old_x = -12
	tier = 3
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/activable/burrow,
		/datum/action/xeno_action/build_tunnel,
		/datum/action/xeno_action/place_trap
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)

/mob/living/carbon/Xenomorph/Burrower/update_canmove()
	. = ..()
	if(burrow)
		density = FALSE
		canmove = FALSE
		return canmove

/mob/living/carbon/Xenomorph/Burrower/ex_act(severity)
	if(burrow)
		return
	..()

/mob/living/carbon/Xenomorph/Burrower/attack_hand()
	if(burrow)
		return
	..()

/mob/living/carbon/Xenomorph/Burrower/attackby()
	if(burrow)
		return
	..()

/mob/living/carbon/Xenomorph/Burrower/get_projectile_hit_chance()
	. = ..()
	if(burrow)
		return 0

/mob/living/carbon/Xenomorph/Burrower/update_icons()
	if (stat == DEAD)
		icon_state = "Burrower Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Burrower Sleeping"
		else
			icon_state = "Burrower Knocked Down"
	else if (burrow)
		icon_state = "Burrower Burrowed"
	else
		if (m_intent == MOVE_INTENT_RUN)
			icon_state = "Burrower Running"
		else
			icon_state = "Burrower Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
