#define Z_CHANGE_CALL "z_change"
#define AREA_CHANGE_CALL "area_change"

/mob
	var/list/fullscreens = list()

	///The type of special lighting such as a sunset or lightning is currently active, dont have more than one of these without a special fullscreen framework
	var/special_lighting = null
	///A var to check if there is currently an active special lighting timer already set in order to prevent dupes
	var/special_lighting_active_timer = FALSE

/mob/proc/overlay_fullscreen(category, type, severity)
	var/atom/movable/screen/fullscreen/screen = fullscreens[category]
	if (!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, FALSE)
		fullscreens[category] = screen = type ? new type() : null
	else if ((!severity || severity == screen.severity) && (!client || screen.screen_loc != "CENTER-7,CENTER-7" || screen.fs_view == client.view))
		// doesn't need to be updated
		return screen

	if(!screen)
		return

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity
	if (client && screen.should_show_to(src))
		screen.update_for_view(client.view)
		client.add_to_screen(screen)

	return screen

/mob/proc/clear_fullscreen(category, animated = 10)
	var/atom/movable/screen/fullscreen/screen = fullscreens[category]
	if(!screen)
		return

	fullscreens -= category

	if(animated)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, PROC_REF(clear_fullscreen_after_animate), screen), animated, TIMER_CLIENT_TIME)
	else
		if(client)
			client.remove_from_screen(screen)
		qdel(screen)

/mob/proc/clear_fullscreen_after_animate(atom/movable/screen/fullscreen/screen)
	if(client)
		client.remove_from_screen(screen)
	qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in fullscreens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in fullscreens)
			client.remove_from_screen(fullscreens[category])

/mob/proc/reload_fullscreens()
	if(client)
		var/atom/movable/screen/fullscreen/screen
		for(var/category in fullscreens)
			screen = fullscreens[category]
			if(screen?.should_show_to(src))
				screen.update_for_view(client.view)
				client.add_to_screen(screen)
			else
				client.remove_from_screen(screen)

/mob/proc/initialize_special_lighting() //initialized on hud.dm when a new mob is spawned so you can't dodge this unless you dont have a client somehow
	if(!SSticker.mode)
		if(special_lighting)
			return
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(initialize_special_lighting)))
		special_lighting = SPECIAL_LIGHTING_PREROUND	// do not let a special_lighting get called before roundstart
		return
	if(SSticker.mode.flags_round_type & MODE_SUNSET)
		if(!fullscreens["lighting_backdrop"] || special_lighting == SPECIAL_LIGHTING_SUNSET || special_lighting_active_timer)
			return
		special_lighting = SPECIAL_LIGHTING_SUNSET
		special_lighting_active_timer = TRUE
		if(ROUND_TIME < 4 SECONDS) //if you're in before full setup, dont let special lightings get called prior, it gets messy
			addtimer(CALLBACK(src, PROC_REF(special_lighting_animate), SPECIAL_LIGHTING_SUNSET, 30 SECONDS, 9, 10 SECONDS, 0, null, 1, FALSE, TRUE, TRUE), 3 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(special_lighting_register_signals)), 3 SECONDS)
		else if(ROUND_TIME < 280 SECONDS)
			special_lighting = SPECIAL_LIGHTING_SUNSET
			special_lighting_active_timer = TRUE
			special_lighting_animate(SPECIAL_LIGHTING_SUNSET, 30 SECONDS, 9, 10 SECONDS, 0, 0.1 SECONDS, 1, TRUE, TRUE, TRUE)
			special_lighting_register_signals()
		return
	if(GLOB.sunrise_starting_time)
		if(!fullscreens["lighting_backdrop"] || special_lighting == SPECIAL_LIGHTING_SUNRISE || special_lighting == SPECIAL_LIGHTING_SUNSET || special_lighting_active_timer)
			return
		special_lighting = SPECIAL_LIGHTING_SUNRISE
		special_lighting_active_timer = TRUE
		special_lighting_animate(SPECIAL_LIGHTING_SUNRISE, 30 SECONDS, 6, 1 SECONDS, 0.1 SECONDS, -1, TRUE, TRUE, FALSE)
		special_lighting_register_signals() //sunrise is permanent, you wont need to unregister

//Get the distance to the farthest edge of the screen
/mob/proc/get_maximum_view_range()
	if(!client)
		return world.view

	var/offset = max(abs(client.pixel_x), abs(client.pixel_y))
	return client.view + offset / 32

/atom/movable/screen/fullscreen
	icon = 'icons/mob/hud/screen1_full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/severity = 0
	var/fs_view = 7
	var/show_when_dead = FALSE
	/// If this should try and resize if the user's view is bigger than the default
	var/should_resize = TRUE

