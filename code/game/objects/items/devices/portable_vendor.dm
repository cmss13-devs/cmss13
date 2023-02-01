//Vendor for CL stuff
//Bribe items may help marines, but also give CL more control over them
//Bought with points, which regenerate over time

/obj/item/device/portable_vendor
	name = "\improper Automated Storage Briefcase"
	desc = "A suitcase-sized automated storage and retrieval system. Designed to efficiently store and selectively dispense small items."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "secure"
	flags_atom = FPRINT|CONDUCT
	force = 8
	hitsound = "swing_hit"
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_LARGE

	var/req_role = "" //to be compared with assigned_role to only allow those to use that machine.
	var/points = 40
	var/max_points = 50
	var/use_points = TRUE
	var/fabricating = 0
	var/broken = 0
	var/list/purchase_log = list()

	var/list/listed_products = list()

	var/special_prod_time_lock //needs to be a time define
	var/list/special_prods //list of typepaths

/obj/item/device/portable_vendor/attack_hand(mob/user)
	if(loc == user)
		attack_self(user)
	else
		..()


/obj/item/device/portable_vendor/attack_self(mob/user)
	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	src.add_fingerprint(usr)

	if(broken)
		to_chat(user, SPAN_NOTICE("[src] is irrepairably broken."))
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/obj/item/card/id/I = H.wear_id
	if(!istype(I)) //not wearing an ID
		to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
		return

	if(I.registered_name != H.real_name)
		to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
		return

	if(req_role && I.rank != req_role)
		to_chat(H, SPAN_WARNING("This device isn't for you."))
		return


	user.set_interaction(src)
	ui_interact(user)


