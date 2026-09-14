/datum/xeno_strain/acider
	name = RUNNER_ACIDER
	description = "At the cost of a little bit of your speed and all of your current abilities, you gain a considerable amount of health, some armor, and a new organ that fills with volatile acid over time. When outside of combat, only a limited amount of acid will generate. Your Tail Stab and slashes apply acid to living lifeforms that slowly burns them and fills your acid glands. You also gain Corrosive Acid equivalent to that of a boiler that you can deploy more quickly than any other caste, at the cost of a chunk of your acid reserves with each use. Finally, after a twenty second windup, you can force your body to explode, covering everything near you with acid. The more acid you have stored, the more devastating the explosion will be, but during those twenty seconds before detonation you are slowed and give off several warning signals which give talls an opportunity to end you before you can detonate. If you successfully explode, you will reincarnate as a larva again!"
	flavor_description = "This one will be the last thing they hear. A martyr."
	icon_state_prefix = "Acider"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/acider_acid,
		/datum/action/xeno_action/activable/acider_for_the_hive,
	)

	behavior_delegate_type = /datum/behavior_delegate/runner_acider

/datum/xeno_strain/acider/apply_strain(mob/living/carbon/xenomorph/runner/runner)
	runner.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	runner.armor_modifier += XENO_ARMOR_MOD_MED
	runner.health_modifier += XENO_HEALTH_MOD_ACIDER

	runner.recalculate_everything()

/datum/behavior_delegate/runner_acider
	var/acid_amount = 0

	var/caboom_left = 20
	var/caboom_trigger
	var/caboom_last_proc

	var/max_acid = 1000
	var/caboom_timer = 20
	var/acid_slash_regen_lying = 8
	var/acid_slash_regen_standing = 14
	var/acid_passive_regen = 1
	/// Amount of acid before passive (non-combat) acid generation stops
	var/acid_gen_cap = 400

	/// How much acid is generated per tick in combat
	var/combat_acid_regen = 1
	/// Duration of combat acid generation after a slash/tailstab
	var/combat_gen_timer = 60
	/// Determines whether the combat acid generation is on or off
	var/combat_gen_active = FALSE

	/// How much acid is required to melt something
	var/melt_acid_cost = 100
	/// How much acid is required to fill a trap
	var/fill_acid_cost = 75

	var/list/caboom_sound = list('sound/effects/runner_charging_1.ogg','sound/effects/runner_charging_2.ogg')
	var/caboom_loop = 1

	var/caboom_acid_ratio = 200
	var/caboom_burn_damage_ratio = 5
	var/caboom_burn_range_ratio = 100
	var/caboom_struct_acid_type = /obj/effect/xenomorph/acid

	var/drool_overlay_active = FALSE
	var/mutable_appearance/drool_applied_icon
	var/mutable_appearance/acid_overlays_icon

/datum/behavior_delegate/runner_acider/New()
	. = ..()
	drool_applied_icon = mutable_appearance('icons/mob/xenos/castes/tier_1/runner_strain_overlays.dmi', "Acider Runner Walking")
	acid_overlays_icon = mutable_appearance('icons/mob/xenos/castes/tier_1/runner_strain_overlays.dmi', "empty")

/datum/behavior_delegate/runner_acider/proc/modify_acid(amount)
	acid_amount += amount
	if(acid_amount > max_acid)
		acid_amount = max_acid
	if(acid_amount < 0)
		acid_amount = 0
	update_acid_overlays()

/datum/behavior_delegate/runner_acider/append_to_stat() //The status panel info for Acid Runner is handed here.
	. = list()
	. += "Acid: [acid_amount]/[max_acid]"
	if(acid_amount >= acid_gen_cap)
		. += "Passive acid generation cap ([acid_gen_cap]) reached"
	. += "Battle acid generation: [combat_gen_active ? "Active" : "Inactive"]"
	if(caboom_trigger)
		. += "FOR THE HIVE!: in [caboom_left] seconds"

