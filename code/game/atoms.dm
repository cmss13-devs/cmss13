
/atom
	var/name_label /// Labels put onto the atom by a hand labeler. usually in the format "[initial(name)] ([name_label])"

	layer = TURF_LAYER
	var/level = 2
	var/flags_atom = FPRINT

	var/list/fingerprintshidden
	var/fingerprintslast = null

	var/unacidable = FALSE
	var/last_bumped = 0

	// The cached datum for the permanent pass flags for any given atom
	var/datum/pass_flags_container/pass_flags

	// Temporary lags for what an atom can pass through
	var/list/flags_pass_temp
	var/list/temp_flag_counter

	// Temporary flags for what can pass through an atom
	var/list/flags_can_pass_all_temp
	var/list/flags_can_pass_front_temp
	var/list/flags_can_pass_behind_temp

	var/flags_barrier = NO_FLAGS
	var/throwpass = 0

	//Effects
	var/list/effects_list

	var/list/filter_data //For handling persistent filters

	// Base transform matrix
	var/matrix/base_transform = null

	///Chemistry.
	var/datum/reagents/reagents = null

	//Z-Level Transitions
	var/atom/movable/clone/clone = null

	// Bitflag of which test cases this atom is exempt from
	// See #define/tests.dm
	var/test_exemptions = 0

	// Whether the atom is an obstacle that should be considered for passing
	var/can_block_movement = FALSE

	// Beams
	var/list/beams // An assoc list where the keys are ids and their values are TRUE (indicating beam should persist)
	var/beam_id = 0

/atom/New(loc, ...)
	var/do_initialize = SSatoms.initialized
	if(do_initialize != INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return

/*
We actually care what this returns, since it can return different directives.
Not specifically here, but in other variations of this. As a general safety,
Make sure the return value equals the return value of the parent so that the
directive is properly returned.
*/
//===========================================================================
/atom/Destroy()
	QDEL_NULL(reagents)
	QDEL_NULL(light)
	fingerprintshidden = null
	. = ..()

//===========================================================================



//atmos procs

//returns the atmos info relevant to the object (gas type, temperature, and pressure)
/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null


/atom/proc/return_pressure()
	if(loc)
		return loc.return_pressure()

/atom/proc/return_temperature()
	if(loc)
		return loc.return_temperature()

//returns the gas mix type
/atom/proc/return_gas()
	if(loc)
		return loc.return_gas()

// Updates the atom's transform
/atom/proc/apply_transform(var/matrix/M)
	if(!base_transform)
		transform = M
		return

	var/matrix/base_copy = matrix(base_transform)
	// Compose the base and applied transform in that order
	transform = base_copy.Multiply(M)

/atom/proc/on_reagent_change()
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags_atom & OPENCONTAINER

/atom/proc/can_be_syringed()
	return flags_atom & CAN_BE_SYRINGED

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

/atom/proc/allow_drop()
	return 1


/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi', time = 50, maxdistance = 10, always_turn = TRUE)
	set waitfor = FALSE

	if (isnull(beams))
		beams = list()

	. = beam_id
	var/str_id = "[beam_id++]"
	beams[str_id] = TRUE

	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime = world.time+time

	while(BeamTarget && ((time == BEAM_INFINITE_DURATION && beams[str_id]) || world.time < EndTime) && get_dist(src,BeamTarget) < maxdistance && z == BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		if(always_turn)
			setDir(get_dir(src,BeamTarget))	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10,src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource == src)				//just draw another instance of the beam instead of trying to manipulate all the
				qdel(O)							//pieces to a new orientation.
		var/Angle = round(Get_Angle(src,BeamTarget))
		var/icon/I = new(icon,icon_state)
		I.Turn(Angle)
		var/DX = (32*BeamTarget.x - BeamTarget.pixel_x) - (32*x + pixel_x)
		var/DY = (32*BeamTarget.y - BeamTarget.pixel_y) - (32*y + pixel_y)
		var/N = 0
		var/length = round(sqrt((DX)**2 + (DY)**2))
		for(N, N < length, N += 32)
			var/obj/effect/overlay/beam/X = new(loc)
			X.BeamSource = src
			if(N + 32 > length)
				var/icon/II = new(icon,icon_state)
				II.DrawBox(null,1,(length-N),32,32)
				II.Turn(Angle)
				X.icon = II
			else
				X.icon = I
			var/Pixel_x = round(sin(Angle) + 32*sin(Angle)*(N+16)/32)
			var/Pixel_y = round(cos(Angle) + 32*cos(Angle)*(N+16)/32)
			if(DX == 0)
				Pixel_x = 0
			if(DY == 0)
				Pixel_y = 0
			if(Pixel_x > 32)
				for(var/a = 0, a <= Pixel_x, a += 32)
					X.x++
					Pixel_x -= 32
			if(Pixel_x < -32)
				for(var/a = 0, a >= Pixel_x, a -= 32)
					X.x--
					Pixel_x += 32
			if(Pixel_y > 32)
				for(var/a = 0, a <= Pixel_y, a += 32)
					X.y++
					Pixel_y -= 32
			if(Pixel_y < -32)
				for(var/a = 0, a >= Pixel_y, a -= 32)
					X.y--
					Pixel_y += 32
			X.pixel_x = Pixel_x + pixel_x
			X.pixel_y = Pixel_y + pixel_y
		stoplag()

	for(var/obj/effect/overlay/beam/O in orange(10,src))
		if(O.BeamSource == src)
			qdel(O)

	return TRUE

//All atoms
/atom/verb/atom_examine()
	set name = "Examine"
	set category = "IC"
	set src in view(usr.client) //If it can be seen, it can be examined.

	if(!usr) return
	examine(usr)

/atom/proc/examine(mob/user)
	to_chat(user, "[icon2html(src, user)] That's \a [src].") //changed to "That's" from "This is" because "This is some metal sheets" sounds dumb compared to "That's some metal sheets" ~Carn
	if(desc)
		to_chat(user, desc)

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

/atom/proc/ex_act()
	return

/atom/proc/fire_act()
	return

/atom/proc/hitby(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_ATOM_HITBY, AM)
	return

/atom/proc/add_hiddenprint(mob/living/M)
	if(!M || QDELETED(M) || !M.key || !(flags_atom  & FPRINT) || fingerprintslast == M.key)
		return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves)
			fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
		else
			fingerprintshidden += "\[[time_stamp()]\] Real name: [H.real_name], Key: [H.key]"
	else
		fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
	fingerprintslast = M.key


