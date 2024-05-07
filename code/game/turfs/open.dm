
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

/turf/open/void/vehicle
	density = TRUE
	opacity = TRUE

/turf/open/void/is_weedable()
	return NOT_WEEDABLE

/turf/open/river
	can_bloody = FALSE
	supports_surgery = FALSE

// Prison grass
/turf/open/organic/grass
	name = "grass"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "grass1"

// Mars grounds

/turf/open/mars
	name = "sand"
	icon = 'icons/turf/floors/bigred.dmi'
	icon_state = "mars_sand_1"
	is_groundmap_turf = TRUE
	minimap_color = MINIMAP_MARS_DIRT


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

/turf/open/gm/dirt/Initialize(mapload, ...)
	. = ..()
	if(rand(0,15) == 0)
		icon_state = "desert[pick("0","1","2","3")]"

/turf/open/gm/grass
	name = "grass"
	icon_state = "grass1"
	baseturfs = /turf/open/gm/grass
	scorchable = "grass1"

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

/turf/open/gm/dirtgrassborder/north

/turf/open/gm/dirtgrassborder/south
	dir = 1

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

/turf/open/gm/river
	name = "river"
	icon_state = "seashallow"
	can_bloody = FALSE
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

/turf/open/gm/river/ex_act(severity)
	if(covered & severity >= EXPLOSION_THRESHOLD_LOW)
		covered = 0
		update_icon()
		spawn(10)
			for(var/atom/movable/AM in src)
				src.Entered(AM)
				for(var/atom/movable/AM1 in src)
					if(AM == AM1)
						continue
					AM1.Crossed(AM)
	if(!covered && supports_fishing && prob(5))
		var/obj/item/caught_item = get_fishing_loot(src, get_area(src), 15, 35, 10, 2)
		caught_item.sway_jitter(3, 6)

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
	if(!M || !istype(M)) return

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
	if(istype(M)) M.apply_damage(55,TOX)


/turf/open/gm/river/ocean
	color = "#dae3e2"
	base_river_slowdown = 4 // VERY. SLOW.

/turf/open/gm/river/ocean/Entered(atom/movable/AM)
	. = ..()
	if(prob(20)) // fuck you
		if(!ismob(AM))
			return
		var/mob/unlucky_mob = AM
		var/turf/target_turf = get_random_turf_in_range(AM.loc, 3, 0)
		var/datum/launch_metadata/LM = new()
		LM.target = target_turf
		LM.range = get_dist(AM.loc, target_turf)
		LM.speed = SPEED_FAST
		LM.thrower = unlucky_mob
		LM.spin = TRUE
		LM.pass_flags = NO_FLAGS
		to_chat(unlucky_mob, SPAN_WARNING("The ocean currents sweep you off your feet and throw you away!"))
		unlucky_mob.launch_towards(LM)
		return

	if(world.time % 5)
		if(ismob(AM))
			var/mob/rivermob = AM
			to_chat(rivermob, SPAN_WARNING("Moving through the incredibly deep ocean slows you down a lot!"))

/turf/open/gm/coast
	name = "coastline"
	icon_state = "beach"
	baseturfs = /turf/open/gm/coast
	supports_surgery = FALSE

/turf/open/gm/coast/north

/turf/open/gm/coast/south
	dir = 1

/turf/open/gm/coast/west
	dir = 4

/turf/open/gm/coast/east
	dir = 8

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


