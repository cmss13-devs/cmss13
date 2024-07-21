/client/proc/mark_datum(datum/D)
	if(!player_data.admin_holder)
		return
	if(player_data.admin_holder.marked_datum)
		player_data.admin_holder.UnregisterSignal(player_data.admin_holder.marked_datum, COMSIG_PARENT_QDELETING)
		vv_update_display(player_data.admin_holder.marked_datum, "marked", "")
	player_data.admin_holder.marked_datum = D
	player_data.admin_holder.RegisterSignal(player_data.admin_holder.marked_datum, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/entity/admin_holder, handle_marked_del))
	vv_update_display(D, "marked", VV_MSG_MARKED)

/client/proc/mark_datum_mapview(datum/D as mob|obj|turf|area in view(view))
	set category = "Debug"
	set name = "Mark Object"
	mark_datum(D)

/datum/entity/admin_holder/proc/handle_marked_del(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(marked_datum, COMSIG_PARENT_QDELETING)
	marked_datum = null
