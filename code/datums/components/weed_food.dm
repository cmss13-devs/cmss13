#define WEED_FOOD_DELAY 5 MINUTES

/atom/movable/vis_obj/weed_food
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "human"
	vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	name = "weeds"
	desc = "Weird black weeds in the shape of a body..."
	gender = PLURAL

/**
 * A component that can be attached to a living mob to be merged with weeds after a delay.
 * Attempting to attach a new weed_food even if one already exists is equivalent to calling start().
 *
 * Attach this to any living mob that is dead (death or initialized dead) and it should handle the rest.
 */
/datum/component/weed_food
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	/// Whether we are actively being merged
	var/active = FALSE
	/// Whether we are completely merged with weeds
	var/merged = FALSE
	/// The time we were unmerged (just to handle weeds upgrading)
	var/unmerged_time
	/// Any active timer for a pending merge
	var/timer_id = null
	/// The weeds that we are merging/merged with
	var/obj/effect/alien/weeds/absorbing_weeds
	/// The living mob that we are bound to
	var/mob/living/parent_mob
	/// The turf that our parent is on
	var/turf/parent_turf
	/// The overlay image when merged
	var/atom/movable/vis_obj/weed_food/weed_appearance

/datum/component/weed_food/Initialize(...)
	. = ..()

	parent_mob = parent
	//if(!istype(parent_mob))
		//return COMPONENT_INCOMPATIBLE
	if(!istype(parent_mob, /mob/living/carbon/human))
		return COMPONENT_INCOMPATIBLE // At the moment we only support humans

	parent_turf = get_turf(parent_mob)

	start()

/datum/component/weed_food/InheritComponent(datum/component/C, i_am_original)
	. = ..()
	start()

/datum/component/weed_food/Destroy(force, silent)
	. = ..()

	unmerge_with_weeds()
	QDEL_NULL(weed_appearance)
	parent_mob = null
	parent_turf = null

/datum/component/weed_food/RegisterWithParent()
	. = ..()

	RegisterSignal(parent_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(parent_mob, COMSIG_LIVING_REJUVENATED, PROC_REF(on_rejuv))
	RegisterSignal(parent_mob, COMSIG_HUMAN_REVIVED, PROC_REF(on_rejuv))
	RegisterSignal(parent_mob, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(start))
	if(parent_turf)
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(start))

/datum/component/weed_food/UnregisterFromParent()
	. = ..()

	if(parent_mob)
		UnregisterSignal(parent_mob, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(parent_mob, COMSIG_LIVING_REJUVENATED)
		UnregisterSignal(parent_mob, COMSIG_HUMAN_REVIVED)
		UnregisterSignal(parent_mob, COMSIG_HUMAN_SET_UNDEFIBBABLE)
	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
	if(parent_turf)
		UnregisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH)

/// SIGNAL_HANDLER for COMSIG_MOVABLE_MOVED
/datum/component/weed_food/proc/on_move()
	SIGNAL_HANDLER

	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
		absorbing_weeds = null
	if(parent_turf)
		UnregisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH)
	parent_turf = get_turf(parent_mob)
	if(parent_turf)
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(start))

	// We moved, restart or start the proccess
	if(stop() || !merged)
		start()
		return

	// If we somehow moved when we were merged, handle that
	absorbing_weeds = parent_turf?.weeds
	if(absorbing_weeds)
		RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(unmerge_with_weeds))
	else
		unmerge_with_weeds()

/// SIGNAL_HANDLER for COMSIG_LIVING_REJUVENATED and COMSIG_HUMAN_REVIVED
/datum/component/weed_food/proc/on_rejuv()
	SIGNAL_HANDLER
	qdel(src)

/// Try to start the process to turn into weeds
/// SIGNAL_HANDLER for COMSIG_HUMAN_SET_UNDEFIBBABLE & COMSIG_WEEDNODE_GROWTH which should not set force TRUE
/datum/component/weed_food/proc/start(force = FALSE)
	SIGNAL_HANDLER

	if(active)
		return FALSE
	if(merged)
		return FALSE
	if(QDELETED(parent_mob))
		return FALSE
	if(parent_mob.is_xeno_grabbable())
		return FALSE
	if(!(parent_mob.status_flags & PERMANENTLY_DEAD))
		var/mob/living/carbon/human/parent_human = parent_mob
		if(istype(parent_human) && !parent_human.undefibbable)
			return FALSE

	if(parent_turf?.weeds)
		if(unmerged_time == world.time)
			// Weeds upgraded, re-merge now
			return merge_with_weeds()
		QDEL_NULL(weed_appearance) // if we're here, we know we aren't re-using the apperance
		absorbing_weeds = parent_turf.weeds
		RegisterSignal(parent_turf.weeds, COMSIG_PARENT_QDELETING, PROC_REF(stop))
	else if(!force)
		return FALSE

	active = TRUE
	timer_id = addtimer(CALLBACK(src, PROC_REF(merge_with_weeds), force), WEED_FOOD_DELAY, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_DELETE_ME|TIMER_OVERRIDE)

	return TRUE

/// Try to stop the process turning into weeds
/// Signal handler for COMSIG_PARENT_QDELETING of weeds
/datum/component/weed_food/proc/stop()
	SIGNAL_HANDLER

	if(!active)
		return FALSE

	active = FALSE
	deltimer(timer_id)
	timer_id = null

	return TRUE

/// Finish becomming one with the weeds
/datum/component/weed_food/proc/merge_with_weeds(force = FALSE)
	if(merged)
		return FALSE
	if(QDELETED(parent_mob))
		return FALSE

	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)

	if(!force && !parent_turf?.weeds)
		return FALSE

	absorbing_weeds = parent_turf?.weeds
	if(absorbing_weeds)
		RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(unmerge_with_weeds))

	active = FALSE
	merged = TRUE

	parent_mob.density = FALSE
	parent_mob.anchored = TRUE
	parent_mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	parent_mob.plane = FLOOR_PLANE
	parent_mob.remove_from_all_mob_huds()

	// Update the sprite
	if(!weed_appearance)
		weed_appearance = new()
	if(absorbing_weeds)
		weed_appearance.color = absorbing_weeds.color
	// For non-humans change the icon_state or something here
	parent_mob.vis_contents += weed_appearance

	return TRUE

/// Undo the weedening
/// SIGNAL_HANDLER for COMSIG_PARENT_QDELETING of weeds
/datum/component/weed_food/proc/unmerge_with_weeds()
	SIGNAL_HANDLER

	merged = FALSE
	unmerged_time = world.time
	if(absorbing_weeds) // Just to supress errors if this proc is manually called
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
	absorbing_weeds = null

	parent_mob.anchored = FALSE
	parent_mob.mouse_opacity = MOUSE_OPACITY_ICON
	parent_mob.plane = GAME_PLANE
	parent_mob.add_to_all_mob_huds()
	parent_mob.vis_contents -= weed_appearance

#undef WEED_FOOD_DELAY
