/datum/caste_datum/king
	caste_type = XENO_CASTE_KING
	caste_desc = "The end of the line."
	tier = 4

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_8
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_KING
	plasma_gain = XENO_PLASMA_GAIN_TIER_3
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_7
	armor_deflection = XENO_ARMOR_FACTOR_TIER_5
	speed = XENO_SPEED_TIER_1

	evolves_to = null
	deevolves_to = null
	evolution_allowed = FALSE
	can_vent_crawl = FALSE

	behavior_delegate_type = /datum/behavior_delegate/king_base

	tackle_min = 6
	tackle_max = 10

	minimap_icon = "xenoqueen"

	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE

/mob/living/carbon/xenomorph/king
	caste_type = XENO_CASTE_KING
	name = XENO_CASTE_KING
	desc = "A massive alien covered in spines and armoured plates."
	icon = 'icons/mob/xenos/king.dmi'
	icon_size = 64
	icon_state = "King Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_IMMOBILE
	tier = 4
	small_explosives_stun = FALSE
	counts_for_slots = FALSE
	organ_value = 50000

	claw_type = CLAW_TYPE_VERY_SHARP
	age = -1
	aura_strength = 6

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/rend,
		/datum/action/xeno_action/activable/doom,
		/datum/action/xeno_action/activable/destroy,
		/datum/action/xeno_action/onclick/king_shield,
		/datum/action/xeno_action/onclick/emit_pheromones,
	)

	icon_xeno = 'icons/mob/xenos/king.dmi'
	weed_food_states = list()
	weed_food_states_flipped = list()

	bubble_icon = "alienroyal"

/mob/living/carbon/xenomorph/king/get_organ_icon()
	return "heart_t3"

/mob/living/carbon/xenomorph/king/Destroy()
	UnregisterSignal(src, COMSIG_MOVABLE_PRE_MOVE)

	return ..()

/mob/living/carbon/xenomorph/king/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_block))

/mob/living/carbon/xenomorph/king/proc/check_block(mob/king, turf/new_loc)
	SIGNAL_HANDLER
	for(var/mob/living/carbon/carbon in new_loc.contents)
		if(isxeno(carbon))
			var/mob/living/carbon/xenomorph/xeno = carbon
			if(xeno.hivenumber == src.hivenumber)
				xeno.KnockDown((5 DECISECONDS) / GLOBAL_STATUS_MULTIPLIER)
			else
				xeno.KnockDown((1 SECONDS) / GLOBAL_STATUS_MULTIPLIER)
		else
			if(carbon.stat != DEAD)
				carbon.apply_armoured_damage(20)
				carbon.KnockDown((1 SECONDS) / GLOBAL_STATUS_MULTIPLIER)

		playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)

/mob/living/carbon/xenomorph/king/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, 1)

/datum/behavior_delegate/king_base
	name = "Base King Behavior Delegate"

/mob/living/carbon/xenomorph/king/rogue
	icon_xeno = 'icons/mob/xenos/rogueking.dmi'
	icon = 'icons/mob/xenos/rogueking.dmi'

/atom/movable/vis_obj/xeno_wounds/rogue
	icon = 'icons/mob/xenos/roguedamage.dmi'

/mob/living/carbon/xenomorph/king/rogue/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	vis_contents -= wound_icon_holder
	wound_icon_holder = new /atom/movable/vis_obj/xeno_wounds/rogue(null, src)
	vis_contents += wound_icon_holder
