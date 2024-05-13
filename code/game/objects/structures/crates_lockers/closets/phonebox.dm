/obj/structure/closet/phonebox
	name = "phonebox"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. As reliable as they are... It seems the line is down though."
	icon = 'icons/obj/structures/props/phonebox .dmi'
	icon_state = "phonebox_off_empty_closed"
	bound_width = 32
	bound_height = 64
	material = MATERIAL_METAL
	anchored = TRUE
	layer = BETWEEN_OBJECT_ITEM_LAYER

	open_sound = 'sound/effects/metal_door_open.ogg'
	close_sound = 'sound/effects/metal_door_close.ogg'

/obj/structure/closet/phonebox/update_icon()
	icon_state = "phonebox_on_open"
	if(!opened)
		icon_state = "phonebox_on_empty_closed"
		for(var/mob/M in src)
			icon_state = "phonebox_on_full_closed"


/obj/structure/machinery/phonebox
	name = "phonebox"
	icon = 'icons/obj/structures/props/phonebox .dmi'
	icon_state = "borgcharger0"
	desc = "It's a phonebox, outdated but realiable technology. These are used to communicate throughout the colony and connected colonies without interference. As reliable as they are... It seems the line is down though."
	density = TRUE
	anchored = TRUE
	use_power = 0
	can_buckle = TRUE
	/// the borg inside
	var/mob/living/occupant = null
	var/icon_update_tick = 0
	///stun time upon exiting, if at all
	var/exit_stun = 2

/obj/structure/machinery/phonebox/Initialize(mapload, ...)
	. = ..()
	update_icon()
	flags_atom |= USES_HEARING

/obj/structure/machinery/recharge_station/Destroy()
	if(occupant)
		to_chat(occupant, SPAN_NOTICE(" <B>[name] colapses around you.</B>"))
		go_out()
	return ..()

/obj/structure/machinery/phonebox/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_HIGH_OVER_ONLY|PASS_AROUND|PASS_OVER_THROW_ITEM

/obj/structure/machinery/phonebox/process()
	update_icon()

/obj/structure/machinery/phonebox/stop_processing()
	update_icon()

/obj/structure/machinery/phonebox/allow_drop()
	return 0

/obj/structure/machinery/phonebox/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.go_out()
	return

/obj/structure/machinery/phonebox/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "phonebox_off_open"
		if(src.occupant)
			icon_state = "phonebox_off_full_closed"
	else
		icon_state = "phonebox_on_open"
		if(src.occupant)
			icon_state = "phonebox_on_full_closed"

/obj/structure/machinery/phonebox/proc/go_out()
	if(!occupant)
		return
	var/mob/living/synth = occupant
	if(synth.client)
		synth.client.eye = synth.client.mob
		synth.client.perspective = MOB_PERSPECTIVE

	synth.forceMove(loc)
	if(exit_stun)
		synth.Stun(exit_stun) //Action delay when going out of a closet
	if(synth.mobility_flags & MOBILITY_MOVE)
		synth.visible_message(SPAN_WARNING("[synth] suddenly gets out of [src]!"), SPAN_WARNING("You get out of [src] and get your bearings!"))

	occupant = null
	update_icon()

/obj/structure/machinery/phonebox/do_buckle(mob/target, mob/user)
	return move_mob_inside(target)

/obj/structure/machinery/phonebox/verb/move_mob_inside(mob/living/M)
	if (occupant)
		return FALSE
	M.stop_pulling()
	if(M && M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	src.occupant = M
	start_processing()
	src.add_fingerprint(usr)
	update_icon()
	return TRUE

/obj/structure/machinery/phonebox/verb/move_eject()
	set category = "Object"
	set name = "Eject"

	set src in oview(1)
	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return



#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/phonebox/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH
