/datum/caste_datum/spitter
	caste_name = "Spitter"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_MEDIUMLOW
	max_health = XENO_HEALTH_HIGHMEDIUM
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_VERYHIGH
	xeno_explosion_resistance = XENO_MEDIUM_EXPLOSIVE_ARMOR
	armor_deflection = XENO_LOW_ARMOR + XENO_ARMOR_MOD_VERYSMALL
	armor_hardiness_mult = XENO_ARMOR_FACTOR_HIGH
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_LOWHIGH
	speed_mod = XENO_SPEED_MOD_SMALL

	spit_delay = 30
	caste_desc = "Ptui!"
	spit_types = list(/datum/ammo/xeno/acid/medium)
	evolves_to = list("Boiler")
	deevolves_to = "Sentinel"
	acid_level = 2

	behavior_delegate_type = /datum/behavior_delegate/spitter_base

/datum/caste_datum/spitter/mature
	upgrade_name = "Mature"
	caste_desc = "A ranged damage dealer. It looks a little more dangerous."
	upgrade = 1

	spit_delay = 30
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40

/datum/caste_datum/spitter/elder
	upgrade_name = "Elder"
	caste_desc = "A ranged damage dealer. It looks pretty strong."
	upgrade = 2

	spit_delay = 25
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45

/datum/caste_datum/spitter/ancient
	upgrade_name = "Ancient"
	caste_desc = "A ranged destruction machine."
	upgrade = 3

	spit_delay = 25
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 48

/mob/living/carbon/Xenomorph/Spitter
	caste_name = "Spitter"
	name = "Spitter"
	desc = "A gross, oozing alien of some kind."
	icon = 'icons/mob/xenos/spitter.dmi'
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


/datum/behavior_delegate/spitter_base
	name = "Base Spitter Behavior Delegate"

	// list of atoms that we cannot apply a DoT effect to
	var/list/dot_cooldown_atoms = list()
	var/dot_cooldown_duration = 120 // every 12 seconds

/datum/behavior_delegate/spitter_base/ranged_attack_additional_effects_target(atom/A)
	if (istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if (H.stat == DEAD)
			return

	for (var/atom/dotA in dot_cooldown_atoms)
		if (dotA == A)
			return

	dot_cooldown_atoms += A
	add_timer(CALLBACK(src, .proc/dot_cooldown_up, A), dot_cooldown_duration)
	
	if (isobj(A) || ismob(A))
		new /datum/effects/acid(A, bound_xeno, initial(bound_xeno.caste_name))

		if (ismob(A))
			var/datum/action/xeno_action/onclick/spitter_frenzy/SFA = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/spitter_frenzy)
			if (istype(SFA) && !SFA.action_cooldown_check())
				SFA.end_cooldown()

/datum/behavior_delegate/spitter_base/proc/dot_cooldown_up(var/atom/A)
	if (A != null && !disposed)
		dot_cooldown_atoms -= A
		if (istype(bound_xeno))
			to_chat(bound_xeno, SPAN_XENOWARNING("You can soak [A] in acid again!"))