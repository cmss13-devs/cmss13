var/list/water_rerouting =  list(
	"/turf/open/gm/coast" = /turf/open/gm/river,			//we use this when putting on the overlay that will cover mobs legs
	"/turf/open/gm/coast/north" = /turf/open/gm/river,		//since if we just used the textures of coasts, part of the overlay would be sand
	"/turf/open/gm/coast/east" = /turf/open/gm/river,		//this table is used to "reroute" those to the type that holds a similar texture
	"/turf/open/gm/coast/south" = /turf/open/gm/river,		//but its completely water;
	"/turf/open/gm/coast/west" = /turf/open/gm/river,		//we use  type because we need icon and icon_state, so two birds with one stone
	"/turf/open/gm/coast/south_east" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner/north_west" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner/north_east" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner/south_east" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner/south_west" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner2" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner2/east" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner2/north_west" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner2/north_east" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner2/south_west" = /turf/open/gm/river,
	"/turf/open/gm/coast/beachcorner2/south_east" = /turf/open/gm/river,
	"/turf/open/gm/grass/grassbeach" = /turf/open/gm/river,
	"/turf/open/gm/grass/grassbeach/north" = /turf/open/gm/river,
	"/turf/open/gm/grass/grassbeach/south" = /turf/open/gm/river,
	"/turf/open/gm/grass/grassbeach/west" = /turf/open/gm/river,
	"/turf/open/gm/grass/grassbeach/east" = /turf/open/gm/river,
	"/turf/open/desert/desert_shore" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/desert_shore1" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/desert_shore1/north" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/desert_shore1/east" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/desert_shore1/west" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner1" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner1/north" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner1/west" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner2" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner2/north" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner2/east" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_corner2/west" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_edge1" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_edge1/north" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_edge1/east" = /turf/open/gm/river/desert/shallow,
	"/turf/open/desert/desert_shore/shore_edge1/west" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/southwest" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/north" = /turf/open/gm/river/desert/deep,
	"/turf/open/gm/river/desert/shallow_edge/east" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/northeast" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/southeast" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/west" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/northwest" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/covered" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/covered/north" = /turf/open/gm/river/desert/deep,
	"/turf/open/gm/river/desert/shallow_edge/covered/east" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/covered/northeast" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_edge/covered/west" = /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_corner" = /turf/open/gm/river/desert/deep,
	"/turf/open/gm/river/desert/shallow_corner/covered"= /turf/open/gm/river/desert/deep,
	"/turf/open/gm/river/desert/shallow_corner/north"= /turf/open/gm/river/desert/deep,
	"/turf/open/gm/river/desert/shallow_corner/east"= /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/river/desert/shallow_corner/west"= /turf/open/gm/river/desert/shallow,
	"/turf/open/gm/coast/dirt" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/north" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/south" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/west" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/east" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner/north_west" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner/north_east" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner/south_east" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner/south_west" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner2" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner2/north_west" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner2/north_east" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner2/south_west" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/beachcorner2/south_east" = /turf/open/gm/river/soro,
	"/turf/open/gm/coast/dirt/forestdir" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestdir/south" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestdir/west" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestdir/east" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner/north_west" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner/north_east" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner/south_east" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner/south_west" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner2" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner2/north_west" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner2/north_east" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner2/south_west" = /turf/open/gm/river/tyrargo,
	"/turf/open/gm/coast/dirt/forestbeachcorner2/south_east" = /turf/open/gm/river/tyrargo,
)

