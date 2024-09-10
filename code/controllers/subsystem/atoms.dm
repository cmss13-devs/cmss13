#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE

	var/old_initialized
	/// A count of how many initalize changes we've made. We want to prevent old_initialize being overridden by some other value, breaking init code
	var/initialized_changed = 0
	var/init_start_time
	var/processing_late_loaders = FALSE

	var/list/late_loaders = list()
	var/list/roundstart_loaders = list()

	var/list/BadInitializeCalls = list()

	///initAtom() adds the atom its creating to this list iff InitializeAtoms() has been given a list to populate as an argument
	var/list/created_atoms

	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/Initialize(timeofday)
	init_start_time = world.time
	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	initialized = INITIALIZATION_INNEW_REGULAR
	old_initialized = initialized

	// Set up roundstart seed list. This is here because vendors were
	// bugging out and not populating with the correct packet names
	// due to this list not being instantiated.
	populate_seed_list()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms, list/atoms_to_return)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	set_tracked_initalized(INITIALIZATION_INNEW_MAPLOAD)

	fix_atoms_locs(atoms)

	// This may look a bit odd, but if the actual atom creation runtimes for some reason, we absolutely need to set initialized BACK
	CreateAtoms(atoms)
	clear_tracked_initalize()

	InitializeLateLoaders()

/// Processes all late_loaders, checking the length each iteration and prevents duplicate calls
/// This is necessary because of an edge case where there might be simultanious calls to InitializeAtoms
/datum/controller/subsystem/atoms/proc/InitializeLateLoaders()
	if(processing_late_loaders) // If we still manage to double this proc, try a ++ here, or solve the root of the problem
		#ifdef TESTING
		testing("Ignoring duplicate request to InitializeLateLoaders")
		#endif
		return

	processing_late_loaders = TRUE

	for(var/I = 1; I <= length(late_loaders); I++)
		var/atom/A = late_loaders[I]
		//I hate that we need this
		if(QDELETED(A))
			continue
		A.LateInitialize()

	#ifdef TESTING
	testing("Late initialized [length(late_loaders)] atoms")
	#endif
	late_loaders.Cut()
	processing_late_loaders = FALSE

/// Actually creates the list of atoms. Exists soley so a runtime in the creation logic doesn't cause initalized to totally break
/datum/controller/subsystem/atoms/proc/CreateAtoms(list/atoms, list/atoms_to_return = null)
	if (atoms_to_return)
		LAZYINITLIST(created_atoms)

	#ifdef TESTING
	var/count
	#endif

	var/list/mapload_arg = list(TRUE)
	if(atoms)
		#ifdef TESTING
		count = length(atoms)
		#endif

		for(var/I in 1 to length(atoms))
			var/atom/A = atoms[I]
			if(!(A.flags_atom & INITIALIZED))
				CHECK_TICK
				InitAtom(A, TRUE, mapload_arg)
	else
		#ifdef TESTING
		count = 0
		#endif

		for(var/atom/A as anything in world)
			if(!(A.flags_atom & INITIALIZED))
				InitAtom(A, FALSE, mapload_arg)
				#ifdef TESTING
				++count
				#endif
				CHECK_TICK

	#ifdef TESTING
	testing("Initialized [count] atoms")
	#endif

/// Init this specific atom
/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, from_template = FALSE, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		// Check init_start_time to not worry about atoms created before the atoms SS that are cleaned up before this
		if (A.gc_destroyed > init_start_time)
			BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	// This is handled and battle tested by dreamchecker. Limit to UNIT_TESTS just in case that ever fails.
	#ifdef UNIT_TESTS
	var/start_tick = world.time
	#endif

	var/result = A.Initialize(arglist(arguments))

	#ifdef UNIT_TESTS
	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT
	#endif

	var/qdeleted = FALSE

	switch(result)
		if (INITIALIZE_HINT_NORMAL)
			pass()
		if(INITIALIZE_HINT_LATELOAD)
			if(arguments[1]) //mapload
				late_loaders += A
			else
				A.LateInitialize()
		if(INITIALIZE_HINT_ROUNDSTART)
			if(SSticker.current_state >= GAME_STATE_PLAYING)
				A.LateInitialize()
			else
				roundstart_loaders += A
		if(INITIALIZE_HINT_QDEL)
			qdel(A)
			qdeleted = TRUE
		else
			BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A) //possible harddel
		qdeleted = TRUE
	else if(!(A.flags_atom & INITIALIZED))
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT
	else
		SEND_SIGNAL(A, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON)
		if(created_atoms && from_template && ispath(the_type, /atom/movable))//we only want to populate the list with movables
			created_atoms += A.get_all_contents()

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
	set_tracked_initalized(INITIALIZATION_INSSATOMS)

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	clear_tracked_initalize()

/// Use this to set initialized to prevent error states where old_initialized is overridden. It keeps happening and it's cheesing me off
/datum/controller/subsystem/atoms/proc/set_tracked_initalized(value)
	if(!initialized_changed)
		old_initialized = initialized
		initialized = value
	else
		// TG has this as a stack_trace, but currently is a non-issue so lets not escalate it to be a runtime
		debug_log("We started maploading while we were already maploading. You doing something odd?")
	initialized_changed += 1

/datum/controller/subsystem/atoms/proc/clear_tracked_initalize()
	initialized_changed -= 1
	if(!initialized_changed)
		initialized = old_initialized

/// Returns TRUE if anything is currently being initialized
/datum/controller/subsystem/atoms/proc/initializing_something()
	return initialized_changed > 0

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
		text2file(initlog, "[GLOB.log_directory]/initialize.log")
