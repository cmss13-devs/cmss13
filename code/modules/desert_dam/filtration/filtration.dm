/*
obj/effect/landmark/desertdam
	icon = 'icons/misc/mark.dmi'
obj/effect/landmark/desertdam/river_blocker
	name = "toxic river blocker"
	icon_state = "spawn_event"

/obj/effect/blocker/fog
	name = "dense fog"
	desc = "It looks way too dangerous to traverse. Best wait until it has cleared up."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = 1
	density = 1
	//opacity = 1
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


var/global/riverend_west = 0
var/global/riverend_north = 0
var/global/river_central = 0
var/global/cannal = 0
var/global/dam_underpass = 0
var/global/south_river = 0
var/global/south_filtration = 0
var/global/east_river = 0
var/global/east_filtration = 0
var/global/south_riverstart = 0
var/global/east_riverstart = 0

/proc/filtration_check()
	if(east_filtration)

*/

/obj/effect/blocker/toxic_water
	anchored = 1
	density = 0
	opacity = 0
	unacidable = TRUE
	layer = ABOVE_FLY_LAYER //to make it visible in the map editor
	mouse_opacity = 0
	icon = 'icons/old_stuff/mark.dmi'

	var/dispersing = 0
	var/toxic = 1
	var/disperse_group
	var/spread_delay = 5

	icon_state = "spawn_shuttle"

/obj/effect/blocker/toxic_water/Group_1
	disperse_group = 1
	icon_state = "spawn_event"

/obj/effect/blocker/toxic_water/Group_1/delay
	spread_delay = 100
	icon_state = "spawn_shuttle_dock"

/obj/effect/blocker/toxic_water/Group_2
	disperse_group = 2
	icon_state = "spawn_goal"

/obj/effect/blocker/toxic_water/Group_2/delay
	spread_delay = 100
	icon_state = "spawn_shuttle_dock"


/obj/effect/blocker/toxic_water/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/blocker/toxic_water/LateInitialize()
	. = ..()
	update_turf()
	icon_state = null


/obj/effect/blocker/toxic_water/proc/update_turf()
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



/obj/effect/blocker/toxic_water/Crossed(mob/living/M as mob)
	if(toxic == 0)
		return

	if(!istype(M))
		return

	// Inside a xeno for example
	if(!istype(M.loc, /turf))
		return

	if(istype(src.loc, /turf/open/gm/river/desert))
		var/turf/open/gm/river/desert/R = src.loc
		if(R.covered)
			return
	else
		return

	for(var/turf/open/floor/F in range(0, src))
		return

	if(isXeno(M))
		if(M.pulling)
			to_chat(M, SPAN_WARNING("The current forces you to release [M.pulling]!"))
			M.stop_pulling()

	cause_damage(M)
	START_PROCESSING(SSobj, src)


/obj/effect/blocker/toxic_water/process()

	if(!toxic)
		STOP_PROCESSING(SSobj, src)
		return

	if(istype(src.loc, /turf/open/gm/river/desert))
		var/turf/open/gm/river/desert/R = src.loc
		if(R.covered)
			return
	else
		return

	var/mobs_present = 0
	for(var/mob/living/carbon/M in range(0, src))
		mobs_present++
		cause_damage(M)
	if(mobs_present < 1)
		STOP_PROCESSING(SSobj, src)


/obj/effect/blocker/toxic_water/proc/cause_damage(mob/living/M)
	if(M.stat == DEAD)
		return
	if(isXeno(M))
		M.apply_damage(34,BURN)
	else if(isYautja(M))
		M.apply_damage(0.5,BURN)
	else
		var/dam_amount = 3
		if(istype(M,/mob/living/carbon/human/synthetic_old)) dam_amount = 0.5
		else if(istype(M,/mob/living/carbon/human/synthetic) || istype(M,/mob/living/carbon/human/synthetic_2nd_gen)) dam_amount = 1
		if(M.lying)
			M.apply_damage(dam_amount,BURN)
			M.apply_damage(dam_amount,BURN)
			M.apply_damage(dam_amount,BURN)
			M.apply_damage(dam_amount,BURN)
			M.apply_damage(dam_amount,BURN)
		else
			M.apply_damage(dam_amount,BURN,"l_leg")
			M.apply_damage(dam_amount,BURN,"l_foot")
			M.apply_damage(dam_amount,BURN,"r_leg")
			M.apply_damage(dam_amount,BURN,"r_foot")
			M.apply_damage(dam_amount,BURN,"groin")
		M.apply_effect(20,IRRADIATE,0)
		if( !isSynth(M) ) to_chat(M, SPAN_DANGER("The water burns!"))
	playsound(M, 'sound/bullets/acid_impact1.ogg', 10, 1)


/obj/effect/blocker/toxic_water/proc/disperse_spread(var/from_dir = 0)
	if(dispersing || !toxic)
		return

	for(var/direction in alldirs)
		if(direction == from_dir) continue //doesn't check backwards

		var/effective_spread_delay
		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				effective_spread_delay = spread_delay
			else
				effective_spread_delay = spread_delay * 1.414 //diagonal spreading takes longer

		for(var/obj/effect/blocker/toxic_water/W in get_step(src,direction) )
			if(W.disperse_group == src.disperse_group)
				spawn(effective_spread_delay)
					W.disperse_spread(turn(direction,180))

	disperse()

/obj/effect/blocker/toxic_water/proc/disperse()
	dispersing = 1
	toxic = -1

	update_turf()

	addtimer(CALLBACK(src, .proc/do_disperse), 1 SECONDS)

/obj/effect/blocker/toxic_water/proc/do_disperse()
	toxic = 0
	update_turf()
	dispersing = 0

/obj/structure/machinery/dispersal_initiator
	name = "\improper Dispersal Initiator"
	icon = 'icons/old_stuff/mark.dmi'
	icon_state = "spawn_shuttle_move"
	layer = ABOVE_FLY_LAYER - 0.1 //to make it visible in the map editor
	mouse_opacity = 0
	var/id = null

/obj/structure/machinery/dispersal_initiator/New()
	..()
	icon_state = null

/obj/structure/machinery/dispersal_initiator/proc/initiate()
	// Ported over ambience->ambience_exterior, was broken. Enable if you actually want it
	//var/area/A = get_area(src)
	//A.ambience_exterior = 'sound/ambience/ambiatm1.ogg'
	sleep(30)
	for(var/obj/effect/blocker/toxic_water/W in get_turf(src))
		W.disperse_spread()

/obj/structure/machinery/dispersal_initiator/ex_act()
	return


/obj/structure/machinery/filtration_button
	name = "\improper Filtration Activation"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "Activates the filtration mechanism."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/filtration_button/attack_hand(mob/user as mob)

	if(inoperable())
		return
	if(active)
		return

	use_power(5)

	active = 1
	icon_state = "launcheract"

	// Ported over ambience->ambience_exterior, was broken. Enable if you actually want it
	//var/area/A = get_area(src)
	//A.ambience_exterior = 'sound/ambience/ambiatm1.ogg'

	for(var/obj/structure/machinery/dispersal_initiator/M in machines)
		if (M.id == src.id)
			M.initiate()

	sleep(50)

	icon_state = "launcherbtt"
	active = 0

	return

/obj/structure/machinery/filtration_button/ex_act()
	return

/*
/obj/effect/blocker/toxic_water/connector
	icon_state = "null"

//something to stop this stuff from killing people

/obj/effect/blocker/toxic_water/connector/disperse()
	return
*/
