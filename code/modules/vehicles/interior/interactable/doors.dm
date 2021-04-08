/obj/structure/interior_exit
	name = "interior door"
	desc = "I can get out of here if I go through this."
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	layer = INTERIOR_DOOR_LAYER

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

	// The interior interior this exit is tied to
	var/datum/interior/interior = null
	// Which entrance to exit through
	var/entrance_id = null

/obj/structure/interior_exit/get_projectile_hit_boolean(obj/item/projectile/P)
	return FALSE

/obj/structure/interior_exit/attack_hand(var/mob/M)

	// Check if drag anything
	var/atom/dragged_atom
	if(istype(M.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_inactive_hand()
		dragged_atom = G.grabbed_thing
	else if(istype(M.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_active_hand()
		dragged_atom = G.grabbed_thing

	var/obj/vehicle/multitile/V = interior.exterior
	var/exit_time = V.entrance_speed SECONDS
	if(dragged_atom)
		exit_time = 2 SECONDS

	to_chat(M, SPAN_NOTICE("You start climbing out of \the [interior.exterior]."))
	if(!do_after(M, exit_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Something has interrupted you."))
		return

	//Dragged stuff comes with us only if properly waited 2 seconds. No cheating!
	if(dragged_atom)
		dragged_atom = null
		if(istype(M.get_inactive_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_inactive_hand()
			interior.exit(G.grabbed_thing)
		else if(istype(M.get_active_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_active_hand()
			interior.exit(G.grabbed_thing)

	interior.exit(M)

/obj/structure/interior_exit/attack_alien(var/mob/living/carbon/Xenomorph/M, var/dam_bonus)
	to_chat(M, SPAN_NOTICE("You start climbing out of \the [interior.exterior]."))
	if(!do_after(M, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Something has interrupted you."))
		return

	interior.exit(M)

/obj/structure/interior_exit/vehicle/attackby(var/obj/item/O, var/mob/M)
	attack_hand(M)

/obj/structure/interior_exit/attack_ghost(mob/dead/observer/user)
	if(!interior)
		return ..()

	var/turf/vehicle_turf = get_turf(interior.exterior)
	if(!vehicle_turf)
		return ..()

	user.forceMove(vehicle_turf)

/obj/structure/interior_exit/vehicle
	name = "vehicle door"

/obj/structure/interior_exit/vehicle/Initialize()
	. = ..()
	update_icon()

/obj/structure/interior_exit/vehicle/update_icon()
	switch(dir)
		if(NORTH)
			pixel_y = 31
			layer = INTERIOR_WALL_NORTH_LAYER
		if(SOUTH)
			alpha = 150
			layer = INTERIOR_WALL_SOUTH_LAYER
		if(WEST)
			pixel_x = 3
		if(EAST)
			pixel_x = -3

/obj/structure/interior_exit/vehicle/proc/get_exit_turf()
	var/obj/vehicle/multitile/V = interior.exterior
	var/list/entrance_coords = V.entrances[entrance_id]
	return locate(V.x + entrance_coords[1], V.y + entrance_coords[2], V.z)

/obj/structure/interior_exit/vehicle/attack_hand(var/mob/M)

	// Check if drag anything
	var/atom/dragged_atom
	if(istype(M.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_inactive_hand()
		dragged_atom = G.grabbed_thing
	else if(istype(M.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_active_hand()
		dragged_atom = G.grabbed_thing

	var/obj/vehicle/multitile/V = interior.exterior
	var/exit_time = V.entrance_speed SECONDS
	if(dragged_atom)
		exit_time = 2 SECONDS

	to_chat(M, SPAN_NOTICE("You start climbing out of \the [interior.exterior]."))
	if(!do_after(M, exit_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Something has interrupted you."))
		return

	var/turf/exit_turf = get_exit_turf()

	//Dragged stuff comes with us only if properly waited 2 seconds. No cheating!
	if(dragged_atom)
		dragged_atom = null
		if(istype(M.get_inactive_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_inactive_hand()
			interior.exit(G.grabbed_thing, exit_turf)
		else if(istype(M.get_active_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_active_hand()
			interior.exit(G.grabbed_thing, exit_turf)

	interior.exit(M, exit_turf)

/obj/structure/interior_exit/vehicle/attack_alien(var/mob/living/carbon/Xenomorph/M, var/dam_bonus)
	to_chat(M, SPAN_NOTICE("You start climbing out of \the [interior.exterior]."))
	if(!do_after(M, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		to_chat(M, SPAN_WARNING("Something has interrupted you."))
		return

	interior.exit(M, get_exit_turf())
