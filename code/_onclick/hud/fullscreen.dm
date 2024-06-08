

/mob
	var/list/fullscreens = list()

	///If a type of special lighting such as a sunset or lightning is currently active, dont have more than one of these without a special fullscreen framework
	var/special_lighting = null

/mob/proc/overlay_fullscreen(category, type, severity)
	var/atom/movable/screen/fullscreen/screen = fullscreens[category]
	if (!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, FALSE)
		fullscreens[category] = screen = new type()
	else if ((!severity || severity == screen.severity) && (!client || screen.screen_loc != "CENTER-7,CENTER-7" || screen.fs_view == client.view))
		// doesn't need to be updated
		return screen

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
			if(screen.should_show_to(src))
				screen.update_for_view(client.view)
				client.add_to_screen(screen)
			else
				client.remove_from_screen(screen)

/mob/proc/initialize_special_lighting() //initialized on hud.dm when a new mob is spawned so you can't dodge this unless you dont have a client somehow
	if(!SSticker.mode)
		if(special_lighting)
			return
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(initialize_special_lighting)))
		debug_msg("sunset call has been called on [src] but delayed to roundstart")
		special_lighting = "sunset"	// technically setting it early, but it shouldnt effect anything
		return
	if(SSticker.mode.flags_round_type & MODE_SUNSET)
		if(fullscreens.len == 0)
			return
		addtimer(CALLBACK(src, PROC_REF(sunset)), 3 SECONDS) // 3 seconds for them to spawn in and other lighting stuff to load
		special_lighting = "sunset"
		debug_msg("sunset proc will be called on [src] in 3 seconds")


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


/mob/proc/sunset(special_stage_time = null, special_call = FALSE)

	var/atom/movable/screen/fullscreen/screen = fullscreens["lighting_backdrop"]
	var/mob/lighting_mob = src
	var/area/lighting_mob_area = get_area(lighting_mob)

	if(!lighting_mob.client)
		return

	var/sun_color = "#000" /// used in the animation, set by sun stage and maptype
	var/stage_time = 30 SECONDS /// how long each stage lasts, don't edit this if you want smooth movement, use special_stage_time instead
	var/max_stages = 9 /// how many stages of sunset there are, starts at 0

	var/startup_delay = 10 SECONDS /// how long the initial stage lasts for, doesn't factor in round start stuff

	var/sun_stage = clamp((floor((ROUND_TIME + stage_time - startup_delay)/stage_time)), 0, max_stages) /// the current stage of the sun, ticks up by 1 every stagetime after startup_delay
	//uses formula (x + y - z)/(y) with x = round_time, y = stage_time, and z being startup_delay

	var/time_til_next_suncall = (sun_stage * stage_time) + startup_delay - ROUND_TIME /// how long until the next sunstage occurs

	if(special_call)
		sun_stage = clamp((sun_stage + 1), 0, max_stages) //you gotta start at the next stage if you come in during the duration of one in order to prevent advantages, more stages make this look better

	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD || ZTRAIT_IN_SPACE] || SSmapping.configs[GROUND_MAP].map_name == MAP_LV522_CHANCES_CLAIM) //if its cold or in space (or chances claim)
		switch(sun_stage) //for sun stages, the more you have the better it looks when special called, I recommend choosing cinematic 4 colors then using a gradient tool to pick out the rest
			if(0)
				sun_color = "#a8c3cf"
				special_stage_time = 0.5 SECONDS
				time_til_next_suncall = startup_delay
			if(1)
				sun_color = "#718faf"
			if(2)
				sun_color = "#5e71a0"
			if(3)
				sun_color = "#414b70"
			if(4)
				sun_color = "#303e61"
			if(5)
				sun_color = "#292b48"
			if(6)
				sun_color = "#211b36"
			if(7)
				sun_color = "#1f1b33"
			if(8)
				sun_color = "#0c0a1b"
			if(9)
				sun_color = "#000"
	else //a warm sunset for anywhere else
		switch(sun_stage)
			if(0)
				sun_color = "#e3a979"
				special_stage_time = 0.5 SECONDS
				time_til_next_suncall = startup_delay
			if(1)
				sun_color = "#e29658"
			if(2)
				sun_color = "#da8b4a"
			if(3)
				sun_color = "#a9633c"
			if(4)
				sun_color = "#90422d"
			if(5)
				sun_color = "#68333a"
			if(6)
				sun_color = "#4d2b35"
			if(7)
				sun_color = "#231935"
			if(8)
				sun_color = "#050c27"
			if(9)
				sun_color = "#000"

	debug_msg("sunset has been called")


	debug_msg("(sun_stage * stage_time) + startup_delay - ROUND_TIME = ([(sun_stage * stage_time)/10]) + [startup_delay/10] - [ROUND_TIME/10]")
	debug_msg("*------*")

	debug_msg("roundtime = [ROUND_TIME/10] seconds, sun_stage = [sun_stage], ")

	if(sun_stage < max_stages) // calls for the next sunset
		debug_msg("next suncall in [time_til_next_suncall/10] seconds")
		addtimer(CALLBACK(lighting_mob, PROC_REF(sunset)), time_til_next_suncall, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)
	if(sun_stage == max_stages) // deactives special lighting when the sun hits #000
		addtimer(VARSET_CALLBACK(lighting_mob, special_lighting, null), time_til_next_suncall)

	if(CEILING_IS_PROTECTED(lighting_mob_area.ceiling, CEILING_PROTECTION_TIER_2)) //if underground, don't animate
		return
	if(!is_ground_level(lighting_mob.z)) // dont animate if not groundlevel
		return

	if(special_stage_time)
		stage_time = special_stage_time

	animate(screen, color = sun_color, time = stage_time)


