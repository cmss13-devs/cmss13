/datum/action
	var/desc

/datum/action/New(Target, override_icon_state)
	. = ..()
	if(desc)
		button.desc = desc

/atom/movable/screen/action_button/MouseEntered(location, control, params)
	. = ..()
	if(!QDELETED(src))
		openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/action_button/MouseExited(location, control, params)
	closeToolTip(usr)
	return ..()