/datum/behavior_delegate/runner_acider/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	if(ishuman(target_mob)) //Will acid be applied to the mob
		var/mob/living/carbon/human/target_human = target_mob
		if(target_human.buckled && istype(target_human.buckled, /obj/structure/bed/nest))
			return
		if(target_human.stat == DEAD)
			return

	var/datum/effects/acid/acid_effect = locate() in target_mob.effects_list
	if(acid_effect)
		acid_effect.prolong_duration()
	else
		new /datum/effects/acid(target_mob, bound_xeno, initial(bound_xeno.caste_type))
	if(isxeno_human(target_mob)) //Will the runner get acid stacks
		var/obj/item/alien_embryo/embryo = locate(/obj/item/alien_embryo) in target_mob.contents
		if(embryo?.stage >= 4) //very late stage hugged in case the runner unnests them
			return

		if(target_mob.body_position == LYING_DOWN)
			modify_acid(acid_slash_regen_lying)
			return
		modify_acid(acid_slash_regen_standing)

		addtimer(CALLBACK(src, PROC_REF(combat_gen_end)), combat_gen_timer, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE) //this calls for the proc to turn combat acid gen off after a set time passes
		combat_gen_active = TRUE //turns combat acid regen on
		drool_overlay_active = TRUE //turns the overlay on

/datum/behavior_delegate/runner_acider/on_life()
	if(acid_amount < acid_gen_cap)
		modify_acid(acid_passive_regen)
	if(combat_gen_active)
		modify_acid(combat_acid_regen)
	if(!bound_xeno)
		return
	if(bound_xeno.stat == DEAD)
		return
	if(caboom_trigger)
		var/wt = world.time
		if(caboom_last_proc)
			caboom_left -= (wt - caboom_last_proc)/10
		caboom_last_proc = wt
		var/amplitude = 50 + 50 * (caboom_timer - caboom_left) / caboom_timer
		playsound(bound_xeno, caboom_sound[caboom_loop], amplitude, FALSE, 10)
		caboom_loop++
		if(caboom_loop > length(caboom_sound))
			caboom_loop = 1
	if(caboom_left <= 0)
		caboom_trigger = FALSE
		do_caboom()
		return

	var/image/holder = bound_xeno.hud_list[SPECIAL_HUD]
	holder.overlays.Cut()
	var/percentage_acid = round((acid_amount / max_acid) * 100, 10)
	var/percentage_acid_cap = round((acid_gen_cap /max_acid) * 100, 10)
	if(percentage_acid)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_acid]")
	if(acid_amount >= acid_gen_cap)
		holder.overlays += image('icons/mob/hud/hud.dmi', "cap[percentage_acid_cap]")

/datum/behavior_delegate/runner_acider/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[SPECIAL_HUD]
	holder.overlays.Cut()
	STOP_PROCESSING(SSfasteffects, src)

/datum/behavior_delegate/runner_acider/proc/do_caboom()
	if(!bound_xeno)
		return
	var/acid_range = acid_amount / caboom_acid_ratio
	var/max_burn_damage = acid_amount / caboom_burn_damage_ratio
	var/burn_range = acid_amount / caboom_burn_range_ratio

	for(var/barricades in dview(acid_range, bound_xeno))
		if(istype(barricades, /obj/structure/barricade))
			new caboom_struct_acid_type(get_turf(barricades), barricades)
			continue
		if(istype(barricades, /mob))
			new /datum/effects/acid(barricades, bound_xeno, initial(bound_xeno.caste_type))
			continue
	var/x = bound_xeno.x
	var/y = bound_xeno.y
	FOR_DVIEW(var/mob/living/target_living, burn_range, bound_xeno, HIDE_INVISIBLE_OBSERVER)
		if (!isxeno_human(target_living) || bound_xeno.can_not_harm(target_living))
			continue
		var/dist = 0
		// such cheap, much fast
		var/dx = abs(target_living.x - x)
		var/dy = abs(target_living.y - y)
		if(dx>=dy)
			dist = (0.934*dx) + (0.427*dy)
		else
			dist = (0.427*dx) + (0.934*dy)
		var/damage = floor((burn_range - dist) * max_burn_damage / burn_range)
		if(isxeno(target_living))
			damage *= XVX_ACID_DAMAGEMULT

		target_living.apply_damage(damage, BURN)
	FOR_DVIEW_END
	FOR_DVIEW(var/turf/T, acid_range, bound_xeno, HIDE_INVISIBLE_OBSERVER)
		new /obj/effect/particle_effect/smoke/acid_runner_harmless(T)
	FOR_DVIEW_END
	playsound(bound_xeno, 'sound/effects/blobattack.ogg', 75)
	if(bound_xeno.client && bound_xeno.hive)
		var/datum/hive_status/hive_status = bound_xeno.hive
		var/turf/spawning_turf = get_turf(bound_xeno)
		if(!hive_status.hive_location)
			addtimer(CALLBACK(bound_xeno.hive, TYPE_PROC_REF(/datum/hive_status, respawn_on_turf), bound_xeno.client, spawning_turf), 0.5 SECONDS)
		else
			addtimer(CALLBACK(bound_xeno.hive, TYPE_PROC_REF(/datum/hive_status, free_respawn), bound_xeno.client), 5 SECONDS)
	bound_xeno.gib(create_cause_data("internal acid rupture", src))

