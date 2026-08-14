/proc/is_full_water(turf/potential_water)
	if(!isturf(potential_water))
		return FALSE
	if(istype(potential_water, /turf/open))
		var/turf/open/potential_open_water = potential_water
		if(potential_open_water.covered)
			return FALSE
	return (potential_water.turf_flags & TURF_FULL_WATER)

/proc/is_coastline(turf/potential_coastline)
	if(!isturf(potential_coastline))
		return FALSE
	if(istype(potential_coastline, /turf/open))
		var/turf/open/potential_open_coastline = potential_coastline
		if(potential_open_coastline.covered)
			return FALSE
	return  (potential_coastline.turf_flags & TURF_COASTLINE)

/proc/is_water(turf/T)
	return (is_full_water(T) || is_coastline(T))

//////////////////////////////////////////////////////////////////////////////////////////
//		SUBSYSTEM CODE --> Generate the icons at roundstart for the display effects		//
//////////////////////////////////////////////////////////////////////////////////////////

/proc/handle_get_icon(recieved_icon, toxic)		//I love Toxic code!!!
	var/return_icon = recieved_icon
	if(recieved_icon == 'icons/turf/floors/desert_water.dmi')
		if(toxic == 1)
			return_icon ='icons/turf/floors/desert_water_toxic.dmi'
		else if(toxic == -1)
			return_icon = 'icons/turf/floors/desert_water_transition.dmi'
	return return_icon

/proc/handle_toxic_states(turf/in_turf)			//adds duplicate states for toxic water turfs so we can handle toxic states
	var/list/return_list =  list(in_turf.type)
	if(ispath(in_turf, /turf/open/gm/river/desert) || ispath(in_turf, /turf/open/desert/desert_shore))
		return_list += in_turf.type
		return_list += in_turf.type
	return return_list

/* //////////////////////////	GENERATING ICONS TO BE USED IN WATER OVERLAYS	/////////////////////////// generate_water_display_icons()
water turfs are hardcoded to only have certain depths, but the shorelines take from their fulltile varients ---> turf/open var/water_type
so for each water turf we generate a water overlay for each size mobs' textures can have: 32, 48, 64, and 88 ---> texture_sizes
in addition to those for extra deep water turfs we also generate an icon that will cover the mob completely
some mobs look weird with just the default overlay, so for those we generate additional overlays using unique culling masks ---> water_overlay_special
and lastly 2 more overlays for resting humans per waterturf. and there, all the overlays we'll every need all in one neat list :0) */

//currently it generates icons only for turfs on loaded maps, not counting nightmares
//which could concievably be lowered by having coasts of the same depth reroute to the same overlay... oh god, just imagining it hurts

/proc/generate_water_display_icons()
	for(var/starting_type in SSwater_overlays.found_waters)
		var/turf/open/starting_open_turf = starting_type	//if theres a water turf thats not an open turf subtype someones messed up
		if(starting_open_turf.depth == DEPTH_LAND)
			continue       //some turfs are water turfs, but have no depth... meaning no need for an overlay
		var/toxic = -1
		for(var/found_type in handle_toxic_states(starting_open_turf))	//if the water turf can be toxic, we need to add overlays for each possiblity
			toxic++
			var/usable_tox = toxic == 0 ? 0 : (toxic == 1 ? 1 : -1)
			var/working_type = starting_open_turf.water_type ? starting_open_turf.water_type : found_type	//handle rerouting
			var/turf/open/working_T = working_type
			for(var/texture_size in SSwater_overlays.texture_sizes)
				//	V V V V	construct water texture	V V V V
				var/icon/sized_water_texture = icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"],"empty")              //this is what will eventually be our water texture
				var/icon/turf_texture = icon(handle_get_icon(working_T.icon, usable_tox), working_T.icon_state)    //this is the actual texture we'll use to create the water texture
				var/icon/subtraction_texture = icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], "culling_mask") //this is the part of it we'll keep, rest will become "air"
				var/texture_width = sized_water_texture.Width()
				var/pieces = round(texture_width / 32) + (texture_width / 32 > round(texture_width / 32) ? 1 : 0)      //since mobs wont always be 32x32 the water texture will need be build out of 32x32 parts
				for(var/i=0, i<pieces, i++)
					for(var/j=0, j<pieces, j++)
						sized_water_texture.Blend(turf_texture, ICON_OVERLAY, (i*32)+1, (j*32)+1)     //place our 32x32 textures on our water texture every 32 pixels
				if(starting_open_turf.depth == DEPTH_DEEP)
					SSwater_overlays.water_overlay_icons["[texture_size]_[found_type][usable_tox]_u"] = icon(sized_water_texture)	// for the full water overlay

				//	V V V V	construct depthed overlay for mob texture size	V V V V
				var/icon/culled_water = icon(sized_water_texture)
				var/texture_hieght = sized_water_texture.Height()
				subtraction_texture.Shift(SOUTH, (texture_hieght - abs(starting_open_turf.depth)-3), FALSE)         //we move it down to "water level" if we're not using a custom mob culling mask
				culled_water.AddAlphaMask(subtraction_texture)
				SSwater_overlays.water_overlay_icons["[texture_size]_[found_type][usable_tox]"] = culled_water	//this is the default overlays, made according to depth

				//	V V V V	specialized water overlays	V V V V
				var/list/special_mob_masks = SSwater_overlays.water_overlay_special["[texture_size]"]
				for(var/mob_type in special_mob_masks)
					// * HUMANS RESTING * <-- this could be expanded later if someone wants to sprite 2 culling masks for every mob you want them on...
					if(mob_type == /mob/living/carbon/human)
						var/resting_key = starting_open_turf.depth >= -4 ? "coast" : "float"
						var/icon/resting_east = icon(sized_water_texture)
						var/icon/resting_west = icon(sized_water_texture)
						resting_east.AddAlphaMask(icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_e"))
						resting_west.AddAlphaMask(icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_w"))
						SSwater_overlays.water_overlay_icons["32_[found_type][usable_tox]_[mob_type]_e"] =  resting_east
						SSwater_overlays.water_overlay_icons["32_[found_type][usable_tox]_[mob_type]_w"] =  resting_west

					// * water_overlay_special * these mobs look weird with the default overlays, we use special culling masks for them
					if(special_mob_masks[mob_type])
						var/icon/special_icon = icon(sized_water_texture)
						var/icon/special_mask = icon(SSwater_overlays.water_overlay_icon_paths["[texture_size]"], special_mob_masks[mob_type])
						special_icon.AddAlphaMask(special_mask)
						SSwater_overlays.water_overlay_icons["[texture_size]_[found_type][usable_tox]_[mob_type]"] = special_icon

		CHECK_TICK
