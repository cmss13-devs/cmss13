#define WEED_FOOD_DELAY 10 SECONDS

/atom/movable/vis_obj/weed_food
	icon = 'icons/mob/xenos/weeds.dmi'
	icon_state = "human"
	vis_flags = VIS_INHERIT_ID|VIS_INHERIT_DIR|VIS_INHERIT_LAYER

/**
 * A component that can be attached to a human to be merged with weeds after a delay
 * Attach this to any human that is dead and it should handle the rest (currently no signal for weeds spreading)
 */
/datum/component/weed_food
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/name = "weeds"
	var/description = "Weird black weeds in the shape of a body..."

	/// Whether we are actively being merged
	var/active = FALSE
	/// Whether we are completely merged with weeds
	var/merged = FALSE
	var/timer_id = null
	/// The weeds that we merging/merged with
	var/obj/effect/alien/weeds/absorbing_weeds
	/// The human mob that we are bound to
	var/mob/living/carbon/human/parent_human
	/// The overlay image when merged
	var/atom/movable/vis_obj/weed_food/weed_appearance
	/// The original description if our parent has TRAIT_SIMPLE_DESC: Assumes it wasn't also just left null
	var/old_simple_desc = null
	/// The original name for our parent (currently set at Initialize)
	var/old_name

/datum/component/weed_food/Initialize(...)
	. = ..()
	parent_human = parent
	if(!istype(parent_human))
		return COMPONENT_INCOMPATIBLE

	// Save any simple description and name
	if(HAS_TRAIT(src, TRAIT_SIMPLE_DESC))
		old_simple_desc = parent_human.desc
	old_name = parent_human.name

	start()

/datum/component/weed_food/InheritComponent(datum/component/C, i_am_original)
	. = ..()
	message_admins("Handling duplicate Init on [parent_human]...") // TODO: Remove this
	start()

/datum/component/weed_food/Destroy(force, silent)
	. = ..()
	unmerge_with_weeds()
	message_admins("Destroying on [parent_human]...") // TODO: Remove this
	parent_human = null

/datum/component/weed_food/RegisterWithParent()
	. = ..()
	RegisterSignal(parent_human, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	RegisterSignal(parent_human, COMSIG_LIVING_REJUVENATED, PROC_REF(on_rejuv))
	RegisterSignal(parent_human, COMSIG_HUMAN_REVIVED, PROC_REF(on_rejuv))
	RegisterSignal(parent_human, COMSIG_HUMAN_SET_UNDEFIBBABLE, PROC_REF(start))

/datum/component/weed_food/UnregisterFromParent()
	. = ..()
	if(parent_human)
		UnregisterSignal(parent_human, COMSIG_MOVABLE_MOVED)
		UnregisterSignal(parent_human, COMSIG_LIVING_REJUVENATED)
		UnregisterSignal(parent_human, COMSIG_HUMAN_REVIVED)
		UnregisterSignal(parent_human, COMSIG_HUMAN_SET_UNDEFIBBABLE)

/datum/component/weed_food/proc/on_move()
	SIGNAL_HANDLER
	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)

	// We moved, restart or start the proccess
	if(stop() || !merged)
		start()
		return

	// If we somehow moved when we were merged, handle that
	var/turf/parent_turf = get_turf(parent_human)
	absorbing_weeds = parent_turf?.weeds
	if(absorbing_weeds)
		RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(unmerge_with_weeds))
	else
		unmerge_with_weeds()

/datum/component/weed_food/proc/on_rejuv()
	message_admins("on_rejuv [parent_human]") // TODO: Remove this
	qdel(src)

/// Try to start the process to turn into weeds
/datum/component/weed_food/proc/start(force = FALSE)
	SIGNAL_HANDLER
	if(active)
		return FALSE
	if(merged)
		return FALSE
	if(QDELETED(parent_human))
		return FALSE
	if(!parent_human.undefibbable)
		message_admins("cant start [parent_human] because we are defibbable") // TODO: Remove this
		return FALSE
	if(parent_human.is_xeno_grabbable())
		message_admins("cant start [parent_human] because we are grabable") // TODO: Remove this
		return FALSE

	var/turf/parent_turf = get_turf(parent_human)
	if(parent_turf?.weeds)
		absorbing_weeds = parent_turf.weeds
		RegisterSignal(parent_turf.weeds, COMSIG_PARENT_QDELETING, PROC_REF(stop))
	else if(!force)
		message_admins("cant start [parent_human] because we aren't on weeds") // TODO: Remove this
		return FALSE

	active = TRUE
	timer_id = addtimer(CALLBACK(src, PROC_REF(merge_with_weeds)), WEED_FOOD_DELAY, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_DELETE_ME|TIMER_OVERRIDE)

	message_admins("started [parent_human]") // TODO: Remove this
	return TRUE

/// Try to stop the process turning into weeds
/datum/component/weed_food/proc/stop()
	SIGNAL_HANDLER
	if(!active)
		return FALSE

	active = FALSE
	deltimer(timer_id)
	timer_id = null

	message_admins("stopped [parent_human]") // TODO: Remove this
	return TRUE

/// Finish becomming one with the weeds
/datum/component/weed_food/proc/merge_with_weeds(force = FALSE)
	if(merged)
		return FALSE

	if(QDELETED(parent_human))
		return FALSE

	if(absorbing_weeds)
		UnregisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING)

	var/turf/parent_turf = get_turf(parent_human)
	if(!force && !parent_turf?.weeds)
		return FALSE

	active = FALSE
	merged = TRUE

	absorbing_weeds = parent_turf?.weeds
	if(absorbing_weeds)
		RegisterSignal(absorbing_weeds, COMSIG_PARENT_QDELETING, PROC_REF(unmerge_with_weeds))

	parent_human.density = FALSE
	parent_human.anchored = TRUE

	// Update the sprite
	weed_appearance = new()
	if(absorbing_weeds)
		weed_appearance.color = absorbing_weeds.color
	parent_human.vis_contents += weed_appearance

	// Hide the examine info by using TRAIT_SIMPLE_DESC and replacing the name
	ADD_TRAIT(parent_human, TRAIT_SIMPLE_DESC, TRAIT_SOURCE_HIVE)
	parent_human.desc = description
	parent_human.name = name

	message_admins("merged [parent_human]") // TODO: Remove this
	return TRUE

/// Undo the weedening
/datum/component/weed_food/proc/unmerge_with_weeds()
	SIGNAL_HANDLER
	merged = FALSE
	absorbing_weeds = null

	parent_human.anchored = FALSE

	// Undo the sprite changes
	parent_human.vis_contents -= weed_appearance
	QDEL_NULL(weed_appearance)

	// Undo changes to the name and description
	if(isnull(old_simple_desc))
		REMOVE_TRAIT(parent_human, TRAIT_SIMPLE_DESC, TRAIT_SOURCE_HIVE)
	else
		parent_human.desc = old_simple_desc
	parent_human.name = old_name

	message_admins("unmerged [parent_human]") // TODO: Remove this

#undef WEED_FOOD_DELAY
