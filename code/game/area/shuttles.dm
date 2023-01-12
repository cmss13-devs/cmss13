/area/shuttle
	name = "Shuttle"
	requires_power = FALSE
	always_unpowered = FALSE
	icon_state = "shuttle"
	ceiling_muffle = TRUE

	// Loading the same shuttle map at a different time will produce distinct area instances.
	unique = FALSE
	lighting_use_dynamic = FALSE


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

/area/shuttle/vehicle_elevator
	name = "Vehicle ASRS"

/area/shuttle/ert
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"

/area/shuttle/lifeboat
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"
	flags_atom = AREA_NOTUNNEL
