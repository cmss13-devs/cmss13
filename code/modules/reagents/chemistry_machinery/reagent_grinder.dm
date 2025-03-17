/obj/structure/machinery/reagentgrinder
	name = "All-In-One Grinder"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "juicer1"
	layer = ABOVE_TABLE_LAYER
	density = FALSE
	anchored = FALSE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/grind_duration = 6 SECONDS // 6 seconds
	var/obj/item/reagent_container/beaker = null
	var/limit = 10
	var/tether_range = 8
	var/obj/structure/machinery/smartfridge/chemistry/linked_storage //Where we send bottle chemicals
	var/list/blend_items = list (

		//Sheets
		/obj/item/stack/sheet/mineral/phoron = list("phoron" = 20),
		/obj/item/stack/sheet/mineral/uranium = list("uranium" = 20),
		/obj/item/stack/sheet/mineral/silver = list("silver" = 20),
		/obj/item/stack/sheet/mineral/gold = list("gold" = 20),

		//Blender Stuff
		/obj/item/reagent_container/food/snacks/grown/soybeans = list("soymilk" = 0),
		/obj/item/reagent_container/food/snacks/grown/tomato = list("ketchup" = 0),
		/obj/item/reagent_container/food/snacks/grown/corn = list("cornoil" = 0),
		/obj/item/reagent_container/food/snacks/grown/wheat = list("flour" = -5),
		/obj/item/reagent_container/food/snacks/grown/ricestalk = list("rice" = -5),
		/obj/item/reagent_container/food/snacks/grown/cherries = list("cherryjelly" = 0),
		/obj/item/reagent_container/food/snacks/grown/plastellium = list("plasticide" = 5),


		//All types that you can put into the grinder to transfer the reagents to the beaker. !Put all recipes above this.!
		/obj/item/reagent_container/pill = list(),
		/obj/item/reagent_container/food = list(),
		/obj/item/clothing/mask/cigarette = list()
	)

	var/list/juice_items = list (

		//Juicer Stuff
		/obj/item/reagent_container/food/snacks/grown/tomato = list("tomatojuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/carrot = list("carrotjuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/berries = list("berryjuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/soybeans = list("soymilk" = 0),
		/obj/item/reagent_container/food/snacks/grown/banana = list("banana" = 0),
		/obj/item/reagent_container/food/snacks/grown/potato = list("potato" = 0),
		/obj/item/reagent_container/food/snacks/grown/lemon = list("lemonjuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/orange = list("orangejuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/lime = list("limejuice" = 0),
		/obj/item/reagent_container/food/snacks/watermelonslice = list("watermelonjuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/grapes = list("grapejuice" = 0),
		/obj/item/reagent_container/food/snacks/grown/poisonberries = list("poisonberryjuice" = 0),

	)


	var/list/holdingitems = list()

/obj/structure/machinery/reagentgrinder/Initialize()
	. = ..()
	beaker = new /obj/item/reagent_container/glass/beaker/large(src)
	connect_smartfridge()
	return

/obj/structure/machinery/reagentgrinder/Destroy()
	cleanup()

	QDEL_NULL(beaker)

	return ..()

/obj/structure/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return


/obj/structure/machinery/reagentgrinder/attackby(obj/item/O, mob/living/user)
	if(istype(O,/obj/item/reagent_container/glass) || istype(O,/obj/item/reagent_container/food/drinks/drinkingglass) || istype(O,/obj/item/reagent_container/food/drinks/shaker))
		var/obj/item/old_beaker = beaker
		beaker = O
		user.drop_inv_item_to_loc(O, src)
		if(old_beaker)
			to_chat(user, SPAN_NOTICE("You swap out \the [old_beaker] for \the [O]."))
			user.put_in_hands(old_beaker)
		update_icon()
		updateUsrDialog()
		return FALSE

	if(LAZYLEN(holdingitems) >= limit)
		to_chat(user, SPAN_WARNING("The machine cannot hold anymore items."))
		return TRUE
	if (istype(O, /obj/item/research_upgrades/grinderspeed))
		if(limit == 10)
			grind_duration = 3 SECONDS
			limit = 25
			to_chat(user, SPAN_NOTICE("You insert [O] into [src]"))
			qdel(O)
			return TRUE
		else
			to_chat(user, SPAN_WARNING("[src] already contains [O], and already has extended capacity and speed."))
			return TRUE
	if(istype(O,/obj/item/storage))
		var/obj/item/storage/B = O
		if(length(B.contents) > 0)
			to_chat(user, SPAN_NOTICE("You start dumping the contents of [B] into [src]."))
			if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				return
			for(var/obj/item/I in B)
				if(LAZYLEN(holdingitems) >= limit)
					to_chat(user, SPAN_WARNING("The machine cannot hold anymore items."))
					break
				else
					if(!is_type_in_list(I, blend_items) && !is_type_in_list(I, juice_items))
						to_chat(user, SPAN_WARNING("Cannot refine [I] into a reagent."))
						break
					else
						user.drop_inv_item_to_loc(I, src)
						holdingitems += I
			playsound(user.loc, "rustle", 15, 1, 6)
			return FALSE

		else
			to_chat(user, SPAN_WARNING("[B] is empty."))
			return TRUE

	else if(!is_type_in_list(O, blend_items) && !is_type_in_list(O, juice_items))
		to_chat(user, SPAN_WARNING("Cannot refine into a reagent."))
		return TRUE
	user.drop_inv_item_to_loc(O, src)
	holdingitems += O
	updateUsrDialog()
	return FALSE

/obj/structure/machinery/reagentgrinder/attack_hand(mob/living/user)
	user.set_interaction(src)
	interact(user)

/obj/structure/machinery/reagentgrinder/interact(mob/living/user) // what is tgui even
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""
	var/list/processing_names = list()

	if(!inuse)
		for(var/obj/item/holding_item in holdingitems)
			processing_names[holding_item.name] += 1
		for(var/obj/item/item_key as anything in processing_names)
			processing_chamber += "\A [item_key] x[processing_names[item_key]]<BR>"

		if(!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if(!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name] <A href='byond://?src=\ref[src];bottle=[R.id]'>Bottle</a><A href='byond://?src=\ref[src];dispose=[R.id]'>Dispose</a><br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
		<b>Processing chamber contains:</b><br>
		[processing_chamber]<br>
		[beaker_contents]<hr>
		"}
		if(is_beaker_ready && !is_chamber_empty && !(inoperable()))
			dat += "<A href='byond://?src=\ref[src];action=grind'>Grind the reagents</a><BR>"
			dat += "<A href='byond://?src=\ref[src];action=juice'>Juice the reagents</a><BR><BR>"
		if(LAZYLEN(holdingitems) > 0)
			dat += "<A href='byond://?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if(beaker)
			dat += "<A href='byond://?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
		if(!linked_storage && tether_range > 0)
			dat += "<A href='byond://?src=\ref[src];action=connect'>Connect to smartfridge</a><BR>"
	else
		dat += "Please wait..."
	show_browser(user, "<HEAD><TITLE>[name]</TITLE></HEAD><TT>[dat]</TT>", name, "reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/structure/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	var/mob/living/carbon/human/user = usr
	if(!in_range(src, user))
		return
	user.set_interaction(src)
	if(href_list["bottle"])
		var/id = href_list["bottle"]
		if(QDELETED(linked_storage) || src.z != linked_storage.z || get_dist(src, linked_storage) > tether_range)
			visible_message(SPAN_WARNING("Smartfridge is out of range. Connection severed."))
			cleanup()
			return

		var/obj/item/reagent_container/glass/bottle/P = new /obj/item/reagent_container/glass/bottle()
		P.icon_state = "bottle-1" // Default bottle
		beaker.reagents.trans_id_to(P, id, P.reagents.maximum_volume)
		P.name = "[P.reagents.get_master_reagent_name()] bottle"
		linked_storage.add_local_item(P)
	else if(href_list["dispose"])
		var/id = href_list["dispose"]
		beaker.reagents.del_reagent(id)
	else
		switch(href_list["action"])
			if("grind")
				grind(user)
			if("juice")
				juice(user)
			if("eject")
				eject(user)
			if("detach")
				detach(user)
			if("connect")
				connect_smartfridge()
	updateUsrDialog()
	return

/obj/structure/machinery/reagentgrinder/proc/detach(mob/user)
	if(user.is_mob_incapacitated())
		return
	if(!beaker)
		return
	user.put_in_hands(beaker)
	beaker = null
	update_icon()

/obj/structure/machinery/reagentgrinder/proc/eject(mob/user)
	if(user.is_mob_incapacitated())
		return
	if(!length(holdingitems))
		return

	for(var/obj/item/O in holdingitems)
		O.forceMove(loc)
		holdingitems -= O
	holdingitems = list()

/obj/structure/machinery/reagentgrinder/proc/connect_smartfridge()
	if(linked_storage || tether_range <= 0)
		return
	linked_storage = locate(/obj/structure/machinery/smartfridge/chemistry) in range(tether_range, src)
	if(linked_storage)
		RegisterSignal(linked_storage, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))
		visible_message(SPAN_NOTICE("<b>The [src] beeps:</b> Smartfridge connected."))

/obj/structure/machinery/reagentgrinder/proc/is_allowed(obj/item/reagent_container/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return 1
	return 0

/obj/structure/machinery/reagentgrinder/proc/get_allowed_by_id(obj/item/grown/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return blend_items[i]

/obj/structure/machinery/reagentgrinder/proc/get_allowed_snack_by_id(obj/item/reagent_container/food/snacks/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return blend_items[i]

/obj/structure/machinery/reagentgrinder/proc/get_allowed_juice_by_id(obj/item/reagent_container/food/snacks/O)
	for(var/i in juice_items)
		if(istype(O, i))
			return juice_items[i]

/obj/structure/machinery/reagentgrinder/proc/get_grownweapon_amount(obj/item/grown/O)
	if(!istype(O))
		return 5
	else if(O.potency == -1)
		return 5
	else
		return floor(O.potency)

/obj/structure/machinery/reagentgrinder/proc/get_juice_amount(obj/item/reagent_container/food/snacks/grown/O)
	if(!istype(O))
		return 5
	else if(O.potency == -1)
		return 5
	else
		return floor(5*sqrt(O.potency))

/obj/structure/machinery/reagentgrinder/proc/remove_object(obj/item/O)
	holdingitems -= O
	qdel(O)

/obj/structure/machinery/reagentgrinder/proc/juice(mob/user)
	power_change()
	if(inoperable())
		return
	if(!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src.loc, 'sound/machines/juicer.ogg', 25, 1)
	inuse = 1
	addtimer(CALLBACK(src, PROC_REF(end_using), user), grind_duration)
	animate(src, transform = matrix(rand(1,-1), rand(-0.5,0.5), MATRIX_TRANSLATE), time = 0.5, easing = EASE_IN)
	for(var/i in 0 to 30)
		animate(transform = matrix(rand(-0.5,0.5), rand(1,-1), MATRIX_TRANSLATE), time = 1)
	animate(transform = matrix(0, 0, MATRIX_TRANSLATE), time = 0.5, easing = EASE_OUT)
	//Snacks
	for(var/obj/item/reagent_container/food/snacks/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

		var/allowed = get_allowed_juice_by_id(O)
		if(isnull(allowed))
			break

		for(var/r_id in allowed)

			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = get_juice_amount(O)

			beaker.reagents.add_reagent(r_id, min(amount, space))

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

		remove_object(O)

/obj/structure/machinery/reagentgrinder/proc/grind(mob/user)

	power_change()
	if(inoperable())
		return
	if(!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
	inuse = 1
	addtimer(CALLBACK(src, PROC_REF(end_using), user), grind_duration)
	animate(src, transform = matrix(rand(-0.5,0.5), rand(-0.5,0.5), MATRIX_TRANSLATE), time = 0.5, easing = EASE_IN)
	for(var/i in 0 to grind_duration)
		animate(transform = matrix(rand(-0.4,0.4), rand(-0.4,0.4), MATRIX_TRANSLATE), time = 1)
	animate(transform = matrix(0, 0, MATRIX_TRANSLATE), time = 0.5, easing = EASE_OUT, )
	//Snacks and Plants
	for(var/obj/item/reagent_container/food/snacks/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

		var/allowed = get_allowed_snack_by_id(O)
		if(isnull(allowed))
			break

		for(var/r_id in allowed)

			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if(amount <= 0)
				if(amount == 0)
					if(O.reagents != null && O.reagents.has_reagent("nutriment"))
						beaker.reagents.add_reagent(r_id, min(O.reagents.get_reagent_amount("nutriment"), space))
						O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))
				else
					if(O.reagents != null && O.reagents.has_reagent("nutriment"))
						beaker.reagents.add_reagent(r_id, min(floor(O.reagents.get_reagent_amount("nutriment")*abs(amount)), space))
						O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))

			else
				O.reagents.trans_id_to(beaker, r_id, min(amount, space))

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

		if(length(O.reagents.reagent_list) == 0)
			remove_object(O)

	//Sheets
	for(var/obj/item/stack/sheet/O in holdingitems)
		var/allowed = get_allowed_by_id(O)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		while(round(O.amount, 1)) // Technically possible to get a full quantity from a half bar, but shouldn't happen here
			for(var/r_id in allowed)
				var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
				var/amount = allowed[r_id]
				beaker.reagents.add_reagent(r_id,min(amount, space))
				if(space < amount)
					break
			O.amount--
			if(O.amount <= 0)
				remove_object(O)
				break
			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
	//Plants
	for(var/obj/item/grown/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/allowed = get_allowed_by_id(O)
		for(var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if(amount == 0)
				if(O.reagents != null && O.reagents.has_reagent(r_id))
					beaker.reagents.add_reagent(r_id,min(O.reagents.get_reagent_amount(r_id), space))
			else
				beaker.reagents.add_reagent(r_id,min(amount, space))

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
		remove_object(O)

	//Cigarettes
	for(var/obj/item/clothing/mask/cigarette/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/amount = O.reagents.total_volume
		O.reagents.trans_to(beaker, amount)
		if(!O.reagents.total_volume)
			remove_object(O)

	//Everything else - Transfers reagents from it into beaker
	for(var/obj/item/reagent_container/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/amount = O.reagents.total_volume
		O.reagents.trans_to(beaker, amount)
		if(!O.reagents.total_volume)
			remove_object(O)

/obj/structure/machinery/reagentgrinder/proc/cleanup()
	SIGNAL_HANDLER
	if(linked_storage)
		linked_storage = null

/obj/structure/machinery/reagentgrinder/proc/end_using(mob/user)
	inuse = 0
	interact(user)

/obj/structure/machinery/reagentgrinder/industrial
	name = "Industrial Grinder"
	desc = "a heavy-duty variant of the all-in-one grinder meant for grinding large amounts of industrial material. Not food safe."
	icon_state = "industry1"
	limit = 30
	blend_items = list (

		//Sheets
		/obj/item/stack/sheet/mineral/phoron = list("phoron" = 20),
		/obj/item/stack/sheet/mineral/uranium = list("uranium" = 20),
		/obj/item/stack/sheet/mineral/iron = list("iron" = 60),
		/obj/item/stack/sheet/mineral/silver = list("silver" = 60),
		/obj/item/stack/sheet/mineral/gold = list("gold" = 60),
		/obj/item/stack/sheet/metal = list("iron" = 60),
		/obj/item/stack/sheet/aluminum = list("aluminum" = 60),
		/obj/item/stack/sheet/copper = list("copper" = 60),

		//Special Stuff
		/obj/item/reagent_container/hypospray/autoinjector/yautja = list("thwei" = 30),

		//Blender Stuff
		/obj/item/reagent_container/food/snacks/grown/corn = list("cornoil" = 0)
	)
	tether_range = 0
	juice_items = list ()

/obj/structure/machinery/reagentgrinder/industrial/Initialize()
	. = ..()
	beaker = new /obj/item/reagent_container/glass/bucket(src)
	return

/obj/structure/machinery/reagentgrinder/industrial/update_icon()
	icon_state = "industry"+num2text(!isnull(beaker))
	return
