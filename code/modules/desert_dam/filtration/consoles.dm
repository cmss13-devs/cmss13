var/global/river_activated = 0

/obj/structure/machinery/filtration/console
	name = "console"
	desc = "A console."
	icon = 'icons/obj/structures/machinery/filtration.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	use_power = 0
	//idle_power_usage = 1000
	var/id = null
	var/damaged = 0

/obj/structure/machinery/filtration/console/update_icon()
	..()
	if(damaged)
		icon_state = "[initial(icon_state)]-d"
	else if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]-off"
	else
		icon_state = initial(icon_state)
	return

/obj/structure/machinery/filtration/console/ex_act(severity)
	switch(severity)
		if(1.0)
			get_broken()
			return
		if(2.0)
			if (prob(40))
				get_broken()
				return
		if(3.0)
			if (prob(10))
				get_broken()
				return
		else
	return

/obj/structure/machinery/filtration/console/proc/get_broken()
	if(damaged)
		return //We're already broken
	damaged = !damaged
	visible_message(SPAN_WARNING("[src]'s screen cracks, and it bellows out smoke!"))
	playsound(src, 'sound/effects/metal_crash.ogg', 35)
	update_icon()
	return

/obj/structure/machinery/filtration/console/attack_hand(mob/user as mob)
	user.set_interaction(src)
	//var/area/A = src.loc
	var/d1
	//var/d2

	if (istype(user, /mob/living/carbon/human) || issilicon(user))
		d1 = text("<A href='?src=\ref[];reset=1'>ACTIVATE RIVER</A>", src)
		var/dat = "<HTML><HEAD></HEAD><BODY><TT>[d1]</TT></BODY></HTML>"
		river_activated = 1
		user << browse(dat, "window=console")
		onclose(user, "console")

/obj/structure/machinery/filtration/console/Topic(href, href_list)
	..()
	if (usr.stat || stat & (BROKEN|NOPOWER))
		return

	//if (buildstage != 2)
	//	return

	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (issilicon(usr)))
		usr.set_interaction(src)
	else
		usr << browse(null, "window=console")
		return
	return
