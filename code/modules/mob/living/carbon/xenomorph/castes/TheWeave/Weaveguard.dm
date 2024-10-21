/datum/caste_datum/weaveguard
	caste_type = WEAVE_CASTE_WEAVEGUARD
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = 1400
	plasma_gain = XENO_PLASMA_GAIN_TIER_5
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_TIER_6

	evolves_to = null
	deevolves_to = list(WEAVE_CASTE_WEAVELING)
	caste_desc = "The guardians of The Weave!"
	acid_level = 3
	weed_level = WEED_LEVEL_STANDARD
	evolution_allowed = TRUE

	aura_strength = 7

	tackle_chance = 65
	tackle_min = 2
	tackle_max = 6
	tacklestrength_min = 5
	tacklestrength_max = 6

	burrow_cooldown = 20
	tunnel_cooldown = 70
	widen_cooldown = 70
	tremor_cooldown = 450

	minimap_icon = "crusher"

/mob/living/carbon/xenomorph/weaveguard
	hivenumber = XENO_HIVE_WEAVE
	caste_type = WEAVE_CASTE_WEAVEGUARD
	name = WEAVE_CASTE_WEAVEGUARD
	langchat_color = "#4d97aa"
	desc = "A powerful protector of The Weave."
	icon = 'icons/mob/xenonids/weave.dmi'
	icon_size = 64
	icon_state = "Weaveguard Walking"
	layer = MOB_LAYER
	plasma_stored = 100
	plasma_types = list(PLASMA_WEAVE, PLASMA_WEAVE, PLASMA_WEAVE)//Deliberate tripling, to affect ratio of extracted blood and plasma.
	pixel_x = -12
	old_x = -12
	base_pixel_x = 0
	base_pixel_y = -20
	tier = 2
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/strong/weave,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/place_trap, //second macro
		/datum/action/xeno_action/activable/spray_acid/weaveguard, //third macro
		/datum/action/xeno_action/onclick/tremor, //fourth macro
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep,
		/datum/action/xeno_action/onclick/predalien_roar/weave,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/psychic_whisper,
		/datum/action/xeno_action/onclick/psychic_radiance,
		/datum/action/xeno_action/onclick/exude_energy,
		/datum/action/xeno_action/onclick/weave_heal,
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
	)

	icon_xeno = 'icons/mob/xenonids/weave.dmi'
	icon_xenonid = 'icons/mob/xenonids/weave.dmi'

	max_placeable = 2
	available_fruits = list(/obj/effect/alien/resin/fruit/weave)
	selected_fruit = /obj/effect/alien/resin/fruit/weave
	universal_understand = TRUE

	speaking_noise = 'sound/voice/weave_talk2.ogg'

/mob/living/carbon/xenomorph/weaveguard/Initialize(mapload, mob/living/carbon/xenomorph/oldXeno, h_number)
	. = ..()
	sight |= SEE_THRU//Changes what counts as Line-of-Sight, allowing Psychic speech through walls, but not hearing replies.
	resin_build_order = GLOB.resin_build_order_drone

/mob/living/carbon/xenomorph/weaveguard/update_icons()
	if (stat == DEAD)
		icon_state = "Weaveguard Dead"
	else if(body_position == LYING_DOWN)
		if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
			icon_state = "Weaveguard Sleeping"
		else
			icon_state = "Weaveguard Knocked Down"
	else if(m_intent == MOVE_INTENT_WALK)
		icon_state = "Weaveguard Walking"
	else
		icon_state = "Weaveguard Running"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.
	update_wounds()
