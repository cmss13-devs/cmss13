/datum/xeno_strain/watcher
	name = FACEHUGGER_WATCHER
	description = "You lose your ability to hide in exchange to see further. This enables you to stalk your host from a distance and wait for the perfect oppertunity to strike."
	flavor_description = "No need to hide when you can see the danger."

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/xenohide,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_long_range/facehugger,
	)

	behavior_delegate_type = /datum/behavior_delegate/facehugger_watcher

/datum/xeno_strain/watcher/apply_strain(mob/living/carbon/xenomorph/facehugger/huggy)
	huggy.viewsize = 10
	huggy.layer = initial(huggy.layer)

// This has no special effects, it's just here to skip `/datum/behavior_delegate/facehugger_base/on_life()`.
/datum/behavior_delegate/facehugger_watcher
	name = "Watcher Facehugger Behavior Delegate"

/datum/behavior_delegate/facehugger_watcher/on_life()
	// Sap health if we're standing, not on weeds, and not zoomed out
	if(bound_xeno.body_position != STANDING_UP)
		return
	if(bound_xeno.is_zoomed)
		return
	if(locate(/obj/effect/alien/weeds) in get_turf(bound_xeno))
		return
	bound_xeno.adjustBruteLoss(1)
