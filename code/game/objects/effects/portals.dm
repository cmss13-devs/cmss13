/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/effects/portals.dmi'
	icon_state = "portal"
	density = TRUE
	unacidable = TRUE//Can't destroy energy portals.
	var/failchance = 5
	var/obj/item/target = null
	var/creator = null
	anchored = TRUE

/obj/effect/portal/Collided(atom/movable/AM)
	INVOKE_ASYNC(src, PROC_REF(teleport), AM)

/obj/effect/portal/Crossed(AM as mob|obj)
	INVOKE_ASYNC(src, PROC_REF(teleport), AM)

/obj/effect/portal/attack_hand(mob/user as mob)
	INVOKE_ASYNC(src, PROC_REF(teleport), user)

/obj/effect/portal/Initialize(mapload, ...)
	. = ..()
	GLOB.portal_list += src
	AddElement(/datum/element/temporary, 30 SECONDS)

/obj/effect/portal/Destroy()
	GLOB.portal_list -= src
	return ..()

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(prob(failchance)) //oh dear a problem, put em in deep space
			src.icon_state = "portal1"
			do_teleport(M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon

