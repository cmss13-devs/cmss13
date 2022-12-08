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

/datum/xeno_mutator/shaman/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (!.)
		return .
	var/mob/living/carbon/Xenomorph/Carrier/C = MS.xeno
	if(!istype(C))
		return FALSE
	C.mutation_type = CARRIER_SHAMAN
	apply_behavior_holder(C)
	mutator_update_actions(C)
	MS.recalculate_actions(description, flavor_description)
	C.phero_modifier = C.caste.aura_strength
	C.recalculate_pheromones()
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
	if(!istype(BD) || (!..()))
		return FALSE
	return !BD.used_shaman_ability

/datum/action/xeno_action/activable/sacrifice_egg/proc/get_cooldown()
	return 10 SECONDS

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
	var/hide_pain_seconds = 30 SECONDS
	var/hide_pain_range = 7
	xeno_cooldown = 15 SECONDS

/datum/action/xeno_action/verb/verb_hide_pain()
	set category = "Alien"
	set name = "Hide Pain (100)"
	set hidden = 1
	var/action_name = "Hide Pain (100)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/hide_pain/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	if(!action_cooldown_check())
		return
	if(X.egg_sacr_hide_pain(src))
		apply_cooldown()

/mob/living/carbon/Xenomorph/Carrier/proc/return_wounds_alpha(var/mob/living/carbon/Xenomorph/X)
	if(!istype(X))
		return
	if(!X.wound_icon_carrier)
		return
	X.wound_icon_carrier.alpha = 255

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_hide_pain(var/datum/action/xeno_action/activable/sacrifice_egg/hide_pain/action_def)
	if(!check_state())
		return FALSE

	if(!check_plasma(100))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_GREEN_POWER_UP))
		BD.used_shaman_ability = FALSE
		return FALSE

	plasma_stored -= 100
	eggs_cur--

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! The hive now finds vitality to continue the fight and avenge the little one."), null, 8)

	var/image/effect_overlay = get_busy_icon(ACTION_GREEN_POWER_UP)

	var/list/xenomorphs_in_range = list()
	for(var/mob/living/carbon/Xenomorph/X in orange(action_def.hide_pain_range, src))
		if(X.stat == DEAD)
			continue
		if(!hive.is_ally(X))
			continue

		to_chat(X, SPAN_XENOBOLDNOTICE("The sacrifice of an egg spikes your adrenal system to hide your weakness!"))

		effect_overlay.flick_overlay(X, 20)
		xenomorphs_in_range += X

	addtimer(CALLBACK(xeno_behavior, TYPE_PROC_REF(/datum/behavior_delegate/carrier_shaman, reset_shaman_ability)), action_def.get_cooldown())

	for(var/mob/living/carbon/Xenomorph/X as anything in xenomorphs_in_range)
		X.wound_icon_carrier.alpha = 0
		addtimer(CALLBACK(src, .proc/return_wounds_alpha, X), action_def.hide_pain_seconds)

	src.current_aura = "frenzy"
	visible_message(SPAN_XENOWARNING("\The [src] begins to emit strange-smelling pheromones."), \
	SPAN_XENOWARNING("You begin to emit frenzy pheromones."), null, 5)
	playsound(loc, "alien_drool", 25)
	addtimer(CALLBACK(src, .proc/return_wounds_alpha, src), action_def.hide_pain_seconds)

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
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	if(!action_cooldown_check())
		return
	if(X.egg_sacr_scream(src))
		apply_cooldown()

/mob/living/var/scream_stun_timeout

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_scream(var/datum/action/xeno_action/activable/sacrifice_egg/radius_scream/action_def)
	if(!check_state())
		return FALSE

	if(!check_plasma(300))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_RED_POWER_UP))
		BD.used_shaman_ability = FALSE
		return FALSE

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

		var/mob/living/carbon/Xenomorph/X = M
		var/mob/living/carbon/human/H = M

		if(istype(X))
			to_chat(X, SPAN_XENODANGER("A wave of madness passes through and completely overwhelms you. How could they do this to their own little ones!?"))
			X.KnockDown(action_def.stun_timer)
			X.emote("needhelp")
			X.scream_stun_timeout = world.time + action_def.stun_timeout
			effect_overlay.flick_overlay(X, 20)
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
	xeno_cooldown = 40 SECONDS

