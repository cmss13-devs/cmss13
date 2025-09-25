/*
/obj/effect/landmark/desertdam
	icon = 'icons/misc/mark.dmi'
/obj/effect/landmark/desertdam/river_blocker
	name = "toxic river blocker"
	icon_state = "spawn_event"

/obj/effect/blocker/fog
	name = "dense fog"
	desc = "It looks way too dangerous to traverse. Best wait until it has cleared up."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	density = TRUE
	//opacity = TRUE
	unslashable = TRUE
	unacidable = TRUE

	New()
		..()
		dir  = pick(CARDINAL_DIRS)

	attack_hand(mob/M)
		to_chat(M, SPAN_NOTICE("You peer through the fog, but it's impossible to tell what's on the other side..."))

	attack_alien(M)
		return attack_hand(M)


//Disperses river, doing so gradually.
/datum/game_mode/proc/disperse_river()
	set waitfor = 0
	flags_round_type &= ~MODE_FOG_ACTIVATED
	var/i
	for(i in round_toxic_river)
		round_toxic_river -= i
		qdel(i)
		sleep(1)
	round_toxic_river = null
*/

/*
So, how will we do this?
Global river status var, maybe


Each var depends on others


/proc/filtration_check()
	if(east_filtration)

*/
/obj/effect/blocker/water
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	unacidable = TRUE

	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "seadeep"


	alpha = 0
	layer = TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/flooded_alpha = 180
	var/dispersing = FALSE
	var/toxic = FALSE
	var/disperse_group = 1
	var/spread_delay = 5
	var/list/water_sounds = list('sound/effects/slosh.ogg')




/obj/effect/blocker/water/toxic
	icon = 'icons/old_stuff/mark.dmi'
	toxic = TRUE
	disperse_group
	spread_delay = 5
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_FLY_LAYER //to make it visible in the map editor

	icon_state = "spawn_shuttle"

/obj/effect/blocker/water/toxic/Group_1
	disperse_group = 1
	icon_state = "spawn_event"

/obj/effect/blocker/water/toxic/Group_1/delay
	spread_delay = 100
	icon_state = "spawn_shuttle_dock"

/obj/effect/blocker/water/toxic/Group_2
	disperse_group = 2
	icon_state = "spawn_goal"

/obj/effect/blocker/water/toxic/Group_2/delay
	spread_delay = 100
	icon_state = "spawn_shuttle_dock"


/obj/effect/blocker/water/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/blocker/water/toxic/LateInitialize()
	. = ..()
	update_turf()
	icon_state = null


/obj/effect/blocker/water/proc/update_turf()
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



/obj/effect/blocker/water/Crossed(atom/A)
	if(toxic == 0)
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

		START_PROCESSING(SSobj, src)
		return
	else if(isVehicleMultitile(A))
		var/obj/vehicle/multitile/V = A

		//various colony vehicles and trucks take damage from toxic water. Military-grade armored vehicles don't
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
			V.handle_acidic_environment(src)
			START_PROCESSING(SSobj, src)
		return


/obj/effect/blocker/water/process()

	if(!toxic)
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
	for(var/obj/vehicle/multitile/V in range(0, src))
		if(V.vehicle_flags & VEHICLE_CLASS_WEAK)
			targets_present++
			V.handle_acidic_environment(src)

	if(targets_present < 1)
		STOP_PROCESSING(SSobj, src)

/obj/effect/blocker/toxic_water/proc/cause_damage(mob/living/target)
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


/obj/effect/blocker/water/proc/disperse_spread(from_dir = 0, drain = FALSE)
	if((dispersing && !drain) || (!dispersing && drain))
		return

	for(var/direction in GLOB.alldirs)
		if(direction == from_dir)
			continue //doesn't check backwards

		var/effective_spread_delay
		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				effective_spread_delay = spread_delay
			else
				effective_spread_delay = spread_delay * 1.414 //diagonal spreading takes longer

		for(var/obj/effect/blocker/water/W in get_step(src,direction) )
			if(W.disperse_group == src.disperse_group)
				spawn(effective_spread_delay)
					W.disperse_spread(turn(direction,180), drain)
	if(drain)
		drain()
	else
		disperse(from_dir)

