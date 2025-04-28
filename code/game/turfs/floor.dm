
//actual built floors, not natural ground
/turf/open/floor
	name = "floor"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "floor"
	turf_flags = TURF_BURNABLE|TURF_BREAKABLE
	var/mineral = "metal"
	var/image/wet_overlay

	var/tile_type = /obj/item/stack/tile/plasteel
	var/plating_type = /turf/open/floor/plating
	var/tool_flags = REMOVE_CROWBAR

/turf/open/floor/get_examine_text(mob/user)
	. = ..()
	if(!(turf_flags & TURF_HULL))
		var/tool_output = list()
		if(tool_flags & REMOVE_CROWBAR)
			tool_output += SPAN_GREEN("crowbar")
		if(tool_flags & BREAK_CROWBAR)
			tool_output += SPAN_RED("crowbar")
		if(tool_flags & REMOVE_SCREWDRIVER)
			tool_output += SPAN_GREEN("screwdriver")
		if(length(tool_output))
			. += SPAN_NOTICE("\The [src] can be removed with \a [english_list(tool_output)].")


/turf/open/floor/is_plasteel_floor()
	return TRUE

////////////////////////////////////////////


/turf/open/floor/ex_act(severity, explosion_direction)
	if(turf_flags & TURF_HULL)
		return 0
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(severity))
				break_tile()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(severity-EXPLOSION_THRESHOLD_LOW))
				break_tile_to_plating()
			else
				break_tile()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			break_tile_to_plating()
	return 0

/turf/open/floor/fire_act(exposed_temperature, exposed_volume)
	if(turf_flags & TURF_HULL)
		return
	if(!(turf_flags & TURF_BURNT) && prob(5))
		burn_tile()
	else if(prob(1))
		make_plating()
		burn_tile()


/turf/open/floor/ceiling_debris_check(size = 1)
	ceiling_debris(size)

/turf/open/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in GLOB.cardinals)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0

/turf/open/floor/proc/gets_drilled()
	return

/turf/open/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/open/floor/proc/break_tile()
	if(!(turf_flags & TURF_BREAKABLE)  || turf_flags & TURF_HULL)
		return
	if(turf_flags & TURF_BROKEN)
		return

	turf_flags |= TURF_BROKEN
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
	else if(is_light_floor())
		icon_state = "light_broken"
		set_light(0)
	else if(is_plating())
		icon_state = "platingdmg[pick(1, 2, 3)]"
	else if(is_wood_floor())
		icon_state = "wood-broken"
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
	else if(is_grass_floor())
		icon_state = "grass[pick("1", "2", "3")]"

/turf/open/floor/proc/burn_tile()
	if(!(turf_flags & TURF_BURNABLE) || turf_flags & TURF_HULL)
		return
	if(turf_flags & TURF_BROKEN || turf_flags & TURF_BURNT)
		return

	turf_flags |= TURF_BURNT
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
	else if(is_plasteel_floor())
		icon_state = "floorscorched[pick(1, 2)]"
	else if(is_plating())
		icon_state = "panelscorched"
	else if(is_wood_floor())
		icon_state = "wood-broken"
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
	else if(is_grass_floor())
		icon_state = "grass[pick("1", "2", "3")]"

//This proc auto corrects the grass tiles' siding.
/turf/open/floor/proc/make_plating()
	set_light(0)
	intact_tile = FALSE
	turf_flags &= ~TURF_BURNT
	turf_flags &= ~TURF_BROKEN
	ChangeTurf(plating_type)

/turf/open/floor/attackby(obj/item/hitting_item, mob/user)
	if(turf_flags & TURF_HULL) //no interaction for hulls
		return

	if(src.weeds)
		return weeds.attackby(hitting_item,user)

	if(HAS_TRAIT(hitting_item, TRAIT_TOOL_CROWBAR) && (tool_flags & (REMOVE_CROWBAR|BREAK_CROWBAR)))
		if(turf_flags & TURF_BROKEN || turf_flags & TURF_BURNT)
			to_chat(user, SPAN_WARNING("You remove the broken tiles."))
		else
			if(tool_flags & BREAK_CROWBAR)
				to_chat(user, SPAN_WARNING("You forcefully pry off the planks, destroying them in the process."))
			else
				to_chat(user, SPAN_WARNING("You remove \the [src]."))
				new tile_type(src, 1, type)

		playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
		make_plating()
		return

	if(HAS_TRAIT(hitting_item, TRAIT_TOOL_SCREWDRIVER) && (tool_flags & REMOVE_SCREWDRIVER))
		to_chat(user, SPAN_WARNING("You unscrew the planks."))
		new tile_type(src, 1, type)
		playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
		make_plating()
		return

	return ..()

/turf/open/floor/wet_floor(wet_level = FLOOR_WET_WATER)
	if(wet >= wet_level)
		return
	wet = wet_level
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null
	wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
	overlays += wet_overlay

	var/oldtype = type
	spawn(800)
		if(type != oldtype)
			return
		if(wet == wet_level)
			wet = 0
			if(wet_overlay)
				overlays -= wet_overlay
				wet_overlay = null


/turf/open/floor/sandstone
	name = "sandstone floor"
	icon_state = "whiteyellowfull"

/turf/open/floor/sandstone/runed
	name = "sandstone temple floor"
	icon_state = "runedsandstone"

/turf/open/floor/sandstone/cult
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "cult"

/turf/open/floor/sandstone/red
	name = "carved red temple floor"
	icon = 'icons/turf/floors/hunter_floors.dmi'
	icon_state = "hunter_red"

/turf/open/floor/sandstone/red2
	name = "carved red temple floor"
	icon = 'icons/turf/floors/hunter_floors.dmi'
	icon_state = "hunter_red_2"

/turf/open/floor/sandstone/red3
	name = "carved red temple floor"
	icon = 'icons/turf/floors/hunter_floors.dmi'
	icon_state = "hunter_red_3"