/turf/open/gm/riverdeep/Initialize(mapload, ...)
	. = ..()
	overlays += image("icon"='icons/turf/ground_map.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1)

/turf/open/gm/river/no_overlay
	no_overlay = TRUE
	supports_surgery = FALSE




//ELEVATOR SHAFT-----------------------------------//
/turf/open/gm/empty
	name = "empty space"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "black"
	density = TRUE
	supports_surgery = FALSE

/turf/open/gm/empty/is_weedable()
	return NOT_WEEDABLE



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

/turf/open/ice/noweed/is_weedable() //used for new prison ice block xenos
	return NOT_WEEDABLE



// Colony tiles
/turf/open/asphalt
	name = "asphalt"
	icon = 'icons/turf/floors/asphalt.dmi'
	icon_state = "sunbleached_asphalt"
	baseturfs = /turf/open/asphalt

/turf/open/asphalt/cement
	name = "concrete"
	icon_state = "cement5"
/turf/open/asphalt/cement_sunbleached
	name = "concrete"
	icon_state = "cement_sunbleached5"


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

/turf/open/jungle/Initialize(mapload, ...)
	. = ..()

	icon_state = icon_spawn_state

	if(plants_spawn && prob(40))
		if(prob(90))
			var/image/I
			if(prob(35))
				I = image('icons/obj/structures/props/jungleplants.dmi',"plant[rand(1,7)]")
			else
				if(prob(30))
					I = image('icons/obj/structures/props/ausflora.dmi',"reedbush_[rand(1,4)]")
				else if(prob(33))
					I = image('icons/obj/structures/props/ausflora.dmi',"leafybush_[rand(1,3)]")
				else if(prob(50))
					I = image('icons/obj/structures/props/ausflora.dmi',"fernybush_[rand(1,3)]")
				else
					I = image('icons/obj/structures/props/ausflora.dmi',"stalkybush_[rand(1,3)]")
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

/turf/open/jungle/path
	bushes_spawn = 0
	name = "dirt"
	desc = "it is very dirty."
	icon = 'icons/turf/floors/jungle.dmi'
	icon_state = "grass_path"
	icon_spawn_state = "dirt"
	minimap_color = MINIMAP_DIRT

/turf/open/jungle/path/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/flora/jungle/thickbush/B in src)
		qdel(B)

/turf/open/jungle/impenetrable
	bushes_spawn = 0
	icon_state = "grass_impenetrable"
	icon_spawn_state = "grass1"

/turf/open/jungle/impenetrable/Initialize(mapload, ...)
	. = ..()
	var/obj/structure/flora/jungle/thickbush/B = new(src)
	B.indestructable = 1


/turf/open/jungle/water
	bushes_spawn = 0
	name = "murky water"
	desc = "thick, murky water"
	icon = 'icons/turf/floors//beach.dmi'
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

/turf/open/shuttle/can_surgery/red
	icon_state = "floor6"

/turf/open/shuttle/can_surgery/black
	icon_state = "floor7"

/turf/open/shuttle/dropship
	name = "floor"
	icon_state = "rasputin1"

/turf/open/shuttle/dropship/can_surgery
	icon_state = "rasputin1"
	allow_construction = TRUE
	supports_surgery = TRUE

/turf/open/shuttle/dropship/can_surgery/light_grey_middle
	icon_state = "rasputin13"

/turf/open/shuttle/dropship/can_surgery/light_grey_top
	icon_state = "rasputin10"

/turf/open/shuttle/dropship/can_surgery/light_grey_single_wide_left_to_right
	icon_state = "floor8"

/*same two but helps with finding if you think top to bottom or up to down*/
/turf/open/shuttle/dropship/can_surgery/light_grey_single_wide_up_to_down
	icon_state = "rasputin3"

/turf/open/shuttle/dropship/can_surgery/light_grey_single_wide_top_to_bottom
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

/turf/open/shuttle/dropship/can_surgery/dark_grey
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

/turf/open/shuttle/lifeboat
	icon = 'icons/turf/almayer.dmi'
	icon_state = "plating"
	allow_construction = FALSE

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



// Hybrisa tiles


/turf/open/hybrisa
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "hybrisa"


/turf/open/floor/hybrisa
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "hybrisa"


// Street


/turf/open/hybrisa/street
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "cement1"
	baseturfs = /turf/open/asphalt


/turf/open/hybrisa/street/cement1
	icon_state = "cement1"
/turf/open/hybrisa/street/cement2
	icon_state = "cement2"
/turf/open/hybrisa/street/cement3
	icon_state = "cement3"
/turf/open/hybrisa/street/asphalt
	icon_state = "asphalt_old"
/turf/open/hybrisa/street/sidewalk
	icon_state = "sidewalk"
/turf/open/hybrisa/street/sidewalkfull
	icon_state = "sidewalkfull"
/turf/open/hybrisa/street/sidewalkcorner
	icon_state = "sidewalkcorner"
/turf/open/hybrisa/street/sidewalkcenter
	icon_state = "sidewalkcenter"
/turf/open/hybrisa/street/roadlines
	icon_state = "asphalt_old_roadlines"
/turf/open/hybrisa/street/roadlines2
	icon_state = "asphalt_old_roadlines2"
/turf/open/hybrisa/street/roadlines3
	icon_state = "asphalt_old_roadlines3"
