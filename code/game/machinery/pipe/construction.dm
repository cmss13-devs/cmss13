/*CONTENTS
Buildable pipes
Buildable meters
*/
#define PIPE_SIMPLE_STRAIGHT	0
#define PIPE_SIMPLE_BENT		1
#define PIPE_HE_STRAIGHT		2
#define PIPE_HE_BENT			3
#define PIPE_CONNECTOR			4
#define PIPE_MANIFOLD			5
#define PIPE_JUNCTION			6
#define PIPE_UVENT				7
#define PIPE_MVALVE				8
#define PIPE_PUMP				9
#define PIPE_SCRUBBER			10
#define PIPE_INSULATED_STRAIGHT	11
#define PIPE_INSULATED_BENT		12
#define PIPE_GAS_FILTER			13
#define PIPE_GAS_MIXER			14
#define PIPE_PASSIVE_GATE       15
#define PIPE_VOLUME_PUMP        16
#define PIPE_HEAT_EXCHANGE      17
#define PIPE_MTVALVE			18
#define PIPE_MANIFOLD4W			19
#define PIPE_CAP				20

#define PIPE_GAS_FILTER_M		23
#define PIPE_GAS_MIXER_T		24
#define PIPE_GAS_MIXER_M		25
#define PIPE_OMNI_MIXER			26
#define PIPE_OMNI_FILTER		27
///// Supply, scrubbers and universal pipes
#define PIPE_UNIVERSAL				28
#define PIPE_SUPPLY_STRAIGHT		29
#define PIPE_SUPPLY_BENT			30
#define PIPE_SCRUBBERS_STRAIGHT		31
#define PIPE_SCRUBBERS_BENT			32
#define PIPE_SUPPLY_MANIFOLD		33
#define PIPE_SCRUBBERS_MANIFOLD		34
#define PIPE_SUPPLY_MANIFOLD4W		35
#define PIPE_SCRUBBERS_MANIFOLD4W	36

#define PIPE_SUPPLY_CAP				41
#define PIPE_SCRUBBERS_CAP			42

/obj/item/pipe
	name = "pipe"
	desc = "A pipe"
	var/pipe_type = 0
	//var/pipe_dir = 0
	var/pipename
	var/connect_types[] = list(1) //1=regular, 2=supply, 3=scrubber
	force = 7
	icon = 'icons/obj/pipes/pipe_item.dmi'
	icon_state = "simple"
	item_state = "buildpipe"
	flags_atom = FPRINT|CONDUCT
	w_class = SIZE_MEDIUM
	level = 2

