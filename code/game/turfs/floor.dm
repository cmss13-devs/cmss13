
//actual built floors, not natural ground
/turf/open/floor
	name = "floor"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "floor"
	var/broken = FALSE
	var/burnt = FALSE
	var/mineral = "metal"
	var/breakable_tile = TRUE
	var/burnable_tile = TRUE
	var/hull_floor = FALSE //invincible floor, can't interact with it
	var/image/wet_overlay

	var/tile_type = /obj/item/stack/tile/plasteel
	var/plating_type = /turf/open/floor/plating
	var/tool_flags = REMOVE_CROWBAR

/turf/open/floor/get_examine_text(mob/user)
	. = ..()
	if(!hull_floor)
		var/tool_output = list()
		if(tool_flags & REMOVE_CROWBAR)
			tool_output += SPAN_GREEN("crowbar")
		if(tool_flags & BREAK_CROWBAR)
			tool_output += SPAN_RED("crowbar")
		if(tool_flags & REMOVE_SCREWDRIVER)
			tool_output += SPAN_GREEN("screwdriver")
		if(length(tool_output))
			. += SPAN_NOTICE("\The [src] can be removed with \a [english_list(tool_output)].")


/turf/open/floor/plating/is_plasteel_floor()
	return TRUE

////////////////////////////////////////////


/turf/open/floor/ex_act(severity, explosion_direction)
	if(hull_floor)
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
	if(hull_floor)
		return
	if(!burnt && prob(5))
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
		for(var/direction in cardinal)
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
	if(!breakable_tile || hull_floor) return
	if(broken) return
	broken = TRUE
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		broken = 1
	else if(is_light_floor())
		icon_state = "light_broken"
		broken = 1
		SetLuminosity(0)
	else if(is_plating())
		icon_state = "platingdmg[pick(1, 2, 3)]"
		broken = 1
	else if(is_wood_floor())
		icon_state = "wood-broken"
		broken = 1
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
		broken = 1
	else if(is_grass_floor())
		icon_state = "grass[pick("1", "2", "3")]"
		broken = 1

/turf/open/floor/proc/burn_tile()
	if(!burnable_tile|| hull_floor) return
	if(broken || burnt) return
	burnt = TRUE
	if(is_plasteel_floor())
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		burnt = 1
	else if(is_plasteel_floor())
		icon_state = "floorscorched[pick(1, 2)]"
		burnt = 1
	else if(is_plating())
		icon_state = "panelscorched"
		burnt = 1
	else if(is_wood_floor())
		icon_state = "wood-broken"
		burnt = 1
	else if(is_carpet_floor())
		icon_state = "carpet-broken"
		burnt = 1
	else if(is_grass_floor())
		icon_state = "grass[pick("1", "2", "3")]"
		burnt = 1

//This proc auto corrects the grass tiles' siding.
/turf/open/floor/proc/make_plating()
	SetLuminosity(0)
	intact_tile = FALSE
	broken = FALSE
	burnt = FALSE
	ChangeTurf(plating_type)

/turf/open/floor/attackby(obj/item/hitting_item, mob/user)
	if(hull_floor) //no interaction for hulls
		return

	if(src.weeds)
		return weeds.attackby(hitting_item,user)

	if(istype(hitting_item, /obj/item/tool/crowbar) && (tool_flags & (REMOVE_CROWBAR|BREAK_CROWBAR)))
		if(broken || burnt)
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
	if(wet >= wet_level) return
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

//all the subtype of the base floor tile.	icon_state = "floor"

//those default tile with decal stuck on top.
/turf/open/floor/default

//unsure if direction on it matter
/turf/open/floor/default/bot
	icon_state = "bot"

/turf/open/floor/default/delivery
	icon_state = "delivery"

/turf/open/floor/default/loadingarea
	icon_state = "loadingarea"

//south is the default.
/turf/open/floor/default/loadingarea/south

/turf/open/floor/default/loadingarea/north
	dir = 1;

/turf/open/floor/default/loadingarea/east
	dir = 4;

/turf/open/floor/default/loadingarea/west
	dir = 8;

//all the colored tiles with the default one red purple green

//default/red
/turf/open/floor/default/red

//half filled tiles
/turf/open/floor/default/red/red
	icon_state = "red"

/turf/open/floor/default/red/red/south

/turf/open/floor/default/red/red/north
	dir = 1;

/turf/open/floor/default/red/red/west
	dir = 8;

/turf/open/floor/default/red/red/east
	dir = 4;


//1/4 colored tiles

/turf/open/floor/default/red/redcorner
	icon_state = "redcorner"

/turf/open/floor/default/red/redcorner/south_east

/turf/open/floor/default/red/redcorner/north_west
	dir = 1;

/turf/open/floor/default/red/redcorner/south_west
	dir = 8;

/turf/open/floor/default/red/redcorner/north_east
	dir = 4;

//fully colored tile
/turf/open/floor/default/red/redfull
	icon_state = "redfull"


//default/blue
/turf/open/floor/default/blue

/turf/open/floor/default/blue/bluecorner
	icon_state = "bluecorner"

/turf/open/floor/default/blue/bluecorner/south_east

/turf/open/floor/default/blue/bluecorner/north_west
	dir = 1;

/turf/open/floor/default/blue/bluecorner/south_west
	dir = 8;

