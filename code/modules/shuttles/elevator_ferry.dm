/* QUICK INHERITANCE THING FOR ELEVATORS
	NOTE: Elevators do NOT use the above system, they inherit from /datum/shuttle/ferry not /datum/shuttle/ferry/marine */

/datum/shuttle/ferry/elevator
	var/list/controls = list() //Used to announce failure
	var/list/main_doors = list() //Used to check failure
	var/fail_flavortext = "Could not move the elevator due to blockage in the main door."

/datum/shuttle/ferry/elevator/New()
	..()
	for(var/obj/structure/machinery/M in get_location_area(location))
		if(istype(M, /obj/structure/machinery/computer/shuttle_control))
			controls += M
		else if(istype(M, /obj/structure/machinery/door/airlock/multi_tile/elevator))
			main_doors += M

//Kinda messy proc, but the best solution to prevent shearing of multitile vehicles
//Alternatives include:
//1. A ticker that verifies that all multi_tile vics aren't out of wack
// -Two problems here, intersection of movement and verication would cause issues and this idea is dumb and expensive
//2. Somewhere in the shuttle_backend, every time you move a multi_tile vic hitbox or root, tell the vic to update when the move completes
// -Issues here are that this is not atomic at all and vics get left behind unless the entirety of them is on the shuttle/elevator,
// plus then part of the vic would be in space since elevators leave that behind
/datum/shuttle/ferry/elevator/preflight_checks()
	for(var/obj/structure/machinery/door/airlock/multi_tile/elevator/E in main_doors)
		//If there is part of a multitile vic in any of the turfs the door occupies, cancel
		//An argument can be made for tanks being allowed to block the door, but
		// that would make this already relatively expensive and inefficent even more so
		// --MadSnailDisease
		for(var/obj/vehicle/multitile/M in E.loc)
			if(M)
				return 0

		for(var/turf/T in E.locs) //For some reason elevators use different multidoor code, this should work though
			for(var/obj/vehicle/multitile/M in T)
				if(M)
					return 0

		//No return 1 here in case future elevators have multiple multi_tile doors

	return 1

/datum/shuttle/ferry/elevator/announce_preflight_failure()
	for(var/obj/structure/machinery/computer/shuttle_control/control in controls)
		playsound(control, 'sound/effects/adminhelp-error.ogg', 20) //Arbitrary notification sound
		control.visible_message(SPAN_WARNING(fail_flavortext))
		return //Kill it so as not to repeat
