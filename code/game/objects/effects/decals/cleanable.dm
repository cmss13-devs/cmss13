/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	var/targeted_by = null			// Used so cleanbots can't claim a mess.

/obj/effect/decal/cleanable/New()
	set waitfor = 0
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()
	if(map_tag == MAP_WHISKEY_OUTPOST)
		sleep(SECONDS_10)
		qdel(src)

/obj/effect/decal/cleanable/attackby(obj/item/W, mob/user)
	var/obj/effect/alien/weeds/A = locate() in loc
	if(A)
		return A.attackby(W,user)
	else
		return ..()