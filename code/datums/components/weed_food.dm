#define WEED_FOOD_DELAY 10 SECONDS
#define WEED_FOOD_STATE_DELAY 10 SECONDS // TODO: 1 MINUTES

/atom/movable/vis_obj/weed_food
	name = "weeds"
	desc = "Weird black weeds in the shape of a body..."
	gender = PLURAL
	vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	icon = 'icons/mob/xenos/weeds.dmi'
	var/static/list/icon_states = list("human_1","human_2","human_3","human_4","human_5")
	var/icon_state_idx = 0
	var/timer_id = null

/atom/movable/vis_obj/weed_food/Initialize(mapload, ...)
	timer_id = addtimer(CALLBACK(src, PROC_REF(on_animation_timer)), WEED_FOOD_STATE_DELAY, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_LOOP|TIMER_DELETE_ME)
	on_animation_timer()
	return ..()

/// Timer callback for changing the icon_state
/atom/movable/vis_obj/weed_food/proc/on_animation_timer()
	icon_state_idx++
	if(icon_state_idx > length(icon_states))
		deltimer(timer_id)
		timer_id = null
		return
	icon_state = icon_states[icon_state_idx]

/**
 * A component that can be attached to a mob/living to be merged with weeds after a delay.
 * Attempting to attach a new weed_food even if one already exists is equivalent to calling start().
 *
 * Attach this to any mob/living that is dead (death or initialized dead) and it should handle the rest.
 */
/datum/component/weed_food
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Whether we are waiting on timer to merge
	var/active = FALSE
	/// Whether we are merged with weeds
	var/merged = FALSE
	/// The time we were unmerged (just to handle weeds upgrading)
	var/unmerged_time
	/// Any active timer for a pending merge
	var/timer_id = null
	/// The living mob that we are bound to
	var/mob/living/parent_mob
	/// The turf that our parent is on
	var/turf/parent_turf
	/// The obj that our parent is buckled to and we have registered a signal
	var/obj/parent_buckle
	/// The weeds that we are merging/merged with
	var/obj/effect/alien/weeds/absorbing_weeds
	/// The overlay image when merged
	var/atom/movable/vis_obj/weed_food/weed_appearance

/datum/component/weed_food/Initialize(...)
	parent_mob = parent
	//if(!istype(parent_mob))
		//return COMPONENT_INCOMPATIBLE
	if(!istype(parent_mob, /mob/living/carbon/human))
		return COMPONENT_INCOMPATIBLE // TODO: At the moment we only support humans

	parent_turf = get_turf(parent_mob)
	if(parent_turf != parent_mob.loc)
		parent_turf = null // if our location is actually a container, we want to be safe from weeds

	start()

/datum/component/weed_food/InheritComponent(datum/component/C, i_am_original)
	start()

/datum/component/weed_food/Destroy(force, silent)
	. = ..()

	unmerge_with_weeds()
	QDEL_NULL(weed_appearance)
	parent_mob = null
	parent_turf = null

/datum/component/weed_food/RegisterWithParent()
	RegisterSignal(parent_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(parent_mob, list(COMSIG_LIVING_REJUVENATED, COMSIG_HUMAN_REVIVED), PROC_REF(on_rejuv))
	RegisterSignal(parent_mob, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(start))
	if(parent_turf)
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(start))

/datum/component/weed_food/UnregisterFromParent()
	if(parent_mob)
		UnregisterSignal(parent_mob, list(
			COMSIG_MOVABLE_MOVED,
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED,
			COMSIG_HUMAN_SET_UNDEFIBBABLE,
			))
	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
	if(parent_turf)
		UnregisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH)
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)

/// SIGNAL_HANDLER for COMSIG_MOVABLE_MOVED
/datum/component/weed_food/proc/on_move()
	SIGNAL_HANDLER

	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
		absorbing_weeds = null

	if(parent_turf)
		UnregisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH)
	parent_turf = get_turf(parent_mob)
	if(parent_turf != parent_mob.loc)
		parent_turf = null // if our location is actually a container, we want to be safe from weeds
	else
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(start))

	// We moved, restart or start the proccess
	if(stop() || !merged)
		start()
		return

	// If we somehow moved when we were merged, handle that
	absorbing_weeds = parent_turf?.weeds
	if(absorbing_weeds)
		RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(unmerge_with_weeds))
		return
	unmerge_with_weeds()

/// SIGNAL_HANDLER for COMSIG_LIVING_REJUVENATED and COMSIG_HUMAN_REVIVED
/datum/component/weed_food/proc/on_rejuv()
	SIGNAL_HANDLER

	message_admins("on_rejuv [parent_mob]") // TODO: Remove this
	qdel(src)

/// SIGNAL_HANDLER for COSMIG_OBJ_AFTER_BUCKLE
/datum/component/weed_food/proc/on_after_buckle(obj/source, mob/buckled)
	SIGNAL_HANDLER

	if(buckled)
		return
	start() // We unbuckled, so lets try to start again

/**
 * Try to start the process to turn into weeds
 * SIGNAL_HANDLER for COMSIG_HUMAN_SET_UNDEFIBBABLE & COMSIG_WEEDNODE_GROWTH
 * Returns TRUE if started successfully
 */
