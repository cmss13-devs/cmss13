//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	matter = list("metal" = 1000, "glass" = 500, "waste" = 100)


	wires = WIRE_ASSEMBLY_PULSE

	secured = 0

	var/on = 0
	var/visible = 0
	var/obj/effect/beam/i_beam/first = null

/obj/item/device/assembly/infra/Destroy()
	QDEL_NULL(first)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/device/assembly/infra/activate()
	if(!..())
		return 0//Cooldown check
	on = !on
	update_icon()
	return 1


/obj/item/device/assembly/infra/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		on = 0
		QDEL_NULL(first)
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/infra/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(on)
		overlays += "infrared_on"
		attached_overlays += "infrared_on"

	if(holder)
		holder.update_icon()
	return


/obj/item/device/assembly/infra/process()//Old code
	if(!on)
		if(first)
			QDEL_NULL(first)
			return

	if((!(first) && (secured && (istype(loc, /turf) || (holder && istype(holder.loc, /turf))))))
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam((holder ? holder.loc : loc) )
		I.master = src
		I.density = TRUE
		I.setDir(dir)
		step(I, I.dir)
		if(I)
			I.density = FALSE
			first = I
			I.vis_spread(visible)
			spawn(0)
				if(I)
					I.limit = 8
					I.process()
				return
	return


/obj/item/device/assembly/infra/attack_hand()
	QDEL_NULL(first)
	..()

/obj/item/device/assembly/infra/attackby()
	return

/obj/item/device/assembly/infra/Move()
	var/t = dir
	. = ..()
	setDir(t)
	QDEL_NULL(first)
	return


/obj/item/device/assembly/infra/holder_movement()
	if(!holder)
		return 0
// dir = holder.dir
	QDEL_NULL(first)
	return 1


/obj/item/device/assembly/infra/proc/trigger_beam()
	if((!secured)||(!on)||(cooldown > 0))
		return 0
	pulse(0)
	if(!holder)
		visible_message("[icon2html(src, hearers(src))] *beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()
	return


/obj/item/device/assembly/infra/interact(mob/user as mob)//TODO: change this this to the wire control panel
	if(!secured)
		return
	user.set_interaction(src)

	/* a testament to autism
	var/dat = text("<TT><B>Infrared Laser</B>\n<B>Status</B>: []<BR>\n<B>Visibility</B>: []<BR>\n</TT>", (on ? text("<A href='byond://?src=\ref[];state=0'>On</A>", src) : text("<A href='byond://?src=\ref[];state=1'>Off</A>", src)), (src.visible ? text("<A href='byond://?src=\ref[];visible=0'>Visible</A>", src) : text("<A href='byond://?src=\ref[];visible=1'>Invisible</A>", src)))
	*/

	var/dat = "<TT><B>Infrared Laser</B>\n<B>Status</B>: "
	if (on)
		dat += "<A href='byond://?src=\ref[src];state=0'>On</A>"
	else
		dat += "<A href='byond://?src=\ref[src];state=1'>Off</A>"
	dat += "<BR>\n<B>Visibility</B>: "

	if (visible)
		dat += "<A href='byond://?src=\ref[src];visible=0'>Visible</A>"
	else
		dat += "<A href='byond://?src=\ref[src];visible=1'>Invisible</A>"

	dat += "<BR>\n</TT>"
	dat += "<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='byond://?src=\ref[src];close=1'>Close</A>"
	show_browser(user, dat, "Infrared Laser", "infra")
	return


/obj/item/device/assembly/infra/Topic(href, href_list)
	..()
	if(usr.is_mob_incapacitated() || !in_range(loc, usr))
		close_browser(usr, "infra")
		return

	if(href_list["state"])
		on = !(on)
		update_icon()

	if(href_list["visible"])
		visible = !(visible)
		spawn(0)
			if(first)
				first.vis_spread(visible)

	if(href_list["close"])
		close_browser(usr, "infra")
		return

	if(usr)
		attack_self(usr)

	return


/obj/item/device/assembly/infra/verb/rotate()//This could likely be better
	set name = "Rotate Infrared Laser"
	set category = "Object"
	set src in usr

	setDir(turn(dir, 90))
	return



//***************************IBeam*********************************/

/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/effect/beam/i_beam/next = null
	var/obj/item/device/assembly/infra/master = null
	var/limit = null
	var/visible = 0
	var/left = null
	anchored = TRUE
	flags_atom = NOINTERACT

/obj/effect/beam/i_beam/proc/hit()
	if(master)
		master.trigger_beam()
	qdel(src)
	return

/obj/effect/beam/i_beam/proc/vis_spread(v)
	visible = v
	spawn(0)
		if(next)
			next.vis_spread(v)
		return
	return

/obj/effect/beam/i_beam/Destroy()
	if(master)
		master = null
	QDEL_NULL(next)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/beam/i_beam/process()

	if((!loc || loc.density || !(master)))
		qdel(src)
		return

	if(left > 0)
		left--
	if(left < 1)
		if(!(visible))
			invisibility = 101
		else
			invisibility = 0
	else
		invisibility = 0


	var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(loc)
	I.master = master
	I.density = TRUE
	I.setDir(dir)
	step(I, I.dir)

	if(I)
		if(!(next))
			I.density = FALSE
			I.vis_spread(visible)
			next = I
			spawn(0)
				if((I && limit > 0))
					I.limit = limit - 1
					I.process()
				return
		else
			qdel(I)
	else
		QDEL_NULL(next)
	spawn(10)
		process()
		return
	return

/obj/effect/beam/i_beam/Collide()
	qdel(src)
	return

/obj/effect/beam/i_beam/Collided(atom/movable/AM)
	hit()
	return

/obj/effect/beam/i_beam/Crossed(atom/movable/AM as mob|obj)
	if(istype(AM, /obj/effect/beam))
		return
	spawn(0)
		hit()
