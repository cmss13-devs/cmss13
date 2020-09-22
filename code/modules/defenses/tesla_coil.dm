#define TESLA_COIL_FIREDELAY 	20
#define TESLA_COIL_RANGE 		3
#define TESLA_COIL_DAZE_EFFECT 		5
#define TESLA_COIL_SLOW_EFFECT 		3

/obj/structure/machinery/defenses/tesla_coil
	name = "\improper 21S tesla coil"
	desc = "A perfected way of producing high-voltage, low-current and high frquency electricity. Minor modifications allow it to only hit hostile targets with a devastating shock."
	var/list/targets
	var/last_fired = 0
	handheld_type = /obj/item/defenses/handheld/tesla_coil
	disassemble_time = 10
	health = 150
	health_max = 150

/obj/structure/machinery/defenses/tesla_coil/Initialize()
	. = ..()

	if(turned_on)
		start_processing()
	update_icon()

/obj/structure/machinery/defenses/tesla_coil/update_icon()
	..()

	overlays.Cut()
	if(stat == DEFENSE_DAMAGED)
		var/image/I = image('icons/obj/structures/machinery/defenses.dmi', icon_state = "tesla_coil_destroyed")
		I.pixel_y = 3
		overlays += I
		return

	if(turned_on)
		var/image/I = image('icons/obj/structures/machinery/defenses.dmi', icon_state = "tesla_coil_on")
		I.pixel_y = 3
		overlays += I
	else
		var/image/I = image('icons/obj/structures/machinery/defenses.dmi', icon_state = "tesla_coil")
		I.pixel_y = 3
		overlays += I

/obj/structure/machinery/defenses/tesla_coil/power_on_action()
	SetLuminosity(7)
	start_processing()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] gives a short zap, as it awakens.")]")

/obj/structure/machinery/defenses/tesla_coil/power_off_action()
	SetLuminosity(0)
	stop_processing()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_NOTICE("The [name] dies out with a last spark.")]")

/obj/structure/machinery/defenses/tesla_coil/process()
	if(!anchored || !turned_on || stat)
		return

	get_target()
	if(!isnull(targets))
		fire(targets)
	return

/obj/structure/machinery/defenses/tesla_coil/proc/get_target()
	targets = list()

	for(var/mob/living/M in oview(TESLA_COIL_RANGE, src))
		if(M.stat & DEAD || isrobot(M)) 
			continue

		var/mob/living/carbon/human/H = M
		if(istype(H) && H.get_target_lock(faction_group)) 
			continue

		targets += M
	
	for(var/obj/structure/machinery/defenses/D in oview(TESLA_COIL_RANGE, src))
		if(D.turned_on)
			targets += D

/obj/structure/machinery/defenses/tesla_coil/proc/fire(var/atoms)
	if(!(world.time - last_fired >= TESLA_COIL_FIREDELAY) || !turned_on)
		return

	last_fired = world.time

	if(QDELETED(owner_mob))
		owner_mob = src

	for(var/A in atoms)
		if(isliving(A))
			var/mob/living/M = A
			if(!check_path(M))
				continue
			M.Daze(TESLA_COIL_DAZE_EFFECT)
			M.Superslow(TESLA_COIL_SLOW_EFFECT)
		else if(istype(A, /obj/structure/machinery/defenses))
			var/obj/structure/machinery/defenses/D = A
			D.power_off()

		var/datum/effect_system/spark_spread/S = new()
		S.set_up(5, 0, A)
		S.attach(A)
		S.start()
		qdel(S)

		Beam(A, "electric", 'icons/effects/beam.dmi', 5, 5)

	targets = null

/obj/structure/machinery/defenses/tesla_coil/proc/check_path(var/mob/living/M)
	if(!istype(M))
		return FALSE

	var/list/turf/path = getline2(src, M, include_from_atom = FALSE)

	var/blocked = FALSE
	for(var/turf/T in path)
		if(T.density || T.opacity)
			blocked = TRUE
			break

		for(var/obj/structure/S in T)
			if(S.opacity)
				blocked = TRUE
				break

		for(var/obj/effect/particle_effect/smoke/S in T)
			blocked = TRUE
			break

	if(blocked)
		return FALSE

	return TRUE

/obj/structure/machinery/defenses/tesla_coil/Dispose() //Clear these for safety's sake.
	if(targets)
		targets = null

	SetLuminosity(0)
	. = ..()


#undef TESLA_COIL_FIREDELAY
#undef TESLA_COIL_RANGE
