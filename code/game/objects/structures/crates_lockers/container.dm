/obj/structure/container
	name = "container"
	desc = "A large container that can be loaded with crates and then packed for transport with logistics vehicles."
	icon = 'icons/obj/structures/containers.dmi'
	icon_state = "container"
	layer = CONVEYOR_LAYER
	density = FALSE
	anchored = TRUE

	var/packaged = FALSE

	var/list/held_loads = list()
	var/list/dir_to_load = list()

/obj/structure/container/Initialize()
	bound_width = 2 * world.icon_size
	bound_height = 2 * world.icon_size
	return ..()

/obj/structure/container/attackby(obj/item/W, mob/user)
	if(W.flags_item & ITEM_ABSTRACT)
		return
	return ..()

/obj/structure/container/attack_hand(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] starts [packaged ? "unpacking" : "packing"] \the [src]."), SPAN_NOTICE("You start [packaged ? "unpacking" : "packing"] \the [src]."), max_distance = 3)
	if(do_after(user, 5 SECONDS, INTERRUPT_ALL))
		toggle_packaged()

/obj/structure/container/proc/toggle_packaged()
	if(packaged)
		unpackage()
	else
		package()
	packaged = !packaged

/obj/structure/container/proc/package()
	for(var/turf/corner in locs)
		for(var/atom/movable/load in corner)
			var/is_packageable = FALSE
			if(istype(load, /obj/structure/closet/crate))
				var/obj/structure/closet/crate/crate = load
				if(!crate.opened)
					is_packageable = TRUE
			if(istype(load, /obj/structure/largecrate))
				is_packageable = TRUE
			if(!is_packageable)
				continue
			var/load_dir = get_dir(loc, load.loc)
			dir_to_load[WEAKREF(load)] = load_dir
			load.forceMove(src)
			held_loads += load
	icon_state = "[initial(icon_state)]_packaged"

/obj/structure/container/proc/unpackage()
	for(var/atom/movable/load in held_loads)
		var/load_dir = dir_to_load[WEAKREF(load)]
		var/turf/settle_turf = get_step(src, load_dir)
		load.forceMove(settle_turf)
	dir_to_load = list()
	held_loads = list()
	icon_state = initial(icon_state)