/turf/open/hybrisa/street/roadlines4
	icon_state = "asphalt_old_roadlines4"
/turf/open/hybrisa/street/CMB_4x4_emblem
	icon_state = "marshallsemblem_concrete_2x2"

// Unweedable

/turf/open/hybrisa/street/underground_unweedable
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "underground"
	baseturfs = /turf/open/asphalt
	allow_construction = FALSE
/turf/open/hybrisa/metal/underground_unweedable
	name = "floor"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "bcircuit"
	allow_construction = FALSE


/turf/open/hybrisa/street/underground_unweedable/is_weedable()
	return NOT_WEEDABLE

// Engineer Ship Hull
/turf/open/engineership/ship_hull
	name = "strange metal wall"
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship."
	icon = 'icons/turf/floors/engineership.dmi'
	icon_state = "engineerwallfloor1"
	baseturfs = /turf/open/asphalt
	allow_construction = FALSE

/turf/open/engineership/ship_hull/is_weedable()
	return NOT_WEEDABLE

// Carpet


/turf/open/floor/hybrisa/carpet
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "carpetred"


/turf/open/floor/hybrisa/carpet/carpetfadedred
	icon_state = "carpetfadedred"
/turf/open/floor/hybrisa/carpet/carpetgreen
	icon_state = "carpetgreen"
/turf/open/floor/hybrisa/carpet/carpetbeige
	icon_state = "carpetbeige"
/turf/open/floor/hybrisa/carpet/carpetblack
	icon_state = "carpetblack"
/turf/open/floor/hybrisa/carpet/carpetred
	icon_state = "carpetred"
/turf/open/floor/hybrisa/carpet/carpetdarkerblue
	icon_state = "carpetdarkerblue"
/turf/open/floor/hybrisa/carpet/carpetorangered
	icon_state = "carpetorangered"
/turf/open/floor/hybrisa/carpet/carpetblue
	icon_state = "carpetblue"
/turf/open/floor/hybrisa/carpet/carpetpatternblue
	icon_state = "carpetpatternblue"
/turf/open/floor/hybrisa/carpet/carpetpatternbrown
	icon_state = "carpetpatternbrown"
/turf/open/floor/hybrisa/carpet/carpetreddeco
	icon_state = "carpetred_deco"
/turf/open/floor/hybrisa/carpet/carpetbluedeco
	icon_state = "carpetblue_deco"
/turf/open/floor/hybrisa/carpet/carpetblackdeco
	icon_state = "carpetblack_deco"
/turf/open/floor/hybrisa/carpet/carpetbeigedeco
	icon_state = "carpetbeige_deco"
/turf/open/floor/hybrisa/carpet/carpetgreendeco
	icon_state = "carpetgreen_deco"

// Tile

/turf/open/floor/hybrisa/tile
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "supermartfloor1"


/turf/open/floor/hybrisa/tile/supermartfloor1
	icon_state = "supermartfloor1"
/turf/open/floor/hybrisa/tile/supermartfloor2
	icon_state = "supermartfloor2"
/turf/open/floor/hybrisa/tile/cuppajoesfloor
	icon_state = "cuppafloor"
/turf/open/floor/hybrisa/tile/tilered
	icon_state = "tilered"
/turf/open/floor/hybrisa/tile/tileblue
	icon_state = "tileblue"
/turf/open/floor/hybrisa/tile/tilegreen
	icon_state = "tilegreen"
/turf/open/floor/hybrisa/tile/tileblackcheckered
	icon_state = "tileblack"
/turf/open/floor/hybrisa/tile/tilewhitecheckered
	icon_state = "tilewhitecheck"
/turf/open/floor/hybrisa/tile/tilelightbeige
	icon_state = "tilelightbeige"
/turf/open/floor/hybrisa/tile/tilebeigecheckered
	icon_state = "tilebeigecheck"
/turf/open/floor/hybrisa/tile/tilebeige
	icon_state = "tilebeige"
/turf/open/floor/hybrisa/tile/tilewhite
	icon_state = "tilewhite"
/turf/open/floor/hybrisa/tile/tilegrey
	icon_state = "tilegrey"
/turf/open/floor/hybrisa/tile/tileblack
	icon_state = "tileblack2"
/turf/open/floor/hybrisa/tile/beigetileshiny
	icon_state = "beigetileshiny"
