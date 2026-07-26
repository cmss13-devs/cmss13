GLOBAL_DATUM_INIT(sun_status, /datum/sun, new)
///computes sunset and sunrise behavior
/datum/sun
	var/static/list/warm_color_progression = list("#da8b4a", "#a9633c", "#90422d", "#5c2d33", "#42232c", "#231935", "#050c27", "#000")
	var/static/list/cold_color_progression = list("#6679a8", "#516a8b", "#38486e", "#2c2f4d", "#211b36", "#1f1b33", "#0c0a1b", "#000")
	var/static/list/sunrise_color_progression = list("#000", "#040712", "#111322", "#291642", "#3f2239", "#632c3d", "#d89d6d")
	var/list/used_color_progression
	var/is_cold ///are we on snowy planet
	var/p_special_lighting_type = SPECIAL_LIGHTING_SUNSET
	var/stage_time /// how long each stage lasts, don't edit this if you want smooth movement, use special_stage_time instead
	var/lighting_stage = 0
	var/max_stages /// how many stages of special lighting there are, starts at 0
	var/stage ///current stage of the sun
	var/startup_delay /// how long the initial stage lasts for, doesn't factor in round start stuff
	var/sun_behavior_change_time ///when did we set this sun behavior

/datum/sun/proc/start_sun_behavior(behavior = SPECIAL_LIGHTING_SUNSET)
	sun_behavior_change_time = ROUND_TIME
	is_cold = (SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD])
	if(behavior == SPECIAL_LIGHTING_SUNSET)
		stage_time = 30 SECONDS
		max_stages = 9
		startup_delay = 10 SECONDS
		if(is_cold)
			used_color_progression = cold_color_progression
		else
			used_color_progression = warm_color_progression

	if(behavior == SPECIAL_LIGHTING_SUNRISE)
		stage_time = 30 SECONDS
		max_stages = 7
		startup_delay = 10 SECONDS
		used_color_progression = sunrise_color_progression

	handle_player_light()

	addtimer(CALLBACK(src, PROC_REF(progress_light)), time_till_next_call())

/datum/sun/proc/handle_player_light()
	//todo

/datum/sun/proc/progress_light()
	if(stage == max_stages)
		return
	stage ++
	addtimer(CALLBACK(src, PROC_REF(progress_light)), time_till_next_call())

/datum/sun/proc/time_till_next_call()
	return max(((lighting_stage * stage_time) + startup_delay + sun_behavior_change_time - ROUND_TIME), 0.5 SECONDS) /// how long until the next sunstage occurs (minimum of 0.5 seconds)

//not rly needed as we keep the current stage here
/datum/sun/proc/compute_stage()
	var/lighting_stage = clamp((floor((ROUND_TIME - sun_behavior_change_time + stage_time - startup_delay)/stage_time)), 0, max_stages) /// the current stage of the lighting, ticks up by 1 every stagetime after startup_delay + start_time
	return lighting_stage

/datum/sun/proc/should_animate(mob/living/mob_in_light)
	var/area/lighting_mob_area = get_area(mob_in_light)
	if(CEILING_IS_PROTECTED(lighting_mob_area?.ceiling, CEILING_PROTECTION_TIER_2)) //if underground, don't animate, this is needed in combo with the special area check
		return FALSE
	if(!is_ground_level(mob_in_light.z)) // dont animate if not groundlevel
		return FALSE
	return TRUE


/datum/sun/proc/initialize_current_stage(mob/living/mob_in_light)
	//add start of tracking progression
	if(should_animate(mob_in_light))
		var/atom/movable/screen/fullscreen/screen = mob_in_light.fullscreens["lighting_backdrop"]
		screen.color = used_color_progression[compute_stage()]
