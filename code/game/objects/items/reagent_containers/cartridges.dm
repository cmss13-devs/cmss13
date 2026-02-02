////////////////////////////////////////////////////////////////////////////////
/// Ordnance Cartridges.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_container/cartridge
	name = " "
	desc = " "
	icon = 'icons/obj/items/chemistry.dmi'

	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,40,50,60)
	volume = 60
	matter = list("plasteel" = 3750)
	flags_atom = FPRINT|OPENCONTAINER
	transparent = TRUE
	var/splashable = TRUE
	var/has_lid = TRUE
	var/base_name = " "

	var/list/obj/inherent_reagents = list()
	var/list/obj/required_reagents = list()
	var/list/obj/allowed_reagents = list()
	var/has_required_reagents = FALSE
	var/has_disallowed_reagents = FALSE

	var/list/can_be_placed_into = list(
		/obj/structure/machinery/chem_master/,
		/obj/structure/machinery/chem_dispenser/,
		/obj/structure/machinery/reagentgrinder,
		/obj/structure/surface/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/item/clothing,
		/obj/item/explosive,
		/obj/item/mortar_shell/custom,
		/obj/item/ammo_magazine/rocket/custom,
		/obj/item/storage/secure/safe,
		/obj/structure/machinery/disposal,
		/obj/structure/machinery/smartfridge/,
		/obj/structure/machinery/reagent_analyzer,
		/obj/structure/machinery/centrifuge,
		/obj/structure/machinery/autodispenser,
		/obj/structure/machinery/constructable_frame)

/obj/item/reagent_container/cartridge/Initialize()
	. = ..()
	base_name = name
	update_validity()
	update_icon()
	ADD_TRAIT(src, TRAIT_REACTS_UNSAFELY, TRAIT_SOURCE_INHERENT)

/obj/item/reagent_container/cartridge/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	if(!is_open_container())
		. += SPAN_INFO("An airtight lid seals it completely.")

/obj/item/reagent_container/cartridge/attack_self()
	..()
	if(!has_lid)
		return
	if(splashable)
		if(is_open_container())
			to_chat(usr, SPAN_NOTICE("You put the lid on [src]."))
			flags_atom ^= OPENCONTAINER
		else
			to_chat(usr, SPAN_NOTICE("You take the lid off [src]."))
			flags_atom |= OPENCONTAINER
		update_icon()

/obj/item/reagent_container/cartridge/afterattack(obj/target, mob/user , flag)
	if(!reagents)
		create_reagents(volume)

	if(!is_open_container_or_can_be_dispensed_into() || !flag)
		return

	for(var/type in src.can_be_placed_into)
		if(istype(target, type))
			return

	if(is_open_container() && ismob(target) && target.reagents && reagents.total_volume && user.a_intent == INTENT_HARM && splashable)
		to_chat(user, SPAN_NOTICE("You splash the solution onto [target]."))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)

		var/mob/living/M = target
		var/list/injected = list()
		for(var/datum/reagent/R in src.reagents.reagent_list)
			injected += R.name
		var/contained = english_list(injected)
		M.last_damage_data = create_cause_data(initial(name), user)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to splash [M.name] ([M.key]). Reagents: [contained]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		visible_message(SPAN_WARNING("[target] has been splashed with something by [user]!"))
		reagents.reaction(target, TOUCH)
		if(!QDELETED(src))
			reagents.clear_reagents()
		return
	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		var/obj/structure/reagent_dispensers/dispenser = target
		dispenser.add_fingerprint(user)
		if(dispenser.dispensing)
			if(!target.reagents.total_volume && target.reagents)
				to_chat(user, SPAN_WARNING("\The [target] is empty."))
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("\The [src] is full."))
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

			if(!trans)
				to_chat(user, SPAN_DANGER("You fail to remove reagents from [target]."))
				return

			to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
		else
			if(is_open_container_or_can_be_dispensed_into())
				if(reagents && !reagents.total_volume)
					to_chat(user, SPAN_WARNING("\The [src] is empty."))
					return

				if(dispenser.reagents.total_volume >= dispenser.reagents.maximum_volume)
					to_chat(user, SPAN_WARNING("\The [dispenser] is full."))
					return

				var/trans = reagents.trans_to(dispenser, dispenser:amount_per_transfer_from_this)

				if(!trans)
					to_chat(user, SPAN_DANGER("You fail to add reagents to [target]."))
					return

				to_chat(user, SPAN_NOTICE("You fill [dispenser] with [trans] units of the contents of [src]."))
			else
				to_chat(user, SPAN_WARNING("You must open the container first!"))

	else if(is_open_container() && target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [target] is full."))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to add reagents to [target]."))
			return

		to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to [target]."))

	else if(istype(target, /obj/structure/machinery/smartfridge))
		return

	else if(is_open_container() && (reagents.total_volume) && (user.a_intent == INTENT_HARM) && splashable)
		to_chat(user, SPAN_NOTICE("You splash the solution onto [target]."))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)
		reagents.reaction(target, TOUCH)
		if(!QDELETED(src))
			reagents.clear_reagents()
		return


