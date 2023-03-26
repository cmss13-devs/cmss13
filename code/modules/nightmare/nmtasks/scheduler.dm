/// Simple blocking executor to execute several tasks in a row
/datum/nmtask/scheduler
	var/list/datum/nmtask/tasks = list()
	var/list/datum/nmtask/donetasks = list()

/datum/nmtask/scheduler/Destroy()
	QDEL_NULL_LIST(tasks)
	QDEL_NULL_LIST(donetasks)
	return ..()

/datum/nmtask/scheduler/cleanup()
	QDEL_NULL_LIST(donetasks)
	return ..()

/datum/nmtask/scheduler/proc/add_task(datum/nmtask/task)
	tasks += task

/datum/nmtask/scheduler/execute()
	var/list/runtasks = src.tasks
	src.tasks = list()
	for(var/datum/nmtask/task as anything in runtasks)
		if(SSnightmare.stat != NIGHTMARE_STATUS_RUNNING)
			return NIGHTMARE_TASK_ERROR // Safety
		var/ret = task.invoke_sync()
		donetasks[task] = ret
	return NIGHTMARE_TASK_OK
