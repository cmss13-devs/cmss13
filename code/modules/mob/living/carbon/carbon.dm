/mob/living/carbon/Life()
	..()

	handle_fire() //Check if we're on fire

/mob/living/carbon/Destroy()
	if(internal_organs)
		for(var/datum/internal_organ/I in internal_organs)
			qdel(I)
		internal_organs = null

	for(var/datum/disease/virus in viruses)
		virus.cure()

	. = ..()

	if(handcuffed)
		qdel(handcuffed)
		handcuffed = null

	if(legcuffed)
		qdel(legcuffed)
		legcuffed = null

	stomach_contents.Cut() //movable atom's Dispose() deletes all content, we clear stomach_contents to be safe.

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(nutrition && stat != DEAD)
			nutrition -= HUNGER_FACTOR/5

/mob/living/carbon/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated(TRUE)) return
	if(user in src.stomach_contents)
		if(user.client)
			user.client.next_movement = world.time + 20
		if(prob(30))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(SPAN_DANGER("You hear something rumbling inside [src]'s stomach..."), 2)
		var/obj/item/I = user.get_active_hand()
		if(I && I.force)
			var/d = rand(round(I.force / 4), I.force)
			if(istype(src, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = src
				var/organ = H.get_limb("chest")
				if(istype(organ, /obj/limb))
					var/obj/limb/temp = organ
					if(temp.take_damage(d, 0))
						H.UpdateDamageIcon()
				H.updatehealth()
			else
				src.take_limb_damage(d)
			for(var/mob/M in viewers(user, null))
				if(M.client)
					M.show_message(text(SPAN_DANGER("<B>[user] attacks [src]'s stomach wall with the [I.name]!")), 2)
			user.track_hit(initial(I.name))
			playsound(user.loc, 'sound/effects/attackblob.ogg', 25, 1)

			if(prob(max(4*(100*getBruteLoss()/maxHealth - 75),0))) //4% at 24% health, 80% at 5% health
				last_damage_source = "chestbursting"
				last_damage_mob = user
				gib("chestbursting")
	else if(!chestburst && (status_flags & XENO_HOST) && isXenoLarva(user))
		var/mob/living/carbon/Xenomorph/Larva/L = user
		L.chest_burst(src)

/mob/living/carbon/ex_act(var/severity, var/direction, var/source, var/source_mob)

	if(lying)
		severity *= EXPLOSION_PRONE_MULTIPLIER

	if(severity >= 30)
		flash_eyes()

	if(source)
		last_damage_source = source
	if(source_mob)
		last_damage_mob = source_mob

	if(severity >= health && severity >= EXPLOSION_THRESHOLD_GIB)
		gib(source)
		return

	apply_damage(severity, BRUTE)
	updatehealth()

	var/knock_value = min( round( severity*0.1 ,1) ,10)
	if(knock_value > 0)
		KnockDown(knock_value)
		KnockOut(knock_value)
		explosion_throw(severity, direction)

/mob/living/carbon/gib(var/cause = "gibbing")
	if(legcuffed)
		drop_inv_item_on_ground(legcuffed)

	for(var/atom/movable/A in stomach_contents)
		stomach_contents.Remove(A)
		A.forceMove(get_turf(loc))
		A.acid_damage = 0 //Reset the acid damage
		if(ismob(A))
			visible_message(SPAN_DANGER("[A] bursts out of [src]!"))

	for(var/atom/movable/A in contents_recursive())
		if(isobj(A))
			var/obj/O = A
			if(O.unacidable)
				O.forceMove(get_turf(loc))
				O.throw_atom(pick(range(get_turf(loc), 1)), 1, SPEED_FAST)

	. = ..(cause)


/mob/living/carbon/revive()
	if(handcuffed && !initial(handcuffed))
		drop_inv_item_on_ground(handcuffed)
	handcuffed = initial(handcuffed)

	if(legcuffed && !initial(legcuffed))
		drop_inv_item_on_ground(legcuffed)
	legcuffed = initial(legcuffed)
	recalculate_move_delay = TRUE
	..()


/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return

	for(var/datum/disease/D in viruses)
		if(D.spread_by_touch())
			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)
		if(D.spread_by_touch())
			contract_disease(D, 0, 1, CONTACT_HANDS)

	next_move += 7 //Adds some lag to the 'attack'
	return

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE) //godmode
		return FALSE
	shock_damage *= siemens_coeff
	if(shock_damage<1)
		return FALSE

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")

	playsound(loc, "sparks", 25, 1)
	if(shock_damage > 10)
		src.visible_message(
			SPAN_DANGER("[src] was shocked by the [source]!"), \
			SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"), \
			SPAN_DANGER("You hear a heavy electrical crack.") \
		)
		if(isXeno(src) && mob_size == MOB_SIZE_BIG)
			Stun(1)//Sadly, something has to stop them from bumping them 10 times in a second
			KnockDown(1)
		else
			Stun(6)//This should work for now, more is really silly and makes you lay there forever
			KnockDown(6)
		
		count_niche_stat(STATISTICS_NICHE_SHOCK)
		
	else
		src.visible_message(
			SPAN_DANGER("[src] was mildly shocked by the [source]."), \
			SPAN_DANGER("You feel a mild shock course through your body."), \
			SPAN_DANGER("You hear a light zapping.") \
		)

	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage


/mob/living/carbon/swap_hand()
	var/obj/item/wielded_item = get_active_hand()
	if(wielded_item && (wielded_item.flags_item & WIELDED)) //this segment checks if the item in your hand is twohanded.
		var/obj/item/weapon/melee/twohanded/offhand/offhand = get_inactive_hand()
		if(offhand && (offhand.flags_item & WIELDED))
			to_chat(src, SPAN_WARNING("Your other hand is too busy holding \the [offhand.name]")) //So it's an offhand.
			return
		else 
			wielded_item.unwield(src) //Get rid of it.
	if(wielded_item && wielded_item.zoom) //Adding this here while we're at it
		wielded_item.zoom(src)
	..()
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	return

/mob/living/carbon/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if(src == M)
		return
	var/t_him = "it"
	if(gender == MALE)
		t_him = "him"
	else if(gender == FEMALE)
		t_him = "her"
	if(lying || sleeping)
		if(client)
			sleeping = max(0,sleeping-5)
		if(sleeping == 0)
			resting = 0
			update_canmove()
		M.visible_message(SPAN_NOTICE("[M] shakes [src] trying to wake [t_him] up!"), \
			SPAN_NOTICE("You shake [src] trying to wake [t_him] up!"), null, 4)
	else
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.species.hug(H, src, H.zone_selected)
		else
			M.visible_message(SPAN_NOTICE("[M] pats [src] on the back to make [t_him] feel better!"), \
				SPAN_NOTICE("You pat [src] on the back to make [t_him] feel better!"), null, 4)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)
		return

	AdjustKnockedout(-3)
	AdjustStunned(-3)
	AdjustKnockeddown(-3)

	playsound(loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 5)


