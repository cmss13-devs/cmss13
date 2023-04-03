// It... uses a lot of power.  Everything under power is engineering stuff, at least.

/obj/structure/machinery/computer/gravity_control_computer
	name = "Gravity Generator Control"
	desc = "A computer to control a local gravity generator.  Qualified personnel only."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "airtunnel0e"
	anchored = TRUE
	density = TRUE
	var/obj/structure/machinery/gravity_generator = null


/obj/structure/machinery/gravity_generator
	name = "Gravitational Generator"
	desc = "A device which produces a gravaton field when set up."
	icon = 'icons/obj/structures/props/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 200
	active_power_usage = 1000
	var/on = 1
