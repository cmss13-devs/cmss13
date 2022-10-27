/datum/xeno_mutator/shaman
	name = "STRAIN: Carrier - Shaman"
	description = "In exchange for your ability to store huggers, you can cheat the adrenaline mechanism of nearby xenos and the minds of enemies by violently killing little ones while they are still in a small egg form."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_CARRIER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/throw_hugger,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/onclick/place_trap,
		/datum/action/xeno_action/activable/retrieve_egg,
		/datum/action/xeno_action/onclick/set_hugger_reserve,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/sacrifice_egg/hide_pain, //first macro
		/datum/action/xeno_action/activable/sacrifice_egg/radius_scream, //second macro
		/datum/action/xeno_action/activable/sacrifice_egg/firewalk, //third macro
		/datum/action/xeno_action/activable/sacrifice_egg/mindtrick //fourth macro
		)
	behavior_delegate_type = /datum/behavior_delegate/carrier_shaman
	keystone = TRUE

/datum/behavior_delegate/carrier_shaman
	var/used_shaman_ability = FALSE
	var/mob/living/simple_animal/hostile/alien/fakexeno

/datum/behavior_delegate/carrier_shaman/proc/reset_shaman_ability()
	used_shaman_ability = FALSE
	to_chat(bound_xeno, SPAN_XENOBOLDNOTICE("The hive is ready for another sacrifice."))

/datum/xeno_mutator/shaman/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (!.)
		return .
	var/mob/living/carbon/Xenomorph/Carrier/carrier = mutator_set.xeno
	if(!istype(carrier))
		return FALSE
	carrier.mutation_type = CARRIER_SHAMAN
	apply_behavior_holder(carrier)
	mutator_update_actions(carrier)
	mutator_set.recalculate_actions(description, flavor_description)
	carrier.phero_modifier = -carrier.caste.aura_strength
	carrier.recalculate_pheromones()
	if(carrier.huggers_cur > 0)
		playsound(carrier.loc, 'sound/voice/alien_facehugger_dies.ogg', 25, 1)
	carrier.huggers_cur = 0
	carrier.huggers_max = 0
	return TRUE

/datum/action/xeno_action/activable/sacrifice_egg
	name = "NO NAME - USE CHILD"
	action_icon_state = "lay_egg"
	ability_name = "sacrifice egg"
	action_type = XENO_ACTION_ACTIVATE

/datum/action/xeno_action/activable/sacrifice_egg/action_cooldown_check()
	var/mob/living/carbon/Xenomorph/Carrier/xeno = owner
	var/datum/behavior_delegate/carrier_shaman/xeno_behavior = xeno.behavior_delegate
	if(!istype(xeno_behavior))
		return FALSE
	return !xeno_behavior.used_shaman_ability

/datum/action/xeno_action/activable/sacrifice_egg/proc/get_cooldown()
	return 10 SECONDS

/datum/action/xeno_action/activable/sacrifice_egg/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/xeno = owner
	if(!istype(xeno))
		return FALSE
	if(xeno.eggs_cur <= 0)
		to_chat(xeno, SPAN_XENOWARNING("You need an egg in your storage to sacrifice."))
		return FALSE
	var/datum/behavior_delegate/carrier_shaman/xeno_behavior = xeno.behavior_delegate
	if(!istype(xeno_behavior))
		return FALSE
	if(xeno_behavior.used_shaman_ability)
		to_chat(xeno, SPAN_XENOWARNING("Hive is not ready for death of another little one."))
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
	var/hide_pain_seconds = 30 SECONDS
	var/hide_pain_range = 7
	var/hide_pain_cost = 100
	xeno_cooldown = 30 SECONDS

/datum/action/xeno_action/verb/verb_hide_pain()
	set category = "Alien"
	set name = "Hide Pain (100)"
	set hidden = 1
	var/action_name = "Hide Pain (100)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_shield/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_shield(src)

/mob/living/carbon/Xenomorph/Carrier/proc/return_wounds_alpha(var/mob/living/carbon/Xenomorph/X)
	if(!istype(X))
		return
	if(!X.wound_icon_carrier)
		return
	X.wound_icon_carrier.alpha = 255

