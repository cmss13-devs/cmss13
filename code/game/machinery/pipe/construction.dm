/*CONTENTS
Buildable pipes
Buildable meters
*/
#define PIPE_SIMPLE_STRAIGHT 0
#define PIPE_SIMPLE_BENT 1
#define PIPE_HE_STRAIGHT 2
#define PIPE_HE_BENT 3
#define PIPE_CONNECTOR 4
#define PIPE_MANIFOLD 5
#define PIPE_JUNCTION 6
#define PIPE_UVENT 7
#define PIPE_MVALVE 8
#define PIPE_PUMP 9
#define PIPE_SCRUBBER 10
#define PIPE_INSULATED_STRAIGHT 11
#define PIPE_INSULATED_BENT 12
#define PIPE_GAS_FILTER 13
#define PIPE_GAS_MIXER 14
#define PIPE_PASSIVE_GATE    15
#define PIPE_VOLUME_PUMP 16
#define PIPE_HEAT_EXCHANGE   17
#define PIPE_MTVALVE 18
#define PIPE_MANIFOLD4W 19
#define PIPE_CAP 20

#define PIPE_GAS_FILTER_M 23
#define PIPE_GAS_MIXER_T 24
#define PIPE_GAS_MIXER_M 25
#define PIPE_OMNI_MIXER 26
#define PIPE_OMNI_FILTER 27
///// Supply, scrubbers and universal pipes
#define PIPE_UNIVERSAL 28
#define PIPE_SUPPLY_STRAIGHT 29
#define PIPE_SUPPLY_BENT 30
#define PIPE_SCRUBBERS_STRAIGHT 31
#define PIPE_SCRUBBERS_BENT 32
#define PIPE_SUPPLY_MANIFOLD 33
#define PIPE_SCRUBBERS_MANIFOLD 34
#define PIPE_SUPPLY_MANIFOLD4W 35
#define PIPE_SCRUBBERS_MANIFOLD4W 36

#define PIPE_SUPPLY_CAP 41
#define PIPE_SCRUBBERS_CAP 42

/obj/item/pipe
	name = "pipe"
	desc = "A pipe"
	var/pipe_type = 0
	//var/pipe_dir = 0
	var/pipename
	var/connect_types[] = list(1) //1=regular, 2=supply, 3=scrubber
	force = 7
	icon = 'icons/obj/pipes/pipe_item.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/construction_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/construction_righthand.dmi',
	)
	icon_state = "simple"
	item_state = "buildpipe"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_MEDIUM
	level = 2