//Throwing stuff

/mob/living/carbon/toggle_normal_throw()
	if(!stat && isturf(loc) && !is_mob_restrained())
		toggle_throw_mode(THROW_MODE_NORMAL)

/mob/living/carbon/toggle_high_toss()
	if(!stat && isturf(loc) && !is_mob_restrained())
		toggle_throw_mode(THROW_MODE_HIGH)

/mob/living/carbon/proc/toggle_throw_mode(type)
	if(type == THROW_MODE_OFF || throw_mode == type)
		throw_mode = THROW_MODE_OFF
		if(hud_used && hud_used.throw_icon)
			hud_used.throw_icon.icon_state = "act_throw_off"
		return
	
	throw_mode = type
	if(!hud_used || !hud_used.throw_icon)
		return

	if(type == THROW_MODE_NORMAL)
		hud_used.throw_icon.icon_state = "act_throw_normal"
	else
		hud_used.throw_icon.icon_state = "act_throw_high"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	var/throw_type = throw_mode
	toggle_throw_mode(THROW_MODE_OFF) // This MUST be at the beginning, or else players will not recognize that throw is not toggled on (especially xenos)

	if(is_ventcrawling) //NOPE
		return
	if(stat || !target)
		return
	if(!istype(loc, /turf)) // In some mob/object (i.e. devoured or tank)
		to_chat(src, SPAN_WARNING("You cannot throw anything while inside of \the [loc.name]."))
		return
	if(target.type == /obj/screen)
		return

	var/atom/movable/thrown_thing
	var/obj/item/I = get_active_hand()

	if(!I || (I.flags_item & NODROP))
		return

	var/spin_throw = TRUE

	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(ismob(G.grabbed_thing))
			if(grab_level >= GRAB_CARRY) // Carry and choke can only throw
				var/mob/living/M = G.grabbed_thing
				spin_throw = FALSE //thrown mobs don't spin
				thrown_thing = M
				var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
				var/turf/end_T = get_turf(target)
				if(start_T && end_T)
					var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
					var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

					M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been thrown by [key_name(usr)] from [start_T_descriptor] with the target [end_T_descriptor]</font>"
					usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has thrown [key_name(M)] from [start_T_descriptor] with the target [end_T_descriptor]</font>"
					msg_admin_attack("[key_name(usr)] has thrown [key_name(M)] from [start_T_descriptor] with the target [end_T_descriptor] in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
			else
				to_chat(src, SPAN_WARNING("You need a better grip!"))

	else //real item in hand, not a grab
		thrown_thing = I

	//actually throw it!
	if(thrown_thing)
		visible_message(SPAN_WARNING("[src] has thrown [thrown_thing]."), null, null, 5)

		if(!lastarea)
			lastarea = get_area(src.loc)
		if((istype(loc, /turf/open/space)) || !lastarea.has_gravity)
			inertia_dir = get_dir(target, src)
			step(src, inertia_dir)

		if(throw_type == THROW_MODE_HIGH)
			to_chat(src, SPAN_NOTICE("You prepare to perform a high toss."))
			if(!do_after(src, SECONDS_1, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
				to_chat(src, SPAN_WARNING("You need to set up the high toss!"))
				return
			drop_inv_item_on_ground(I, TRUE)
			thrown_thing.throw_atom(target, thrown_thing.throw_range, SPEED_SLOW, src, spin_throw, HIGH_LAUNCH)
		else
			drop_inv_item_on_ground(I, TRUE)
			thrown_thing.throw_atom(target, thrown_thing.throw_range, thrown_thing.throw_speed, src, spin_throw)

/mob/living/carbon/fire_act(exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT+10)
	recalculate_move_delay = TRUE


/mob/living/carbon/show_inv(mob/living/carbon/user as mob)
	user.set_interaction(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=face'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/tank) && !( internal )) ? " <A href='?src=\ref[src];internal=1'>Set Internal</A>" : "")]
	<BR>[(handcuffed ? "<A href='?src=\ref[src];item=handcuffs'>Handcuffed</A>" : "<A href='?src=\ref[src];item=handcuffs'>Not Handcuffed</A>")]
	<BR>[(internal ? "<A href='?src=\ref[src];internal=1'>Remove Internal</A>" : "")]
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	show_browser(user, dat, name, "mob[name]")

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		to_chat(usr, SPAN_DANGER("You are already sleeping"))
		return
	if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
		usr.sleeping = 20 //Short nap


/mob/living/carbon/Collide(atom/movable/AM)
	if(now_pushing)
		return
	. = ..()

/mob/living/carbon/slip(slip_source_name, stun_level, weaken_level, run_only, override_noslip, slide_steps)
	set waitfor = 0
	if(buckled) return FALSE //can't slip while buckled
	if(lying) return FALSE //can't slip if already lying down.
	stop_pulling()
	to_chat(src, SPAN_WARNING("You slipped on \the [slip_source_name? slip_source_name : "floor"]!"))
	playsound(src.loc, 'sound/misc/slip.ogg', 25, 1)
	Stun(stun_level)
	KnockDown(weaken_level)
	. = TRUE
	if(slide_steps && lying)//lying check to make sure we downed the mob
		var/slide_dir = dir
		for(var/i=1, i<=slide_steps, i++)
			step(src, slide_dir)
			sleep(2)
			if(!lying)
				break



/mob/living/carbon/on_stored_atom_del(atom/movable/AM)
	..()
	if(stomach_contents.len && ismob(AM))
		for(var/X in stomach_contents)
			if(AM == X)
				stomach_contents -= AM
				break

/mob/living/carbon/proc/extinguish_mob(mob/living/carbon/C)
	adjust_fire_stacks(-5, min_stacks = 0)
	playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
	C.visible_message(SPAN_DANGER("[C] tries to put out the fire on [src]!"), \
	SPAN_WARNING("You try to put out the fire on [src]!"), null, 5)
	if(fire_stacks <= 0)
		C.visible_message(SPAN_DANGER("[C] has successfully extinguished the fire on [src]!"), \
		SPAN_NOTICE("You extinguished the fire on [src]."), null, 5)

/mob/living/carbon/resist_buckle()
	if(istype(buckled, /obj/structure/bed/nest))
		buckled.manual_unbuckle(src)
		return
		
	if(handcuffed)
		next_move = world.time + 100
		last_special = world.time + 100
		visible_message(SPAN_DANGER("<B>[src] attempts to unbuckle themself!</B>"),\
		SPAN_DANGER("You attempt to unbuckle yourself. (This will take around 2 minutes and you need to stand still)"))
		if(do_after(src, 1200, INTERRUPT_ALL^INTERRUPT_RESIST, BUSY_ICON_HOSTILE))
			if(!buckled)
				return
			visible_message(SPAN_DANGER("<B>[src] manages to unbuckle themself!</B>"),\
						SPAN_NOTICE("You successfully unbuckle yourself."))
			buckled.manual_unbuckle(src)
	else
		buckled.manual_unbuckle(src)
