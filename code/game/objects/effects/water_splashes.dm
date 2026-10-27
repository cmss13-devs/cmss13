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
		QDEL_IN(src, lifetime)
	if(playsound)
		playsound(get_turf(src), "sound/effects/water/splash.ogg", 20, 1, 10, falloff=1)


//this is what water_overlay_effect puts on mobs that are in water
/obj/effect/water_splash/water_overlay_splash
	lifetime = INFINITY
	appearance_flags = RESET_ALPHA | KEEP_APART
	vis_flags = VIS_INHERIT_DIR
	layer = FLOAT_LAYER
	plane = FLOAT_PLANE


/obj/effect/water_splash/water_overlay_splash/proc/update_wateroverlay(turf/water_turf, mob/living/carbon/affected_carbon, water_depth = 0, xeno_resting = FALSE)
	icon_state = null
	icon = null

	var/datum/water_overlay_config/config = affected_carbon.water_config
	if(!config || !config.use_splash)
		return

	var/is_resting = affected_carbon.resting || affected_carbon.body_position == LYING_DOWN || HAS_TRAIT(affected_carbon, TRAIT_FLOORED)
	var/is_immersed = FALSE
	switch(config.immerse_behavior)
		if(WATER_OVERLAY_CONFIG_IMMERSE_NONE)
			is_immersed = FALSE
		if(WATER_OVERLAY_CONFIG_IMMERSE_ALWAYS)
			is_immersed = TRUE
		if(WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED)
			is_immersed = (water_depth <= config.immerse_at_depth)
		if(WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_ALWAYS)
			is_immersed = is_resting
		if(WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_DEPTHED)
			is_immersed = is_resting && (water_depth <= config.immerse_at_depth)

	if(is_immersed)	// fully under → no splash
		return

	// resting with no resting splash
	if(is_resting && config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_NONE)
		return

	var/splash_state
	if(is_resting && config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_ANGLED)
		var/resting_dir = affected_carbon.get_lying_angle() == 270 ? "e" : "w"
		if(water_depth >= WATER_DEPTH_COAST_INTERMEDIATE)
			splash_state = "[config.icon_state_key]_resting_coast_[resting_dir]"
		else if(water_depth <= WATER_DEPTH_SHALLOW)
			splash_state = "[config.icon_state_key]_resting_deep_[resting_dir]"
	else if(is_resting && config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_SOME)
		if(water_depth >= WATER_DEPTH_COAST_INTERMEDIATE)
			splash_state = "[config.icon_state_key]_resting_coast"
		else if(water_depth <= WATER_DEPTH_SHALLOW)
			splash_state = "[config.icon_state_key]_resting_deep"
	else
		if(water_depth == WATER_DEPTH_COAST_SHALLOW)
			splash_state = "coast_shallow"
		else if(water_depth == WATER_DEPTH_COAST_INTERMEDIATE)
			splash_state = "coast_deep"
		else if(water_depth == WATER_DEPTH_SHALLOW)
			splash_state = "shallow"
		else if(water_depth == WATER_DEPTH_INTERMEDIATE)
			splash_state = "intermediate"
		else
			splash_state = "deep"

	if(!splash_state)
		return

	icon = SSwater_overlays.icon_paths["[config.icon_size]"]
	icon_state = splash_state


