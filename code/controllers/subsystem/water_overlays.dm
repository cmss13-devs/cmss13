SUBSYSTEM_DEF(water_overlays)
	name = "Water Overlays"
	init_order = SS_INIT_WATEROVERLAYS
	flags = SS_NO_FIRE
	var/list/turfs_to_process = list()
	var/list/texture_sizes = list(32, 48, 64, 88)
	var/list/found_waters = list()
	var/list/water_overlay_icons = list()
	var/list/water_overlay_special = list(
		"32" = list(
			/mob/living/carbon/human = null,
			/mob/living/carbon/xenomorph/larva = "culling_larva",
		),
		"48" = list(
			/mob/living/carbon/xenomorph/facehugger = "culling_facehugger",
		),
		"64" = list(),
		"88" = list()
	)
	var/list/water_overlay_icon_paths = list(
		"32" = 'icons/effects/water_overlay_effects/_32.dmi',   //humans, etc
		"48" = 'icons/effects/water_overlay_effects/_48.dmi',   //facehugger, drone
		"64" = 'icons/effects/water_overlay_effects/_64.dmi',	//most xenos
		"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	)

/datum/controller/subsystem/water_overlays/Initialize()
	for(var/turf/search_turf in GLOB.turfs)	//we're gonna cut down on the turfs we're gonna check to improve game start lag, ignoring water in nightmares...
		if(is_water(search_turf))
			var/turf/open/found_water = search_turf
			var/turf/open/water_turf = found_water.water_type
			found_waters["[found_water.water_type][water_turf.icon][water_turf.icon_state][found_water.depth]"] = list(water_turf.icon, water_turf.icon_state, found_water.depth, found_water.water_type)
			for(var/direction in GLOB.alldirs)
				var/turf/found_turf = get_step(search_turf, direction)
				if(found_turf && !is_water(found_turf))
					turfs_to_process |= found_turf
		for(var/obj/effect/blocker/water/found_blocker in search_turf.contents)		//blocker/water objects can create water, we need to create overlays for those too
			var/turf/water_blocker_turf = found_blocker.water_type
			found_waters["[found_blocker.water_type][found_blocker.water_type][water_blocker_turf.icon][water_blocker_turf.icon_state][found_blocker.created_depth]"] = list(water_blocker_turf.icon, water_blocker_turf.icon_state, found_blocker.created_depth, found_blocker.water_type)
		CHECK_TICK
	generate_water_display_icons()
	found_waters = list()	//clear for nightmares to add their turfs, we'll generate some for those soon
	RegisterSignal(SSnightmare, COMSIG_NIGHTMARES_PREPARE_GAME_COMPLETE, PROC_REF(update_turfs_layers_near_water))
	return SS_INIT_SUCCESS

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
	generate_water_display_icons() //called again to handle nightmare water turfs (usually redundant or tiny)
	UnregisterSignal(SSnightmare, COMSIG_NIGHTMARES_PREPARE_GAME_COMPLETE)

/datum/controller/subsystem/water_overlays/proc/is_full_water(turf/potential_water)
	if(!istype(potential_water, /turf/open))
		return FALSE
	var/turf/open/potential_open_water = potential_water
	if(potential_open_water.covered || potential_open_water.depth >= DEPTH_LAND)
		return FALSE
	return (potential_water.turf_flags & (TURF_WATER | TURF_WATERLIKE) && potential_open_water.depth <= DEPTH_SHALLOW)

/datum/controller/subsystem/water_overlays/proc/is_coastline(turf/potential_coastline)
	if(!istype(potential_coastline, /turf/open))
		return FALSE
	var/turf/open/potential_open_coastline = potential_coastline
	if(potential_open_coastline.covered || potential_open_coastline.depth >= DEPTH_LAND)
		return FALSE
	return  ((potential_coastline.turf_flags & (TURF_WATER | TURF_WATERLIKE)) && potential_open_coastline.depth >= DEPTH_COAST_INTERMEDIATE)

/datum/controller/subsystem/water_overlays/proc/is_water(turf/potential_water)
	return (is_full_water(potential_water) || is_coastline(potential_water))

/datum/controller/subsystem/water_overlays/proc/handle_toxic_states(in_icon)			//adds duplicate states for toxic water turfs so we can handle toxic states
	if(in_icon == 'icons/turf/floors/desert_water.dmi')
		var/list/return_list = list('icons/turf/floors/desert_water.dmi')
		return_list += 'icons/turf/floors/desert_water_transition.dmi'
		return_list += 'icons/turf/floors/desert_water_toxic.dmi'
		return return_list
	return list(in_icon)

/datum/controller/subsystem/water_overlays/proc/is_layer_underwater_turf(atom/to_check)
	return to_check.layer == UNDER_WATER_TURF_LAYER

/**
*	water turfs are hardcoded to only have certain depths, but the shorelines take from their fulltile varients ---> turf/open var/water_type
*	so for coasts we only generate a very shallow overlay of their fulltile varient, this greatly shrinks the amount we need to make
*	for each of these we generate a water overlay for each size mobs' textures can have: 32, 48, 64, and 88 ---> texture_sizes
*	in addition to those for extra deep water turfs we also generate an icon that will cover the mob completely
*	some mobs look weird with just the default overlay, so for those we generate additional overlays using unique culling masks ---> water_overlay_special
*	and lastly 2 more overlays for resting humans per waterturf. and there, all the overlays we'll every need all in one neat list :0)
*/
/datum/controller/subsystem/water_overlays/proc/generate_water_display_icons()
	for(var/key in SSwater_overlays.found_waters)
		var/list/water_data = SSwater_overlays.found_waters[key]
		var/found_icon = water_data[1]
		var/found_icon_state = water_data[2]
		var/found_depth = water_data[3]
		var/found_type = water_data[4]
		if(found_depth == DEPTH_LAND)	//somehow we got a non water turf in SSwater_overlays.found_waters, it shouldnt get an overlay for it
			continue
		var/toxic = 0	//this works as a iterator... used exclusively for water turfs that use 'icons/turf/floors/desert_water.dmi' which have 2 addtional varients
		for(var/working_icon in handle_toxic_states(found_icon))	//if the water turf can be toxic, we need to run a loop for each possiblity, handle_toxic_states returns a list[1] for waters that dont have that possibility or a list[3] for those that do
			for(var/texture_size in SSwater_overlays.texture_sizes)
				//	V V V V	construct water texture	V V V V
				var/icon/sized_water_texture = icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"],"empty")		//this is what will eventually be our water texture
				var/icon/turf_texture = icon(working_icon, found_icon_state)   													//this is the actual texture we'll use to create the water texture
				var/icon/subtraction_texture = icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], "culling_mask")//this is the part of it we'll keep, rest will become "air"
				var/texture_width = sized_water_texture.Width()
				var/pieces = round(texture_width / 32) + (texture_width / 32 > round(texture_width / 32) ? 1 : 0)      //since mobs wont always be 32x32 the water texture will need be build out of 32x32 parts
				for(var/i=0, i<pieces, i++)
					for(var/j=0, j<pieces, j++)
						sized_water_texture.Blend(turf_texture, ICON_OVERLAY, (i*32)+1, (j*32)+1)     //place our 32x32 textures on our water texture every 32 pixels
				if(found_depth == DEPTH_DEEP)
					SSwater_overlays.water_overlay_icons["[texture_size]_[found_type]_[toxic]_[found_depth]_u"] = icon(sized_water_texture)	// for the full water overlay

				//	V V V V	construct depthed overlay for mob texture size	V V V V
				var/icon/culled_water = icon(sized_water_texture)
				var/texture_height = sized_water_texture.Height()
				subtraction_texture.Shift(SOUTH, (texture_height - abs(found_depth)-3), FALSE)         //we move it down to "water level" if we're not using a custom mob culling mask
				culled_water.AddAlphaMask(subtraction_texture)
				SSwater_overlays.water_overlay_icons["[texture_size]_[found_type]_[toxic]_[found_depth]"] = culled_water	//this is the default overlays, made according to depth

				//	V V V V	specialized water overlays	V V V V
				var/list/special_mob_masks = SSwater_overlays.water_overlay_special["[texture_size]"]
				for(var/mob_type in special_mob_masks)
					// * HUMANS RESTING * <-- this could be expanded later if someone wants to sprite 2 culling masks for every mob you want them on... and splashes
					if(mob_type == /mob/living/carbon/human)
						var/resting_key = found_depth >= -4 ? "coast" : "float"
						var/icon/resting_east = icon(sized_water_texture)
						var/icon/resting_west = icon(sized_water_texture)
						resting_east.AddAlphaMask(icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_e"))
						resting_west.AddAlphaMask(icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_w"))
						SSwater_overlays.water_overlay_icons["32_[found_type]_[toxic]_[found_depth]_[mob_type]_e"] =  resting_east
						SSwater_overlays.water_overlay_icons["32_[found_type]_[toxic]_[found_depth]_[mob_type]_w"] =  resting_west

					// * water_overlay_special * these mobs look weird with the default overlays, we use special culling masks for them
					if(special_mob_masks[mob_type])
						var/icon/special_icon = icon(sized_water_texture)
						var/icon/special_mask = icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], special_mob_masks[mob_type])
						special_icon.AddAlphaMask(special_mask)
						SSwater_overlays.water_overlay_icons["[texture_size]_[found_type]_[toxic]_[found_depth]_[mob_type]"] = special_icon
			toxic = toxic == 0 ? -1 : (toxic == -1 ? 1 : INFINITY)
