/////////////////////////////////////////
// SLEEPER CONSOLE
/////////////////////////////////////////

/obj/structure/machinery/sleep_console
	name = "Sleeper Console"
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeperconsole"
	var/obj/structure/machinery/sleeper/connected = null
	anchored = 1 //About time someone fixed this.
	density = 0
	use_power = 1
	idle_power_usage = 40

/obj/structure/machinery/sleep_console/Initialize()
	. = ..()
	connect_sleeper()

/obj/structure/machinery/sleep_console/proc/connect_sleeper()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/sleeper,get_step(src, WEST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/sleeper,get_step(src, EAST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/sleep_console/Destroy()
	if(connected)
		if(connected.occupant)
			connected.go_out()

		connected.connected = null
		QDEL_NULL(connected)
	. = ..()


/obj/structure/machinery/sleep_console/process()
	if(inoperable())
		return
	updateUsrDialog()


/obj/structure/machinery/sleep_console/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)



/obj/structure/machinery/sleep_console/attack_remote(mob/living/user)
	return attack_hand(user)

/obj/structure/machinery/sleep_console/attack_hand(mob/living/user)
	if(..())
		return
	if(inoperable())
		return
	var/dat = ""
	if (!connected || (connected.inoperable()))
		dat += "This console is not connected to a sleeper or the sleeper is non-functional."
	else
		var/mob/living/occupant = connected.occupant
		dat += SET_CLASS("<B>Occupant Statistics:</B>", INTERFACE_BLUE)
		dat += "<BR>"
		if (occupant)
			var/t1
			switch(occupant.stat)
				if(0)
					t1 = "Conscious"
				if(1)
					t1 = SET_CLASS("Unconscious", INTERFACE_BLUE)
				if(2)
					t1 = SET_CLASS("*dead*", INTERFACE_RED)
				else
			var/s_class = occupant.health > 50 ? INTERFACE_BLUE : INTERFACE_RED
			dat += SET_CLASS("\tHealth %: [occupant.health] ([t1])", s_class)
			dat += "<BR>"
			if(iscarbon(occupant))
				var/mob/living/carbon/C = occupant
				s_class = C.pulse == PULSE_NONE || C.pulse == PULSE_THREADY ? INTERFACE_RED : INTERFACE_BLUE
				dat += SET_CLASS("\t-Pulse, bpm: [C.get_pulse(GETPULSE_TOOL)]<BR>", s_class)

			s_class = occupant.getBruteLoss() < 60 ? INTERFACE_BLUE : INTERFACE_RED
			dat += SET_CLASS("\t-Brute Damage %: [occupant.getBruteLoss()]<BR>", s_class)

			s_class = occupant.getOxyLoss() < 60 ? INTERFACE_BLUE : INTERFACE_RED
			dat += SET_CLASS("\t-Respiratory Damage %: [occupant.getOxyLoss()]<BR>", s_class)

			s_class = occupant.getToxLoss() < 60 ? INTERFACE_BLUE : INTERFACE_RED
			dat += SET_CLASS("\t-Toxin Content %: [occupant.getToxLoss()]<BR>", s_class)

			s_class = occupant.getFireLoss() < 60 ? INTERFACE_BLUE : INTERFACE_RED
			dat += SET_CLASS("\t-Burn Severity %: [occupant.getFireLoss()]<BR>", s_class)

			dat += "<HR>Knocked Out Summary %: [occupant.knocked_out] ([round(occupant.knocked_out / 4)] seconds left!)<BR>"
			if(occupant.reagents)
				for(var/chemical in connected.available_chemicals)
					dat += "[connected.available_chemicals[chemical]]: [occupant.reagents.get_reagent_amount(chemical)] units<br>"
			dat += "<A href='?src=\ref[src];refresh=1'>Refresh Meter Readings</A><BR>"

			if(ishuman(occupant))
				if(connected.filtering)
					dat += "<A href='?src=\ref[src];togglefilter=1'>Stop Dialysis</A><BR>"
				else
					dat += "<HR><A href='?src=\ref[src];togglefilter=1'>Start Dialysis</A><BR>"
				dat += "Occupant has [occupant.reagents.total_volume] units of chemicals remaining<BR><HR>"
			else
				dat += "<HR>Dialysis Disabled - Non-human present.<BR><HR>"

			for(var/chemical in connected.available_chemicals)
				dat += "Inject [connected.available_chemicals[chemical]]: "
				for(var/amount in connected.amounts)
					dat += "<a href ='?src=\ref[src];chemical=[chemical];amount=[amount]'>[amount] units</a><br> "


			dat += "<HR><A href='?src=\ref[src];ejectify=1'>Eject Patient</A>"
		else
			dat += "The sleeper is empty."
	dat += "<BR><BR><A href='?src=\ref[user];mach_close=sleeper'>Close</A>"
	show_browser(user, dat, "sleeper")
	return

/obj/structure/machinery/sleep_console/Topic(href, href_list)
	if(..())
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if ((user.contents.Find(src) || ((get_dist(src, user) <= 1) && isturf(loc))))
		user.set_interaction(src)
		if (href_list["chemical"])
			if (connected)
				if (connected.occupant)
					if (connected.occupant.stat == DEAD)
						to_chat(user, SPAN_WARNING("This person has no life for to preserve anymore. Take them to a department capable of reanimating them."))
					else if(href_list["chemical"] in connected.available_chemicals)
						var/amount = text2num(href_list["amount"])
						if(amount == 5 || amount == 10)
							connected.inject_chemical(user,href_list["chemical"],amount)
					else
						to_chat(user, SPAN_WARNING("This person is not in good enough condition for sleepers to be effective! Use another means of treatment, such as cryogenics!"))
					updateUsrDialog()
		if (href_list["refresh"])
			updateUsrDialog()
		if (href_list["togglefilter"])
			connected.toggle_filter()
			updateUsrDialog()
		if (href_list["ejectify"])
			connected.eject()
			updateUsrDialog()
		add_fingerprint(user)
	return









/////////////////////////////////////////
// THE SLEEPER ITSELF
/////////////////////////////////////////

/obj/structure/machinery/sleeper
	name = "Sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/structures/machinery/cryogenics.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	var/mob/living/carbon/human/occupant = null
	var/available_chemicals = list("inaprovaline" = "Inaprovaline", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin", "tricordrazine" = "Tricordrazine")
	var/amounts = list(5, 10)
	var/filtering = FALSE
	var/obj/structure/machinery/sleep_console/connected
	var/reagent_removed_per_second = AMOUNT_PER_TIME(3, 1 SECONDS)

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.


/obj/structure/machinery/sleeper/Initialize()
	. = ..()
	connect_sleeper_console()

/obj/structure/machinery/sleeper/proc/connect_sleeper_console()
	if(connected)
		return
	if(dir == EAST || dir == SOUTH)
		connected = locate(/obj/structure/machinery/sleep_console,get_step(src, EAST))
	if(dir == WEST || dir == NORTH)
		connected = locate(/obj/structure/machinery/sleep_console,get_step(src, WEST))
	if(connected)
		connected.connected = src


/obj/structure/machinery/sleeper/Destroy()
	if(occupant)
		go_out()
	if(connected)
		connected.connected = null
		QDEL_NULL(connected)
	. = ..()



/obj/structure/machinery/sleeper/update_icon()
	if(occupant)
		icon_state = "sleeper_1"
	else
		icon_state = "sleeper_0"

/obj/structure/machinery/sleeper/allow_drop()
	return 0

/obj/structure/machinery/sleeper/process(delta_time)
	if (inoperable())
		return

	if(filtering)
		for(var/datum/reagent/x in occupant.reagents.reagent_list)
			occupant.reagents.remove_reagent(x.id, reagent_removed_per_second*delta_time)

	updateUsrDialog()


/obj/structure/machinery/sleeper/attackby(var/obj/item/W, var/mob/living/user)
	if(istype(W, /obj/item/grab))
		if(isXeno(user)) return
		var/obj/item/grab/G = W
		if(!ismob(G.grabbed_thing))
			return

		if(occupant)
			to_chat(user, SPAN_NOTICE("The sleeper is already occupied!"))
			return

		visible_message(SPAN_NOTICE("[user] starts putting [G.grabbed_thing] into the sleeper."), null, null, 3)

		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			if(occupant)
				to_chat(user, SPAN_NOTICE("The sleeper is already occupied!"))
				return
			if(!G || !G.grabbed_thing) return
			var/mob/M = G.grabbed_thing
			go_in_sleeper(M)
			add_fingerprint(user)



/obj/structure/machinery/sleeper/ex_act(severity)
	if(filtering)
		toggle_filter()
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				qdel(src)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)


/obj/structure/machinery/sleeper/emp_act(severity)
	if(filtering)
		toggle_filter()
	if(inoperable())
		..(severity)
		return
	if(occupant)
		go_out()
	..()

/obj/structure/machinery/sleeper/proc/toggle_filter()
	if(!occupant)
		filtering = FALSE
		return
	if(filtering)
		filtering = FALSE
	else
		filtering = TRUE

/obj/structure/machinery/sleeper/proc/go_in_sleeper(mob/M)
	M.forceMove(src)
	update_use_power(2)
	occupant = M
	START_PROCESSING(SSobj, src)
	START_PROCESSING(SSobj, connected)
	update_icon()
	//prevents occupant's belonging from landing inside the machine
	for(var/obj/O in src)
		O.forceMove(loc)


/obj/structure/machinery/sleeper/proc/go_out()
	if(filtering)
		toggle_filter()
	if(!occupant)
		return
	occupant.forceMove(loc)
	occupant = null
	STOP_PROCESSING(SSobj, src)
	STOP_PROCESSING(SSobj, connected)
	update_use_power(1)
	update_icon()

#ifdef OBJECTS_PROXY_SPEECH
// Transfers speech to occupant
/obj/structure/machinery/sleeper/hear_talk(mob/living/sourcemob, message, verb, language, italics)
	if(!QDELETED(occupant) && istype(occupant) && occupant.stat != DEAD)
		proxy_object_heard(src, sourcemob, occupant, message, verb, language, italics)
	else
		..(sourcemob, message, verb, language, italics)
#endif // ifdef OBJECTS_PROXY_SPEECH

/obj/structure/machinery/sleeper/proc/inject_chemical(mob/living/user as mob, chemical, amount)
	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= 20)
			occupant.reagents.add_reagent(chemical, amount, , , user)
			to_chat(user, SPAN_NOTICE("Occupant now has [occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in his/her bloodstream."))
			return
	to_chat(user, SPAN_WARNING("There's no occupant in the sleeper or the subject has too many chemicals!"))
	return


