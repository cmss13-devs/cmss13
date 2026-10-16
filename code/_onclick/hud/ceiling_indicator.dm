/// Current tile's roof over a template, with an independently tinted tier outline.
/atom/movable/screen/ceiling_indicator
	name = "Ceiling"
	desc = "The ceiling above you cannot be determined."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "template"
	screen_loc = ui_ceiling_indicator
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	/// Cached inputs
	var/last_ceiling
	var/last_resin_tier
	var/has_reading = FALSE
	/// Seperate icons for each different type of ceiling
	var/static/list/ceiling_states = list(
		"[CEILING_NO_PROTECTION]" = "open",
		"[CEILING_NONE]" = "open",
		"[CEILING_GLASS]" = "glass",
		"[CEILING_METAL]" = "metal",
		"[CEILING_SANDSTONE_ALLOW_CAS]" = "sandstone",
		"[CEILING_UNDERGROUND_ALLOW_CAS]" = "underground",
		"[CEILING_UNDERGROUND_METAL_ALLOW_CAS]" = "underground_metal",
		"[CEILING_UNDERGROUND_BLOCK_CAS]" = "cavern",
		"[CEILING_UNDERGROUND_METAL_BLOCK_CAS]" = "cavern_metal",
		"[CEILING_UNDERGROUND_SANDSTONE_BLOCK_CAS]" = "cavern_sandstone",
		"[CEILING_DEEP_UNDERGROUND]" = "deep_underground",
		"[CEILING_DEEP_UNDERGROUND_METAL]" = "deep_underground_metal",
		"[CEILING_REINFORCED_METAL]" = "reinforced_metal",
		"[CEILING_RESIN]" = "weed",
		"[CEILING_MAX]" = "maximum",
	)
	/// Ceiling descriptions when hovering over the UI
	var/static/list/ceiling_descriptions = list(
		"open" = "The open sky is above.",
		"glass" = "A glass ceiling is above.",
		"metal" = "A metal ceiling is above.",
		"sandstone" = "A sandstone ceiling is above.",
		"underground" = "A thin cavern ceiling is above.",
		"underground_metal" = "An underground thin metal ceiling is above.",
		"cavern" = "A thick cavern ceiling is above.",
		"cavern_metal" = "An underground thick metal ceiling is above.",
		"cavern_sandstone" = "An underground thick sandstone ceiling is above.",
		"deep_underground" = "A heavy cavern ceiling is above.",
		"deep_underground_metal" = "An underground heavy metal ceiling is above.",
		"reinforced_metal" = "A heavy reinforced metal ceiling is above.",
		"weed" = "A pulsating resin ceiling is above.",
		"maximum" = "The ceiling above provides maximum protection.",
	)

/atom/movable/screen/ceiling_indicator/Initialize(mapload, datum/hud/owner_hud)
	. = ..()
	hud = owner_hud
	if(!hud?.mymob)
		return
	if(isxeno(hud.mymob))
		screen_loc = ui_ceiling_indicator_xeno
	RegisterSignal(hud.mymob, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved))
	update_ceiling()
	// Also catches roofs changing under a stationary mob and movement in vehicles.
	START_PROCESSING(SSobj, src)

/atom/movable/screen/ceiling_indicator/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(hud?.mymob)
		UnregisterSignal(hud.mymob, COMSIG_MOVABLE_MOVED)
	return ..()

/atom/movable/screen/ceiling_indicator/proc/on_owner_moved()
	SIGNAL_HANDLER
	update_ceiling()

/atom/movable/screen/ceiling_indicator/process()
	update_ceiling()

/atom/movable/screen/ceiling_indicator/MouseEntered(location, control, params)
	. = ..()
	if(QDELETED(src))
		return
	update_ceiling()
	openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/ceiling_indicator/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/atom/movable/screen/ceiling_indicator/proc/update_ceiling()
	var/turf/current_turf = get_turf(hud?.mymob)
	var/area/current_area = get_area(current_turf)
	if(!current_turf || !current_area)
		has_reading = FALSE
		name = "Ceiling: unknown"
		desc = initial(desc)
		overlays.Cut()
		return

	var/ceiling = current_area.ceiling
	var/resin_tier = get_ceiling_protection_level(current_turf.get_pylon_protection_level())
	if(has_reading && ceiling == last_ceiling && resin_tier == last_resin_tier)
		return
	last_ceiling = ceiling
	last_resin_tier = resin_tier
	has_reading = TRUE

	var/tier = max(floor(ceiling), resin_tier)
	var/roof_state = ceiling_states["[ceiling]"]
	// A resin roof doesn't hide a stronger natural ceiling.
	if(resin_tier > CEILING_NO_PROTECTION && resin_tier >= floor(ceiling))
		roof_state = "weed"
	if(!roof_state)
		name = "Ceiling: unknown"
		desc = initial(desc)
		overlays.Cut()
		return
	var/roof_name = replacetext(roof_state, "_", " ")
	name = "Ceiling: [roof_name]"
	desc = ceiling_descriptions[roof_state]
	switch(tier)
		if(CEILING_NO_PROTECTION)
			desc += "<br>It's not going to stop anything."
		if(CEILING_PROTECTION_TIER_1)
			desc += "<br>Blocks suborbital CAS fire, but not mortar fire or CAS firemissions."
		if(CEILING_PROTECTION_TIER_2)
			desc += "<br>Blocks mortar fire, but not CAS firemissions."
		if(CEILING_PROTECTION_TIER_3)
			desc += "<br>Blocks mortar fire and CAS firemissions, but not orbital bombardments."
		if(CEILING_PROTECTION_TIER_4)
			desc += "<br>Blocks mortar fire, CAS firemissions, and orbital bombardments."

	var/outline_color = COLOR_GREEN
	if(CEILING_IS_PROTECTED(tier, CEILING_PROTECTION_TIER_3))
		outline_color = COLOR_RED
	else if(CEILING_IS_PROTECTED(tier, CEILING_PROTECTION_TIER_1))
		outline_color = COLOR_YELLOW

	var/mutable_appearance/roof = mutable_appearance(icon, roof_state)
	var/mutable_appearance/outline = mutable_appearance(icon, "outline", ABOVE_FLOAT_LAYER)
	outline.color = outline_color
	overlays = list(roof, outline)
