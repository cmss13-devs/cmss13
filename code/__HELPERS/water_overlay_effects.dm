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
	/turf/open/gm/river/no_overlay,
	/turf/open/gm/river/no_overlay/sewage,
	/turf/open/gm/river/desert,
	/turf/open/gm/river/desert/shallow,
	/turf/open/gm/river/desert/deep/toxic,
	/turf/open/gm/river/desert/deep/covered,
	/turf/open/gm/river/desert/deep/no_slowdown,
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
	/turf/open/gm/river/desert/deep,
	/turf/open/gm/river/tyrargo,
	/turf/open/gm/river/soro,
)

/proc/is_full_water(turf/open/gm/T)
	return (T.type in full_water_turfs)

/proc/is_water(turf/T)
	return (T.type in full_water_turfs) || (T.type in coastline_water_turfs)

/proc/is_coastline(turf/open/T)
	return (T.type in coastline_water_turfs)

//////////////////////////////////////////////////////////////////////////////////////////
//		SUBSYSTEM CODE --> Generate the icons at roundstart for the display effects		//
//////////////////////////////////////////////////////////////////////////////////////////

//depths: -2, -4 (shores), -8 (shallows), -12 (transition to deep), -16(deep)
//water turfs are hardcoded to only have certain depths, but the shorelines take from their fulltile varients, so for some we'll have to make multiple for those
//and for each of these we need to generate 4 overlays, for each of the texture sizes used for mobs, and special cases like larva or facehugger

/var/list/texture_sizes = list(32, 48, 64, 88)

/var/list/texture_sized_mob_culling_masks = list(
	"32" = list(
		/mob/living/carbon/human = "culling_human", //this will handle all subtypes as well, phew
		/mob/living/carbon/xenomorph/larva = "culling_larva",
		/mob/living/carbon/xenomorph/lesser_drone = "culling_lesser",
	),
	"48" = list(
		/mob/living/carbon/xenomorph/facehugger = "culling_facehugger",
		/mob/living/carbon/xenomorph/drone = "culling_drone",
		/mob/living/carbon/xenomorph/sentinel = "culling_sentinel",
		/mob/living/carbon/xenomorph/lurker = "culling_lurker",
		/mob/living/carbon/xenomorph/spitter = "culling_spitter",
	),
	"64" = list(
		/mob/living/carbon/xenomorph/defender = "culling_defender",
		/mob/living/carbon/xenomorph/runner = "culling_runner",
		/mob/living/carbon/xenomorph/carrier = "culling_carrier",
		/mob/living/carbon/xenomorph/burrower = "culling_burrower",
		/mob/living/carbon/xenomorph/hivelord = "culling_hivelord",
		/mob/living/carbon/xenomorph/warrior = "culling_warrior",
		/mob/living/carbon/xenomorph/boiler = "culling_boiler",
		/mob/living/carbon/xenomorph/despoiler = "culling_despoiler",
		/mob/living/carbon/xenomorph/praetorian = "culling_praetorian",
		/mob/living/carbon/xenomorph/ravager = "culling_ravager",
		/mob/living/carbon/xenomorph/crusher = "culling_crusher",
		/mob/living/carbon/xenomorph/predalien = "culling_predalien",
	),
	"88" = list(
		/mob/living/carbon/xenomorph/queen = "culling_queen",
	)
)

GLOBAL_LIST_INIT(water_overlay_icon_paths,list(
		"32" = 'icons/effects/water_overlay_effects/_32.dmi',	//humans, etc
		"48" = 'icons/effects/water_overlay_effects/_48.dmi',	//facehugger, drone
		"64" = 'icons/effects/water_overlay_effects/_64.dmi', //most xenos
		"88" = 'icons/effects/water_overlay_effects/_88.dmi',	//queen
	))

GLOBAL_LIST_INIT(water_overlay_effect_water_overlays, list())

/proc/get_water_turf_iconstuff(turf/open/gm/T, key)
	var/turf/open/found_type = water_rerouting["[T.type]"] ? water_rerouting["[T.type]"] : T.type
	var/return_icon = found_type.icon
	var/return_icon_state = found_type.icon_state
	if(ispath(found_type, /turf/open/gm/river/desert))
		var/turf/open/gm/river/desert/Tdesert = T
		if(Tdesert.toxic == 1)
			return_icon ='icons/turf/floors/desert_water_toxic.dmi'
		else if (Tdesert.toxic == 0)
			return_icon = 'icons/turf/floors/desert_water.dmi'
		else //Tdesert.toxic == -1
			return_icon = 'icons/turf/floors/desert_water_transition.dmi'
	return key == "icon" ? return_icon : return_icon_state

