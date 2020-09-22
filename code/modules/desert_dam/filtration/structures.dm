/turf/open/floor/filtrationside
	name = "filtration"
	icon = 'icons/turf/floors/filtration.dmi'
	icon_state = "filtrationside"

/turf/open/floor/plating/catwalk/rusted
	icon = 'icons/turf/floors/filtration.dmi'
	icon_state = "grate"

/turf/open/floor/plating/catwalk/rusted/ex_act()
	return

/turf/open/floor/coagulation
	name = "coagulation"
	icon = 'icons/turf/floors/coagulation.dmi'

/obj/structure/filtration/coagulation
	name = "coagulation"
	icon = 'icons/turf/floors/coagulation.dmi'



/obj/structure/filtration
	unslashable = TRUE
	unacidable = TRUE
/*
/obj/structure/filtration
	icon = 'icons/obj/filtration/96x96.dmi'
	bound_x = 96
	bound_y = 96
	density = 1


/obj/structure/prop/almayer/anti_air_cannon
	name = "\improper Anti-air Cannon"
	desc = "An anti-air cannon for shooting spaceships. It looks broken."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "anti_air_cannon"
	density = 1
	anchored = 1
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
*/
/obj/structure/filtration
	name = "filtration machine"

/obj/structure/filtration/machine_32x32
	icon = 'icons/turf/floors/32x32.dmi'
	name = "filtration catwalks"
	//bound_x = 96
	//bound_y = 96
	density = 0
	anchored = 1
	bound_width = 32
	bound_height = 32

/obj/structure/filtration/machine_32x32/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_32x32/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_32x64
	icon = 'icons/obj/structures/props/32x64.dmi'
	density = 1
	anchored = 1
	bound_width = 32
	bound_height = 64

/obj/structure/filtration/machine_32x64/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_32x64/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_96x96
	icon = 'icons/obj/structures/props/96x96.dmi'
	//bound_x = 96
	//bound_y = 96
	density = 1
	anchored = 1
	bound_width = 96
	bound_height = 96

/obj/structure/filtration/machine_96x96/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_96x96/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_64x96
	icon = 'icons/obj/structures/props/64x96.dmi'
	//bound_x = 96
	//bound_y = 96
	density = 1
	anchored = 1
	bound_width = 64
	bound_height = 96

/obj/structure/filtration/machine_64x96/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_64x96/indestructible/ex_act(severity)
	return

/obj/structure/filtration/machine_64x128
	icon = 'icons/obj/structures/props/64x128.dmi'
	//bound_x = 96
	//bound_y = 96
	density = 1
	anchored = 1
	bound_width = 64
	bound_height = 128

/obj/structure/filtration/machine_64x128/indestructible
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE

/obj/structure/filtration/machine_64x128/indestructible/ex_act(severity)
	return

/obj/structure/filtration/coagulation_arm
	name = "coagulation arm"
	desc = "An axel with four sides, made to spin to help filter the water."
	density = 1
	icon = 'icons/obj/structures/props/coagulation_arm.dmi'
	icon_state = "arm"
	layer = ABOVE_MOB_LAYER + 0.1
	bound_width = 96
	bound_height = 96

/obj/structure/filtration/flacculation_arm
	name = "flacculation arm"
	desc = "A long metal filtering rod on an axel, made to spin for flacculation."
	density = 1
	icon = 'icons/obj/structures/props/flacculation_arm.dmi'
	icon_state = "flacculation_arm"
	bound_height = 32
	bound_width = 128
	layer = ABOVE_MOB_LAYER + 0.1

/obj/structure/filtration/collector_pipes
	name = "collection pipes"
	desc = "A series of pipes collecting water from the river to take it to the plant for filtration."
	icon = 'icons/obj/structures/props/pipes.dmi'
	icon_state = "upper_1" //use instances to set the types.
	bound_height = 32
	bound_width = 64

/obj/structure/filtration/machine/distribution
	name = "Distribution"
	icon_state = "distribution"

/obj/structure/filtration/machine/sedementation
	name = "Sedementation"
	icon_state = "sedementation"

/obj/structure/filtration/machine/filtration
	name = "Filtration"
	icon_state = "filtration"

/obj/structure/filtration/machine/disinfection
	name = "Disinfection"
	icon_state = "disinfection"