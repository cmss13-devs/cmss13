/obj/item/storage/backpack/marine/satchel/rto/pickup(mob/M, silent)
	if(M.job == JOB_SQUAD_TEAM_LEADER)
		give_action(M, /datum/action/human_action/activable/droppod)
	..()

/obj/item/storage/backpack/marine/satchel/rto/dropped(mob/living/M)
	if(M.job == JOB_SQUAD_TEAM_LEADER)
		for(var/datum/action/human_action/activable/droppod/S in M.actions)
			S.remove_from(M)
			break
	..()

/obj/item/storage/backpack/marine/satchel/rto/proc/new_droppod_tech_unlocked(name)
	playsound(get_turf(loc), 'sound/machines/techpod/techpod_rto_notif.ogg', 100, FALSE, 1, 4)

	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_PURPLE("[icon2html(src, M)] New droppod available ([name])."))
