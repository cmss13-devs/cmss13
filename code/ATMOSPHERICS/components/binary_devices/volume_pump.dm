/obj/machinery/atmospherics/binary/pump/high_power
	icon = 'icons/obj/pipes/volume_pump.dmi'
	icon_state = "map_off"
	level = 1

	name = "high power gas pump"
	desc = "A pump. Has double the power rating of the standard gas pump."

/obj/machinery/atmospherics/binary/pump/high_power/on
	on = 1
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[on ? "on" : "off"]"