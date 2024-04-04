/datum/action/xeno_action/activable/runner_skillshot/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc) || !xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] fires a burst of bone chips at [affected_atom]!"), SPAN_XENOWARNING("We fire a burst of bone chips at [affected_atom]!"))

	var/turf/target = locate(affected_atom.x, affected_atom.y, affected_atom.z)
	var/obj/projectile/projectile = new /obj/projectile(xeno.loc, create_cause_data(initial(xeno.caste_type), xeno))

	var/datum/ammo/ammo_datum = GLOB.ammo_list[ammo_type]

	projectile.generate_bullet(ammo_datum)

	projectile.fire_at(target, xeno, xeno, ammo_datum.max_range, ammo_datum.shell_speed)

	apply_cooldown()
	return ..()


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
			to_chat(src, SPAN_WARNING("[acid] is already drenched in acid."))
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
	if (!istype(behavior_del))
		return
	if(behavior_del.acid_amount < behavior_del.melt_acid_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	behavior_del.modify_acid(-behavior_del.melt_acid_cost)

	var/obj/effect/xenomorph/acid/acid = new acid_type(turf, affected_atom)

	if(istype(affected_atom, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = affected_atom
		multitile_vehicle.take_damage_type(20 / acid.acid_delay, "acid", src)
		visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff at [multitile_vehicle]. It sizzles under the bubbling mess of acid!"), \
			SPAN_XENOWARNING("We vomit globs of vile stuff at [multitile_vehicle]. It sizzles under the bubbling mess of acid!"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(acid, 20)
		return

	acid.add_hiddenprint(src)
	acid.name += " ([affected_atom])"

	visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff all over [affected_atom]. It begins to sizzle and melt under the bubbling mess of acid!"), \
	SPAN_XENOWARNING("We vomit globs of vile stuff all over [affected_atom]. It begins to sizzle and melt under the bubbling mess of acid!"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)


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