/datum/component/weed_food/proc/start()
	SIGNAL_HANDLER

	if(active)
		return FALSE
	if(merged)
		return FALSE
	if(QDELETED(parent_mob))
		return FALSE

	if(parent_mob.buckled)
		if(parent_mob.buckled == parent_buckle)
			return FALSE // Still buckled to the same thing
		if(!istype(parent_mob.buckled, /obj/structure/bed/nest))
			message_admins("cant start [parent_mob] because we are buckled. Listening...") // TODO: Remove this
			if(parent_buckle) // Still have a lingering reference somehow?
				UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
			parent_buckle = parent_mob.buckled
			RegisterSignal(parent_mob.buckled, COSMIG_OBJ_AFTER_BUCKLE, PROC_REF(on_after_buckle))
			return FALSE
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
		parent_buckle = null

	if(parent_mob.is_xeno_grabbable())
		message_admins("cant start [parent_mob] because we are grabable") // TODO: Remove this
		return FALSE
	if(!(parent_mob.status_flags & PERMANENTLY_DEAD))
		var/mob/living/carbon/human/parent_human = parent_mob
		if(istype(parent_human) && !parent_human.undefibbable)
			message_admins("cant start [parent_mob] because we are defibbable revive status: [parent_human.is_revivable()]") // TODO: Remove this
			return FALSE
	if(!parent_turf?.weeds)
		message_admins("cant start [parent_mob] because we aren't on weeds") // TODO: Remove this
		return FALSE

	if(unmerged_time == world.time)
		return merge_with_weeds() // Weeds upgraded, re-merge now re-using the apperance
	QDEL_NULL(weed_appearance)
	absorbing_weeds = parent_turf.weeds
	RegisterSignal(parent_turf.weeds, COMSIG_PARENT_QDELETING, PROC_REF(stop))

	active = TRUE
	timer_id = addtimer(CALLBACK(src, PROC_REF(merge_with_weeds)), WEED_FOOD_DELAY, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_DELETE_ME|TIMER_OVERRIDE)

	message_admins("started [parent_mob]") // TODO: Remove this
	return TRUE

/**
 * Try to stop the process turning into weeds
 * Signal handler for COMSIG_PARENT_QDELETING of weeds
 * Returns TRUE if stopped successfully (was active when called)
 */
/datum/component/weed_food/proc/stop()
	SIGNAL_HANDLER

	if(!active)
		return FALSE

	active = FALSE
	deltimer(timer_id)
	timer_id = null

	message_admins("stopped [parent_mob]") // TODO: Remove this
	return TRUE

/**
 * Finish becomming one with the weeds
 * Returns TRUE if merged successfully
 */
/datum/component/weed_food/proc/merge_with_weeds()
	if(merged)
		return FALSE
	if(QDELETED(parent_mob))
		return FALSE

	if(absorbing_weeds) // Remove the signal that would call stop
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)

	if(parent_mob.buckled)
		if(parent_mob.buckled == parent_buckle)
			return FALSE // Still buckled to the same thing somehow?
		if(!istype(parent_mob.buckled, /obj/structure/bed/nest))
			if(parent_buckle) // Still have a lingering reference somehow?
				UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
			message_admins("cant merge [parent_mob] because we are buckled. Listening...") // TODO: Remove this
			parent_buckle = parent_mob.buckled
			RegisterSignal(parent_mob.buckled, COSMIG_OBJ_AFTER_BUCKLE, PROC_REF(on_after_buckle))
			return FALSE
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
		parent_buckle = null

	absorbing_weeds = parent_turf?.weeds
	if(!absorbing_weeds)
		message_admins("cant merge [parent_mob] because we aren't on weeds") // TODO: Remove this
		return FALSE
	RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(unmerge_with_weeds))

	active = FALSE
	merged = TRUE

	parent_mob.density = FALSE
	parent_mob.anchored = TRUE
	parent_mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	parent_mob.plane = FLOOR_PLANE
	parent_mob.remove_from_all_mob_huds()

	if(!weed_appearance) // Make a new sprite if we aren't re-merging
		weed_appearance = new()
	weed_appearance.color = absorbing_weeds.color
	// TODO: For non-humans change the icon_state or something here
	parent_mob.vis_contents += weed_appearance

	message_admins("merged [parent_mob] on [parent_mob.layer]") // TODO: Remove this
	return TRUE

/**
 * Undo the weedening
 * SIGNAL_HANDLER for COMSIG_PARENT_QDELETING of weeds
 * Returns TRUE if unmerged successfully (always)
 */
/datum/component/weed_food/proc/unmerge_with_weeds()
	SIGNAL_HANDLER

	merged = FALSE
	unmerged_time = world.time

	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
	absorbing_weeds = null

	parent_mob.anchored = FALSE
	parent_mob.mouse_opacity = MOUSE_OPACITY_ICON
	parent_mob.plane = GAME_PLANE
	parent_mob.add_to_all_mob_huds()
	parent_mob.vis_contents -= weed_appearance

	message_admins("unmerged [parent_mob]") // TODO: Remove this
	return TRUE

#undef WEED_FOOD_DELAY
#undef WEED_FOOD_STATE_DELAY