/obj/effect/blocker/water/proc/drain()
	dispersing = 0
	animate(src, alpha = initial(alpha), time = 60)
	var/turf/location = loc
	location.is_weedable = initial(location.is_weedable)


/obj/effect/blocker/water/proc/disperse(from_dir)
	dispersing = 1
	if(prob(30))
		var/sound = pick(water_sounds)
		playsound(loc, sound, 10, 1)
	for(var/obj/effect/alien/weeds/weeds_to_clean in loc)
		qdel(weeds_to_clean)

	for(var/obj/effect/alien/resin/resin in loc)
		qdel(resin)

	for(var/obj/flamer_fire/fire in loc)
		qdel(fire)

	for(var/obj/item/item in loc)
		if(item.anchored)
			continue
		if(prob(70))
			item.throw_atom((get_step(loc,turn(from_dir,180))),1)

	animate(src, alpha= flooded_alpha, easing = BACK_EASING | EASE_OUT , time= 40)
	update_icon()
	var/turf/location = loc
	location.is_weedable = NOT_WEEDABLE


/obj/effect/blocker/water/toxic/disperse()
	.=..()
	toxic = -1

	update_turf()

	addtimer(CALLBACK(src, PROC_REF(do_disperse)), 1 SECONDS)

/obj/effect/blocker/water/toxic/proc/do_disperse()
	toxic = 0
	update_turf()
	dispersing = 0

/obj/structure/machinery/dispersal_initiator
	name = "\improper Dispersal Initiator"
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "spawn_shuttle_move"
	layer = ABOVE_FLY_LAYER - 0.1 //to make it visible in the map editor
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/id = null

/obj/structure/machinery/dispersal_initiator/floodgate
	id = "floodgate"

/obj/structure/machinery/dispersal_initiator/New()
	..()
	icon_state = null

/obj/structure/machinery/dispersal_initiator/proc/initiate(drain = FALSE)
	// Ported over ambience->ambience_exterior, was broken. Enable if you actually want it
	//var/area/A = get_area(src)
	//A.ambience_exterior = 'sound/ambience/ambiatm1.ogg'
	sleep(30)
	for(var/obj/effect/blocker/water/W in get_turf(src))
		W.disperse_spread(drain = drain)

/obj/structure/machinery/dispersal_initiator/ex_act()
	return


/obj/structure/machinery/filtration_button
	name = "\improper Filtration Activation"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "big_red_button_wallv"
	desc = "Activates the filtration mechanism."
	var/id = null
	var/active = 0
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/filtration_button/floodgate
	id = "floodgate"

/obj/structure/machinery/filtration_button/floodgate/power_change(area/master_area)
	. = ..()
	if(!inoperable())
		return

	drain()

/obj/structure/machinery/filtration_button/floodgate/proc/drain()
	for(var/obj/structure/machinery/dispersal_initiator/M in GLOB.machines)
		if (M.id == src.id)
			M.initiate(drain = TRUE)

/obj/structure/machinery/filtration_button/attack_hand(mob/user as mob)

	if(inoperable())
		return
	if(active)
		return

	use_power(5)

	active = 1
	icon_state = "big_red_button_wallv1"

	// Ported over ambience->ambience_exterior, was broken. Enable if you actually want it
	//var/area/A = get_area(src)
	//A.ambience_exterior = 'sound/ambience/ambiatm1.ogg'

	for(var/obj/structure/machinery/dispersal_initiator/M in GLOB.machines)
		if (M.id == src.id)
			M.initiate()

	marine_announcement("Alert: Tyrargo sewer release valve triggered: Imminent flooding of sewer lines.")
	xeno_announcement("The hosts have triggered the release of a flood of water in to the sewers underneath this battleground. Be wary of the loss our ability to weed the sewer tunnels.")

	sleep(50)

	icon_state = "big_red_button_wallv-p"
	active = 0

	return

/obj/structure/machinery/filtration_button/ex_act()
	return

/*
/obj/effect/blocker/water/toxic/connector
	icon_state = null

//something to stop this stuff from killing people

/obj/effect/blocker/water/toxic/connector/disperse()
	return
*/