/obj/item/pipe/Initialize(mapload, pipe_type as num, dir as num, obj/structure/pipes/make_from = null)
	. = ..()
	if(pipe_type == null)
		pipe_type = 0
	if (make_from)
		setDir(make_from.dir)
		src.pipename = make_from.name
		color = make_from.pipe_color
		var/is_bent
		if  (make_from.valid_directions in list(NORTH|SOUTH, WEST|EAST))
			is_bent = 0
		else
			is_bent = 1
		if(istype(make_from, /obj/structure/pipes/standard/simple/insulated))
			src.pipe_type = PIPE_INSULATED_STRAIGHT + is_bent
		else if(istype(make_from, /obj/structure/pipes/standard/simple/visible/supply) || istype(make_from, /obj/structure/pipes/standard/simple/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_STRAIGHT + is_bent
			connect_types = list(2)
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/structure/pipes/standard/simple/visible/scrubbers) || istype(make_from, /obj/structure/pipes/standard/simple/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_STRAIGHT + is_bent
			connect_types = list(3)
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/structure/pipes/standard/simple/visible/universal) || istype(make_from, /obj/structure/pipes/standard/simple/hidden/universal))
			src.pipe_type = PIPE_UNIVERSAL
			connect_types = list(1,2,3)
		else if(istype(make_from, /obj/structure/pipes/standard/simple))
			src.pipe_type = PIPE_SIMPLE_STRAIGHT + is_bent
		else if(istype(make_from, /obj/structure/pipes/portables_connector))
			src.pipe_type = PIPE_CONNECTOR
		else if(istype(make_from, /obj/structure/pipes/standard/manifold/visible/supply) || istype(make_from, /obj/structure/pipes/standard/manifold/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_MANIFOLD
			connect_types = list(2)
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/structure/pipes/standard/manifold/visible/scrubbers) || istype(make_from, /obj/structure/pipes/standard/manifold/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_MANIFOLD
			connect_types = list(3)
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/structure/pipes/standard/manifold))
			src.pipe_type = PIPE_MANIFOLD
		else if(istype(make_from, /obj/structure/pipes/vents/pump))
			src.pipe_type = PIPE_UVENT
		else if(istype(make_from, /obj/structure/pipes/valve))
			src.pipe_type = PIPE_MVALVE
		else if(istype(make_from, /obj/structure/pipes/binary/pump/high_power))
			src.pipe_type = PIPE_VOLUME_PUMP
		else if(istype(make_from, /obj/structure/pipes/binary/pump))
			src.pipe_type = PIPE_PUMP
		else if(istype(make_from, /obj/structure/pipes/trinary/filter/m_filter))
			src.pipe_type = PIPE_GAS_FILTER_M
		else if(istype(make_from, /obj/structure/pipes/trinary/mixer/t_mixer))
			src.pipe_type = PIPE_GAS_MIXER_T
		else if(istype(make_from, /obj/structure/pipes/trinary/mixer/m_mixer))
			src.pipe_type = PIPE_GAS_MIXER_M
		else if(istype(make_from, /obj/structure/pipes/trinary/filter))
			src.pipe_type = PIPE_GAS_FILTER
		else if(istype(make_from, /obj/structure/pipes/trinary/mixer))
			src.pipe_type = PIPE_GAS_MIXER
		else if(istype(make_from, /obj/structure/pipes/vents/scrubber))
			src.pipe_type = PIPE_SCRUBBER
		else if(istype(make_from, /obj/structure/pipes/binary/passive_gate))
			src.pipe_type = PIPE_PASSIVE_GATE
		else if(istype(make_from, /obj/structure/pipes/unary/heat_exchanger))
			src.pipe_type = PIPE_HEAT_EXCHANGE
		else if(istype(make_from, /obj/structure/pipes/tvalve))
			src.pipe_type = PIPE_MTVALVE
		else if(istype(make_from, /obj/structure/pipes/standard/manifold/fourway/visible/supply) || istype(make_from, /obj/structure/pipes/standard/manifold/fourway/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_MANIFOLD4W
			connect_types = list(2)
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/structure/pipes/standard/manifold/fourway/visible/scrubbers) || istype(make_from, /obj/structure/pipes/standard/manifold/fourway/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_MANIFOLD4W
			connect_types = list(3)
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/structure/pipes/standard/manifold/fourway))
			src.pipe_type = PIPE_MANIFOLD4W
		else if(istype(make_from, /obj/structure/pipes/standard/cap/visible/supply) || istype(make_from, /obj/structure/pipes/standard/cap/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_CAP
			connect_types = list(2)
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/structure/pipes/standard/cap/visible/scrubbers) || istype(make_from, /obj/structure/pipes/standard/cap/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_CAP
			connect_types = list(3)
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/structure/pipes/standard/cap))
			src.pipe_type = PIPE_CAP

	else
		src.pipe_type = pipe_type
		setDir(dir)
		if (pipe_type == 29 || pipe_type == 30 || pipe_type == 33 || pipe_type == 35 || pipe_type == 37 || pipe_type == 39 || pipe_type == 41)
			connect_types = list(2)
			src.color = PIPE_COLOR_BLUE
		else if (pipe_type == 31 || pipe_type == 32 || pipe_type == 34 || pipe_type == 36 || pipe_type == 38 || pipe_type == 40 || pipe_type == 42)
			connect_types = list(3)
			src.color = PIPE_COLOR_RED
		else if (pipe_type == 28)
			connect_types = list(1,2,3)
	//src.pipe_dir = get_pipe_dir()
	update()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

//update the name and icon of the pipe item depending on the type

