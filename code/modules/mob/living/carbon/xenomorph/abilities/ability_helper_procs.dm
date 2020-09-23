
//Corrosive acid is consolidated -- it checks for specific castes for strength now, but works identically to each other.
//The acid items are stored in XenoProcs.
/mob/living/carbon/Xenomorph/proc/corrosive_acid(atom/O, acid_type, plasma_cost)
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

	//TURF CHECK
	else if(isturf(O))

		if(istype(O, /turf/closed/wall))
			var/turf/closed/wall/wall_target = O
			if(wall_target.acided_hole)
				to_chat(src, SPAN_WARNING("[O] is already weakened."))
				return

		var/dissolvability = T.can_be_dissolved()
		switch(dissolvability)
			if(0)
				to_chat(src, SPAN_WARNING("You cannot dissolve [T]."))
				return
			if(1)
				wait_time = 50
			if(2)
				if(acid_type != /obj/effect/xenomorph/acid/strong)
					to_chat(src, SPAN_WARNING("This [T.name] is too tough to be melted by your weak acid."))
					return
				wait_time = 100
			else
				return
		to_chat(src, SPAN_XENOWARNING("You begin generating enough acid to melt through [T]."))
	else
		to_chat(src, SPAN_WARNING("You cannot dissolve [O]."))
		return

	if(!do_after(src, wait_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return

	// AGAIN BECAUSE SOMETHING COULD'VE ACIDED THE PLACE
	for(var/obj/effect/xenomorph/acid/A in T)
		if(acid_type == A.type && A.acid_t == O)
			to_chat(src, SPAN_WARNING("[A] is already drenched in acid."))
			return

	if(!check_state())
		return

	if(!O || O.disposed) //Some logic.
		return

	if(!check_plasma(plasma_cost))
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

	use_plasma(plasma_cost)

	var/obj/effect/xenomorph/acid/A = new acid_type(T, O)

	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/R = O
		R.take_damage_type((1 / A.acid_strength) * 20, "acid", src)
		visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff at \the [O]. It sizzles under the bubbling mess of acid!"), \
			SPAN_XENOWARNING("You vomit globs of vile stuff at [O]. It sizzles under the bubbling mess of acid!"), null, 5)
		playsound(loc, "sound/bullets/acid_impact1.ogg", 25)
		QDEL_IN(A, 20)
		return

	if(isturf(O))
		A.icon_state += "_wall"

	if(istype(O, /obj/structure) || istype(O, /obj/structure/machinery)) //Always appears above machinery
		A.layer = O.layer + 0.1
	else //If not, appear on the floor or on an item
		A.layer = LOWER_ITEM_LAYER //below any item, above BELOW_OBJ_LAYER (smartfridge)

	A.add_hiddenprint(src)
	A.name += " ([O])"

	if(!isturf(O))
		msg_admin_attack("[src.name] ([src.ckey]) spat acid on [O] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
		attack_log += text("\[[time_stamp()]\] <font color='green'>Spat acid on [O]</font>")
	visible_message(SPAN_XENOWARNING("[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!"), \
	SPAN_XENOWARNING("You vomit globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!"), null, 5)
	playsound(loc, "sound/bullets/acid_impact1.ogg", 25)

/proc/unroot_human(mob/living/carbon/H)
	if (!isXenoOrHuman(H))
		return

	H.frozen = 0
	H.update_canmove()

	if(ishuman(H))
		var/mob/living/carbon/human/T = H
		T.update_xeno_hostile_hud()
	to_chat(H, SPAN_XENOHIGHDANGER("You can move again!"))

/proc/xeno_throw_human(mob/living/carbon/H, mob/living/carbon/Xenomorph/X, direction, distance)
	if (!istype(H) || !istype(X) ||  !direction || !distance)
		return

	var/turf/T = get_turf(H)
	var/turf/temp = get_turf(H)
	for (var/x in 0 to distance)
		temp = get_step(T, direction)
		if (!temp)
			break
		T = temp

	H.throw_atom(T, distance, SPEED_VERY_FAST, X, TRUE)
	shake_camera(H, 10, 1)

/mob/living/carbon/Xenomorph/proc/zoom_in(movement_handler_type = /datum/event_handler/xeno_zoom_onmovement)
	if(stat || resting)
		if(is_zoomed)
			is_zoomed = 0
			zoom_out()
			return
		return
	if(is_zoomed)
		return
	if(!client)
		return
	is_zoomed = 1
	// Clients can opt-out of cancelling zoom on movement by handing in NULL
	if (movement_handler_type != XENOZOOM_NO_MOVEMENT_HANDLER)
		add_movement_handler(new movement_handler_type(src))
	client.change_view(viewsize)
	var/viewoffset = 32 * tileoffset
	switch(dir)
		if(NORTH)
			client.pixel_x = 0
			client.pixel_y = viewoffset
		if(SOUTH)
			client.pixel_x = 0
			client.pixel_y = -viewoffset
		if(EAST)
			client.pixel_x = viewoffset
			client.pixel_y = 0
		if(WEST)
			client.pixel_x = -viewoffset
			client.pixel_y = 0

/mob/living/carbon/Xenomorph/proc/zoom_out()
	if(!client)
		return
	client.change_view(world_view_size)
	client.pixel_x = 0
	client.pixel_y = 0
	is_zoomed = 0

/datum/event_handler/xeno_zoom_onmovement
	flags_handler = NO_FLAGS
	var/mob/living/carbon/Xenomorph/X = null

/datum/event_handler/xeno_zoom_onmovement/New(mob/living/carbon/Xenomorph/X)
	if (!isXeno(X))
		qdel(src)
		return
	src.X = X

/datum/event_handler/xeno_zoom_onmovement/Destroy()
	X = null
	. = ..()
	return

/datum/event_handler/xeno_zoom_onmovement/handle(sender, datum/event_args/ev_args)
	var/datum/event_args/mob_movement/event_args = ev_args
	var/isMoving = event_args.moving

	if (!isMoving)
		return

	if (X && !X.disposed)
		cancel_zoom()
		return 0
	else
		qdel(src)

/datum/event_handler/xeno_zoom_onmovement/proc/cancel_zoom()
	if (!istype(X) || X.disposed || !X.is_zoomed)
		qdel(src)
		return


	X.zoom_out()
	X.event_movement.remove_handler(src)
	qdel(src)

// Movement with a 'buffer'
// only if our counter is zero do we return
/datum/event_handler/xeno_zoom_onmovement/buffer
	var/buffer = 14 // for some reason this gets decremented twice per move, so we set 14 to allow 7 moves

/datum/event_handler/xeno_zoom_onmovement/buffer/New(mob/living/carbon/Xenomorph/X, buffer = 14)
	if (!isXeno(X))
		qdel(src)
		return
	src.buffer = buffer
	src.X = X

/datum/event_handler/xeno_zoom_onmovement/buffer/handle(sender, datum/event_args/ev_args)
	var/datum/event_args/mob_movement/event_args = ev_args
	var/isMoving = event_args.moving

	if (!isMoving)
		return

	if (X && !X.disposed)
		if (buffer > 0)
			buffer--
		else
			cancel_zoom()
	else
		X = null
		qdel(src)


/mob/living/carbon/Xenomorph/proc/do_acid_spray_cone(var/turf/T, spray_type = /obj/effect/xenomorph/spray, range = 3)
	set waitfor = FALSE

	var/facing = get_cardinal_dir(src, T)
	dir = facing

	T = loc
	for(var/i in 0 to range - 1)
		var/turf/next_turf = get_step(T, facing)
		var/atom/movable/temp = new/obj/effect/xenomorph/spray()
		var/atom/movable/AM = LinkBlocked(temp, T, next_turf)
		qdel(temp)
		if(AM)
			AM.acid_spray_act(src)
			return
		T = next_turf
		var/obj/effect/xenomorph/spray/S = new spray_type(T, initial(src.caste_name), src)
		do_acid_spray_cone_normal(T, i, facing, S, spray_type)
		sleep(2)

// Normal refers to the mathematical normal
/mob/living/carbon/Xenomorph/proc/do_acid_spray_cone_normal(turf/T, distance, facing, obj/effect/xenomorph/spray/source_spray, spray_type = /obj/effect/xenomorph/spray)
	if(!distance)
		return

	var/obj/effect/xenomorph/spray/left_S = source_spray
	var/obj/effect/xenomorph/spray/right_S = source_spray

	var/normal_dir = turn(facing, 90)
	var/inverse_normal_dir = turn(facing, -90)

	var/turf/normal_turf = T
	var/turf/inverse_normal_turf = T

	var/normal_density_flag = FALSE
	var/inverse_normal_density_flag = FALSE

	for(var/i in 1 to distance)
		if(normal_density_flag && inverse_normal_density_flag)
			return

		if(!normal_density_flag)
			var/next_normal_turf = get_step(normal_turf, normal_dir)
			var/atom/A = LinkBlocked(left_S, normal_turf, next_normal_turf)

			if(A)
				A.acid_spray_act()
				normal_density_flag = TRUE
			else
				normal_turf = next_normal_turf
				left_S = new spray_type(normal_turf, initial(src.caste_name), src)


		if(!inverse_normal_density_flag)
			var/next_inverse_normal_turf = get_step(inverse_normal_turf, inverse_normal_dir)
			var/atom/A = LinkBlocked(right_S, inverse_normal_turf, next_inverse_normal_turf)

			if(A)
				A.acid_spray_act()
				inverse_normal_density_flag = TRUE
			else
				inverse_normal_turf = next_inverse_normal_turf
				right_S = new spray_type(inverse_normal_turf, initial(src.caste_name), src)


/mob/living/carbon/Xenomorph/proc/do_acid_spray_line(list/turflist, spray_path = /obj/effect/xenomorph/spray, distance_max = 5)
	if(isnull(turflist))
		return
	var/turf/prev_turf = loc

	var/distance = 0
	for(var/turf/T in turflist)
		distance++

		if(!prev_turf && turflist.len > 1)
			prev_turf = get_turf(src)
			continue //So we don't burn the tile we be standin on

		if(T.density || istype(T, /turf/open/space))
			break
		if(distance > distance_max)
			break

		var/atom/movable/temp = new spray_path()
		var/atom/movable/AM = LinkBlocked(temp, prev_turf, T)
		qdel(temp)
		if(AM)
			AM.acid_spray_act(src)
			break

		prev_turf = T
		new spray_path(T, initial(src.caste_name), src)
		sleep(2)


/mob/living/carbon/Xenomorph/proc/xeno_transfer_plasma(atom/A, amount = 50, transfer_delay = 20, max_range = 2)
	if(!istype(A, /mob/living/carbon/Xenomorph))
		return
	var/mob/living/carbon/Xenomorph/target = A

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't transfer plasma from here!"))
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("You need to be closer to [target]."))
		return

	to_chat(src, SPAN_NOTICE("You start focusing your plasma towards [target]."))
	to_chat(target, SPAN_NOTICE("You feel that [src] starts transferring some of their plasma to you."))
	if(!do_after(src, transfer_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return

	if(!check_state())
		return

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You can't transfer plasma from here!"))
		return

	if(get_dist(src, target) > max_range)
		to_chat(src, SPAN_WARNING("You need to be closer to [target]."))
		return

	if(plasma_stored < amount)
		amount = plasma_stored //Just use all of it
	use_plasma(amount)
	target.gain_plasma(amount)
	to_chat(target, SPAN_XENOWARNING("[src] has transfered [amount] plasma to you. You now have [target.plasma_stored]."))
	to_chat(src, SPAN_XENOWARNING("You have transferred [amount] plasma to [target]. You now have [plasma_stored]."))
	playsound(src, "alien_drool", 25)