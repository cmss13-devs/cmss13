/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE, offset_const, apply_bloom = TRUE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, 255, appearance_flags | EMISSIVE_APPEARANCE_FLAGS, offset_const)
	if(alpha == 255)
		if (apply_bloom)
			appearance.color = GLOB.emissive_color
		else
			appearance.color = GLOB.emissive_color_no_bloom
	else
		var/alpha_ratio = alpha/255
		if (apply_bloom)
			appearance.color = _EMISSIVE_COLOR(alpha_ratio)
		else
			appearance.color = _EMISSIVE_COLOR_NO_BLOOM(alpha_ratio)

	//Test to make sure emissives with broken or missing icon states are created
	if(PERFORM_ALL_TESTS(focus_only/invalid_emissives))
		if(icon_state && !icon_exists(icon, icon_state))
			stack_trace("An emissive appearance was added with non-existant icon_state \"[icon_state]\" in [icon]!")

	return appearance

// This is a semi hot proc, so we micro it. saves maybe 150ms
// sorry :)
/proc/fast_emissive_blocker(atom/make_blocker)
	var/mutable_appearance/blocker = new()
	blocker.icon = make_blocker.icon
	blocker.icon_state = make_blocker.icon_state
	// blocker.layer = FLOAT_LAYER // Implied, FLOAT_LAYER is default for appearances
	blocker.appearance_flags |= make_blocker.appearance_flags | EMISSIVE_APPEARANCE_FLAGS
	blocker.dir = make_blocker.dir
	if(make_blocker.alpha == 255)
		blocker.color = GLOB.em_block_color
	else
		var/alpha_ratio = make_blocker.alpha/255
		blocker.color = _EM_BLOCK_COLOR(alpha_ratio)

	blocker.plane = EMISSIVE_PLANE
	return blocker

/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EM_BLOCK_COLOR].
/proc/emissive_blocker(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE, offset_const)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags | EMISSIVE_APPEARANCE_FLAGS, offset_const)
	if(alpha == 255)
		appearance.color = GLOB.em_block_color
	else
		var/alpha_ratio = alpha/255
		appearance.color = _EM_BLOCK_COLOR(alpha_ratio)
	return appearance
