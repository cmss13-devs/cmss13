/obj/structure/machinery/chem_master
	name = "ChemMaster 3000"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "mixer0"
	var/base_state = "mixer"
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	layer = BELOW_OBJ_LAYER //So bottles/pills reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_DOCTOR
	var/pill_maker = TRUE
	var/vial_maker = FALSE
	var/obj/item/reagent_container/beaker = null
	var/list/loaded_pill_bottles = list()
	var/list/loaded_pill_bottles_to_fill = list()
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 16
	var/bottlesprite = "1" //yes, strings
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 20
	var/max_bottles_count = 8
	var/tether_range = 3
	var/obj/structure/machinery/smartfridge/chemistry/connected

/obj/structure/machinery/chem_master/Initialize()
	. = ..()
	create_reagents(500)
	connect_smartfridge()

/obj/structure/machinery/chem_master/Destroy()
	cleanup()
	. = ..()

/obj/structure/machinery/chem_master/proc/connect_smartfridge()
	if(connected)
		return
	connected = locate(/obj/structure/machinery/smartfridge/chemistry) in range(tether_range, src)
	if(connected)
		RegisterSignal(connected, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))
		visible_message(SPAN_NOTICE("<b>The [src] beeps:</b> Smartfridge connected."))

/obj/structure/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/chem_master/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker?"mixer1_b":"mixer0_b")
	else if(stat & NOPOWER)
		icon_state = (beaker?"[base_state]1_nopower":"[base_state]0_nopower")
	else
		icon_state = (beaker?"[base_state]1":"[base_state]0")


/obj/structure/machinery/chem_master/attackby(obj/item/inputed_item, mob/living/user)
	if(istype(inputed_item, /obj/item/reagent_container/glass))
		var/obj/item/old_beaker = beaker
		beaker = inputed_item
		user.drop_inv_item_to_loc(inputed_item, src)
		if(old_beaker)
			to_chat(user, SPAN_NOTICE("You swap out \the [old_beaker] for \the [inputed_item]."))
			user.put_in_hands(old_beaker)
		else
			to_chat(user, SPAN_NOTICE("You add the beaker to the machine!"))
		SStgui.update_uis(src)
		update_icon()

	else if(istype(inputed_item, /obj/item/storage/pill_bottle) && pill_maker)
		var/obj/item/storage/pill_bottle/bottle = inputed_item

		if(length(loaded_pill_bottles) >= max_bottles_count)
			to_chat(user, SPAN_WARNING("Machine is fully loaded by pill bottles."))
			return

		//making sure to have same bottles in the machine
		if (length(loaded_pill_bottles) > 0)
			var/obj/item/storage/pill_bottle/main_bottle = loaded_pill_bottles[1]
			var/datum/component/label/label_component_on_main_bottle = main_bottle.GetComponent(/datum/component/label)
			var/datum/component/label/label_component_on_inputed_bottle = bottle.GetComponent(/datum/component/label)

			if(label_component_on_main_bottle)
				bottle.AddComponent(/datum/component/label, label_component_on_main_bottle.label_name)
				if(length(main_bottle.maptext_label) < 3)
					bottle.maptext_label = main_bottle.maptext_label
					bottle.update_icon()
			else if(label_component_on_inputed_bottle)
				qdel(label_component_on_inputed_bottle)
			bottle.icon_state = main_bottle.icon_state

		loaded_pill_bottles += bottle
		loaded_pill_bottles_to_fill += bottle
		user.drop_inv_item_to_loc(bottle, src)
		to_chat(user, SPAN_NOTICE("You add the pill bottle into the dispenser slot!"))
		SStgui.update_uis(src)
	return

/obj/structure/machinery/chem_master/proc/transfer_chemicals(obj/dest, obj/source, amount, reagent_id)
	if(istype(source))
		if(amount > 0 && source.reagents && amount <= source.reagents.maximum_volume)
			if(!istype(dest))
				source.reagents.remove_reagent(reagent_id, amount)
			else if(dest.reagents)
				source.reagents.trans_id_to(dest, reagent_id, amount)

/obj/structure/machinery/chem_master/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemMaster", name)
		ui.open()

/obj/structure/machinery/chem_master/ui_data(mob/user)
	. = ..()

	.["is_connected"] = !!connected
	.["mode"] = mode
	.["pillsprite"] = pillsprite
	.["bottlesprite"] = bottlesprite

	.["pill_bottles"] = list()
	if(length(loaded_pill_bottles) > 0)
		for(var/obj/item/storage/pill_bottle/bottle in loaded_pill_bottles)
			var/datum/component/label/label = bottle.GetComponent(/datum/component/label)
			LAZYADD(.["pill_bottles"], list(list(
					"size" = length(bottle.contents),
					"max_size" = bottle.max_storage_space,
					"label" = label ? label.label_name : null,
					"icon_state" = bottle.icon_state,
					"isNeedsToBeFilled" = LAZYFIND(loaded_pill_bottles_to_fill, bottle) > 0
				)))

	.["beaker"] = null
	if(beaker)
		.["beaker"] = list(
			"reagents_volume" = beaker.reagents.total_volume
		)

		for(var/datum/reagent/contained_reagent in beaker.reagents.reagent_list)
			LAZYADD(.["beaker"]["reagents"], list(list(
				"name" = contained_reagent.name,
				"volume" = contained_reagent.volume,
				"id" = contained_reagent.id,
			)))

	.["buffer"] = null
	if(reagents.total_volume)
		.["buffer"] = list()
		for(var/datum/reagent/contained_reagent in reagents.reagent_list)
			.["buffer"] += list(list(
				"name" = contained_reagent.name,
				"volume" = contained_reagent.volume,
				"id" = contained_reagent.id
			))

	.["internal_reagent_name"] = reagents.get_master_reagent_name()

