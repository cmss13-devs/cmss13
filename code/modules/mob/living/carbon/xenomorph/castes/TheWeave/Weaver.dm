/datum/caste_datum/weaver
	caste_type = WEAVE_CASTE_WEAVELING
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_QUEEN
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_6

	evolves_to = list(WEAVE_CASTE_WEAVER)
	deevolves_to = null
	caste_desc = "Wielders of The Weave!"
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	evolution_allowed = TRUE

	tackle_min = 3
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 5

	burrow_cooldown = 20
	tunnel_cooldown = 70
	widen_cooldown = 70
	tremor_cooldown = 450

/mob/living/carbon/xenomorph/weaver
	hivenumber = XENO_HIVE_WEAVE
	caste_type = WEAVE_CASTE_WEAVELING
	name = WEAVE_CASTE_WEAVELING
	desc = "The Weave is all. All is The Weave."
	icon = 'icons/mob/xenonids/weave.dmi'
	icon_size = 64
	icon_state = "Weaver Walking"
	layer = MOB_LAYER
	plasma_stored = 100
	plasma_types = list(PLASMA_WEAVE, PLASMA_WEAVE)//Deliberate doubling, to affect ratio of extracted blood and plasma.
	pixel_x = -12
	old_x = -12
	tier = 2
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/plant_resin_fruit/weave,
		/datum/action/xeno_action/onclick/place_trap, //second macro
		/datum/action/xeno_action/activable/burrow, //third macro
		/datum/action/xeno_action/onclick/tremor //fourth macro
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		)
	mutation_type = WEAVE_NORMAL

	icon_xeno = 'icons/mob/xenonids/weave.dmi'
	icon_xenonid = 'icons/mob/xenonids/weave.dmi'

	max_placeable = 1
	available_fruits = list(/obj/effect/alien/resin/fruit/weave)
	selected_fruit = /obj/effect/alien/resin/fruit/weave

/mob/living/carbon/xenomorph/weaver/Initialize(mapload, mob/living/carbon/xenomorph/oldXeno, h_number)
	. = ..()
	sight |= SEE_THRU//Changes what counts as Line-of-Sight, allowing Psychic speech through walls, but not hearing replies.

/mob/living/carbon/xenomorph/weaver/update_canmove()
	. = ..()
	if(burrow)
		density = FALSE
		canmove = FALSE
		return canmove

/mob/living/carbon/xenomorph/weaver/ex_act(severity)
	if(burrow)
		return
	..()

/mob/living/carbon/xenomorph/weaver/attack_hand()
	if(burrow)
		return
	..()

/mob/living/carbon/xenomorph/weaver/attackby()
	if(burrow)
		return
	..()

/mob/living/carbon/xenomorph/weaver/get_projectile_hit_chance()
	. = ..()
	if(burrow)
		return 0

/mob/living/carbon/xenomorph/weaver/update_icons()
	if (stat == DEAD)
		icon_state = "Weaver Dead"
	else if (lying)
		if ((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Weaver Sleeping"
		else
			icon_state = "Weaver Knocked Down"
	else if (burrow)
		icon_state = "Weaver Burrowed"
	else
		icon_state = "Weaver Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
	update_wounds()
