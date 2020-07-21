/obj/structure/machinery/computer/aifixer
	name = "AI System Integrity Restorer"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "ai-fixer"
	circuit = /obj/item/circuitboard/computer/aifixer
	req_one_access = list(ACCESS_CIVILIAN_ENGINEERING)
	var/mob/living/silicon/ai/occupant = null
	var/active = 0
	processing = TRUE

/obj/structure/machinery/computer/aifixer/New()
	src.overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-empty")


/obj/structure/machinery/computer/aifixer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/device/aicard))
		if(inoperable())
			to_chat(user, "This terminal isn't functioning right now, get it working!")
			return
		I:transfer_ai("AIFIXER","AICARD",src,user)

	..()
	return

/obj/structure/machinery/computer/aifixer/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/aifixer/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_interaction(src)
	var/dat

	if (src.occupant)
		dat += "Stored AI: [src.occupant.name]<br>System integrity: [(src.occupant.health+100)/2]%<br>"

		if (src.occupant.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			dat += "<b>AI functional</b>"
		if (!src.active)
			dat += {"<br><br><A href='byond://?src=\ref[src];fix=1'>Begin Reconstruction</A>"}
		else
			dat += "<br><br>Reconstruction in process, please wait.<br>"
	dat += {" <A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	show_browser(user, dat, "AI System Integrity Restorer", "computer", "size=400x500")
	return

/obj/structure/machinery/computer/aifixer/process()
	if(..())
		src.updateDialog()
		return

/obj/structure/machinery/computer/aifixer/Topic(href, href_list)
	if(..())
		return
	if (href_list["fix"])
		src.active = 1
		src.overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-on")
		while (src.occupant.health < 100)
			src.occupant.apply_damage(-1, OXY)
			src.occupant.apply_damage(-1, BURN)
			src.occupant.apply_damage(-1, TOX)
			src.occupant.apply_damage(-1, BRUTE)
			src.occupant.updatehealth()
			if (src.occupant.health >= 0 && src.occupant.stat == DEAD)
				src.occupant.stat = CONSCIOUS
				src.occupant.lying = 0
				dead_mob_list -= src.occupant
				living_mob_list += src.occupant
				occupant.reload_fullscreens()
				src.overlays -= image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-404")
				src.overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-full")
				src.occupant.add_ai_verbs()
			src.updateUsrDialog()
			sleep(10)
		src.active = 0
		src.overlays -= image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-on")


		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/structure/machinery/computer/aifixer/update_icon()
	..()
	// Broken / Unpowered
	if(inoperable())
		overlays.Cut()

	// Working / Powered
	else
		if (occupant)
			switch (occupant.stat)
				if (0)
					overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-full")
				if (2)
					overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-404")
		else
			overlays += image('icons/obj/structures/machinery/computer.dmi', "ai-fixer-empty")
