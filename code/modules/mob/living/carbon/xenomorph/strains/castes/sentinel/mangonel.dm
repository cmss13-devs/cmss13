/datum/xeno_strain/mangonel
	name = SENTINEL_MANGONEL
	description = "Exchange your base abilities, some speed and some slash damage for increased explosive armor and abilities oriented around besieging locations, and where the strengths of your abilities alter based on what type of weeds you are standing on. Entrench roots you in place, draining your plasma to increase your armor based on the type of weeds you're standing on. Adaptive Spit switches between a low damaging scattershot to a single higher damage shot depending on Entrenchment, which also influences single shot damage. Gas Shroud creates a small, vision-blocking cloud of gas which slows those who walk through it, serving as an escape and obfuscation tool."
	flavor_description = "Lay siege upon their walls, and watch their defences fall before us."
//	icon_state_prefix = "Mangonel"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/slowing_spit,
		/datum/action/xeno_action/activable/scattered_spit,
		/datum/action/xeno_action/onclick/paralyzing_slash,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/entrench,
		/datum/action/xeno_action/activable/adaptive_spit,
		/datum/action/xeno_action/onclick/gas_shroud,
	)

	behavior_delegate_type = /datum/behavior_delegate/sentinel_mangonel

/datum/xeno_strain/mangonel/apply_strain(mob/living/carbon/xenomorph/sentinel/sent)
	sent.speed_modifier += XENO_SPEED_SLOWMOD_TIER_4
	sent.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	sent.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_MED

	sent.recalculate_everything()

/datum/behavior_delegate/sentinel_mangonel
	name = "mangonel Sentinel Behavior Delegate"

	var/entrenched = FALSE // Are we currently entrenched or not
	var/weed_strength = 0 // What is the strength of the weeds we currently are standing on, if any (0 = no weeds, 1 = weak, 2 = normal, 3 = hardy, 4 = hive)
	var/weed_strength_message = "" // To provide feedback on weeds being stood on when Entrenching
	var/last_armor_buff = 0 // How much armor was given last time Entrench was used?
	var/entrench_loc = null // Where was Entrench used? For disabling Entrench if knocked back

/datum/behavior_delegate/sentinel_mangonel/on_life()

	if(entrench_loc && bound_xeno.loc != entrench_loc)
		entrench_effects(FALSE)

	var/obj/effect/alien/weeds/turf_weeds = locate() in bound_xeno.loc
	if(!turf_weeds)
		weed_strength = 0
		weed_strength_message = "! The lack of weeds belonging to our hive makes for poor reinforcement!"
		return

	if(turf_weeds.linked_hive.hivenumber == bound_xeno.hivenumber)
		switch(turf_weeds.weed_strength)
			if(WEED_LEVEL_WEAK)
				weed_strength = 1
				weed_strength_message = "! The [turf_weeds] barely reinforce us!"
			if(WEED_LEVEL_STANDARD)
				weed_strength = 2
				weed_strength_message = "! The [turf_weeds] reinforce us!"
			if(WEED_LEVEL_HARDY)
				weed_strength = 3
				weed_strength_message = "! The [turf_weeds] strongly reinforce us!"
			if(WEED_LEVEL_HIVE)
				weed_strength = 4
				weed_strength_message = "! The [turf_weeds] greatly reinforce us!"

