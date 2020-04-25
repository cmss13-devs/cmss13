/*
HOW TO MAKE A CALLBACK:
	var/datum/callback/C = new(object|null, /proc/type/path|"procstring", arg1, arg2, ... argn)

HOW TO MAKE A TIMER:
	C being a callback datum as shown above, 
	var/timerid = add_timer(C, time, timertype)
	var/timerid = add_timer(CALLBACK(object|null, /proc/type/path|procstring, arg1, arg2, ... argn), time, timertype)

PROC STRINGS ARE BAD, they can only be done for datum proc calls and they dont give compile errors.

INVOKING THE CALLBACK:
	C being a callback datum ,
	var/result = C.Invoke(args, to, add) //additional args are added after the ones given when the callback was created
	var/result = C.InvokeAsync(args, to, add) //Sleeps will not block, returns . on the first sleep (then continues on in the "background" after the sleep/block ends), otherwise operates normally.
	INVOKE_ASYNC(<CALLBACK args>) to immediately create and call InvokeAsync

HELP TO PROC TYPEPATH SHORTCUTS (Purely based on the path in the code)
	Global proc while in another global proc:
		.procname
		Example:
			CALLBACK(GLOBAL_PROC, .some_proc_here)

	Proc defined on current(src) object (when in a /proc/ and NOT AN OVERRIDE) OR overridden at src or any of it's parents:
		.procname
		Example:
			CALLBACK(src, .some_proc_here)


	When the above doesn't apply:
		.proc/procname
		Example:
			CALLBACK(src, .proc/some_proc_here)

	Proc defined on a parent of a some type:
		/some/type/.proc/some_proc_here

	If you can't do the above or want to be sure, use the full path (/type/of/thing/proc/procname)
*/

/datum/callback
	var/datum/object = GLOBAL_PROC
	var/delegate
	var/list/arguments

/datum/callback/New(thingtocall, proctocall, ...)
	if (thingtocall)
		object = thingtocall
	delegate = proctocall
	if (length(args) > 2)
		arguments = args.Copy(3)

/proc/ImmediateInvokeAsync(thingtocall, proctocall, ...)
	set waitfor = FALSE

	if (!thingtocall)
		return

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	if (thingtocall == GLOBAL_PROC)
		call(proctocall)(arglist(calling_arguments))
	else
		call(thingtocall, proctocall)(arglist(calling_arguments))

/datum/callback/proc/Invoke(...)
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))

//copy and pasted because fuck proc overhead
/datum/callback/proc/InvokeAsync(...)
	set waitfor = FALSE
	if (!object)
		return
	var/list/calling_arguments = arguments
	if (length(args))
		if (length(arguments))
			calling_arguments = calling_arguments + args //not += so that it creates a new list so the arguments list stays clean
		else
			calling_arguments = args
	if (object == GLOBAL_PROC)
		return call(delegate)(arglist(calling_arguments))
	return call(object, delegate)(arglist(calling_arguments))

// DYNAMIC callbacks. Certainly will be loved by the NDatabase
// The difference is simple. Object is NEVER passed in constructor. First parameter of any INVOKE is our object
/datum/callback/dynamic/New(proctocall, ...)
	object = null
	delegate = proctocall
	if (length(args) > 1)
		arguments = args.Copy(2)

/datum/callback/dynamic/Invoke(...)	
	var/list/calling_arguments = arguments
	if (length(args))
		object = args[1]
		if (length(arguments))
			calling_arguments = calling_arguments + args.Copy(2)
		else
			calling_arguments = args.Copy(2)
	if (!object)
		return
	return call(object, delegate)(arglist(calling_arguments))

/datum/callback/dynamic/InvokeAsync(...)	
	set waitfor = FALSE
	var/list/calling_arguments = arguments
	if (length(args))
		object = args[1]
		if (length(arguments))
			calling_arguments = calling_arguments + args.Copy(2)
		else
			calling_arguments = args.Copy(2)
	if (!object)
		return
	return call(object, delegate)(arglist(calling_arguments))