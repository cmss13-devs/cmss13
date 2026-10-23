/datum/cooking/recipe_step
	/// Whether or not the recipe requires this step to be performed.
	var/optional = FALSE

/datum/cooking/recipe_step/New(options)
	if("optional" in options)
		optional = options["optional"]


/// See if the *used_item* meets the conditions for this recipe step. This will
/// typically be something like ensuring that a recipe step for adding a
/// specific kind of item has been passed an item of that type.
///
/// Returns one of [PCWJ_CHECK_INVALID], [PCWJ_CHECK_VALID], [PCWJ_CHECK_FULL],
/// [PCWJ_CHECK_SILENT].
/datum/cooking/recipe_step/proc/check_conditions_met(obj/used_item, datum/cooking/recipe_tracker/tracker)
	return PCWJ_CHECK_VALID

/// Attempt to satisfy the requirements of this step with the object *used_item*
/// being used on the cooking container that the tracker is tracking.
///
/// The return value is a list of metadata about the step used by the tracker
/// during the preparation and final recipe creation. There is no fixed set of
/// values to return here, and different recipe steps may return different
/// useful keys to the tracker. One key that is returned by most steps is
/// "message", which returns the visible message that should be shown in chat to
/// the user when the step is followed.
/datum/cooking/recipe_step/proc/follow_step(obj/used_item, datum/cooking/recipe_tracker/tracker, mob/user)
	RETURN_TYPE(/list)
	return list()

/// Special function to check if the step has been satisfied. Sometimed just following the step is enough, but not always.
/datum/cooking/recipe_step/proc/is_complete(obj/added_item, datum/cooking/recipe_tracker/tracker, list/step_data)
	return TRUE

/// Return a human readable description of the recipe step as an instruction to the reader.
/datum/cooking/recipe_step/proc/get_cookbook_formatted_desc()
	return ""
