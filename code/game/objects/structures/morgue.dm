/*
 * Morgue
 */
/obj/structure/morgue
	name = "morgue"
	desc = "Used to keep bodies in until someone fetches them."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "morgue1"
	dir = EAST
	density = 1
	var/obj/structure/morgue_tray/connected = null
	var/morgue_type = "morgue"
	var/tray_path = /obj/structure/morgue_tray
	var/morgue_open = 0
	anchored = 1
	throwpass = 1

/obj/structure/morgue/Initialize()
	. = ..()
	connected = new tray_path(src)

/obj/structure/morgue/Destroy()
	for(var/atom/movable/object in contents)
		object.forceMove(loc)
	. = ..()
	QDEL_NULL(connected)

/obj/structure/morgue/update_icon()
	if(morgue_open)
		icon_state = "[morgue_type]0"
	else
		if(contents.len > 1) //not counting the morgue tray
			icon_state = "[morgue_type]2"
		else
			icon_state = "[morgue_type]1"

/obj/structure/morgue/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				return
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(95))
				return
	for(var/atom/movable/A in src)
		A.forceMove(loc)
		ex_act(severity)
	qdel(src)

/obj/structure/morgue/attack_hand(mob/user)
	toggle_morgue(user)

/obj/structure/morgue/proc/toggle_morgue(mob/user)
	add_fingerprint(user)
	if(!connected) return
	if(morgue_open)
		for(var/atom/movable/A in connected.loc)
			if(!A.anchored)
				A.forceMove(src)
		connected.forceMove(src)
		name = "morgue"
		var/mob/living/L = locate(/mob/living) in contents
		if(L)
			name = "morgue ([L])"
		else
			var/obj/structure/closet/bodybag/B = locate(/obj/structure/closet/bodybag) in contents
			if(B)
				L = locate(/mob/living) in B.contents
				if(L)
					name = "morgue ([L])"

	else
		name = "morgue"
		connected.forceMove(loc)
		if(step(connected, dir))
			connected.setDir(dir)
			for(var/atom/movable/A in src)
				A.forceMove(connected.loc)
		else
			connected.forceMove(src)
			return
	morgue_open = !morgue_open
	playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
	update_icon()


/obj/structure/morgue/attackby(obj/item/P, mob/user)
	if(istype(P, /obj/item/weapon/zombie_claws))
		attack_hand()
		return
	else if(istype(P, /obj/item/tool/pen))
		var/t = copytext(stripped_input(user, "What would you like the label to be?", name, null),1,MAX_MESSAGE_LEN)
		if(user.get_active_hand() != P)
			return
		if((!in_range(src, user) && src.loc != user))
			return
		if(t)
			name = "[initial(name)]- '[t]'"
		else
			name = initial(name)
		add_fingerprint(user)
	else
		. = ..()

/obj/structure/morgue/relaymove(mob/user)
	if(user.is_mob_incapacitated(TRUE))
		return
	toggle_morgue(user)


/*
 * Morgue tray
 */

/obj/structure/morgue_tray
	name = "morgue tray"
	desc = "Apply corpse before closing."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "morguet"
	var/icon_tray = ""
	density = 1
	layer = OBJ_LAYER
	var/obj/structure/morgue/linked_morgue = null
	anchored = 1
	throwpass = 1
	var/bloody = FALSE

/obj/structure/morgue_tray/New(loc, obj/structure/morgue/morgue_source)
	icon_tray = initial(icon_state)
	if(morgue_source)
		linked_morgue = morgue_source
	..()

/obj/structure/morgue_tray/Destroy()
	. = ..()
	linked_morgue = null

/obj/structure/morgue_tray/MouseDrop_T(atom/movable/O, mob/user)
	if(!istype(O) || O.anchored || !isturf(O.loc))
		return
	if(!ismob(O) && !istype(O, /obj/structure/closet/bodybag))
		return
	if(!istype(user) || user.is_mob_incapacitated() || !isturf(user.loc))
		return
	O.forceMove(loc)
	if(user != O)
		for(var/mob/B in viewers(user, 3))
			B.show_message(SPAN_DANGER("[user] stuffs [O] into [src]!"), 1)
			if(B.stat==DEAD)
				bloody = TRUE
				update_icon()

/obj/structure/morgue_tray/update_icon()
	if(bloody)
		icon_state = icon_tray + "_b"
	else
		icon_state = icon_tray

/obj/structure/morgue_tray/clean_blood()
	bloody = FALSE
	update_icon()
	. = ..()


/*
 * Crematorium
 */

/obj/structure/morgue/crematorium
	name = "crematorium"
	desc = "A human incinerator. Works well on barbeque nights."
	icon_state = "crema1"
	dir = SOUTH
	tray_path = /obj/structure/morgue_tray/crematorium
	morgue_type = "crema"
	var/cremating = 0
	var/id = 1


/obj/structure/morgue/crematorium/toggle_morgue(mob/user)
	if(cremating)
		to_chat(user, SPAN_WARNING("It's locked."))
		return
	..()


/obj/structure/morgue/crematorium/relaymove(mob/user)
	if(cremating) return
	..()


/obj/structure/morgue/crematorium/update_icon()
	if(cremating)
		icon_state = "[morgue_type]_active"
	else
		..()


/obj/structure/morgue/crematorium/proc/cremate(mob/user)
	set waitfor = 0
	if(cremating)
		return

	if(contents.len <= 1) //1 because the tray is inside.
		visible_message(SPAN_DANGER("You hear a hollow crackle."))
	else
		visible_message(SPAN_DANGER("You hear a roar as the crematorium activates."))

		cremating = 1

		update_icon()

		for(var/mob/living/M in contents)
			if(M.stat!=DEAD)
				if(!ishuman(M))
					M.emote("scream")
				else
					var/mob/living/carbon/human/H = M
					if(H.pain.feels_pain)
						H.emote("scream")

			user.attack_log +="\[[time_stamp()]\] Cremated <b>[key_name(M)]</b>"
			msg_admin_attack("\[[time_stamp()]\] <b>[key_name(user)]</b> cremated <b>[key_name(M)]</b> in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
			M.death(create_cause_data("cremation", user), TRUE)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents)
			if(istype(O, /obj/structure/morgue_tray)) continue
			qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		update_icon()
		playsound(src.loc, 'sound/machines/ding.ogg', 25, 1)


/*
 * Crematorium tray
 */

/obj/structure/morgue_tray/crematorium
	name = "crematorium tray"
	desc = "Apply body before burning."
	icon_state = "cremat"


/*
 * Crematorium switch
 */

/obj/structure/machinery/crema_switch/attack_hand(mob/user)
	if(allowed(user))
		for(var/obj/structure/morgue/crematorium/C in range(7,src))
			if(C.id == id)
				if(!C.cremating)
					C.cremate(user)
	else
		to_chat(user, SPAN_DANGER("Access denied."))



/*
 * Sarcophagus
 */

/obj/structure/morgue/sarcophagus
    name = "sarcophagus"
    desc = "Used to store predators."
    icon_state = "sarcophagus1"
    morgue_type = "sarcophagus"
    tray_path = /obj/structure/morgue_tray/sarcophagus


/*
 * Sarcophagus tray
 */

/obj/structure/morgue_tray/sarcophagus
    name = "sarcophagus tray"
    desc = "Apply corpse before closing."
    icon_state = "sarcomat"
