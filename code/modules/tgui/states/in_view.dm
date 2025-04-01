//If in view and within view distance
GLOBAL_DATUM_INIT(in_view, /datum/ui_state/in_view, new)
/datum/ui_state/in_view/can_use_topic(src_object, mob/user)
	return user.in_view_can_use_topic(src_object) // Call the individual mob-overridden procs.

/mob/proc/in_view_can_use_topic(src_object)
	return UI_CLOSE // Don't allow interaction by default.

/mob/ghost/in_view_can_use_topic(src_object)
	return UI_UPDATE //ghost can just watch

/mob/living/in_view_can_use_topic(src_object)
	. = shared_ui_interaction(src_object)
	if(. > UI_CLOSE && loc) //must not be in nullspace.
		. = min(., shared_living_ui_in_view(src_object)) // Check the distance and view...
