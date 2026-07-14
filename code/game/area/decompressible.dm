/area/decompressible
	/// How long it takes for this room to repressurize and become habitable.
	/// Set to -1 for rooms that are permanently decompressed.
	var/recompression_time = -1

	/// Is this room currently decompressed?
	var/decompressed = FALSE

	/// When in gametime this room was decompressed.
	var/time_decompressed = null

/area/decompressible/proc/decompress(/turf/breach_location)
	decompressed = TRUE
	time_decompressed = REALTIMEOFDAY

	temperature = 42 // 42 K

	for (var/obj/obj_in_area in src)
		if (!obj_in_area)
			continue
		if (obj_in_area.anchored)
			continue

		var/obj/structure/window/framed/decompressible/window = obj_in_area
		// TODO: Handle decompression shutters

		// Throw everything not bolted down towards the breach location
		obj_in_area.throw_atom(breach_location, range = 8, speed = SPEED_VERY_FAST, thrower = src, launch_type = HIGH_LAUNCH)

	for (var/mob/living/carbon/mob in src)
		mob.throw_atom(breach_location, range = 8, speed = SPEED_FAST, thrower = src)
		to_chat(mob, SPAN_HIGHDANGER("You are violently thrown off your feet as the air around you rushes towards the breach!"))

		var/mob/living/carbon/human/human = mob
		if (human != null)
			var/datum/internal_organ/lungs/lungs = human.internal_organs_by_name["lungs"]
			if (!lungs || lungs.organ_status & ORGAN_BROKEN)
				continue

			// Rupture their lungs if they're not already
			lungs.take_damage(20)
			to_chat(mob, SPAN_DANGER("You feel your lungs explode during the rapid decompression!"))

	if (recompression_time != -1)
		addtimer(CALLBACK(src, PROC_REF(recompress)), recompression_time)

/area/decompressible/proc/recompress()
	decompressed = FALSE
	time_decompressed = null

	temperature = initial(temperature)