var/list/coastline_water_turfs = list(
	/turf/open/gm/coast,
	/turf/open/gm/coast/north,
	/turf/open/gm/coast/east,
	/turf/open/gm/coast/south,
	/turf/open/gm/coast/west,
	/turf/open/gm/coast/south_east,
	/turf/open/gm/coast/beachcorner,
	/turf/open/gm/coast/beachcorner/north_west,
	/turf/open/gm/coast/beachcorner/north_east,
	/turf/open/gm/coast/beachcorner/south_east,
	/turf/open/gm/coast/beachcorner/south_west,
	/turf/open/gm/coast/beachcorner2,
	/turf/open/gm/coast/beachcorner2/east,
	/turf/open/gm/coast/beachcorner2/north_west,
	/turf/open/gm/coast/beachcorner2/north_east,
	/turf/open/gm/coast/beachcorner2/south_west,
	/turf/open/gm/coast/beachcorner2/south_east,
	/turf/open/gm/grass/grassbeach,
	/turf/open/gm/grass/grassbeach/north,
	/turf/open/gm/grass/grassbeach/south,
	/turf/open/gm/grass/grassbeach/west,
	/turf/open/gm/grass/grassbeach/east,
	/turf/open/desert/desert_shore,
	/turf/open/desert/desert_shore/desert_shore1,
	/turf/open/desert/desert_shore/desert_shore1/north,
	/turf/open/desert/desert_shore/desert_shore1/east,
	/turf/open/desert/desert_shore/desert_shore1/west,
	/turf/open/desert/desert_shore/shore_corner1,
	/turf/open/desert/desert_shore/shore_corner1/north,
	/turf/open/desert/desert_shore/shore_corner1/west,
	/turf/open/desert/desert_shore/shore_corner2,
	/turf/open/desert/desert_shore/shore_corner2/north,
	/turf/open/desert/desert_shore/shore_corner2/east,
	/turf/open/desert/desert_shore/shore_corner2/west,
	/turf/open/desert/desert_shore/shore_edge1,
	/turf/open/desert/desert_shore/shore_edge1/north,
	/turf/open/desert/desert_shore/shore_edge1/east,
	/turf/open/desert/desert_shore/shore_edge1/west,
	/turf/open/desert/cave/cave_shore,
	/turf/open/desert/cave/cave_shore/east,
	/turf/open/desert/cave/cave_shore/northeast,
	/turf/open/desert/cave/cave_shore/southeast,
	/turf/open/gm/coast/dirt,
	/turf/open/gm/coast/dirt/north,
	/turf/open/gm/coast/dirt/south,
	/turf/open/gm/coast/dirt/west,
	/turf/open/gm/coast/dirt/east,
	/turf/open/gm/coast/dirt/beachcorner,
	/turf/open/gm/coast/dirt/beachcorner/north_west,
	/turf/open/gm/coast/dirt/beachcorner/north_east,
	/turf/open/gm/coast/dirt/beachcorner/south_east,
	/turf/open/gm/coast/dirt/beachcorner/south_west,
	/turf/open/gm/coast/dirt/beachcorner2,
	/turf/open/gm/coast/dirt/beachcorner2/north_west,
	/turf/open/gm/coast/dirt/beachcorner2/north_east,
	/turf/open/gm/coast/dirt/beachcorner2/south_west,
	/turf/open/gm/coast/dirt/beachcorner2/south_east,
	/turf/open/gm/coast/dirt/forestdir,
	/turf/open/gm/coast/dirt/forestdir/south,
	/turf/open/gm/coast/dirt/forestdir/west,
	/turf/open/gm/coast/dirt/forestdir/east,
	/turf/open/gm/coast/dirt/forestbeachcorner,
	/turf/open/gm/coast/dirt/forestbeachcorner/north_west,
	/turf/open/gm/coast/dirt/forestbeachcorner/north_east,
	/turf/open/gm/coast/dirt/forestbeachcorner/south_east,
	/turf/open/gm/coast/dirt/forestbeachcorner/south_west,
	/turf/open/gm/coast/dirt/forestbeachcorner2,
	/turf/open/gm/coast/dirt/forestbeachcorner2/north_west,
	/turf/open/gm/coast/dirt/forestbeachcorner2/north_east,
	/turf/open/gm/coast/dirt/forestbeachcorner2/south_west,
	/turf/open/gm/coast/dirt/forestbeachcorner2/south_east,
)

