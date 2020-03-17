var/datum/subsystem/decorator/SSdecorator

// our atom declaration should not be hardcoded for this SS existance.
// if this subsystem is deleted, stuff still works
// That's why we define this here
/atom/Decorate()
	if(SSdecorator && SSdecorator.registered_decorators[type])
		SSdecorator.decorate(src)

/datum/subsystem/decorator
	name          = "Decorator"
	init_order    = SS_INIT_DECORATOR
	display_order = SS_DISPLAY_DECORATOR
	priority      = SS_PRIORITY_DECORATOR
	flags		  = SS_FIRE_IN_LOBBY

	can_fire = FALSE

	var/list/currentrun
	var/list/decoratable
	var/list/registered_decorators
	var/list/datum/decorator/active_decorators


/datum/subsystem/decorator/New()
	decoratable = list()
	registered_decorators = list()
	active_decorators = list()

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

	NEW_SS_GLOBAL(SSdecorator)

/datum/subsystem/decorator/Initialize()	
	for(var/atom/object in world)
		object.Decorate()
		CHECK_TICK
	..()

/datum/subsystem/decorator/proc/add_decorator(decor_type)	
	var/datum/decorator/decor = new decor_type()

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

/datum/subsystem/decorator/proc/force_update()
	// OH GOD YOU BETTER NOT DO THIS IF YOU VALUE YOUR TIME
	for(var/atom/o in world)
		o.Decorate()

/datum/subsystem/decorator/stat_entry()
	if(registered_decorators && decoratable)
		..("D:[registered_decorators.len],P:[decoratable.len]")
		return
	..("INITING")

/datum/subsystem/decorator/proc/decorate(var/atom/o)
	if (!o || o.disposed)
		return

	var/list/datum/decorator/decors = registered_decorators[o.type]
	if(!decors)
		return

	for(var/datum/decorator/decor in decors)
		decor.decorate(o)

// List of lists, sorts by element[key] - for things like crew monitoring computer sorting records by name.
/datum/subsystem/decorator/proc/sortDecorators(var/list/datum/decorator/L)
	if(!istype(L))
		return null
	if(L.len < 2)
		return L
	var/middle = L.len / 2 + 1
	return mergeDecoratorLists(sortDecorators(L.Copy(0, middle)), sortDecorators(L.Copy(middle)))

/datum/subsystem/decorator/proc/mergeDecoratorLists(var/list/datum/decorator/L, var/list/datum/decorator/R)
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