/mob/living/carbon/xenomorph/runner/ventcrawl_carry()
	var/datum/behavior_delegate/runner_acider/behavior_delegates = behavior_delegate
	if(istype(behavior_delegates) && behavior_delegates.caboom_trigger)
		to_chat(src, SPAN_XENOWARNING("You cannot ventcrawl when you are about to explode!"))
		return FALSE
	return ..()

/mob/living/carbon/xenomorph/runner/get_examine_text(mob/user)
	. = ..()
	var/datum/behavior_delegate/runner_acider/behavior = behavior_delegate
	if(istype(behavior) && isxeno(user))
		. += "it has [SPAN_GREEN(behavior.acid_amount)] acid!"

/datum/behavior_delegate/runner_acider/proc/combat_gen_end() //This proc is triggerd once the combat acid timer runs out.
	combat_gen_active = FALSE //turns combat acid off
	drool_overlay_active = FALSE
	bound_xeno.behavior_delegate?.on_update_icons()

/datum/behavior_delegate/runner_acider/on_update_icons()
	var/mob/living/carbon/xenomorph/runner/bound_runner = bound_xeno
	update_acid_overlays()

	bound_runner.overlays -= drool_applied_icon
	drool_applied_icon.overlays.Cut()

	if(!drool_overlay_active)
		return

	if(bound_runner.stat == DEAD)
		drool_applied_icon.icon_state = "Acider Runner Dead"
	else if(bound_runner.body_position == LYING_DOWN)
		if(!HAS_TRAIT(bound_runner, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_runner, TRAIT_FLOORED))
			drool_applied_icon.icon_state = "Acider Runner Sleeping"
		else
			drool_applied_icon.icon_state = "Acider Runner Knocked Down"
	else
		drool_applied_icon.icon_state = "Acider Runner Walking"

	bound_runner.overlays += drool_applied_icon


/datum/behavior_delegate/runner_acider/proc/update_acid_overlays()
	var/mob/living/carbon/xenomorph/runner/bound_runner = bound_xeno

	if(!acid_overlays_icon || !istype(bound_runner))
		return

	bound_runner.overlays -= acid_overlays_icon
	acid_overlays_icon.overlays.Cut()

	if(!acid_amount)
		return

	///Simplified image index change.
	var/perc_index = 0
	if(acid_amount > max_acid * 0.8)
		perc_index = 3
	else if (acid_amount > max_acid * 0.5)
		perc_index = 2
	else if (acid_amount > max_acid * 0.2)
		perc_index = 1

	if(perc_index && bound_runner.stat != DEAD)
		if(bound_runner.body_position == LYING_DOWN)
			if(!HAS_TRAIT(bound_runner, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_runner, TRAIT_FLOORED))
				acid_overlays_icon.overlays += icon('icons/mob/xenos/castes/tier_1/runner_strain_overlays.dmi', "acidsac_[perc_index] Sleeping")
			else
				acid_overlays_icon.overlays += icon('icons/mob/xenos/castes/tier_1/runner_strain_overlays.dmi', "acidsac_[perc_index] Knocked Down")
		else
			acid_overlays_icon.overlays += icon('icons/mob/xenos/castes/tier_1/runner_strain_overlays.dmi', "acidsac_[perc_index]")

	bound_runner.overlays += acid_overlays_icon



