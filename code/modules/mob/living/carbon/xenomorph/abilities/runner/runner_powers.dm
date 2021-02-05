/datum/action/xeno_action/activable/runner_skillshot/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENOWARNING("[X] fires a burst of bone chips at [A]!"), SPAN_XENOWARNING("You fire a burst of bone chips at [A]!"))

	var/turf/target = locate(A.x, A.y, A.z)
	var/obj/item/projectile/P = new /obj/item/projectile(initial(X.caste_name), X, X.loc)

	var/datum/ammo/ammoDatum = GLOB.ammo_list[ammo_type]

	P.generate_bullet(ammoDatum)

	P.fire_at(target, X, X, ammoDatum.max_range, ammoDatum.shell_speed)

	apply_cooldown()
	..()
	return


/datum/action/xeno_action/activable/acider_acid/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if(!istype(A, /obj/item) && !istype(A, /obj/structure/) && !istype(A, /obj/vehicle/multitile))
		to_chat(X, SPAN_XENOHIGHDANGER("Can only melt barricades and items!"))
		return
	var/datum/behavior_delegate/runner_acider/BD = X.behavior_delegate
	if (!istype(BD))
		return
	if(BD.acid_amount < acid_cost)
		to_chat(X, SPAN_XENOHIGHDANGER("Not enough acid stored!"))
		return

	X.corrosive_acid(A, acid_type, 0)
	for(var/obj/item/explosive/plastic/E in A.contents)
		X.corrosive_acid(E,acid_type,0)
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

		if(I.unacidable || istype(I, /obj/structure/machinery/computer) || istype(I, /obj/effect)) //So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
			to_chat(src, SPAN_WARNING("You cannot dissolve [I].")) // ^^ Note for obj/effect.. this might check for unwanted stuff. Oh well
			return
		if(istype(O, /obj/structure/window_frame))
			var/obj/structure/window_frame/WF = O
			if(WF.reinforced && acid_type != /obj/effect/xenomorph/acid/strong)
				to_chat(src, SPAN_WARNING("This [O.name] is too tough to be melted by your weak acid."))
				return

		if(O.density || istype(O, /obj/structure))
			wait_time = 40 //dense objects are big, so takes longer to melt.
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


/datum/action/xeno_action/activable/acider_for_the_hive/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if(!istype(X))
		return

	if(!X.check_state())
		return

	if(!action_cooldown_check())
		return

	if(X.mutation_type != RUNNER_ACIDER)
		return

	var/datum/behavior_delegate/runner_acider/BD = X.behavior_delegate
	if(!istype(BD))
		return

	if(BD.caboom_trigger)
		cancel_ability()
		return

	if(BD.acid_amount < minimal_acid)
		to_chat(X, SPAN_XENOWARNING("Not enough acid built up for an explosion."))
		return

	to_chat(X, SPAN_XENOWARNING("Your stomach starts turning and twisting, getting ready to compress the built up acid."))
	X.color = "#22FF22"
	X.SetLuminosity(3)

	BD.caboom_trigger = TRUE
	BD.caboom_left = BD.caboom_timer
	BD.caboom_last_proc = 0
	X.SetSuperslowed(BD.caboom_timer*2)

	X.say(";FOR THE HIVE!!!")

/datum/action/xeno_action/activable/acider_for_the_hive/proc/cancel_ability()
	var/mob/living/carbon/Xenomorph/X = owner

	if(!istype(X))
		return
	var/datum/behavior_delegate/runner_acider/BD = X.behavior_delegate
	if(!istype(BD))
		return

	BD.caboom_trigger = FALSE
	X.color = null
	X.SetLuminosity(0)
	BD.modify_acid(-BD.max_acid / 4)
	to_chat(X, SPAN_XENOWARNING("You remove all your explosive acid before it combusted."))
