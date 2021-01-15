/datum/caste_datum/spitter
	caste_name = "Spitter"
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_MOD_MED
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_5

	caste_desc = "Ptui!"
	spit_types = list(/datum/ammo/xeno/acid/medium)
	evolves_to = list("Boiler")
	deevolves_to = "Sentinel"
	acid_level = 2

	behavior_delegate_type = /datum/behavior_delegate/spitter_base

	spit_delay = 40

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 45
	tacklestrength_min = 4
	tacklestrength_max = 5

/mob/living/carbon/Xenomorph/Spitter
	caste_name = "Spitter"
	name = "Spitter"
	desc = "A gross, oozing alien of some kind."
	icon_size = 48
	icon_state = "Spitter Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12

	tier = 2
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/spitter_frenzy,
		/datum/action/xeno_action/activable/spray_acid/spitter,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = SPITTER_NORMAL

/mob/living/carbon/Xenomorph/Spitter/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_spitter))

/datum/behavior_delegate/spitter_base
	name = "Base Spitter Behavior Delegate"

	// list of atoms that we cannot apply a DoT effect to
	var/list/dot_cooldown_atoms = list()
	var/dot_cooldown_duration = 120 // every 12 seconds

/datum/behavior_delegate/spitter_base/ranged_attack_additional_effects_target(atom/A)
	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		if (H.stat == DEAD)
			return

	for (var/atom/dotA in dot_cooldown_atoms)
		if (dotA == A)
			return

	dot_cooldown_atoms += A
	addtimer(CALLBACK(src, .proc/dot_cooldown_up, A), dot_cooldown_duration)

	new /datum/effects/acid(A, bound_xeno, initial(bound_xeno.caste_name))

	if (ismob(A))
		var/datum/action/xeno_action/onclick/spitter_frenzy/SFA = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/spitter_frenzy)
		if (istype(SFA) && !SFA.action_cooldown_check())
			SFA.end_cooldown()

/datum/behavior_delegate/spitter_base/proc/dot_cooldown_up(var/atom/A)
	if (A != null && !QDELETED(src))
		dot_cooldown_atoms -= A
		if (istype(bound_xeno))
			to_chat(bound_xeno, SPAN_XENOWARNING("You can soak [A] in acid again!"))
