/obj/structure/machinery/camera

	var/list/motionTargets = list()
	var/detectTime = 0
	var/area/ai_monitored/area_motion = null
	var/alarm_delay = 100 // Don't forget, there's another 10 seconds in queueAlarm()


/obj/structure/machinery/camera/process()
	// motion camera event loop
	if (stat & (EMPED|NOPOWER))
		return
	if(!isMotion())
		. = PROCESS_KILL
		return
	if (detectTime > 0)
		var/elapsed = world.time - detectTime
		if (elapsed > alarm_delay)
			triggerAlarm()
	else if (detectTime == -1)
		for (var/mob/target in motionTargets)
			if (target.stat == 2) lostTarget(target)
			// If not detecting with motion camera...

/obj/structure/machinery/camera/proc/newTarget(mob/target)
	if (detectTime == 0)
		detectTime = world.time // start the clock
	if (!(target in motionTargets))
		motionTargets += target
	return 1

/obj/structure/machinery/camera/proc/lostTarget(mob/target)
	if (target in motionTargets)
		motionTargets -= target
	if (length(motionTargets) == 0)
		cancelAlarm()

/obj/structure/machinery/camera/proc/cancelAlarm()
	if (!status || (stat & NOPOWER))
		return 0
	detectTime = 0
	return 1

/obj/structure/machinery/camera/proc/triggerAlarm()
	if (!status || (stat & NOPOWER))
		return 0
	if (!detectTime) return 0
	detectTime = -1
	return 1
