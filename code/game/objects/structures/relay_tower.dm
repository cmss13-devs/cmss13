/obj/structure/machinery/relay_tower
	name = "X993A2 Relay Tower"
	desc = "This tower boosts the connection strength of nearby X993A1 links. Additionally, it generates intel and research points from combat data given by any controlled xenomorphs."
	icon = 'icons/obj/structures/machinery/comm_tower.dmi'
	icon_state = "comm_tower"
	unacidable = FALSE
	unslashable = FALSE
	/// How much to multiply headset range by
	var/range_boost = 2

/obj/structure/machinery/relay_tower/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_SEND_RELAY_POINTS, PROC_REF(handle_point_gain))

/obj/structure/machinery/relay_tower/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("To re-package, use at least five wooden planks on it while holding a screwdriver in the other hand.")

/obj/structure/machinery/relay_tower/proc/handle_point_gain(point_multiplier)
	var/intel_point_gain = OBJECTIVE_LOW_VALUE * point_multiplier
	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(intel_point_gain)

	var/biomass_points_gain = 200 * point_multiplier
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BIOMASS_GAIN, biomass_points_gain)

	playsound(src, 'sound/machines/techpod/techpod_rto_notif.ogg', 50)
	// it speaks!
	for(var/mob/mob in hearers(src, null))
		mob.show_message("<span class='game say'><span class='name'>[src]</span> beeps, \"Combat data recieved. [intel_point_gain] intel points have been gained. [biomass_points_gain] biomass points gained.\"</span>", SHOW_MESSAGE_AUDIBLE)

/obj/structure/machinery/relay_tower/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/head/control_headset_marine))
		link_up_headset(W, user)
	else if(istype(W, /obj/item/stack/sheet/wood))
		repackage_relay(W, user)
	else return ..()

/obj/structure/machinery/relay_tower/proc/link_up_headset(obj/item/clothing/head/control_headset_marine/headset, mob/user)
	if(headset.connected_tower == src)
		to_chat(user, SPAN_NOTICE("[headset] is already connected to [src]!"))
		return
	//play_warbly_sound
	headset.connected_tower = src
	user.visible_message(
		SPAN_NOTICE("[user] connects [headset] to [src]."),
		SPAN_NOTICE("You connect [headset] to [src], [range_boost == 2 ? "doubling" : "increasing"] its maximum range."))
	playsound(headset,'sound/machines/click.ogg', 15, 1)
	return

/obj/structure/machinery/relay_tower/proc/repackage_relay(obj/item/stack/sheet/wood/wooden_stack, mob/user)
	if(wooden_stack.amount < 5)
		to_chat(user, SPAN_WARNING("You need at least 5 wooden sheets to repackage [src]!"))
		return
	var/obj/item/tool/screwdriver/offhand_item = user.get_inactive_hand()
	if(!istype(offhand_item))
		to_chat(user, SPAN_WARNING("You need to be holding a screwdriver in the offhand to do this!"))
		return
	if(!do_after(user, 7 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_BUILD, src))
		return
	wooden_stack.use(5)
	new /obj/structure/largecrate/machine/relay_tower(get_turf(src))
	qdel(src)

/obj/structure/largecrate/machine/relay_tower
	name = "relay tower crate"
	desc = "A crate containing a relay tower."
	dir_needed = 0

/obj/structure/largecrate/machine/relay_tower/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	new /obj/structure/machinery/relay_tower(T)

	qdel(src)
	return TRUE
