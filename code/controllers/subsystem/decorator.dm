// our atom declaration should not be hardcoded for this SS existance.
// if this subsystem is deleted, stuff still works
// That's why we define this here
/atom/proc/Decorate(deferable = FALSE)
	// Case 1: Early init - Skip it, we'll decorate everything during our init
	if(!SSdecorator.decoratable)
		return
	if(SSdecorator.registered_decorators[type])
		// Case 2: Deferable, usually non-init mapload - have SS do it later
		if(deferable)
			SSdecorator.decoratable += WEAKREF(src)
			return
		// Case 3: In-round spawning, just do it now
		SSdecorator.decorate(src)
	flags_atom |= ATOM_DECORATED
	SEND_SIGNAL(src, COMSIG_ATOM_DECORATED)

SUBSYSTEM_DEF(decorator)
	name = "Decorator"
	init_order = SS_INIT_DECORATOR
	priority = SS_PRIORITY_DECORATOR
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_BACKGROUND
	wait = 5 SECONDS

	var/list/registered_decorators = list()
	var/list/datum/decorator/active_decorators = list()
	var/list/datum/weakref/decoratable // List of things to decorate asynchronously
	var/list/datum/weakref/currentrun = list()

/datum/controller/subsystem/decorator/Initialize()
	var/list/all_decors = typesof(/datum/decorator) - list(/datum/decorator) - typesof(/datum/decorator/manual)
	for(var/decor_type in all_decors)
		var/datum/decorator/decor = new decor_type()
		if(!decor.is_active_decor())
			continue
		var/list/applicable_types = decor.get_decor_types()
		if(!applicable_types || !applicable_types.len)
			continue
		active_decorators |= decor
		for(var/app_type in applicable_types)
			if(!registered_decorators[app_type])
				registered_decorators[app_type] = list()
			registered_decorators[app_type] += decor

	for(var/i in registered_decorators)
		registered_decorators[i] = sortDecorators(registered_decorators[i])

	decoratable = list() // Put any extras here from there on
	for(var/atom/object in world)
		if(!(object.flags_atom & ATOM_DECORATED))
			object.Decorate(deferable = FALSE)
		CHECK_TICK
	return ..()

/datum/controller/subsystem/decorator/fire(resumed)
	if(Master.map_loading || !initialized)
		return

	if(!resumed && !length(currentrun))
		var/swap = decoratable
		decoratable = currentrun
		decoratable.Cut()
		currentrun = swap

	while(length(currentrun))
		var/datum/weakref/ref = currentrun[currentrun.len]
		currentrun.len--
		var/atom/A = ref?.resolve()
		if(A) A.Decorate(deferable = FALSE)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/decorator/proc/add_decorator(decor_type, ...)
	var/list/arguments = list()
	if (length(args) > 1)
		arguments = args.Copy(2)
	var/datum/decorator/decor = new decor_type(arglist(arguments))

	// DECORATOR IS ENABLED FORCEFULLY

	var/list/applicable_types = decor.get_decor_types()
	if(!applicable_types || !applicable_types.len)
		return
	active_decorators |= decor
	for(var/app_type in applicable_types)
		if(!registered_decorators[app_type])
			registered_decorators[app_type] = list()
		registered_decorators[app_type] += decor

	for(var/i in registered_decorators)
		registered_decorators[i] = sortDecorators(registered_decorators[i])

	return decor

/datum/controller/subsystem/decorator/proc/force_update()
	// OH GOD YOU BETTER NOT DO THIS IF YOU VALUE YOUR TIME
	for(var/atom/o in world)
		o.Decorate()

/datum/controller/subsystem/decorator/stat_entry(msg)
	if(registered_decorators && decoratable)
		msg = "D:[registered_decorators.len],P:[decoratable.len]"
	return ..()

/datum/controller/subsystem/decorator/proc/decorate(var/atom/o)
	if (!o || QDELETED(o))
		return

	var/list/datum/decorator/decors = registered_decorators[o.type]
	if(!decors)
		return

	for(var/datum/decorator/decor in decors)
		decor.decorate(o)

// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/datum/controller/subsystem/decorator/proc/sortDecorators(var/list/datum/decorator/L)
	if(!istype(L))
		return null
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeDecoratorLists(sortDecorators(L.Copy(0, middle)), sortDecorators(L.Copy(middle)))

/datum/controller/subsystem/decorator/proc/mergeDecoratorLists(var/list/datum/decorator/L, var/list/datum/decorator/R)
	var/Li=1
	var/Ri=1
	var/list/result = new()
	while(Li <= L.len && Ri <= R.len)
		if(sorttext(L[Li].priority, R[Ri].priority) < 1)
			// Works around list += list2 merging lists; it's not pretty but it works
			result += "temp item"
			result[result.len] = R[Ri++]
		else
			result += "temp item"
			result[result.len] = L[Li++]

	if(Li <= L.len)
		return (result + L.Copy(Li, 0))
	return (result + R.Copy(Ri, 0))

/datum/controller/subsystem/decorator/var/list/debugged_var
/datum/controller/subsystem/decorator/proc/debug_type(T)
	var/tt = text2path(T)
	debugged_var = registered_decorators[tt]