/obj/item/reagent_container/cartridge/attackby(obj/item/attacking_object, mob/living/user)
	if(HAS_TRAIT(attacking_object, TRAIT_TOOL_PEN))
		var/prior_label_text
		var/datum/component/label/labelcomponent = GetComponent(/datum/component/label)
		if(labelcomponent && labelcomponent.has_label())
			prior_label_text = labelcomponent.label_name
		var/tmp_label = tgui_input_text(user, "Enter a label for [src] (or nothing to remove)", "Label", prior_label_text, MAX_NAME_LEN, ui_state=GLOB.not_incapacitated_state)
		if(isnull(tmp_label))
			return // Canceled
		if(!tmp_label)
			if(prior_label_text)
				log_admin("[key_name(usr)] has removed label from [src].")
				user.visible_message(SPAN_NOTICE("[user] removes label from [src]."),
									SPAN_NOTICE("You remove the label from [src]."))
				labelcomponent.clear_label()
			return
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("The label can be at most [MAX_NAME_LEN] characters long."))
			return
		if(prior_label_text == tmp_label)
			to_chat(user, SPAN_WARNING("The label already says \"[tmp_label]\"."))
			return
		user.visible_message(SPAN_NOTICE("[user] labels [src] as \"[tmp_label]\"."),
		SPAN_NOTICE("You label [src] as \"[tmp_label]\"."))
		AddComponent(/datum/component/label, tmp_label)
		playsound(src, "paper_writing", 15, TRUE)
		return

	if(istype(attacking_object, /obj/item/storage/pill_bottle)) //dumping a pill bottle's contents in a container
		var/obj/item/storage/pill_bottle/pbottle = attacking_object
		if(reagents)
			if(!is_open_container())
				to_chat(user, SPAN_WARNING("[src] has a lid on it. You can't dump pills into [src] with the lid in the way."))
				return
			if(reagents?.total_volume <= 0)
				to_chat(user, SPAN_WARNING("[src] needs to contain some liquid to dissolve the pills in."))
				return
			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("[src] is full. You cannot dissolve any more pills."))
				return
			if(length(pbottle.contents) <= 0)
				to_chat(user, SPAN_WARNING("You don't have any pills to dump from \the [pbottle.name]."))
				return
			user.visible_message(SPAN_NOTICE("[user] starts to empty \the [pbottle.name] into [src]..."),
			SPAN_NOTICE("You start to empty \the [pbottle.name] into [src]..."),
			SPAN_NOTICE("You hear the emptying of a pill bottle and pills dropping into liquid."), 2)

			var/waiting_time = (length(pbottle.contents)) * 0.125 SECONDS
			if(!do_after(user, waiting_time, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] stops trying to empty \the [pbottle.name] into [src]."),
				SPAN_WARNING("You get distracted and stop trying to empty \the [pbottle.name] into [src]."))
				return

			var/list/reagent_list_text = list()
			for(var/obj/item/reagent_container/pill/pill in pbottle.contents)
				var/temp_reagent_text = pill.get_reagent_list_text()
				if(temp_reagent_text in reagent_list_text)
					reagent_list_text[temp_reagent_text]++
				else
					reagent_list_text += temp_reagent_text

				var/amount = pill.reagents.total_volume + reagents.total_volume
				var/loss = amount - reagents.maximum_volume

				pill.reagents.trans_to(src, reagents.total_volume)
				pbottle.forced_item_removal(pill)
				if(amount > reagents.maximum_volume)
					user.visible_message(SPAN_WARNING("[user] overflows [src], spilling some of its contents."),
					SPAN_WARNING("[src] overflows and spills [loss]u of the last pill you dissolved."))
					break

			var/output_text
			for(var/reagent_text in reagent_list_text)
				output_text += "[output_text ? "," : ":" ] [reagent_list_text[reagent_text]+1] Pill[reagent_list_text[reagent_text] > 0 ? "s" : ""] of " + reagent_text
			user.visible_message(SPAN_NOTICE("[user] finishes emptying \the [pbottle.name] into [src]."), SPAN_NOTICE("You stop emptying \the [pbottle.name] into [src]."))
			log_interact(user, null, "[key_name(user)] dissolved the contents of \the [pbottle.name] containing [output_text] into [src].")
			return // No call parent AFTER loop is done. Prevents pill bottles from attempting to gather pills.

	return ..()