/obj/item/pipe/proc/update()
	var/list/nlist = list( \
		"pipe", \
		"bent pipe", \
		"h/e pipe", \
		"bent h/e pipe", \
		"connector", \
		"manifold", \
		"junction", \
		"uvent", \
		"mvalve", \
		"pump", \
		"scrubber", \
		"insulated pipe", \
		"bent insulated pipe", \
		"gas filter", \
		"gas mixer", \
		"pressure regulator", \
		"high power pump", \
		"heat exchanger", \
		"t-valve", \
		"4-way manifold", \
		"pipe cap", \
///// Z-Level stuff
		"pipe up", \
		"pipe down", \
///// Z-Level stuff
		"gas filter m", \
		"gas mixer t", \
		"gas mixer m", \
		"omni mixer", \
		"omni filter", \
///// Supply and scrubbers pipes
		"universal pipe adapter", \
		"supply pipe", \
		"bent supply pipe", \
		"scrubbers pipe", \
		"bent scrubbers pipe", \
		"supply manifold", \
		"scrubbers manifold", \
		"supply 4-way manifold", \
		"scrubbers 4-way manifold", \
		"supply pipe up", \
		"scrubbers pipe up", \
		"supply pipe down", \
		"scrubbers pipe down", \
		"supply pipe cap", \
		"scrubbers pipe cap", \
	)
	name = nlist[pipe_type+1] + " fitting"
	var/list/islist = list( \
		"simple", \
		"simple", \
		"he", \
		"he", \
		"connector", \
		"manifold", \
		"junction", \
		"uvent", \
		"mvalve", \
		"pump", \
		"scrubber", \
		"insulated", \
		"insulated", \
		"filter", \
		"mixer", \
		"passivegate", \
		"volumepump", \
		"heunary", \
		"mtvalve", \
		"manifold4w", \
		"cap", \
///// Z-Level stuff
		"cap", \
		"cap", \
///// Z-Level stuff
		"m_filter", \
		"t_mixer", \
		"m_mixer", \
		"omni_mixer", \
		"omni_filter", \
///// Supply and scrubbers pipes
		"universal", \
		"simple", \
		"simple", \
		"simple", \
		"simple", \
		"manifold", \
		"manifold", \
		"manifold4w", \
		"manifold4w", \
		"cap", \
		"cap", \
		"cap", \
		"cap", \
		"cap", \
		"cap", \
	)
	icon_state = islist[pipe_type + 1]

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/open/floor/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target))
		user.drop_inv_item_to_loc(src, target)
	else
		return ..()

/obj/item/pipe/pickup(mob/user, silent)
	var/old_dir = dir
	..()
	setDir(old_dir) // Retain old dir since these rotate in hand

/obj/item/pipe/equipped(mob/user, slot, silent)
	var/old_dir = dir
	..()
	setDir(old_dir) // Retain old dir since these rotate in hand

// rotate the pipe item clockwise
/obj/item/pipe/verb/rotate()
	set category = "Object"
	set name = "Rotate Pipe"
	set src in view(1)

	if ( usr.stat || usr.is_mob_restrained() )
		return

	setDir(turn(src.dir, -90))

	if (pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_UNIVERSAL, PIPE_HE_STRAIGHT, PIPE_INSULATED_STRAIGHT, PIPE_MVALVE))
		if(dir==2)
			setDir(1)
		else if(dir==8)
			setDir(4)
	else if (pipe_type in list (PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W))
		setDir(2)
	//src.pipe_dir = get_pipe_dir()
	return

/obj/item/pipe/Move()
	. = ..()
	if ((pipe_type in list (PIPE_SIMPLE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT, PIPE_HE_BENT, PIPE_INSULATED_BENT)) \
		&& (src.dir in GLOB.cardinals))
		setDir(src.dir|turn(src.dir, 90))
	else if (pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_UNIVERSAL, PIPE_HE_STRAIGHT, PIPE_INSULATED_STRAIGHT, PIPE_MVALVE))
		if(dir==2)
			setDir(1)
		else if(dir==8)
			setDir(4)
	return

// returns all pipe's endpoints

/obj/item/pipe/proc/get_pipe_dir()
	if (!dir)
		return 0
	var/flip = turn(dir, 180)
	var/cw = turn(dir, -90)
	var/acw = turn(dir, 90)

	switch(pipe_type)
		if( PIPE_SIMPLE_STRAIGHT, \
			PIPE_INSULATED_STRAIGHT, \
			PIPE_HE_STRAIGHT, \
			PIPE_JUNCTION ,\
			PIPE_PUMP ,\
			PIPE_VOLUME_PUMP ,\
			PIPE_PASSIVE_GATE ,\
			PIPE_MVALVE, \
			PIPE_SUPPLY_STRAIGHT, \
			PIPE_SCRUBBERS_STRAIGHT, \
			PIPE_UNIVERSAL, \
		)
			return dir|flip
		if(PIPE_SIMPLE_BENT, PIPE_INSULATED_BENT, PIPE_HE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT)
			return dir //dir|acw
		if(PIPE_CONNECTOR,PIPE_UVENT,PIPE_SCRUBBER,PIPE_HEAT_EXCHANGE)
			return dir
		if(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER)
			return dir|flip|cw|acw
		if(PIPE_MANIFOLD, PIPE_SUPPLY_MANIFOLD, PIPE_SCRUBBERS_MANIFOLD)
			return flip|cw|acw
		if(PIPE_GAS_FILTER, PIPE_GAS_MIXER,PIPE_MTVALVE)
			return dir|flip|cw
		if(PIPE_GAS_FILTER_M, PIPE_GAS_MIXER_M)
			return dir|flip|acw
		if(PIPE_GAS_MIXER_T)
			return dir|cw|acw
		if(PIPE_CAP, PIPE_SUPPLY_CAP, PIPE_SCRUBBERS_CAP)
			return dir

	return 0

