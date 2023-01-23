/datum/action/xeno_action/activable/runner_skillshot/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner
	if (!istype(xeno_owner))
		return

	if (!action_cooldown_check())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno_owner.loc) || !xeno_owner.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno_owner.visible_message(SPAN_XENOWARNING("[xeno_owner] fires a burst of bone chips at [target]!"), SPAN_XENOWARNING("You fire a burst of bone chips at [target]!"))

	var/turf/target_turf = locate(target.x, target.y, target.z)
	var/obj/item/projectile/bone_chip = new /obj/item/projectile(xeno_owner.loc, create_cause_data(initial(xeno_owner.caste_type), xeno_owner))

	var/datum/ammo/chip_ammo = GLOB.ammo_list[ammo_type]

	bone_chip.generate_bullet(chip_ammo)

	bone_chip.fire_at(target_turf, xeno_owner, xeno_owner, chip_ammo.max_range, chip_ammo.shell_speed)

	apply_cooldown()
	..()
	return


/datum/action/xeno_action/activable/acider_acid/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner
	if(!istype(target, /obj/item) && !istype(target, /obj/structure/) && !istype(target, /obj/vehicle/multitile))
		to_chat(xeno_owner, SPAN_XENOHIGHDANGER("Can only melt barricades and items!"))
		return
	var/datum/behavior_delegate/runner_acider/BD = xeno_owner.behavior_delegate
	if (!istype(BD))
		return
	if(BD.acid_amount < acid_cost)
		to_chat(xeno_owner, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	xeno_owner.corrosive_acid(target, acid_type, 0)
	for(var/obj/item/explosive/plastic/E in target.contents)
		xeno_owner.corrosive_acid(E,acid_type,0)
	..()

/mob/living/carbon/Xenomorph/Runner/corrosive_acid(atom/O, acid_type, plasma_cost)
	if (mutation_type != RUNNER_ACIDER)
		..(O, acid_type, plasma_cost)
		return
	if(!O.Adjacent(src))
		if(istype(O,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/E = O
			if(E.plant_target && !E.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("You can't reach [O]."))
				return
		else
			to_chat(src, SPAN_WARNING("[O] is too far away."))
			return

	if(!isturf(loc) || burrow)
		to_chat(src, SPAN_WARNING("You can't melt [O] from here!"))
		return

	face_atom(O)

	var/wait_time = 10

	var/turf/T = get_turf(O)

	for(var/obj/effect/xenomorph/acid/A in T)
		if(acid_type == A.type && A.acid_t == O)
			to_chat(src, SPAN_WARNING("[A] is already drenched in acid."))
			return

	var/obj/I
	//OBJ CHECK
	if(isobj(O))
		I = O

		if(istype(O, /obj/structure/window_frame))
			var/obj/structure/window_frame/WF = O
			if(WF.reinforced && acid_type != /obj/effect/xenomorph/acid/strong)
				to_chat(src, SPAN_WARNING("This [O.name] is too tough to be melted by your weak acid."))
				return

		wait_time = I.get_applying_acid_time()
		if(wait_time == -1)
			to_chat(src, SPAN_WARNING("You cannot dissolve \the [I]."))
			return
	else
		to_chat(src, SPAN_WARNING("You cannot dissolve [O]."))
		return
	wait_time = wait_time / 4
	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	// AGAIN BECAUSE SOMETHING COULD'VE ACIDED THE PLACE
	for(var/obj/effect/xenomorph/acid/A in T)
		if(acid_type == A.type && A.acid_t == O)
			to_chat(src, SPAN_WARNING("[A] is already drenched in acid."))
			return

	if(!check_state())
		return

	if(!O || QDELETED(O)) //Some logic.
		return

	if(!O.Adjacent(src) || (I && !isturf(I.loc)))//not adjacent or inside something
		if(istype(O,/obj/item/explosive/plastic))
			var/obj/item/explosive/plastic/E = O
			if(E.plant_target && !E.plant_target.Adjacent(src))
				to_chat(src, SPAN_WARNING("You can't reach [O]."))
				return
		else
			to_chat(src, SPAN_WARNING("[O] is too far away."))
			return

	var/datum/behavior_delegate/runner_acider/BD = behavior_delegate
	if (!istype(BD))
		return
	if(BD.acid_amount < BD.melt_acid_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	BD.modify_acid(-BD.melt_acid_cost)

	var/obj/effect/xenomorph/acid/A = new acid_type(T, O)

	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/R = O
		R.take_damage_type((1 / A.acid_strength) * 20, "acid", src)
		visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff at \the [O]. It sizzles under the bubbling mess of acid!"), \
			SPAN_XENOWARNING("You vomit globs of vile stuff at [O]. It sizzles under the bubbling mess of acid!"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(A, 20)
		return

	A.add_hiddenprint(src)
	A.name += " ([O])"

	visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!"), \
	SPAN_XENOWARNING("You vomit globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)


/datum/action/xeno_action/activable/acider_for_the_hive/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner

	if(!istype(xeno_owner))
		return

	if(!isturf(xeno_owner.loc))
		to_chat(xeno_owner, SPAN_XENOWARNING("It is too cramped in here to activate this!"))
		return

	var/area/xeno_area = get_area(xeno_owner)
	if(xeno_area.flags_area & AREA_CONTAINMENT)
		to_chat(xeno_owner, SPAN_XENOWARNING("You can't activate this here!"))
		return

	if(!xeno_owner.check_state())
		return

	if(!action_cooldown_check())
		return

	if(xeno_owner.mutation_type != RUNNER_ACIDER)
		return

	var/datum/behavior_delegate/runner_acider/BD = xeno_owner.behavior_delegate
	if(!istype(BD))
		return

	if(BD.caboom_trigger)
		cancel_ability()
		return

	if(BD.acid_amount < minimal_acid)
		to_chat(xeno_owner, SPAN_XENOWARNING("Not enough acid built up for an explosion."))
		return

	to_chat(xeno_owner, SPAN_XENOWARNING("Your stomach starts turning and twisting, getting ready to compress the built up acid."))
	xeno_owner.color = "#22FF22"
	xeno_owner.SetLuminosity(3)

	BD.caboom_trigger = TRUE
	BD.caboom_left = BD.caboom_timer
	BD.caboom_last_proc = 0
	xeno_owner.set_effect(BD.caboom_timer*2, SUPERSLOW)

	xeno_owner.say(";FOR THE HIVE!!!")

/datum/action/xeno_action/activable/acider_for_the_hive/proc/cancel_ability()
	var/mob/living/carbon/Xenomorph/xeno_owner = owner

	if(!istype(xeno_owner))
		return
	var/datum/behavior_delegate/runner_acider/BD = xeno_owner.behavior_delegate
	if(!istype(BD))
		return

	BD.caboom_trigger = FALSE
	xeno_owner.color = null
	xeno_owner.SetLuminosity(0)
	BD.modify_acid(-BD.max_acid / 4)
	to_chat(xeno_owner, SPAN_XENOWARNING("You remove all your explosive acid before it combusted."))
