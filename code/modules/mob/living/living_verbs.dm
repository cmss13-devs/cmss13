/mob/living/can_resist()
	if(next_move > world.time)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		return FALSE
	return TRUE

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	reset_view()

	if(next_move > world.time)
		return

	if(is_mob_incapacitated(TRUE))
		to_chat(src, SPAN_WARNING("You can't resist in your current state."))
		return

	if(isxeno(src))
		var/mob/living/carbon/xenomorph/xeno = src
		if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
			to_chat(src, SPAN_WARNING("You can't resist in your current state."))
			return

	resisting = TRUE

	next_move = world.time + 20

	//Getting out of someone's inventory.
	if(istype(loc, /obj/item/holder))
		var/obj/item/holder/H = loc //Get our item holder.
		var/mob/M = H.loc //Get our mob holder (if any).

		if(istype(M))
			M.drop_inv_item_on_ground(H)
			to_chat(M, "[H] wriggles out of your grip!")
			to_chat(src, "You wriggle out of [M]'s grip!")
		else if(istype(H.loc,/obj/item))
			to_chat(src, "You struggle free of [H.loc].")
			H.forceMove(get_turf(H))

		if(!istype(M))
			return

		for(var/obj/item/holder/hold in M.contents)
			return

		M.status_flags &= ~PASSEMOTES
		return

	//resisting grabs (as if it helps anyone...)
	if(!is_mob_restrained(0) && pulledby)
		visible_message(SPAN_DANGER("[src] resists against [pulledby]'s grip!"))
		resist_grab()
		return

	//unbuckling yourself
	if(buckled && (last_special <= world.time) )
		resist_buckle()

	//escaping a bodybag or a thermal tarp
	if(loc && (istype(loc, /obj/structure/closet/bodybag)))
		var/obj/structure/closet/bodybag/BB = loc
		if (BB.opened)
			return
		visible_message("[BB] begins to wiggle violently!")
		if(do_after(src, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, BB))//5 second unzip from inside
			BB.open()

		///The medical machines below are listed separately to allow easier changes to each process

	//getting out of hypersleep
	if(loc && (istype(loc, /obj/structure/machinery/cryopod)))
		var/obj/structure/machinery/cryopod/BB = loc
		BB.eject()

	//getting out of bodyscanner
	if(loc && (istype(loc, /obj/structure/machinery/medical_pod/bodyscanner)))
		var/obj/structure/machinery/medical_pod/bodyscanner/BB = loc
		BB.go_out() //This doesn't need flashiness as you can just WASD to walk out anyways

	//getting out of autodoc, resist does the emergency eject
	//regular ejection is done with verbs and doesnt work for half the time
	if(loc && (istype(loc, /obj/structure/machinery/medical_pod/autodoc)))
		var/obj/structure/machinery/medical_pod/autodoc/BB = loc
		if (alert(usr, "Would you like to emergency eject out of [BB]? A surgery may be in progress.", "Confirm", "Yes", "No") == "Yes")
			visible_message(SPAN_WARNING ("[BB]'s emergency lights blare as the casket starts moving!"))
			to_chat(usr, SPAN_NOTICE ("You are now leaving [BB]"))
			playsound(src, 'sound/machines/beepalert.ogg', 30)
			if(do_after(src, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, BB))//5 sec delay
				BB.go_out() //Eject doesnt work you have to force it
		else
			return

	//getting out of cryocells
	if(loc && (istype(loc, /obj/structure/machinery/cryo_cell)))
		var/obj/structure/machinery/cryo_cell/BB = loc
		BB.move_eject() //Ejection process listed under the machine, no need to list again

	//getting out of sleeper
	if(loc && (istype(loc, /obj/structure/machinery/medical_pod/sleeper)))
		var/obj/structure/machinery/medical_pod/sleeper/BB = loc
		BB.go_out() //This doesn't need flashiness as the verb is instant as well

	//Breaking out of a locker?
	else if(loc && (istype(loc, /obj/structure/closet)))
		var/breakout_time = 2 //2 minutes by default

		var/obj/structure/closet/C = loc
		if(C.opened)
			return //Door's open... wait, why are you in it's contents then?
		if(istype(loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/SC = loc
			if(!SC.locked && !SC.welded)
				return //It's a secure closet, but isn't locked. Easily escapable from, no need to 'resist'
		else if(!C.welded)
			return //closed but not welded...

		//okay, so the closet is either welded or locked... resist!!!
		next_move = world.time + 100
		last_special = world.time + 100
		to_chat(src, SPAN_DANGER("You lean on the back of \the [C] and start pushing the door open. (this will take about [breakout_time] minutes)"))
		for(var/mob/O in viewers(loc))
			O.show_message(SPAN_DANGER("<B>The [loc] begins to shake violently!</B>"), SHOW_MESSAGE_VISIBLE)

		if(!do_after(src, (breakout_time*1 MINUTES), INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST))
			return

		if(!C || !src || stat != CONSCIOUS || loc != C || C.opened) //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
			return
		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(istype(loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/SC = loc
			if(!SC.locked && !SC.welded)
				return
		else if(!C.welded)
			return
		//Well then break it!
		if(istype(loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/SC = loc
			SC.desc = "It appears to be broken."
			SC.icon_state = SC.icon_off
			flick(SC.icon_broken, SC)
			sleep(10)
			flick(SC.icon_broken, SC)
			sleep(10)
			SC.broken = 1
			SC.locked = 0
			SC.update_icon()
			to_chat(src, SPAN_DANGER("You successfully break out!"))
			for(var/mob/O in viewers(loc))
				O.show_message(SPAN_DANGER("<B>\the [src] successfully broke out of \the [SC]!</B>"), SHOW_MESSAGE_VISIBLE)
			if(istype(SC.loc, /obj/structure/bigDelivery)) //Do this to prevent contents from being opened into nullspace (read: bluespace)
				var/obj/structure/bigDelivery/BD = SC.loc
				BD.attack_hand(src)
			SC.open()
			return
		else
			C.welded = 0
			C.update_icon()
			to_chat(src, SPAN_DANGER("You successfully break out!"))
			for(var/mob/O in viewers(loc))
				O.show_message(SPAN_DANGER("<B>\the [src] successfully broke out of \the [C]!</B>"), SHOW_MESSAGE_VISIBLE)
			if(istype(C.loc, /obj/structure/bigDelivery)) //nullspace ect... read the comment above
				var/obj/structure/bigDelivery/BD = C.loc
				BD.attack_hand(src)
			C.open()
			return

	//breaking out of handcuffs & putting out fires
	if(!is_mob_incapacitated(TRUE))
		if(on_fire)
			resist_fire()

		var/on_acid = FALSE
		for(var/datum/effects/acid/A in effects_list)
			on_acid = TRUE
			break
		if(on_acid)
			resist_acid()

	SEND_SIGNAL(src, COMSIG_MOB_RESISTED)

	if(!iscarbon(src))
		return
	var/mob/living/carbon/C = src
	if((C.handcuffed || C.legcuffed) && (C.mobility_flags & MOBILITY_MOVE) && (C.last_special <= world.time))
		resist_restraints()

/mob/living/proc/resist_buckle()
	buckled.manual_unbuckle(src)

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_acid()
	return

/mob/living/proc/resist_restraints()
	return