/atom/movable/screen/fullscreen/proc/update_for_view(client_view)
	if (screen_loc == "CENTER-7,CENTER-7" && fs_view != client_view && should_resize)
		var/list/actualview = getviewsize(client_view)
		fs_view = client_view
		transform = matrix(actualview[1]/FULLSCREEN_OVERLAY_RESOLUTION_X, 0, 0, 0, actualview[2]/FULLSCREEN_OVERLAY_RESOLUTION_Y, 0)

/atom/movable/screen/fullscreen/proc/should_show_to(mob/mymob)
	if(!show_when_dead && mymob.stat == DEAD)
		return FALSE
	return TRUE

/atom/movable/screen/fullscreen/Destroy()
	severity = 0
	. = ..()

/atom/movable/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = FULLSCREEN_DAMAGE_LAYER

/atom/movable/screen/fullscreen/brute/nvg
	color = COLOR_BLACK

/atom/movable/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = FULLSCREEN_DAMAGE_LAYER

/atom/movable/screen/fullscreen/flash/noise/nvg
	alpha = 27.5

/atom/movable/screen/fullscreen/crit
	icon_state = "passage"
	layer = FULLSCREEN_CRIT_LAYER

/atom/movable/screen/fullscreen/crit/dark
	color = COLOR_GRAY

/atom/movable/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = FULLSCREEN_BLIND_LAYER

/atom/movable/screen/fullscreen/impaired
	icon_state = "impairedoverlay"
	layer = FULLSCREEN_IMPAIRED_LAYER

/atom/movable/screen/fullscreen/flash
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	layer = FULLSCREEN_FLASH_LAYER

/atom/movable/screen/fullscreen/flash/noise
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"

/atom/movable/screen/fullscreen/flash/dark
	icon_state = "black"

/atom/movable/screen/fullscreen/high
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"
	layer = FULLSCREEN_DRUGGY_LAYER

/atom/movable/screen/fullscreen/blurry
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "blurry"
	layer = FULLSCREEN_BLURRY_LAYER

/atom/movable/screen/fullscreen/nvg
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "nvg_hud"
	appearance_flags = NONE

/atom/movable/screen/fullscreen/thermal
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "thermal_hud"
	appearance_flags = NONE

/atom/movable/screen/fullscreen/meson
	icon = 'icons/mob/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "meson_hud"
	appearance_flags = NONE

/atom/movable/screen/fullscreen/meson/refurb
	icon_state = "refurb_meson_hud"

/atom/movable/screen/fullscreen/pain
	icon_state = "painoverlay"
	layer = FULLSCREEN_PAIN_LAYER

/atom/movable/screen/fullscreen/xeno_pain
	icon_state = "xeno_painoverlay"
	layer = FULLSCREEN_PAIN_LAYER

/atom/movable/screen/fullscreen/laser_blind
	icon_state = "impairedoverlay1"

/atom/movable/screen/fullscreen/vulture
	icon_state = "vulture_scope_overlay_sniper"
	layer = FULLSCREEN_VULTURE_SCOPE_LAYER

/atom/movable/screen/fullscreen/vulture/spotter
	icon_state = "vulture_scope_overlay_spotter"
	should_resize = FALSE

//Weather overlays//

/atom/movable/screen/fullscreen/weather
	icon_state = "initialize this"
	layer = FULLSCREEN_WEATHER_LAYER
	appearance_flags = NONE
	show_when_dead = TRUE


/atom/movable/screen/fullscreen/weather/low
	icon_state = "impairedoverlay1"

/atom/movable/screen/fullscreen/weather/medium
	icon_state = "impairedoverlay2"

/atom/movable/screen/fullscreen/weather/high
	icon_state = "impairedoverlay3"

/atom/movable/screen/fullscreen/lighting_backdrop
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "flash"
	transform = matrix(200, 0, 0, 0, 200, 0)
	plane = LIGHTING_PLANE
	blend_mode = BLEND_OVERLAY
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/lighting_backdrop/update_for_view(client_view)
	return

//Provides darkness to the back of the lighting plane
/atom/movable/screen/fullscreen/lighting_backdrop/lit_secondary
	invisibility = INVISIBILITY_LIGHTING
	layer = BACKGROUND_LAYER + LIGHTING_PRIMARY_DIMMER_LAYER
	color = "#000"
	alpha = 60

/atom/movable/screen/fullscreen/lighting_backdrop/backplane
	invisibility = INVISIBILITY_LIGHTING
	layer = LIGHTING_BACKPLANE_LAYER
	color = "#000"
	blend_mode = BLEND_ADD

