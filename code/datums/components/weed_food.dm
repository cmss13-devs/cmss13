#define WEED_FOOD_DELAY 5 MINUTES
#define WEED_FOOD_STATE_DELAY 1 MINUTES

/atom/movable/vis_obj/weed_food
	name = "weeds"
	desc = "Weird black weeds in the shape of a body..."
	gender = PLURAL
	vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_PLANE|VIS_INHERIT_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/mob/xenos/weeds.dmi'
	var/list/icon_states
	var/list/icon_states_flipped
	var/icon_state_idx = 0
	var/timer_id = null
	var/flipped = FALSE

/atom/movable/vis_obj/weed_food/Initialize(mapload, is_flipped, weeds_icon, states, states_flipped, ...)
	flipped = is_flipped
	icon = weeds_icon
	icon_states = states
	icon_states_flipped = states_flipped
	timer_id = addtimer(CALLBACK(src, PROC_REF(on_animation_timer)), WEED_FOOD_STATE_DELAY, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_LOOP|TIMER_DELETE_ME)
	on_animation_timer()
	return ..()

/// Timer callback for changing the icon_state
/atom/movable/vis_obj/weed_food/proc/on_animation_timer()
	icon_state_idx++
	// Assumption: Length of icon_states is the same as icon_states_flipped
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
	/// A nest our parent is buckled to and we have registered a signal
	var/obj/structure/bed/nest/parent_nest
	/// The weeds that we are merging/merged with
	var/obj/effect/alien/weeds/absorbing_weeds
	/// The overlay image when merged
	var/atom/movable/vis_obj/weed_food/weed_appearance

/datum/component/weed_food/Initialize(...)
	parent_mob = parent
	// At the moment we only support humans and xenos
	if(!istype(parent_mob, /mob/living/carbon/human) && !istype(parent_mob, /mob/living/carbon/xenomorph))
		return COMPONENT_INCOMPATIBLE

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
	parent_buckle = null

/datum/component/weed_food/RegisterWithParent()
	RegisterSignal(parent_mob, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(on_move))
	RegisterSignal(parent_mob, list(COMSIG_LIVING_REJUVENATED, COMSIG_HUMAN_REVIVED), PROC_REF(on_rejuv))
	RegisterSignal(parent_mob, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(on_update))
	RegisterSignal(parent_mob, COMSIG_LIVING_PREIGNITION, PROC_REF(on_preignition))
	RegisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING, PROC_REF(on_forsaken))
	if(parent_turf)
		RegisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH, PROC_REF(on_update))

/datum/component/weed_food/UnregisterFromParent()
	if(parent_mob)
		UnregisterSignal(parent_mob, list(
			COMSIG_MOVABLE_TURF_ENTERED,
			COMSIG_LIVING_REJUVENATED,
			COMSIG_HUMAN_REVIVED,
			COMSIG_HUMAN_SET_UNDEFIBBABLE,
			COMSIG_LIVING_PREIGNITION,
			))
	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)
	if(parent_turf)
		UnregisterSignal(parent_turf, COMSIG_WEEDNODE_GROWTH)
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COMSIG_OBJ_AFTER_BUCKLE)
	if(parent_nest)
		UnregisterSignal(parent_nest, COMSIG_PARENT_QDELETING)
	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

/// SIGNAL_HANDLER for COMSIG_MOVABLE_TURF_ENTERED
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

/// SIGNAL_HANDLER for COMSIG_OBJ_AFTER_BUCKLE
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

/// SIGNAL_HANDLER for COMSIG_PARENT_QDELETING of nest
/datum/component/weed_food/proc/on_nest_deletion()
	SIGNAL_HANDLER

	if(merged)
		parent_mob.plane = FLOOR_PLANE
	UnregisterSignal(parent_nest, COMSIG_PARENT_QDELETING)
	parent_nest = null

/// SIGNAL_HANDLER for COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING
/datum/component/weed_food/proc/on_forsaken()
	SIGNAL_HANDLER

	UnregisterSignal(SSdcs, COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING)

	if(!merged)
		return
	if(!is_ground_level(parent_mob.z))
		return

	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_FORSAKEN]
	weed_appearance.color = hive.color

/// SIGNAL_HANDLER for COMSIG_LIVING_PREIGNITION of weeds
/datum/component/weed_food/proc/on_preignition()
	SIGNAL_HANDLER

	if(merged)
		return COMPONENT_CANCEL_IGNITION

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
				UnregisterSignal(parent_buckle, COMSIG_OBJ_AFTER_BUCKLE)
			parent_buckle = parent_mob.buckled
			RegisterSignal(parent_mob.buckled, COMSIG_OBJ_AFTER_BUCKLE, PROC_REF(on_after_buckle))
			return FALSE
	if(parent_buckle)
		UnregisterSignal(parent_buckle, COMSIG_OBJ_AFTER_BUCKLE)
		parent_buckle = null

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
				UnregisterSignal(parent_buckle, COMSIG_OBJ_AFTER_BUCKLE)
			parent_buckle = parent_mob.buckled
			RegisterSignal(parent_mob.buckled, COMSIG_OBJ_AFTER_BUCKLE, PROC_REF(on_after_buckle))
			return FALSE
		else
			parent_nest = parent_mob.buckled
			RegisterSignal(parent_nest, COMSIG_PARENT_QDELETING, PROC_REF(on_nest_deletion))

	if(parent_buckle)
		UnregisterSignal(parent_buckle, COMSIG_OBJ_AFTER_BUCKLE)
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
	if(!parent_nest)
		parent_mob.plane = FLOOR_PLANE
	parent_mob.remove_from_all_mob_huds()
	parent_mob.ExtinguishMob()

	if(!weed_appearance) // Make a new sprite if we aren't re-merging
		var/is_flipped = parent_mob.transform.b == -1 // Technically we should check if d is 1 too, but corpses can only be rotated 90 or 270 (1/-1 or -1/1)
		if(parent_mob.dir & WEST)
			is_flipped = !is_flipped // The direction reversed the effect of the flip!
		weed_appearance = new(null, is_flipped, parent_mob.weed_food_icon, parent_mob.weed_food_states, parent_mob.weed_food_states_flipped)
	weed_appearance.color = absorbing_weeds.color
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

	if(parent_nest)
		UnregisterSignal(parent_nest, COMSIG_PARENT_QDELETING)
	parent_nest = null

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