/datum/action/xeno_action/activable/acider_acid/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(affected_atom, /obj/item) && !istype(affected_atom, /obj/structure/) && !istype(affected_atom, /obj/vehicle/multitile))
		to_chat(xeno, SPAN_XENOHIGHDANGER("Can only melt barricades and items!"))
		return
	var/datum/behavior_delegate/runner_acider/behavior_delegate = xeno.behavior_delegate
	if (!istype(behavior_delegate))
		return
	if(behavior_delegate.acid_amount < acid_cost)
		to_chat(xeno, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	xeno.corrosive_acid(affected_atom, acid_type, 0)
	for(var/obj/item/explosive/plastic/plastic_explosive in affected_atom.contents)
		xeno.corrosive_acid(plastic_explosive, acid_type, 0)
	return ..()


/datum/action/xeno_action/activable/acider_for_the_hive/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	if(!isturf(xeno.loc))
		to_chat(xeno, SPAN_XENOWARNING("It is too cramped in here to activate this!"))
		return

	var/area/xeno_area = get_area(xeno)
	if(xeno_area.flags_area & AREA_CONTAINMENT)
		to_chat(xeno, SPAN_XENOWARNING("We can't activate this here!"))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	var/datum/behavior_delegate/runner_acider/behavior_delegate = xeno.behavior_delegate
	if(!istype(behavior_delegate))
		return

	if(behavior_delegate.caboom_trigger)
		cancel_ability()
		return

	if(behavior_delegate.acid_amount < minimal_acid)
		to_chat(xeno, SPAN_XENOWARNING("Not enough acid built up for an explosion."))
		return

	notify_ghosts(header = "For the Hive!", message = "[xeno] is going to explode for the Hive!", source = xeno, action = NOTIFY_ORBIT)

	to_chat(xeno, SPAN_XENOWARNING("Our stomach starts turning and twisting, getting ready to compress the built up acid."))
	xeno.color = "#22FF22"
	xeno.set_light_color("#22FF22")
	xeno.set_light_range(3)

	behavior_delegate.caboom_trigger = TRUE
	behavior_delegate.caboom_left = behavior_delegate.caboom_timer
	behavior_delegate.caboom_last_proc = 0
	xeno.set_effect(behavior_delegate.caboom_timer*2, SUPERSLOW)

	START_PROCESSING(SSfasteffects, src)

	xeno.say(";FOR THE HIVE!!!")
	return ..()

/datum/action/xeno_action/activable/acider_for_the_hive/proc/cancel_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return
	var/datum/behavior_delegate/runner_acider/behavior_delegate = xeno.behavior_delegate
	if(!istype(behavior_delegate))
		return

	behavior_delegate.caboom_trigger = FALSE
	xeno.color = null
	xeno.set_light_range(0)
	behavior_delegate.modify_acid(-behavior_delegate.max_acid / 4)

	// Done this way rather than setting to 0 in case something else slowed us
	// -Original amount set - (time exploding + timer inaccuracy) * how much gets removed per tick / 2
	xeno.adjust_effect(behavior_delegate.caboom_timer * -2 - (behavior_delegate.caboom_timer - behavior_delegate.caboom_left + 2) * xeno.life_slow_reduction * 0.5, SUPERSLOW)

	to_chat(xeno, SPAN_XENOWARNING("We remove all our explosive acid before it combusted."))

	STOP_PROCESSING(SSfasteffects, src)
	button.set_maptext()

/datum/action/xeno_action/activable/acider_for_the_hive/process(delta_time)
	return update_caboom_maptext()

/datum/action/xeno_action/activable/acider_for_the_hive/proc/update_caboom_maptext()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/runner_acider/delegate = xeno.behavior_delegate
	if(!istype(delegate) || !delegate.caboom_trigger || delegate.caboom_left <= 0)
		button.set_maptext()
		return PROCESS_KILL

	button.set_maptext(SMALL_FONTS_COLOR(7, delegate.caboom_left, "#e69d00"), 19, 2)
	return



/mob/living/carbon/xenomorph/runner/corrosive_acid(atom/affected_atom, acid_type, plasma_cost)
	if(!istype(strain, /datum/xeno_strain/acider))
		return ..()
	if(!affected_atom.Adjacent(src))
		if(istype(affected_atom,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/plastic_explosive = affected_atom
			if(plastic_explosive.plant_target && !plastic_explosive.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("We can't reach [affected_atom]."))
				return
		else
			to_chat(src, SPAN_WARNING("[affected_atom] is too far away."))
			return

	if(!isturf(loc) || HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_WARNING("We can't melt [affected_atom] from here!"))
		return

	face_atom(affected_atom)

	var/wait_time = 10

	var/turf/turf = get_turf(affected_atom)

	for(var/obj/effect/xenomorph/acid/acid in turf)
		if(acid_type == acid.type && acid.acid_t == affected_atom)
			to_chat(src, SPAN_WARNING("[affected_atom] is already drenched in acid."))
			return

	var/obj/object
	//OBJ CHECK
	if(isobj(affected_atom))
		object = affected_atom

		wait_time = object.get_applying_acid_time()
		if(wait_time == -1)
			to_chat(src, SPAN_WARNING("We cannot dissolve [object]."))
			return
	else
		to_chat(src, SPAN_WARNING("We cannot dissolve [affected_atom]."))
		return
	wait_time = wait_time / 4
	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	// AGAIN BECAUSE SOMETHING COULD'VE ACIDED THE PLACE
	for(var/obj/effect/xenomorph/acid/acid in turf)
		if(acid_type == acid.type && acid.acid_t == affected_atom)
			to_chat(src, SPAN_WARNING("[affected_atom] is already drenched in acid."))
			return

	if(!check_state())
		return

	if(!affected_atom || QDELETED(affected_atom)) //Some logic.
		return

	if(!affected_atom.Adjacent(src) || (object && !isturf(object.loc)))//not adjacent or inside something
		if(istype(affected_atom, /obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/plastic_explosive = affected_atom
			if(plastic_explosive.plant_target && !plastic_explosive.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("We can't reach [affected_atom]."))
				return
		else
			to_chat(src, SPAN_WARNING("[affected_atom] is too far away."))
			return

	var/datum/behavior_delegate/runner_acider/behavior_del = behavior_delegate
	if(!istype(behavior_del))
		return
	if(behavior_del.acid_amount < behavior_del.melt_acid_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	behavior_del.modify_acid(-behavior_del.melt_acid_cost)

	var/obj/effect/xenomorph/acid/acid = new acid_type(turf, affected_atom)

	if(istype(affected_atom, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = affected_atom
		multitile_vehicle.take_damage_type(20 / acid.acid_delay, "acid", src)
		visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff at [multitile_vehicle]. It sizzles under the bubbling mess of acid!"),
			SPAN_XENOWARNING("We vomit globs of vile stuff at [multitile_vehicle]. It sizzles under the bubbling mess of acid!"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(acid, 20)
		return

	acid.add_hiddenprint(src)
	acid.name += " ([affected_atom])"

	visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff all over [affected_atom]. It begins to sizzle and melt under the bubbling mess of acid!"),
	SPAN_XENOWARNING("We vomit globs of vile stuff all over [affected_atom]. It begins to sizzle and melt under the bubbling mess of acid!"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)

#define ACIDER_ACID_LEVEL 3

/mob/living/carbon/xenomorph/runner/try_fill_trap(obj/effect/alien/resin/trap/target)
	if(!istype(strain, /datum/xeno_strain/acider))
		return ..()

	if(!istype(target))
		return FALSE

	var/datum/behavior_delegate/runner_acider/behavior_del = behavior_delegate
	if(!istype(behavior_del))
		return FALSE

	if(behavior_del.acid_amount < behavior_del.fill_acid_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return FALSE

	var/trap_acid_level = 0
	if(target.trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + target.trap_type - RESIN_TRAP_ACID1

	if(trap_acid_level >= ACIDER_ACID_LEVEL) // Acid runners apply /obj/effect/xenomorph/acid/strong generally
		to_chat(src, SPAN_XENONOTICE("It already has good acid in."))
		return FALSE

	to_chat(src, SPAN_XENONOTICE("You begin charging the resin trap with acid."))
	xeno_attack_delay(src)
	if(!do_after(src, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, src))
		return FALSE

	if(target.trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + target.trap_type - RESIN_TRAP_ACID1

	if(trap_acid_level >= ACIDER_ACID_LEVEL)
		return FALSE

	if(behavior_del.acid_amount < behavior_del.fill_acid_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return FALSE

	behavior_del.modify_acid(-behavior_del.fill_acid_cost)

	target.cause_data = create_cause_data("resin acid trap", src)
	target.setup_tripwires()
	target.set_state(RESIN_TRAP_ACID1 + ACIDER_ACID_LEVEL - 1)

	playsound(target, 'sound/effects/refill.ogg', 25, 1)
	visible_message(SPAN_XENOWARNING("[src] pressurises the resin trap with acid!"),
	SPAN_XENOWARNING("You pressurise the resin trap with acid!"), null, 5)
	return TRUE

#undef ACIDER_ACID_LEVEL
