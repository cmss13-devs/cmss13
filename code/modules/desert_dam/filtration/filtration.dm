/obj/structure/machinery/filtration_button
	name = "\improper Filtration Activation"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "big_red_button_wallv"
	desc = "Activates the filtration mechanism."
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	var/id = null
	var/active = FALSE

/obj/structure/machinery/filtration_button/floodgate
	id = "floodgate"

/obj/structure/machinery/filtration_button/floodgate/power_change(area/master_area)
	. = ..()
	if(!inoperable())
		return

	drain() // the floodgate closes again

/obj/structure/machinery/filtration_button/floodgate/proc/drain()
	sleep(3 SECONDS)
	for(var/obj/effect/landmark/dispersal_initiator/M in GLOB.dispersal_initiators_by_id[src.id])
		M.initiate_drain()

// This stub exists so that the Tyrargo floodgate can do an announcement when activated.
/obj/structure/machinery/filtration_button/proc/do_activation_announcements()
	return

/obj/structure/machinery/filtration_button/floodgate/do_activation_announcements()
	marine_announcement("Alert: Tyrargo sewer release valve triggered: Imminent flooding of sewer lines.")
	xeno_announcement("The hosts have triggered the release of a flood of water in to the sewers underneath this battleground. Be wary of the loss of our ability to weed the sewer tunnels.")

/obj/structure/machinery/filtration_button/attack_hand(mob/user as mob)

	if(inoperable())
		return
	if(active)
		return

	use_power(5)

	active = TRUE
	icon_state = "big_red_button_wallv1"

	// Ported over ambience->ambience_exterior, was broken. Enable if you actually want it
	//var/area/A = get_area(src)
	//A.ambience_exterior = 'sound/ambience/ambiatm1.ogg'

	sleep(3 SECONDS) // we don't want to sleep once per initiator, we want to sleep once overall
	// this could also be a spawn inside initiate_dispersal i guess
	for(var/obj/effect/landmark/dispersal_initiator/M in GLOB.dispersal_initiators_by_id[src.id])
		M.initiate_dispersal()

	do_activation_announcements()

	sleep(5 SECONDS)

	icon_state = "big_red_button_wallv-p"
	active = FALSE

	return
