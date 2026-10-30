SUBSYSTEM_DEF(water_overlays)
	name = "Water Overlays"
	init_order = SS_INIT_WATEROVERLAYS
	flags = SS_NO_FIRE
	/// the master list, holds all the water overlays (sprites) used by water_overlay_effect components
	var/list/water_overlay_icons = list()
	/// this list gets an entry for each water turf that already has had overlays generated for it
	var/list/generated_water_overlays = list()
	/// this holds a list of all datum/water_overlay_config types, ordered by sprite size (used for generating the overlays)
	var/list/configs_by_size = list(
		"32" = list(),
		"48" = list(),
		"64" = list(),
		"88" = list(),
	)
	/// this holds paths to the dmis used by each config size
	var/list/icon_paths = list(
		"32" = 'icons/effects/water_overlay_effects/_32.dmi',   //humans, etc
		"48" = 'icons/effects/water_overlay_effects/_48.dmi',   //facehugger, drone
		"64" = 'icons/effects/water_overlay_effects/_64.dmi',	//most xenos
		"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	)


/datum/controller/subsystem/water_overlays/Initialize()
	// This MUST stay early — turfs call generate_water_overlay during their Initialize (the configs_by_size needs to have been populated by then)
	for(var/datum/water_overlay_config/config_type as anything in subtypesof(/datum/water_overlay_config))
		var/size = "[initial(config_type.icon_size)]"
		if(!configs_by_size[size])
			stack_trace("water_overlay_config [config_type] has unsupported icon_size [size]")
			continue
		configs_by_size[size] += config_type
	return SS_INIT_SUCCESS


/datum/controller/subsystem/water_overlays/proc/is_water(turf/potential_water)
	if(isnull(potential_water) || !istype(potential_water, /turf/open))
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


/**
 * update_turfs_layers_near_water()
 * Goes through the given water turf's neighbors and adjusts layering on adjacent non-water turfs.
 * We lower mob layers while in water so they render under turfs to their south (making them look submerged
 * under the bank). For the northern shore this would incorrectly make tall mobs standing on land clip under
 * the water, so those land turfs (and the ones flanking them) are pushed further down instead.
 * Turfs already sit below everything else visually, so the only effect is preventing the unwanted clip.
 */
/datum/controller/subsystem/water_overlays/proc/update_turfs_layers_near_water(turf/water_turf)
	var/list/turfs_to_process = list()
	var/list/relayered_turfs = list()

	for(var/direction in GLOB.alldirs)
		var/turf/found_turf = get_step(water_turf, direction)
		if(found_turf && !is_water(found_turf))
			turfs_to_process |= found_turf

	for(var/turf/current_turf as anything in turfs_to_process)
		if(current_turf in relayered_turfs)
			continue
		relayered_turfs |= current_turf.near_water_layering_fix(relayered_turfs)

	for(var/turf/current_turf as anything in relayered_turfs)
		current_turf.near_water_layering_cleanup()


#define ADDITIONAL_DEPTH_OFFSET 3


/**
*	Water turfs do not have built in overlays anymore. They are now added directly on mobs upon entering these water turfs, handled by the component: /datum/component/water_overlay_effect
*	Its unfesible to generate an overlay everytime a mob enters water, instead each water turf calles this proc to generate them all when all the atoms are first initialized..
*	and the results are added into a list in this subsystem to be fetched by the water_overlay components when needed: SSwater_overlays.water_overlay_icons
*
*	Every water turf uses a var water_type which is necessary because of water turfs like coasts, using their icon would add sand/dirt/grass into the water overlay texture
*	Since every water turf is calling this proc on their init, we use generated_water_overlays and their depth and water_type as a key; determining if its already ran or not
*
*	Not every mob gets the same overlay, theres about 6 different sprite sizes mobs have, and lots behave differently in water and so need additional/different overlays.. e.g. humans resting in water
*	So we use datum/water_overlay_config to inform each water turf what overlays we need (every mob ought to have one, or they ought not get a water overlay)
*	for each config we check if the turf's depth applies and generate an overlay accordingly (some mobs ignore water while resting as some depths, or only use one overlay regardless of depth)
*
*	we use |= when adding overlays to eliminate duplicates, and since this proc is only ran once after the water turfs are initialized.. not to mention all congfigs complicating things
*	coding checks for duplicates before running the logic seems not really worth the investment
*
*	ADDITIONAL NOTES:
*	Because coasts generate overlays based off their water_type and because many coasts share the same depth, instead of having 8 or 12 overlays generated for every coast type we basically only generate 3(one for each coast depth)
*	@param input_icons should be a list of all the different icons the water turf uses (get_all_possible_icon_files)
*	@param water_type should be the water_type var all water turfs have
*	@param input_depth should be the depth var all water turfs have
*/
/datum/controller/subsystem/water_overlays/proc/generate_water_overlay(list/input_icons, water_type, input_depth)
	if(input_depth >= WATER_DEPTH_COAST_DEPTHLESS)
		return
	if(generated_water_overlays["[water_type]_[input_depth]"])
		return
	generated_water_overlays["[water_type]_[input_depth]"] = TRUE
	var/turf/open/water_turf = water_type
	var/found_icon_state = water_turf.icon_state
	var/toxic = WATER_TOXIC_NO	//this works as a iterator... used exclusively for water turfs that use 'icons/turf/floors/desert_water.dmi' which have 2 addtional varients
	for(var/working_icon in input_icons)	//if the water turf can be toxic, we need to run a loop for each possiblity, thus this is a list
		for(var/texture_size in configs_by_size)
			var/list/configs_of_this_size = configs_by_size[texture_size]
			if(!length(configs_of_this_size))
				continue

			for(var/datum/water_overlay_config/config as anything in configs_of_this_size)	//could be streamlined by removing configs thatd result in the same overlays being generated
				//	V V V V	construct water texture	V V V V
				var/icon/sized_water_texture = icon(icon_paths["[config.icon_size]"],"empty")		//this is what will eventually be our water texture
				var/icon/turf_texture = icon(working_icon, found_icon_state)   													//this is the actual texture we'll use to create the water texture
				var/icon/subtraction_texture = icon(icon_paths["[config.icon_size]"], "culling_mask")//this is the part of it we'll keep, rest will become "air"
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
					resting_overlay.AddAlphaMask(icon(icon_paths["[config.icon_size]"], "culling_[config.icon_state_key]_resting_[resting_key]"))
					SSwater_overlays.water_overlay_icons["32_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]_resting"] = resting_overlay
				else if(config.resting_behavior == WATER_OVERLAY_CONFIG_RESTING_ANGLED)
					var/icon/resting_east = icon(sized_water_texture)
					var/icon/resting_west = icon(sized_water_texture)
					resting_east.AddAlphaMask(icon(icon_paths["[config.icon_size]"], "culling_[config.icon_state_key]_resting_[resting_key]_e"))
					resting_west.AddAlphaMask(icon(icon_paths["[config.icon_size]"], "culling_[config.icon_state_key]_resting_[resting_key]_w"))
					SSwater_overlays.water_overlay_icons["32_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]_resting_e"] = resting_east
					SSwater_overlays.water_overlay_icons["32_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]_resting_w"] = resting_west

				//	V V V V	specialized water overlays	V V V V
				if(config.special_culling_mask)	// * water_overlay_special * these mobs look weird with the default overlays, we use special culling masks for them
					var/icon/special_icon = icon(sized_water_texture)
					var/icon/special_mask = icon(icon_paths["[config.icon_size]"], "culling_[config.icon_state_key]")
					special_icon.AddAlphaMask(special_mask)
					SSwater_overlays.water_overlay_icons["[texture_size]_[water_type]_[toxic]_[input_depth]_[config.icon_state_key]"] = special_icon

		toxic = toxic == WATER_TOXIC_NO ? WATER_TOXIC_DISPERSING : WATER_TOXIC_YES


#undef ADDITIONAL_DEPTH_OFFSET
