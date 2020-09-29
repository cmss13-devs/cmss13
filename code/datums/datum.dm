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

	/// Datum level flags
	var/datum_flags = NONE

	/// A weak reference to another datum
	var/datum/weakref/weak_reference

#ifdef TESTING
	var/running_find_references
	var/last_find_references = 0
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
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weak_reference = null	//ensure prompt GCing of weakref.

	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)

	return QDEL_HINT_QUEUE
