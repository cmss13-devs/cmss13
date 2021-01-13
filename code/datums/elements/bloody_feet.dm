/datum/element/bloody_feet
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 4
	/// The amount of steps you can take to make bloody footsteps
	var/steps_to_take
	/// Color of the tracks left behind
	var/color
	/// State var to track the shoes (if any) of the humans
	/// with this element
	var/list/target_shoes

/datum/element/bloody_feet/Attach(datum/target, dry_time, obj/item/clothing/shoes, steps, bcolor)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE

	steps_to_take = steps
	color = bcolor

	var/mob/living/carbon/human/H = target
	H.bloody_footsteps = steps_to_take

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/on_moved)
	RegisterSignal(target, COMSIG_HUMAN_BLOOD_CROSSED, .proc/blood_crossed)
	RegisterSignal(target, COMSIG_HUMAN_CLEAR_BLOODY_FEET, .proc/clear_blood)
	if(shoes)
		LAZYSET(target_shoes, target, shoes)
		RegisterSignal(shoes, COMSIG_ITEM_DROPPED, .proc/on_shoes_removed)

	if(dry_time)
		addtimer(CALLBACK(src, .proc/clear_blood, target), dry_time)

/datum/element/bloody_feet/Detach(datum/target, force)
	UnregisterSignal(target, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_HUMAN_BLOOD_CROSSED,
		COMSIG_HUMAN_CLEAR_BLOODY_FEET,
	))
	if(LAZYACCESS(target_shoes, target))
		UnregisterSignal(target_shoes[target], COMSIG_ITEM_DROPPED)
		LAZYREMOVE(target_shoes, target)

	var/mob/living/carbon/human/H = target
	H.bloody_footsteps = 0

	return ..()

/datum/element/bloody_feet/proc/on_moved(mob/living/carbon/human/target, oldLoc, direction)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, .proc/add_tracks, target, oldLoc, direction)

/datum/element/bloody_feet/proc/add_tracks(mob/living/carbon/human/target, oldLoc, direction)
	// FIXME: This shit is retarded and Entered should be refactored
	if(target.bloody_footsteps == steps_to_take)
		target.bloody_footsteps--
		return

	var/turf/T_in = target.loc
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

	// Need to do the value check first because
	// of the Entered issue mentioned above
	if(target.bloody_footsteps-- <= 0)
		Detach(target)

/datum/element/bloody_feet/proc/on_shoes_removed(datum/target)
	SIGNAL_HANDLER
	Detach(target)

/datum/element/bloody_feet/proc/blood_crossed(mob/living/carbon/human/target, amount, bcolor, dry_time_left)
	SIGNAL_HANDLER
	Detach(target)
	target.AddElement(/datum/element/bloody_feet, dry_time_left, target.shoes, amount, bcolor)

/datum/element/bloody_feet/proc/clear_blood(datum/target)
	Detach(target)