var/list/full_water_turfs = list(
	/turf/open/gm/river,
	/turf/open/gm/river/poison,
	/turf/open/gm/river/darkred_pool,
	/turf/open/gm/river/darkred,
	/turf/open/gm/river/red_pool,
	/turf/open/gm/river/red,
	/turf/open/gm/river/pool,
	/turf/open/gm/river/pool/no_overlay,
	/turf/open/gm/river/shallow_ocean_shallow_ocean,
	/turf/open/gm/river/ocean,
	/turf/open/gm/river/ocean/deep_ocean,
	/turf/open/gm/riverdeep,
	/turf/open/gm/river/desert,
	/turf/open/gm/river/desert/channel,
	/turf/open/gm/river/desert/channel_edge,
	/turf/open/gm/river/desert/channel_three,
	/turf/open/gm/river/desert/deep,
	/turf/open/gm/river/desert/deep/toxic,
	/turf/open/gm/river/desert/deep/covered,
	/turf/open/gm/river/desert/deep/no_slowdown,
	/turf/open/gm/river/desert/shallow,
	/turf/open/gm/river/desert/shallow/covered,
	/turf/open/gm/river/desert/shallow_edge,
	/turf/open/gm/river/desert/shallow_edge/southwest,
	/turf/open/gm/river/desert/shallow_edge/north,
	/turf/open/gm/river/desert/shallow_edge/east,
	/turf/open/gm/river/desert/shallow_edge/northeast,
	/turf/open/gm/river/desert/shallow_edge/southeast,
	/turf/open/gm/river/desert/shallow_edge/west,
	/turf/open/gm/river/desert/shallow_edge/northwest,
	/turf/open/gm/river/desert/shallow_edge/covered,
	/turf/open/gm/river/desert/shallow_edge/covered/north,
	/turf/open/gm/river/desert/shallow_edge/covered/east,
	/turf/open/gm/river/desert/shallow_edge/covered/northeast,
	/turf/open/gm/river/desert/shallow_edge/covered/west,
	/turf/open/gm/river/desert/shallow_corner,
	/turf/open/gm/river/desert/shallow_corner/covered,
	/turf/open/gm/river/desert/shallow_corner/north,
	/turf/open/gm/river/desert/shallow_corner/east,
	/turf/open/gm/river/desert/shallow_corner/west,
	/turf/open/gm/river/desert/tyrargo,
	/turf/open/gm/river/desert/tyrargo/no_slowdown,
	/turf/open/gm/river/desert/tyrargo/covered,
	/turf/open/gm/river/desert/tyrargo/deep,
	/turf/open/gm/river/desert/tyrargo/deep/no_slowdown,
	/turf/open/gm/river/desert/tyrargo/deep/covered,
	/turf/open/gm/river/tyrargo,
	/turf/open/gm/river/soro,
)

/proc/is_full_water(turf/T)
	if(istype(T, /turf/open))
		var/turf/open/OT = T
		if(OT.covered)
			return FALSE
	return (T.type in full_water_turfs)

/proc/is_coastline(turf/T)
	if(istype(T, /turf/open))
		var/turf/open/OT = T
		if(OT.covered)
			return FALSE
	return (T.type in coastline_water_turfs)

/proc/is_water(turf/T)
	return (is_full_water(T) || is_coastline(T))

//////////////////////////////////////////////////////////////////////////////////////////
//		SUBSYSTEM CODE --> Generate the icons at roundstart for the display effects		//
//////////////////////////////////////////////////////////////////////////////////////////

/var/list/texture_sizes = list(32, 48, 64, 88)

//this list holds all the paths of mobs to create special overlays for using unique culling masks instead of the default.
//the boolean is to distinguish from ^^^ above behaviour TRUE and mobs handled by their own dedicated code FALSE.
//each texture size needs to have at least 1 FALSE entry to generate the non unique overlays for that texture size.
GLOBAL_LIST_INIT(water_overlay_special, list(
	"32" = list(
		/mob/living/carbon/human = null,
		/mob/living/carbon/xenomorph/larva = "culling_larva",
	),
	"48" = list(
		/mob/living/carbon/xenomorph/facehugger = "culling_facehugger",
	),
	"64" = list(),
	"88" = list()
))