/atom/proc/add_fingerprint(mob/living/M)
	if(!M || QDELETED(M) || !M.key || !(flags_atom & FPRINT) || fingerprintslast == M.key)
		return
	if(!fingerprintshidden)
		fingerprintshidden = list()
	fingerprintslast = M.key

	if (ishuman(M))
		var/mob/living/carbon/human/H = M

		//Fibers~
		blood_touch(H)

		fingerprintslast = M.key

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			fingerprintshidden += "\[[time_stamp()]\](Wearing gloves). Real name: [H.real_name], Key: [H.key]"
		else
			fingerprintshidden += "\[[time_stamp()]\]Real name: [H.real_name], Key: [H.key]"
	else
		fingerprintshidden +=  "\[[time_stamp()]\]Real name: [M.real_name], Key: [M.key]"



//put blood on stuff we touched
/atom/proc/blood_touch(mob/living/carbon/human/M)
	if(M.gloves)
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.gloves_blood_amt && add_blood(G.blood_color)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
			G.gloves_blood_amt--
	else if(M.hands_blood_amt && add_blood(M.hands_blood_color))
		M.hands_blood_amt--




/atom/proc/transfer_fingerprints_to(var/atom/A)

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()




/atom/proc/add_vomit_floor(mob/living/carbon/M, var/toxvomit = 0)
	return

/turf/add_vomit_floor(mob/living/carbon/M, var/toxvomit = 0)
	var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

	// Make toxins vomit look different
	if(toxvomit)
		this.icon_state = "vomittox_[pick(1,4)]"


//Generalized Fire Proc.
/atom/proc/flamer_fire_act(var/dam = BURN_LEVEL_TIER_1, var/datum/cause_data/flame_cause_data)
	return

/atom/proc/acid_spray_act()
	return


//things that object need to do when a movable atom inside it is deleted
/atom/proc/on_stored_atom_del(atom/movable/AM)
	return

/atom/proc/handle_barrier_chance()
	return FALSE