/obj/item/pipe/proc/get_pdir() //endpoints for regular pipes

	var/flip = turn(dir, 180)
// var/cw = turn(dir, -90)
// var/acw = turn(dir, 90)

	if (!(pipe_type in list(PIPE_HE_STRAIGHT, PIPE_HE_BENT, PIPE_JUNCTION)))
		return get_pipe_dir()
	switch(pipe_type)
		if(PIPE_HE_STRAIGHT,PIPE_HE_BENT)
			return 0
		if(PIPE_JUNCTION)
			return flip
	return 0

// return the h_dir (heat-exchange pipes) from the type and the dir

/obj/item/pipe/proc/get_hdir() //endpoints for h/e pipes

// var/flip = turn(dir, 180)
// var/cw = turn(dir, -90)

	switch(pipe_type)
		if(PIPE_HE_STRAIGHT)
			return get_pipe_dir()
		if(PIPE_HE_BENT)
			return get_pipe_dir()
		if(PIPE_JUNCTION)
			return dir
		else
			return 0

/obj/item/pipe/attack_self(mob/user as mob)
	..()
	rotate()

/obj/item/pipe/attackby(obj/item/W, mob/user)
	. = ..()
	if(!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		return .
	if(!isturf(loc))
		return TRUE
	var/turf/turf = loc
	var/pipelevel = turf.intact_tile ? 2 : 1

	if(pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_HE_STRAIGHT, PIPE_INSULATED_STRAIGHT, PIPE_MVALVE))
		if(dir == SOUTH)
			setDir(NORTH)
		else if(dir == WEST)
			setDir(EAST)
	else if(pipe_type in list(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER))
		setDir(SOUTH)
	var/pipe_dir = get_pipe_dir()

	for(var/obj/structure/pipes/existing_pipe in loc)
		if((existing_pipe.valid_directions & pipe_dir)) // matches at least one direction on either type of pipe & same connection type
			to_chat(user, SPAN_WARNING("There is already a pipe of the same type at this location."))
			return TRUE
	// no conflicts found

	//TODO: Move all of this stuff into the various pipe constructors.
	var/obj/structure/pipes/new_pipe
	switch(pipe_type)
		if(PIPE_SIMPLE_STRAIGHT, PIPE_SIMPLE_BENT)
			new_pipe = new /obj/structure/pipes/standard/simple(loc)
			new_pipe.pipe_color = color
			new_pipe.level = pipelevel

		if(PIPE_SUPPLY_STRAIGHT, PIPE_SUPPLY_BENT)
			new_pipe = new /obj/structure/pipes/standard/simple/hidden/supply(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_SCRUBBERS_STRAIGHT, PIPE_SCRUBBERS_BENT)
			new_pipe = new /obj/structure/pipes/standard/simple/hidden/scrubbers(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_UNIVERSAL)
			new_pipe = new /obj/structure/pipes/standard/simple/hidden/universal(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_CONNECTOR) // connector
			new_pipe = new /obj/structure/pipes/portables_connector(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_MANIFOLD) //manifold
			new_pipe = new /obj/structure/pipes/standard/manifold(loc)
			new_pipe.pipe_color = color
			new_pipe.level = pipelevel

		if(PIPE_SUPPLY_MANIFOLD) //manifold
			new_pipe = new /obj/structure/pipes/standard/manifold/hidden/supply(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_SCRUBBERS_MANIFOLD) //manifold
			new_pipe = new /obj/structure/pipes/standard/manifold/hidden/scrubbers(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_MANIFOLD4W) //4-way manifold
			new_pipe = new /obj/structure/pipes/standard/manifold/fourway(loc)
			new_pipe.pipe_color = color
			new_pipe.level = pipelevel

		if(PIPE_SUPPLY_MANIFOLD4W) //4-way manifold
			new_pipe = new /obj/structure/pipes/standard/manifold/fourway/hidden/supply(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_SCRUBBERS_MANIFOLD4W) //4-way manifold
			new_pipe = new /obj/structure/pipes/standard/manifold/fourway/hidden/scrubbers(loc)
			new_pipe.color = color
			new_pipe.level = pipelevel

		if(PIPE_UVENT) //unary vent
			new_pipe = new /obj/structure/pipes/vents/pump(loc)
			if(pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_MVALVE) //manual valve
			new_pipe = new /obj/structure/pipes/valve(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_PUMP) //gas pump
			new_pipe = new /obj/structure/pipes/binary/pump(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_GAS_FILTER) //gas filter
			new_pipe = new /obj/structure/pipes/trinary/filter(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_GAS_MIXER) //gas mixer
			new_pipe = new /obj/structure/pipes/trinary/mixer(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_GAS_FILTER_M) //gas filter mirrored
			new_pipe = new /obj/structure/pipes/trinary/filter/m_filter(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_GAS_MIXER_T) //gas mixer-t
			new_pipe = new /obj/structure/pipes/trinary/mixer/t_mixer(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_GAS_MIXER_M) //gas mixer mirrored
			new_pipe = new /obj/structure/pipes/trinary/mixer/m_mixer(loc)
			if(pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_SCRUBBER) //scrubber
			new_pipe = new /obj/structure/pipes/vents/scrubber(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

		if(PIPE_INSULATED_STRAIGHT, PIPE_INSULATED_BENT)
			new_pipe = new /obj/structure/pipes/standard/simple/insulated(loc)
			new_pipe.level = pipelevel


		if(PIPE_MTVALVE) //manual t-valve
			new_pipe = new /obj/structure/pipes/tvalve(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel


		if(PIPE_CAP)
			new_pipe = new /obj/structure/pipes/standard/cap(loc)

		if(PIPE_SUPPLY_CAP)
			new_pipe = new /obj/structure/pipes/standard/cap/hidden/supply(loc)

		if(PIPE_SCRUBBERS_CAP)
			new_pipe = new /obj/structure/pipes/standard/cap/hidden/scrubbers(loc)

		if(PIPE_PASSIVE_GATE) //passive gate
			new_pipe = new /obj/structure/pipes/binary/passive_gate(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel


		if(PIPE_VOLUME_PUMP) //volume pump
			new_pipe = new /obj/structure/pipes/binary/pump/high_power(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel


		if(PIPE_HEAT_EXCHANGE) // heat exchanger
			new_pipe = new /obj/structure/pipes/unary/heat_exchanger(loc)
			if (pipename)
				new_pipe.name = pipename
			new_pipe.level = pipelevel

	new_pipe.setDir(dir)
	new_pipe.create_valid_directions()
	new_pipe.search_for_connections()

	playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message(
		"[user] fastens [src].",
		SPAN_NOTICE("You have fastened [src]."),
		"You hear ratchet.")
	qdel(src) // remove the pipe item

	return
	//TODO: DEFERRED

// ensure that setterm() is called for a newly connected pipeline



/obj/item/pipe_meter
	name = "meter"
	desc = "A meter that can be laid on pipes"
	icon = 'icons/obj/pipes/pipe_item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_LARGE

/obj/item/pipe_meter/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (!HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		return ..()
	if(!locate(/obj/structure/pipes/standard/, src.loc))
		to_chat(user, SPAN_WARNING("You need to fasten it to a pipe."))
		return 1
	new/obj/structure/machinery/meter( src.loc )
	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE(" You have fastened the meter to the pipe"))
	qdel(src)
//not sure why these are necessary
#undef PIPE_SIMPLE_STRAIGHT
#undef PIPE_SIMPLE_BENT
#undef PIPE_HE_STRAIGHT
#undef PIPE_HE_BENT
#undef PIPE_CONNECTOR
#undef PIPE_MANIFOLD
#undef PIPE_JUNCTION
#undef PIPE_UVENT
#undef PIPE_MVALVE
#undef PIPE_PUMP
#undef PIPE_SCRUBBER
#undef PIPE_INSULATED_STRAIGHT
#undef PIPE_INSULATED_BENT
#undef PIPE_GAS_FILTER
#undef PIPE_GAS_MIXER
#undef PIPE_PASSIVE_GATE
#undef PIPE_VOLUME_PUMP
#undef PIPE_MTVALVE
#undef PIPE_GAS_FILTER_M
#undef PIPE_GAS_MIXER_T
#undef PIPE_GAS_MIXER_M
#undef PIPE_SUPPLY_STRAIGHT
#undef PIPE_SUPPLY_BENT
#undef PIPE_SCRUBBERS_STRAIGHT
#undef PIPE_SCRUBBERS_BENT
#undef PIPE_SUPPLY_MANIFOLD
#undef PIPE_SCRUBBERS_MANIFOLD
#undef PIPE_UNIVERSAL
//#undef PIPE_MANIFOLD4W