/mob/living/carbon/Xenomorph/Carrier/proc/return_wounds_pheromones(var/mob/living/carbon/Xenomorph/Carrier/X)
	if(!istype(X))
		return
	if(!X.current_aura)
		return
	X.current_aura = null
	visible_message(SPAN_XENOWARNING("\The [src] stops emitting pheromones."), \
	SPAN_XENOWARNING("You stop emitting pheromones."), null, 5)

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	xeno_behavior.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_GREEN_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	use_plasma(action_def.hide_pain_cost)
	eggs_cur--

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! The hive now finds vitality to continue the fight and avenge the little one."), null, 8)

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

	addtimer(CALLBACK(xeno_behavior, TYPE_PROC_REF(/datum/behavior_delegate/carrier_shaman, reset_shaman_ability)), action_def.get_cooldown())

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
		X.set_effect(0, STUN)
		X.set_effect(0, DAZE)
		X.set_effect(0, WEAKEN)

		shield_overlay.flick_overlay(X, 20)

	return TRUE


/datum/action/xeno_action/activable/sacrifice_egg/radius_scream
	name = "Frenzied Scream"
	action_icon_state = "screech"
	ability_name = "frenzied scream"
	macro_path = /datum/action/xeno_action/verb/verb_egg_sacr_scream
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/windup_delay = 30
	var/scream_range = 5
	var/scream_cost = 300
	var/stun_timer = 2
	var/stun_timeout = 20 SECONDS
	xeno_cooldown = 60 SECONDS

/datum/action/xeno_action/verb/verb_egg_sacr_scream()
	set category = "Alien"
	set name = "Frenzied Scream (300)"
	set hidden = 1
	var/action_name = "Frenzied Scream (300)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_scream/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/xeno = owner
	if(!..())
		return
	X.egg_sacr_scream(src)

