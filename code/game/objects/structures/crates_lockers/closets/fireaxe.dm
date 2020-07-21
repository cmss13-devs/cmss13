//I still dont think this should be a closet but whatever
/obj/structure/closet/fireaxecabinet
	name = "Fire Axe Cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/weapon/melee/twohanded/fireaxe/fireaxe = new/obj/item/weapon/melee/twohanded/fireaxe
	icon_state = "fireaxe1000"
	icon_closed = "fireaxe1000"
	icon_opened = "fireaxe1100"
	anchored = 1
	density = 0
	var/localopened = 0 //Setting this to keep it from behaviouring like a normal closet and obstructing movement in the map. -Agouri
	opened = 1
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0

	attackby(obj/item/O, var/mob/user)  //Marker -Agouri
		//..() //That's very useful, Erro

		var/hasaxe = 0       //gonna come in handy later~
		if(fireaxe)
			hasaxe = 1

		if (isrobot(usr) || src.locked)
			if(istype(O, /obj/item/device/multitool))
				to_chat(user, SPAN_DANGER("Resetting circuitry..."))
				playsound(user, 'sound/machines/lockreset.ogg', 25, 1)
				if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
					src.locked = 0
					to_chat(user, "<span class = 'caution'> You disable the locking modules.</span>")
					update_icon()
				return
			else if(!(O.flags_item & NOBLUDGEON) && O.force)
				var/obj/item/W = O
				if(src.smashed || src.localopened)
					if(localopened)
						localopened = 0
						icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
						spawn(10) update_icon()
					return
				else
					playsound(user, 'sound/effects/Glasshit.ogg', 25, 1) //We don't want this playing every time
				if(W.force < 15)
					to_chat(user, SPAN_NOTICE(" The cabinet's protective glass glances off the hit."))
				else
					src.hitstaken++
					if(src.hitstaken == 4)
						playsound(user, 'sound/effects/Glassbr3.ogg', 50, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
						src.smashed = 1
						src.locked = 0
						src.localopened = 1
				update_icon()
			return
		if (istype(O, /obj/item/weapon/melee/twohanded/fireaxe) && src.localopened)
			if(!fireaxe)
				if(O.flags_item & WIELDED)
					to_chat(user, SPAN_DANGER("Unwield the axe first."))
					return
				fireaxe = O
				user.drop_held_item()
				src.contents += O
				to_chat(user, SPAN_NOTICE(" You place the fire axe back in the [src.name]."))
				update_icon()
			else
				if(src.smashed)
					return
				else
					localopened = !localopened
					if(localopened)
						icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
					else
						icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
		else
			if(src.smashed)
				return
			if(istype(O, /obj/item/device/multitool))
				if(localopened)
					localopened = 0
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
					return
				else
					to_chat(user, SPAN_DANGER("Resetting circuitry..."))
					sleep(50)
					src.locked = 1
					to_chat(user, SPAN_NOTICE(" You re-enable the locking modules."))
					playsound(user, 'sound/machines/lockenable.ogg', 25, 1)
					if(do_after(user,20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
						src.locked = 1
						to_chat(user, "<span class = 'caution'> You re-enable the locking modules.</span>")
					return
			else
				localopened = !localopened
				if(localopened)
					icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()
				else
					icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
					spawn(10) update_icon()




	attack_hand(mob/user as mob)

		var/hasaxe = 0
		if(fireaxe)
			hasaxe = 1
		if(!ishuman(user)) return
		if(src.locked)
			to_chat(user, SPAN_DANGER("The cabinet won't budge!"))
			return
		if(localopened)
			if(fireaxe)
				user.put_in_hands(fireaxe)
				fireaxe = null
				to_chat(user, SPAN_NOTICE(" You take the fire axe from the [name]."))
				src.add_fingerprint(user)
				update_icon()
			else
				if(src.smashed)
					return
				else
					localopened = !localopened
					if(localopened)
						src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()
					else
						src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
						spawn(10) update_icon()

		else
			localopened = !localopened //I'm pretty sure we don't need an if(src.smashed) in here. In case I'm wrong and it fucks up teh cabinet, **MARKER**. -Agouri
			if(localopened)
				src.icon_state = text("fireaxe[][][][]opening",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()
			else
				src.icon_state = text("fireaxe[][][][]closing",hasaxe,src.localopened,src.hitstaken,src.smashed)
				spawn(10) update_icon()

	verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
		set name = "Open/Close"
		set category = "Object"

		if (isrobot(usr) || src.locked || src.smashed)
			if(src.locked)
				to_chat(usr, SPAN_DANGER("The cabinet won't budge!"))
			else if(src.smashed)
				to_chat(usr, SPAN_NOTICE(" The protective glass is broken!"))
			return

		localopened = !localopened
		update_icon()

	verb/remove_fire_axe()
		set name = "Remove Fire Axe"
		set category = "Object"

		if (isrobot(usr))
			return

		if (istype(usr, /mob/living/carbon/Xenomorph))
			return

		if (localopened)
			if(fireaxe)
				usr.put_in_hands(fireaxe)
				fireaxe = null
				to_chat(usr, SPAN_NOTICE(" You take the Fire axe from the [name]."))
			else
				to_chat(usr, SPAN_NOTICE(" The [src.name] is empty."))
		else
			to_chat(usr, SPAN_NOTICE(" The [src.name] is closed."))
		update_icon()

	attack_remote(mob/user as mob)
		if(src.smashed)
			to_chat(user, SPAN_DANGER("The security of the cabinet is compromised."))
			return
		else
			locked = !locked
			if(locked)
				to_chat(user, SPAN_DANGER("Cabinet locked."))
			else
				to_chat(user, SPAN_NOTICE(" Cabinet unlocked."))
			return

	update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
		var/hasaxe = 0
		if(fireaxe)
			hasaxe = 1
		icon_state = text("fireaxe[][][][]",hasaxe,src.localopened,src.hitstaken,src.smashed)

	open()
		return

	close()
		return