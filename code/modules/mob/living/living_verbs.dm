

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	var/mob/living/L = src

	if(!isliving(L) || L.next_move > world.time)
		return
	if(L.is_mob_incapacitated(TRUE))
		to_chat(L, SPAN_WARNING("You can't resist in your current state."))
		return

	L.resisting = TRUE

	L.next_move = world.time + 20

	//Getting out of someone's inventory.
	if(istype(L.loc,/obj/item/holder))
		var/obj/item/holder/H = L.loc	//Get our item holder.
		var/mob/M = H.loc           	//Get our mob holder (if any).

		if(istype(M))
			M.drop_inv_item_on_ground(H)
			to_chat(M, "[H] wriggles out of your grip!")
			to_chat(L, "You wriggle out of [M]'s grip!")
		else if(istype(H.loc,/obj/item))
			to_chat(L, "You struggle free of [H.loc].")
			H.loc = get_turf(H)

		if(istype(M))
			for(var/atom/A in M.contents)
				if(istype(A,/obj/item/holder))
					return

		M.status_flags &= ~PASSEMOTES
		return

	//resisting grabs (as if it helps anyone...)
	if(!is_mob_restrained(0) && pulledby)
		visible_message(SPAN_DANGER("[L] resists against [pulledby]'s grip!"))
		resist_grab()
		return

	//unbuckling yourself
	if(L.buckled && (L.last_special <= world.time) )
		if(iscarbon(L))
			if(istype(L.buckled,/obj/structure/bed/nest))
				L.buckled.manual_unbuckle(L)
				return

			var/mob/living/carbon/C = L
			if( C.handcuffed )
				C.next_move = world.time + 100
				C.last_special = world.time + 100
				C.visible_message(SPAN_DANGER("<B>[C] attempts to unbuckle themself!</B>"),\
				SPAN_DANGER("You attempt to unbuckle yourself. (This will take around 2 minutes and you need to stand still)"))
				if(do_after(C, 1200, INTERRUPT_ALL^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
					if(!C.buckled)
						return
					C.visible_message(SPAN_DANGER("<B>[C] manages to unbuckle themself!</B>"),\
								SPAN_NOTICE("You successfully unbuckle yourself."))
					C.buckled.manual_unbuckle(C)
			else
				C.buckled.manual_unbuckle(C)
		else
			L.buckled.manual_unbuckle(L)

	//Breaking out of a locker?
	else if( L.loc && (istype(L.loc, /obj/structure/closet)) )
		var/breakout_time = 2 //2 minutes by default

		var/obj/structure/closet/C = L.loc
		if(C.opened)
			return //Door's open... wait, why are you in it's contents then?
		if(istype(L.loc, /obj/structure/closet/secure_closet))
			var/obj/structure/closet/secure_closet/SC = L.loc
			if(!SC.locked && !SC.welded)
				return //It's a secure closet, but isn't locked. Easily escapable from, no need to 'resist'
		else
			if(!C.welded)
				return //closed but not welded...
		//	else Meh, lets just keep it at 2 minutes for now
		//		breakout_time++ //Harder to get out of welded lockers than locked lockers

		//okay, so the closet is either welded or locked... resist!!!
		L.next_move = world.time + 100
		L.last_special = world.time + 100
		to_chat(L, SPAN_DANGER("You lean on the back of \the [C] and start pushing the door open. (this will take about [breakout_time] minutes)"))
		for(var/mob/O in viewers(L.loc))
			O.show_message(SPAN_DANGER("<B>The [L.loc] begins to shake violently!</B>"), 1)


		spawn(0)
			if(do_after(L,(breakout_time*MINUTES_1), INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST))
				if(!C || !L || L.stat != CONSCIOUS || L.loc != C || C.opened) //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
					return

				//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
				if(istype(L.loc, /obj/structure/closet/secure_closet))
					var/obj/structure/closet/secure_closet/SC = L.loc
					if(!SC.locked && !SC.welded)
						return
				else
					if(!C.welded)
						return

				//Well then break it!
				if(istype(L.loc, /obj/structure/closet/secure_closet))
					var/obj/structure/closet/secure_closet/SC = L.loc
					SC.desc = "It appears to be broken."
					SC.icon_state = SC.icon_off
					flick(SC.icon_broken, SC)
					sleep(10)
					flick(SC.icon_broken, SC)
					sleep(10)
					SC.broken = 1
					SC.locked = 0
					SC.update_icon()
					to_chat(L, SPAN_DANGER("You successfully break out!"))
					for(var/mob/O in viewers(L.loc))
						O.show_message(SPAN_DANGER("<B>\the [L] successfully broke out of \the [SC]!</B>"), 1)
					if(istype(SC.loc, /obj/structure/bigDelivery)) //Do this to prevent contents from being opened into nullspace (read: bluespace)
						var/obj/structure/bigDelivery/BD = SC.loc
						BD.attack_hand(L)
					SC.open()
				else
					C.welded = 0
					C.update_icon()
					to_chat(L, SPAN_DANGER("You successfully break out!"))
					for(var/mob/O in viewers(L.loc))
						O.show_message(SPAN_DANGER("<B>\the [L] successfully broke out of \the [C]!</B>"), 1)
					if(istype(C.loc, /obj/structure/bigDelivery)) //nullspace ect.. read the comment above
						var/obj/structure/bigDelivery/BD = C.loc
						BD.attack_hand(L)
					C.open()

	//breaking out of handcuffs & putting out fires
	else if(iscarbon(L))
		if (isXeno(L))
			var/mob/living/carbon/Xenomorph/X = L
			if (X.on_fire && X.canmove && !knocked_down)
				X.fire_stacks = max(X.fire_stacks - rand(3, 6), 0)
				X.KnockDown(4, TRUE)
				X.visible_message(SPAN_DANGER("[X] rolls on the floor, trying to put themselves out!"), \
					SPAN_NOTICE("You stop, drop, and roll!"), null, 5)
				if (fire_stacks <= 0)
					X.visible_message(SPAN_DANGER("[X] has successfully extinguished themselves!"), \
					SPAN_NOTICE("You extinguish yourself."), null, 5)
					ExtinguishMob()
				return

		var/mob/living/carbon/human/CM = L
		if(CM.canmove && !knocked_down)
			if(CM.on_fire)
				if(isYautja(CM))
					CM.fire_stacks = max(CM.fire_stacks - rand(6,10), 0)
					CM.KnockDown(1, TRUE) // actually 0.5
					CM.visible_message(SPAN_DANGER("[CM] expertly rolls on the floor, greatly reducing the amount of flames!"), \
						SPAN_NOTICE("You expertly roll to extinguish the flames!"), null, 5)
				else
					CM.fire_stacks = max(CM.fire_stacks - rand(3,6), 0)
					CM.KnockDown(4, TRUE)
					CM.visible_message(SPAN_DANGER("[CM] rolls on the floor, trying to put themselves out!"), \
						SPAN_NOTICE("You stop, drop, and roll!"), null, 5)
				if(fire_stacks <= 0)
					CM.visible_message(SPAN_DANGER("[CM] has successfully extinguished themselves!"), \
						SPAN_NOTICE("You extinguish yourself."), null, 5)
					ExtinguishMob()
				return
			
			var/on_acid = FALSE
			for(var/datum/effects/acid/A in effects_list)
				on_acid = TRUE
				break
			
			if(on_acid)
				var/sleep_amount = 1
				if(isYautja(CM))
					CM.KnockDown(1, TRUE)
					CM.visible_message(SPAN_DANGER("[CM] expertly rolls on the floor!"), \
						SPAN_NOTICE("You expertly roll to get rid of the acid!"), null, 5)
				else
					sleep_amount = 4
					CM.KnockDown(4, TRUE)
					CM.visible_message(SPAN_DANGER("[CM] rolls on the floor, trying to get the acid off!"), \
						SPAN_NOTICE("You stop, drop, and roll!"), null, 5)
					
				sleep(sleep_amount)
				if(prob(50))
					CM.visible_message(SPAN_DANGER("[CM] has successfully removed the acid!"), \
						SPAN_NOTICE("You get rid of the acid."), null, 5)
					CM.extinguish_acid()
				return
		
		if(CM.handcuffed && CM.canmove && (CM.last_special <= world.time))
			var/obj/item/handcuffs/HC = CM.handcuffed

			CM.next_move = world.time + 100
			CM.last_special = world.time + 100

			var/can_break_cuffs
			if(HULK in usr.mutations)
				can_break_cuffs = 1
			else if(iszombie(CM))
				CM.visible_message(SPAN_DANGER("[CM] is attempting to break out of [HC]..."), \
				SPAN_NOTICE("You use your superior zombie strength to start breaking [HC]..."))
				spawn(0)
					if(do_after(CM, 100, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
						if(!CM.handcuffed || CM.buckled)
							return
						CM.visible_message(SPAN_DANGER("[CM] tears [HC] in half!"), \
							SPAN_NOTICE("You tear [HC] in half!"))
						qdel(CM.handcuffed)
						CM.handcuffed = null
						CM.handcuff_update()
				return
			else if(istype(CM,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = CM
				if(H.species.can_shred(H))
					can_break_cuffs = 1


			if(can_break_cuffs) //Don't want to do a lot of logic gating here.
				to_chat(usr, SPAN_DANGER("You attempt to break [HC]. (This will take around 5 seconds and you need to stand still)"))
				for(var/mob/O in viewers(CM))
					O.show_message(SPAN_DANGER("<B>[CM] is trying to break [HC]!</B>"), 1)
				spawn(0)
					if(do_after(CM, 50, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
						if(!CM.handcuffed || CM.buckled)
							return
						for(var/mob/O in viewers(CM))
							O.show_message(SPAN_DANGER("<B>[CM] manages to break [HC]!</B>"), 1)
						to_chat(CM, SPAN_WARNING("You successfully break [HC]."))
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
						qdel(CM.handcuffed)
						CM.handcuffed = null
						CM.handcuff_update()
			else
				var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				/*if(istype(HC, /obj/item/handcuffs/xeno))
					breakouttime = 300
					displaytime = "Half a"
					to_chat(CM, SPAN_WARNING("You attempt to remove \the [HC]. (This will take around half a minute and you need to stand still)"))
					spawn (breakouttime)
						for(var/mob/O in viewers(CM))//                                         lags so hard that 40s isn't lenient enough - Quarxink
							O.show_message(SPAN_DANGER("<B>[CM] manages to remove the handcuffs!</B>"), 1)
						Cto_chat(M, SPAN_NOTICE(" You successfully remove \the [CM.handcuffed]."))
						CM.drop_inv_item_on_ground(CM.handcuffed)
						return*/ //Commented by Apop


				if(istype(HC))
					displaytime = max(1, round(HC.breakouttime / 600)) //Minutes
				to_chat(CM, SPAN_WARNING("You attempt to remove [HC]. (This will take around [displaytime] minute(s) and you need to stand still)"))
				for(var/mob/O in viewers(CM))
					O.show_message(SPAN_DANGER("<B>[usr] attempts to remove [HC]!</B>"), 1)
				spawn(0)
					if(do_after(CM, HC.breakouttime, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
						if(!CM.handcuffed || CM.buckled)
							return // time leniency for lag which also might make this whole thing pointless but the server
						for(var/mob/O in viewers(CM))//                                         lags so hard that 40s isn't lenient enough - Quarxink
							O.show_message(SPAN_DANGER("<B>[CM] manages to remove [HC]!</B>"), 1)
						to_chat(CM, SPAN_NOTICE(" You successfully remove [HC]."))
						CM.drop_inv_item_on_ground(CM.handcuffed)
		else if(CM.legcuffed && CM.canmove && (CM.last_special <= world.time))
			var/obj/item/legcuffs/LC = CM.legcuffed

			CM.next_move = world.time + 100
			CM.last_special = world.time + 100

			var/can_break_cuffs
			if(HULK in usr.mutations)
				can_break_cuffs = 1
			else if(istype(CM,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = CM
				if(H.species.can_shred(H))
					can_break_cuffs = 1

			if(can_break_cuffs) //Don't want to do a lot of logic gating here.
				to_chat(usr, SPAN_DANGER("You attempt to break your legcuffs. (This will take around 5 seconds and you need to stand still)"))
				for(var/mob/O in viewers(CM))
					O.show_message(SPAN_DANGER("<B>[CM] is trying to break [LC]!</B>"), 1)
				spawn(0)
					if(do_after(CM, 50, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
						if(!CM.legcuffed || CM.buckled)
							return
						for(var/mob/O in viewers(CM))
							O.show_message(SPAN_DANGER("<B>[CM] manages to break [LC]!</B>"), 1)
						to_chat(CM, SPAN_WARNING("You successfully break your legcuffs."))
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
						CM.temp_drop_inv_item(CM.legcuffed)
						qdel(CM.legcuffed)
						CM.legcuffed = null
			else
				var/breakouttime = 1200 //A default in case you are somehow legcuffed with something that isn't an obj/item/legcuffs type
				var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(LC)) //If you are legcuffed with actual legcuffs... Well what do I know, maybe someone will want to legcuff you with toilet paper in the future...
					breakouttime = LC.breakouttime
					displaytime = breakouttime / 600 //Minutes
				to_chat(CM, SPAN_WARNING("You attempt to remove [LC]. (This will take around [displaytime] minutes and you need to stand still)"))
				for(var/mob/O in viewers(CM))
					O.show_message( SPAN_DANGER("<B>[L] attempts to remove [LC]!</B>"), 1)
				spawn(0)
					if(do_after(CM, breakouttime, INTERRUPT_NO_NEEDHAND^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
						if(!CM.legcuffed || CM.buckled)
							return // time leniency for lag which also might make this whole thing pointless but the server
						for(var/mob/O in viewers(CM))//                                         lags so hard that 40s isn't lenient enough - Quarxink
							O.show_message(SPAN_DANGER("<B>[CM] manages to remove the legcuffs!</B>"), 1)
						to_chat(CM, SPAN_NOTICE(" You successfully remove \the [CM.legcuffed]."))
						CM.drop_inv_item_on_ground(CM.legcuffed)
						CM.legcuff_update()

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	if(!resting)
		src.KnockDown(1) //so that the mob immediately falls over

	resting = !resting

	to_chat(src, SPAN_NOTICE("You are now [resting ? "resting." : "getting up."]"))
