SUBSYSTEM_DEF(water_overlays)
	name = "Water Overlays"
	init_order = SS_INIT_WATEROVERLAYS
	flags = SS_NO_FIRE
	var/list/turfs_to_process = list()
	var/list/texture_sizes = list(32, 48, 64, 88)
	var/list/generated_water_overlays = list()
	var/list/water_overlay_icons = list()
	var/list/configs_by_size = list(
		"32" = list(),
		"48" = list(),
		"64" = list(),
		"88" = list(),
	)
	var/list/icon_paths = list(
		"32" = 'icons/effects/water_overlay_effects/_32.dmi',   //humans, etc
		"48" = 'icons/effects/water_overlay_effects/_48.dmi',   //facehugger, drone
		"64" = 'icons/effects/water_overlay_effects/_64.dmi',	//most xenos
		"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	)


/datum/controller/subsystem/water_overlays/Initialize()
	for(var/turf/search_turf in GLOB.turfs)	//we're gonna cut down on the turfs we're gonna check to improve game start lag, ignoring water in nightmares...
		if(is_water(search_turf))
			for(var/direction in GLOB.alldirs)
				var/turf/found_turf = get_step(search_turf, direction)
				if(found_turf && !is_water(found_turf))
					turfs_to_process |= found_turf
		CHECK_TICK
	for(var/datum/water_overlay_config/config_type as anything in subtypesof(/datum/water_overlay_config))
		var/size = "[initial(config_type.icon_size)]"
		if(!configs_by_size[size])
			stack_trace("water_overlay_config [config_type] has unsupported icon_size [size]")
			continue
		configs_by_size[size] += config_type
	RegisterSignal(SSnightmare, COMSIG_NIGHTMARES_PREPARE_GAME_COMPLETE, PROC_REF(update_turfs_layers_near_water))
	return SS_INIT_SUCCESS


/datum/controller/subsystem/water_overlays/proc/get_icon_path(icon_size)
	return icon_paths["[icon_size]"]


/datum/controller/subsystem/water_overlays/proc/is_water(turf/potential_water)
	if(potential_water == null || !istype(potential_water, /turf/open))
		return FALSE
	var/turf/open/potential_open_water = potential_water
	if(potential_open_water.covered || potential_open_water.depth >= WATER_DEPTH_LAND || potential_open_water.turf_flags & TURF_CATWALKED)
		return FALSE
	return potential_water.turf_flags & (TURF_WATER | TURF_WATERLIKE)


/datum/controller/subsystem/water_overlays/proc/is_full_water(turf/potential_water)
	if(!is_water(potential_water))
		return FALSE
	var/turf/open/potential_open_water = potential_water
	return potential_open_water.depth <= WATER_DEPTH_SHALLOW


/datum/controller/subsystem/water_overlays/proc/is_coastline(turf/potential_coastline)
	if(!is_water(potential_coastline))
		return FALSE
	var/turf/open/potential_open_coastline = potential_coastline
	return potential_open_coastline.depth >= WATER_DEPTH_COAST_INTERMEDIATE


/datum/controller/subsystem/water_overlays/proc/handle_toxic_states(in_icon)			//adds duplicate states for toxic water turfs so we can handle toxic states
	if(in_icon == 'icons/turf/floors/desert_water.dmi')
		var/list/return_list = list('icons/turf/floors/desert_water.dmi')
		return_list += 'icons/turf/floors/desert_water_transition.dmi'
		return_list += 'icons/turf/floors/desert_water_toxic.dmi'
		return return_list
	return list(in_icon)


/datum/controller/subsystem/water_overlays/proc/is_layer_underwater_turf(atom/to_check)
	return to_check.layer == UNDER_WATER_TURF_LAYER


/**	update_turfs_layers_near_water()
*		this proc and those it call go through every turf in the game, and check if its near water
*		we need to do this because we alter the layer of mob in water so they appear below turfs south of them
*		but since we dont want this visual for when tall mobs stand on the northern shore of a body of water
*		we have to change the layer of these turfs to below the mobs' in water
*		this is fine since turfs are visually rendered below everything usually, changing their layer to further down..
*		shouldnt affect anything other than making mobs in water not clip below them
*/
/datum/controller/subsystem/water_overlays/proc/update_turfs_layers_near_water()
	SIGNAL_HANDLER
	var/list/altered_turfs = list()
	for(var/turf/current_turf in turfs_to_process)
		if(current_turf in altered_turfs)
			continue
		altered_turfs |= current_turf.near_water_layering_fix(altered_turfs)
	for(var/turf/current_turf in altered_turfs)
		current_turf.near_water_layering_cleanup()
	UnregisterSignal(SSnightmare, COMSIG_NIGHTMARES_PREPARE_GAME_COMPLETE)


#define ADDITIONAL_DEPTH_OFFSET 3


/**
*	water turfs are hardcoded to only have certain depths, but the shorelines take from their fulltile varients ---> turf/open var/water_type
*	so for coasts we only generate a very shallow overlay of their fulltile varient, this greatly shrinks the amount we need to make
*	for each of these we generate a water overlay for each size mobs' textures can have: 32, 48, 64, and 88 ---> texture_sizes
*	in addition to those for extra deep water turfs we also generate an icon that will cover the mob completely
*	some mobs look weird with just the default overlay, so for those we generate additional overlays using unique culling masks ---> water_overlay_special
*	and lastly 2 more overlays for resting humans per waterturf. and there, all the overlays we'll every need all in one neat list :0)
*/
/datum/controller/subsystem/water_overlays/proc/generate_water_overlay(water_type, input_depth)
	if(generated_water_overlays["[water_type]_[input_depth]"])
		return
	generated_water_overlays["[water_type]_[input_depth]"] = TRUE
	var/turf/open/water_turf = water_type
	var/found_icon = water_turf.icon
	var/found_icon_state = water_turf.icon_state
	var/toxic = WATER_TOXIC_NO	//this works as a iterator... used exclusively for water turfs that use 'icons/turf/floors/desert_water.dmi' which have 2 addtional varients
	for(var/working_icon in handle_toxic_states(found_icon))	//if the water turf can be toxic, we need to run a loop for each possiblity, handle_toxic_states returns a list[1] for waters that dont have that possibility or a list[3] for those that do
		for(var/texture_size in configs_by_size)
			var/list/configs_of_this_size = configs_by_size[texture_size]
			if(!length(configs_of_this_size))
				continue
			for(var/datum/water_overlay_config/config as anything in configs_of_this_size)	//could be streamlined by removing configs thatd result in the same overlays being generated
				//	V V V V	construct water texture	V V V V
				var/icon/sized_water_texture = icon(SSwater_overlays.get_icon_path(config.icon_size),"empty")		//this is what will eventually be our water texture
				var/icon/turf_texture = icon(working_icon, found_icon_state)   													//this is the actual texture we'll use to create the water texture
				var/icon/subtraction_texture = icon(SSwater_overlays.get_icon_path(config.icon_size), "culling_mask")//this is the part of it we'll keep, rest will become "air"
				var/texture_width = sized_water_texture.Width()
				var/pieces = round(texture_width / 32) + (texture_width / 32 > round(texture_width / 32) ? 1 : 0)      //since mobs wont always be 32x32 the water texture will need be build out of 32x32 parts
				for(var/i=0, i<pieces, i++)
					for(var/j=0, j<pieces, j++)
						sized_water_texture.Blend(turf_texture, ICON_OVERLAY, (i*32)+1, (j*32)+1)     //place our 32x32 textures on our water texture every 32 pixels
				if((config.immerse_behavior != WATER_OVERLAY_CONFIG_IMMERSE_NONE || config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_IMMERSE) && input_depth <= config.immerse_at_depth)
					SSwater_overlays.water_overlay_icons["[texture_size]_[water_type]_[toxic]_[input_depth]_immersed"] = icon(sized_water_texture)	// for the full water overlay
				//	V V V V	construct depthed overlay for mob texture size	V V V V
				var/icon/culled_water = icon(sized_water_texture)
				var/texture_height = sized_water_texture.Height()
				subtraction_texture.Shift(SOUTH, (texture_height + input_depth - ADDITIONAL_DEPTH_OFFSET), FALSE)         //we move it down to "water level" if we're not using a custom mob culling mask
				culled_water.AddAlphaMask(subtraction_texture)
				SSwater_overlays.water_overlay_icons["[texture_size]_[water_type]_[toxic]_[input_depth]"] = culled_water	//this is the default overlays, made according to depth
				//	V V V V	resting overlays	V V V V
				var/resting_key = input_depth >= WATER_DEPTH_COAST_INTERMEDIATE ? "coast" : "deep"
				if(config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_SOME)
					var/icon/resting_overlay = icon(sized_water_texture)
					resting_overlay.AddAlphaMask(icon(SSwater_overlays.get_icon_path(config.icon_size), "culling_[config.icon_state_key]_resting_[resting_key]"))
					SSwater_overlays.water_overlay_icons["32_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]_resting"] = resting_overlay
				else if(config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_ANGLED)
					var/icon/resting_east = icon(sized_water_texture)
					var/icon/resting_west = icon(sized_water_texture)
					resting_east.AddAlphaMask(icon(SSwater_overlays.get_icon_path(config.icon_size), "culling_[config.icon_state_key]_resting_[resting_key]_e"))
					resting_west.AddAlphaMask(icon(SSwater_overlays.get_icon_path(config.icon_size), "culling_[config.icon_state_key]_resting_[resting_key]_w"))
					SSwater_overlays.water_overlay_icons["32_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]_resting_e"] = resting_east
					SSwater_overlays.water_overlay_icons["32_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]_resting_w"] = resting_west
				//	V V V V	specialized water overlays	V V V V
				if(config.special_culling_mask)	// * water_overlay_special * these mobs look weird with the default overlays, we use special culling masks for them
					var/icon/special_icon = icon(sized_water_texture)
					var/icon/special_mask = icon(SSwater_overlays.get_icon_path(config.icon_size), "culling_[config.icon_state_key]")
					special_icon.AddAlphaMask(special_mask)
					SSwater_overlays.water_overlay_icons["[texture_size]_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]"] = special_icon
		toxic = toxic == WATER_TOXIC_NO ? WATER_TOXIC_DISPERSING : WATER_TOXIC_YES


#undef ADDITIONAL_DEPTH_OFFSET