/turf/open/floor/hybrisa/tile/blacktileshiny
	icon_state = "blacktileshiny"
/turf/open/floor/hybrisa/tile/cementflat
	icon_state = "cementflat"
/turf/open/floor/hybrisa/tile/beige_bigtile
	icon_state = "beige_bigtile"
/turf/open/floor/hybrisa/tile/yellow_bigtile
	icon_state = "yellow_bigtile"
/turf/open/floor/hybrisa/tile/darkgrey_bigtile
	icon_state = "darkgrey_bigtile"
/turf/open/floor/hybrisa/tile/darkbrown_bigtile
	icon_state = "darkbrown_bigtile"
/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile
	icon_state = "darkbrowncorner_bigtile"
/turf/open/floor/hybrisa/tile/asteroidfloor_bigtile
	icon_state = "asteroidfloor_bigtile"
/turf/open/floor/hybrisa/tile/asteroidwarning_bigtile
	icon_state = "asteroidwarning_bigtile"
/turf/open/floor/hybrisa/tile/lightbeige_bigtile
	icon_state = "lightbeige_bigtile"
/turf/open/floor/hybrisa/tile/green_bigtile
	icon_state = "green_bigtile"
/turf/open/floor/hybrisa/tile/greencorner_bigtile
	icon_state = "greencorner_bigtile"
/turf/open/floor/hybrisa/tile/greenfull_bigtile
	icon_state = "greenfull_bigtile"
// Wood

/turf/open/floor/hybrisa/wood
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "darkerwood"


/turf/open/floor/hybrisa/wood/greywood
	icon_state = "greywood"
/turf/open/floor/hybrisa/wood/blackwood
	icon_state = "blackwood"
/turf/open/floor/hybrisa/wood/darkerwood
	icon_state = "darkerwood"
/turf/open/floor/hybrisa/wood/redwood
	icon_state = "redwood"


// Metal


/turf/open/floor/hybrisa/metal
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "bluemetal1"


/turf/open/floor/hybrisa/metal/bluemetal1
	icon_state = "bluemetal1"
/turf/open/floor/hybrisa/metal/bluemetalfull
	icon_state = "bluemetalfull"
/turf/open/floor/hybrisa/metal/bluemetalcorner
	icon_state = "bluemetalcorner"
/turf/open/floor/hybrisa/metal/orangelinecorner
	icon_state = "orangelinecorner"
/turf/open/floor/hybrisa/metal/orangeline
	icon_state = "orangeline"
/turf/open/floor/hybrisa/metal/darkblackmetal1
	icon_state = "darkblackmetal1"
/turf/open/floor/hybrisa/metal/darkblackmetal2
	icon_state = "darkblackmetal2"
/turf/open/floor/hybrisa/metal/darkredfull2
	icon_state = "darkredfull2"
/turf/open/floor/hybrisa/metal/redcorner
	icon_state = "zredcorner"
/turf/open/floor/hybrisa/metal/grated
	icon_state = "rampsmaller"
/turf/open/floor/hybrisa/metal/stripe_red
	icon_state = "stripe_red"
/turf/open/floor/hybrisa/metal/zbrownfloor1
	icon_state = "zbrownfloor1"
/turf/open/floor/hybrisa/metal/zbrownfloor_corner
	icon_state = "zbrownfloorcorner1"
/turf/open/floor/hybrisa/metal/zbrownfloor_full
	icon_state = "zbrownfloorfull1"
/turf/open/floor/hybrisa/metal/greenmetal1
	icon_state = "greenmetal1"
/turf/open/floor/hybrisa/metal/greenmetalfull
	icon_state = "greenmetalfull"
/turf/open/floor/hybrisa/metal/greenmetalcorner
	icon_state = "greenmetalcorner"
/turf/open/floor/hybrisa/metal/metalwhitefull
	icon_state = "metalwhitefull"
// Misc

/turf/open/floor/hybrisa/misc
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "marshallsemblem"


/turf/open/floor/hybrisa/misc/marshallsemblem
    icon_state = "marshallsemblem"
/turf/open/floor/hybrisa/misc/wybiglogo
	name = "Weyland-Yutani corp. - bulding better worlds."
	icon_state = "big8x8wylogo"
/turf/open/floor/hybrisa/misc/wysmallleft
	icon_state = "weylandyutanismall1"
