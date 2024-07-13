/turf/open/floor/filtrationside
	name = "filtration"
	icon = 'icons/turf/floors/filtration.dmi'
	icon_state = "filtrationside"

/turf/open/floor/filtrationside/southwest
	dir = SOUTHWEST

/turf/open/floor/filtrationside/north
	dir = NORTH

/turf/open/floor/filtrationside/east
	dir = EAST

/turf/open/floor/filtrationside/northeast
	dir = NORTHEAST

/turf/open/floor/filtrationside/southeast
	dir = SOUTHEAST

/turf/open/floor/filtrationside/west
	dir = WEST

/turf/open/floor/filtrationside/northwest
	dir = NORTHWEST

/turf/open/floor/plating/catwalk/rusted
	icon = 'icons/turf/floors/filtration.dmi'
	icon_state = "grate"

/turf/open/floor/plating/catwalk/rusted/ex_act()
	return

/turf/open/floor/coagulation
	name = "coagulation"
	icon = 'icons/turf/floors/coagulation.dmi'

/turf/open/floor/coagulation/icon0_0
	icon_state = "0,0"

/turf/open/floor/coagulation/icon0_4
	icon_state = "0,4"

/turf/open/floor/coagulation/icon0_5
	icon_state = "0,5"

/turf/open/floor/coagulation/icon0_8
	icon_state = "0,8"

/turf/open/floor/coagulation/icon1_1
	icon_state = "1,1"

/turf/open/floor/coagulation/icon1_7
	icon_state = "1,7"

/turf/open/floor/coagulation/icon2_0
	icon_state = "2,0"

/turf/open/floor/coagulation/icon4_8
	icon_state = "4,8"

/turf/open/floor/coagulation/icon5_8
	icon_state = "5,8"

/turf/open/floor/coagulation/icon6_8
	icon_state = "6,8"

/turf/open/floor/coagulation/icon6_8_2
	icon_state = "6,8-2"

/turf/open/floor/coagulation/icon7_0
	icon_state = "7,0"

/turf/open/floor/coagulation/icon7_1
	icon_state = "7,1"

/turf/open/floor/coagulation/icon7_7
	icon_state = "7,7"

/turf/open/floor/coagulation/icon7_7_2
	icon_state = "7,7-2"

/turf/open/floor/coagulation/icon7_8
	icon_state = "7,8"

/turf/open/floor/coagulation/icon7_8_2
	icon_state = "7,8-2"

/turf/open/floor/coagulation/icon8_0
	icon_state = "8,0"

/turf/open/floor/coagulation/icon8_3
	icon_state = "8,3"

/turf/open/floor/coagulation/icon8_4
	icon_state = "8,4"

/turf/open/floor/coagulation/icon8_6
	icon_state = "8,6"

/turf/open/floor/coagulation/icon8_7
	icon_state = "8,7"

/turf/open/floor/coagulation/icon8_7_2
	icon_state = "8,7-2"

/turf/open/floor/coagulation/icon8_8
	icon_state = "8,8"

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
	density = TRUE


/obj/structure/prop/almayer/anti_air_cannon
	name = "\improper Anti-air Cannon"
	desc = "An anti-air cannon for shooting spaceships. It looks broken."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "anti_air_cannon"
	density = TRUE
	anchored = TRUE
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
	density = FALSE
	anchored = TRUE
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
	density = TRUE
	anchored = TRUE
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
	density = TRUE
	anchored = TRUE
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
	density = TRUE
	anchored = TRUE
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
	density = TRUE
	anchored = TRUE
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
	density = TRUE
	icon = 'icons/obj/structures/props/coagulation_arm.dmi'
	icon_state = "arm"
	layer = ABOVE_MOB_LAYER + 0.1
	bound_width = 96
	bound_height = 96

/obj/structure/filtration/flacculation_arm
	name = "flocculation arm"
	desc = "A long metal filtering rod on an axel, made to spin for flocculation."
	density = TRUE
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

/obj/structure/filtration/machine_96x96
	icon = 'icons/obj/structures/props/96x96.dmi'

/obj/structure/filtration/machine_96x96/distribution
	name = "Waste Distribution System"
	desc = "This machine separates the leftover waste from the purification processes to be discarded into space, recycled for supplies, or used for research."
	icon_state = "distribution"

/obj/structure/filtration/machine_96x96/sedimentation
	name = "Sedimentation Filter"
	desc = "A water filter specifically designed to capture and remove sediment, such as sand, silt, dirt, and rust, from water without removing the nutritious minerals for that crisp, clean taste every time."
	icon_state = "sedimentation"

/obj/structure/filtration/machine_96x96/filtration
	name = "Water Filtration System"
	desc = "A water filter that separates both organic and inorganic matter, hazardous waste, and corrosive acids from water so it may be further processed."
	icon_state = "filtration"

/obj/structure/filtration/machine_96x96/disinfection
	name = "Disinfection Filter"
	desc = "A water filter specifically designed to separate micro-organisms, such as viruses and bacteria, from water."
	icon_state = "disinfection"
