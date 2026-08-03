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
	/// Whether the human has moved into the turf giving them bloody feet
	/// Necessary because of how Crossed is called before Moved
	var/list/entered_bloody_turf

/datum/element/bloody_feet/Attach(datum/target, dry_time, obj/item/clothing/shoes, steps, bcolor)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE

	steps_to_take = steps
	color = bcolor

	var/mob/living/carbon/human/target_human = target
	target_human.bloody_footsteps = steps_to_take
	LAZYADD(entered_bloody_turf, target)

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)
	RegisterSignal(target, COMSIG_HUMAN_BLOOD_CROSSED, PROC_REF(blood_crossed), override = TRUE)
	RegisterSignal(target, COMSIG_HUMAN_CLEAR_BLOODY_FEET, PROC_REF(clear_blood), override = TRUE)
	if(shoes)
		LAZYSET(target_shoes, target, shoes)
		RegisterSignal(shoes, COMSIG_ITEM_DROPPED, PROC_REF(on_shoes_removed), override = TRUE)

	if(dry_time)
		addtimer(CALLBACK(src, PROC_REF(clear_blood), WEAKREF(target)), dry_time)

/datum/element/bloody_feet/Detach(datum/target, force)
	UnregisterSignal(target, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_HUMAN_BLOOD_CROSSED,
		COMSIG_HUMAN_CLEAR_BLOODY_FEET,
	))
	LAZYREMOVE(entered_bloody_turf, target)
	if(LAZYACCESS(target_shoes, target))
		UnregisterSignal(target_shoes[target], COMSIG_ITEM_DROPPED)
		LAZYREMOVE(target_shoes, target)

	var/mob/living/carbon/human/target_human = target
	if(ishuman(target_human))
		target_human.bloody_footsteps = 0

	return ..()

/datum/element/bloody_feet/proc/on_moved(mob/living/carbon/human/target, turf/old_loc, direction)
	SIGNAL_HANDLER
	if(target.stat == CONSCIOUS)
		INVOKE_ASYNC(src, PROC_REF(add_tracks), target, old_loc, direction)

/datum/element/bloody_feet/proc/add_tracks(mob/living/carbon/human/target, turf/old_loc, direction)
	if(GLOB.perf_flags & PERF_TOGGLE_NOBLOODPRINTS)
		Detach(target)
		return

	// FIXME: This shit is silly and Entered should be refactored
	if(LAZYISIN(entered_bloody_turf, target))
		LAZYREMOVE(entered_bloody_turf, target)
		return

	var/turf/T_in = target.loc
	var/turf/T_out = old_loc

	if(istype(T_in))
		var/obj/effect/decal/cleanable/blood/tracks/footprints/print = LAZYACCESS(T_in.cleanables, CLEANABLE_TRACKS)
		if(print)
			var/image/steps_image = LAZYACCESS(print.steps_in, "[direction]")
			if(!steps_image)
				print.add_tracks(direction, color, FALSE)
		else
			print = new(T_in)
			print.add_tracks(direction, color, FALSE)

	if(istype(T_out))
		var/obj/effect/decal/cleanable/blood/tracks/footprints/print = LAZYACCESS(T_out.cleanables, CLEANABLE_TRACKS)
		if(print)
			var/image/steps_image = LAZYACCESS(print.steps_out, "[direction]")
			if(!steps_image)
				print.add_tracks(direction, color, TRUE)
		else
			print = new(T_out)
			print.add_tracks(direction, color, TRUE)

	if(--target.bloody_footsteps <= 0)
		Detach(target)

/datum/element/bloody_feet/proc/on_shoes_removed(datum/target)
	SIGNAL_HANDLER
	Detach(target)

/datum/element/bloody_feet/proc/blood_crossed(mob/living/carbon/human/target, amount, bcolor, dry_time_left)
	SIGNAL_HANDLER
	Detach(target)
	target.AddElement(/datum/element/bloody_feet, dry_time_left, target.shoes, amount, bcolor)

/datum/element/bloody_feet/proc/clear_blood(datum/target)
	SIGNAL_HANDLER
	if(isweakref(target))
		var/datum/weakref/target_ref = target
		target = target_ref.resolve()
	Detach(target)
