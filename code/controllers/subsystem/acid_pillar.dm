SUBSYSTEM_DEF(acid_pillar)
	name          = "Acid Pillar"
	wait          = 0.2 SECONDS
	priority      = SS_PRIORITY_ACID_PILLAR
	flags		  = SS_NO_INIT

	var/list/queuedrun = list()
	var/list/currentrun = list()

/datum/controller/subsystem/acid_pillar/fire(resumed = FALSE)
	if (!resumed)
		currentrun = queuedrun.Copy()

	while (currentrun.len)
		var/hash = currentrun[currentrun.len]
		var/datum/acid_spray_info/data = currentrun[hash]
		currentrun.len--


		if(QDELETED(data))
			queuedrun -= hash
			data = null
			continue

		var/obj/effect/alien/resin/acid_pillar/P = data.source

		if(!P.acid_travel(data))
			qdel(data)
			queuedrun -= hash

		if (MC_TICK_CHECK)
			return


/datum/controller/subsystem/acid_pillar/proc/queue_attack(var/obj/effect/alien/resin/acid_pillar/P, var/atom/target)
	var/hash  = "([REF(P)])|([REF(target)])"

	if(queuedrun[hash])
		return

	var/datum/acid_spray_info/info = new()
	info.source = P
	info.target = target
	info.current_turf = P.loc
	info.hash = hash

	queuedrun[hash] = info

/datum/acid_spray_info
	var/obj/effect/alien/resin/acid_pillar/source
	var/atom/target
	var/turf/current_turf
	var/distance_travelled = 0
	var/hash

/datum/acid_spray_info/Destroy(force, ...)
	source = null
	target = null
	current_turf = null
	return ..()
