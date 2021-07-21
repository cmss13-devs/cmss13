/// Handles running several tasks in round-robin fashion
/datum/nmtask/multi
	name = "multi"
	var/list/datum/nmtask/tasks    = list() // All tasks, pending or done
	var/list/datum/nmtask/async    = list() // Async running - not actively handled
	var/list/datum/nmtask/queue    = list() // Those that still need to be ran
	var/list/datum/nmtask/finished = list() // Mapped to final return OK/ERROR

/datum/nmtask/multi/Destroy(force)
	. = ..()
	QDEL_NULL_LIST(tasks)
	QDEL_NULL_LIST(async)
	QDEL_NULL_LIST(queue)
	QDEL_NULL_LIST(finished)

/// Runs all tasks until completion
/datum/nmtask/multi/execute()
	queue = tasks.Copy()
	while(length(queue) || length(async))
		while(TICK_CHECK_HIGH_PRIORITY || (!length(queue) && length(async)))
			return NM_TASK_PAUSE
		var/datum/nmtask/T = queue[1]
		queue.Remove(T)
		invoke_task(T)
	if(CONFIG_GET(flag/nightmare_debug))
		report_status()
	return NM_TASK_OK

/// Call wrapper to invoke a task
/datum/nmtask/multi/proc/invoke_task(datum/nmtask/T)
	set waitfor = FALSE
	var/retval = T.invoke(CALLBACK(src, .proc/task_callback, T))
	if(retval == NM_TASK_ASYNC)
		async += T

/// Handles return status from tasks via callback
/datum/nmtask/multi/proc/task_callback(datum/nmtask/T, retval)
	if(!T) return
	async -= T
	switch(retval)
		if(NM_TASK_OK)
			finished[T] = NM_TASK_OK
		if(NM_TASK_PAUSE)
			queue += T
		else
			finished[T] = NM_TASK_ERROR

/// Report status to debug output
/datum/nmtask/multi/proc/report_status()
	var/tally_ok  = 0
	var/tally_err = 0
	for(var/datum/nmtask/N in finished)
		if(finished[N] == NM_TASK_OK)
			tally_ok++
		else tally_err++
	log_debug("NMTASK [name]: Tasks: OK=[tally_ok], Err=[tally_err]")

/// Registers a new task for execution
/datum/nmtask/multi/proc/register_task(datum/nmtask/T)
	tasks |= T