/obj/structure/machinery/sleeper/proc/check(mob/living/user)
	if(occupant)
		var/msg_occupant = "[occupant]"
		to_chat(user, SPAN_NOTICE("<B>Occupant ([msg_occupant]) Statistics:</B>"))
		var/t1
		switch(occupant.stat)
			if(0)
				t1 = "Conscious"
			if(1)
				t1 = "Unconscious"
			if(2)
				t1 = "*dead*"
			else
		to_chat(user, "[]\t Health %: [] ([])", (occupant.health > 50 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.health, t1)
		to_chat(user, "[]\t -Core Temperature: []&deg;C ([]&deg;F)</FONT><BR>", (occupant.bodytemperature > 50 ? "<font color='blue'>" : "<font color='red'>"), occupant.bodytemperature-T0C, occupant.bodytemperature*1.8-459.67)
		to_chat(user, "[]\t -Brute Damage %: []", (occupant.getBruteLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getBruteLoss())
		to_chat(user, "[]\t -Respiratory Damage %: []", (occupant.getOxyLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getOxyLoss())
		to_chat(user, "[]\t -Toxin Content %: []", (occupant.getToxLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getToxLoss())
		to_chat(user, "[]\t -Burn Severity %: []", (occupant.getFireLoss() < 60 ? SPAN_NOTICE("") : SPAN_DANGER("")), occupant.getFireLoss())
		to_chat(user, SPAN_NOTICE(" Expected time till occupant can safely awake: (note: If health is below 20% these times are inaccurate)"))
		to_chat(user, SPAN_NOTICE(" \t [occupant.knocked_out / 5] second\s (if around 1 or 2 the sleeper is keeping them asleep.)"))
	else
		to_chat(user, SPAN_NOTICE(" There is no one inside!"))
	return


/obj/structure/machinery/sleeper/verb/eject()
	set name = "Eject Sleeper"
	set category = "Object"
	set src in oview(1)
	if(usr.is_mob_incapacitated())
		return
	go_out()
	add_fingerprint(usr)


/obj/structure/machinery/sleeper/verb/move_inside()
	set name = "Enter Sleeper"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if(occupant)
		to_chat(user, SPAN_NOTICE("The sleeper is already occupied!"))
		return

	visible_message("[user] starts climbing into the sleeper.", null, null, 3)

	if(do_after(user, 20, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		if(occupant)
			to_chat(user, SPAN_NOTICE("The sleeper is already occupied!"))
			return
		go_in_sleeper(user)
		add_fingerprint(user)
