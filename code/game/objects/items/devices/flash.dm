/obj/item/device/flash
	name = "flash"
	desc = "Used for blinding and being an asshole."
	icon_state = "flash"
	item_state = "flash_device"	//Replace me later
	throwforce = 5
	w_class = SIZE_SMALL
	throw_speed = SPEED_VERY_FAST
	throw_range = 10
	flags_atom = FPRINT|CONDUCT

	var/broken_icon_state = "flashburnt"
	var/skilllock = SKILL_POLICE_FLASH
	var/times_used = 0 //Number of times it's been used.
	var/flashes_per_minute = 5 //how many you can do per minute
	var/broken = FALSE     //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.

/obj/item/device/flash/update_icon()
	if(broken)
		icon_state = broken_icon_state

/obj/item/device/flash/proc/flash_recharge()
	//capacitor recharges over time
	for(var/i=0, i<flashes_per_minute, i++)
		if(last_used+300 > world.time)
			break
		last_used += 300
		times_used -= 1
	last_used = world.time
	times_used = max(0,round(times_used)) //sanity

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

/obj/item/device/flash/proc/do_flash(mob/living/M, mob/user, var/aoe = FALSE) //actually does the stun and logs it
	flash_recharge()
	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	if(times_used <= flashes_per_minute)
		last_used = world.time
		if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
			broken = TRUE
			to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
			update_icon()
			return
		times_used++
	else	//can only use it 5 times a minute
		to_chat(user, SPAN_WARNING("*click* *click*"))
		playsound(src.loc, 'sound/weapons/gun_empty.ogg', 25, 1)
		return

	if(aoe)
		playsound(src.loc, 'sound/weapons/flash.ogg', 25, 1)
		flick("flash2", src)
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

		else if(isSilicon(M))
			M.KnockDown(rand(5,10))

		else //if not carbon or sillicn
			flashfail = TRUE

		if(isrobot(user))
			spawn(0)
				var/atom/movable/overlay/animation = new(user.loc)
				animation.layer = user.layer + 1
				animation.icon_state = "blank"
				animation.icon = 'icons/mob/mob.dmi'
				animation.master = user
				flick("blspell", animation)
				sleep(5)
				qdel(animation)

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
	if(!user || !M)	return	//sanity
	if(!ishuman(M)) return

	if(check_if_can_use_flash(user))
		if(isXeno(M))
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
	if(broken)	return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))
				broken = TRUE
				update_icon()
				return
			times_used++
			if(istype(loc, /mob/living/carbon))
				var/mob/living/carbon/M = loc
				if(M.flash_eyes())
					M.KnockDown(10)
					M.visible_message("<span class='disarm'>[M] is blinded by \the [src]!</span>")
	..()

/obj/item/device/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution. Only good for one use."
	icon_state = "sflash"
	broken_icon_state = "flashburnt_very_old"

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
