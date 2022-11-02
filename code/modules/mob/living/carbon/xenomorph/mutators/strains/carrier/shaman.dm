/datum/xeno_mutator/shaman
	name = "STRAIN: Carrier - Shaman"
	description = "In exchange for your ability to store facehuggers, you can cheat the adrenaline mechanism of nearby xenos by violently killing little ones while they are still in a small egg form."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_CARRIER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/retrieve_egg,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/sacrifice_egg/radius_remember,
		/datum/action/xeno_action/activable/sacrifice_egg/radius_shield, //first macro
		/datum/action/xeno_action/activable/sacrifice_egg/radius_scream, //second macro
		/datum/action/xeno_action/activable/sacrifice_egg/radius_pheromones, //third macro
		/datum/action/xeno_action/activable/retrieve_egg, //fourth macro
		/datum/action/xeno_action/onclick/use_pain
		)
	behavior_delegate_type = /datum/behavior_delegate/carrier_shaman
	keystone = TRUE

/datum/behavior_delegate/carrier_shaman
	var/used_shaman_ability = FALSE
	var/remembered_count = 0
	var/enable_pain_usage = TRUE

/datum/behavior_delegate/carrier_shaman/append_to_stat()
	. = list()
	if(remembered_count)
		. += "Remembered: [remembered_count]"
	if(bound_xeno.aura_strength)
		. += "Pheremone Strength: [get_pheromone_aura_strength(bound_xeno.aura_strength)]"

/datum/behavior_delegate/carrier_shaman/proc/reset_shaman_ability()
	used_shaman_ability = FALSE
	to_chat(bound_xeno, SPAN_XENOBOLDNOTICE("The hive is ready for another sacrifice."))

/datum/xeno_mutator/shaman/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (!.)
		return .
	var/mob/living/carbon/Xenomorph/Carrier/C = MS.xeno
	if(!istype(C))
		return FALSE
	C.mutation_type = CARRIER_SHAMAN
	C.shaman_interactive = FALSE
	C.ignores_pheromones = TRUE
	apply_behavior_holder(C)
	mutator_update_actions(C)
	MS.recalculate_actions(description, flavor_description)
	C.phero_modifier = -C.caste.aura_strength
	C.recalculate_pheromones()
	if(C.huggers_cur > 0)
		playsound(C.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)
	C.huggers_cur = 0
	C.huggers_max = 0
	return TRUE

/datum/action/xeno_action/activable/sacrifice_egg
	name = "NO NAME - USE CHILD"
	action_icon_state = "lay_egg"
	ability_name = "sacrifice egg"
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/sacrifice_egg/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	var/datum/behavior_delegate/carrier_shaman/BD = X.behavior_delegate
	if(!istype(BD))
		return FALSE
	return !BD.used_shaman_ability

/datum/action/xeno_action/activable/sacrifice_egg/proc/get_cooldown()
	return 10 SECONDS

/datum/action/xeno_action/activable/sacrifice_egg/proc/get_gather_range()
	return 4

/datum/action/xeno_action/activable/sacrifice_egg/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!istype(X))
		return FALSE
	if(X.eggs_cur <= 0)
		to_chat(X, SPAN_XENOWARNING("You need an egg in your storage to sacrifice."))
		return FALSE
	var/datum/behavior_delegate/carrier_shaman/BD = X.behavior_delegate
	if(!istype(BD))
		return FALSE
	if(BD.used_shaman_ability)
		to_chat(X, SPAN_XENOWARNING("Hive is not ready for death of another little one."))
		return FALSE
	return TRUE


/datum/action/xeno_action/activable/sacrifice_egg/radius_shield
	name = "Adrenal Shielding (100)"
	action_icon_state = "shield_xeno"
	ability_name = "adrenal shielding"
	macro_path = /datum/action/xeno_action/verb/verb_egg_sacr_shield
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_1
	var/windup_delay = 25

	var/shield_strength_base = 10 // in percent
	var/shield_strength_gain = 10 // in percent
	var/shield_strength_max = 400 // in health points

	var/armor_strength_base = 10 // in integrity points
	var/armor_strength_gain = 2 // in integrity points
	var/armor_strength_max = 25 // in integrity points

