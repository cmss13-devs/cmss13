//todo: handle moving sunlight turfs - see various uses of get_turf in lighting_object


/*

Sunlight System

	Objects + Details
		Sunlight Objects (this file)
			- Grayscale version of lighting_object
			- Has 3 states
				- SKY_BLOCKED  (0)
					- Turfs that have an opaque turf above them. Has no light themselves but is affected by SKY_VISIBLE_BORDER
				- SKY_VISIBLE (1)
					- Turfs that with no opaque turfs above it (no roof, glass roof, etc), with no neighbouring SKY_BLOCKED tiles
					  Emits no light, but is fully white to display the overlay color
				- SKY_VISIBLE_BORDER  (2)
					- Turfs that with no opaque turfs above it (no roof, glass roof, etc), which neighbour at least one SKY_BLOCKED tile.
				     Emits light to SKY_BLOCKED tiles, and fully white to display the overlay color

*/

/atom/movable/outdoor_effect
	name = ""
	mouse_opacity = FALSE
	anchored = TRUE

	/* misc vars */
	var/mutable_appearance/sunlight_overlay
	var/state = SKY_VISIBLE	// If we can see the see the sky, are blocked, or we have a blocked neighbour (SKY_BLOCKED/VISIBLE/VISIBLE_BORDER)
	var/turf/source_turf
	var/list/datum/static_lighting_corner/affecting_corners

/atom/movable/outdoor_effect/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE

	//If we are a source of light - disable it, to fix out corner refs
	disable_sunlight()

	//Remove ourselves from our turf
	if(source_turf && source_turf.outdoor_effect == src)
		source_turf.outdoor_effect = null

	return ..()

/atom/movable/outdoor_effect/Initialize(mapload)
	. = ..()
	source_turf = loc
	if(source_turf.outdoor_effect)
		qdel(source_turf.outdoor_effect, force = TRUE)
		source_turf.outdoor_effect = null //No qdel_null force
	source_turf.outdoor_effect = src

/atom/movable/outdoor_effect/proc/disable_sunlight()
	var/turf/turf = list()
	for(var/datum/static_lighting_corner/corner as anything in affecting_corners)
		corner.glob_affect -= src
		corner.get_sunlight_falloff()
		if(corner.master_NE)
			turf |= corner.master_NE
		if(corner.master_SE)
			turf |= corner.master_SE
		if(corner.master_SW)
			turf |= corner.master_SW
		if(corner.master_NW)
			turf |= corner.master_NW
	turf |= source_turf /* get our calculated indoor lighting */
	GLOB.sunlight_queue_corner |= turf

	//Empty our affecting_corners list
	affecting_corners = null

/atom/movable/outdoor_effect/proc/process_state()
	switch(state)
		if(SKY_BLOCKED)
			disable_sunlight() /* Do our indoor processing */
		if(SKY_VISIBLE_BORDER)
			calc_sunlight_spread()

#define HARDSUN 0.5 /* our hyperboloidy modifyer funky times - I wrote this in like, 2020 and can't remember how it works - I think it makes a 3D cone shape with a flat top */
/* calculate the indoor corners we are affecting */
#define SUN_FALLOFF(C, T) (1 - CLAMP01(sqrt((C.x - T.x) ** 2 + (C.y - T.y) ** 2 - HARDSUN) / max(1, GLOB.global_light_range)))


