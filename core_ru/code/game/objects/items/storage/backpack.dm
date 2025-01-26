/obj/item/storage/backpack/marine/satchel/rto/proc/new_droppod_tech_unlocked(name)
	playsound(get_turf(loc), 'sound/machines/techpod/techpod_rto_notif.ogg', 100, FALSE, 1, 4)

	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_PURPLE("[icon2html(src, M)] New droppod available ([name])."))