/obj/item/reagent_container/cartridge/proc/update_validity()
	if(!reagents)
		has_required_reagents = FALSE
		has_disallowed_reagents = FALSE
		return

	has_disallowed_reagents = FALSE
	if(length(allowed_reagents))
		for(var/datum/reagent/R in reagents.reagent_list)
			if(!(R.id in allowed_reagents))
				has_disallowed_reagents = TRUE
				break

	has_required_reagents = TRUE
	if(length(required_reagents))
		for(var/req_id in required_reagents)
			var/needed_amount = required_reagents[req_id]
			if(!reagents.has_reagent(req_id, needed_amount))
				has_required_reagents = FALSE
				break

/obj/item/reagent_container/cartridge/on_reagent_change()
	update_validity()
	update_icon()

/obj/item/reagent_container/cartridge/pickup(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_container/cartridge/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/cartridge/attack_hand()
	..()
	update_validity()
	update_icon()

/obj/item/reagent_container/cartridge/smoke
	name = "smoke ordnance cartridge"
	desc = "A special cartridge for explosive casings. This one creates chemical smoke. Requires to be filled with sugar. Can hold up to 60 units."
	icon_state = "cartridge_smoke"
	item_state = "cartridge_smoke"
	inherent_reagents = list("phosphorus" = 60, "potassium" = 60)
	required_reagents = list("sugar" = 60)
	allowed_reagents = list("sugar")

/obj/item/reagent_container/cartridge/smoke/update_icon()
	overlays.Cut()

	if(has_required_reagents && !has_disallowed_reagents)
		overlays += image('icons/obj/items/chemistry.dmi', src, "cartridge_valid")

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "cartridge-1")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 11)
				filling.icon_state = "cartridge-1"
			if(12 to 22)
				filling.icon_state = "cartridge-2"
			if(23 to 43)
				filling.icon_state = "cartridge-3"
			if(44 to INFINITY)
				filling.icon_state = "cartridge-4"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "[initial(icon_state)]_lid")
		overlays += lid

/obj/item/reagent_container/cartridge/flash
	name = "flash ordnance cartridge"
	desc = "A special cartridge for explosive casings. This one creates a flash of light. Requires to be filled with aluminium. Can hold up to 60 units."
	icon_state = "cartridge_flash"
	item_state = "cartridge_flash"
	inherent_reagents = list("sulfur" = 60, "potassium" = 60)
	required_reagents = list("aluminum" = 60)
	allowed_reagents = list("aluminum")

/obj/item/reagent_container/cartridge/flash/update_icon()
	overlays.Cut()

	if(has_required_reagents && !has_disallowed_reagents)
		overlays += image('icons/obj/items/chemistry.dmi', src, "cartridge_valid")

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "cartridge-1")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 11)
				filling.icon_state = "cartridge-1"
			if(12 to 22)
				filling.icon_state = "cartridge-2"
			if(23 to 43)
				filling.icon_state = "cartridge-3"
			if(44 to INFINITY)
				filling.icon_state = "cartridge-4"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "[initial(icon_state)]_lid")
		overlays += lid

/obj/item/reagent_container/cartridge/shrapnel
	name = "shrapnel ordnance cartridge"
	desc = "A special cartridge for explosive casings. This one is filled with shrapnel by default. Additives can be added to modify the shrapnel. Can hold up to 10 units."
	icon_state = "cartridge_shrapnel"
	item_state = "cartridge_shrapnel"
	matter = list("metal" = 3750, "plasteel" = 3750)
	volume = 10
	inherent_reagents = list("iron" = 64, "anfo" = 1) // we add a tiny bit of ANFO, else shrapnel wouldn't spawn (kind of a silly fix)
	allowed_reagents = list("phoron", "pacid", "neurotoxinplasma")

/obj/item/reagent_container/cartridge/shrapnel/update_icon()
	overlays.Cut()

	if(has_required_reagents && !has_disallowed_reagents)
		overlays += image('icons/obj/items/chemistry.dmi', src, "cartridge_valid")

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]-1")

		var/percent = floor((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 5)
				filling.icon_state = "[icon_state]-1"
			if(5 to INFINITY)
				filling.icon_state = "[icon_state]-2"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "[initial(icon_state)]_lid")
		overlays += lid
