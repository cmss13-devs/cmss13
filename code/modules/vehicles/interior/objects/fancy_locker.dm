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

/obj/structure/closet/fancy/insane
	name = "impossible box"
	desc = "<span class='red'>You cannot comprehend the depths...</span>"

	interior_map = /datum/map_template/interior/fancy_insanity
	passengers_slots = 70
	revivable_dead_slots = 25
	xenos_slots = 50

	icon = 'icons/obj/structures/crates.dmi'
	icon_state = "closed_plastic"
	icon_closed = "closed_plastic"
	icon_opened = "open_plastic"

	open_sound = 'sound/effects/ghost.ogg'
	close_sound = 'sound/effects/ghost2.ogg'

/obj/structure/closet/fancy/insane/store_mobs(stored_units)
	for(var/mob/M in loc)
		var/entry_num = rand(1,5)
		var/succ = interior.enter(M, "insanity[entry_num]")
		if(!succ)
			break

/obj/structure/closet/fancy/insane/verb/verb_climbinto()
	set src in oview(1)
	set category = "Object"
	set name = "Climb Into"

	var/mob/user = usr

	var/entry_num = rand(1,5)
	if(isobserver(user))
		interior.enter(user, "insanity[entry_num]")
		return TRUE

	if(user.is_mob_incapacitated())
		return FALSE
	if(!ishuman(user) && !isxeno(user))
		return FALSE

	if(!opened)
		to_chat(user, SPAN_WARNING("You cannot climb into [src] while it's closed!"))
		return FALSE

	user.visible_message(SPAN_NOTICE("[user] begins climbing into [src]."), SPAN_NOTICE("You begin climbing into [src]."))
	if(!do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, src, INTERRUPT_OUT_OF_RANGE))
		user.visible_message(SPAN_NOTICE("[user] stops climbing into [src]."), SPAN_NOTICE("You stop climbing into [src]."))
		return FALSE
	interior.enter(user, "insanity[entry_num]")
	return TRUE

/obj/structure/interior_exit/fancy/ladder
	name = "very long ladder"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "ladder10"
	density = FALSE
	layer = LADDER_LAYER
