/*
*       Backend for CORSAT (and potential other, future teleporters)
*/



// Teleporter landmarks
// How these work:
// Loaded into lists by location_id when the landmark SS calls them
/obj/effect/landmark/teleporter_loc
    desc = "The reference landmark for teleporters"
    icon = 'icons/old_stuff/mark.dmi'
    icon_state = "spawn_shuttle"

    var/location_id       // Which location this is
    var/index             // just that, which index in the location list this gets loaded into
    var/linked_teleporter // Which teleporter to load this marker into (hardcode this by teleporter ID)

// Put us into the glob list handled by the landmarks SS
/obj/effect/landmark/teleporter_loc/New()
    set waitfor = 0
    teleporter_landmarks += src
    ..()

/obj/effect/landmark/teleporter_loc/Destroy()
	teleporter_landmarks -= src
	. = ..()

// Index matrix:
// 1  2  3 ...
// 5  6  7 ...
// 10 11 12 ...
// 15 16 ...
// 20 21 ...

// Find our teleporter datum from the glob list, then load us into the appropriate location list based on our hardcoded location_id and index
// List ends up looking like this:
// teleporter
// \ locations
//   \ "location_id" -> /list/turf(area_size)
/obj/effect/landmark/teleporter_loc/proc/initialize_marker()
    var/datum/subsystem/teleporter/teleporterSS = teleporter_ss

    if (teleporterSS)
        var/datum/teleporter/T = teleporterSS.teleporters_by_id[linked_teleporter]
        if (T)
            if (!T.locations[location_id])
                T.locations[location_id] = list()

            var/list/location = T.locations[location_id]

            if (!location)
                log_debug("Teleporter locations turf list not properly instantiated. Code: TELEPORTER_LANDMARK_1")
                log_admin("Teleporter locations turf list not properly instantiated. Tell the devs. Code: TELEPORTER_LANDMARK_1")
                qdel(src)
                return

            location[index] = get_turf(src)

        else
            log_debug("Couldn't find teleporter matching ID [linked_teleporter]. Code: TELEPORTER_LANDMARK_2")
            log_admin("Couldn't find teleporter matching ID [linked_teleporter]. Tell the devs. Code: TELEPORTER_LANDMARK_2")
            qdel(src)
            return
    else
        log_debug("Couldn't find teleporter SS to register with. Code: TELEPORTER_LANDMARK_3")
        log_admin("Couldn't find teleporter SS to register with. Tell the devs. Code: TELEPORTER_LANDMARK_3")
        qdel(src)
        return

    qdel(src)

/obj/effect/landmark/teleporter_loc/corsat_sigma_local
    location_id = "Sigma Local"
    linked_teleporter = "Corsat_Teleporter"

/obj/effect/landmark/teleporter_loc/corsat_sigma_remote
    location_id = "Sigma Remote"
    linked_teleporter = "Corsat_Teleporter"