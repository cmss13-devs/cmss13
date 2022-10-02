/obj/structure/container
	name = "container"
	desc = "A large container that can be loaded with crates and then packed for transport with logistics vehicles."
	icon = 'icons/obj/structures/containers.dmi'
	icon_state = "container"
	layer = CONVEYOR_LAYER
	density = FALSE
	anchored = TRUE
	unacidable = TRUE

	projectile_coverage = PROJECTILE_COVERAGE_NONE
	throwpass = TRUE

	var/packaged = FALSE

	var/list/held_loads = list()
	var/list/dir_to_load = list()

/obj/structure/container/Initialize()
	bound_width = 2 * world.icon_size
	bound_height = 2 * world.icon_size
	return ..()

/obj/structure/container/initialize_pass_flags(var/datum/pass_flags_container/PF)
	. = ..()
	if(PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_AROUND

/obj/structure/container/attackby(obj/item/W, mob/user)
	if(W.flags_item & ITEM_ABSTRACT)
		return
	return ..()

/obj/structure/container/attack_hand(mob/user)
	if(user.action_busy)
		return
	user.visible_message(SPAN_NOTICE("\The [user] starts [packaged ? "unpacking" : "packing"] \the [src]..."), SPAN_NOTICE("You start [packaged ? "unpacking" : "packing"] \the [src]..."), max_distance = 3)
	playsound(loc, 'sound/effects/pry3.ogg', 25, TRUE)
	var/before_state = packaged
	if(do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD) && packaged == before_state)
		toggle_packaged()

/obj/structure/container/attack_alien(mob/living/carbon/Xenomorph/xeno)
	if(!packaged || unslashable)
		return ..()
	xeno.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)
	xeno.visible_message(SPAN_DANGER("\The [xeno] slices \the [src] open!"), SPAN_DANGER("You slice \the [src] open!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	toggle_packaged()
	return XENO_ATTACK_ACTION

/obj/structure/container/proc/toggle_packaged()
	playsound(loc, 'sound/effects/slam2.ogg', 25, TRUE)
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
	density = TRUE
	icon_state = "[initial(icon_state)]_packaged"

/obj/structure/container/proc/unpackage()
	for(var/atom/movable/load in held_loads)
		var/load_dir = dir_to_load[WEAKREF(load)]
		var/turf/settle_turf = get_step(src, load_dir)
		load.forceMove(settle_turf)
	density = FALSE
	dir_to_load = list()
	held_loads = list()
	icon_state = initial(icon_state)
