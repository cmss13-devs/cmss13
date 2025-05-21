/obj/structure/pipes/standard/simple/visible/universal
	name = "Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	icon_state = "map_universal"

/obj/structure/pipes/standard/simple/visible/universal/update_icon(safety = 0)
	if(!check_icon_cache())
		return
	alpha = 255

	overlays.Cut()
	underlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")

	universal_underlays(dir)
	universal_underlays(turn(dir, 180))

/obj/structure/pipes/standard/simple/hidden/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	icon_state = "map_universal"

/obj/structure/pipes/standard/simple/hidden/universal/update_icon(safety = 0)
	if(!check_icon_cache())
		return
	alpha = 255

	overlays.Cut()
	underlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "universal")

	universal_underlays(dir)
	universal_underlays(turn(dir, -180))

/obj/structure/pipes/proc/universal_underlays(direction)
	var/turf/T = loc
	add_underlay_adapter(T, direction)
	add_underlay_adapter(T, direction)
	add_underlay_adapter(T, direction)

/obj/structure/pipes/proc/add_underlay_adapter(turf/T, direction) //modified from add_underlay, does not make exposed underlays
	if(T.intact_tile && level == 1)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "down")
	else
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(src), "intact")


/obj/structure/pipes/standard/cap
	name = "pipe endcap"
	desc = "An endcap for pipes."
	icon = 'icons/obj/pipes/pipes3.dmi'
	icon_state = ""
	level = 2
	dir = SOUTH
	valid_directions = list(SOUTH)

/obj/structure/pipes/standard/cap/create_valid_directions()
	valid_directions = list(dir)

/obj/structure/pipes/standard/cap/update_icon(safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_manager.get_atmos_icon("pipe", , pipe_color, "cap")

/obj/structure/pipes/standard/cap/visible
	level = 2
	icon_state = "cap"

/obj/structure/pipes/standard/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes."
	icon_state = "cap-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes."
	icon_state = "cap-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/cap/hidden
	icon_state = "cap"
	alpha = 128

/obj/structure/pipes/standard/cap/hidden/update_icon()
	level = 1

	. = ..()

/obj/structure/pipes/standard/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes."
	icon_state = "cap-f-scrubbers"
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/pipes/standard/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes."
	icon_state = "cap-f-supply"
	layer = ATMOS_PIPE_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/pipes/standard/cap/hidden/supply/no_boom
	name = "reinforced supply pipe endcap"
	explodey = FALSE
	color = PIPE_COLOR_PURPLE


/obj/structure/pipes/standard/tank
	icon = 'icons/obj/pipes/tank.dmi'
	icon_state = "air_map"
	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."
	dir = SOUTH
	valid_directions = list(SOUTH)
	density = TRUE
	layer = OBJ_LAYER
	var/actual_icon_state = "air"

/obj/structure/pipes/standard/tank/New()
	icon_state = actual_icon_state
	valid_directions = list(dir)
	..()

/obj/structure/pipes/standard/tank/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, dir)

/obj/structure/pipes/standard/tank/hide()
	update_underlays()

/obj/structure/pipes/standard/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air_map"
	actual_icon_state = "air"

/obj/structure/pipes/standard/tank/oxygen
	name = "Pressure Tank (Oxygen)"
	icon_state = "o2_map"
	actual_icon_state = "o2"

/obj/structure/pipes/standard/tank/nitrogen
	name = "Pressure Tank (Nitrogen)"
	icon_state = "n2_map"
	actual_icon_state = "n2_map"

/obj/structure/pipes/standard/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2_map"
	actual_icon_state = "co2"

/obj/structure/pipes/standard/tank/phoron
	name = "Pressure Tank (Phoron)"
	icon_state = "phoron_map"
	actual_icon_state = "phoron"

/obj/structure/pipes/standard/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o_map"
	actual_icon_state = "n2o"
