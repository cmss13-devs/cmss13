// ###############################################################################
// # ITEM: FRACTAL ENERGY REACTOR #
// # FUNCTION: Generate infinite electricity. Used for map testing.   #
// ###############################################################################

/obj/structure/machinery/power/fractal_reactor
	name = "Fractal Energy Reactor"
	desc = "This thing drains power from fractal-subspace. (DEBUG ITEM: INFINITE POWERSOURCE FOR MAP TESTING. CONTACT DEVELOPERS IF FOUND.)"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "bbox_on"
	anchored = TRUE
	density = TRUE
	directwired = 1
	var/power_generation_rate = 2000000 //Defaults to 2MW of power. Should be enough to run SMES charging on full 2 times.
	var/powernet_connection_failed = 0
	power_machine = TRUE

	// This should be only used on Dev for testing purposes.
/obj/structure/machinery/power/fractal_reactor/New()
	..()
	to_world("<b>\red WARNING: \black Map testing power source activated at: X:[src.loc.x] Y:[src.loc.y] Z:[src.loc.z]</b>")
	start_processing()

/obj/structure/machinery/power/fractal_reactor/power_change()
	return

/obj/structure/machinery/power/fractal_reactor/process()
	if(!powernet && !powernet_connection_failed)
		if(!connect_to_network())
			powernet_connection_failed = 1
			spawn(150) // Error! Check again in 15 seconds.
				powernet_connection_failed = 0
	add_avail(power_generation_rate)
