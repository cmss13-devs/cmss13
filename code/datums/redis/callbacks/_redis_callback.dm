
/**
 * # Redis callbacks
 *
 * This datum is used for assigning callbacks that run
 * when a message is received on a specific channel. Subtypes of this
 * are automatically registered in SSredis initialization
 */
/datum/redis_callback
	/// redis channel that this callback subscribes to
	var/channel


/**
 * This proc is run when a message is received on the callback's channel.
 * Must be overwritten.
 *
 * Arguments:
 * * message - The message received on the redis channel.
 */
/datum/redis_callback/proc/on_message(message)
	CRASH("on_message not overridden for [type]!")

/datum/redis_callback/vv_edit_var(var_name, var_value)
	return FALSE

/datum/redis_callback/CanProcCall(procname)
	return FALSE
