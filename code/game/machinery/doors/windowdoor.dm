/obj/structure/machinery/door/window
	name = "Glass door"
	desc = "A window, that is also a door. A windoor if you will."
	icon = 'icons/obj/structures/doors/windoor.dmi'
	icon_state = "left"
	layer = WINDOW_LAYER
	var/base_state = "left"
	health = 150.0 //If you change this, consiter changing ../door/window/brigdoor/ health at the bottom of this .dm file
	visible = 0.0
	use_power = 0
	flags_atom = ON_BORDER
	flags_can_pass_all = PASS_GLASS
	opacity = 0
	var/obj/item/circuitboard/airlock/electronics = null
	air_properties_vary_with_direction = 1

/obj/structure/machinery/door/window/New()
	. = ..()
	add_timer(CALLBACK(src, .proc/update_icon), 0)
	if (src.req_access && src.req_access.len)
		src.icon_state = "[src.icon_state]"
		src.base_state = src.icon_state

/obj/structure/machinery/door/window/Dispose()
	density = 0
	playsound(src, "shatter", 50, 1)
	. = ..()

//Enforces perspective layering like it's contemporary; windows.
/obj/structure/machinery/door/window/update_icon(loc, direction)
	if(direction)
		dir = direction
	switch(dir)
		if(NORTH) layer = ABOVE_TABLE_LAYER
		if(SOUTH) layer = ABOVE_MOB_LAYER
		else layer = initial(layer)

/obj/structure/machinery/door/window/Collided(atom/movable/AM)
	if (!( ismob(AM) ))
		var/obj/structure/machinery/bot/bot = AM
		if(istype(bot))
			if(density && src.check_access(bot.botcard))
				open()
				sleep(50)
				close()
		return
	var/mob/M = AM // we've returned by here if M is not a mob
	if (!( ticker ))
		return
	if (src.operating)
		return
	if (src.density && M.mob_size > MOB_SIZE_SMALL && src.allowed(AM))
		open()
		if(src.check_access(null))
			sleep(50)
		else //secure doors close faster
			sleep(20)
		close()
	return

/obj/structure/machinery/door/window/open()
	if (src.operating == 1) //doors can still open when emag-disabled
		return 0
	if (!ticker)
		return 0
	if(!src.operating) //in case of emag
		src.operating = 1
	flick(text("[]opening", src.base_state), src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 25, 1)
	src.icon_state = text("[]open", src.base_state)
	sleep(10)

	src.density = 0

	if(operating == 1) //emag again
		src.operating = 0
	return 1

/obj/structure/machinery/door/window/close()
	if (src.operating)
		return 0
	src.operating = 1
	flick(text("[]closing", src.base_state), src)
	playsound(src.loc, 'sound/machines/windowdoor.ogg', 25, 1)
	src.icon_state = src.base_state

	src.density = 1

	sleep(10)

	src.operating = 0
	return 1

/obj/structure/machinery/door/window/proc/take_damage(var/damage)
	src.health = max(0, src.health - damage)
	if (src.health <= 0)
		new /obj/item/shard(src.loc)
		var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src.loc)
		CC.amount = 2
		var/obj/item/circuitboard/airlock/ae
		if(!electronics)
			ae = new/obj/item/circuitboard/airlock( src.loc )
			if(!src.req_access)
				src.check_access()
			if(src.req_access.len)
				ae.conf_access = src.req_access
			else if (src.req_one_access && src.req_one_access.len)
				ae.conf_access = src.req_one_access
				ae.one_access = 1
		else
			ae = electronics
			electronics = null
			ae.loc = src.loc
		if(operating == -1)
			ae.icon_state = "door_electronics_smoked"
			operating = 0
		src.density = 0
		qdel(src)
		return

/obj/structure/machinery/door/window/bullet_act(var/obj/item/projectile/Proj)
	bullet_ping(Proj)
	if(Proj.ammo.damage)
		take_damage(round(Proj.ammo.damage / 2))
		if(Proj.ammo.damage_type == BRUTE)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return 1

//When an object is thrown at the window
/obj/structure/machinery/door/window/hitby(atom/movable/AM)

	..()
	visible_message(SPAN_DANGER("<B>The glass door was hit by [AM].</B>"), null, null, 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	take_damage(tforce)
	//..() //Does this really need to be here twice? The parent proc doesn't even do anything yet. - Nodrak
	return


/obj/structure/machinery/door/window/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/door/window/attack_hand(mob/user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
			visible_message(SPAN_DANGER("<B>[user] smashes against the [src.name].</B>"), 1)
			take_damage(25)
			return
	return try_to_activate_door(user)

/obj/structure/machinery/door/window/attackby(obj/item/I, mob/user)

	//If it's in the process of opening/closing, ignore the click
	if (src.operating == 1)
		return

	//If it's emagged, crowbar can pry electronics out.
	if (src.operating == -1 && istype(I, /obj/item/tool/crowbar))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
		user.visible_message("[user] removes the electronics from the windoor.", "You start to remove electronics from the windoor.")
		if (do_after(user, 40, INTERRUPT_ALL, BUSY_ICON_BUILD))
			to_chat(user, SPAN_NOTICE(" You removed the windoor electronics!"))

			var/obj/structure/windoor_assembly/wa = new/obj/structure/windoor_assembly(src.loc)
			if (istype(src, /obj/structure/machinery/door/window/brigdoor))
				wa.secure = "secure_"
				wa.name = "Secure Wired Windoor Assembly"
			else
				wa.name = "Wired Windoor Assembly"
			if (src.base_state == "right" || src.base_state == "rightsecure")
				wa.facing = "r"
			wa.dir = src.dir
			wa.state = "02"
			wa.update_icon()

			var/obj/item/circuitboard/airlock/ae
			if(!electronics)
				ae = new/obj/item/circuitboard/airlock( src.loc )
				if(!src.req_access)
					src.check_access()
				if(src.req_access.len)
					ae.conf_access = src.req_access
				else if (src.req_one_access.len)
					ae.conf_access = src.req_one_access
					ae.one_access = 1
			else
				ae = electronics
				electronics = null
				ae.loc = src.loc
			ae.icon_state = "door_electronics_smoked"

			operating = 0
			qdel(src)
			return

	if(!(I.flags_item & NOBLUDGEON) && I.force && density) //trying to smash windoor with item
		var/aforce = I.force
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
		visible_message(SPAN_DANGER("<B>[src] was hit by [I].</B>"))
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return 1
	else
		return try_to_activate_door(user)

/obj/structure/machinery/door/window/brigdoor
	name = "Secure glass door"
	desc = "A thick chunk of tempered glass on metal track. Probably more robust than you."
	req_access = list(ACCESS_MARINE_BRIG)
	health = 300.0 //Stronger doors for prison (regular window door health is 150)


/obj/structure/machinery/door/window/northleft
	dir = NORTH

/obj/structure/machinery/door/window/eastleft
	dir = EAST

/obj/structure/machinery/door/window/westleft
	dir = WEST

/obj/structure/machinery/door/window/southleft
	dir = SOUTH

/obj/structure/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/structure/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/structure/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/structure/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/structure/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/structure/machinery/door/window/tinted
	opacity = 1