/obj/item/device/portable_vendor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 0)

	if(!ishuman(user)) return

	var/list/display_list = list()


	for(var/i in 1 to listed_products.len)
		var/list/myprod = listed_products[i]
		var/p_name = myprod[1]
		var/p_cost = myprod[2]
		if(p_cost > 0)
			p_name += " ([p_cost] points)"

		var/prod_available = FALSE
		//var/avail_flag = myprod[4]
		if(points >= p_cost || !use_points)
			prod_available = TRUE

								//place in main list, name, cost, available or not, color.
		display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_available" = prod_available, "prod_color" = myprod[4], "prod_desc" = myprod[5]))


	var/list/data = list(
		"vendor_name" = name,
		"show_points" = use_points,
		"current_points" = round(points),
		"max_points" = max_points,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "portable_vendor.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)


/obj/item/device/portable_vendor/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(broken)
		return
	if(usr.is_mob_incapacitated())
		return

	if (in_range(src, usr) && ishuman(usr))
		usr.set_interaction(src)
		if (href_list["vend"])

			if(!allowed(usr))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return

			var/mob/living/carbon/human/H = usr
			var/obj/item/card/id/I = H.wear_id
			if(!istype(I)) //not wearing an ID
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				return

			if(I.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				return

			if(req_role && I.rank != req_role)
				to_chat(H, SPAN_WARNING("This device isn't for you."))
				return

			var/idx=text2num(href_list["vend"])

			var/list/L = listed_products[idx]
			var/cost = L[2]

			if(use_points && points < cost)
				to_chat(H, SPAN_WARNING("Not enough points."))
				return


			var/turf/T = get_turf(loc)
			if(length(T.contents) > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				return

			if(special_prod_time_lock)
				if(L[3] in special_prods)
					if(world.time < SSticker.mode.round_time_lobby + special_prod_time_lock)
						to_chat(usr, SPAN_WARNING("\The [src] is still fabricating \the [L[1]]. Please wait another [round((SSticker.mode.round_time_lobby + special_prod_time_lock-world.time)/600)] minutes before trying again."))
						return

			if(use_points)
				points -= cost

			purchase_log += "[key_name(usr)] bought [L[1]]."

			playsound(src, "sound/machines/fax.ogg", 5)
			fabricating = 1
			update_overlays()
			spawn(30)
				var/type_p = L[3]
				var/obj/IT = new type_p(get_turf(src))
				H.put_in_any_hand_if_possible(IT)
				fabricating = 0
				update_overlays()

		src.add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window


/obj/item/device/portable_vendor/proc/update_overlays()
	if(overlays) overlays.Cut()
	if (broken)
		overlays += image(icon, "securespark")
	else if (fabricating)
		overlays += image(icon, "secureb")
	else
		overlays += image(icon, "secure0")


/obj/item/device/portable_vendor/process()
	points = min(max_points, points+0.05)


/obj/item/device/portable_vendor/New()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_overlays()

/obj/item/device/portable_vendor/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/device/portable_vendor/proc/malfunction()
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_WARNING("[src] shudders as its internal components break apart!"))
	broken = 1
	STOP_PROCESSING(SSobj, src)
	update_overlays()

	playsound(src, 'sound/effects/sparks4.ogg', 60, 1)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(2, 1, src)
	s.start()

/obj/item/device/portable_vendor/emp_act(severity)
	if (broken)
		return
	if (prob(40*severity))
		malfunction()

/obj/item/device/portable_vendor/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(80))
				malfunction()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
			else
				malfunction()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return


/obj/item/device/portable_vendor/corporate
	name = "\improper Weyland-Yutani Automated Storage Briefcase"
	desc = "A suitcase-sized automated storage and retrieval system. Designed to efficiently store and selectively dispense small items. This one has the Weyland-Yutani logo stamped on its side."

	special_prod_time_lock = CL_BRIEFCASE_TIME_LOCK
	special_prods = list(/obj/item/implanter/neurostim, /obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison)

	req_access = list(ACCESS_WY_CORPORATE)
	req_role = JOB_CORPORATE_LIAISON
	listed_products = list(
		list("INCENTIVES", 0, null, null, null),
		list("Neurostimulator Implant", 30, /obj/item/implanter/neurostim, "white", "Implant which regulates nociception and sensory function. Benefits include pain reduction, improved balance, and improved resistance to overstimulation and disorientation. To encourage compliance, negative stimulus is applied if the implant hears a (non-radio) spoken codephrase. Implant will be degraded by the body's immune system over time, and thus malfunction with gradually increasing frequency. Personal use not recommended."),
		list("Ultrazine Injector", 25, /obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison, "white", "Highly-addictive stimulant. Enhances short-term physical performance, particularly running speed. Effects last approximately 10 minutes per injection. More than two injections at a time will result in overdose. Withdrawal causes extreme discomfort and hallucinations. Long-term use results in halluciations and organ failure. Conditional distribution secures subject compliance. Not for personal use."),
		list("Ceramic Plate", 10, /obj/item/trash/ceramic_plate, "white", "A ceramic plate, useful in a variety of situations."),
		list("Cash", 5, /obj/item/spacecash/c1000/counterfeit, "white", "$1000 USD, unmarked bills"),
		list("WY Encryption Key", 5, /obj/item/device/encryptionkey/WY, "white", "WY private comms encryption key, for conducting private business."),

		list("SMOKABLES", 0, null, null, null),
		list("Cigars", 5, /obj/item/storage/fancy/cigar, "white", "Case of premium cigars, untampered."),
		list("Cigarettes", 5, /obj/item/storage/fancy/cigarettes/wypacket, "white", "Weyland-Yutani Gold packet, for the more sophisticated taste."),
		list("Zippo", 5, /obj/item/tool/lighter/zippo, "white", "A Zippo lighter, for those smoking in style."),

		list("DRINKABLES", 0, null, null, null),
		list("Sake", 5, /obj/item/reagent_container/food/drinks/bottle/sake, "white", "Weyland-Yutani Sake, for a proper business dinner."),
		list("Beer", 5, /obj/item/reagent_container/food/drinks/cans/aspen, "white", "Weyland-Yutani Aspen Beer, for a more casual night."),
		list("Drinking Glass", 1, /obj/item/reagent_container/food/drinks/drinkingglass, "white", "A Drinking Glass, because you have class."),

		list("STATIONERY", 0, null, null, null),
		list("WY pen, black", 1, /obj/item/tool/pen/clicky, "white", "A WY pen, for writing formally on the go."),
		list("WY pen, blue", 1, /obj/item/tool/pen/blue/clicky, "white", "A WY pen, for writing with a flourish on the go."),
		list("WY pen, red", 1, /obj/item/tool/pen/red/clicky, "white", "A WY pen, for writing angrily on the go."),
		list("WY pen, green", 1, /obj/item/tool/pen/green/clicky, "white", "A WY pen, for writing angrily on the go."),
		list("Paper", 1, /obj/item/paper, "white", "A fresh piece of paper, for writing on."),
		list("WY Paper", 1, /obj/item/paper/wy, "white", "A fresh piece of WY-branded paper, for writing important things on."),
		list("Carbon Paper", 1, /obj/item/paper/carbon, "white", "A piece of carbon paper, to double the writing output."),
		list("Clipboard", 1, /obj/item/clipboard, "white", "A clipboard, for storing all that writing."),
	)
