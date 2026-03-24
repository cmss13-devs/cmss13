// Not really needed since wires got nuked, but it's here mostly cosmetically but SMES, APC still need to have one to function

/obj/structure/terminal
	name = "terminal"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "term"
	desc = "It's an underfloor wiring terminal for power equipment."
	level = 1
	var/obj/structure/machinery/power/master = null
	anchored = TRUE
	layer = WIRE_TERMINAL_LAYER
	unacidable = TRUE //so xenos can't melt visible SMES terminals on the planet to break the SMES


/obj/structure/terminal/Initialize()
	. = ..()
	var/turf/T = src.loc
	if(level==1)
		hide(T.intact_tile)

/obj/structure/terminal/Destroy()
	. = ..()
	if(!master)
		return

	master.terminal = null
	master = null

/obj/structure/terminal/hide(i)
	if(i)
		invisibility = 101
		icon_state = "term-f"
	else
		invisibility = 0
		icon_state = "term"
