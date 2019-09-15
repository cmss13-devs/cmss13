/obj/structure/machinery/atmospherics/unary/oxygen_generator
	icon = 'icons/obj/pipes/oxygen_generator.dmi'
	icon_state = "intact_off"
	density = 1
	name = "Oxygen Generator"
	desc = ""
	dir = SOUTH
	initialize_directions = SOUTH
	var/on = 0
	var/oxygen_content = 10

/obj/structure/machinery/atmospherics/unary/oxygen_generator/update_icon()
	if(node)
		icon_state = "intact_[on?("on"):("off")]"
	else
		icon_state = "exposed_off"
		on = 0

/obj/structure/machinery/atmospherics/unary/oxygen_generator/process()
	..()
	if(!on)
		return 0

	return 1