/datum/action/xeno_action/verb/verb_egg_sacr_firewalk()
	set category = "Alien"
	set name = "Firewalk (250)"
	set hidden = 1
	var/action_name = "Firewalk (250)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/firewalk/use_ability()
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	if(!..())
		return
	if(!action_cooldown_check())
		return
	if(X.egg_sacr_firewalk(src))
		apply_cooldown()

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_firewalk(var/datum/action/xeno_action/activable/sacrifice_egg/firewalk/action_def)
	if(!check_state())
		return FALSE

	if(!check_plasma(250))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_BLUE_POWER_UP))
		BD.used_shaman_ability = FALSE
		return FALSE

	plasma_stored -= 250
	eggs_cur--

	var/image/effect_overlay = get_busy_icon(ACTION_BLUE_POWER_UP)

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! You absorb the pheremones and redirect them outwards!"), null, 8)

	var/list/allies_in_range = list()
	for(var/mob/living/carbon/X in range(action_def.firewalk_range, src))
		if(X.stat == DEAD)
			continue
		if(!can_not_harm(X))
			continue

		to_chat(X, SPAN_XENONOTICE("The death of an ovomorph causes you to release fire resistant pheromones!"))

		effect_overlay.flick_overlay(X, 20)
		allies_in_range += X

	addtimer(CALLBACK(xeno_behavior, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	for(var/mob/living/carbon/Xenomorph/X as anything in allies_in_range)
		X.ExtinguishMob()
		X.mob_flags |= FIRE_SHIELD_ON

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
	xeno_cooldown = 25 SECONDS

/datum/action/xeno_action/verb/verb_egg_sacr_mindtrick()
	set category = "Alien"
	set name = "Mindtrick (200)"
	set hidden = 1
	var/action_name = "Mindtrick (200)"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/sacrifice_egg/mindtrick/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	var/datum/behavior_delegate/carrier_shaman/BD = X.behavior_delegate
	if(!action_cooldown_check())
		if(BD.fakexeno)
			mindtrick_control(BD.fakexeno, A)
			BD.fakexeno.FindTarget()
			return
		return
	if(!..())
		return
	if(X.egg_sacr_mindtrick(src, A))
		apply_cooldown()


/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_mindtrick(var/datum/action/xeno_action/activable/sacrifice_egg/mindtrick/action_def, atom/A)
	if(!check_state())
		return FALSE

	if(!check_plasma(200))
		return FALSE

	var/datum/behavior_delegate/carrier_shaman/BD = behavior_delegate
	if(!istype(BD))
		return FALSE
	BD.used_shaman_ability = TRUE

	visible_message(SPAN_XENOBOLDNOTICE("\The [src] takes an alien egg into its hand and prepares to crush it!"), SPAN_XENOBOLDNOTICE("You prepare to sacrifice an egg, trying to inflict as much suffering as possible!"), null, 8)

	if(!do_after(src, action_def.windup_delay, INTERRUPT_ALL, ACTION_PURPLE_POWER_UP))
		BD.used_shaman_ability = FALSE
		return FALSE

	plasma_stored -= 200
	eggs_cur--

	visible_message(SPAN_XENONOTICE("\The [src] squashes the egg into a pulp."), SPAN_XENONOTICE("You squash the egg into a mess of acid, blood, and gore! You absorb the adrenal pheremones and store them inside you."), null, 8)

	var/randomxeno = pick(subtypesof(/mob/living/simple_animal/hostile/alien/hologram))
	var/turf/target_turf = get_turf(A)
	var/list/fake_mobs = list()
	BD.fakexeno = new randomxeno(loc, src)
	fake_mobs.Add(BD.fakexeno)
	mindtrick_appear(BD.fakexeno)
	for(var/mob/M in fake_mobs)
		if(isturf(BD.fakexeno.loc) && !BD.fakexeno.key)
			walk_to(BD.fakexeno, target_turf, 0, 4)
			BD.fakexeno.FindTarget()
			addtimer(CALLBACK(src, .proc/egg_sacr_mindtrick_disable, BD.fakexeno), action_def.mindtrick_seconds - 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, BD.fakexeno), action_def.mindtrick_seconds)

		effect_overlay.flick_overlay(X, 20)
		effect_power++

	addtimer(CALLBACK(BD, /datum/behavior_delegate/carrier_shaman.proc/reset_shaman_ability), action_def.get_cooldown())

	return TRUE

/mob/living/carbon/Xenomorph/Carrier/proc/egg_sacr_mindtrick_disable(var/mob/living/simple_animal/hostile/alien/hologram/X)
	if(!istype(X))
		return
	animate(X, alpha = 0, time = 1 SECONDS, easing = QUAD_EASING)

/mob/living/carbon/Xenomorph/Carrier/proc/mindtrick_appear(var/mob/living/simple_animal/hostile/alien/hologram/target)
	if(!istype(target))
		return
	target.alpha = 0
	animate(target, alpha = 255, time = 2 SECONDS, easing = QUAD_EASING)

/datum/action/xeno_action/activable/sacrifice_egg/mindtrick/proc/mindtrick_control(mob/living/simple_animal/hostile/alien/hologram/target, turf/target_turf)
	if(!istype(target))
		return
	walk_to(target, target_turf, 0, 4)