/datum/action/xeno_action/verb/verb_egg_sacr_shield()
	set category = "Alien"
	set name = "Adrenal Shielding (100)"
	set hidden = 1
	var/action_name = "Adrenal Shielding (100)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_shield/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_shield(src)

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_shield(var/datum/action/xeno_action/activable/sacrifice_egg/radius_shield/action_def)
	if(!check_state())
		return

	if(!check_plasma(100))
		return

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_GREEN_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	plasma_stored -= 100
	eggs_cur--

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! The hive now finds vitality to continue the fight and avenge the little one."), null, 8)

	var/image/shield_overlay = get_busy_icon(BUSY_ICON_MEDICAL)
	var/image/effect_overlay = get_busy_icon(ACTION_GREEN_POWER_UP)

	var/list/xenomorphs_in_range = list()
	var/effect_power = 0
	for(var/mob/living/carbon/Xenomorph/X in range(action_def.get_gather_range(), src) - src)
		if(X.stat == DEAD)
			continue
		if(!X.shaman_interactive) // Shamans are disconnected from the effect
			continue
		if(!hive.is_ally(X))
			continue

		to_chat(X, SPAN_XENOBOLDNOTICE("The sacrifice of an egg spikes your adrenal system into overdrive!"))

		effect_overlay.flick_overlay(X, 20)
		effect_power++
		xenomorphs_in_range += X

	addtimer(CALLBACK(BD, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	if(!length(xenomorphs_in_range))
		to_chat(src, SPAN_XENOWARNING("There weren't enough of your allies around for the sacrifice to be effective."))
		return

	if(BD.enable_pain_usage && effect_power < BD.remembered_count)
		to_chat(src, SPAN_XENOWARNING("You use stored pain memory."))
		effect_power = BD.remembered_count
		BD.remembered_count = 0

	var/shield_percent = min(((effect_power - 1) * action_def.shield_strength_gain) + action_def.shield_strength_base, action_def.shield_strength_max)
	var/armor_percent =  min(((effect_power - 1) * action_def.armor_strength_gain) + action_def.armor_strength_base, action_def.armor_strength_max)

	for(var/mob/living/carbon/Xenomorph/X as anything in xenomorphs_in_range)
		// give overshield
		var/to_shield = min(X.maxHealth * shield_percent / 100, action_def.shield_strength_max)
		X.add_xeno_shield(to_shield, XENO_SHIELD_SOURCE_SHAMAN)

		if(X.armor_deflection && X.armor_integrity < 100)
			var/to_armor = armor_percent
			X.gain_armor_percent(to_armor)

		// lift them up from any state
		X.SetStunned(0)
		X.SetDazed(0)
		X.SetKnockeddown(0)

		shield_overlay.flick_overlay(X, 20)

	return TRUE


/datum/action/xeno_action/activable/sacrifice_egg/radius_scream
	name = "Frenzied Scream (300)"
	action_icon_state = "screech"
	ability_name = "frenzied scream"
	macro_path = /datum/action/xeno_action/verb/verb_egg_sacr_scream
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/windup_delay = 30
	var/initial_range = 3
	var/maximum_range = 7
	var/gain_per_xeno = 0.5
	var/stun_timer = 2
	var/stun_timeout = 20 SECONDS

/datum/action/xeno_action/verb/verb_egg_sacr_scream()
	set category = "Alien"
	set name = "Frenzied Scream (300)"
	set hidden = 1
	var/action_name = "Frenzied Scream (300)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_scream/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_scream(src)

/mob/living/var/scream_stun_timeout

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_scream(var/datum/action/xeno_action/activable/sacrifice_egg/radius_scream/action_def)
	if(!check_state())
		return

	if(!check_plasma(300))
		return

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_RED_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	plasma_stored -= 300
	eggs_cur--

	var/image/effect_overlay = get_busy_icon(ACTION_RED_POWER_UP)

	var/effect_power = 0
	for(var/mob/living/carbon/Xenomorph/X in range(action_def.get_gather_range(), src) - src)
		if(X.stat == DEAD)
			continue
		if(!X.shaman_interactive) // Shamans are disconnected from the effect
			continue
		if(!hive.is_ally(X))
			continue

		to_chat(X, SPAN_XENONOTICE("Your mind emits a strange wave of thoughts that even other creatures can feel!"))

		effect_overlay.flick_overlay(X, 20)
		effect_power++

	addtimer(CALLBACK(BD, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	if(BD.enable_pain_usage && effect_power < BD.remembered_count)
		to_chat(src, SPAN_XENOWARNING("You use stored pain memory."))
		effect_power = BD.remembered_count
		BD.remembered_count = 0

	if(!effect_power)
		to_chat(src, SPAN_XENOWARNING("There weren't enough of your allies around for the sacrifice to be effective."))
		return

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! The collective psychic scream will stun nearby enemies!"), null, 8)

	var/effect = min(((effect_power - 1) * action_def.gain_per_xeno) + action_def.initial_range, action_def.maximum_range)
	playsound(loc, 'sound/voice/xenos_roaring.ogg', 125)
	for(var/mob/living/M in view(effect, src) - src)
		if(M.stat == DEAD)
			continue
		if(hive.is_ally(M))
			continue
		if(M.scream_stun_timeout > world.time)
			to_chat(src, SPAN_XENOWARNING("A wave of madness passes over you, but you were already shocked by the same feeling recently."))
			continue

		var/mob/living/carbon/Xenomorph/X = M
		var/mob/living/carbon/human/H = M

		if(istype(X))
			to_chat(X, SPAN_XENODANGER("A wave of madness passes through and completely overwhelms you. How could they do this to their own little ones!?"))
			X.KnockDown(action_def.stun_timer)
			X.emote("needhelp")
			X.scream_stun_timeout = world.time + action_def.stun_timeout
			continue

		if(istype(H))
			if(isYautja(H))
				continue
			H.KnockDown(action_def.stun_timer)
			H.emote("scream")
			H.adjust_fire_stacks(-10, min_stacks = 0)
			H.spin(25, 2)
			if(!prob(50))
				H.extinguish_acid()
			H.visible_message(SPAN_DANGER("[H] rolls on the floor, flailing their hands in panic!"), SPAN_DANGER("A wave of madness passes through and completely overwhelms you. What is this madness?! GET IT OFF ME!"), null, 5)
			H.scream_stun_timeout = world.time + action_def.stun_timeout
			continue

	return TRUE


/datum/action/xeno_action/activable/sacrifice_egg/radius_pheromones
	name = "Adrenal Pheromones (300)"
	action_icon_state = "emit_pheromones"
	ability_name = "adrenal pheromones"
	macro_path = /datum/action/xeno_action/verb/verb_egg_sacr_scream
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/pheromone_strength_per_xeno = 0.5
	var/pheromone_strength_base = 1
	var/gather_range = 3
	var/pheromone_time = 300
	var/windup_delay = 25

/datum/action/xeno_action/verb/verb_egg_sacr_pheromones()
	set category = "Alien"
	set name = "Adrenal Pheromones (300)"
	set hidden = 1
	var/action_name = "Adrenal Pheromones (300)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_pheromones/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_pheromones(src)

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_pheromones(var/datum/action/xeno_action/activable/sacrifice_egg/radius_pheromones/action_def)
	if(!check_state())
		return

	if(!check_plasma(300))
		return

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_BLUE_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	plasma_stored -= 300
	eggs_cur--

	var/effect_power = 0

	var/image/effect_overlay = get_busy_icon(ACTION_BLUE_POWER_UP)

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! You absorb the adrenal pheremones and redirect them outwards!"), null, 8)

	for(var/mob/living/carbon/Xenomorph/X in range(action_def.get_gather_range(), src) - src)
		if(X.stat == DEAD)
			continue
		if(!X.shaman_interactive) // Shamans are disconnected from the effect
			continue
		if(!hive.is_ally(X))
			continue

		to_chat(X, SPAN_XENONOTICE("The death of an ovomorph causes you to release adrenal pheromones!"))

		effect_overlay.flick_overlay(X, 20)
		effect_power++

	addtimer(CALLBACK(BD, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	if(BD.enable_pain_usage && effect_power < BD.remembered_count)
		to_chat(src, SPAN_XENOWARNING("You use stored pain memory."))
		effect_power = BD.remembered_count
		BD.remembered_count = 0

	if(!effect_power)
		to_chat(src, SPAN_XENOWARNING("There weren't enough of your allies around for the sacrifice to be effective."))
		return

	var/effect = min(((effect_power - 1) * action_def.pheromone_strength_per_xeno) + action_def.pheromone_strength_base, 5)

	current_aura = "all"
	aura_strength = effect

	playsound(loc, "alien_drool", 25)
	visible_message(SPAN_XENOWARNING("\The [src] begins to emit madness-inducing pheromones."), SPAN_XENOWARNING("You begin to emit an array of pheromones."), null, 5)

	addtimer(CALLBACK(src, /mob/living/carbon/Xenomorph/Carrier.proc/egg_sacr_pheromones_disable), 30 SECONDS)
	return TRUE


/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_pheromones_disable()
	current_aura = null
	aura_strength = 0
	visible_message(SPAN_XENOWARNING("\The [src] stops emitting madness-inducing pheromones."), SPAN_XENOWARNING("Your reserve of adrenal pheremones runs out."), null, 5)

/datum/action/xeno_action/activable/sacrifice_egg/radius_remember
	name = "Remember Pain (300)"
	action_icon_state = "xeno_readmit"
	ability_name = "remember pain"
	macro_path = /datum/action/xeno_action/verb/radius_remember
	action_type = XENO_ACTION_ACTIVATE
	var/pheromone_strength_per_xeno = 0.5
	var/pheromone_strength_base = 1
	var/gather_range = 3
	var/pheromone_time = 300
	var/windup_delay = 25

/datum/action/xeno_action/verb/radius_remember()
	set category = "Alien"
	set name = "Remember Pain (300)"
	set hidden = 1
	var/action_name = "Remember Pain (300)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_remember/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_remember_pain(src)

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_remember_pain(var/datum/action/xeno_action/activable/sacrifice_egg/radius_remember/action_def)
	if(!check_state())
		return

	if(!check_plasma(300))
		return

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_PURPLE_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	plasma_stored -= 300
	eggs_cur--

	var/effect_power = 0
	var/image/effect_overlay = get_busy_icon(ACTION_PURPLE_POWER_UP)

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! You absorb the adrenal pheremones and store them inside you."), null, 8)

	for(var/mob/living/carbon/Xenomorph/X in range(7, src) - src)
		if(X.stat == DEAD)
			continue
		if(!X.shaman_interactive) // Shamans are disconnected from the effect
			continue
		if(!hive.is_ally(X))
			continue

		effect_overlay.flick_overlay(X, 20)
		effect_power++

	addtimer(CALLBACK(BD, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	if(!effect_power)
		to_chat(src, SPAN_XENOWARNING("There weren't enough of your allies around for the sacrifice to be effective."))
		return

	to_chat(src, SPAN_XENOBOLDNOTICE("You absorb the adrenal pheremones of [effect_power] xenomorph\s!"))
	BD.remembered_count = effect_power

/datum/action/xeno_action/onclick/use_pain
	name = "Use Pain"
	action_icon_state = "agility_off"
	button_icon_state = "template_active"
	ability_name = "use pain"
	macro_path = /datum/action/xeno_action/verb/use_pain_verb

/datum/action/xeno_action/verb/use_pain_verb()
	set category = "Alien"
	set name = "Use Pain"
	set hidden = 1
	var/action_name = "Use Pain"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/use_pain/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.use_pain_toggle()
	var/datum/behavior_delegate/carrier_shaman/BD = X.behavior_delegate
	if(!istype(BD))
		return FALSE
	button.icon_state = BD.enable_pain_usage ? "template_active" : "template"

/mob/living/carbon/Xenomorph/Carrier/proc/use_pain_toggle()
	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.enable_pain_usage = !BD.enable_pain_usage
	to_chat(src, SPAN_XENONOTICE("You will now [BD.enable_pain_usage ? "" : "<b>NOT</b> "]use remembered pain to cast abilities."))
