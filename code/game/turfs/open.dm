
//turfs with density = FALSE

/turf/open
	plane = FLOOR_PLANE
	minimap_color = MINIMAP_AREA_COLONY
	var/is_groundmap_turf = FALSE //whether this a turf used as main turf type for the 'outside' of a map.
	var/allow_construction = TRUE //whether you can build things like barricades on this turf.
	var/bleed_layer = 0 //snow layer
	var/wet = 0 //whether the turf is wet (only used by floors).
	var/supports_surgery = TRUE
	var/scorchable = FALSE //if TRUE set to be an icon_state which is the full sprite version of whatever gets scorched --> for border turfs like grass edges and shorelines
	var/scorchedness = 0 //how scorched is this turf 0 to 3
	var/icon_state_before_scorching //this is really dumb, blame the mappers...

/turf/open/Initialize(mapload, ...)
	. = ..()

	update_icon()

/turf/open/update_icon()
	overlays.Cut()

	add_cleanable_overlays()

	var/list/turf/open/auto_turf/auto_turf_dirs = list()
	for(var/direction in GLOB.alldirs)
		var/turf/open/auto_turf/T = get_step(src, direction)
		if(!istype(T))
			continue

		if(bleed_layer >= T.bleed_layer)
			continue

		auto_turf_dirs["[direction]"] = T

	var/list/handled_dirs = list()
	var/list/unhandled_dirs = list()
	for(var/direction in GLOB.diagonals)
		var/x_dir = direction & (direction-1)
		var/y_dir = direction - x_dir

		if(!("[direction]" in auto_turf_dirs))
			unhandled_dirs |= x_dir
			unhandled_dirs |= y_dir
			continue

		var/turf/open/auto_turf/xy_turf = auto_turf_dirs["[direction]"]
		if(("[x_dir]" in auto_turf_dirs) && ("[y_dir]" in auto_turf_dirs))
			var/special_icon_state = "[xy_turf.icon_prefix]_innercorner"
			var/image/I = image(xy_turf.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + xy_turf.bleed_layer * 0.0001)
			I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR
			overlays += I
			handled_dirs += "[x_dir]"
			handled_dirs += "[y_dir]"
			continue

		var/special_icon_state = "[xy_turf.icon_prefix]_outercorner"
		var/image/I = image(xy_turf.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + xy_turf.bleed_layer * 0.0001)
		I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR
		overlays += I
		unhandled_dirs |= x_dir
		unhandled_dirs |= y_dir

	for(var/direction in unhandled_dirs)
		if(("[direction]" in auto_turf_dirs) && !("[direction]" in handled_dirs))
			var/turf/open/auto_turf/turf = auto_turf_dirs["[direction]"]
			var/special_icon_state = "[turf.icon_prefix]_[pick("innercorner", "outercorner")]"
			var/image/I = image(turf.icon, special_icon_state, dir = REVERSE_DIR(direction), layer = layer + 0.001 + turf.bleed_layer * 0.0001)
			I.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR
			overlays += I

	if(scorchedness)
		if(!icon_state_before_scorching) //I hate you mappers, stop var editting turfs
			icon_state_before_scorching = icon_state
		var/new_icon_state = "[icon_state_before_scorching]_scorched[scorchedness]"
		if(icon_state != new_icon_state) //no point in updating the icon_state if it would be updated to be the same thing that it was
			icon_state = new_icon_state
			for(var/i in GLOB.cardinals) //but we still check so that we can update our neighbor's overlays if we do
				var/turf/open/T = get_step(src, i) //since otherwise they'd be stuck with overlays that were made with
				T.update_icon()
		for(var/i in GLOB.cardinals)
			var/turf/open/T = get_step(src, i)
			if(istype(T, /turf/open) && T.scorchable && T.scorchedness < scorchedness)
				var/icon/edge_overlay
				if(T.scorchedness)
					edge_overlay = icon(T.icon, "[T.scorchable]_scorched[T.scorchedness]")
				else
					edge_overlay = icon(T.icon, T.scorchable)
				if(!T.icon_state_before_scorching)
					T.icon_state_before_scorching = T.icon_state
				var/direction_from_neighbor_towards_src = get_dir(T, src)
				var/icon/culling_mask = icon(T.icon, "[T.scorchable]_mask[GLOB.turf_edgeinfo_cache[T.icon_state_before_scorching][dir2indexnum(T.dir)][dir2indexnum(direction_from_neighbor_towards_src)]]", direction_from_neighbor_towards_src)
				edge_overlay.Blend(culling_mask, ICON_OVERLAY)
				edge_overlay.SwapColor(rgb(255, 0, 255, 255), rgb(0, 0, 0, 0))
				overlays += edge_overlay

	var/area/my_area = loc
	if(my_area.lighting_effect)
		overlays += my_area.lighting_effect

/turf/open/proc/scorch(heat_level)
	// All scorched icons should be in the dmi that their unscorched bases are
	// "name_scorched#" where # is the scorchedness level 0 - 1 - 2 - 3
	// 0 being no scorch, and 3 the most scorched
	// level 1 should appear dried version of the base sprite so singeing works well
	// depending on the heat_level either will singe or progressively increase the scorchedness up to level 3
	// heat_level's logic has been written to scale with /obj/flamer_fire's burnlevel --- greenfire=15,orangefire=30,bluefire=40,whitefire=80

	if(scorchedness == 3) //already scorched to hell, no point in doing anything more
		return

	switch(heat_level)
		if(0)
			return

		if(1) // 1 only singes
			if(!scorchedness) // we only singe that which hasnt burned
				scorchedness = 1

		if(2 to 30)
			scorchedness = clamp(scorchedness + 1, 0, 3) //increase scorch by 1 (not that hot of a fire)

		if(31 to 60)
			scorchedness = clamp(scorchedness + 2, 0, 3) //increase scorch by 2 (hotter fire)

		if(61 to INFINITY)
			scorchedness = 3 //max out the scorchedness (hottest fire)
			var/turf/open/singe_target //super heats singe the surrounding singeables
			for(var/i in GLOB.cardinals)
				singe_target = get_step(src, i)
				if(istype(singe_target, /turf/open))
					if(singe_target.scorchable && !singe_target.scorchedness)  //much recurision checking
						singe_target.scorch(1)

	update_icon()

