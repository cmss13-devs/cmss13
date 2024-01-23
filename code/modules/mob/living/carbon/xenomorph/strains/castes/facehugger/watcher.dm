/datum/xeno_strain/watcher
	name = FACEHUGGER_WATCHER
	description = "You lose your ability to hide in exchange to see further and the ability to no longer take damage outside of weeds. This enables you to stalk your host from a distance and wait for the perfect oppertunity to strike."
	flavor_description = "No need to hide when you can see the danger."

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/xenohide,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)

	behavior_delegate_type = /datum/behavior_delegate/facehugger_watcher

/datum/xeno_strain/watcher/apply_strain(mob/living/carbon/xenomorph/facehugger/huggy)
	huggy.viewsize = 10
	huggy.layer = initial(huggy.layer)

// This has no special effects, it's just here to skip `/datum/behavior_delegate/facehugger_base/on_life()`.
/datum/behavior_delegate/facehugger_watcher
	name = "Watcher Facehugger Behavior Delegate"
