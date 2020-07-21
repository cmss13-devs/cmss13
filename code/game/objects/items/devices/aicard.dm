/obj/item/device/aicard
	name = "inteliCard"
	icon = 'icons/obj/items/robot_component.dmi'
	icon_state = "aicard" // aicard-full
	item_state = "electronic"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST
	var/flush = null
	


/obj/item/device/aicard/attack(mob/living/silicon/ai/M as mob, mob/user as mob)
	if(!isremotecontrolling(M))//If target is not an AI.
		return ..()

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been carded with [src.name] by [user.name] ([user.ckey])</font>")
	M.last_damage_source = initial(name)
	M.last_damage_mob = user
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to card [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to card [M.name] ([M.ckey]) in [get_area(user)] ([user.x],[user.y],[user.z]).", user.x, user.y, user.z)

	transfer_ai("AICORE", "AICARD", M, user)
	return

/obj/item/device/aicard/attack(mob/living/silicon/decoy/M as mob, mob/user as mob)
	if (!istype (M, /mob/living/silicon/decoy))
		return ..()
	else
		M.death()
		to_chat(user, "<b>ERROR ERROR ERROR</b>")

/obj/item/device/aicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_interaction(src)
	var/dat = "<TT><B>Intelicard</B><BR>"
	for(var/mob/living/silicon/ai/A in src)
		dat += "Stored AI: [A.name]<br>System integrity: [(A.health+100)/2]%<br>"

		if (A.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			if (!src.flush)
				dat += {"<A href='byond://?src=\ref[src];choice=Wipe'>Wipe AI</A>"}
			else
				dat += "<b>Wipe in progress</b>"
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Wireless'>[A.control_disabled ? "Enable" : "Disable"] Wireless Activity</a>"}
			dat += "<br>"
			dat += "Subspace Transceiver is: [A.aiRadio.disabledAi ? "Disabled" : "Enabled"]"
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Radio'>[A.aiRadio.disabledAi ? "Enable" : "Disable"] Subspace Transceiver</a>"}
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Close'> Close</a>"}
	user << browse(dat, "window=aicard")
	onclose(user, "aicard")
	return

/obj/item/device/aicard/Topic(href, href_list)
	var/mob/U = usr
	if (!in_range(src, U)||U.interactee!=src)//If they are not in range of 1 or less or their machine is not the card (ie, clicked on something else).
		close_browser(U, "aicard")
		U.unset_interaction()
		return

	add_fingerprint(U)
	U.set_interaction(src)

	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			close_browser(U, "aicard")
			U.unset_interaction()
			return

		if ("Radio")
			for(var/mob/living/silicon/ai/A in src)
				A.aiRadio.disabledAi = !A.aiRadio.disabledAi
		if ("Wipe")
			var/confirm = alert("Are you sure you want to wipe this card's memory? This cannot be undone once started.", "Confirm Wipe", "Yes", "No")
			if(confirm == "Yes")
				if(isnull(src)||!in_range(src, U)||U.interactee!=src)
					close_browser(U, "aicard")
					U.unset_interaction()
					return
				else
					flush = 1
					for(var/mob/living/silicon/ai/A in src)
						to_chat(A, "Your core files are being wiped!")
						while (A.stat != 2)
							A.apply_damage(2, OXY)
							A.updatehealth()
							sleep(10)
						flush = 0

		if ("Wireless")
			for(var/mob/living/silicon/ai/A in src)
				A.control_disabled = !A.control_disabled
				if (A.control_disabled)
					overlays -= image('icons/obj/items/robot_component.dmi', "aicard-on")
				else
					overlays += image('icons/obj/items/robot_component.dmi', "aicard-on")
	attack_self(U)