/*
Called after New.
Must refer back to this parent or manually set initialized to TRUE.
Parameters are passed from New.
*/
/atom/proc/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(TRUE)
	if(flags_atom & INITIALIZED)
		CRASH("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	pass_flags = pass_flags_cache[type]
	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()
	Decorate(mapload)

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/process()
	return

///---CLONE---///

/atom/clone
	var/proj_x = 0
	var/proj_y = 0

/atom/proc/create_clone(shift_x, shift_y) //NOTE: Use only for turfs, otherwise use create_clone_movable
	var/turf/T = null
	T = locate(src.x + shift_x, src.y + shift_y, src.z)

	T.appearance = src.appearance
	T.setDir(src.dir)

	clones_t.Add(src)
	src.clone = T

// EFFECTS
/atom/proc/extinguish_acid()
	for(var/datum/effects/acid/A in effects_list)
		qdel(A)

/atom/proc/remove_weather_effects()
	for(var/datum/effects/weather/W in effects_list)
		qdel(W)

// Movement
/atom/proc/add_temp_pass_flags(flags_to_add)
	if (isnull(temp_flag_counter))
		temp_flag_counter = list()

	for (var/flag in GLOB.bitflags)
		if(!(flags_to_add & flag))
			continue
		var/flag_str = "[flag]"
		if (temp_flag_counter[flag_str])
			temp_flag_counter[flag_str] += 1
		else
			temp_flag_counter[flag_str] = 1
			flags_pass_temp |= flag

/atom/proc/remove_temp_pass_flags(flags_to_remove)
	if (isnull(temp_flag_counter))
		return

	for (var/flag in GLOB.bitflags)
		if(!(flags_to_remove & flag))
			continue
		var/flag_str = "[flag]"
		if (temp_flag_counter[flag_str])
			temp_flag_counter[flag_str] -= 1
			if (temp_flag_counter[flag_str] == 0)
				temp_flag_counter -= flag_str
				flags_pass_temp &= ~flag

// This proc is for initializing pass flags (allows for inheriting pass flags and list-based pass flags)
/atom/proc/initialize_pass_flags(var/datum/pass_flags_container/PF)
	return

/atom/proc/enable_pixel_scaling()
	appearance_flags |= PIXEL_SCALE

/atom/proc/disable_pixel_scaling()
	appearance_flags &= ~PIXEL_SCALE

///Passes Stat Browser Panel clicks to the game and calls client click on an atom
/atom/Topic(href, list/href_list)
	if(!usr?.client)
		return
	var/client/usr_client = usr.client
	var/list/paramslist = list()
	if(href_list["statpanel_item_middleclick"])
		paramslist["middle"] = "1"
	if(href_list["statpanel_item_shiftclick"])
		paramslist["shift"] = "1"
	if(href_list["statpanel_item_ctrlclick"])
		paramslist["ctrl"] = "1"
	if(href_list["statpanel_item_altclick"])
		paramslist["alt"] = "1"
	if(href_list["statpanel_item_click"])
		// first of all make sure we valid
		var/mouseparams = list2params(paramslist)
		usr_client.ignore_next_click = FALSE
		usr_client.Click(src, loc, TRUE, mouseparams)
		return TRUE

///This proc is called on atoms when they are loaded into a shuttle
/atom/proc/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	return

/**
 * Hook for running code when a dir change occurs
 *
 * Not recommended to use, listen for the [COMSIG_ATOM_DIR_CHANGE] signal instead (sent by this proc)
 */
/atom/proc/setDir(newdir)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, newdir)
	dir = newdir


/atom/proc/add_filter(name,priority,list/params)
	LAZYINITLIST(filter_data)
	var/list/p = params.Copy()
	p["priority"] = priority
	filter_data[name] = p
	update_filters()

/atom/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, /proc/cmp_filter_data_priority, TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))
	UNSETEMPTY(filter_data)

/atom/proc/transition_filter(name, time, list/new_params, easing, loop)
	var/filter = get_filter(name)
	if(!filter)
		return

	var/list/old_filter_data = filter_data[name]

	var/list/params = old_filter_data.Copy()
	for(var/thing in new_params)
		params[thing] = new_params[thing]

	animate(filter, new_params, time = time, easing = easing, loop = loop)
	for(var/param in params)
		filter_data[name][param] = params[param]

/atom/proc/change_filter_priority(name, new_priority)
	if(!filter_data || !filter_data[name])
		return

	filter_data[name]["priority"] = new_priority
	update_filters()

/*/obj/item/update_filters()
	. = ..()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()*/

/atom/proc/get_filter(name)
	if(filter_data && filter_data[name])
		return filters[filter_data.Find(name)]

/atom/proc/remove_filter(name_or_names)
	if(!filter_data)
		return

	var/found = FALSE
	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(filter_data[name])
			filter_data -= name
			found = TRUE

	if(found)
		update_filters()

/atom/proc/clear_filters()
	filter_data = null
	filters = null


//Shamelessly stolen from TG
/atom/proc/Shake(var/pixelshiftx = 15, var/pixelshifty = 15, var/duration = 250)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	var/shiftx = rand(-pixelshiftx,pixelshiftx)
	var/shifty = rand(-pixelshifty,pixelshifty)
	animate(src, pixel_x = pixel_x + shiftx, pixel_y = pixel_y + shifty, time = 0.2, loop = duration)
	pixel_x = initialpixelx
	pixel_y = initialpixely
