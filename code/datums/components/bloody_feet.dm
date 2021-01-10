/datum/component/bloody_feet
	var/steps_left = 0 // How many steps before tracks are no longer left behind
	var/color // Color of the tracks left behind
	var/dry_timer_id // The id timer for the bloody feet to dry
	var/first_moved = TRUE // A bandaid var because Crossed is called before Moved :D

/datum/component/bloody_feet/Initialize(steps_to_take, bcolor, dry_time, obj/item/clothing/shoes)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	steps_left = steps_to_take
	color = bcolor

	var/mob/living/carbon/human/H = parent
	H.bloody_feet = src

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)
	if(shoes)
		RegisterSignal(shoes, COMSIG_ITEM_DROPPED, .proc/on_shoes_removed)

	if(dry_time)
		dry_timer_id = addtimer(CALLBACK(src, .proc/dry), dry_time, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/datum/component/bloody_feet/Destroy(force, silent)
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

	var/mob/living/carbon/human/H = parent
	H.bloody_feet = null

	return ..()

/datum/component/bloody_feet/proc/on_moved(mob/living/carbon/human/source, oldLoc, direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, .proc/add_tracks, source, oldLoc, direction)

/datum/component/bloody_feet/proc/add_tracks(mob/living/carbon/human/source, oldLoc, direction)
	// FIXME: This shit is retarded and Entered should be refactored
	if(first_moved)
		first_moved = FALSE
		return

	var/turf/T_in = source.loc
	var/turf/T_out = oldLoc

	if(istype(T_in))
		var/obj/effect/decal/cleanable/blood/tracks/footprints/FP = LAZYACCESS(T_in.cleanables, CLEANABLE_TRACKS)
		if(FP)
			var/image/I = LAZYACCESS(FP.steps_in, "[direction]")
			if(!I)
				FP.add_tracks(direction, color, FALSE)
		else
			FP = new(T_in)
			FP.add_tracks(direction, color, FALSE)

	if(istype(T_out))
		var/obj/effect/decal/cleanable/blood/tracks/footprints/FP = LAZYACCESS(T_out.cleanables, CLEANABLE_TRACKS)
		if(FP)
			var/image/I = LAZYACCESS(FP.steps_out, "[direction]")
			if(!I)
				FP.add_tracks(direction, color, TRUE)
		else
			FP = new(T_out)
			FP.add_tracks(direction, color, TRUE)

	steps_left--
	if(!steps_left)
		qdel(src)

/datum/component/bloody_feet/proc/on_shoes_removed(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_ITEM_DROPPED)
	qdel(src)

/datum/component/bloody_feet/proc/blood_crossed(amount, bcolor, dry_time_left)
	color = bcolor
	steps_left = max(steps_left, amount)
	if(dry_time_left)
		dry_timer_id = addtimer(CALLBACK(src, .proc/dry), dry_time_left, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/datum/component/bloody_feet/proc/dry()
	qdel(src)