/turf/open/floor/hybrisa/misc/wysmallright
	icon_state = "weylandyutanismall2"
/turf/open/floor/hybrisa/misc/spaceport1
	icon_state = "spaceport1"
/turf/open/floor/hybrisa/misc/spaceport2
	icon_state = "spaceport2"


// Dropship


/turf/open/hybrisa/dropship
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "dropshipfloor1"

/turf/open/hybrisa/dropship/dropship1
	icon_state = "dropshipfloor1"
/turf/open/hybrisa/dropship/dropship2
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/dropship3
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/dropship3
	icon_state = "dropshipfloor3"
/turf/open/hybrisa/dropship/dropship4
	icon_state = "dropshipfloor4"
/turf/open/hybrisa/dropship/dropshipfloorcorner1
	icon_state = "dropshipfloorcorner1"
/turf/open/hybrisa/dropship/dropshipfloorcorner2
	icon_state = "dropshipfloorcorner2"
/turf/open/hybrisa/dropship/dropshipfloorfull
	icon_state = "dropshipfloorfull"

// Engineer tiles

/turf/open/engineership
	name = "floor"
	desc = "A strange metal floor, unlike any metal you've seen before."
	icon = 'icons/turf/floors/engineership.dmi'
	icon_state = "hybrisa"
	baseturfs = /turf/open/asphalt

/turf/open/engineership/engineer_floor1
	icon_state = "engineer_metalfloor_3"
/turf/open/engineership/engineer_floor2
	icon_state = "engineer_floor_4"
/turf/open/engineership/engineer_floor3
	icon_state = "engineer_metalfloor_2"
/turf/open/engineership/engineer_floor4
	icon_state = "engineer_metalfloor_1"
/turf/open/engineership/engineer_floor5
	icon_state = "engineerlight"
/turf/open/engineership/engineer_floor6
	icon_state = "engineer_floor_2"
/turf/open/engineership/engineer_floor7
	icon_state = "engineer_floor_1"
/turf/open/engineership/engineer_floor8
	icon_state = "engineer_floor_5"
/turf/open/engineership/engineer_floor9
	icon_state = "engineer_metalfloor_4"
/turf/open/engineership/engineer_floor10
	icon_state = "engineer_floor_corner1"
/turf/open/engineership/engineer_floor11
	icon_state = "engineer_floor_corner2"
/turf/open/engineership/engineer_floor12
	icon_state = "engineerwallfloor1"
/turf/open/engineership/engineer_floor13
	icon_state = "outerhull_dir"
/turf/open/engineership/engineer_floor14
	icon_state = "engineer_floor_corner3"

// Pillars
/turf/open/engineership/pillars
	name = "strange metal pillar"
	desc = "A strange metal pillar, unlike any metal you've seen before."
	icon_state = "eng_pillar1"

/turf/open/engineership/pillars/north/pillar1
	icon_state = "eng_pillar1"
/turf/open/engineership/pillars/north/pillar2
	icon_state = "eng_pillar2"
/turf/open/engineership/pillars/north/pillar3
	icon_state = "eng_pillar3"
/turf/open/engineership/pillars/north/pillar4
	icon_state = "eng_pillar4"
/turf/open/engineership/pillars/south/pillarsouth1
	icon_state = "eng_pillarsouth1"
/turf/open/engineership/pillars/south/pillarsouth2
	icon_state = "eng_pillarsouth2"
/turf/open/engineership/pillars/south/pillarsouth3
	icon_state = "eng_pillarsouth3"
/turf/open/engineership/pillars/south/pillarsouth4
	icon_state = "eng_pillarsouth4"
/turf/open/engineership/pillars/west/pillarwest1
	icon_state = "eng_pillarwest1"
/turf/open/engineership/pillars/west/pillarwest2
	icon_state = "eng_pillarwest2"
/turf/open/engineership/pillars/west/pillarwest3
	icon_state = "eng_pillarwest3"
/turf/open/engineership/pillars/west/pillarwest4
	icon_state = "eng_pillarwest4"
/turf/open/engineership/pillars/east/pillareast1
	icon_state = "eng_pillareast1"
/turf/open/engineership/pillars/east/pillareast2
	icon_state = "eng_pillareast2"
/turf/open/engineership/pillars/east/pillareast3
	icon_state = "eng_pillareast3"
/turf/open/engineership/pillars/east/pillareast4
	icon_state = "eng_pillareast4"
