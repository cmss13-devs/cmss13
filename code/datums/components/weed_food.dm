#define WEED_FOOD_DELAY 5 MINUTES
#define WEED_FOOD_STATE_DELAY 1 MINUTES

/atom/movable/vis_obj/weed_food
	name = "weeds"
	desc = "Weird black weeds in the shape of a body..."
	gender = PLURAL
	vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	icon = 'icons/mob/xenos/weeds.dmi'
	var/static/list/icon_states = list("human_1","human_2","human_3","human_4","human_5")
	var/static/list/icon_states_flipped = list("human_1_f","human_2_f","human_3_f","human_4_f","human_5_f")
	var/icon_state_idx = 0
	var/timer_id = null
	var/flipped = FALSE

/atom/movable/vis_obj/weed_food/Initialize(mapload, is_flipped, ...)
	flipped = is_flipped
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
	icon_state = flipped ? icon_states_flipped[icon_state_idx] : icon_states[icon_state_idx]

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
	RegisterSignal(parent_mob, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(on_update))
	if(parent_turf)
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(on_update))

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
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(on_update))

	// We moved, restart or start the proccess
	if(stop() || !merged)
		start()
		return

	// If we somehow moved when we were merged, handle that
	absorbing_weeds = parent_turf?.weeds
	if(absorbing_weeds)
		RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_deletion))
		return
	unmerge_with_weeds()

/// SIGNAL_HANDLER for COMSIG_LIVING_REJUVENATED and COMSIG_HUMAN_REVIVED
/datum/component/weed_food/proc/on_rejuv()
	SIGNAL_HANDLER

	qdel(src)

/// SIGNAL_HANDLER for COSMIG_OBJ_AFTER_BUCKLE
/datum/component/weed_food/proc/on_after_buckle(obj/source, mob/buckled)
	SIGNAL_HANDLER

	if(buckled)
		return
	start() // We unbuckled, so lets try to start again

/// SIGNAL_HANDLER for COMSIG_HUMAN_SET_UNDEFIBBABLE & COMSIG_WEEDNODE_GROWTH
/datum/component/weed_food/proc/on_update()
	SIGNAL_HANDLER

	start()

/// SIGNAL_HANDLER for COMSIG_PARENT_QDELETING of weeds
/datum/component/weed_food/proc/on_weed_deletion()
	SIGNAL_HANDLER

	if(active)
		stop()
		return
	if(merged)
		unmerge_with_weeds()
		return

/**
 * Try to start the process to turn into weeds
 * Returns TRUE if started successfully
 */
/datum/component/weed_food/proc/start()
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
			if(parent_buckle) // Still have a lingering reference somehow?
				UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
			parent_buckle = parent_mob.buckled
			RegisterSignal(parent_mob.buckled, COSMIG_OBJ_AFTER_BUCKLE, PROC_REF(on_after_buckle))
			return FALSE
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
		parent_buckle = null

	if(parent_mob.is_xeno_grabbable())
		return FALSE
	if(!(parent_mob.status_flags & PERMANENTLY_DEAD))
		var/mob/living/carbon/human/parent_human = parent_mob
		if(istype(parent_human) && !parent_human.undefibbable)
			return FALSE
	if(!parent_turf?.weeds)
		return FALSE
	if(SEND_SIGNAL(parent_mob, COMSIG_ATTEMPT_MOB_PULL) & COMPONENT_CANCEL_MOB_PULL)
		return FALSE

	if(unmerged_time == world.time)
		return merge_with_weeds() // Weeds upgraded, re-merge now re-using the apperance
	QDEL_NULL(weed_appearance)
	absorbing_weeds = parent_turf.weeds
	RegisterSignal(parent_turf.weeds, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_deletion))

	active = TRUE
	timer_id = addtimer(CALLBACK(src, PROC_REF(merge_with_weeds)), WEED_FOOD_DELAY, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_DELETE_ME|TIMER_OVERRIDE)

	return TRUE

/**
 * Try to stop the process turning into weeds
 * Returns TRUE if stopped successfully (was active when called)
 */
/datum/component/weed_food/proc/stop()
	if(!active)
		return FALSE

	active = FALSE
	deltimer(timer_id)
	timer_id = null

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
			parent_buckle = parent_mob.buckled
			RegisterSignal(parent_mob.buckled, COSMIG_OBJ_AFTER_BUCKLE, PROC_REF(on_after_buckle))
			return FALSE
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COSMIG_OBJ_AFTER_BUCKLE)
		parent_buckle = null

	if(SEND_SIGNAL(parent_mob, COMSIG_ATTEMPT_MOB_PULL) & COMPONENT_CANCEL_MOB_PULL)
		return FALSE

	absorbing_weeds = parent_turf?.weeds
	if(!absorbing_weeds)
		return FALSE
	RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(on_weed_deletion))
	// Technically we could have just left the signal alone, but both because of the posibility of other conditions preventing a merge or weeds somehow changing and on_move didn't catch it, this is less fragile

	active = FALSE
	merged = TRUE

	ADD_TRAIT(parent_mob, TRAIT_UNDENSE, XENO_WEED_TRAIT)
	ADD_TRAIT(parent_mob, TRAIT_MERGED_WITH_WEEDS, XENO_WEED_TRAIT)
	parent_mob.anchored = TRUE
	parent_mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	parent_mob.plane = FLOOR_PLANE
	parent_mob.remove_from_all_mob_huds()

	if(!weed_appearance) // Make a new sprite if we aren't re-merging
		var/is_flipped = parent_mob.transform.b == -1 // Technically we should check if d is 1 too, but corpses can only be rotated 90 or 270 (1/-1 or -1/1)
		if(parent_mob.dir & WEST)
			is_flipped = !is_flipped // The direction reversed the effect of the flip!
		weed_appearance = new(null, is_flipped)
	weed_appearance.color = absorbing_weeds.color
	// TODO: For non-humans change the icon_state or something here
	parent_mob.vis_contents += weed_appearance

	return TRUE

/**
 * Undo the weedening
 * Returns TRUE if unmerged successfully (always)
 */
/datum/component/weed_food/proc/unmerge_with_weeds()
	merged = FALSE
	unmerged_time = world.time

	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
	absorbing_weeds = null

	REMOVE_TRAIT(parent_mob, TRAIT_MERGED_WITH_WEEDS, XENO_WEED_TRAIT)
	parent_mob.anchored = FALSE
	parent_mob.mouse_opacity = MOUSE_OPACITY_ICON
	parent_mob.plane = GAME_PLANE
	parent_mob.vis_contents -= weed_appearance

	if(!QDELETED(parent_mob))
		parent_mob.add_to_all_mob_huds()

	return TRUE

#undef WEED_FOOD_DELAY
#undef WEED_FOOD_STATE_DELAY
