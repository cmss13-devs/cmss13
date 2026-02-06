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
	var/limit = 16
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
		/obj/item/reagent_container/food/snacks/chocolatebar = list("chocolatesyrup" = 0),

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
	start_processing()
	return

/obj/structure/machinery/reagentgrinder/process()
	if(linked_storage)
		if(QDELETED(linked_storage) || src.z != linked_storage.z || get_dist(src, linked_storage) > tether_range)
			visible_message(SPAN_WARNING("<b>The [src] beeps:</b> Smartfridge connection lost."))
			cleanup()
			SStgui.update_uis(src)

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
		SStgui.update_uis(src)
		return FALSE

	if(LAZYLEN(holdingitems) >= limit)
		to_chat(user, SPAN_WARNING("The machine cannot hold anymore items."))
		return TRUE
	if (istype(O, /obj/item/research_upgrades/grinderspeed))
		if(limit == 16)
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
	SStgui.update_uis(src)
	return FALSE

/obj/structure/machinery/reagentgrinder/attack_hand(mob/living/user)
	tgui_interact(user)

/obj/structure/machinery/reagentgrinder/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ReagentGrinder", name)
		ui.open()

/obj/structure/machinery/reagentgrinder/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/reagentgrinder/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!in_range(src, user))
		return UI_CLOSE
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/reagentgrinder/ui_data(mob/user)
	. = list()
	.["inuse"] = inuse
	.["isBeakerLoaded"] = beaker ? TRUE : FALSE
	.["hasStorage"] = linked_storage ? TRUE : FALSE
	.["canConnect"] = (!linked_storage && tether_range > 0) ? TRUE : FALSE

	var/list/chamberContents = list()
	var/list/processing_names = list()
	for(var/obj/item/holding_item in holdingitems)
		processing_names[holding_item.name] += 1
	for(var/obj/item/item_key as anything in processing_names)
		chamberContents += list(list("name" = item_key, "amount" = processing_names[item_key]))
	.["chamberContents"] = chamberContents

	var/list/beakerContents = list()
	if(beaker && beaker.reagents && length(beaker.reagents.reagent_list))
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = R.name, "volume" = R.volume, "id" = R.id))
	.["beakerContents"] = beakerContents


/obj/structure/machinery/reagentgrinder/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/user = usr

	switch(action)
		if("grind")
			grind(user)
			. = TRUE
		if("juice")
			juice(user)
			. = TRUE
		if("eject")
			eject(user)
			. = TRUE
		if("detach")
			detach(user)
			. = TRUE
		if("connect")
			connect_smartfridge()
			. = TRUE
		if("bottle")
			var/id = params["id"]
			if(QDELETED(linked_storage) || src.z != linked_storage.z || get_dist(src, linked_storage) > tether_range)
				visible_message(SPAN_WARNING("Smartfridge is out of range. Connection severed."))
				cleanup()
				return
			if(!beaker)
				return
			var/obj/item/reagent_container/glass/bottle/P = new /obj/item/reagent_container/glass/bottle()
			P.icon_state = "bottle-1"
			beaker.reagents.trans_id_to(P, id, P.reagents.maximum_volume)
			P.name = "[P.reagents.get_master_reagent_name()] bottle"
			linked_storage.add_local_item(P)
			. = TRUE
		if("dispose")
			var/id = params["id"]
			if(!beaker)
				return
			beaker.reagents.del_reagent(id)
			. = TRUE

/obj/structure/machinery/reagentgrinder/proc/detach(mob/user)
	if(user.is_mob_incapacitated())
		return
	if(!beaker)
		return
	user.put_in_hands(beaker)
	beaker = null
	update_icon()
	SStgui.update_uis(src)

/obj/structure/machinery/reagentgrinder/proc/eject(mob/user)
	if(user.is_mob_incapacitated())
		return
	if(!length(holdingitems))
		return

	for(var/obj/item/O in holdingitems)
		O.forceMove(loc)
		holdingitems -= O
	holdingitems = list()
	SStgui.update_uis(src)

/obj/structure/machinery/reagentgrinder/proc/connect_smartfridge()
	if(linked_storage || tether_range <= 0)
		return
	linked_storage = locate(/obj/structure/machinery/smartfridge/chemistry) in range(tether_range, src)
	if(linked_storage)
		RegisterSignal(linked_storage, COMSIG_PARENT_QDELETING, PROC_REF(cleanup), override = TRUE)
		visible_message(SPAN_NOTICE("<b>The [src] beeps:</b> Smartfridge connected."))
	else
		visible_message(SPAN_WARNING("<b>The [src] beeps:</b> No smartfridge detected in range."))

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
			continue

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
			continue

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
	SStgui.update_uis(src)

/obj/structure/machinery/reagentgrinder/industrial
	name = "Industrial Grinder"
	desc = "A heavy-duty variant of the all-in-one grinder meant for grinding large amounts of industrial material. Not food safe."
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
