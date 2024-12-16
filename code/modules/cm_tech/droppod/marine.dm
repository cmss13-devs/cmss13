/obj/structure/droppod/tech
	name = "\improper USCM droppod"
/*
	var/time_until_return = 2 MINUTES
*/
//RUCM START
	var/datum/tech/droppod/attached_tech
//RUCM END

/* RUCM CHANGE
/obj/structure/droppod/tech/Initialize(mapload, contents_name = "Empty")
	. = ..()
	name += " ([contents_name])"

/obj/structure/droppod/tech/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user) || !(droppod_flags & DROPPOD_OPEN))
		return

/obj/structure/droppod/tech/post_land()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(recall)), time_until_return)
*/
//RUCM START
/obj/structure/droppod/tech/Initialize(mapload, datum/tech/droppod/attached_tech)
	if(!attached_tech)
		return INITIALIZE_HINT_QDEL
	. = ..()
	src.attached_tech = attached_tech
	attached_tech.on_pod_created(src)
	name += " ([attached_tech.droppod_name])"

/obj/structure/droppod/tech/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user) || !attached_tech || !(droppod_flags & DROPPOD_OPEN))
		return
	if(!attached_tech.can_access(user, src))
		return
	attached_tech.on_pod_access(user, src)
//RUCM END