/mob/living/var/scream_stun_timeout

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_scream(var/datum/action/xeno_action/activable/sacrifice_egg/radius_scream/action_def)
	if(!check_state())
		return FALSE

	if(!check_plasma(action_def.scream_cost))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/xeno_behavior = behavior_delegate
	if(!istype(xeno_behavior))
		return FALSE
	xeno_behavior.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_RED_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	use_plasma(action_def.scream_cost)
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

	addtimer(CALLBACK(xeno_behavior, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	if(BD.enable_pain_usage && effect_power < BD.remembered_count)
		to_chat(src, SPAN_XENOWARNING("You use stored pain memory."))
		effect_power = BD.remembered_count
		BD.remembered_count = 0

	if(!effect_power)
		to_chat(src, SPAN_XENOWARNING("There weren't enough of your allies around for the sacrifice to be effective."))
		return

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! The collective psychic scream will stun nearby enemies!"), null, 8)

	playsound(loc, 'sound/voice/xenos_roaring.ogg', 125)
	for(var/mob/living/M in view(action_def.scream_range, src) - src)
		if(M.stat == DEAD)
			continue
		if(can_not_harm(M))
			continue
		if(M.scream_stun_timeout > world.time)
			to_chat(src, SPAN_XENOWARNING("A wave of madness passes over you, but you were already shocked by the same feeling recently."))
			continue

		var/mob/living/carbon/Xenomorph/xeno = M
		var/mob/living/carbon/human/H = M

		if(istype(X))
			to_chat(X, SPAN_XENODANGER("A wave of madness passes through and completely overwhelms you. How could they do this to their own little ones!?"))
			X.apply_effect(action_def.stun_timer, WEAKEN)
			X.emote("needhelp")
			X.scream_stun_timeout = world.time + action_def.stun_timeout
			continue

		if(istype(H))
			if(isYautja(H))
				continue
			effect_overlay.flick_overlay(H, 20)
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
	var/firewalk_range = 7
	var/firewalk_seconds = 15 SECONDS
	var/firewalk_cost = 250
	xeno_cooldown = 40 SECONDS

/datum/action/xeno_action/verb/verb_egg_sacr_firewalk()
	set category = "Alien"
	set name = "Firewalk (250)"
	set hidden = 1
	var/action_name = "Firewalk (250)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_pheromones/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_pheromones(src)

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_firewalk(var/datum/action/xeno_action/activable/sacrifice_egg/firewalk/action_def)
	if(!check_state())
		return FALSE

	if(!check_plasma(action_def.firewalk_cost))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/xeno_behavior = behavior_delegate
	if(!istype(xeno_behavior))
		return FALSE
	xeno_behavior.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_BLUE_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	use_plasma(action_def.firewalk_cost)
	eggs_cur--

	var/image/effect_overlay = get_busy_icon(ACTION_BLUE_POWER_UP)

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! You absorb the pheremones and redirect them outwards!"), null, 8)

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

	addtimer(CALLBACK(xeno_behavior, TYPE_PROC_REF(/datum/behavior_delegate/carrier_shaman, reset_shaman_ability)), action_def.get_cooldown())

	if(BD.enable_pain_usage && effect_power < BD.remembered_count)
		to_chat(src, SPAN_XENOWARNING("You use stored pain memory."))
		effect_power = BD.remembered_count
		BD.remembered_count = 0

		RegisterSignal(X, COMSIG_LIVING_PREIGNITION, .proc/fire_immune)
		RegisterSignal(X, list(
			COMSIG_LIVING_FLAMER_CROSSED,
			COMSIG_LIVING_FLAMER_FLAMED,
		), .proc/flamer_crossed_immune)

		X.add_filter("firewalk_on", 1, list("type" = "outline", "color" = "#03fcc6", "size" = 1))
		addtimer(CALLBACK(src, .proc/firewalk_immune_off, X), action_def.firewalk_seconds)

	playsound(loc, "alien_drool", 25)
	visible_message(SPAN_XENOWARNING("\The [src] begins to emit fire resistant phermones."), SPAN_XENOWARNING("You begin to emit fire resistant pheromones."), null, 5)

	addtimer(CALLBACK(src, /mob/living/carbon/Xenomorph/Carrier.proc/egg_sacr_pheromones_disable), 30 SECONDS)
	return TRUE

/mob/living/carbon/Xenomorph/Carrier/proc/firewalk_immune_off(var/mob/living/carbon/X)
	if(!istype(X))
		return
	UnregisterSignal(X, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_CROSSED,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	X.mob_flags &= ~FIRE_SHIELD_ON

	X.remove_filter("firewalk_on")
	visible_message(SPAN_XENOWARNING("\The [src] stops emitting fire resistant pheromones."), SPAN_XENOWARNING("Your reserve of fire resistant pheremones runs out."), null, 5)

/datum/action/xeno_action/activable/sacrifice_egg/mindtrick
	name = "Mindtrick"
	action_icon_state = "project_xeno"
	ability_name = "mindtrick"
	macro_path = /datum/action/xeno_action/verb/verb_egg_sacr_mindtrick
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	var/windup_delay = 25
	var/mindtrick_seconds = 16 SECONDS //-1 for qdel in the end
	var/mindtrick_cost = 200
	xeno_cooldown = 25 SECONDS

/datum/action/xeno_action/verb/verb_egg_sacr_mindtrick()
	set category = "Alien"
	set name = "Mindtrick (200)"
	set hidden = 1
	var/action_name = "Mindtrick (200)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/radius_remember/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	X.egg_sacr_remember_pain(src)


/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_mindtrick(var/datum/action/xeno_action/activable/sacrifice_egg/mindtrick/action_def, atom/A)
	if(!check_state())
		return FALSE

	if(!check_plasma(action_def.mindtrick_cost))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/xeno_behavior = behavior_delegate
	if(!istype(xeno_behavior))
		return FALSE
	xeno_behavior.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_PURPLE_POWER_UP))
		BD.used_shaman_ability = FALSE
		return

	use_plasma(action_def.mindtrick_cost)
	eggs_cur--

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

	addtimer(CALLBACK(xeno_behavior, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	return TRUE

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_mindtrick_disable(var/mob/living/simple_animal/hostile/alien/hologram/X)
	if(!istype(X))
		return
	animate(X, alpha = 0, time = 1 SECONDS, easing = QUAD_EASING)

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
