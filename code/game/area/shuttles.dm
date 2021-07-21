
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Shuttle"
	requires_power = FALSE
//	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	always_unpowered = FALSE
//	valid_territory = FALSE
	icon_state = "shuttle"
	// Loading the same shuttle map at a different time will produce distinct area instances.
	unique = FALSE

///area/shuttle/Initialize()
//	if(!canSmoothWithAreas)
//		canSmoothWithAreas = type
//	. = ..()

/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

////////////////////////////Single-area shuttles////////////////////////////

/area/shuttle/transit
	name = "Hyperspace"
	desc = "Weeeeee"

/area/shuttle/vehicle_elevator
	name = "Vehicle ASRS"
