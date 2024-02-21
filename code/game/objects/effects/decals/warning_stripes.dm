/obj/effect/decal/warning_stripes
	name = "warning stripes"
	gender = PLURAL
	icon = 'icons/effects/warning_stripes.dmi'
	layer = WEED_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/initial_icon_state

/obj/effect/decal/warning_stripes/Initialize(mapload, ...)
	. = ..()
	initial_icon_state = icon_state

/obj/effect/decal/warning_stripes/setDir(newdir)
	. = ..()
	switch(newdir)
		if(NORTH)
			icon_state = initial_icon_state
		if(SOUTH)
			switch(initial_icon_state)
				if("W")
					icon_state = "E"
				if("N")
					icon_state = "S"
				if("E")
					icon_state = "W"
				if("S")
					icon_state = "N"
				if("SE-out")
					icon_state = "NW-out"
				if("SW-out")
					icon_state = "NE-out"
				if("NW-out")
					icon_state = "SE-out"
				if("NE-out")
					icon_state = "SW-out"

		if(EAST)
			switch(initial_icon_state)
				if("W")
					icon_state = "N"
				if("N")
					icon_state = "E"
				if("E")
					icon_state = "S"
				if("S")
					icon_state = "W"
				if("SE-out")
					icon_state = "SW-out"
				if("SW-out")
					icon_state = "NW-out"
				if("NW-out")
					icon_state = "NE-out"
				if("NE-out")
					icon_state = "SE-out"
		if(WEST)
			switch(initial_icon_state)
				if("W")
					icon_state = "S"
				if("N")
					icon_state = "W"
				if("E")
					icon_state = "N"
				if("S")
					icon_state = "E"
				if("SE-out")
					icon_state = "NE-out"
				if("SW-out")
					icon_state = "SE-out"
				if("NW-out")
					icon_state = "SW-out"
				if("NE-out")
					icon_state = "NW-out"

/obj/effect/decal/warning_stripes/asteroid
	icon_state = "warning"


/obj/effect/decal/sand_overlay
	name = "sandy edge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE
	icon = 'icons/turf/overlays.dmi'
	layer = TURF_LAYER

/obj/effect/decal/sand_overlay/sand1
	icon_state = "sand1_s"
/obj/effect/decal/sand_overlay/sand1/corner1
	icon_state = "sand1_c"
/obj/effect/decal/sand_overlay/sand2
	icon_state = "sand2_s"
/obj/effect/decal/sand_overlay/sand2/corner2
	icon_state = "sand2_c"

/obj/effect/decal/grass_overlay
	name = "grass edge"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE
	icon = 'icons/turf/floors/auto_strata_grass.dmi'
	layer = TURF_LAYER

/obj/effect/decal/grass_overlay/grass1
	icon_state = "grass_outercorner"

/obj/effect/decal/grass_overlay/grass1/inner
	name = "grass edge"
	icon_state = "grass_innercorner"

/obj/effect/decal/siding
	name = "siding"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "siding1"

/obj/effect/decal/siding/wood_siding
	name = "wood siding"
	icon_state = "wood_siding1"




/// Hybrisa Decals

/obj/effect/hybrisa
	icon = 'icons/effects/64x64hybrisa_decals.dmi'
	icon_state = "weylandyutanilogo1"
	layer = TURF_LAYER
	plane = FLOOR_PLANE

//Roadlines

/obj/effect/hybrisa/decal/road
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_W1"
/obj/effect/hybrisa/decal/road/lines1
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_W1"
/obj/effect/hybrisa/decal/road/lines2
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_N2"
/obj/effect/hybrisa/decal/road/lines3
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_S3"
/obj/effect/hybrisa/decal/road/lines4
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_E4"
/obj/effect/hybrisa/decal/road/lines5
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_M1"
/obj/effect/hybrisa/decal/road/lines6
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_M2"
/obj/effect/hybrisa/decal/road/corner
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_corner"
/obj/effect/hybrisa/decal/road/roadmiddle
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "roadlinesmiddle"


// Dam Roadlines smaller
/obj/effect/hybrisa/decal/road/road_edge
	name = "road"
	icon_state = "road_edge_decal1"
/obj/effect/hybrisa/decal/road/road_stop
	name = "road"
	icon_state = "stop_decal1"

// Double Roadlines
/obj/effect/hybrisa/decal/doubleroad
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_W1"
/obj/effect/hybrisa/decal/doubleroad/lines1
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_W1"
/obj/effect/hybrisa/decal/doubleroad/lines2
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_N2"
/obj/effect/hybrisa/decal/doubleroad/lines3
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_S3"
/obj/effect/hybrisa/decal/doubleroad/lines4
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_E4"
/obj/effect/hybrisa/decal/doubleroad/lines5
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_M1"
/obj/effect/hybrisa/decal/doubleroad/lines6
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "ZD_M2"

//Gold lines
/obj/effect/hybrisa/decal/gold
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_S"
/obj/effect/hybrisa/decal/gold/line1
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_S"
/obj/effect/hybrisa/decal/gold/line2
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_E"
/obj/effect/hybrisa/decal/gold/line3
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_N"
/obj/effect/hybrisa/decal/gold/line4
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "Z_W"

// Red & White Warning Stripes

/obj/effect/hybrisa/decal/warning/redandwhite_SEcorner
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_SE-out"
/obj/effect/hybrisa/decal/warning/redandwhite_S
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_S"
/obj/effect/hybrisa/decal/warning/redandwhite_SWcorner
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_SW-out"
/obj/effect/hybrisa/decal/warning/redandwhite_E
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_E"
/obj/effect/hybrisa/decal/warning/redandwhite_W
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_W"
/obj/effect/hybrisa/decal/warning/redandwhite_NEcorner
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_NE-out"
/obj/effect/hybrisa/decal/warning/redandwhite_N
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_N"
/obj/effect/hybrisa/decal/warning/redandwhite_NWcorner
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "red_NW-out"


// Grate

/obj/effect/hybrisa/decal/grate
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/effects/hybrisa_decals.dmi'
	icon_state = "zhalfgrate1"

// 64x64 Decals

/obj/effect/hybrisa/decal/WY/WY1
	icon = 'icons/effects/64x64hybrisa_decals.dmi'
	icon_state = "weylandyutanilogo1"

/obj/effect/hybrisa/decal/WY/WYworn
	icon = 'icons/effects/64x64hybrisa_decals.dmi'
	icon_state = "weylandyutanilogo2"

/obj/effect/hybrisa/decal/roadcross
	icon = 'icons/effects/64x64hybrisa_decals.dmi'
	icon_state = "roadcross"
