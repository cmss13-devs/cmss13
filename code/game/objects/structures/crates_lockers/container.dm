/obj/structure/container
	name = "container"
	desc = "A large container that can be loaded with crates and then packed for transport with logistics vehicles."
	icon = 'icons/obj/structures/containers.dmi'
	icon_state = "container"
	layer = CONVEYOR_LAYER
	density = FALSE
	anchored = TRUE

	var/packaged = FALSE
	var/list/dir_to_crate = list()

/obj/structure/container/Initialize()
	bound_width = 2 * world.icon_size
	bound_height = 2 * world.icon_size
	return ..()

/obj/structure/container/attackby(obj/item/W, mob/user)
	if(W.flags_item & ITEM_ABSTRACT)
		return
	return ..()

/obj/structure/container/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You start [packaged ? "unpacking" : "packing"] \the [src]."))
	toggle_packaged()

/obj/structure/container/proc/toggle_packaged()
	if(packaged)
		unpackage()
	else
		package()
	packaged = !packaged

/obj/structure/container/proc/package()
	for(var/turf/corner in locs)
		for(var/obj/structure/closet/crate/crate in corner)
			if(crate.opened)
				continue
			var/crate_dir = get_dir(loc, crate.loc)
			dir_to_crate[WEAKREF(crate)] = crate_dir
			crate.forceMove(src)
	icon_state = "[initial(icon_state)]_packaged"

/obj/structure/container/proc/unpackage()
	for(var/obj/structure/closet/crate/crate in src)
		var/crate_dir = dir_to_crate[WEAKREF(crate)]
		var/turf/settle_turf = get_step(src, crate_dir)
		crate.forceMove(settle_turf)
	dir_to_crate = list()
	icon_state = initial(icon_state)
