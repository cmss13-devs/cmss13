/obj/item/device/flash
	name = "flash"
	desc = "Used for blinding and being an asshole. Recharges one flash every 30 seconds. You must wait 1 second between uses for the capacitor to recharge."
	icon_state = "flash"
	item_state = "flash_device" //Replace me later
	throwforce = 5
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	flags_atom = FPRINT|CONDUCT
	black_market_value = 10

	var/skilllock = SKILL_POLICE_FLASH
	var/flashes_stored = 5
	var/max_flashes_stored = 5 //how many you can do per minute
	var/broken = FALSE  //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.
	var/recharge_time_per_flash = 30 SECONDS
	var/cooldown_between_flashes = 0.5 SECONDS

/obj/item/device/flash/update_icon()
	if(broken)
		icon_state = "[icon_state]_burnt"

/obj/item/device/flash/get_examine_text(mob/user)
	. = ..()
	if(broken)
		. += "This one's bulb has popped. Oh well."
	else
		. += SPAN_NOTICE("[flashes_stored] / [max_flashes_stored] flashes remaining.")

/obj/item/device/flash/proc/add_charge()
	if(broken)
		return
	flashes_stored++
	if(flashes_stored <= max_flashes_stored)
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] \The [src] pings as it recharges!"), SPAN_NOTICE("You hear a ping"), 3)
	flashes_stored = min(max_flashes_stored, floor(flashes_stored)) //sanity

/obj/item/device/flash/proc/check_if_can_use_flash(mob/user) //checks for using the flash
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user

	if(skilllock && !skillcheck(H, SKILL_POLICE, skilllock))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use \the [src]..."))
		return FALSE

	if(broken)
		to_chat(H, SPAN_WARNING("\The [src] is broken."))
		return FALSE
	return TRUE

/obj/item/device/flash/proc/do_flash(mob/living/M, mob/user, aoe = FALSE) //actually does the stun and logs it
	//spamming the flash before it's fully charged increases the chance of it  breaking
	//It will never break on the first use.
	if(flashes_stored)
		if((world.time - last_used) < cooldown_between_flashes)
			to_chat(user, SPAN_WARNING("\The [src]'s capacitor is still recharging for the next flash, wait a moment!"))
			return
		last_used = world.time
		flashes_stored--
		if(prob(10 - (flashes_stored*2))) //it has a 10% chance to break on the final flash
			broken = TRUE
			to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
			update_icon()
			return
		addtimer(CALLBACK(src, PROC_REF(add_charge)), recharge_time_per_flash)
		to_chat(user, SPAN_DANGER("[flashes_stored] / [max_flashes_stored] flashes remaining."))
	else
		to_chat(user, SPAN_WARNING("*click* *click*"))
		playsound(src.loc, 'sound/weapons/gun_empty.ogg', 25, 1)
		return

	if(aoe)
		playsound(src.loc, 'sound/weapons/flash.ogg', 25, 1)
		flick("[icon_state]_flashing", src)
		user.visible_message(SPAN_DANGER("[user] activates \the [src]'s bulb, emitting a brilliant light!"))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] in hand to flash everyone around them in [src.loc.name] ([src.loc.x],[src.loc.y],[src.loc.z])</font>")
		msg_admin_attack("[key_name(user)] used the [src.name] to flash everyone around them in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
		for(var/mob/living/carbon/human/victim in oviewers(3, null))
			if(prob(50))
				if (locate(/obj/item/device/chameleon, victim))
					for(var/obj/item/device/chameleon/S in victim)
						S.disrupt(victim)
			victim.flash_eyes()
			victim.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been AoE flashed (attempt) with [src.name] by [key_name(user)] in [src.loc.name] ([src.loc.x],[src.loc.y],[src.loc.z])</font>")
			msg_admin_attack("[key_name(victim)] has been AoE flashed with [src.name] by [key_name(user)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
	else
		playsound(src.loc, 'sound/weapons/flash.ogg', 25, 1)
		var/flashfail = FALSE //determines if you actually blind + stun the guy or not
		flick("flash2", src)

		if(iscarbon(M))
			flashfail = !M.flash_eyes()
			if(!flashfail)
				M.KnockDown(10)
				M.Stun(10)

		else if(isSilicon(M))
			M.apply_effect(rand(5,10), WEAKEN)

		else //if not carbon or sillicn
			flashfail = TRUE

		if(!flashfail)
			if(!isSilicon(M))
				user.visible_message(SPAN_DANGER("[user] blinds [M] with \the [src]!"))
			else
				user.visible_message(SPAN_WARNING("[user] overloads [M]'s sensors with \the [src]!"))
		else
			user.visible_message(SPAN_WARNING("[user] fails to blind [M] with \the [src]!"))

		if(!flashfail)
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been flashed (attempt) with [src.name] by [key_name(user)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to flash [key_name(M)]</font>")
			msg_admin_attack("[key_name(user)] used the [src.name] to flash [key_name(M)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

//targeted flash

/obj/item/device/flash/attack(mob/living/M, mob/user)
	if(!user || !M) return //sanity
	if(!istype(M)) return

	if(check_if_can_use_flash(user))
		if(isxeno(M))
			to_chat(user, SPAN_WARNING("You can't find any eyes!"))
			return

		if(M == user && user.a_intent != INTENT_HARM)
			to_chat(user, SPAN_WARNING("You point \the [src] towards your eyes, but stop yourself from activating it at the last moment!"))
			return

		do_flash(M, user, FALSE)

//AOE flash

/obj/item/device/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	..()

	if(!user)
		return

	if(check_if_can_use_flash(user))
		do_flash(user = user, aoe = TRUE)

/obj/item/device/flash/emp_act(severity)
	. = ..()
	if(broken) return
	switch(flashes_stored)
		if(0 to 5)
			if(prob(20 - (2*flashes_stored)))
				broken = TRUE
				update_icon()
				return
			flashes_stored--
			if(istype(loc, /mob/living/carbon))
				var/mob/living/carbon/M = loc
				if(M.flash_eyes())
					M.apply_effect(10, WEAKEN)
					M.visible_message(SPAN_DISARM("[M] is blinded by \the [src]!"))

/obj/item/device/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution. Only good for one use."
	icon_state = "sflash"

/obj/item/device/flash/synthetic/attack(mob/living/M as mob, mob/user as mob)
	..()
	if(!broken)
		broken = TRUE
		to_chat(user, SPAN_DANGER("The bulb has burnt out!"))
		update_icon()

/obj/item/device/flash/synthetic/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	..()
	if(!broken)
		broken = TRUE
		to_chat(user, SPAN_DANGER("The bulb has burnt out!"))
		update_icon()

/obj/item/device/flash/old
	name = "old-looking flash"
	icon_state = "flash_old"
