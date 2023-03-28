#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE

	var/old_initialized

	var/list/late_loaders = list()
	var/list/roundstart_loaders = list()

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()

	// Set up roundstart seed list. This is here because vendors were
	// bugging out and not populating with the correct packet names
	// due to this list not being instantiated.
	populate_seed_list()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	initialized = INITIALIZATION_INNEW_MAPLOAD

	fix_atoms_locs(atoms)

	var/count
	var/list/mapload_arg = list(TRUE)
	if(atoms)
		count = atoms.len
		for(var/I in atoms)
			var/atom/A = I
			if(!(A.flags_atom & INITIALIZED))
				InitAtom(I, TRUE, mapload_arg)
				CHECK_TICK
	else
		count = 0
		for(var/atom/A in world)
			if(!(A.flags_atom & INITIALIZED))
				InitAtom(A, FALSE, mapload_arg)
				++count
				CHECK_TICK

	testing("Initialized [count] atoms")
	pass(count)

	initialized = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/I in late_loaders)
			var/atom/A = I
			A.LateInitialize()
		testing("Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

/// Init this specific atom
/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, from_template = FALSE, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	#ifdef UNIT_TESTS
	var/start_tick = world.time
	#endif

	var/result = A.Initialize(arglist(arguments))

	#ifdef UNIT_TESTS
	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT
	#endif

	var/qdeleted = FALSE

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1]) //mapload
					late_loaders += A
				else
					A.LateInitialize()
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			if(INITIALIZE_HINT_ROUNDSTART)
				if(SSticker.current_state >= GAME_STATE_PLAYING)
					A.LateInitialize()
				else
					roundstart_loaders += A
			else
				BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A) //possible harddel
		qdeleted = TRUE
	else if(!(A.flags_atom & INITIALIZED))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT
	/*
	else
		SEND_SIGNAL(A,COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE)
		if(created_atoms && from_template && ispath(the_type, /atom/movable))//we only want to populate the list with movables
			created_atoms += A.get_all_contents()
	*/

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/proc/lateinit_roundstart_atoms()
	for(var/atom/A as anything in roundstart_loaders)
		A.LateInitialize()
	roundstart_loaders.Cut()

/// Force reset atoms loc, as map expansion can botch turf contents for multitiles
/// This is obviously a bandaid fix, see CM MR !2797, /tg/ PR #65638,
/// and the BYOND Bug Report: http://www.byond.com/forum/post/2777527
/datum/controller/subsystem/atoms/proc/fix_atoms_locs(list/atoms)
	if(atoms)
		for(var/atom/movable/A in atoms)
			A.loc = A.loc
	else
		for(var/atom/movable/A in world)
			A.loc = A.loc

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_initialized = initialized
	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	initialized = old_initialized

/datum/controller/subsystem/atoms/Recover()
	initialized = SSatoms.initialized
	if(initialized == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_initialized = SSatoms.old_initialized
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "data/initialize.log")
