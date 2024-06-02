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

	/// to be compared with assigned_role to only allow those to use that machine.
	var/req_role = ""
	var/points = 40
	var/max_points = 50
	var/use_points = TRUE
	var/fabricating = FALSE
	var/broken = FALSE
	var/contraband = FALSE

	var/list/purchase_log = list()

	var/list/listed_products = list()
	var/list/contraband_products = list()

	/// needs to be a time define
	var/special_prod_time_lock
	/// list of typepaths
	var/list/special_prods

/obj/item/device/portable_vendor/attack_hand(mob/user)
	if(loc == user)
		attack_self(user)
	else
		..()


/obj/item/device/portable_vendor/attack_self(mob/user)
	..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user

	src.add_fingerprint(usr)

	if(broken)
		to_chat(user, SPAN_NOTICE("[src] is irrepairably broken."))
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/obj/item/card/id/idcard = human_user.wear_id
	if(!istype(idcard)) //not wearing an ID
		to_chat(human_user, SPAN_WARNING("Access denied. No ID card detected"))
		return

	if(!idcard.check_biometrics(human_user))
		to_chat(human_user, SPAN_WARNING("Wrong ID card owner detected."))
		return

	if(req_role && idcard.rank != req_role)
		to_chat(human_user, SPAN_WARNING("This device isn't for you."))
		return


	user.set_interaction(src)
	tgui_interact(user)

/obj/item/device/portable_vendor/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableVendor", "[src]")
		ui.open()

/obj/item/device/portable_vendor/ui_data(mob/user)
	. = ..()

	var/list/available_items = list()
	for(var/index in 1 to length(listed_products))
		var/product = listed_products[index]

		var/name = product[1]
		var/cost = product[2]
		var/color = product[4]
		var/description = product[5]

		if(cost > 0)
			name += " ([cost] points)"

		var/available = points >= product[2] || !use_points
		available_items += list(list("index" = index, "name" = name, "cost" = cost, "available" = available, "color" = color, "description" = description))

	if(contraband)
		var/non_contraband_product_count = length(listed_products)
		for(var/index in 1 to length(contraband_products))
			var/product = contraband_products[index]

			var/name = product[1]
			var/cost = product[2]
			var/color = product[4]
			var/description = product[5]

			if(cost > 0)
				name += " ([cost] points)"

			var/available = points >= product[2] || !use_points
			available_items += list(list("index" = index + non_contraband_product_count, "name" = name, "cost" = cost, "available" = available, "color" = color, "description" = description))

	.["vendor_name"] = name
	.["show_points"] = use_points
	.["current_points"] = floor(points)
	.["max_points"] = max_points
	.["displayed_records"] = available_items


/obj/item/device/portable_vendor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("vend")
			vend(text2num(params["choice"]), ui.user)

/obj/item/device/portable_vendor/proc/vend(choice, mob/user)
	if(broken)
		return

	if(user.is_mob_incapacitated())
		return

	if(!(in_range(src, user) || ishuman(user)))
		return

	user.set_interaction(src)

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/mob/living/carbon/human/human_user = user
	var/obj/item/card/id/id = human_user.get_idcard()

	if(!istype(id))
		to_chat(human_user, SPAN_WARNING("Access denied. No ID card detected."))
		return

	if(req_role && req_role != id.rank)
		to_chat(human_user, SPAN_WARNING("This device isn't for you."))

	var/list/product
	var/non_contraband_product_count = length(listed_products)
	if(choice > non_contraband_product_count)
		choice -= non_contraband_product_count
		product = contraband_products[choice]
	else
		product = listed_products[choice]

	var/cost = product[2]

	if(use_points && points < cost)
		to_chat(human_user, SPAN_WARNING("Not enough points."))
		return

	var/turf/current_turf = get_turf(src)
	if(length(current_turf.contents) > 25)
		to_chat(human_user, SPAN_WARNING("The floor is too cluttered, make some space."))
		return

	if(special_prod_time_lock && (product[3] in special_prods))
		if(ROUND_TIME < special_prod_time_lock)
			to_chat(usr, SPAN_WARNING("[src] is still fabricating [product[1]]. Please wait another [floor((SSticker.mode.round_time_lobby + special_prod_time_lock-world.time)/600)] minutes before trying again."))
			return

	if(use_points)
		points -= cost

	purchase_log += "[key_name(usr)] bought [product[1]]."

	playsound(src, "sound/machines/fax.ogg", 5)
	fabricating = TRUE
	update_overlays()

	addtimer(CALLBACK(src, PROC_REF(spawn_product), product[3], user), 3 SECONDS)

/obj/item/device/portable_vendor/proc/spawn_product(typepath, mob/user)
	var/obj/new_item = new typepath(get_turf(src))
	user.put_in_any_hand_if_possible(new_item)
	fabricating = FALSE
	update_overlays()

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