/proc/generate_water_display_icons() //used in water_overlays subsystem, generates the overlays to be used in water water_overlay_effects
	for (var/found_type in coastline_water_turfs + full_water_turfs)
		var/turf/open/working_T = found_type
		if(working_T.depth == 0) continue 		//some turfs are water turfs, but have no depth... meaning no need for an overlay
		for(var/texture_size in texture_sizes)
			var/icon/water_overlay = icon(GLOB.water_overlay_icon_paths["[texture_size]"],"empty")				//this is what will eventually be our water texture
			var/icon/subtraction_texture = icon(GLOB.water_overlay_icon_paths["[texture_size]"],"culling_mask")	//this is the part of it we'll keep, rest will become "air"
			var/icon/turf_texture = icon(get_water_turf_iconstuff(working_T, "icon"), get_water_turf_iconstuff(working_T, "icon_state"))	//this is the actual texture we'll use to create the water texture
			var/w_w = water_overlay.Width()
			var/w_h = water_overlay.Height()
			var/t_t = turf_texture.Width()
			var/pieces_x = round(w_w / t_t) + (w_w / t_t > round( w_w / t_t ) ? 1 : 0)		//since mobs wont always be 32x32 the water texture will need be build out of 32x32 parts
			for(var/i=0, i<pieces_x, i++)
				for(var/j=0, j<2, j++)
					water_overlay.Blend(turf_texture, ICON_OVERLAY, (i*32)+1, (j*32)+1)		//place our 32x32 textures on our water texture every 32 pixels
			subtraction_texture.Shift(SOUTH, (w_h - abs(working_T.depth)-3), FALSE)			//we move it down to "water level"
			var/list/mob_masks = texture_sized_mob_culling_masks["[texture_size]"]			//now for each mob type in a texture size we generate an icon for it, culled to its features
			for(var/mob_type in mob_masks)													//using static icons for the masks, since often the mobs get overlays and with this method we can account for those
				var/mob_culling_mask = mob_masks[mob_type]									//I just dont want to think about generating those on roundstart, just the inhands alone, not to mention armors or backpacks
				var/icon/mob_specific_water_overlay = icon(water_overlay)					//duplicate the water_overlay, so we dont reuse a culled texture later in the for loop
				if(mob_type == /mob/living/carbon/human)
					var/resting_key = working_T.depth >= -4 ? "coast" : "float"
					var/icon/resting_east = icon(water_overlay)								//only adding resting icons for humans, if we ever add some for xenos this will have to be rewritten :(
					var/icon/resting_west = icon(water_overlay)
					var/icon/resting_under = icon(water_overlay)
					resting_east.AddAlphaMask(icon(GLOB.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_e"))
					resting_west.AddAlphaMask(icon(GLOB.water_overlay_icon_paths["[texture_size]"], "culling_[resting_key]_rest_w"))
					resting_under.AddAlphaMask(icon(GLOB.water_overlay_icon_paths["[texture_size]"], mob_culling_mask))
					GLOB.water_overlay_effect_water_overlays["[mob_type]_[working_T.type]_resting_e"] =  resting_east
					GLOB.water_overlay_effect_water_overlays["[mob_type]_[working_T.type]_resting_w"] =  resting_west
					GLOB.water_overlay_effect_water_overlays["[mob_type]_[working_T.type]_resting_u"] =  resting_under
				if(mob_culling_mask != "culling_facehugger" && mob_culling_mask != "culling_larva") //these are special cases, they look weird with default overlay since they are so close to the ground
					mob_specific_water_overlay.AddAlphaMask(subtraction_texture)			//remove everything other than what the subraction overlay overlaps
				mob_specific_water_overlay.AddAlphaMask(icon(GLOB.water_overlay_icon_paths["[texture_size]"], mob_culling_mask))
				GLOB.water_overlay_effect_water_overlays["[mob_type]_[working_T.type]"] =  mob_specific_water_overlay	//water overlay done!

		CHECK_TICK