/atom/movable/screen/fullscreen/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	layer = LIGHTING_PRIMARY_LAYER
	blend_mode = BLEND_ADD
	show_when_dead = TRUE

/mob/proc/special_lighting_animate(p_special_lighting_type = null, p_stage_time, p_max_stages, p_startup_delay = 1 SECONDS, p_special_start_time = 0, p_special_stage_time = null, p_special_tick_dir, p_special_call = FALSE, p_create_new_lighting_timer = FALSE, p_lighting_deactivates = TRUE)

	var/atom/movable/screen/fullscreen/screen = fullscreens["lighting_backdrop"]
	var/area/lighting_mob_area = get_area(src)

	if(p_special_lighting_type != special_lighting)
		return

	var/lighting_color = "#000" /// used in the animation, set by the special_lighting_type

	var/stage_time = p_stage_time /// how long each stage lasts, don't edit this if you want smooth movement, use special_stage_time instead
	var/max_stages = p_max_stages /// how many stages of special lighting there are, starts at 0

	var/startup_delay = p_startup_delay /// how long the initial stage lasts for, doesn't factor in round start stuff
	var/special_start_time = p_special_start_time /// when the special_lighting starts (use 0 if roundstart)

	var/special_stage_time = p_special_stage_time /// changes animation time without changing stage time, used by special calls and init stages
	var/special_call = p_special_call /// the type of special call
	var/special_tick_dir = p_special_tick_dir /// If it gets a special call, if it ticks up or down in order to prevent advantages

	var/create_new_lighting_timer = p_create_new_lighting_timer /// used to prevent timer dupes, keep this as False unless its supposed to be the first call
	var/lighting_deactivates = p_lighting_deactivates /// If the lighting deactivates

	var/lighting_stage = clamp((floor((ROUND_TIME + stage_time - special_start_time - startup_delay)/stage_time)), 0, max_stages) /// the current stage of the lighting, ticks up by 1 every stagetime after startup_delay + start_time
	//uses formula (x + y - w - z)/(y) with x = round_time, y = stage_time, w = special_start_time, and z being startup_delay

	var/time_til_next_lighting_call = max(((lighting_stage * stage_time) + startup_delay + special_start_time - ROUND_TIME), 0.5 SECONDS) /// how long until the next sunstage occurs (minimum of 0.5 seconds)

	if(special_call && lighting_stage != 0) // controls stuff related to special calls, prevents people from getting unfair advantages by getting stages reset, unnecessary for short anims
		if(lighting_deactivates && ROUND_TIME < (stage_time * max_stages) + special_start_time + startup_delay) //if its finished max stage anim and doesn't deactivate, make special calls animate to full
			lighting_stage = clamp((lighting_stage + special_tick_dir), 0, max_stages)
		if(time_til_next_lighting_call < special_stage_time)
			time_til_next_lighting_call = time_til_next_lighting_call + special_stage_time //delays main anims until the special call anim is done

	var/static/list/warm_color_progression = list("#e3a979", "#e29658", "#da8b4a", "#a9633c", "#90422d", "#68333a", "#4d2b35", "#231935", "#050c27", "#000")
	var/static/list/cold_color_progression = list("#a8c3cf", "#7a9abb", "#6679a8", "#516a8b", "#38486e", "#2c2f4d", "#211b36", "#1f1b33", "#0c0a1b", "#000")
	var/static/list/sunrise_color_progression = list("#000", "#040712", "#111322", "#291642", "#3f2239", "#632c3d", "#b97034")
	var/is_cold = SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] || SSmapping.configs[GROUND_MAP].map_name == MAP_LV522_CHANCES_CLAIM || MAP_PRISON_STATION_V3
	
	if(special_lighting == SPECIAL_LIGHTING_SUNSET)
		lighting_color = is_cold ? cold_color_progression[lighting_stage] : warm_color_progression[lighting_stage]
	else
		lighting_color = sunrise_color_progression[lighting_stage]

	if(lighting_stage == 0) //there aren't any cases you won't want these coming up fast
		special_stage_time = 0.5 SECONDS
		time_til_next_lighting_call = startup_delay + special_start_time - ROUND_TIME

	if(create_new_lighting_timer) // if create_new_lighting_timer = TRUE, a new timer gets set
		special_lighting_active_timer = FALSE

	if(!special_lighting_active_timer)
		if(lighting_stage < max_stages)
			addtimer(CALLBACK(src, PROC_REF(special_lighting_animate), special_lighting, stage_time, max_stages, startup_delay, special_start_time, null, special_tick_dir, FALSE, TRUE, lighting_deactivates), time_til_next_lighting_call, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)
			special_lighting_active_timer = TRUE
		if(lighting_stage == max_stages && lighting_deactivates) // deactives special lighting when the sun hits #000
			addtimer(CALLBACK(src, PROC_REF(special_lighting_unregister_signals)), time_til_next_lighting_call, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)

	if(CEILING_IS_PROTECTED(lighting_mob_area?.ceiling, CEILING_PROTECTION_TIER_2)) //if underground, don't animate, this is needed in combo with the special area check
		return
	if(!is_ground_level(z) && special_call != Z_CHANGE_CALL) // dont animate if not groundlevel
		return

	if(special_stage_time)
		stage_time = special_stage_time

	animate(screen, color = lighting_color, time = stage_time)

