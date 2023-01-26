/obj/structure/closet/fancy
	name = "fancy closet"
	desc = "It's a fancy storage unit."

	var/datum/interior/interior = null
	var/entrance_speed = 1 SECONDS
	var/passengers_slots = 2
	var/revivable_dead_slots = 0
	var/list/role_reserved_slots = list()
	var/xenos_slots = 2

/obj/structure/closet/fancy/Initialize()
	. = ..()

	interior = new(src)
	interior.create_interior("fancylocker")

/obj/structure/closet/fancy/store_mobs(stored_units)
	for(var/mob/M in loc)
		var/succ = interior.enter(M, "default")
		if(!succ)
			break


/obj/structure/interior_exit/fancy
	name = "fancy wooden door"
	icon = 'icons/obj/structures/doors/mineral_doors.dmi'
	icon_state = "wood"
	density = TRUE
