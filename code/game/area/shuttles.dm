/area/shuttle
	name = "Shuttle"
	requires_power = FALSE
	unlimited_power = TRUE
	always_unpowered = FALSE
	icon_state = "shuttle"
	ceiling_muffle = TRUE

	// Loading the same shuttle map at a different time will produce distinct area instances.
	unique = FALSE

	base_lighting_alpha = 255


///area/shuttle/Initialize()
// if(!canSmoothWithAreas)
// canSmoothWithAreas = type
// . = ..()

/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

// Dynamic sound handling for the shuttles
/area/shuttle/get_sound_ambience(client/target)
	// Get the actual shuttle instance
	var/obj/docking_port/mobile/shuttle = SSshuttle.get_containing_shuttle(target.mob)
	if(!shuttle)
		return ambience_exterior
	// Pass it on
	return shuttle.get_sound_ambience()

//========== Single-area shuttles ============//

/area/shuttle/transit
	name = "Hyperspace"
	desc = "Weeeeee"
	ambience_exterior = 'sound/ambience/shuttle_fly_loop.ogg'
	base_lighting_alpha = 255

/area/shuttle/vehicle_elevator
	name = "Vehicle ASRS"

/area/shuttle/ert
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"

/area/shuttle/trijent_shuttle
	name = "Trijent Elevator"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"

/area/shuttle/trijent_shuttle/elevator
	requires_power = TRUE
	unlimited_power = FALSE
	powernet_name = "ground"

/area/shuttle/trijent_shuttle/lz1
	name = "Trijent LZ1"

/area/shuttle/trijent_shuttle/lz2
	name = "Trijent LZ2"

/area/shuttle/trijent_shuttle/engi
	name = "Trijent Engineering"

/area/shuttle/trijent_shuttle/omega
	name = "Trijent Omega"

/area/shuttle/escape_pod
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"

/area/shuttle/escape_pod/afterShuttleMove(new_parallax_dir)
	. = ..()
	playsound_area(src, 'sound/effects/escape_pod_launch.ogg', 50, 1)

/area/shuttle/lifeboat
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"
	flags_area = AREA_NOTUNNEL