/obj/structure/machinery/chem_master/ui_static_data(mob/user)
	. = ..()

	.["pill_or_bottle_icon"] = "['icons/obj/items/chemistry.dmi']"
	.["pill_icon_choices"] = PILL_ICON_CHOICES
	.["bottle_icon_choices"] = BOTTLE_ICON_CHOICES

	.["color_pill"] = list(
		"icon" = "[/obj/item/storage/pill_bottle::icon]",
		"colors" = /obj/item/storage/pill_bottle::possible_colors,
		"base" = /obj/item/storage/pill_bottle::base_icon
	)

	.["is_pillmaker"] = pill_maker
	.["is_condiment"] = condi
	.["is_vialmaker"] = vial_maker

/obj/structure/machinery/chem_master/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	if(inoperable())
		return

	var/mob/user = ui.user

	if(!Adjacent(user) || !ishuman(user) || user.stat || user.is_mob_restrained())
		return

	switch(action)
		if("eject_pill")
			var/bottle_index = params["bottleIndex"] + 1;
			if(length(loaded_pill_bottles) == 0 || bottle_index > length(loaded_pill_bottles))
				return

			var/obj/item/storage/pill_bottle/bottle = loaded_pill_bottles[bottle_index]

			if (!bottle)
				return

			if(!user.put_in_hands(loaded_pill_bottles[bottle_index]))
				bottle.forceMove(loc)

			if(LAZYFIND(loaded_pill_bottles_to_fill, bottle) > 0)
				loaded_pill_bottles_to_fill -= bottle
			loaded_pill_bottles -= bottle

			if(length(loaded_pill_bottles) == 1)
				loaded_pill_bottles_to_fill = LAZYCOPY(loaded_pill_bottles)

			return TRUE

		if("label_pill")
			if(length(loaded_pill_bottles) == 0)
				return

			var/label = copytext(reject_bad_text(params["text"]), 1, MAX_NAME_LEN)
			if(!label)
				return

			for(var/obj/item/storage/pill_bottle/bottle in loaded_pill_bottles)
				bottle.AddComponent(/datum/component/label, label)
				if(length(label) < 3)
					bottle.maptext_label = label
					bottle.update_icon()

			return TRUE

		if("color_pill")
			if(length(loaded_pill_bottles) == 0)
				return

			var/picked_color = params["color"]

			for(var/obj/item/storage/pill_bottle/bottle in loaded_pill_bottles)
				if(picked_color && (picked_color in bottle.possible_colors))
					bottle.icon_state = bottle.base_icon + bottle.possible_colors[picked_color]

		if("add")
			var/amount = params["amount"]
			var/id = params["id"]
			if(!isnum(amount) || !id)
				return

			transfer_chemicals(src, beaker, amount, id)
			return TRUE

		if("add_all")
			for(var/datum/reagent/beaker_reagent in beaker.reagents.reagent_list)
				transfer_chemicals(src, beaker, beaker.volume, beaker_reagent.id)

			return TRUE

		if("remove")
			var/amount = params["amount"]
			var/id = params["id"]
			if(!isnum(amount) || !id)
				return

			if(mode)
				transfer_chemicals(beaker, src, amount, id)
				return TRUE

			transfer_chemicals(null, src, amount, id)
			return TRUE

		if("remove_all")
			for(var/datum/reagent/contained_reagent in reagents.reagent_list)
				var/amount = reagents.total_volume
				if(mode)
					transfer_chemicals(beaker, src, amount, contained_reagent.id)
				else
					transfer_chemicals(null, src, amount, contained_reagent.id)

			return TRUE

		if("toggle")
			mode = !mode
			return TRUE

		if("eject")
			if(!beaker)
				return

			if(!user.put_in_hands(beaker))
				beaker.forceMove(loc)

			beaker = null
			reagents.clear_reagents()
			update_icon()
			return TRUE

		if("create_pill")
			if(!pill_maker)
				return

			var/param_num = params["number"]
			if(!isnum(param_num))
				return

			var/to_create = floor(clamp(param_num, 1, max_pill_count))

			if(reagents.total_volume / to_create < 1)
				return

			var/list/reagents_in_pill = list()
			for(var/datum/reagent/contained_reagent in reagents.reagent_list)
				if(contained_reagent.flags & REAGENT_NOT_INGESTIBLE)
					to_chat(user, SPAN_WARNING("[contained_reagent.name] must be administered intravenously, and cannot be made into a pill."))
					return

				reagents_in_pill += contained_reagent.name

			if(length(loaded_pill_bottles_to_fill) == 0)
				return

			var/amount_per_pill = clamp((reagents.total_volume / to_create) / length(loaded_pill_bottles_to_fill), 0, 60)

			msg_admin_niche("[key_name(user)] created one or more pills (total pills to synthesize: [to_create]) (REAGENTS: [english_list(reagents_in_pill)]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			for(var/obj/item/storage/pill_bottle/bottle in loaded_pill_bottles_to_fill)
				for(var/iterator in 1 to to_create)
					var/obj/item/reagent_container/pill/creating_pill = new(loc)
					creating_pill.pill_desc = "A custom pill."
					creating_pill.icon_state = "pill[pillsprite]"

					reagents.trans_to(creating_pill, amount_per_pill)
					if(bottle && length(bottle.contents) < bottle.max_storage_space)
						bottle.handle_item_insertion(creating_pill, TRUE)

			return TRUE

		if("create_glass")
			if(condi)
				var/obj/item/reagent_container/food/condiment/new_condiment = new()
				reagents.trans_to(new_condiment, 50)

				if(!user.put_in_hands(new_condiment))
					new_condiment.forceMove(loc)

				return TRUE

			var/name = reject_bad_text(params["label"] || reagents.get_master_reagent_name())
			if(!name)
				return

			var/obj/item/reagent_container/glass/new_container
			switch(params["type"])
				if("glass")
					new_container = new /obj/item/reagent_container/glass/bottle()
					new_container.name = "[name] bottle"
					new_container.icon_state = "bottle-[bottlesprite]"
					reagents.trans_to(new_container, 60)
				if("vial")
					if(!vial_maker)
						return

					new_container = new /obj/item/reagent_container/glass/beaker/vial()
					new_container.name = "[name] Vial"
					reagents.trans_to(new_container, 30)

			if(!new_container)
				return

			new_container.update_icon()

			if(params["store"] && connected)
				connected.add_local_item(new_container)
				return TRUE

			if(!user.put_in_hands(new_container))
				new_container.forceMove(loc)

			return TRUE

		if("change_pill")
			var/pill = params["picked"]
			if(!isnum(pill) || pill > PILL_ICON_CHOICES)
				return

			pillsprite = pill
			return TRUE

		if("change_bottle")
			var/bottle = params["picked"]
			if(!isnum(bottle) || bottle > BOTTLE_ICON_CHOICES)
				return

			bottlesprite = bottle
			return TRUE


		if("transfer_pill")
			var/bottle_index = params["bottleIndex"] + 1;

			if(length(loaded_pill_bottles) == 0 || bottle_index > length(loaded_pill_bottles))
				return

			if(QDELETED(connected))
				to_chat(user, SPAN_WARNING("Connect a smartfridge first."))
				return

			if(src.z != connected.z || get_dist(src, connected) > tether_range)
				to_chat(user, SPAN_WARNING("Smartfridge is out of range. Connection severed."))
				cleanup()
				attack_hand(user)
				return

			connected.add_local_item(loaded_pill_bottles[bottle_index])
			if(LAZYFIND(loaded_pill_bottles_to_fill, loaded_pill_bottles[bottle_index]) > 0)
				loaded_pill_bottles_to_fill -= loaded_pill_bottles[bottle_index]
			loaded_pill_bottles -= loaded_pill_bottles[bottle_index]

			if(length(loaded_pill_bottles) == 1)
				loaded_pill_bottles_to_fill = LAZYCOPY(loaded_pill_bottles)
			return TRUE

		if("connect")
			connect_smartfridge()
			return TRUE
		if("check_pill_bottle")
			if(params["bottleIndex"] + 1 > length(loaded_pill_bottles))
				return FALSE
			if(params["value"])
				loaded_pill_bottles_to_fill += loaded_pill_bottles[params["bottleIndex"] + 1]
			else if (LAZYFIND(loaded_pill_bottles_to_fill, loaded_pill_bottles[params["bottleIndex"] + 1]) != 0)
				loaded_pill_bottles_to_fill -= loaded_pill_bottles[params["bottleIndex"] + 1]


/obj/structure/machinery/chem_master/attack_hand(mob/living/user)
	if(stat & BROKEN)
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use this."))
		return

	tgui_interact(usr)
	user.set_interaction(src)

/obj/structure/machinery/chem_master/proc/cleanup()
	SIGNAL_HANDLER
	if(connected)
		connected = null

/obj/structure/machinery/chem_master/yautja
	name = "chemical distributor"
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	breakable = FALSE

/obj/structure/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	req_skill = null
	req_skill_level = null
	condi = 1

/obj/structure/machinery/chem_master/industry_mixer
	name = "Industrial Chemical Mixer"
	icon_state = "industry_mixer0"
	base_state = "industry_mixer"
	req_skill = SKILL_ENGINEER
	req_skill_level = SKILL_ENGINEER_TRAINED
	pill_maker = FALSE
	vial_maker = TRUE
	max_pill_count = 0
