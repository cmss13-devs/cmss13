#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

var/datum/subsystem/atoms/SSatoms

/datum/subsystem/atoms
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE

	var/init_state = INITIALIZATION_INSSATOMS
	var/old_init_state

	var/list/atoms_loaded_late
	var/list/initialize_gone_wrong = list()

/datum/subsystem/atoms/New()
	NEW_SS_GLOBAL(SSatoms)

/datum/subsystem/atoms/stat_entry()
	..("B:[initialize_gone_wrong.len]")

/datum/subsystem/atoms/Initialize(timeofday)
	init_state = INITIALIZATION_INNEW_MAPLOAD
	initialize_all_atoms()
	return ..()

/datum/subsystem/atoms/proc/initialize_all_atoms(var/list/created_atoms)
	if(init_state <= INITIALIZATION_INSSATOMS_LATE)
		return

	init_state = INITIALIZATION_INNEW_MAPLOAD

	LAZYINITLIST(atoms_loaded_late)

	var/list/mapload_arg = list(TRUE)
	if(created_atoms)
		for(var/I in created_atoms)
			var/atom/A = I
			if(!(A.flags_atom & INITIALIZED))
				initalize_atom(I, mapload_arg)
				CHECK_TICK
	else
		for(var/atom/A in world)
			if(!(A.flags_atom & INITIALIZED))
				initalize_atom(A, mapload_arg)
				CHECK_TICK

	init_state = INITIALIZATION_INNEW_REGULAR

	if(length(atoms_loaded_late))
		for(var/I in atoms_loaded_late)
			var/atom/A = I
			A.InitializeLate(TRUE)
		atoms_loaded_late.Cut()

/datum/subsystem/atoms/proc/initalize_atom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		initialize_gone_wrong[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		initialize_gone_wrong[the_type] |= BAD_INIT_SLEPT

	var/qdeleted = FALSE

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1])	//mapload
					atoms_loaded_late[A] = arguments
				else
					A.InitializeLate(arglist(arguments))
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			else
				initialize_gone_wrong[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!(A.flags_atom & INITIALIZED))
		initialize_gone_wrong[the_type] |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

/datum/subsystem/atoms/proc/map_loader_begin()
	old_init_state = init_state
	init_state = INITIALIZATION_INSSATOMS_LATE

/datum/subsystem/atoms/proc/map_loader_stop()
	init_state = old_init_state

/datum/subsystem/atoms/Recover()
	init_state = SSatoms.init_state
	if(init_state == INITIALIZATION_INNEW_MAPLOAD)
		initialize_all_atoms()
	old_init_state = SSatoms.old_init_state
	initialize_gone_wrong = SSatoms.initialize_gone_wrong

/datum/subsystem/atoms/proc/create_log()
	. = ""
	for(var/path in initialize_gone_wrong)
		. += "Path : [path] \n"
		var/fails = initialize_gone_wrong[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return a Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/subsystem/atoms/Shutdown()
	var/log = create_log()
	if(log)
		text2file(log, "data/initialize.log")

#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT