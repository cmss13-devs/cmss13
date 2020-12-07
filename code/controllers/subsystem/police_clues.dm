SUBSYSTEM_DEF(clues)
	name          = "Clues"
	wait          = 10 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_DISEASE

	var/list/currentrun = list()
	var/list/prints_list = list()

/datum/controller/subsystem/clues/stat_entry()
	..("P:[prints_list.len]")

/datum/controller/subsystem/clues/fire(resumed = FALSE)
	if(!resumed && length(prints_list))
		currentrun = prints_list.Copy()

	while(currentrun.len)
		var/obj/effect/decal/prints/P = currentrun[currentrun.len]
		currentrun.len--

		if(!P || QDELETED(P))
			continue

		if(world.timeofday - P.created_time > 10 MINUTE)
			qdel(P)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/clues/proc/create_print(var/turf/location, var/mob/living/carbon/human/criminal_mob, var/incident = "")
	if(!location || !istype(criminal_mob) || SSticker.mode.is_in_endgame)
		return

	new /obj/effect/decal/prints(location, criminal_mob, incident)