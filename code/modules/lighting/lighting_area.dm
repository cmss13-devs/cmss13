/area
	luminosity = 1
	///The mutable appearance we underlay to show light
	var/mutable_appearance/lighting_effect = null
	///The mutable appearance we underlay to show light, same params as lighting_effect with BLEND_MULTIPLY
	var/mutable_appearance/lighting_multiply_effect = null
	///Whether this area has a currently active base lighting, bool
	var/area_has_base_lighting = FALSE
	///alpha 0-255 of lighting_effect and thus baselighting intensity
	var/base_lighting_alpha = 0
	///The colour of the light acting on this area
	var/base_lighting_color = COLOR_WHITE

	//This is used to indicate that of some turfs in the given area should have all of their contents scanned for alpha masking. 
	// Use this sparingly or it will have performance issues on startup.
	var/area_has_alphamasking = FALSE
	var/list/base_lighting_multiply_types = null

/area/proc/set_base_lighting(new_base_lighting_color = -1, new_alpha = -1)
	if(base_lighting_alpha == new_alpha && base_lighting_color == new_base_lighting_color)
		return FALSE
	if(new_alpha != -1)
		base_lighting_alpha = new_alpha
	if(new_base_lighting_color != -1)
		base_lighting_color = new_base_lighting_color
	update_base_lighting()
	return TRUE

/area/vv_edit_var(var_name, var_value)
	switch(var_name)
		if("base_lighting_color")
			set_base_lighting(new_base_lighting_color = var_value)
			return TRUE
		if("base_lighting_alpha")
			set_base_lighting(new_alpha = var_value)
			return TRUE
	return ..()

/area/proc/update_base_lighting()
	if(!area_has_base_lighting && (!base_lighting_alpha || !base_lighting_color))
		return

	if(!area_has_base_lighting)
		add_base_lighting()
		return
	remove_base_lighting()
	if(base_lighting_alpha && base_lighting_color)
		add_base_lighting()

/area/proc/remove_base_lighting()
	for(var/turf/T in src)
		if(base_lighting_multiply_types != null)
			if (T.type in base_lighting_multiply_types)
				T.overlays -= lighting_multiply_effect
				continue
		T.overlays -= lighting_effect
	QDEL_NULL(lighting_effect)
	QDEL_NULL(lighting_multiply_effect)
	area_has_base_lighting = FALSE

/area/proc/get_lighting_params()
	if (lighting_effect != null)
		return lighting_effect
	lighting_effect = mutable_appearance('icons/effects/alphacolors.dmi', "white")
	lighting_effect.plane = LIGHTING_PLANE
	lighting_effect.layer = LIGHTING_PRIMARY_LAYER
	lighting_effect.blend_mode = BLEND_ADD
	lighting_effect.alpha = base_lighting_alpha
	lighting_effect.color = base_lighting_color
	lighting_effect.appearance_flags = RESET_COLOR
	return lighting_effect

/area/proc/get_lighting_multiply_params()
	if (lighting_multiply_effect != null)
		return lighting_multiply_effect
	lighting_multiply_effect = mutable_appearance('icons/effects/alphacolors.dmi', "white")
	lighting_multiply_effect.plane = LIGHTING_PLANE
	lighting_multiply_effect.layer = LIGHTING_PRIMARY_LAYER
	lighting_multiply_effect.blend_mode = BLEND_MULTIPLY
	lighting_multiply_effect.alpha = base_lighting_alpha
	lighting_multiply_effect.color = base_lighting_color
	return lighting_multiply_effect

/area/proc/add_base_lighting_for_turf(var/turf/T)
	if(!area_has_base_lighting && (!base_lighting_alpha || !base_lighting_color))
		return

	var/mutable_appearance/appearance = get_turf_lighting_effect(T)

	T.overlays += appearance
	T.luminosity = 1

	// do not enable this in an area with many contents or it will LAG!
	if(area_has_alphamasking)
		apply_alphamask_to_turf_contents(T)

/area/proc/apply_alphamask_to_turf_contents(var/turf/T)
	for(var/obj/item in contents)
		if(item.use_alphamasking != null)
			item.alphamask_appearance = get_alphamask_apperance(item)
			item.overlays += item.alphamask_appearance

/area/proc/get_alphamask_apperance(var/obj/item)
	var/mutable_appearance/effect = mutable_appearance('icons/effects/alphacolors.dmi', "white")
	effect.plane = LIGHTING_PLANE
	effect.layer = LIGHTING_PRIMARY_LAYER
	effect.blend_mode = BLEND_ADD
	effect.alpha = 255
	effect.color = COLOR_WHITE
	effect.appearance_flags = KEEP_APART
	effect.icon = item.icon
	effect.icon_state = item.icon_state
	
	return effect


/area/proc/get_turf_lighting_effect(var/turf/T)
	if(!area_has_base_lighting && (!base_lighting_alpha || !base_lighting_color))
		return null
	var/mutable_appearance/appearance = get_lighting_params()
	if(base_lighting_multiply_types != null)
		if (T.type in base_lighting_multiply_types)
			appearance = get_lighting_multiply_params()
	return appearance
	
/area/proc/add_base_lighting()
	for(var/turf/T in src)
		add_base_lighting_for_turf(T)
	area_has_base_lighting = TRUE