/turf/open/get_examine_text(mob/user)
	. = ..()
	var/ceiling_info = ceiling_desc(user)
	if(ceiling_info)
		. += ceiling_info
	if(scorchedness)
		switch(scorchedness)
			if(1)
				. += "Lightly Toasted."
			if(2)
				. += "Medium Roasted."
			if(3)
				. += "Well Done."

// Black & invisible to the mouse. used by vehicle interiors
/turf/open/void
	name = "void"
	icon = 'icons/turf/floors/space.dmi'
	icon_state = "black"
	mouse_opacity = FALSE
	can_bloody = FALSE
	supports_surgery = FALSE
	is_weedable = NOT_WEEDABLE

/turf/open/void/vehicle
	density = TRUE
	opacity = TRUE

/turf/open/river
	can_bloody = FALSE
	supports_surgery = FALSE

// Prison grass
/turf/open/organic/grass
	name = "grass"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "grass1"

/turf/open/organic/grass/astroturf
	desc = "It'll get in your shoes no matter what you do."
	name = "astroturf"

// Mars grounds

/turf/open/mars
	name = "sand"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_sand_1"
	is_groundmap_turf = TRUE
	minimap_color = MINIMAP_MARS_DIRT
	is_weedable = SEMI_WEEDABLE


/turf/open/mars_cave
	name = "cave"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_cave_1"
	is_groundmap_turf = TRUE

/turf/open/mars_cave/Initialize(mapload, ...)
	. = ..()

	var/r = rand(0, 2)

	if (r == 0 && icon_state == "mars_cave_2")
		icon_state = "mars_cave_3"

/turf/open/mars_cave/mars_cave_10
	icon_state = "mars_cave_10"

/turf/open/mars_cave/mars_cave_11
	icon_state = "mars_cave_11"

/turf/open/mars_cave/mars_cave_12
	icon_state = "mars_cave_12"

/turf/open/mars_cave/mars_cave_13
	icon_state = "mars_cave_13"

/turf/open/mars_cave/mars_cave_14
	icon_state = "mars_cave_14"

/turf/open/mars_cave/mars_cave_15
	icon_state = "mars_cave_15"

/turf/open/mars_cave/mars_cave_16
	icon_state = "mars_cave_16"

/turf/open/mars_cave/mars_cave_17
	icon_state = "mars_cave_17"

/turf/open/mars_cave/mars_cave_18
	icon_state = "mars_cave_18"

/turf/open/mars_cave/mars_cave_19
	icon_state = "mars_cave_19"

/turf/open/mars_cave/mars_cave_2
	icon_state = "mars_cave_2"

/turf/open/mars_cave/mars_cave_20
	icon_state = "mars_cave_20"

/turf/open/mars_cave/mars_cave_22
	icon_state = "mars_cave_22"

/turf/open/mars_cave/mars_cave_23
	icon_state = "mars_cave_23"

/turf/open/mars_cave/mars_cave_3
	icon_state = "mars_cave_3"

/turf/open/mars_cave/mars_cave_4
	icon_state = "mars_cave_4"

/turf/open/mars_cave/mars_cave_5
	icon_state = "mars_cave_5"

/turf/open/mars_cave/mars_cave_6
	icon_state = "mars_cave_6"

/turf/open/mars_cave/mars_cave_7
	icon_state = "mars_cave_7"

/turf/open/mars_cave/mars_cave_8
	icon_state = "mars_cave_8"

/turf/open/mars_cave/mars_cave_9
	icon_state = "mars_cave_9"

/turf/open/mars_cave/mars_dirt_4
	icon_state = "mars_dirt_4"

/turf/open/mars_cave/mars_dirt_5
	icon_state = "mars_dirt_5"

/turf/open/mars_cave/mars_dirt_6
	icon_state = "mars_dirt_6"

/turf/open/mars_cave/mars_dirt_7
	icon_state = "mars_dirt_7"

/turf/open/mars_dirt
	name = "dirt"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_dirt_1"
	minimap_color = MINIMAP_DIRT

/turf/open/mars_dirt/Initialize(mapload, ...)
	. = ..()
	var/r = rand(0, 32)

	if (r == 0 && icon_state == "mars_dirt_4")
		icon_state = "mars_dirt_1"
		return

	r = rand(0, 32)

	if (r == 0 && icon_state == "mars_dirt_4")
		icon_state = "mars_dirt_2"
		return

	r = rand(0, 6)

	if (r == 0 && icon_state == "mars_dirt_4")
		icon_state = "mars_dirt_7"

/turf/open/mars_dirt/mars_cave_10
	icon_state = "mars_cave_10"

/turf/open/mars_dirt/mars_cave_11
	icon_state = "mars_cave_11"

/turf/open/mars_dirt/mars_cave_3
	icon_state = "mars_cave_3"

/turf/open/mars_dirt/mars_cave_6
	icon_state = "mars_cave_6"

/turf/open/mars_dirt/mars_cave_7
	icon_state = "mars_cave_7"

/turf/open/mars_dirt/mars_cave_8
	icon_state = "mars_cave_8"

/turf/open/mars/mars_cave_10
	icon_state = "mars_cave_10"

