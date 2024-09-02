/datum/action/looc_toggle
	name = "Toggle Overhead LOOC"
	action_icon_state = "looc_toggle"

/datum/action/looc_toggle/give_to(mob/M)
	..()
	M.looc_overhead = TRUE
	button.icon_state = "template_on"

/datum/action/looc_toggle/remove_from(mob/M)
	M.looc_overhead = FALSE
	..()

// Called when the action is clicked on.
/datum/action/looc_toggle/action_activate()
	. = ..()
	if(owner.looc_overhead)
		button.icon_state = "template"
		owner.looc_overhead = FALSE
	else
		button.icon_state = "template_on"
		owner.looc_overhead = TRUE
