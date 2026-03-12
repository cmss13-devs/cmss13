/atom/movable/static_lighting_object
	name          = ""
	anchored      = TRUE
	icon          = LIGHTING_ICON
	icon_state    = "transparent"
	color         = LIGHTING_BASE_MATRIX
	plane         = LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility  = INVISIBILITY_LIGHTING
	vis_flags     = VIS_HIDE
	unacidable    = TRUE
	///whether we are already in the SSlighting.objects_queue list
	var/needs_update = FALSE
	///the turf that our light is applied to
	var/turf/affected_turf

/atom/movable/static_lighting_object/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)

	if(flags_atom & INITIALIZED)
		CRASH("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	// do we even need these...?
	pass_flags = GLOB.pass_flags_cache[type]
	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()
	verbs.Cut()

	affected_turf = loc
	if (affected_turf.static_lighting_object)
		qdel(affected_turf.static_lighting_object, force = TRUE)
		stack_trace("a lighting object was assigned to a turf that already had a lighting object!")
	affected_turf.static_lighting_object = src
	affected_turf.luminosity = 0

	needs_update = TRUE
	SSlighting.objects_queue += src
	return INITIALIZE_HINT_NORMAL

/atom/movable/static_lighting_object/Destroy(force)
	if (force)
		SSlighting.objects_queue -= src
		if (loc != affected_turf)
			var/turf/oldturf = get_turf(affected_turf)
			var/turf/newturf = get_turf(loc)
			stack_trace("A lighting object was qdeleted with a different loc then it is suppose to have ([COORD(oldturf)] -> [COORD(newturf)])")
		if (isturf(affected_turf))
			affected_turf.static_lighting_object = null
			affected_turf.luminosity = 1
		affected_turf = null

		return ..()

	else
		return QDEL_HINT_LETMELIVE

/atom/movable/static_lighting_object/proc/update()

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	var/static/datum/static_lighting_corner/dummy/dummy_lighting_corner = new

	var/turf/affected_turf = src.affected_turf
	var/datum/static_lighting_corner/red_corner = affected_turf.lighting_corner_SW || dummy_lighting_corner
	var/datum/static_lighting_corner/green_corner = affected_turf.lighting_corner_SE || dummy_lighting_corner
	var/datum/static_lighting_corner/blue_corner = affected_turf.lighting_corner_NW || dummy_lighting_corner
	var/datum/static_lighting_corner/alpha_corner = affected_turf.lighting_corner_NE || dummy_lighting_corner

	var/max = max(red_corner.largest_color_luminosity, green_corner.largest_color_luminosity, blue_corner.largest_color_luminosity, alpha_corner.largest_color_luminosity)

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points�?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif
	if(red_corner.cache_r & green_corner.cache_r & blue_corner.cache_r & alpha_corner.cache_r && \
		(red_corner.cache_g + green_corner.cache_g + blue_corner.cache_g + alpha_corner.cache_g + \
		red_corner.cache_b + green_corner.cache_b + blue_corner.cache_b + alpha_corner.cache_b == 8))
		//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		icon_state = "transparent"
		color = null
	else if(!set_luminosity)
		icon_state = "dark"
		color = null
	else
		icon_state = null
		color = list(
			red_corner.cache_r, red_corner.cache_g, red_corner.cache_b, 00,
			green_corner.cache_r, green_corner.cache_g, green_corner.cache_b, 00,
			blue_corner.cache_r, blue_corner.cache_g, blue_corner.cache_b, 00,
			alpha_corner.cache_r, alpha_corner.cache_g, alpha_corner.cache_b, 00,
			00, 00, 00, 01
		)

	if(set_luminosity)
		affected_turf.luminosity = set_luminosity
		return
	var/area/turf_area = affected_turf.loc
	//We are not lit by static light OR dynamic light.
	if(!LAZYLEN(affected_turf.hybrid_lights_affecting) && !turf_area.base_lighting_alpha)
		affected_turf.luminosity = 0

// Variety of overrides so the overlays don't get affected by weird things.

/atom/movable/static_lighting_object/ex_act(severity)
	return FALSE

/atom/movable/static_lighting_object/fire_act()
	return

/atom/movable/static_lighting_object/acid_spray_act()
	return

/atom/movable/static_lighting_object/flamer_fire_act()
	return

/atom/movable/static_lighting_object/onTransitZ()
	return

// Override here to prevent things accidentally moving around overlays.
/atom/movable/static_lighting_object/forceMove(atom/destination, no_tp=FALSE, harderforce = FALSE)
	if(harderforce)
		. = ..()
