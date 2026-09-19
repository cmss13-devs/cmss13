/obj/faux_turf
	density = FALSE
	opacity = FALSE
	flags_atom = NO_ZFALL
	unacidable = TRUE
	explo_proof = TRUE
	anchored = TRUE

/obj/faux_turf/open
	opacity = FALSE
	density = FALSE

/obj/faux_turf/closed
	opacity = TRUE
	density = TRUE

/obj/faux_turf/open/dropship

GLOBAL_LIST_EMPTY(omaha_roof_fauxes)
GLOBAL_LIST_EMPTY(midway_roof_fauxes)

/obj/faux_turf/open/dropship/roof
	name = "\improper Dropship Roof"
	icon = 'icons/turf/midway/roof_split.dmi'
	icon_state = "0,0"
	layer = TURF_LAYER + 0.01
	var/post_init_icon_state = "fuck_you"
	var/obj/deployer/shuttle/dropship/roof_loader/linked_loader
	var/recorded_offset_X
	var/recorded_offset_Y

/obj/faux_turf/open/dropship/roof/solid
	icon_state = "8,3"

/obj/faux_turf/open/dropship/roof/solid/omaha
	icon = 'icons/turf/omaha/roof_split.dmi'

/obj/faux_turf/open/dropship/roof/solid/omaha/Initialize()
	. = ..()
	GLOB.omaha_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/solid/midway
	icon = 'icons/turf/midway/roof_split.dmi'

/obj/faux_turf/open/dropship/roof/solid/midway/Initialize()
	. = ..()
	GLOB.midway_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/edge // placed in problematic places where we dont rly want to make an transparent turf if there's a non-transparent there alr
	icon_state = "8,1"

/obj/faux_turf/open/dropship/roof/edge/omaha

/obj/faux_turf/open/dropship/roof/edge/omaha/Initialize()
	. = ..()
	GLOB.omaha_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/edge/midway

/obj/faux_turf/open/dropship/roof/edge/midway/Initialize()
	. = ..()
	GLOB.midway_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/canopy
	icon_state = "8,22"

/obj/faux_turf/open/dropship/roof/canopy/omaha

/obj/faux_turf/open/dropship/roof/canopy/omaha/Initialize()
	. = ..()
	GLOB.omaha_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/canopy/midway

/obj/faux_turf/open/dropship/roof/canopy/midway/Initialize()
	. = ..()
	GLOB.midway_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/canopy_edge
	icon_state = "8,19"

/obj/faux_turf/open/dropship/roof/canopy_edge/omaha

/obj/faux_turf/open/dropship/roof/canopy_edge/omaha/Initialize()
	. = ..()
	GLOB.omaha_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/canopy_edge/midway

/obj/faux_turf/open/dropship/roof/canopy_edge/midway/Initialize()
	. = ..()
	GLOB.midway_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/empty_space // used so i dont have to bother with offsets and proper icon assignment n shit
	icon_state = "1,1"

/obj/faux_turf/open/dropship/roof/empty_space/omaha/Initialize()
	. = ..()
	GLOB.omaha_roof_fauxes += src

/obj/faux_turf/open/dropship/roof/empty_space/midway/Initialize()
	. = ..()
	GLOB.midway_roof_fauxes += src