/atom/movable/outdoor_effect/proc/calc_sunlight_spread()
	var/list/turf/turfs = list()
	var/datum/static_lighting_corner/corner
	var/turf/turf
	var/list/tempMasterList = list() /* to mimimize double ups */
	var/list/corners  = list() /* corners we are currently affecting */

	//Set lum so we can see things
	var/oldLum = luminosity
	luminosity = GLOB.global_light_range

	for(turf in view(CEILING(GLOB.global_light_range, 1), source_turf))
		if(IS_OPAQUE_TURF(turf)) /* get_corners used to do opacity checks for arse */
			continue
		if (!turf.lighting_corners_initialised)
			turf.static_generate_missing_corners()
		corners |= turf.lighting_corner_NE
		corners |= turf.lighting_corner_SE
		corners |= turf.lighting_corner_SW
		corners |= turf.lighting_corner_NW
		turfs += turf

	//restore lum
	luminosity = oldLum

	/* fix up the lists */
	/* add ourselves and our distance to the corner */
	if(!affecting_corners)
		affecting_corners = list()
	var/list/corners_list = corners - affecting_corners
	affecting_corners += corners_list
	for(corner in corners_list)
		corner.glob_affect[src] = SUN_FALLOFF(corner, source_turf)
		if(corner.glob_affect[src] > corner.sun_falloff) /* if are closer than current dist, update the corner */
			corner.sun_falloff = corner.glob_affect[src]
			if(corner.master_NE)
				tempMasterList |= corner.master_NE
			if(corner.master_SE)
				tempMasterList |= corner.master_SE
			if(corner.master_SW)
				tempMasterList |= corner.master_SW
			if(corner.master_NW)
				tempMasterList |= corner.master_NW

	corners_list = affecting_corners - corners // Now-gone corners, remove us from the affecting.
	affecting_corners -= corners_list
	for(corner in corners_list)
		corner.glob_affect -= src
		corner.get_sunlight_falloff()
		if(corner.master_NE)
			tempMasterList |= corner.master_NE
		if(corner.master_SE)
			tempMasterList |= corner.master_SE
		if(corner.master_SW)
			tempMasterList |= corner.master_SW
		if(corner.master_NW)
			tempMasterList |= corner.master_NW

	GLOB.sunlight_queue_corner += tempMasterList /* update the boys */

/* Related object changes */
/* I moved this here to consolidate sunlight changes as much as possible, so its easily disabled */

/* turf fuckery */
/turf
	var/tmp/atom/movable/outdoor_effect/outdoor_effect /* a turf's sunlight overlay */
	var/turf/pseudo_roof /* our roof turf - may be a path for top z level, or a ref to the turf above*/

/* check ourselves and neighbours to see what outdoor effects we need */
/* turf won't initialize an outdoor_effect if sky_blocked*/
/turf/proc/get_sky_and_weather_states()
	var/tempstate
	update_ceiling_status()
	if(ceiling_status & SKYVISIBLE)
		tempstate = SKY_VISIBLE
		for(var/turf/neighbour_turf in RANGE_TURFS(1, src))
			neighbour_turf.update_ceiling_status()
			if(!(neighbour_turf.ceiling_status & SKYVISIBLE)) /* if we have a single roofed/indoor neighbour, we are a border */
				tempstate = SKY_VISIBLE_BORDER
				break
	else /* roofed, so turn off the lights */
		tempstate = SKY_BLOCKED

	/* if border or indoor, initialize. Set sunlight state if valid */
	if(!outdoor_effect && (tempstate <> SKY_BLOCKED || ceiling_status & WEATHERVISIBLE))
		outdoor_effect = new /atom/movable/outdoor_effect(src)

	if(outdoor_effect)
		outdoor_effect.state = tempstate
		turf_flags &= ~TURF_WEATHER
		SSweather_conditions.weathered_turfs -= src
		if(ceiling_status & WEATHERVISIBLE)
			turf_flags |= TURF_WEATHER
			SSweather_conditions.weathered_turfs |= src

