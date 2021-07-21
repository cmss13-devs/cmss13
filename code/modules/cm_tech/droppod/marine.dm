/obj/structure/droppod/tech
	name = "\improper USCM droppod"

	var/datum/tech/droppod/attached_tech
	var/time_until_return = 2 MINUTES

/obj/structure/droppod/tech/Initialize(mapload, var/datum/tech/droppod/attached_tech)
	if(!attached_tech)
		qdel(src)
		return

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

/obj/structure/droppod/tech/post_land()
	. = ..()
	addtimer(CALLBACK(src, .proc/recall), time_until_return)