/mob/proc/special_lighting_register_signals()

	RegisterSignal(src, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(special_lighting_z_change), TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_ENTERED_AREA, PROC_REF(special_lighting_area_change), TRUE)


/mob/proc/special_lighting_unregister_signals()

	special_lighting = null //clears special lighting

	UnregisterSignal(src, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(special_lighting_z_change))
	UnregisterSignal(src, COMSIG_MOVABLE_ENTERED_AREA, PROC_REF(special_lighting_area_change))


/mob/proc/special_lighting_z_change(atom/source, old_z, new_z)
	SIGNAL_HANDLER

	var/atom/movable/screen/fullscreen/screen = fullscreens["lighting_backdrop"]

	var/stage_time = 30 SECONDS
	var/max_stages = null
	var/startup_delay = 10 SECONDS
	var/special_start_time = 0
	var/special_stage_time = 0.1 SECONDS
	var/special_tick_dir = 0
	var/special_call = Z_CHANGE_CALL
	var/create_new_lighting_timer = FALSE
	var/lighting_deactivates = TRUE

	if(!special_lighting || special_lighting == SPECIAL_LIGHTING_PREROUND)
		return

	switch(special_lighting) //figure out a way of handling this better if possible
		if(SPECIAL_LIGHTING_SUNSET)
			max_stages = 9
			special_tick_dir = 1
		if(SPECIAL_LIGHTING_SUNRISE)
			max_stages = 6
			special_start_time = GLOB.sunrise_starting_time
			special_tick_dir = -1
			lighting_deactivates = FALSE

	if(is_ground_level(new_z))
		special_lighting_animate(special_lighting, stage_time, max_stages, startup_delay, special_start_time, special_stage_time, special_tick_dir, special_call, create_new_lighting_timer, lighting_deactivates)

	if(!is_ground_level(new_z))
		animate(screen, color = "#000", time = 0.1 SECONDS)


/mob/proc/special_lighting_area_change(atom/source, old_area, new_area)
	SIGNAL_HANDLER

	var/atom/movable/screen/fullscreen/screen = fullscreens["lighting_backdrop"]

	var/stage_time = 30 SECONDS
	var/max_stages = null
	var/startup_delay = 10 SECONDS
	var/special_start_time = 0
	var/special_stage_time = 4 SECONDS
	var/special_tick_dir = 0
	var/special_call = AREA_CHANGE_CALL
	var/create_new_lighting_timer = FALSE
	var/lighting_deactivates = TRUE


	if(!special_lighting || special_lighting == SPECIAL_LIGHTING_PREROUND)
		return

	switch(special_lighting)
		if(SPECIAL_LIGHTING_SUNSET)
			max_stages = 9
			special_tick_dir = 1
		if(SPECIAL_LIGHTING_SUNRISE)
			max_stages = 6
			special_start_time = GLOB.sunrise_starting_time
			special_tick_dir = -1
			lighting_deactivates = FALSE


	var/area/mob_old_area = old_area
	var/area/mob_new_area = new_area

	var/oldloc_incave = null
	var/newloc_incave = null

	if(CEILING_IS_PROTECTED(mob_old_area?.ceiling, CEILING_PROTECTION_TIER_2))
		oldloc_incave = TRUE
	if(CEILING_IS_PROTECTED(mob_new_area?.ceiling, CEILING_PROTECTION_TIER_2))
		newloc_incave = TRUE

	if(newloc_incave && !oldloc_incave) //handles both null old loc and false oldloc
		animate(screen, color = "#000", time = 4 SECONDS, easing = QUAD_EASING | EASE_OUT)
	else if(oldloc_incave && !newloc_incave)
		special_lighting_animate(special_lighting, stage_time, max_stages, startup_delay, special_start_time, special_stage_time, special_tick_dir, special_call, create_new_lighting_timer, lighting_deactivates)

#undef Z_CHANGE_CALL
#undef AREA_CHANGE_CALL