/* runs up the Z stack for this turf, returns a assoc (SKYVISIBLE, WEATHERPROOF)*/
/* pass recursionStarted=TRUE when we are checking our ceiling's stats */
/turf/proc/update_ceiling_status(recursionStarted = FALSE)
	var/skyvisible
	var/weathervisible
	if(!is_ground_level(z) && !is_mainship_level(z))
		skyvisible = FALSE
		weathervisible = FALSE
		return

	//Check yourself (before you wreck yourself)
	if(istype(src, /turf/closed) || (/obj/structure/window/framed in contents)) //Closed, but we might be transparent
		skyvisible = turf_flags & TURF_TRANSPARENT // a column of glass should still let the sun in
		weathervisible = FALSE
	else
		if(recursionStarted)
			// This src is acting as a ceiling - so if we are a floor we TURF_WEATHER_PROOF + block the sunlight of our down-Z turf
			skyvisible = turf_flags & TURF_TRANSPARENT //If we are glass floor, we don't block
			weathervisible = !(turf_flags & TURF_WEATHER_PROOF) //If we are air or space, we aren't TURF_WEATHER_PROOF
		else //We are open, so assume open to the elements
			skyvisible = TRUE
			weathervisible = TRUE

	// Early leave if we can't see the sky - if we are an opaque turf, we already know the results
	// I can't think of a case where we would have a turf that would block light but let weather effects through - Maybe a vent?
	// fix this if that is the case
	if(!skyvisible)
		ceiling_status = NO_FLAGS
		if(weathervisible)
			ceiling_status |= WEATHERVISIBLE
		return

	//Ceiling Check
	// Psuedo-roof, for the top of the map (no actual turf exists up here) -- We assume these are solid, if you add glass pseudo_roofs then fix this
	if(pseudo_roof)
		skyvisible = FALSE
		weathervisible = FALSE
	else
		//SILENCE FIX FOR MULTIZ
		var/area/area = get_area(src)
		if(area.ceiling < CEILING_GLASS)
			skyvisible = TRUE
			weathervisible = TRUE
		else if(area.ceiling == CEILING_GLASS)
			skyvisible &= TRUE
			weathervisible = FALSE
		else
			skyvisible = FALSE
			weathervisible = FALSE
		// EVERY turf must be transparent for sunlight - so &=
		// ANY turf must be closed for TURF_WEATHER_PROOF - so |=
/*
		var/turf/ceiling = get_step_multiz(src, UP)
		if(ceiling)
			ceiling.update_ceiling_status(TRUE) //Pass TRUE because we are now acting as a ceiling
			skyvisible &= ceiling.ceiling_status & SKYVISIBLE
			weathervisible &= ceiling.ceiling_status & WEATHERVISIBLE
*/

		ceiling_status = NO_FLAGS
		if(skyvisible)
			ceiling_status |= SKYVISIBLE
		if(weathervisible)
			ceiling_status |= WEATHERVISIBLE

/turf/proc/apply_weather_effect(datum/weather_effect/effect)
	SIGNAL_HANDLER

	if(locate(/obj/structure/machinery/door) in src)
		return
	if(locate(/obj/structure/window/framed) in src)
		return
	if(!(turf_flags & TURF_EFFECT_AFFECTABLE) || density || !effect)
		return

	effect.effect_affect(src)

