//burrower is COMBAT support
/datum/caste_datum/burrower
	caste_name = "Burrower"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_LOWPLUS
	max_health = XENO_HEALTH_HIGHMEDIUM
	plasma_gain = XENO_PLASMA_GAIN_MED
	plasma_max = XENO_PLASMA_HIGHMEDIUM
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_HEAVY_EXPLOSIVE_ARMOR
	armor_deflection = XENO_MEDIUM_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_HIGH
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_MEDHIGH
	speed_mod = XENO_SPEED_MOD_MED

	deevolves_to = "Drone"
	caste_desc = "A digger and trapper."
	burrow_cooldown = 50
	tunnel_cooldown = 100
	widen_cooldown = 100
	acid_level = 2
	weed_level = 1
	evolution_allowed = FALSE
	tremor_cooldown = 450

/datum/caste_datum/burrower/mature
	upgrade_name = "Mature"
	caste_desc = "A digger and shaper. It looks a little more dangerous."
	upgrade = 1

	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	burrow_cooldown = 40
	tunnel_cooldown = 90
	widen_cooldown = 90
	tremor_cooldown = 450

/datum/caste_datum/burrower/elder
	upgrade_name = "Elder"
	caste_desc = "A digger and shaper. It looks pretty strong."
	upgrade = 2

	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	burrow_cooldown = 20
	tunnel_cooldown = 70
	widen_cooldown = 70
	tremor_cooldown = 450

/datum/caste_datum/burrower/ancient
	upgrade_name = "Ancient"
	caste_desc = "A digger and shaper. It looks extremely strong."
	upgrade = 3

	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	speed = -0.3
	burrow_cooldown = 20
	tunnel_cooldown = 70
	widen_cooldown = 70
	tremor_cooldown = 420

/mob/living/carbon/Xenomorph/Burrower
	caste_name = "Burrower"
	name = "Burrower"
	desc = "A beefy, alien with sharp claws."
	icon = 'icons/mob/xenos/burrower.dmi'
	icon_size = 64
	icon_state = "Burrower Walking"
	layer = MOB_LAYER
	plasma_stored = 100
	plasma_types = list(PLASMA_PURPLE)
	pixel_x = -12
	old_x = -12
	tier = 2
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/burrow,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/place_trap
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		/mob/living/carbon/Xenomorph/proc/rename_tunnel,
		)
	mutation_type = BURROWER_NORMAL

/mob/living/carbon/Xenomorph/Burrower/New()
	. = ..()
	sight |= SEE_TURFS

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
		icon_state = "[mutation_type] Burrower Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] Burrower Sleeping"
		else
			icon_state = "[mutation_type] Burrower Knocked Down"
	else if (burrow)
		icon_state = "[mutation_type] Burrower Burrowed"
	else
		if (m_intent == MOVE_INTENT_RUN)
			icon_state = "[mutation_type] Burrower Running"
		else
			icon_state = "[mutation_type] Burrower Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
