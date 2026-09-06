//	we use an object because critically  we dont want to alter the hitboxes.. like we would by having these as part of the mob sprite
//	and the water overlay is created to over extend past just the pixels of the body sprites, to cover armors/backpacks/inhands/alt sprites etc
//	it can have its alpha adjusted as well, the sprites of water turfs are opaque... also like if we ever wanted to add quicksand or mud thats easy now

/obj/effect/water_overlay_effect
	name = ""
	mouse_opacity = FALSE
	alpha = 180
	blend_mode = BLEND_INSET_OVERLAY
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	appearance_flags = RESET_COLOR
	plane = FLOAT_PLANE
	layer = FLOAT_LAYER

/obj/effect/water_overlay_effect/proc/update_wateroverlay(turf/open/water_turf, mob/living/overlaid_mob, pixel_y_offset = 0)
	overlays.Cut()

	var/datum/water_overlay_config/config = overlaid_mob.water_config
	if(!config)
		return

	var/is_resting = overlaid_mob.resting || overlaid_mob.body_position == LYING_DOWN
	if(is_resting && initial(config.resting_behavior) == WATER_OVERLAY_CONFIG_RESTING_NONE)
		return

	var/key = ""
	var/should_immerse = FALSE
	switch(initial(config.immerse_behavior))
		if(WATER_OVERLAY_CONFIG_IMMERSE_NONE)
			should_immerse = FALSE
		if(WATER_OVERLAY_CONFIG_IMMERSE_ALWAYS)
			should_immerse = TRUE
		if(WATER_OVERLAY_CONFIG_IMMERSE_DEPTHED)
			should_immerse = (config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_IMMERSE && is_resting) || (pixel_y_offset <= initial(config.immerse_at_depth))
		if(WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_ALWAYS)
			should_immerse = is_resting
		if(WATER_OVERLAY_CONFIG_IMMERSE_WHEN_RESTING_DEPTHED)
			should_immerse = is_resting && (pixel_y_offset <= initial(config.immerse_at_depth))

	if(should_immerse)
		key = "_immersed"
	else if(is_resting)
		switch(initial(config.resting_behavior))
			if(WATER_OVERLAY_CONFIG_RESTING_USE_DEFAULT)
				key = ""
			if(WATER_OVERLAY_CONFIG_RESTING_SOME)
				key = "_[initial(config.icon_state_key)]_resting"
			if(WATER_OVERLAY_CONFIG_RESTING_ANGLED)
				var/angle = overlaid_mob.get_lying_angle()
				if(angle == 270)
					key = "_[initial(config.icon_state_key)]_resting_e"
				else if(angle == 90)
					key = "_[initial(config.icon_state_key)]_resting_w"
				else
					key = "_[initial(config.icon_state_key)]_resting"
	else	//we're standing
		if(initial(config.special_culling_mask) && initial(config.icon_state_key))
			key = "_[initial(config.icon_state_key)]"

	var/toxic_key = 0
	if(istype(water_turf, /turf/open/gm/river/desert) || istype(water_turf, /turf/open/desert/desert_shore))
		var/turf/open/gm/river/desert/toxic_turf = water_turf
		toxic_key = toxic_turf.toxic

	var/icon_size = initial(config.icon_size)
	var/icon_key = "[icon_size]_[water_turf.water_type]_[toxic_key]_[pixel_y_offset][key]"
	var/mutable_appearance/final_texture = mutable_appearance(SSwater_overlays.water_overlay_icons[icon_key])
	final_texture.color = water_turf.color
	overlays += final_texture
