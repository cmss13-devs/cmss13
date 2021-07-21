/// Generic task
/datum/nmtask
	/// Task name
	var/name

/// Performs work, returning status as boolean
/datum/nmtask/proc/execute()
	PROTECTED_PROC(TRUE)
	return NM_TASK_OK

/**
 * Call wrapper for executing the task
 * Very important note that the whole thing relies on this single one *NOT* crashing
 * as it's our mechanism for handling sleeps, or crashes within task implements.
 * This ensures something is always returned eventually and tasks are not left dangling.
 * 
 * Intended usage is to call it from a waitfor=0 wrapper, passing a callback
 * If the task sleeps, invoke() early-returns NM_TASK_ASYNC and keeps following it
 * Once it effectively finishes, the provided callback receives result.
 *
 * Do note that on_completion is completion of invocation, not task
 */
/datum/nmtask/proc/invoke(datum/callback/on_completion)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = NM_TASK_ASYNC
	. = execute()
	if(. == NM_TASK_ASYNC) // No explicit detach, clunky to handle
		. = NM_TASK_ERROR
	on_completion?.Invoke(.)

/// Logging wrapper
/datum/nmtask/proc/logself(message, critical = FALSE, prefix)
	if(!critical && !CONFIG_GET(flag/nightmare_debug))
		return
	if(prefix)
		log_debug("NMTASK  \[[prefix]\] \[[name]\]: [message]")
		return
	log_debug("NMTASK \[[name]\]: [message]")