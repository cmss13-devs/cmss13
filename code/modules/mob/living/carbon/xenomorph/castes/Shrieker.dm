/datum/caste_datum/shrieker
	caste_type = XENO_CASTE_SHRIEKER
	caste_desc = "A loud, booming caste that wroughts destruction, or brings support with its shriek."
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_6
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE

	deevolves_to = list(XENO_CASTE_CARRIER, XENO_CASTE_HIVELORD)

	can_vent_crawl = FALSE
	can_hold_facehuggers = TRUE
	can_hold_eggs = CAN_HOLD_TWO_HANDS

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 5

	behavior_delegate_type = /datum/behavior_delegate/shrieker

/mob/living/carbon/Xenomorph/Shrieker
	caste_type = XENO_CASTE_SHRIEKER
	name = XENO_CASTE_SHRIEKER
	desc = "A bulking monstrosity, it's neck appears to be larger than most."
	icon = 'icons/mob/hostiles/shrieker.dmi'
	icon_size = 64
	icon_state = "Shrieker Walking"
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
		/datum/action/xeno_action/activable/shriek,
		/datum/action/xeno_action/activable/rooting_slash,
		/datum/action/xeno_action/activable/pounce/shrieker,
		/datum/action/xeno_action/activable/acid_throw,
		/datum/action/xeno_action/onclick/shrieker_switch_shriek_type,
		/datum/action/xeno_action/onclick/plant_weeds
	)
	mutation_type = SHRIEKER_NORMAL

	icon_xeno = 'icons/mob/hostiles/shrieker.dmi'
	icon_xenonid = 'icons/mob/xenonids/shrieker.dmi'

/mob/living/carbon/Xenomorph/Shrieker/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	icon_xeno = get_icon_from_source(CONFIG_GET(string/alien_shrieker))
	. = ..()


/datum/behavior_delegate/shrieker
	name = "Shrieker Behavior Delegate"
	// Config
	var/internal_acid_level_max = 150
	var/internal_acid_per_attack = 10

	// State
	var/internal_acid_level = 0

/datum/behavior_delegate/shrieker/append_to_stat()
	. = list()
	. += "Acid Reserves: [internal_acid_level]/[internal_acid_level_max]"

/datum/behavior_delegate/shrieker/on_life()
	internal_acid_level = min(internal_acid_level_max, internal_acid_level)

	var/mob/living/carbon/Xenomorph/Shrieker/X = bound_xeno
	var/image/holder = X.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

	if(X.stat == DEAD)
		return

	var/percentage_energy = round((internal_acid_level / internal_acid_level_max) * 100, 10)
	if(percentage_energy)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_energy]")

/datum/behavior_delegate/shrieker/handle_death(mob/M)
	var/mob/living/carbon/Xenomorph/Shrieker/X = bound_xeno
	var/image/holder = X.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/shrieker/melee_attack_additional_effects_self()
	..()

	add_internal_acid_level(internal_acid_per_attack)

/datum/behavior_delegate/shrieker/proc/add_internal_acid_level(amount)
	if (amount > 0)
		if (internal_acid_level >= internal_acid_level_max)
			return
		to_chat(bound_xeno, SPAN_XENODANGER("You feel your resources of acid increase!"))
	internal_acid_level = Clamp(internal_acid_level + amount, 0, internal_acid_level_max)

/datum/behavior_delegate/shrieker/proc/remove_internal_acid_level(amount)
	add_internal_acid_level(-1*amount)

/datum/behavior_delegate/shrieker/proc/use_internal_acid_ability(cost)
	if (cost > internal_acid_level)
		to_chat(bound_xeno, SPAN_XENODANGER("Your acid reserves are insufficient! You need [cost] to do that!"))
		return FALSE
	else
		remove_internal_acid_level(cost)
		return TRUE
