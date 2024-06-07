/**
* The absolute base class for everything
*
* A datum instantiated has no physical world prescence, use an atom if you want something
* that actually lives in the world
*
* Be very mindful about adding variables to this class, they are inherited by every single
* thing in the entire game, and so you can easily cause memory usage to rise a lot with careless
* use of variables at this level
*/
/datum
	/**
	* Tick count time when this object was destroyed.
	*
	* If this is non zero then the object has been garbage collected and is awaiting either
	* a hard del by the GC subsystme, or to be autocollected (if it has no references)
	*/
	var/gc_destroyed

	/// Active timers with this datum as the target
	var/list/active_timers
	/// Status traits attached to this datum. associative list of the form: list(trait name (string) = list(source1, source2, source3,...))
	var/list/_status_traits

	/**
	* Components attached to this datum
	*
	* Lazy associated list in the structure of `type:component/list of components`
	*/
	var/list/datum_components
	/**
	* Any datum registered to receive signals from this datum is in this list
	*
	* Lazy associated list in the structure of `signal:registree/list of registrees`
	*/
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/list/datum/callback/signal_procs
	/**
	* Is this datum capable of sending signals?
	*
	* Set to true when a signal has been registered
	*/
	var/signal_enabled = FALSE

	/// Datum level flags
	var/datum_flags = NONE

	/*
	* Lazy associative list of currently active cooldowns.
	*
	* cooldowns [ COOLDOWN_INDEX ] = add_timer()
	* add_timer() returns the truthy value of -1 when not stoppable, and else a truthy numeric index
	*/
	var/list/cooldowns

	/// A weak reference to another datum
	var/datum/weakref/weak_reference

#ifdef REFERENCE_TRACKING
	var/running_find_references
	var/last_find_references = 0
	#ifdef REFERENCE_TRACKING_DEBUG
	///Stores info about where refs are found, used for sanity checks and testing
	var/list/found_refs
	#endif
#endif

#ifdef DATUMVAR_DEBUGGING_MODE
	var/list/cached_vars
#endif

/**
* Default implementation of clean-up code.
*
* This should be overridden to remove all references pointing to the object being destroyed, if
* you do override it, make sure to call the parent and return it's return value by default
*
* Return an appropriate [QDEL_HINT][QDEL_HINT_QUEUE] to modify handling of your deletion;
* in most cases this is [QDEL_HINT_QUEUE].
*
* The base case is responsible for doing the following
* * Erasing timers pointing to this datum
* * Erasing compenents on this datum
* * Notifying datums listening to signals from this datum that we are going away
*
* Returns [QDEL_HINT_QUEUE]
*/
/datum/proc/Destroy(force=FALSE, ...)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weak_reference = null //ensure prompt GCing of weakref.

	if(cooldowns)
		for(var/cooldown as anything in cooldowns)
			var/cd_id = cooldowns[cooldown]
			if(cd_id != -1)
				deltimer(cd_id)

	if(active_timers)
		var/list/timers = active_timers
		active_timers = null
		for(var/datum/timedevent/timer as anything in timers)
			if (timer.spent && !(timer.flags & TIMER_DELETE_ME))
				continue
			qdel(timer)

	//BEGIN: ECS SHIT
	signal_enabled = FALSE

	if(datum_components)
		var/all_components = datum_components[/datum/component]
		if(length(all_components))
			for(var/datum/component/component as anything in all_components)
				qdel(component, FALSE, TRUE)
		else
			var/datum/component/C = all_components
			qdel(C, FALSE, TRUE)
		if(datum_components)
			debug_log("'[src]' datum_components was not null after removing all components! [datum_components.len] entries remained...")
			datum_components.Cut()

	var/list/lookup = comp_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/datum/component/comp as anything in comps)
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		comp_lookup = lookup = null

	for(var/target in signal_procs)
		UnregisterSignal(target, signal_procs[target])
	//END: ECS SHIT

	return QDEL_HINT_QUEUE

/**
 * Callback called by a timer to end an associative-list-indexed cooldown.
 *
 * Arguments:
 * * source - datum storing the cooldown
 * * index - string index storing the cooldown on the cooldowns associative list
 *
 * This sends a signal reporting the cooldown end.
 */
/proc/end_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	SEND_SIGNAL(source, COMSIG_CD_STOP(index))
	TIMER_COOLDOWN_END(source, index)


/**
 * Proc used by stoppable timers to end a cooldown before the time has ran out.
 *
 * Arguments:
 * * source - datum storing the cooldown
 * * index - string index storing the cooldown on the cooldowns associative list
 *
 * This sends a signal reporting the cooldown end, passing the time left as an argument.
 */
/proc/reset_cooldown(datum/source, index)
	if(QDELETED(source))
		return
	SEND_SIGNAL(source, COMSIG_CD_RESET(index), S_TIMER_COOLDOWN_TIMELEFT(source, index))
	TIMER_COOLDOWN_END(source, index)
