//generic water splash for when things hit water, we could eventually make different sizes for different sized things too
//plays a sound and an animation then dies, nice job water_splash effect you did good RIP
/obj/effect/water_splash
	name = "splash"
	desc = "Disturbed water, watch how it flies!"
	icon = 'icons/effects/water.dmi'
	icon_state = "splash"
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_XENO_LAYER
	var/lifetime = 2 SECONDS	//generous amount of time to let the animation play

/obj/effect/water_splash/Initialize(mapload=FALSE, playsound = TRUE)
	. = ..()
	if(lifetime != INFINITY)
		addtimer(CALLBACK(src, PROC_REF(destroy_effect)), lifetime)
	if(playsound)
		playsound(get_turf(src), "sound/effects/water/splash.ogg", 20, 1, 10, falloff=1)

/obj/effect/water_splash/proc/destroy_effect()
	qdel(src)

//this is what turf_effect/water puts on mobs that are in water
/obj/effect/water_splash/water_overlay_splash
	lifetime = INFINITY
	appearance_flags = RESET_ALPHA | KEEP_APART
	vis_flags = VIS_INHERIT_DIR
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE

/obj/effect/water_splash/water_overlay_splash/proc/update_wateroverlay(turf/water_turf, mob/living/carbon/affected_carbon, pixel_y_offset = 0, xeno_resting=FALSE)
	icon_state = null
	icon = null
	var/datum/water_overlay_config/config = affected_carbon.water_config
	if(!config || !config.use_splash)
		return

	var/is_resting = affected_carbon.resting || affected_carbon.body_position == LYING_DOWN || HAS_TRAIT(affected_carbon, TRAIT_FLOORED)
	if(is_resting && initial(config.resting_behavior) == WATER_OVERLAY_CONFIG_RESTING_NONE)
		return

	var/is_immersed = config.immerse_behavior != WATER_OVERLAY_CONFIG_IMMERSE_NONE && (\
		(config.immerse_behavior == WATER_OVERLAY_CONFIG_IMMERSE_ALWAYS) || \
		(config.immerse_behavior == WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_ALWAYS && is_resting) || \
		(config.immerse_behavior == WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED && pixel_y_offset <= config.immerse_at_depth) || \
		(config.immerse_behavior == WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_DEPTHED && is_resting &&  pixel_y_offset <= config.immerse_at_depth))\
		? TRUE : FALSE
	var/splash_state

	if(!is_immersed)
		if(is_resting && config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_ANGLED)
			var/resting_dir = affected_carbon.get_lying_angle() == 270 ? "e" : "w"
			if(pixel_y_offset >= DEPTH_COAST_INTERMEDIATE)
				splash_state = "[config.icon_state_key]_resting_coast_[resting_dir]"
			else if(pixel_y_offset <= DEPTH_SHALLOW)
				splash_state = "[config.icon_state_key]_resting_deep_[resting_dir]"
		else if(is_resting && config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_SOME)
			if(pixel_y_offset >= DEPTH_COAST_INTERMEDIATE)
				splash_state = "[config.icon_state_key]_resting_coast"
			else if(pixel_y_offset <= DEPTH_SHALLOW)
				splash_state = "[config.icon_state_key]_resting_deep"
		else
			if(pixel_y_offset == DEPTH_COAST_SHALLOW) //shallow coast
				splash_state = "coast_shallow"
			else if(pixel_y_offset == DEPTH_COAST_INTERMEDIATE) //deep coast
				splash_state = "coast_deep"
			else if(pixel_y_offset == DEPTH_SHALLOW) //shallows
				splash_state = "shallow"
			else if(pixel_y_offset == DEPTH_INTERMEDIATE)	//intermediate depth
				splash_state = "intermediate"
			else //pixel_y_offset== DEPTH_DEEP -- deep water
				splash_state = "deep"
	else
		splash_state = affected_carbon.stat == DEAD ? "empty" : "bubbles"
	icon = SSwater_overlays.get_icon_path(config.icon_size)
	icon_state = splash_state


