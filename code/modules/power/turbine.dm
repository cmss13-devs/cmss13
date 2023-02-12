/obj/structure/machinery/compressor
	name = "compressor"
	desc = "The compressor stage of a gas turbine generator."
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = "compressor"
	anchored = TRUE
	density = TRUE
	var/obj/structure/machinery/power/turbine/turbine
	var/turf/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/comp_id = 0

/obj/structure/machinery/power/turbine
	name = "gas turbine generator"
	desc = "A gas turbine used for backup power generation."
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = "turbine"
	anchored = TRUE
	density = TRUE
	var/obj/structure/machinery/compressor/compressor
	directwired = 1
	var/turf/outturf
	var/lastgen

/obj/structure/machinery/computer/turbine_computer
	name = "Gas turbine control computer"
	desc = "A computer to remotely control a gas turbine"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "turbinecomp"
	circuit = /obj/item/circuitboard/computer/turbine_control
	anchored = TRUE
	density = TRUE
