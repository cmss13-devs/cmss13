/obj/structure/closet/fancy
	name = "fancy closet"
	desc = "It's a fancy storage unit."

	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

	unacidable = TRUE

	var/interior_map = /datum/map_template/interior/fancy_locker
	var/datum/interior/interior = null
	var/entrance_speed = 1 SECONDS
	var/passengers_slots = 2
	var/revivable_dead_slots = 0
	var/list/role_reserved_slots = list()
	var/xenos_slots = 2

/obj/structure/closet/fancy/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/fancy/LateInitialize()
	. = ..()
	interior = new(src)
	INVOKE_ASYNC(src, PROC_REF(do_create_interior))

/obj/structure/closet/fancy/proc/do_create_interior()
	interior.create_interior(interior_map)

/obj/structure/closet/fancy/Destroy()
	QDEL_NULL(interior)
	return ..()

/obj/structure/closet/fancy/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src && !closet.wall_mounted)
			return FALSE
	return TRUE

/obj/structure/closet/fancy/store_mobs(stored_units)
	for(var/mob/M in loc)
		var/succ = interior.enter(M, "fancy")
		if(!succ)
			break

/obj/structure/closet/fancy/ex_act(severity)
	return

/obj/structure/interior_exit/fancy
	name = "fancy wooden door"
	icon = 'icons/obj/structures/doors/mineral_doors.dmi'
	icon_state = "wood"
	density = TRUE

/obj/structure/interior_exit/fancy/attackby(obj/item/O, mob/M)
	attack_hand(M)

/obj/structure/interior_exit/fancy/attack_hand(mob/escapee)
	var/obj/structure/closet/fancy/closet = find_closet()
	if(istype(closet) && !closet.can_open())
		to_chat(escapee, SPAN_WARNING("Something is blocking the exit!"))
		return
	..()

/obj/structure/interior_exit/fancy/attack_alien(mob/living/carbon/xenomorph/escapee, dam_bonus)
	var/obj/structure/closet/fancy/closet = find_closet()
	if(istype(closet) && !closet.can_open())
		to_chat(escapee, SPAN_XENOWARNING("Something is blocking the exit!"))
		return
	..()

/obj/structure/interior_exit/fancy/proc/find_closet()
	var/obj/structure/closet/fancy/possible_closet = interior.exterior
	if(istype(possible_closet))
		return possible_closet
	return