/mob/proc/sunrise(special_stage_time = null, special_call = FALSE)

	var/atom/movable/screen/fullscreen/screen = fullscreens["lighting_backdrop"]
	var/mob/lighting_mob = src
	var/area/lighting_mob_area = get_area(lighting_mob)

	if(!lighting_mob.client || lighting_mob.special_lighting == "sunset")
		return //failsafes

	if(!GLOB.sunrise_starting_time) //failsafe incase sunrise gets called without a sunrise time set
		(GLOB.sunrise_starting_time = ROUND_TIME)

	var/sun_color = "#000" //saftey
	var/stage_time = 60 SECONDS
	var/max_stages = 3

	var/current_time = ROUND_TIME

	var/sun_stage = clamp((floor((GLOB.sunrise_starting_time - current_time)/stage_time)), 0, max_stages)

	if(special_call)
		sun_stage = clamp((sun_stage - 1), 0, max_stages) //you gotta start at the next stage if you come in during the duration of one in order to prevent advantages

	switch(sun_stage)
		if(0)
			special_stage_time = 0.5 SECONDS //DONT FORGET TO ADD MORE STAGES, 4 IS NOT ENOUGH
			sun_color = "#000" //a special confirmation to make sure that sunrise starts on full black
		if(1)
			sun_color = "#111322"
		if(2)
			sun_color = "#4e333d"
		if(3)
			sun_color = "#bb542b" //it ends on very orange for cinematics

	lighting_mob.special_lighting = "sunrise" //sunrise is called a few different places instead of a single place so its easier to set it internally

	if(sun_stage == 0) //get ddone with the first one fast then instantly call back
		addtimer(CALLBACK(lighting_mob, PROC_REF(sunset)), special_stage_time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)
	else if(sun_stage < max_stages)
		addtimer(CALLBACK(lighting_mob, PROC_REF(sunrise)), (((stage_time * sun_stage)) - GLOB.sunrise_starting_time), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)
	if(sun_stage == max_stages) // deactives special lighting when the sun hits #bb542b
		addtimer(VARSET_CALLBACK(lighting_mob, special_lighting, null), stage_time)

	if(CEILING_IS_PROTECTED(lighting_mob_area?.ceiling, CEILING_PROTECTION_TIER_2)) //if underground, don't animate
		return
	if(!is_ground_level(lighting_mob.z)) // dont animate if not groundlevel
		return

	if(special_stage_time)
		stage_time = special_stage_time

	animate(screen, color = sun_color, time = stage_time)


/mob/proc/special_lighting_listeners()
	SIGNAL_HANDLER

	var/mob/signaling_mob = src
	if(signaling_mob.special_lighting && signaling_mob.client)
		RegisterSignal(signaling_mob, COMSIG_MOVABLE_MOVED, PROC_REF(special_lighting_change))




/mob/proc/special_lighting_change()

	var/atom/movable/screen/fullscreen/screen = fullscreens["lighting_backdrop"]
	var/mob/lighting_mob = src

	var/oldloc_z = oldloc.z
	var/newloc_z = lighting_mob.z

	if(!oldloc_z == newloc_z)
		if(!is_ground_level(newloc_z))
			animate(screen, color = "#000", time = 0.2 SECONDS, easing = QUAD_EASING | EASE_OUT) //its gotta be fast but not sudden
		else if(is_ground_level(newloc_z))
			switch(lighting_mob.special_lighting)
				if("sunset")
					lighting_mob.sunset(0.2 SECONDS, TRUE)
				if("sunrise")
					lighting_mob.sunrise(0.2 SECONDS, TRUE)

	var/oldloc_area = get_area(oldloc)
	var/newloc_area = get_area(lighting_mob)

	if(!oldloc_area == newloc_area) //dont gotta continue if its the same area

		var/oldloc_incave
		var/newloc_incave

		if(CEILING_IS_PROTECTED(oldloc_area?.ceiling, CEILING_PROTECTION_TIER_2))
			oldloc_incave = TRUE
		if(CEILING_IS_PROTECTED(newloc_area?.ceiling, CEILING_PROTECTION_TIER_2))
			newloc_incave = TRUE

		if(newloc_incave && !oldloc_incave)
			animate(screen, color = "#000", time = 5 SECONDS, easing = QUAD_EASING | EASE_OUT) // 6 seconds no matter sunrise or sunset
		else if(oldloc_incave && !newloc_incave)
			switch(lighting_mob.special_lighting)
				if("sunset")
					lighting_mob.sunset(6 SECONDS, TRUE)
				if("sunrise")
					lighting_mob.sunrise(6 SECONDS, TRUE)



/atom/movable/screen/fullscreen/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	layer = LIGHTING_PRIMARY_LAYER
	blend_mode = BLEND_ADD
	show_when_dead = TRUE
