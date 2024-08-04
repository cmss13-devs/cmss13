//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/machinery/implantchair
	name = "loyalty implanter"
	desc = "Used to implant occupants with loyalty implants."
	icon = 'icons/obj/structures/machinery/implantchair.dmi'
	icon_state = "implantchair"
	density = TRUE
	opacity = FALSE
	anchored = TRUE

	var/ready = 1
	var/malfunction = 0
	var/list/obj/item/implant/loyalty/implant_list = list()
	var/max_implants = 5
	var/injection_cooldown = 600
	var/replenish_cooldown = 6000
	var/replenishing = 0
	var/mob/living/carbon/occupant = null
	var/injecting = 0

/obj/structure/machinery/implantchair/New()
	..()
	add_implants()


/obj/structure/machinery/implantchair/attack_hand(mob/user as mob)
	user.set_interaction(src)
	var/health_text = ""
	if(src.occupant)
		if(src.occupant.health <= -100)
			health_text = "<FONT color=red>Dead</FONT>"
		else if(src.occupant.health < 0)
			health_text = "<FONT color=red>[round(src.occupant.health,0.1)]</FONT>"
		else
			health_text = "[round(src.occupant.health,0.1)]"

	var/dat ="<B>Implanter Status</B><BR>"

	dat +="<B>Current occupant:</B> [src.occupant ? "<BR>Name: [src.occupant]<BR>Health: [health_text]<BR>" : "<FONT color=red>None</FONT>"]<BR>"
	dat += "<B>Implants:</B> [length(src.implant_list) ? "[length(implant_list)]" : "<A href='?src=\ref[src];replenish=1'>Replenish</A>"]<BR>"
	if(src.occupant)
		dat += "[src.ready ? "<A href='?src=\ref[src];implant=1'>Implant</A>" : "Recharging"]<BR>"
	user.set_interaction(src)
	user << browse(dat, "window=implant")
	onclose(user, "implant")


/obj/structure/machinery/implantchair/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if((get_dist(src, usr) <= 1) || isRemoteControlling(usr))
		if(href_list["implant"])
			if(src.occupant)
				injecting = 1
				go_out()
				ready = 0
				spawn(injection_cooldown)
					ready = 1

		if(href_list["replenish"])
			ready = 0
			spawn(replenish_cooldown)
				add_implants()
				ready = 1

		src.updateUsrDialog()
		src.add_fingerprint(usr)
		return

/obj/structure/machinery/implantchair/attackby(obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(ismob(G.grabbed_thing))
			put_mob(G.grabbed_thing)
		return
	updateUsrDialog()
	return


/obj/structure/machinery/implantchair/proc/go_out(mob/M)
	if(!( src.occupant ))
		return
	if(M == occupant) // so that the guy inside can't eject himself -Agouri
		return
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.forceMove(src.loc)
	if(injecting)
		implant(src.occupant)
		injecting = 0
	src.occupant = null
	icon_state = "implantchair"
	return


/obj/structure/machinery/implantchair/proc/put_mob(mob/living/carbon/M as mob)
	if(!iscarbon(M))
		to_chat(usr, SPAN_DANGER("<B>The [src.name] cannot hold this!</B>"))
		return
	if(src.occupant)
		to_chat(usr, SPAN_DANGER("<B>The [src.name] is already occupied!</B>"))
		return
	M.forceMove(src)
	src.occupant = M
	src.add_fingerprint(usr)
	icon_state = "implantchair_on"
	return 1


/obj/structure/machinery/implantchair/proc/implant(mob/M)
	if (!istype(M, /mob/living/carbon))
		return
	if(!length(implant_list)) return
	for(var/obj/item/implant/loyalty/imp in implant_list)
		if(!imp) continue
		if(istype(imp, /obj/item/implant/loyalty))
			for (var/mob/O in viewers(M, null))
				O.show_message(SPAN_DANGER("[M] has been implanted by the [src.name]."), SHOW_MESSAGE_VISIBLE)

			if(imp.implanted(M))
				imp.forceMove(M)
				imp.imp_in = M
				imp.implanted = 1
			implant_list -= imp
			break
	return

/obj/structure/machinery/implantchair/proc/add_implants()
	for(var/i=0, i<src.max_implants, i++)
		var/obj/item/implant/loyalty/I = new /obj/item/implant/loyalty(src)
		implant_list += I
	return

/obj/structure/machinery/implantchair/verb/get_out()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return
	src.go_out(usr)
	add_fingerprint(usr)
	return

/obj/structure/machinery/implantchair/verb/move_inside()
	set name = "Move Inside"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0 || inoperable())
		return
	put_mob(usr)
	return
