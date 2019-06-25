//Basically a one way passive valve. If the pressure inside is greater than the environment then gas will flow passively,
//but it does not permit gas to flow back from the environment into the injector. Can be turned off to prevent any gas flow.
//When it receives the "inject" signal, it will try to pump it's entire contents into the environment regardless of pressure, using power.

/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'icons/atmos/injector.dmi'
	icon_state = "map_injector"
	use_power = 1
	layer = OBJ_LAYER

	name = "air injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."

	var/on = 0
	var/injecting = 0

	var/id = null
	level = 1

/obj/machinery/atmospherics/unary/outlet_injector/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[on ? "on" : "off"]"

/obj/machinery/atmospherics/unary/outlet_injector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir)

/obj/machinery/atmospherics/unary/outlet_injector/hide(var/i)
	update_underlays()