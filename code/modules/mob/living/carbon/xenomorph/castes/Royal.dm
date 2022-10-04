/datum/caste_datum/royal
	caste_type = XENO_CASTE_ROYAL
	caste_desc = "A loud, booming caste that wroughts destruction, or brings support with its roar."
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_6
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE

	deevolves_to = list(XENO_CASTE_CARRIER)

	can_vent_crawl = FALSE
	can_hold_facehuggers = TRUE
	can_hold_eggs = CAN_HOLD_TWO_HANDS

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 45
	tacklestrength_min = 4
	tacklestrength_max = 5

	behavior_delegate_type = /datum/behavior_delegate/royal

/mob/living/carbon/Xenomorph/Royal
	caste_type = XENO_CASTE_ROYAL
	name = XENO_CASTE_ROYAL
	desc = "A bulking monstrosity, it's neck appears to be larger than most."
	icon = 'icons/mob/hostiles/royal.dmi'
	icon_size = 64
	icon_state = "Royal Walking"
	plasma_types = list(PLASMA_PHEROMONE, PLASMA_NEUROTOXIN)
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	pixel_x = -16
	old_x = -16
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/roar,
		/datum/action/xeno_action/activable/rooting_slash,
		/datum/action/xeno_action/activable/pounce/royal,
		/datum/action/xeno_action/activable/blood_throw,
		/datum/action/xeno_action/onclick/royal_switch_roar_type,
		/datum/action/xeno_action/onclick/plant_weeds
	)
	mutation_type = ROYAL_NORMAL

	icon_xeno = 'icons/mob/hostiles/royal.dmi'
	icon_xenonid = 'icons/mob/xenonids/royal.dmi'

/mob/living/carbon/Xenomorph/Royal/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	icon_xeno = get_icon_from_source(CONFIG_GET(string/alien_royal))
	. = ..()


/datum/behavior_delegate/royal
	name = "Royal Behavior Delegate"
	// Config
	var/internal_blood_level_max = 150
	var/internal_blood_per_attack = 10

	// State
	var/internal_blood_level = 0

/datum/behavior_delegate/royal/append_to_stat()
	. = list()
	. += "Blood Reserves: [internal_blood_level]/[internal_blood_level_max]"

/datum/behavior_delegate/royal/on_life()
	internal_blood_level = min(internal_blood_level_max, internal_blood_level)

	var/mob/living/carbon/Xenomorph/Royal/X = bound_xeno
	var/image/holder = X.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(X.stat == DEAD)
		return

	var/percentage_energy = round((internal_blood_level / internal_blood_level_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/royal/handle_death(mob/M)
	var/mob/living/carbon/Xenomorph/Royal/X = bound_xeno
	var/image/holder = X.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/royal/melee_attack_additional_effects_self()
	..()

	add_internal_blood_level(internal_blood_per_attack)

/datum/behavior_delegate/royal/proc/add_internal_blood_level(amount)
	if (amount > 0)
		if (internal_blood_level >= internal_blood_level_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("You feel your resources of blood increase!"))
	internal_blood_level = Clamp(internal_blood_level + amount, 0, internal_blood_level_max)

/datum/behavior_delegate/royal/proc/remove_internal_blood_level(amount)
	add_internal_blood_level(-1*amount)

/datum/behavior_delegate/royal/proc/use_internal_blood_ability(cost)
	if (cost > internal_blood_level)
		to_chat(bound_xeno, SPAN_XENODANGER("Your blood reserves are insufficient! You need at least [cost] to do that!"))
		return FALSE
	else
		remove_internal_blood_level(cost)
		return TRUE
