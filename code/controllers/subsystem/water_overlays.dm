SUBSYSTEM_DEF(water_overlays)
	name = "Water Overlays"
	init_order = SS_INIT_WATEROVERLAYS
	flags = SS_NO_FIRE
	var/stat = WATEROVERLAY_STATUS_STANDBY
	var/start_time = 0
	var/list/turfs_to_process = list()
	var/list/texture_sizes = list(32, 48, 64, 88)
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
			"64" = 'icons/effects/water_overlay_effects/_64.dmi', //most xenos
			"88" = 'icons/effects/water_overlay_effects/_88.dmi',   //queen
	)
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

/datum/controller/subsystem/water_overlays/Initialize()
	generate_water_display_icons()
	for(var/turf/T in GLOB.turfs)	//we're gonna cut down on the turfs we're gonna check to improve game start lag, ignoring water in nightmares...
		if(is_water(T))				//maybe we can add their neighbors to turfs_to_process when placing the nightmares...  someone should
			for(var/direction in GLOB.alldirs)
				var/turf/found_turf = get_step(T, direction)
				if(found_turf && !is_water(found_turf))
					turfs_to_process |= found_turf
		CHECK_TICK
	return SS_INIT_SUCCESS

/datum/controller/subsystem/water_overlays/proc/fix_water_neighbor_layers()
	if(stat == WATEROVERLAY_STATUS_DONE)
		return
	else
		start_time = world.time
		stat = WATEROVERLAY_STATUS_RUNNING
		var/list/altered_turfs = list()
		for(var/turf/T in turfs_to_process)
			if(T in altered_turfs)
				continue
			altered_turfs |= T.fix_water_clipping_layers(altered_turfs)
		for(var/turf/T in altered_turfs)
			T.fix_water_clipping_layers_final()
		stat = WATEROVERLAY_STATUS_DONE