/turf/open/mars/mars_dirt_10
	icon_state = "mars_dirt_10"

/turf/open/mars/mars_dirt_11
	icon_state = "mars_dirt_11"

/turf/open/mars/mars_dirt_12
	icon_state = "mars_dirt_12"

/turf/open/mars/mars_dirt_13
	icon_state = "mars_dirt_13"

/turf/open/mars/mars_dirt_14
	icon_state = "mars_dirt_14"

/turf/open/mars/mars_dirt_3
	icon_state = "mars_dirt_3"

/turf/open/mars/mars_dirt_5
	icon_state = "mars_dirt_5"

/turf/open/mars/mars_dirt_6
	icon_state = "mars_dirt_6"

/turf/open/mars/mars_dirt_8
	icon_state = "mars_dirt_8"

/turf/open/mars/mars_dirt_9
	icon_state = "mars_dirt_9"

// Beach

/turf/open/beach
	name = "Beach"
	icon = 'icons/turf/floors/beach.dmi'
	supports_surgery = FALSE

/turf/open/beach/Entered(atom/movable/AM)
	..()

	if(AM.throwing || !ishuman(AM))
		return

	var/mob/living/carbon/human/H = AM
	if(H.bloody_footsteps)
		SEND_SIGNAL(H, COMSIG_HUMAN_CLEAR_BLOODY_FEET)


/turf/open/beach/sand
	name = "Sand"
	icon_state = "sand"
	supports_surgery = TRUE

/turf/open/beach/coastline
	name = "Coastline"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "sandwater"

/turf/open/beach/water
	name = "Water"
	icon_state = "water"
	can_bloody = FALSE

