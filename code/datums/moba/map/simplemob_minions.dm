/obj/effect/moba_simplemob_checkpoint
	var/list/next_coordinate_set = list()

/obj/effect/moba_simplemob_checkpoint/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(get_turf(src), COMSIG_TURF_ENTERED, PROC_REF(on_turf_enter))

/obj/effect/moba_simplemob_checkpoint/proc/on_turf_enter(datum/source, atom/movable/entering)
	SIGNAL_HANDLER

	if(!istype(entering, /mob/living/carbon/xenomorph/lesser_drone/moba))
		return

	var/mob/living/carbon/xenomorph/lesser_drone/moba/minion = entering
	minion.next_turf_target = locate(next_coordinate_set[1], next_coordinate_set[2], next_coordinate_set[3])

/mob/living/carbon/xenomorph/lesser_drone/moba
	var/mob/living/target
	var/turf/next_turf_target

/mob/living/carbon/xenomorph/lesser_drone/moba/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	START_PROCESSING(SSprocessing)

/mob/living/carbon/xenomorph/lesser_drone/moba/Destroy()
	target = null
	next_turf_target
	return ..()

/mob/living/carbon/xenomorph/lesser_drone/moba/process(delta_time)
	if(!target)
		move_to_next_point()

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/move_to_next_point()
	walk_to(src, next_turf_target, 0)