/* moved this out of reconsider lights so we can call it in multiz refresh  */
/turf/proc/reconsider_sunlight()
	if(!SSlighting.initialized)
		return

	/* remove roof refs (not path for psuedo roof) so we can recalculate it */
	if(pseudo_roof && !ispath(pseudo_roof))
		pseudo_roof = null

	var/atom/movable/outdoor_effect/effect
	var/list/SunlightUpdates = list()

	//Add ourselves (we might not have corners initialized, and this handles it)
	SunlightUpdates += src

	//AHHHHGGGGGHHHHHHHHHHHHHHH
	if(lighting_corner_NE)
		if(lighting_corner_NE.master_NE)
			SunlightUpdates |= lighting_corner_NE.master_NE
		if(lighting_corner_NE.master_SE)
			SunlightUpdates |= lighting_corner_NE.master_SE
		if(lighting_corner_NE.master_SW)
			SunlightUpdates |= lighting_corner_NE.master_SW
		if(lighting_corner_NE.master_NW)
			SunlightUpdates |= lighting_corner_NE.master_NW
		for(effect in lighting_corner_NE.glob_affect)
			SunlightUpdates |= effect.source_turf

	if(lighting_corner_SE)
		if(lighting_corner_SE.master_NE)
			SunlightUpdates |= lighting_corner_SE.master_NE
		if(lighting_corner_SE.master_SE)
			SunlightUpdates |= lighting_corner_SE.master_SE
		if(lighting_corner_SE.master_SW)
			SunlightUpdates |= lighting_corner_SE.master_SW
		if(lighting_corner_SE.master_NW)
			SunlightUpdates |= lighting_corner_SE.master_NW
		for(effect in lighting_corner_SE.glob_affect)
			SunlightUpdates |= effect.source_turf

	if(lighting_corner_SW)
		if(lighting_corner_SW.master_NE)
			SunlightUpdates |= lighting_corner_SW.master_NE
		if(lighting_corner_SW.master_SE)
			SunlightUpdates |= lighting_corner_SW.master_SE
		if(lighting_corner_SW.master_SW)
			SunlightUpdates |= lighting_corner_SW.master_SW
		if(lighting_corner_SW.master_NW)
			SunlightUpdates |= lighting_corner_SW.master_NW
		for(effect in lighting_corner_SW.glob_affect)
			SunlightUpdates |= effect.source_turf

	if(lighting_corner_NW)
		if(lighting_corner_NW.master_NE)
			SunlightUpdates |= lighting_corner_NW.master_NE
		if(lighting_corner_NW.master_SE)
			SunlightUpdates |= lighting_corner_NW.master_SE
		if(lighting_corner_NW.master_SW)
			SunlightUpdates |= lighting_corner_NW.master_SW
		if(lighting_corner_NW.master_NW)
			SunlightUpdates |= lighting_corner_NW.master_NW
		for(effect in lighting_corner_NW.glob_affect)
			SunlightUpdates |= effect.source_turf

	GLOB.sunlight_queue_work |= SunlightUpdates

	var/turf/turf = SSmapping.get_turf_below(src)
	if(turf)
		turf.reconsider_sunlight()

/* corner fuckery */
/datum/static_lighting_corner
	var/list/glob_affect = list() /* list of sunlight objects affecting this corner */
	var/sun_falloff = 0 /* smallest distance to sunlight turf, for sunlight falloff */

/* loop through and find our strongest sunlight value */
/datum/static_lighting_corner/proc/get_sunlight_falloff()
	sun_falloff = 0

	var/atom/movable/outdoor_effect/effect
	for(effect in glob_affect)
		sun_falloff = sun_falloff < glob_affect[effect] ? glob_affect[effect] : sun_falloff

/* Effect Fuckery */
/* these bits are to set the roof on a top-z level, as there is no turf above to act as a roof */
/obj/effect/mapping_helpers
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = ""
	var/late = FALSE

/obj/effect/mapping_helpers/Initialize(mapload)
	..()
	return late ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_QDEL

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter
	var/turf/pseudo_roof

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/mountain
	pseudo_roof = /turf/closed/wall/rock
	icon_state = "roof_mountain"

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/wood
	pseudo_roof = /turf/open/floor/roof/wood
	icon_state = "roof_wood"

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/concrete
	pseudo_roof = /turf/open/floor/roof/asphalt
	icon_state = "roof_concrete"

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/ship_hull
	pseudo_roof = /turf/open/floor/roof/ship_hull
	icon_state = "roof_ship_hull"

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/glass
	pseudo_roof = /turf/open/floor/glass
	icon_state = "roof_glass"

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/ship_glass
	pseudo_roof = /turf/open/floor/glass/reinforced
	icon_state = "roof_ship_glass"

/obj/effect/mapping_helpers/sunlight/pseudo_roof_setter/Initialize(mapload)
	. = ..()
	// Disabled mapload catch - somebody might want to wangle this l8r
	// if(!mapload)
	// 	log_mapping("[src] spawned outside of mapload!")
	// 	return
	if(isturf(loc))// && !get_step_multiz(loc, UP))
		var/turf/our_turf = loc
		our_turf.pseudo_roof = pseudo_roof



#undef SUN_FALLOFF
#undef HARDSUN

//DON'T ASK
/atom/movable/outdoor_effect/proc/extinguish()
	return FALSE
