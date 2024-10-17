/datum/caste_datum/weaver
	caste_type = WEAVE_CASTE_WEAVER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_IMMORTAL
	plasma_gain = XENO_PLASMA_GAIN_TIER_10
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_5
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_6

	evolves_to = null
	deevolves_to = list(WEAVE_CASTE_WEAVELING)
	caste_desc = "Wielders of The Weave!"
	acid_level = 3
	weed_level = WEED_LEVEL_STANDARD
	evolution_allowed = FALSE

	aura_strength = 5

	tackle_chance = 55
	tackle_min = 2
	tackle_max = 6
	tacklestrength_min = 5
	tacklestrength_max = 6

	burrow_cooldown = 20
	tunnel_cooldown = 90
	widen_cooldown = 70
	tremor_cooldown = 450

	minimum_evolve_time = 0

/mob/living/carbon/xenomorph/weaver
	hivenumber = XENO_HIVE_WEAVE
	caste_type = WEAVE_CASTE_WEAVER
	name = WEAVE_CASTE_WEAVER
	desc = "The Weave is all. All is The Weave."
	icon = 'icons/mob/xenonids/weave.dmi'
	icon_size = 64
	icon_state = "Weaver Walking"
	plasma_stored = 100
	plasma_types = list(PLASMA_WEAVE, PLASMA_WEAVE, PLASMA_WEAVE)//Deliberate tripling, to affect ratio of extracted blood and plasma.
	pixel_x = -16
	old_x = -16
	tier = 2
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/strong/weave,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/plant_resin_fruit/weave,
		/datum/action/xeno_action/onclick/place_trap, //second macro
		/datum/action/xeno_action/activable/burrow, //third macro
		/datum/action/xeno_action/onclick/tremor, //fourth macro
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin/hivelord/weave_macro,
		/datum/action/xeno_action/onclick/psychic_whisper,
		/datum/action/xeno_action/onclick/psychic_radiance,
		/datum/action/xeno_action/onclick/exude_energy,
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
	)

	icon_xeno = 'icons/mob/xenonids/weave.dmi'
	icon_xenonid = 'icons/mob/xenonids/weave.dmi'

	max_placeable = 4
	available_fruits = list(/obj/effect/alien/resin/fruit/weave)
	selected_fruit = /obj/effect/alien/resin/fruit/weave

	extra_build_dist = 3
	can_stack_builds = TRUE
	universal_understand = TRUE

	speaking_noise = 'sound/voice/weave_talk2.ogg'

/mob/living/carbon/xenomorph/weaver/Initialize(mapload, mob/living/carbon/xenomorph/oldXeno, h_number)
	. = ..()
	sight |= SEE_THRU//Changes what counts as Line-of-Sight, allowing Psychic speech through walls, but not hearing replies.
	resin_build_order = GLOB.resin_build_order_hivelord

/mob/living/carbon/xenomorph/weaver/update_icons()
	if (stat == DEAD)
		icon_state = "Weaver Dead"
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = "Weaver Sleeping"
		else
			icon_state = "Weaver Knocked Down"
	else if (HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		icon_state = "Weaver Burrowed"
	else
		icon_state = "Weaver Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
	update_wounds()
