/obj/effect/blocker/water/toxic
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "spawn_shuttle"
	spread_delay = 0.5 SECONDS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_FLY_LAYER //to make it visible in the map editor
	var/toxic = WATER_TOXIC_YES
	var/const/WATER_TOXIC_NO = 0
	var/const/WATER_TOXIC_YES = 1
	var/const/WATER_TOXIC_DISPERSING = -1

/obj/effect/blocker/water/toxic/Group_1
	disperse_group = 1
	icon_state = "spawn_event"

/obj/effect/blocker/water/toxic/Group_1/delay
	spread_delay = 10 SECONDS
	icon_state = "spawn_shuttle_dock"

/obj/effect/blocker/water/toxic/Group_2
	disperse_group = 2
	icon_state = "spawn_goal"

/obj/effect/blocker/water/toxic/Group_2/delay
	spread_delay = 10 SECONDS
	icon_state = "spawn_shuttle_dock"

/obj/effect/blocker/water/toxic/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/blocker/water/toxic/LateInitialize()
	. = ..()
	update_turf()
	icon_state = null

/obj/effect/blocker/water/toxic/proc/update_turf()
	if(istype(src.loc, /turf/open/gm/river/desert))
		var/turf/open/gm/river/desert/R = src.loc
		R.toxic = src.toxic
		R.update_icon()

	else if(istype(src.loc, /turf/open/desert/desert_shore))
		var/turf/open/desert/desert_shore/S = src.loc
		S.toxic = src.toxic
		S.update_icon()

	else if(istype(src.loc, /turf/open/desert/cave/cave_shore))
		var/turf/open/desert/cave/cave_shore/C = src.loc
		C.toxic = src.toxic
		C.update_icon()

/obj/effect/blocker/water/toxic/Crossed(atom/A)
	if(toxic == WATER_TOXIC_NO)
		return

	if(istype(loc, /turf/open/gm/river/desert))
		var/turf/open/gm/river/desert/R = loc
		if(R.covered)
			return
	else
		return

	if(isliving(A))
		var/mob/living/M = A

		if(!istype(M.loc, /turf))
			return

		if(isxeno(M))
			if(M.pulling)
				to_chat(M, SPAN_WARNING("The current forces you to release [M.pulling]!"))
				M.stop_pulling()

		if(HAS_TRAIT(M, TRAIT_HAULED))
			return

		cause_damage(M)
		START_PROCESSING(SSobj, src)
		return
	else if(isVehicleMultitile(A))
		var/obj/vehicle/multitile/V = A

		//various colony vehicles and trucks take damage from toxic water. Military-grade armored vehicles don't
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
			V.handle_acidic_environment(src)
			START_PROCESSING(SSobj, src)
		return

/obj/effect/blocker/water/toxic/process()
	if(toxic == WATER_TOXIC_NO)
		STOP_PROCESSING(SSobj, src)
		return

	if(istype(src.loc, /turf/open/gm/river/desert))
		var/turf/open/gm/river/desert/R = loc
		if(R.covered)
			return
	else
		return

	var/targets_present = 0
	for(var/mob/living/carbon/M in range(0, src))
		targets_present++
		cause_damage(M)
	for(var/obj/vehicle/multitile/V in range(0, src))
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
			targets_present++
			V.handle_acidic_environment(src)

	if(targets_present < 1)
		STOP_PROCESSING(SSobj, src)

/obj/effect/blocker/water/toxic/proc/cause_damage(mob/living/target)
	if(target.stat == DEAD)
		return
	target.last_damage_data = create_cause_data("toxic water")
	if(islarva(target))
		target.apply_damage(2, BURN, enviro=TRUE)
	else if(isxeno(target) && !islarva(target))
		target.apply_damage(34, BURN, enviro=TRUE)
	else if(isyautja(target))
		target.apply_damage(0.5, BURN, enviro=TRUE)
	else
		var/dam_amount = 3
		if(target.body_position == LYING_DOWN)
			target.apply_damage(dam_amount, BURN, enviro=TRUE)
			target.apply_damage(dam_amount, BURN, enviro=TRUE)
			target.apply_damage(dam_amount, BURN, enviro=TRUE)
			target.apply_damage(dam_amount, BURN, enviro=TRUE)
			target.apply_damage(dam_amount, BURN, enviro=TRUE)
		else
			target.apply_damage(dam_amount, BURN, "l_leg", enviro=TRUE)
			target.apply_damage(dam_amount, BURN, "l_foot", enviro=TRUE)
			target.apply_damage(dam_amount, BURN, "r_leg", enviro=TRUE)
			target.apply_damage(dam_amount, BURN, "r_foot", enviro=TRUE)
			target.apply_damage(dam_amount, BURN, "groin", enviro=TRUE)
		target.apply_effect(20,IRRADIATE,0)
		if( !issynth(target) )
			to_chat(target, SPAN_DANGER("The water burns!"))
	playsound(target, 'sound/bullets/acid_impact1.ogg', 10, 1)


/obj/effect/blocker/water/toxic/disperse_spread(from_dir = 0)
	if(toxic == WATER_TOXIC_NO)
		return // it's already been dispersed!
	. = ..() // proceed as normal

/obj/effect/blocker/water/toxic/disperse()
	. = ..()
	toxic = WATER_TOXIC_DISPERSING
	update_turf()
	addtimer(CALLBACK(src, PROC_REF(do_disperse)), 1 SECONDS)

/obj/effect/blocker/water/toxic/proc/do_disperse()
	toxic = WATER_TOXIC_NO
	update_turf()
	dispersing = FALSE