/datum/behavior_delegate/sentinel_mangonel/proc/entrench_effects(effects_active)
	last_armor_buff = 5 + (5 * weed_strength)

	if(effects_active)
		RegisterSignal(bound_xeno, COMSIG_XENO_ENTER_CRIT, PROC_REF(entrench_unconscious_check))
		RegisterSignal(bound_xeno, COMSIG_MOB_DEATH, PROC_REF(entrench_unconscious_check))
		bound_xeno.armor_deflection += last_armor_buff
		ADD_TRAIT(bound_xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Entrench"))
		bound_xeno.anchored = TRUE
		bound_xeno.small_explosives_stun = FALSE
		entrenched = TRUE
		entrench_loc = bound_xeno.loc
	else
		UnregisterSignal(bound_xeno, COMSIG_XENO_ENTER_CRIT)
		UnregisterSignal(bound_xeno, COMSIG_MOB_DEATH)
		bound_xeno.armor_deflection -= last_armor_buff
		REMOVE_TRAIT(bound_xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Entrench"))
		bound_xeno.anchored = FALSE
		bound_xeno.small_explosives_stun = TRUE
		entrenched = FALSE
		entrench_loc = null

/datum/behavior_delegate/sentinel_mangonel/proc/entrench_unconscious_check()
	SIGNAL_HANDLER

	if(QDELETED(bound_xeno))
		return

	entrench_effects(FALSE)

// Abilities

// Entrench
/datum/action/xeno_action/onclick/entrench/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	var/datum/behavior_delegate/sentinel_mangonel/beh_del = xeno.behavior_delegate
	if(!istype(beh_del))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	if(!beh_del.entrenched)
		if(!do_after(xeno, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			return
		playsound(xeno.loc, 'sound/weapons/pierce.ogg', 25, 1)
		xeno.visible_message(SPAN_XENODANGER("[xeno] digs itself into place!"), SPAN_XENODANGER("We dig ourself into place[beh_del.weed_strength_message]"))
		beh_del.entrench_effects(TRUE)
		button.icon_state = "template_active"
	else
		beh_del.entrench_effects(FALSE)
		button.icon_state = "template"
		apply_cooldown()

	return ..()

/datum/action/xeno_action/onclick/entrench/life_tick()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	var/datum/behavior_delegate/sentinel_mangonel/beh_del = xeno.behavior_delegate
	if(!istype(beh_del))
		return

	if(beh_del.entrenched)
		. = check_and_use_plasma_owner(plasma_cost)
		if(. == FALSE)
			beh_del.entrench_effects(FALSE)
		return
	return FALSE

// Adaptive Spit
/datum/action/xeno_action/activable/adaptive_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	var/datum/behavior_delegate/sentinel_mangonel/beh_del = xeno.behavior_delegate
	if(!istype(beh_del))
		return

	if(!action_cooldown_check())
		return

	var/turf/current_turf = get_turf(xeno)
	if(!current_turf)
		return

	if(!check_and_use_plasma_owner())
		return

	playsound(xeno.loc, "acid_spit", 25, 1)

	var/datum/ammo/ammoDatum

	if(beh_del.entrenched)
		xeno.visible_message(SPAN_XENOWARNING("[xeno] spits a bolt of acid at [target]!"),
		SPAN_XENOWARNING("We spit a bolt of acid at [target]!"))
		ammoDatum = new /datum/ammo/xeno/acid/mangonel_siege()
		if(beh_del.weed_strength > 0)
			ammoDatum.damage = ammoDatum.damage + (5 * beh_del.weed_strength)
	else
		xeno.visible_message(SPAN_XENOWARNING("[xeno] spits a blast of acid at [target]!"),
		SPAN_XENOWARNING("We spit a blast of acid at [target]!"))
		ammoDatum = new /datum/ammo/xeno/acid/mangonel_shotgun()

	var/obj/projectile/proj = new /obj/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	proj.generate_bullet(ammoDatum)
	proj.permutated += xeno
	proj.def_zone = xeno.get_limbzone_target()
	proj.fire_at(target, xeno, xeno, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	return ..()

// Gas Shroud
/datum/action/xeno_action/onclick/gas_shroud/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/effect_system/smoke_spread/xeno_slow_smokescreen/smokescreen
	smokescreen = new /datum/effect_system/smoke_spread/xeno_slow_smokescreen

	if(!isxeno(owner))
		return

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	var/datum/cause_data/cause_data = create_cause_data("acid shroud gas", owner)
	smokescreen.set_up(1, 0, get_turf(xeno), null, 6, new_cause_data = cause_data)
	smokescreen.start()
	playsound(xeno, 'sound/effects/smoke.ogg', 30, 1)
	to_chat(xeno, SPAN_XENODANGER("We dump lightly paralytic venom through our pores, creating a shroud of gas!"))

	apply_cooldown()
	return ..()
