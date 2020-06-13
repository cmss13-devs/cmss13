/datum/caste_datum/lurker
	caste_name = "Lurker"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_MEDIUM
	melee_damage_upper = XENO_DAMAGE_MEDIUMHIGH
	max_health = XENO_HEALTH_HIGHMEDIUM
	plasma_gain = XENO_PLASMA_GAIN_HIGH
	plasma_max = XENO_PLASMA_HIGHMEDIUM
	xeno_explosion_resistance = XENO_MEDIUM_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_LOWFAST
	speed_mod = XENO_SPEED_MOD_SMALL

	attack_delay = 2 // VERY high slash damage, but attacks relatively slowly

	behavior_delegate_type = /datum/behavior_delegate/lurker_base

	deevolves_to = "Runner"
	caste_desc = "A fast, powerful backline combatant."
	evolves_to = list("Ravager")

/datum/caste_datum/lurker/mature
	upgrade_name = "Mature"
	caste_desc = "A fast, powerful backline combatant. It looks a little more dangerous."
	upgrade = 1

/datum/caste_datum/lurker/elder
	upgrade_name = "Elder"
	caste_desc = "A fast, powerful backline combatant. It looks pretty strong."
	upgrade = 2

/datum/caste_datum/lurker/ancient
	upgrade_name = "Ancient"
	caste_desc = "A completely unmatched hunter. No, not even the Yautja can match you."
	upgrade = 3

/datum/caste_datum/lurker/primordial
	upgrade_name = "Primordial"
	caste_desc = "The apex predator. The hunter who stands atop all others."
	upgrade = 4
	melee_damage_lower = 50
	melee_damage_upper = 55
	max_health = XENO_UNIVERSAL_HPMULT * 250
	plasma_gain = 0.2
	armor_deflection = 30
	melee_damage_lower = 60
	melee_damage_upper = 70
	attack_delay = -4
	speed = -1.8
	plasma_gain = 0.4

/mob/living/carbon/Xenomorph/Lurker
	caste_name = "Lurker"
	name = "Lurker"
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/mob/xenos/lurker.dmi'
	icon_size = 48
	icon_state = "Lurker Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -12
	old_x = -12
	tier = 2
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = LURKER_NORMAL

/mob/living/carbon/Xenomorph/Lurker/update_icons()
	if(!caste)
		return
	if(stat == DEAD)
		icon_state = "[mutation_type] [caste.caste_name] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[mutation_type] [caste.caste_name] Sleeping"
		else
			icon_state = "[mutation_type] [caste.caste_name] Knocked Down"
	else
		var/datum/action/xeno_action/onclick/lurker_invisibility/LIA = get_xeno_action_by_type(src, /datum/action/xeno_action/onclick/lurker_invisibility)
		if (LIA && istype(LIA) && LIA.is_invisible)
			icon_state = "[mutation_type] [caste.caste_name] Invisible"
		else
			icon_state = "[mutation_type] [caste.caste_name] Running"

	update_fire()

/datum/behavior_delegate/lurker_base
	name = "Base Lurker Behavior Delegate"

	// Config
	var/invis_recharge_time = 150      // 15 seconds to recharge invisibility.
	var/invis_start_time = -1 // Special value for when we're not invisible
	var/invis_duration = 300  // so we can display how long the lurker is invisible to it
	var/buffed_slash_damage_ratio = 1.75
	var/slash_slow_duration = 35

	// State
	var/next_slash_buffed = FALSE
	var/can_go_invisible = TRUE

/datum/behavior_delegate/lurker_base/melee_attack_modify_damage(original_damage, atom/A = null)
	if (!ishuman(A))
		return original_damage

	var/mob/living/carbon/human/H = A
	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You significantly strengthen your attack, slowing [H]!"))
		to_chat(H, SPAN_XENOHIGHDANGER("You feel a sharp pain as [bound_xeno] slashes you, slowing you down!"))
		original_damage *= buffed_slash_damage_ratio
		H.SetSuperslowed(3)
		next_slash_buffed = FALSE

	return original_damage

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_target(atom/A)
	if (!ishuman(A))
		return 

	var/mob/living/carbon/human/H = A
	if (H.knocked_down)
		new /datum/effects/xeno_slow(H, bound_xeno, null, null, slash_slow_duration)

	return 

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_self()

	var/datum/action/xeno_action/onclick/lurker_invisibility/LIA = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if (LIA && istype(LIA))
		LIA.invisibility_off()

	return

// What to do when we go invisible
/datum/behavior_delegate/lurker_base/proc/on_invisibility()
	var/datum/action/xeno_action/activable/pounce/lurker/LPA = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if (LPA && istype(LPA))
		LPA.knockdown = TRUE // pounce knocks down
		LPA.freeze_self = TRUE
	can_go_invisible = FALSE
	invis_start_time = world.time

/datum/behavior_delegate/lurker_base/proc/on_invisibility_off()
	var/datum/action/xeno_action/activable/pounce/lurker/LPA = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if (LPA && istype(LPA))
		LPA.knockdown = FALSE // pounce no longer knocks down
		LPA.freeze_self = FALSE

	// SLIGHTLY hacky because we need to maintain lots of other state on the lurker 
	// whenever invisibility is on/off CD and when it's active.
	add_timer(CALLBACK(src, .proc/regen_invisibility), invis_recharge_time)

	invis_start_time = -1

/datum/behavior_delegate/lurker_base/proc/regen_invisibility()
	if (can_go_invisible)
		return

	can_go_invisible = TRUE
	if(bound_xeno)
		var/datum/action/xeno_action/onclick/lurker_invisibility/LIA = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
		if(LIA && istype(LIA))
			LIA.end_cooldown()
	
/datum/behavior_delegate/lurker_base/append_to_stat()
	var/invis_message = (invis_start_time == -1) ? "N/A" : "[(invis_duration-(world.time - invis_start_time))/10] seconds."
	stat("Invisibility Time Left:", invis_message)