GLOBAL_LIST_INIT(water_overlay_icon_paths,list(
		"32" = 'icons/effects/water_overlay_effects/_32.dmi',   //humans, etc
		"48" = 'icons/effects/water_overlay_effects/_48.dmi',   //facehugger, drone
		"64" = 'icons/effects/water_overlay_effects/_64.dmi', //most xenos
		"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	))

GLOBAL_LIST_INIT(water_overlay_icons, list())

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
water turfs are hardcoded to only have certain depths, but the shorelines take from their fulltile varients ---> water_rerouting()
so for each water turf we generate a water overlay for each size mobs' textures can have: 32, 48, 64, and 96 ---> texture_sizes
in addition to those for extra deep water turfs we also generate an icon that will cover the mob completely
some mobs look weird with just the default overlay, so for those we generate additional overlays using unique culling masks ---> water_overlay_special
and lastly 2 more overlays for resting humans per waterturf. and there, all the overlays we'll every need all in one neat list :0) */

//maybe this could be improved by only generating water overlay icons for water turfs that are mapped in, but this would get complicated if we paste maps in for events etc
//currently it generates about 1350 icons, which could concievably be lowered by having coasts of the same depth reroute to the same overlay... oh god, just imagining it hurts

/proc/generate_water_display_icons()
	for(var/starting_type in coastline_water_turfs + full_water_turfs)
		var/turf/open/starting_T = starting_type	//if theres a water turf thats not an open turf subtype someones messed up
		if(starting_T.depth == 0)
			continue       //some turfs are water turfs, but have no depth... meaning no need for an overlay
		var/toxic = -1
		for(var/found_type in handle_toxic_states(starting_T))	//if the water turf can be toxic, we need to add overlays for each possiblity
			toxic++
			var/usable_tox = toxic == 0 ? 0 : (toxic == 1 ? 1 : -1)
			var/working_type = water_rerouting["[found_type]"] || found_type	//handle rerouting
			var/turf/open/working_T = working_type
			for(var/texture_size in texture_sizes)
				//	V V V V	construct water texture	V V V V
				var/icon/sized_water_texture = icon(GLOB.water_overlay_icon_paths["[texture_size]"],"empty")              //this is what will eventually be our water texture
				var/icon/turf_texture = icon(handle_get_icon(working_T.icon, usable_tox), working_T.icon_state)    //this is the actual texture we'll use to create the water texture
				var/icon/subtraction_texture = icon(GLOB.water_overlay_icon_paths["[texture_size]"], "culling_mask") //this is the part of it we'll keep, rest will become "air"
				var/w_w = sized_water_texture.Width()
				var/pieces = round(w_w / 32) + (w_w / 32 > round(w_w / 32) ? 1 : 0)      //since mobs wont always be 32x32 the water texture will need be build out of 32x32 parts
				for(var/i=0, i<pieces, i++)
					for(var/j=0, j<pieces, j++)
						sized_water_texture.Blend(turf_texture, ICON_OVERLAY, (i*32)+1, (j*32)+1)     //place our 32x32 textures on our water texture every 32 pixels
				if(starting_T.depth <= -12)
					GLOB.water_overlay_icons["[texture_size]_[found_type][usable_tox]_u"] = icon(sized_water_texture)	// for the full water overlay

				//	V V V V	construct depthed overlay for mob texture size	V V V V
				var/icon/culled_water = icon(sized_water_texture)
				var/w_h = sized_water_texture.Height()
				subtraction_texture.Shift(SOUTH, (w_h - abs(starting_T.depth)-3), FALSE)         //we move it down to "water level" if we're not using a custom mob culling mask
				culled_water.AddAlphaMask(subtraction_texture)
				GLOB.water_overlay_icons["[texture_size]_[found_type][usable_tox]"] = culled_water	//this is the default overlays, made according to depth

				//	V V V V	specialized water overlays	V V V V
				var/list/special_mob_masks = GLOB.water_overlay_special["[texture_size]"]
				for(var/mob_type in special_mob_masks)
					// * HUMANS RESTING * <-- this could be expanded later if someone wants to sprite 2 culling masks for every mob you want them on...
					if(mob_type == /mob/living/carbon/human)
						var/resting_key = starting_T.depth >= -4 ? "coast" : "float"
						var/icon/resting_east = icon(sized_water_texture)
						var/icon/resting_west = icon(sized_water_texture)
						resting_east.AddAlphaMask(icon(GLOB.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_e"))
						resting_west.AddAlphaMask(icon(GLOB.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_w"))
						GLOB.water_overlay_icons["32_[found_type][usable_tox]_[mob_type]_e"] =  resting_east
						GLOB.water_overlay_icons["32_[found_type][usable_tox]_[mob_type]_w"] =  resting_west

					// * water_overlay_special * these mobs look weird with the default overlays, we use special culling masks for them
					if(special_mob_masks[mob_type])
						var/icon/special_icon = icon(sized_water_texture)
						var/icon/special_mask = icon(GLOB.water_overlay_icon_paths["[texture_size]"], special_mob_masks[mob_type])
						special_icon.AddAlphaMask(special_mask)
						GLOB.water_overlay_icons["[texture_size]_[found_type][usable_tox]_[mob_type]"] = special_icon

		CHECK_TICK
