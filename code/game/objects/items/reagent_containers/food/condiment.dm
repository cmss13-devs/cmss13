///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
// leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
// to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/reagent_container/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/items/food/condiments.dmi'
	icon_state = "emptycondiment"
	flags_atom = FPRINT|OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = "x=16;y=6"
	volume = 50

/obj/item/reagent_container/food/condiment/attack(mob/M, mob/user)
	if(!reagents?.total_volume)
		to_chat(user, SPAN_DANGER("The [src.name] is empty!"))
		return FALSE

	if(M == user)
		to_chat(M, SPAN_NOTICE("You swallow some of contents of [src]."))

	else if(istype(M, /mob/living/carbon/human))
		user.affected_message(M,
			SPAN_HELPFUL("You <b>start feeding</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] starts feeding [user == M ? "themselves" : "[M]"] [src]."))

		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M))
			return FALSE
		user.affected_message(M,
			SPAN_HELPFUL("You <b>fed</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
			SPAN_HELPFUL("[user] <b>fed</b> you <b>[src]</b>."),
			SPAN_NOTICE("[user] fed [user == M ? "themselves" : "[M]"] [src]."))

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)
	else
		return FALSE

	if(reagents.total_volume)
		reagents.set_source_mob(user)
		reagents.trans_to_ingest(M, 10)
	playsound(M.loc,'sound/items/drink.ogg', 15, 1)
	return TRUE

/obj/item/reagent_container/food/condiment/attackby(obj/item/W, mob/living/user, list/mods)
	return

/obj/item/reagent_container/food/condiment/afterattack(obj/target, mob/user , flag)
	if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to fill [src] with reagents from [target]."))
			return

		to_chat(user, SPAN_NOTICE(" You fill [src] with [trans] units of the contents of [target]."))

	//Something like a glass or a food item. Player probably wants to transfer TO it.
	else if(target.is_open_container() || istype(target, /obj/item/reagent_container/food/snacks))
		if(!reagents.total_volume)
			to_chat(user, SPAN_DANGER("[src] is empty."))
			return
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_DANGER("You can't add any more to [target]."))
			return
		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE(" You transfer [trans] units of the condiment to [target]."))

/obj/item/reagent_container/food/condiment/on_reagent_change()
	if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall" || icon_state == "hotsauce_cholula" || icon_state == "hotsauce_franks" || icon_state == "hotsauce_sriracha" || icon_state == "hotsauce_tabasco" || icon_state == "coldsauce_cole")
		return
	if(length(reagents.reagent_list) > 0)
		switch(reagents.get_master_reagent_id())
			if("ketchup")
				name = "Ketchup"
				desc = "You feel more American already."
				icon_state = "ketchup"
				center_of_mass = "x=16;y=6"
			if("enzyme")
				name = "Universal Enzyme"
				desc = "Used in cooking various dishes."
				icon_state = "enzyme"
				center_of_mass = "x=16;y=6"
			if("soysauce")
				name = "Soy Sauce"
				desc = "A salty soy-based flavoring."
				icon_state = "soysauce"
				center_of_mass = "x=16;y=6"
			if("frostoil")
				name = "Coldsauce"
				desc = "Leaves the tongue numb in its passage."
				icon_state = "coldsauce"
				center_of_mass = "x=16;y=6"
			if("sodiumchloride")
				name = "Salt Shaker"
				desc = "Salt. From space oceans, presumably."
				icon_state = "saltshaker"
				center_of_mass = "x=16;y=10"
			if("blackpepper")
				name = "Pepper Mill"
				desc = "Often used to flavor food or make people sneeze."
				icon_state = "peppermill"
				center_of_mass = "x=16;y=10"
			if("cornoil")
				name = "Corn Oil"
				desc = "A delicious oil used in cooking. Made from corn."
				icon_state = "oliveoil"
				center_of_mass = "x=16;y=6"
			if("sugar")
				name = "Sugar"
				desc = "Tasty space sugar!"
				center_of_mass = "x=16;y=6"
			else
				name = "Misc Condiment Bottle"
				if (length(reagents.reagent_list)==1)
					desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
				else
					desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
				icon_state = "mixedcondiments"
				center_of_mass = "x=16;y=6"
	else
		icon_state = "emptycondiment"
		name = "Condiment Bottle"
		desc = "An empty condiment bottle."
		center_of_mass = "x=16;y=6"
		return

