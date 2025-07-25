

/mob
	var/list/fullscreens = list()

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
