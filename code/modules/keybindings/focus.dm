/mob/proc/set_focus(datum/new_focus)
	if(focus == new_focus)
		return
	focus = new_focus
	reset_view(focus) //Maybe this should be done manually? You figure it out, reader
