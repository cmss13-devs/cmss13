/// Generic system for processing events after a certain time on multiple turfs, and
/// announcing them together.
/obj/effect/timed_event
	icon = 'icons/landmarks.dmi'
	icon_state = "o_red"

	var/static/list/notification_areas = list()

	/// How long to wait until the event should occur
	var/time

/obj/effect/timed_event/Initialize(mapload, ...)
	. = ..()

	icon = null

	if(isnull(time))
		log_mapping("[type] (x: [x], y: [y], z: [z]) was created without a time.")
		return INITIALIZE_HINT_QDEL

	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(handle_round_start)))

/obj/effect/timed_event/proc/handle_round_start()
	var/actual_time = time MINUTES

	if(!check_valid_type())
		return

	addtimer(generate_callback(), actual_time)

	if(notification_areas[type]?["[actual_time]"])
		LAZYORASSOCLIST(notification_areas[type], "[actual_time]", get_area(src))
		qdel(src)
	else
		addtimer(CALLBACK(src, PROC_REF(announce_event), actual_time), actual_time)
		LAZYORASSOCLIST(notification_areas[type], "[actual_time]", get_area(src))

/// Checks that the type this is acting on is valid, to prevent errors when adding the timer
/obj/effect/timed_event/proc/check_valid_type()
	return TRUE

/// To be overridden to generate the callback that should be inserted into the timer
/obj/effect/timed_event/proc/generate_callback()
	return

/// When the timer is completed, what global announcement of the event should occur
/obj/effect/timed_event/proc/announce_event(time_to_grab)
	return

/// Mapping helper placed on turfs to remove the turf after a specified duration.
/obj/effect/timed_event/scrapeaway
	icon_state = "o_blue"

/obj/effect/timed_event/scrapeaway/generate_callback()
	return CALLBACK(get_turf(src), TYPE_PROC_REF(/turf, ScrapeAway))

/obj/effect/timed_event/scrapeaway/announce_event(time_to_grab)
	var/announcement_areas = english_list(notification_areas[type]["[time_to_grab]"])

	var/marine_announcement_text = SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_IN_SPACE] \
		? "Structural collapse detected in [announcement_areas]. Be advised that new routes may be accessible." \
		: "Geological shifts detected in [announcement_areas]. Be advised that new routes may be accessible."

	marine_announcement(marine_announcement_text, "Priority Announcement")

	var/xeno_announcement_text = SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_IN_SPACE] \
		? "The shattered metal of this place has collapsed, providing new routes in [announcement_areas]." \
		: "The ground of this world trembles, and new routes are accessible in [announcement_areas]."

	xeno_announcement(SPAN_XENOANNOUNCE(xeno_announcement_text), "everything", XENO_GENERAL_ANNOUNCE)

	qdel(src)

/// Mapping helper placed on turfs that toggles the destructiblity of the turf after a specified duration.
/obj/effect/timed_event/destructible

/obj/effect/timed_event/destructible/check_valid_type()
	if(istype(get_turf(src), /turf/closed/wall))
		return TRUE

	return FALSE

/obj/effect/timed_event/destructible/generate_callback()
	return CALLBACK(get_turf(src), TYPE_PROC_REF(/turf, remove_flag), TURF_HULL)

/obj/effect/timed_event/destructible/announce_event(time_to_grab)
	var/announcement_areas = english_list(notification_areas[type]["[time_to_grab]"])

	var/marine_announcement_text = SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_IN_SPACE] \
		? "Structural collapse detected in [announcement_areas], allowing dismantlement. Be advised that new routes may be created." \
		: "Geological shifts detected in [announcement_areas], allowing excavation. Be advised that new routes may be created."

	marine_announcement(marine_announcement_text, "Priority Announcement")

	var/xeno_announcement_text = SSmapping.configs[GROUND_MAP].environment_traits[ZTRAIT_IN_SPACE] \
		? "The shattered metal of this place has collapsed, and we can create routes through [announcement_areas]." \
		: "The ground of this world trembles, and new routes may be created through [announcement_areas]."

	xeno_announcement(SPAN_XENOANNOUNCE(xeno_announcement_text), "everything", XENO_GENERAL_ANNOUNCE)

	qdel(src)

GLOBAL_LIST_INIT_TYPED(sentry_spawns, /obj/effect/sentry_landmark, list())

/// Allows a mapper to override the location of turrets on specific LZs, in specific placements. If multiple
/// are placed, it picks randomly.
/obj/effect/sentry_landmark
	icon = 'icons/landmarks.dmi'
	icon_state = "map_sentry"

	var/abstract_type = /obj/effect/sentry_landmark

	/// Which landing zone this landmark should be connected to
	var/landing_zone

	/// Which position this sentry should spawn at
	var/position


/obj/effect/sentry_landmark/Initialize(mapload, ...)
	. = ..()

	if(type == abstract_type)
		#if !defined(UNIT_TESTS)
		log_mapping("A [type] was created that should not have been! Use a subtype instead.")
		#endif
		return INITIALIZE_HINT_QDEL

	LAZYADDASSOCLIST(GLOB.sentry_spawns[landing_zone], position, get_turf(src))

	return INITIALIZE_HINT_QDEL

/obj/effect/sentry_landmark/lz_1
	abstract_type = /obj/effect/sentry_landmark/lz_1
	landing_zone = /obj/docking_port/stationary/marine_dropship/lz1

/obj/effect/sentry_landmark/lz_1/top_left
	position = SENTRY_TOP_LEFT

/obj/effect/sentry_landmark/lz_1/top_right
	position = SENTRY_TOP_RIGHT

/obj/effect/sentry_landmark/lz_1/bottom_left
	position = SENTRY_BOTTOM_LEFT

/obj/effect/sentry_landmark/lz_1/bottom_right
	position = SENTRY_BOTTOM_RIGHT

/obj/effect/sentry_landmark/lz_2
	abstract_type = /obj/effect/sentry_landmark/lz_2
	landing_zone = /obj/docking_port/stationary/marine_dropship/lz2

/obj/effect/sentry_landmark/lz_2/top_left
	position = SENTRY_TOP_LEFT

/obj/effect/sentry_landmark/lz_2/top_right
	position = SENTRY_TOP_RIGHT

/obj/effect/sentry_landmark/lz_2/bottom_left
	position = SENTRY_BOTTOM_LEFT

/obj/effect/sentry_landmark/lz_2/bottom_right
	position = SENTRY_BOTTOM_RIGHT
