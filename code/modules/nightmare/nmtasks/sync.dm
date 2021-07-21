/// Handles running several tasks in a row
/datum/nmtask/sync
	name = "sync"
	var/paused = FALSE
	var/list/datum/nmtask/queue    = list() // Those that still need to be ran
	var/list/datum/nmtask/finished = list() // Mapped to final return OK/ERROR

/datum/nmtask/sync/Destroy(force)
	. = ..()
	QDEL_NULL_LIST(queue)
	QDEL_NULL_LIST(finished)

/// Runs all tasks until completion
/datum/nmtask/sync/execute()
	while(length(queue))
		while(paused || TICK_CHECK_HIGH_PRIORITY)
			return NM_TASK_PAUSE
		var/datum/nmtask/T = queue[1]
		invoke_task(T)
	if(CONFIG_GET(flag/nightmare_debug))
		report_status()
	return NM_TASK_OK

/// Call wrapper to invoke a task
/datum/nmtask/sync/proc/invoke_task(datum/nmtask/T)
	set waitfor = FALSE
	paused = TRUE
	T.invoke(CALLBACK(src, .proc/task_callback))

/// Handles return status from tasks via callback
/datum/nmtask/sync/proc/task_callback(retval)
	if(!length(queue)) return
	var/datum/nmtask/T = queue[1]
	paused = FALSE
	switch(retval)
		if(NM_TASK_OK)
			finished[T] = NM_TASK_OK
		if(NM_TASK_PAUSE)		
			return
		else
			finished[T] = NM_TASK_ERROR
	queue.Remove(T)

/// Report status to debug output
/datum/nmtask/sync/proc/report_status()
	var/tally_ok  = 0
	var/tally_err = 0
	for(var/datum/nmtask/N in finished)
		if(finished[N] == NM_TASK_OK)
			tally_ok++
		else tally_err++
	log_debug("NMTASK [name]: Tasks: OK=[tally_ok], Err=[tally_err]")

/// Registers a new task for execution
/datum/nmtask/sync/proc/register_task(datum/nmtask/T)
	queue += T