/obj/item/reagent_container/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/reagent_container/food/condiment/enzyme/Initialize()
	. = ..()
	reagents.add_reagent("enzyme", 50)

/obj/item/reagent_container/food/condiment/sugar

/obj/item/reagent_container/food/condiment/sugar/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 50)

/obj/item/reagent_container/food/condiment/saltshaker //Separate from above since it's a small shaker rather then
	name = "Salt Shaker" // a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_container/food/condiment/saltshaker/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 20)

/obj/item/reagent_container/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/reagent_container/food/condiment/peppermill/Initialize()
	. = ..()
	reagents.add_reagent("blackpepper", 20)

/obj/item/reagent_container/food/condiment/hotsauce
	icon = 'icons/obj/items/food/condiments.dmi'
	name = "hotsauce parent object"
	possible_transfer_amounts = list(1,5,60) //60 allows marines to chug the bottle in one go.
	volume = 60

/obj/item/reagent_container/food/condiment/hotsauce/Initialize()
	. = ..()
	reagents.add_reagent("hotsauce", 60)

/obj/item/reagent_container/food/condiment/hotsauce/cholula
	name = "\improper Cholula bottle"
	desc = "A bottle of Weyland-Yutani brand Cholula hot sauce."
	icon_state = "hotsauce_cholula"
	item_state = "hotsauce_cholula"

/obj/item/reagent_container/food/condiment/hotsauce/franks
	name = "\improper Frank's Red Hot bottle"
	desc = "A bottle of Weyland-Yutani brand Frank's Red Hot hot sauce."
	desc_lore = "Supposedly designed as a middle-ground flavor between ketchup and cayenne, this brand of spicy goodness achieved critical acclaim throughout UA space within both colonies and vessels alike. The sudden and widespread adoption was curiously timed with the near-simultaneous shelving of the original Frank's 'ULTRA' hot sauce."
	icon_state = "hotsauce_franks"
	item_state = "hotsauce_franks"

/obj/item/reagent_container/food/condiment/hotsauce/sriracha
	name = "\improper Sriracha bottle"
	desc = "A bottle of Weyland-Yutani brand Sriracha hot sauce."
	icon_state = "hotsauce_sriracha"
	item_state = "hotsauce_sriracha"

/obj/item/reagent_container/food/condiment/hotsauce/tabasco
	name = "\improper Tabasco bottle"
	desc = "A bottle of Weyland-Yutani brand Tabasco hot sauce."
	icon_state = "hotsauce_tabasco"
	item_state = "hotsauce_tabasco"

/obj/item/reagent_container/food/condiment/hotsauce/franks/macho
	name = "\improper Frank's ULTRA Hot bottle"
	desc = "A bottle of Weyland-Yutani brand Frank's ULTRA Hot sauce, taken off the market after reports of what was described as 'something closer to ignition than digestion' happening to those who drink it."
	icon_state = "hotsauce_franks"
	item_state = "hotsauce_franks"

/obj/item/reagent_container/food/condiment/hotsauce/franks/macho/Initialize()
	. = ..()
	reagents.add_reagent("machosauce", 60)

/obj/item/reagent_container/food/condiment/coldsauce
	name = "Cole's Cold bottle"
	desc = "A bottle of cold sauce locally produced in Shivas Snowball. You probably shouldn't drink this on its own."
	icon_state = "coldsauce_cole"

/obj/item/reagent_container/food/condiment/coldsauce/Initialize()
	. = ..()
	reagents.add_reagent("frostoil", 60)