/obj/item/pipe/Initialize(mapload, var/pipe_type as num, var/dir as num, var/obj/structure/pipes/make_from = null)
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
	if(!proximity) return
	if(istype(target))
		user.drop_inv_item_to_loc(src, target)
	else
		return ..()

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
		&& (src.dir in cardinal))
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
		if(	PIPE_SIMPLE_STRAIGHT, \
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
//	var/cw = turn(dir, -90)
//	var/acw = turn(dir, 90)

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

//	var/flip = turn(dir, 180)
//	var/cw = turn(dir, -90)

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
	return rotate()

/obj/item/pipe/attackby(obj/item/W, mob/user)
	..()
	//*
	if (!istype(W, /obj/item/tool/wrench))
		return ..()
	if (!isturf(loc))
		return 1
	var/turf/T = loc
	var/pipelevel = T.intact_tile ? 2 : 1

	if (pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_HE_STRAIGHT, PIPE_INSULATED_STRAIGHT, PIPE_MVALVE))
		if(dir==2)
			setDir(NORTH)
		else if(dir==8)
			setDir(EAST)
	else if (pipe_type in list(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER))
		setDir(SOUTH)
	var/pipe_dir = get_pipe_dir()

	for(var/obj/structure/pipes/M in src.loc)
		if((M.valid_directions & pipe_dir))	// matches at least one direction on either type of pipe & same connection type
			to_chat(user, SPAN_WARNING("There is already a pipe of the same type at this location."))
			return 1
	// no conflicts found

	//TODO: Move all of this stuff into the various pipe constructors.
	switch(pipe_type)
		if(PIPE_SIMPLE_STRAIGHT, PIPE_SIMPLE_BENT)
			var/obj/structure/pipes/standard/simple/P = new( src.loc )
			P.pipe_color = color
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			P.level = pipelevel

		if(PIPE_SUPPLY_STRAIGHT, PIPE_SUPPLY_BENT)
			var/obj/structure/pipes/standard/simple/hidden/supply/P = new( src.loc )
			P.color = color
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			P.level = pipelevel

		if(PIPE_SCRUBBERS_STRAIGHT, PIPE_SCRUBBERS_BENT)
			var/obj/structure/pipes/standard/simple/hidden/scrubbers/P = new( src.loc )
			P.color = color
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			P.level = pipelevel

		if(PIPE_UNIVERSAL)
			var/obj/structure/pipes/standard/simple/hidden/universal/P = new( src.loc )
			P.color = color
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			P.level = pipelevel

		if(PIPE_CONNECTOR)		// connector
			var/obj/structure/pipes/portables_connector/C = new( src.loc )
			C.setDir(dir)
			C.valid_directions = list(pipe_dir)
			if (pipename)
				C.name = pipename
			C.level = pipelevel

		if(PIPE_MANIFOLD)		//manifold
			var/obj/structure/pipes/standard/manifold/M = new( src.loc )
			M.pipe_color = color
			M.setDir(dir)
			M.valid_directions = list(pipe_dir)
			M.level = pipelevel

		if(PIPE_SUPPLY_MANIFOLD)		//manifold
			var/obj/structure/pipes/standard/manifold/hidden/supply/M = new( src.loc )
			M.color = color
			M.setDir(dir)
			M.valid_directions = list(pipe_dir)
			M.level = pipelevel

		if(PIPE_SCRUBBERS_MANIFOLD)		//manifold
			var/obj/structure/pipes/standard/manifold/hidden/scrubbers/M = new( src.loc )
			M.color = color
			M.setDir(dir)
			M.valid_directions = list(pipe_dir)
			M.level = pipelevel

		if(PIPE_MANIFOLD4W)		//4-way manifold
			var/obj/structure/pipes/standard/manifold/fourway/M = new( src.loc )
			M.pipe_color = color
			M.setDir(dir)
			M.valid_directions = list(pipe_dir)
			M.level = pipelevel

		if(PIPE_SUPPLY_MANIFOLD4W)		//4-way manifold
			var/obj/structure/pipes/standard/manifold/fourway/hidden/supply/M = new( src.loc )
			M.color = color
			M.setDir(dir)
			M.valid_directions = list(pipe_dir)
			M.level = pipelevel

		if(PIPE_SCRUBBERS_MANIFOLD4W)		//4-way manifold
			var/obj/structure/pipes/standard/manifold/fourway/hidden/scrubbers/M = new( src.loc )
			M.color = color
			M.setDir(dir)
			M.valid_directions = list(pipe_dir)
			M.level = pipelevel

		if(PIPE_UVENT)		//unary vent
			var/obj/structure/pipes/vents/pump/V = new( src.loc )
			V.setDir(dir)
			V.valid_directions = list(pipe_dir)
			if(pipename)
				V.name = pipename
			V.level = pipelevel

		if(PIPE_MVALVE)		//manual valve
			var/obj/structure/pipes/valve/V = new( src.loc)
			V.setDir(dir)
			V.valid_directions = list(pipe_dir)
			if (pipename)
				V.name = pipename
			V.level = pipelevel

		if(PIPE_PUMP)		//gas pump
			var/obj/structure/pipes/binary/pump/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel

		if(PIPE_GAS_FILTER)		//gas filter
			var/obj/structure/pipes/trinary/filter/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel

		if(PIPE_GAS_MIXER)		//gas mixer
			var/obj/structure/pipes/trinary/mixer/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel

		if(PIPE_GAS_FILTER_M)		//gas filter mirrored
			var/obj/structure/pipes/trinary/filter/m_filter/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel

		if(PIPE_GAS_MIXER_T)		//gas mixer-t
			var/obj/structure/pipes/trinary/mixer/t_mixer/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel

		if(PIPE_GAS_MIXER_M)		//gas mixer mirrored
			var/obj/structure/pipes/trinary/mixer/m_mixer/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if(pipename)
				P.name = pipename
			P.level = pipelevel

		if(PIPE_SCRUBBER)		//scrubber
			var/obj/structure/pipes/vents/scrubber/S = new(src.loc)
			S.setDir(dir)
			S.valid_directions = list(pipe_dir)
			if (pipename)
				S.name = pipename
			S.level = pipelevel

		if(PIPE_INSULATED_STRAIGHT, PIPE_INSULATED_BENT)
			var/obj/structure/pipes/standard/simple/insulated/P = new( src.loc )
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			P.level = pipelevel


		if(PIPE_MTVALVE)		//manual t-valve
			var/obj/structure/pipes/tvalve/V = new(src.loc)
			V.setDir(dir)
			V.valid_directions = list(pipe_dir)
			if (pipename)
				V.name = pipename
			V.level = pipelevel


		if(PIPE_CAP)
			var/obj/structure/pipes/standard/cap/C = new(src.loc)
			C.setDir(dir)
			C.valid_directions = list(pipe_dir)

		if(PIPE_SUPPLY_CAP)
			var/obj/structure/pipes/standard/cap/hidden/supply/C = new(src.loc)
			C.setDir(dir)
			C.valid_directions = list(pipe_dir)

		if(PIPE_SCRUBBERS_CAP)
			var/obj/structure/pipes/standard/cap/hidden/scrubbers/C = new(src.loc)
			C.setDir(dir)
			C.valid_directions = list(pipe_dir)

		if(PIPE_PASSIVE_GATE)		//passive gate
			var/obj/structure/pipes/binary/passive_gate/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel


		if(PIPE_VOLUME_PUMP)		//volume pump
			var/obj/structure/pipes/binary/pump/high_power/P = new(src.loc)
			P.setDir(dir)
			P.valid_directions = list(pipe_dir)
			if (pipename)
				P.name = pipename
			P.level = pipelevel


		if(PIPE_HEAT_EXCHANGE)		// heat exchanger
			var/obj/structure/pipes/unary/heat_exchanger/C = new( src.loc )
			C.setDir(dir)
			C.valid_directions = list(pipe_dir)
			if (pipename)
				C.name = pipename
			C.level = pipelevel


	playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
	user.visible_message( \
		"[user] fastens the [src].", \
		SPAN_NOTICE("You have fastened the [src]."), \
		"You hear ratchet.")
	qdel(src)	// remove the pipe item

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

/obj/item/pipe_meter/attackby(var/obj/item/W as obj, var/mob/user as mob)
	..()

	if (!istype(W, /obj/item/tool/wrench))
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
