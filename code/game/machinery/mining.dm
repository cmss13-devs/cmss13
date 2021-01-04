/obj/structure/machinery/mineral/input
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "x2"
	name = "Input area"
	density = 0
	anchored = 1.0

/obj/structure/machinery/mineral/input/Initialize(mapload, ...)
	. = ..()
	icon_state = "blank"

/obj/structure/machinery/mineral/output
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "x"
	name = "Output area"
	density = 0
	anchored = 1.0

/obj/structure/machinery/mineral/output/Initialize(mapload, ...)
	. = ..()
	icon_state = "blank"

/obj/structure/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/structures/machinery/mining_machines.dmi'
	icon_state = "furnace"
	density = 1
	anchored = 1
	luminosity = 3