/obj/item/device/portable_vendor/Initialize()
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
	. = ..()
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

	req_access = list(ACCESS_WY_EXEC)
	req_role = JOB_CORPORATE_LIAISON
	listed_products = list(
		list("INCENTIVES", 0, null, null, null),
		list("Corporate Security Bodyguard", 50, /obj/item/handheld_distress_beacon/bodyguard, "white", "A beacon which sends the Corporate Security Division an encoded message informing them of your request for a Corporate Security Bodyguard."),
		list("Corporate Lawyer Team", 50, /obj/item/handheld_distress_beacon/lawyer, "white", "A beacon which sends the Corporate Affairs Division an encoded message informing them of your request for a Corporate Lawyer, required when a contract signee breaks one of their clauses."),
		list("Neurostimulator Implant", 30, /obj/item/implanter/neurostim, "white", "Implant which regulates nociception and sensory function. Benefits include pain reduction, improved balance, and improved resistance to overstimulation and disorientation. To encourage compliance, negative stimulus is applied if the implant hears a (non-radio) spoken codephrase. Implant will be degraded by the body's immune system over time, and thus malfunction with gradually increasing frequency. Personal use not recommended."),
		list("Ultrazine Injector", 25, /obj/item/reagent_container/hypospray/autoinjector/ultrazine/liaison, "white", "Highly-addictive stimulant. Enhances short-term physical performance, particularly running speed. Effects last approximately 10 minutes per injection. More than two injections at a time will result in overdose. Withdrawal causes extreme discomfort and hallucinations. Long-term use results in halluciations and organ failure. Conditional distribution secures subject compliance. Not for personal use."),
		list("Cyanide Pill", 20, /obj/item/reagent_container/pill/cyanide, "white", "A cyanide pill, also known as a suicide pill. For the easy way out."),
		list("Ceramic Plate", 10, /obj/item/trash/ceramic_plate, "white", "A ceramic plate, useful in a variety of situations."),
		list("Cash", 5, /obj/item/spacecash/c1000/counterfeit, "white", "$1000 USD, unmarked bills"),
		list("WY Encryption Key", 5, /obj/item/device/encryptionkey/WY, "white", "WY private comms encryption key, for conducting private business."),

		list("SMOKABLES", 0, null, null, null),
		list("Cigars", 5, /obj/item/storage/fancy/cigar, "white", "Case of premium cigars, untampered."),
		list("Cigarettes", 5, /obj/item/storage/fancy/cigarettes/wypacket, "white", "Weyland-Yutani Gold packet, for the more sophisticated taste."),
		list("Zippo", 5, /obj/item/tool/lighter/zippo/executive, "white", "A Weyland-Yutani brand Zippo lighter, for those smoking in style."),

		list("DRINKABLES", 0, null, null, null),
		list("Sake", 5, /obj/item/reagent_container/food/drinks/bottle/sake, "white", "Weyland-Yutani Sake, for a proper business dinner."),
		list("Beer", 5, /obj/item/reagent_container/food/drinks/cans/aspen, "white", "Weyland-Yutani Aspen Beer, for a more casual night."),
		list("Drinking Glass", 1, /obj/item/reagent_container/food/drinks/drinkingglass, "white", "A Drinking Glass, because you have class."),
		list("Weyland-Yutani Coffee Mug", 1, /obj/item/reagent_container/food/drinks/coffeecup/wy, "white", "A Weyland-Yutani coffee mug, for any Marines who want a Company souvenir."),

		list("STATIONARY", 0, null, null, null),
		list("WY pen, black", 1, /obj/item/tool/pen/clicky, "white", "A WY pen, for writing formally on the go."),
		list("WY pen, blue", 1, /obj/item/tool/pen/blue/clicky, "white", "A WY pen, for writing with a flourish on the go."),
		list("WY pen, red", 1, /obj/item/tool/pen/red/clicky, "white", "A WY pen, for writing angrily on the go."),
		list("WY pen, green", 1, /obj/item/tool/pen/green/clicky, "white", "A WY pen, for writing angrily on the go."),
		list("Paper", 1, /obj/item/paper, "white", "A fresh piece of paper, for writing on."),
		list("WY Paper", 1, /obj/item/paper/wy, "white", "A fresh piece of WY-branded paper, for writing important things on."),
		list("Carbon Paper", 1, /obj/item/paper/carbon, "white", "A piece of carbon paper, to double the writing output."),
		list("Clipboard", 1, /obj/item/clipboard, "white", "A clipboard, for storing all that writing."),

		list("MISC", 0, null, null, null),
		list("Hollow Cane", 15, /obj/item/weapon/pole/fancy_cane/this_is_a_knife, "white", "A hollow cane that can store any commonplace sharp weaponry. Said weapon not included."),

		list("AMMO", 0, null, null, null),
		list("ES-4 stun magazine", 10, /obj/item/ammo_magazine/pistol/es4, "white", "Holds 19 rounds of specialized Conductive 9mm."),

		list("RADIO KEYS", 0, null, null, null),
		list("Alpha Squad", 15, /obj/item/device/encryptionkey/alpha, "white", "Radio Key for USCM Alpha Squad."),
		list("Bravo Squad", 15, /obj/item/device/encryptionkey/bravo, "white", "Radio Key for USCM Bravo Squad."),
		list("Charlie Squad", 15, /obj/item/device/encryptionkey/charlie, "white", "Radio Key for USCM Charlie Squad."),
		list("Delta Squad", 15, /obj/item/device/encryptionkey/delta, "white", "Radio Key for USCM Delta Squad."),
		list("Echo Squad", 15, /obj/item/device/encryptionkey/echo, "white", "Radio Key for USCM Echo Squad."),
		list("Colony", 20, /obj/item/device/encryptionkey/colony, "white", "Pre-tuned Radio Key for local colony comms."),
	)

	contraband_products = list(
		list("CONTRABAND", 0, null, null, null),
		list("W-Y PMC", 20, /obj/item/device/encryptionkey/pmc, "white", "Radio Key for Weyland-Yutani PMC Combat Comms."),
		list("CONTRABAND: Colonial Marshals", 40, /obj/item/device/encryptionkey/cmb, "white", "Radio Key for the CMB."),
		list("CONTRABAND: Colonial Liberation Front", 40, /obj/item/device/encryptionkey/clf, "white", "Radio Key for known local CLF frequencies."),
		list("CONTRABAND: Union of Progressive Peoples", 40, /obj/item/device/encryptionkey/upp, "white", "Radio Key for known UPP listening frequencies."),
	)