/turf/open/beach/water/Initialize(mapload, ...)
	. = ..()
	overlays += image("icon"='icons/turf/floors/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/open/beach/water2
	name = "Water"
	icon_state = "water"
	can_bloody = FALSE

/turf/open/beach/water2/Initialize(mapload, ...)
	. = ..()
	overlays += image("icon"='icons/turf/floors/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)





//LV ground


/turf/open/gm //Basic groundmap turf parent
	name = "ground dirt"
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "desert"
	is_groundmap_turf = TRUE

/turf/open/gm/attackby(obj/item/I, mob/user)

	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already \a [L] at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = TRUE
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.forceMove(src)
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.set_light(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)
	return

/turf/open/gm/ex_act(severity) //Should make it indestructible
	return

/turf/open/gm/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/gm/dirt
	name = "dirt"
	icon_state = "desert"
	baseturfs = /turf/open/gm/dirt
	minimap_color = MINIMAP_DIRT

/turf/open/gm/dirt/beach
	icon_state = "beach"

/turf/open/gm/dirt/beach/northeast
	dir = NORTHEAST

/turf/open/gm/dirt/beach/southeast
	dir = SOUTHEAST

/turf/open/gm/dirt/beach/northwest
	dir = NORTHWEST

/turf/open/gm/dirt/Initialize(mapload, ...)
	. = ..()
	if(rand(0,15) == 0)
		icon_state = "desert[pick("0","1","2","3")]"

/turf/open/gm/dirt/desert0
	icon_state = "desert0"

/turf/open/gm/dirt/desert1
	icon_state = "desert1"

/turf/open/gm/dirt/desert2
	icon_state = "desert2"

/turf/open/gm/dirt/desert3
	icon_state = "desert3"

/turf/open/gm/dirt/desert_dug
	icon_state = "desert_dug"

/turf/open/gm/grass
	name = "grass"
	icon_state = "grass1"
	baseturfs = /turf/open/gm/grass
	scorchable = "grass1"
	is_weedable = SEMI_WEEDABLE

/turf/open/gm/grass/grass1
	icon_state = "grass1"

/turf/open/gm/grass/grass2
	icon_state = "grass2"

/turf/open/gm/grass/grassbeach
	icon_state = "grassbeach"

/turf/open/gm/grass/grassbeach/north

/turf/open/gm/grass/grassbeach/south
	dir = 1

/turf/open/gm/grass/grassbeach/west
	dir = 4

/turf/open/gm/grass/grassbeach/east
	dir = 8

/turf/open/gm/grass/gbcorner
	icon_state = "gbcorner"

/turf/open/gm/grass/gbcorner/north_west

/turf/open/gm/grass/gbcorner/south_east
	dir = 1

/turf/open/gm/grass/gbcorner/south_west
	dir = 4

/turf/open/gm/grass/gbcorner/north_east
	dir = 8

/turf/open/gm/grass/Initialize(mapload, ...)
	. = ..()

	if(!locate(icon_state) in GLOB.turf_edgeinfo_cache)
		switch(icon_state)
			if("grass1")
				GLOB.turf_edgeinfo_cache["grass1"] = GLOB.edgeinfo_full
			if("grass2")
				GLOB.turf_edgeinfo_cache["grass2"] = GLOB.edgeinfo_full
			if("grassbeach")
				GLOB.turf_edgeinfo_cache["grassbeach"] = GLOB.edgeinfo_edge
			if("gbcorner")
				GLOB.turf_edgeinfo_cache["gbcorner"] = GLOB.edgeinfo_corner

/turf/open/gm/dirt2
	name = "dirt"
	icon_state = "dirt"
	baseturfs = /turf/open/gm/dirt2
	minimap_color = MINIMAP_DIRT

/turf/open/gm/dirtgrassborder
	name = "grass"
	icon_state = "grassdirt_edge"
	baseturfs = /turf/open/gm/dirtgrassborder
	scorchable = "grass1"
	is_weedable = SEMI_WEEDABLE

/turf/open/gm/dirtgrassborder/north
	dir = NORTH

/turf/open/gm/dirtgrassborder/south
	dir = SOUTH

/turf/open/gm/dirtgrassborder/west
	dir = 4

/turf/open/gm/dirtgrassborder/east
	dir = 8

/turf/open/gm/dirtgrassborder/grassdirt_corner
	icon_state = "grassdirt_corner"

/turf/open/gm/dirtgrassborder/grassdirt_corner/north_west

/turf/open/gm/dirtgrassborder/grassdirt_corner/north_east
	dir = 1

/turf/open/gm/dirtgrassborder/grassdirt_corner/south_east
	dir = 4

/turf/open/gm/dirtgrassborder/grassdirt_corner/south_west
	dir = 8

/turf/open/gm/dirtgrassborder/grassdirt_corner2
	icon_state = "grassdirt_corner2"

/turf/open/gm/dirtgrassborder/grassdirt_corner2/north_west

/turf/open/gm/dirtgrassborder/grassdirt_corner2/south_east
	dir = 1

/turf/open/gm/dirtgrassborder/grassdirt_corner2/north_east
	dir = 4

/turf/open/gm/dirtgrassborder/grassdirt_corner2/south_west
	dir = 8

/turf/open/gm/dirtgrassborder/desert
	icon_state = "desert"

/turf/open/gm/dirtgrassborder/desert0
	icon_state = "desert0"

/turf/open/gm/dirtgrassborder/desert1
	icon_state = "desert1"

/turf/open/gm/dirtgrassborder/desert2
	icon_state = "desert2"

/turf/open/gm/dirtgrassborder/desert3
	icon_state = "desert3"

/turf/open/gm/dirtgrassborder/desert_dug
	icon_state = "desert_dug"

/turf/open/gm/dirtgrassborder/Initialize(mapload, ...)
	. = ..()

	if(!locate(icon_state) in GLOB.turf_edgeinfo_cache)
		switch(icon_state)
			if("grassdirt_edge")
				GLOB.turf_edgeinfo_cache["grassdirt_edge"] = GLOB.edgeinfo_edge
			if("grassdirt_corner")
				GLOB.turf_edgeinfo_cache["grassdirt_corner"] = GLOB.edgeinfo_corner
			if("grassdirt_corner2")
				GLOB.turf_edgeinfo_cache["grassdirt_corner2"] = GLOB.edgeinfo_corner2

/turf/open/gm/dirtgrassborder2
	name = "grass"
	icon_state = "grassdirt2_edge"
	baseturfs = /turf/open/gm/dirtgrassborder2

/turf/open/gm/dirtgrassborder2/north
	dir = NORTH

/turf/open/gm/dirtgrassborder2/east
	dir = EAST

/turf/open/gm/dirtgrassborder2/west
	dir = WEST

/turf/open/gm/dirtgrassborder2/wall2
	icon_state = "wall2"

/turf/open/gm/dirtgrassborder2/wall3
	icon_state = "wall3"

/turf/open/gm/river
	name = "river"
	icon_state = "seashallow"
	can_bloody = FALSE
	fishing_allowed = TRUE
	var/icon_overlay = "riverwater"
	var/covered = 0
	var/covered_name = "grate"
	var/cover_icon = 'icons/turf/floors/filtration.dmi'
	var/cover_icon_state = "grate"
	var/default_name = "river"
	var/no_overlay = FALSE
	var/base_river_slowdown = 1.75
	baseturfs = /turf/open/gm/river
	supports_surgery = FALSE
	minimap_color = MINIMAP_WATER
	is_weedable = NOT_WEEDABLE

/turf/open/gm/river/Initialize(mapload, ...)
	. = ..()
	update_icon()

/turf/open/gm/river/update_icon()
	..()
	update_overlays()

/turf/open/gm/river/proc/update_overlays()
	overlays.Cut()
	if(no_overlay)
		return
	if(covered)
		name = covered_name
		overlays += image("icon"=src.cover_icon,"icon_state"=cover_icon_state,"layer"=CATWALK_LAYER,"dir" = dir)
	else
		name = default_name
		overlays += image("icon"=src.icon,"icon_state"=icon_overlay,"layer"=ABOVE_MOB_LAYER,"dir" = dir)

/turf/open/gm/river/Entered(atom/movable/AM)
	..()

	SEND_SIGNAL(AM, COMSIG_MOVABLE_ENTERED_RIVER, src, covered)

	if(!iscarbon(AM) || AM.throwing)
		return

	if(!covered)
		var/mob/living/carbon/C = AM
		var/river_slowdown = base_river_slowdown

		if(ishuman(C))
			var/mob/living/carbon/human/H = AM
			cleanup(H)
			if(H.gloves && rand(0,100) < 60)
				if(istype(H.gloves,/obj/item/clothing/gloves/yautja/hunter))
					var/obj/item/clothing/gloves/yautja/hunter/Y = H.gloves
					if(Y && istype(Y) && HAS_TRAIT(H, TRAIT_CLOAKED))
						to_chat(H, SPAN_WARNING(" Your bracers hiss and spark as they short out!"))
						Y.decloak(H, TRUE, DECLOAK_SUBMERGED)

		else if(isxeno(C))
			river_slowdown -= 0.7
			if(isboiler(C))
				river_slowdown -= 1

		var/new_slowdown = C.next_move_slowdown + river_slowdown
		C.next_move_slowdown = new_slowdown

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.bloody_footsteps)
			SEND_SIGNAL(H, COMSIG_HUMAN_CLEAR_BLOODY_FEET)


/turf/open/gm/river/proc/cleanup(mob/living/carbon/human/M)
	if(!M || !istype(M))
		return

	if(M.back)
		if(M.back.clean_blood())
			M.update_inv_back(0)
	if(M.wear_suit)
		if(M.wear_suit.clean_blood())
			M.update_inv_wear_suit(0)
	if(M.w_uniform)
		if(M.w_uniform.clean_blood())
			M.update_inv_w_uniform(0)
	if(M.gloves)
		if(M.gloves.clean_blood())
			M.update_inv_gloves(0)
	if(M.shoes)
		if(M.shoes.clean_blood())
			M.update_inv_shoes(0)
	M.clean_blood()


/turf/open/gm/river/stop_crusher_charge()
	return !covered


/turf/open/gm/river/poison/Initialize(mapload, ...)
	. = ..()
	overlays += image("icon"='icons/effects/effects.dmi',"icon_state"="greenglow","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/poison/Entered(mob/living/M)
	..()
	if(istype(M))
		M.apply_damage(55,TOX)

/turf/open/gm/river/darkred_pool
	color = "#990000"
	name = "pool"

/turf/open/gm/river/darkred
	color = "#990000"

/turf/open/gm/river/red_pool
	color = "#995555"
	name = "pool"

/turf/open/gm/river/red
	color = "#995555"

/turf/open/gm/river/pool
	name = "pool"

/turf/open/gm/river/shallow_ocean_shallow_ocean
	name = "shallow ocean"
	default_name = "shallow ocean"
	allow_construction = FALSE

/turf/open/gm/river/ocean
	color = "#dae3e2"
	base_river_slowdown = 4 // VERY. SLOW.

/turf/open/gm/river/ocean/deep_ocean
	name = "deep ocean"
	default_name = "deep ocean"
	allow_construction = FALSE

/turf/open/gm/river/ocean/Entered(atom/movable/AM)
	. = ..()
	if(prob(20)) // fuck you
		if(!ismob(AM))
			return
		var/mob/unlucky_mob = AM
		var/turf/target_turf = get_random_turf_in_range(AM, 3, 0)
		var/datum/launch_metadata/LM = new()
		LM.target = target_turf
		LM.range = get_dist(AM.loc, target_turf)
		LM.speed = SPEED_FAST
		LM.thrower = unlucky_mob
		LM.spin = TRUE
		LM.pass_flags = NO_FLAGS
		to_chat(unlucky_mob, SPAN_WARNING("The ocean currents sweep you off your feet and throw you away!"))
		// Entered can occur during Initialize so we need to not sleep
		INVOKE_ASYNC(unlucky_mob, TYPE_PROC_REF(/atom/movable, launch_towards), LM)
		return

	if(world.time % 5)
		if(ismob(AM))
			var/mob/rivermob = AM
			if(!HAS_TRAIT(rivermob, TRAIT_HAULED))
				to_chat(rivermob, SPAN_WARNING("Moving through the incredibly deep ocean slows you down a lot!"))

/turf/open/gm/coast
	name = "coastline"
	icon_state = "beach"
	baseturfs = /turf/open/gm/coast
	supports_surgery = FALSE
	is_weedable = NOT_WEEDABLE

/turf/open/gm/coast/north

/turf/open/gm/coast/south
	dir = 1

/turf/open/gm/coast/west
	dir = 4

/turf/open/gm/coast/east
	dir = 8

/turf/open/gm/coast/south_east
	dir = 9

/turf/open/gm/coast/beachcorner
	icon_state = "beachcorner"

/turf/open/gm/coast/beachcorner/north_west

/turf/open/gm/coast/beachcorner/north_east
	dir = 1

/turf/open/gm/coast/beachcorner/south_east
	dir = 4

/turf/open/gm/coast/beachcorner/south_west
	dir = 8

/turf/open/gm/coast/beachcorner2
	icon_state = "beachcorner2"

/turf/open/gm/coast/beachcorner2/east
	dir = EAST

/turf/open/gm/coast/beachcorner2/north_west

/turf/open/gm/coast/beachcorner2/north_east
	dir = 1

/turf/open/gm/coast/beachcorner2/south_west
	dir = 4

/turf/open/gm/coast/beachcorner2/south_east
	dir = 8

/turf/open/gm/riverdeep
	name = "river"
	icon_state = "seadeep"
	can_bloody = FALSE
	baseturfs = /turf/open/gm/riverdeep
	supports_surgery = FALSE
	minimap_color = MINIMAP_WATER
	is_groundmap_turf = FALSE // Not real ground
	fishing_allowed = TRUE


/turf/open/gm/riverdeep/Initialize(mapload, ...)
	. = ..()
	overlays += image("icon"='icons/turf/ground_map.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/no_overlay
	no_overlay = TRUE
	supports_surgery = FALSE

/turf/open/gm/river/no_overlay/sewage
	name = "sewage"


//ELEVATOR SHAFT-----------------------------------//
/turf/open/gm/empty
	name = "empty space"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "black"
	density = TRUE
	supports_surgery = FALSE
	is_weedable = NOT_WEEDABLE

//Nostromo turfs

/turf/open/nostromowater
	name = "ocean"
	desc = "It's a long way down to the ocean from here."
	icon = 'icons/turf/ground_map.dmi'
	icon_state = "seadeep"
	can_bloody = FALSE
	supports_surgery = FALSE

//Ice Colony grounds

//Ice Floor
/turf/open/ice
	name = "ice floor"
	icon = 'icons/turf/ice.dmi'
	icon_state = "ice_floor"
	baseturfs = /turf/open/ice


//Randomize ice floor sprite
/turf/open/ice/Initialize(mapload, ...)
	. = ..()
	setDir(pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))

/turf/open/ice/noweed //used for new prison ice block xenos
	is_weedable = NOT_WEEDABLE

// Colony tiles
/turf/open/asphalt
	name = "asphalt"
	icon = 'icons/turf/floors/asphalt.dmi'
	icon_state = "sunbleached_asphalt"
	baseturfs = /turf/open/asphalt

/turf/open/asphalt/tile
	icon_state = "tile"

/turf/open/asphalt/cement
	name = "concrete"
	icon_state = "cement5"

/turf/open/asphalt/cement/cement1
	icon_state = "cement1"

/turf/open/asphalt/cement/cement1/north
	dir = NORTH

/turf/open/asphalt/cement/cement12
	icon_state = "cement12"

/turf/open/asphalt/cement/cement13
	icon_state = "cement13"

/turf/open/asphalt/cement/cement14
	icon_state = "cement14"

/turf/open/asphalt/cement/cement15
	icon_state = "cement15"

/turf/open/asphalt/cement/cement2
	icon_state = "cement2"

/turf/open/asphalt/cement/cement3
	icon_state = "cement3"

/turf/open/asphalt/cement/cement4
	icon_state = "cement4"

/turf/open/asphalt/cement/cement7
	icon_state = "cement7"

/turf/open/asphalt/cement/cement9
	icon_state = "cement9"

/turf/open/asphalt/cement_sunbleached
	name = "concrete"
	icon_state = "cement_sunbleached5"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached1
	icon_state = "cement_sunbleached1"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached12
	icon_state = "cement_sunbleached12"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached13
	icon_state = "cement_sunbleached13"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached14
	icon_state = "cement_sunbleached14"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached15
	icon_state = "cement_sunbleached15"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached16
	icon_state = "cement_sunbleached16"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached17
	icon_state = "cement_sunbleached17"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached18
	icon_state = "cement_sunbleached18"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached19
	icon_state = "cement_sunbleached19"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached2
	icon_state = "cement_sunbleached2"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached20
	icon_state = "cement_sunbleached20"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached3
	icon_state = "cement_sunbleached3"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached4
	icon_state = "cement_sunbleached4"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached6
	icon_state = "cement_sunbleached6"

/turf/open/asphalt/cement_sunbleached/cement_sunbleached9
	icon_state = "cement_sunbleached9"


// Jungle turfs (Whiksey Outpost)


/turf/open/jungle
	allow_construction = FALSE
	var/bushes_spawn = 1
	var/plants_spawn = 1
	is_groundmap_turf = TRUE
	name = "wet grass"
	desc = "Thick, long, wet grass."
	icon = 'icons/turf/floors/jungle.dmi'
	icon_state = "grass1"
	var/icon_spawn_state = "grass1"
	baseturfs = /turf/open/jungle
	is_weedable = NOT_WEEDABLE

/turf/open/jungle/Initialize(mapload, ...)
	. = ..()

	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('icons/obj/structures/props/natural/vegetation/jungleplants.dmi',"plant_[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/structures/props/natural/vegetation/ausflora.dmi',"reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/structures/props/natural/vegetation/ausflora.dmi',"leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/structures/props/natural/vegetation/ausflora.dmi',"fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/structures/props/natural/vegetation/ausflora.dmi',"stalkybush_[rand(1,3)]")
			I.pixel_x = rand(-6,6)
			I.pixel_y = rand(-6,6)
			overlays += I
		else
			var/obj/structure/flora/jungle/thickbush/jungle_plant/J = new(src)
			J.pixel_x = rand(-6,6)
			J.pixel_y = rand(-6,6)
	if(bushes_spawn && prob(90))
		new /obj/structure/flora/jungle/thickbush(src)



/turf/open/jungle/proc/Spread(probability, prob_loss = 50)
	if(probability <= 0)
		return
	for(var/turf/open/jungle/J in orange(1, src))
		if(!J.bushes_spawn)
			continue

		var/turf/open/jungle/P = null
		if(J.type == src.type)
			P = J
		else
			P = new src.type(J)

		if(P && prob(probability))
			P.Spread(probability - prob_loss)

/turf/open/jungle/attackby(obj/item/I, mob/user)
	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already \a [L] at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = TRUE
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.forceMove(src)
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.set_light(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)
	return

/turf/open/jungle/clear
	bushes_spawn = 0
	plants_spawn = 0
	icon_state = "grass_clear"
	icon_spawn_state = "grass1"

/turf/open/jungle/impenetrable
	bushes_spawn = FALSE
	icon_state = "grass_impenetrable"
	icon_spawn_state = "grass1"

/turf/open/jungle/impenetrable/Initialize(mapload, ...)
	. = ..()
	var/obj/structure/flora/jungle/thickbush/bush = new(src)
	bush.indestructable = TRUE

/turf/open/jungle/impenetrable/grass_clear
	icon_state = "grass_clear"

/turf/open/jungle/water
	bushes_spawn = 0
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/turf/floors/beach.dmi'
	icon_state = "water"
	icon_spawn_state = "water"
	can_bloody = FALSE
	supports_surgery = FALSE


/turf/open/jungle/water/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/flora/jungle/thickbush/B in src)
		qdel(B)

/turf/open/jungle/water/Entered(atom/movable/O)
	..()
	if(istype(O, /mob/living/))
		var/mob/living/M = O
		//slip in the murky water if we try to run through it
		if(prob(50))
			to_chat(M, pick(SPAN_NOTICE("You slip on something slimy."),SPAN_NOTICE("You fall over into the murk.")))
			M.apply_effect(2, STUN)
			M.apply_effect(1, WEAKEN)

		//piranhas - 25% chance to be an omnipresent risk, although they do practically no damage
		if(prob(25))
			to_chat(M, SPAN_NOTICE(" You feel something slithering around your legs."))
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)
			if(prob(50))
				spawn(rand(25,50))
					var/turf/T = get_turf(M)
					if(istype(T, /turf/open/jungle/water))
						to_chat(M, pick(SPAN_DANGER("Something sharp bites you!"),SPAN_DANGER("Sharp teeth grab hold of you!"),SPAN_DANGER("You feel something take a chunk out of your leg!")))
						M.apply_damage(rand(0,1), BRUTE, sharp=1)

/turf/open/jungle/water/deep
	plants_spawn = 0
	density = TRUE
	icon_state = "water2"
	icon_spawn_state = "water2"





//SHUTTLE 'FLOORS'
//not a child of turf/open/floor because shuttle floors are magic and don't behave like real floors.

/turf/open/shuttle
	name = "floor"
	icon_state = "floor"
	icon = 'icons/turf/shuttle.dmi'
	allow_construction = FALSE
	supports_surgery = FALSE

/turf/open/shuttle/can_surgery
	allow_construction = TRUE
	supports_surgery = TRUE

/turf/open/shuttle/can_surgery/blue
	name = "floor"
	icon_state = "floor"
	icon = 'icons/turf/shuttle.dmi'

/turf/open/shuttle/bright_red
	icon_state = "floor4"

/turf/open/shuttle/bright_red/glow
	icon_state = "floor4"
	light_on = TRUE
	light_power = 2
	light_range = 3
	light_color = "#ff0000"

/turf/open/shuttle/red
	icon_state = "floor6"

/turf/open/shuttle/black
	icon_state = "floor7"

/turf/open/shuttle/can_surgery/red
	icon_state = "floor6"

/turf/open/shuttle/can_surgery/black
	icon_state = "floor7"

/turf/open/shuttle/dropship
	name = "floor"
	icon_state = "rasputin1"

/turf/open/shuttle/dropship/light_grey_single_wide_left_to_right
	icon_state = "floor8"

/turf/open/shuttle/dropship/light_grey_single_wide_up_to_down
	icon_state = "rasputin3"

/turf/open/shuttle/dropship/light_grey_bottom_left
	icon_state = "rasputin4"

/turf/open/shuttle/dropship/light_grey_left_to_right
	icon_state = "rasputin5"

/turf/open/shuttle/dropship/light_grey_top_left
	icon_state = "rasputin6"

/turf/open/shuttle/dropship/light_grey_top_right
	icon_state = "rasputin7"

/turf/open/shuttle/dropship/light_grey_bottom_right
	icon_state = "rasputin8"

/turf/open/shuttle/dropship/light_grey_top
	icon_state = "rasputin10"

/turf/open/shuttle/dropship/dark_grey_bottom
	icon_state = "rasputin12"

/turf/open/shuttle/dropship/light_grey_middle
	icon_state = "rasputin13"

/turf/open/shuttle/dropship/medium_grey_single_wide_left_to_right
	icon_state = "rasputin14"

/turf/open/shuttle/dropship/can_surgery
	icon_state = "rasputin1"
	allow_construction = TRUE
	supports_surgery = TRUE

/turf/open/shuttle/dropship/can_surgery/dark_grey_bottom
	icon_state = "rasputin12"

/turf/open/shuttle/dropship/can_surgery/light_grey_top
	icon_state = "rasputin10"

/turf/open/shuttle/dropship/can_surgery/light_grey_middle
	icon_state = "rasputin13"

/turf/open/shuttle/dropship/medium_grey_single_wide_up_to_down
	icon_state = "rasputin15"

/turf/open/shuttle/dropship/can_surgery/light_grey_single_wide_left_to_right
	icon_state = "floor8"

/*same two but helps with finding if you think top to bottom or up to down*/
/turf/open/shuttle/dropship/can_surgery/light_grey_single_wide_up_to_down
	icon_state = "rasputin3"

/turf/open/shuttle/dropship/can_surgery/light_grey_top_left
	icon_state = "rasputin6"

/turf/open/shuttle/dropship/can_surgery/light_grey_bottom_left
	icon_state = "rasputin4"

/turf/open/shuttle/dropship/can_surgery/light_grey_top_right
	icon_state = "rasputin7"

/turf/open/shuttle/dropship/can_surgery/light_grey_bottom_right
	icon_state = "rasputin8"

/turf/open/shuttle/dropship/can_surgery/medium_grey_single_wide_left_to_right
	icon_state = "rasputin14"

/turf/open/shuttle/dropship/can_surgery/medium_grey_single_wide_up_to_down
	icon_state = "rasputin15"



/turf/open/shuttle/predship
	name = "ship floor"
	icon_state = "floor6"
	supports_surgery = TRUE
	allow_construction = TRUE

//not really plating, just the look
/turf/open/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "plating"

/turf/open/shuttle/brig // Added this floor tile so that I have a separate turf to check in the shuttle -- Polymorph
	name = "Brig floor" // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/open/shuttle/escapepod
	icon = 'icons/turf/escapepods.dmi'
	icon_state = "floor3"

/turf/open/shuttle/escapepod/north
	dir = NORTH

/turf/open/shuttle/escapepod/east
	dir = EAST

/turf/open/shuttle/escapepod/west
	dir = WEST

/turf/open/shuttle/escapepod/floor0
	icon_state = "floor0"

/turf/open/shuttle/escapepod/floor0/north
	dir = NORTH

/turf/open/shuttle/escapepod/floor0/east
	dir = EAST

/turf/open/shuttle/escapepod/floor0/west
	dir = WEST

/turf/open/shuttle/escapepod/floor1
	icon_state = "floor1"

/turf/open/shuttle/escapepod/floor1/north
	dir = NORTH

/turf/open/shuttle/escapepod/floor1/east
	dir = EAST

/turf/open/shuttle/escapepod/floor1/west
	dir = WEST

/turf/open/shuttle/escapepod/floor2
	icon_state = "floor2"

/turf/open/shuttle/escapepod/floor2/north
	dir = NORTH

/turf/open/shuttle/escapepod/floor2/east
	dir = EAST

/turf/open/shuttle/escapepod/floor2/west
	dir = WEST

/turf/open/shuttle/escapepod/floor3
	icon_state = "floor3"

/turf/open/shuttle/escapepod/floor3/north
	dir = NORTH

/turf/open/shuttle/escapepod/floor3/east
	dir = EAST

/turf/open/shuttle/escapepod/floor3/west
	dir = WEST

/turf/open/shuttle/escapepod/floor4
	icon_state = "floor4"

/turf/open/shuttle/lifeboat
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating"
	allow_construction = FALSE
	supports_surgery = TRUE

/turf/open/shuttle/lifeboat/plating_striped
	icon_state = "plating_striped"

/turf/open/shuttle/lifeboat/plating_striped/north
	dir = NORTH

/turf/open/shuttle/lifeboat/plate
	icon_state = "plate"

/turf/open/shuttle/lifeboat/test_floor4
	icon_state = "test_floor4"

// Elevator floors
/turf/open/shuttle/elevator
	icon = 'icons/turf/elevator.dmi'
	icon_state = "floor"

/turf/open/shuttle/elevator/grating
	icon_state = "floor_grating"


//vehicle interior floors
/turf/open/shuttle/vehicle
	name = "floor"
	icon = 'icons/turf/vehicle_interior.dmi'
	icon_state = "floor_0"

//vehicle interior floors
/turf/open/shuttle/vehicle/med
	name = "floor"
	icon_state = "dark_sterile"
	supports_surgery = TRUE

/turf/open/shuttle/vehicle/med/slate
	color = "#495462"

/turf/open/shuttle/vehicle/med/gray
	color = "#9c9a97"

/turf/open/shuttle/vehicle/dark_sterile
	icon_state = "dark_sterile"

/turf/open/shuttle/vehicle/dark_sterile_green_11
	icon_state = "dark_sterile_green_11"

/turf/open/shuttle/vehicle/dark_sterile_green_12
	icon_state = "dark_sterile_green_12"

/turf/open/shuttle/vehicle/dark_sterile_green_13
	icon_state = "dark_sterile_green_13"

/turf/open/shuttle/vehicle/dark_sterile_green_14
	icon_state = "dark_sterile_green_14"

/turf/open/shuttle/vehicle/dark_sterile_green_5
	icon_state = "dark_sterile_green_5"

/turf/open/shuttle/vehicle/dark_sterile_green_6
	icon_state = "dark_sterile_green_6"

/turf/open/shuttle/vehicle/dark_sterile_green_7
	icon_state = "dark_sterile_green_7"

/turf/open/shuttle/vehicle/dark_sterile_green_8
	icon_state = "dark_sterile_green_8"

/turf/open/shuttle/vehicle/floor_0_1_15
	icon_state = "floor_0_1_15"

/turf/open/shuttle/vehicle/floor_1_1
	icon_state = "floor_1_1"

/turf/open/shuttle/vehicle/floor_1_10
	icon_state = "floor_1_10"

/turf/open/shuttle/vehicle/floor_1_11
	icon_state = "floor_1_11"

/turf/open/shuttle/vehicle/floor_1_12
	icon_state = "floor_1_12"

/turf/open/shuttle/vehicle/floor_1_13
	icon_state = "floor_1_13"

/turf/open/shuttle/vehicle/floor_1_14
	icon_state = "floor_1_14"

/turf/open/shuttle/vehicle/floor_1_1_3
	icon_state = "floor_1_1_3"

/turf/open/shuttle/vehicle/floor_1_2
	icon_state = "floor_1_2"

/turf/open/shuttle/vehicle/floor_1_3_3
	icon_state = "floor_1_3_3"

/turf/open/shuttle/vehicle/floor_1_5
	icon_state = "floor_1_5"

/turf/open/shuttle/vehicle/floor_1_6
	icon_state = "floor_1_6"

/turf/open/shuttle/vehicle/floor_1_7
	icon_state = "floor_1_7"

/turf/open/shuttle/vehicle/floor_1_8
	icon_state = "floor_1_8"

/turf/open/shuttle/vehicle/floor_1_9
	icon_state = "floor_1_9"

/turf/open/shuttle/vehicle/floor_3
	icon_state = "floor_3"

/turf/open/shuttle/vehicle/floor_3_10_1
	icon_state = "floor_3_10_1"

/turf/open/shuttle/vehicle/floor_3_11
	icon_state = "floor_3_11"

/turf/open/shuttle/vehicle/floor_3_12
	icon_state = "floor_3_12"

/turf/open/shuttle/vehicle/floor_3_13
	icon_state = "floor_3_13"

/turf/open/shuttle/vehicle/floor_3_1_1
	icon_state = "floor_3_1_1"

/turf/open/shuttle/vehicle/floor_3_3
	icon_state = "floor_3_3"

/turf/open/shuttle/vehicle/floor_3_4
	icon_state = "floor_3_4"

/turf/open/shuttle/vehicle/floor_3_5
	icon_state = "floor_3_5"

/turf/open/shuttle/vehicle/floor_3_6
	icon_state = "floor_3_6"

/turf/open/shuttle/vehicle/floor_3_7
	icon_state = "floor_3_7"

/turf/open/shuttle/vehicle/floor_3_7_1
	icon_state = "floor_3_7_1"

/turf/open/shuttle/vehicle/floor_3_8
	icon_state = "floor_3_8"

/turf/open/shuttle/vehicle/floor_3_8_1
	icon_state = "floor_3_8_1"

/turf/open/shuttle/vehicle/floor_3_9
	icon_state = "floor_3_9"

/turf/open/shuttle/vehicle/floor_3_9_1
	icon_state = "floor_3_9_1"
