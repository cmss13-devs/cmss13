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
	

	var/times_used = 0 //Number of times it's been used.
	var/broken = 0     //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.

/obj/item/device/flash/proc/flash_recharge()
	//capacitor recharges over time
	for(var/i=0, i<3, i++)
		if(last_used+600 > world.time)
			break
		last_used += 600
		times_used -= 2
	last_used = world.time
	times_used = max(0,round(times_used)) //sanity


/obj/item/device/flash/attack(mob/living/M, mob/user)
	if(!user || !M)	return	//sanity
	if(!ishuman(M)) return

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been flashed (attempt) with [src.name] by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to flash [key_name(M)]</font>")
	msg_admin_attack("[key_name(user)] used the [src.name] to flash [key_name(M)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_FLASH))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(broken)
		to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return

	flash_recharge()
	if(isXeno(M))
		to_chat(user, "You can't find any eyes!")
		return

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			to_chat(user, SPAN_WARNING("*click* *click*"))
			return
	playsound(src.loc, 'sound/weapons/flash.ogg', 25, 1)
	var/flashfail = 0

	if(iscarbon(M))
		flashfail = !M.flash_eyes()
		if(!flashfail)
			M.KnockDown(10)

	else if(issilicon(M))
		M.KnockDown(rand(5,10))
	else
		flashfail = 1

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
	//	flick("flash2", src)
		if(!issilicon(M))

			user.visible_message("<span class='disarm'>[user] blinds [M] with the flash!</span>")
		else

			user.visible_message(SPAN_NOTICE("[user] overloads [M]'s sensors with the flash!"))
	else

		user.visible_message(SPAN_NOTICE("[user] fails to blind [M] with the flash!"))

	return




/obj/item/device/flash/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	if(!user) 	
		return

	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_FLASH))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(broken)
		user.show_message(SPAN_WARNING("The [src.name] is broken"), 2)
		return

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
				icon_state = "flashburnt"
				return
			times_used++
		else	//can only use it  5 times a minute
			user.show_message(SPAN_WARNING("*click* *click*"), 2)
			return
	playsound(src.loc, 'sound/weapons/flash.ogg', 25, 1)
	//flick("flash2", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.layer = user.layer + 1
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	// Adds logging if you use it as an AoE flash
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] in hand to flash everyone around him in [src.loc.name] ([src.loc.x],[src.loc.y],[src.loc.z])</font>")
	msg_admin_attack("[key_name(user)] used the [src.name] to flash everyone around him in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	for(var/mob/living/carbon/human/M in oviewers(3, null))
		if(prob(50))
			if (locate(/obj/item/device/cloaking_device, M))
				for(var/obj/item/device/cloaking_device/S in M)
					S.active = 0
					S.icon_state = "shield0"
		M.flash_eyes()
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been AoE flashed (attempt) with [src.name] by [key_name(user)] in [src.loc.name] ([src.loc.x],[src.loc.y],[src.loc.z])</font>")
		msg_admin_attack("[key_name(M)] has been AoE flashed with [src.name] by [key_name(user)] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	return

/obj/item/device/flash/emp_act(severity)
	if(broken)	return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))
				broken = 1
				icon_state = "flashburnt"
				return
			times_used++
			if(istype(loc, /mob/living/carbon))
				var/mob/living/carbon/M = loc
				if(M.flash_eyes())
					M.KnockDown(10)
					M.visible_message("<span class='disarm'>[M] is blinded by the flash!</span>")
	..()

/obj/item/device/flash/synthetic
	name = "synthetic flash"
	desc = "When a problem arises, SCIENCE is the solution."
	icon_state = "sflash"
	
	var/construction_cost = list("metal"=750,"glass"=750)
	var/construction_time=100

/obj/item/device/flash/synthetic/attack(mob/living/M as mob, mob/user as mob)
	..()
	if(!broken)
		broken = 1
		to_chat(user, SPAN_DANGER("The bulb has burnt out!"))
		icon_state = "flashburnt"

/obj/item/device/flash/synthetic/attack_self(mob/living/carbon/user as mob, flag = 0, emp = 0)
	..()
	if(!broken)
		broken = 1
		to_chat(user, SPAN_DANGER("The bulb has burnt out!"))
		icon_state = "flashburnt"