/turf/open/floor/default/blue/bluecorner/north_east
	dir = 4;
//end of all the default subtypes

//all the floors related to the dark tiles...
/turf/open/floor/dark
	icon_state = "dark"

//dark2 is the same as dark maybe i could remove it into another PR?
/turf/open/floor/dark2
	icon_state = "dark2"

//all the floor related to the white tiles are bellow
/turf/open/floor/white
	icon_state = "white"
// look like a white tile to me with a default on is base look non intented and could probably replace in another PR.
/turf/open/floor/bar
	icon_state = "bar"

/turf/open/floor/white/blue

//whiteblue
/turf/open/floor/white/blue/whiteblue
	icon_state = "whiteblue"

/turf/open/floor/white/blue/whiteblue/south

/turf/open/floor/white/blue/whiteblue/north
	dir = 1;

/turf/open/floor/white/blue/whiteblue/west
	dir = 8;

/turf/open/floor/white/blue/whiteblue/east
	dir = 4;

//dot corner
/turf/open/floor/white/blue/whitebluecorner
	icon_state = "whitebluecorner"

/turf/open/floor/white/blue/whitebluecorner/south_east

/turf/open/floor/white/blue/whitebluecorner/north_west
	dir = 1;

/turf/open/floor/white/blue/whitebluecorner/south_west
	dir = 8;

/turf/open/floor/white/blue/whitebluecorner/north_east
	dir = 4;

/turf/open/floor/white/blue/whitebluefull
	icon_state = "whitebluefull"
//look like a fullwhiteblue tile to me. should investigate and maybe remove on another PR.

/turf/open/floor/white/blue/whitebluefull/barber
/turf/open/floor/barber
	icon_state = "barber"

//white green
/turf/open/floor/white/green

/turf/open/floor/white/green/whitegreen
	icon_state = "whitegreen"

/turf/open/floor/white/green/whitegreen/south

/turf/open/floor/white/green/whitegreen/north
	dir = 1;

/turf/open/floor/white/green/whitegreen/west
	dir = 8;

/turf/open/floor/white/green/whitegreen/east
	dir = 4;

//dot corner
/turf/open/floor/white/green/whitegreencorner
	icon_state = "whitegreencorner"

/turf/open/floor/white/green/whitegreencorner/south_east

/turf/open/floor/white/green/whitegreencorner/north_west
	dir = 1;

/turf/open/floor/white/green/whitegreencorner/south_west
	dir = 8;

/turf/open/floor/white/green/whitegreencorner/north_east
	dir = 4;

/turf/open/floor/white/green/whitegreenfull
	icon_state = "whitegreenfull"

//white yellow
/turf/open/floor/white/yellow

/turf/open/floor/white/yellow/whiteyellow
	icon_state = "whiteyellow"

/turf/open/floor/white/yellow/whiteyellow/south

/turf/open/floor/white/yellow/whiteyellow/north
	dir = 1;

/turf/open/floor/white/yellow/whiteyellow/west
	dir = 8;

/turf/open/floor/white/yellow/whiteyellow/east
	dir = 4;

//dot corner
/turf/open/floor/white/yellow/whiteyellowcorner
	icon_state = "whiteyellowcorner"

/turf/open/floor/white/yellow/whiteyellowcorner/south_east

/turf/open/floor/white/yellow/whiteyellowcorner/north_west
	dir = 1;

/turf/open/floor/white/yellow/whiteyellowcorner/south_west
	dir = 8;

/turf/open/floor/white/yellow/whiteyellowcorner/north_east
	dir = 4;


/turf/open/floor/white/yellow/whiteyellowfull
	icon_state = "whiteyellowfull"

/turf/open/floor/white/purple

//dot corner
/turf/open/floor/white/purple/whitepurplecorner
	icon_state = "whitepurplecorner"

/turf/open/floor/white/purple/whitepurplecorner/south_east

/turf/open/floor/white/purple/whitepurplecorner/north_west
	dir = 1;

/turf/open/floor/white/purple/whitepurplecorner/south_west
	dir = 8;

/turf/open/floor/white/purple/whitepurplecorner/north_east
	dir = 4;


/turf/open/floor/white/purple/whitepurplefull
	icon_state = "whitepurplefull"

/turf/open/floor/white/red

/turf/open/floor/white/red/whiteredfull
	icon_state = "whiteredfull"
//end of colored white tiles subtype
/turf/open/floor/sandstone
	name = "sandstone floor"
	icon_state = "whiteyellowfull"

/turf/open/floor/sandstone/runed
	name = "sandstone temple floor"
	icon_state = "runedsandstone"

//use the same base as default tile but isnt's any base color of default dark or white.
//look link to default floor.
/turf/open/floor/freezerfloor
	icon_state = "freezerfloor"

/turf/open/floor/warning
	icon_state = "warning"

/turf/open/floor/warning/south

/turf/open/floor/warning/north
	dir = 1;

/turf/open/floor/warning/west
	dir = 8;

/turf/open/floor/warning/east
	dir = 4;

//all of the tiles bellow aren't connected to the default one. icon_state = "floor"
/turf/open/floor/wood
	icon_state = "wood"

/turf/open/floor/grimy
	icon_state = "grimy"

/turf/open/floor/cult
	icon_state = "cult"
