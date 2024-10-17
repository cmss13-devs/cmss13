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
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 16
	var/bottlesprite = "1" //yes, strings
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 20
	var/tether_range = 3
	var/obj/structure/machinery/smartfridge/chemistry/connected

/obj/structure/machinery/chem_master/Initialize()
	. = ..()
	create_reagents(300)
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


/obj/structure/machinery/chem_master/power_change()
	..()
	update_icon()

/obj/structure/machinery/chem_master/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker?"mixer1_b":"mixer0_b")
	else if(stat & NOPOWER)
		icon_state = (beaker?"[base_state]1_nopower":"[base_state]0_nopower")
	else
		icon_state = (beaker?"[base_state]1":"[base_state]0")


/obj/structure/machinery/chem_master/attackby(obj/item/B, mob/living/user)
	if(istype(B, /obj/item/reagent_container/glass))
		var/obj/item/old_beaker = beaker
		beaker = B
		user.drop_inv_item_to_loc(B, src)
		if(old_beaker)
			to_chat(user, SPAN_NOTICE("You swap out \the [old_beaker] for \the [B]."))
			user.put_in_hands(old_beaker)
		else
			to_chat(user, SPAN_NOTICE("You add the beaker to the machine!"))
		SStgui.update_uis(src)
		update_icon()

	else if(istype(B, /obj/item/storage/pill_bottle) && pill_maker)
		if(loaded_pill_bottle)
			to_chat(user, SPAN_WARNING("A pill bottle is already loaded into the machine."))
			return

		loaded_pill_bottle = B
		user.drop_inv_item_to_loc(B, src)
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

/obj/structure/machinery/chem_master/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable())
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained())
		return
	if(!in_range(src, user))
		return

	add_fingerprint(user)
	user.set_interaction(src)


	if(href_list["ejectp"])
		if(!loaded_pill_bottle)
			return

		if(!Adjacent(usr) || !usr.put_in_hands(loaded_pill_bottle))
			loaded_pill_bottle.forceMove(loc)

		loaded_pill_bottle = null

	// Adding a name to the currently stored pill bottle
	if(href_list["addlabelp"])

		// Checking for state changes
		if(!loaded_pill_bottle)
			return

		if(!Adjacent(usr))
			return

		var/label = copytext(reject_bad_text(input(user,"Label text?", "Set label", "")), 1, MAX_NAME_LEN)
		if(label)
			loaded_pill_bottle.AddComponent(/datum/component/label, label)
			if(length(label) < 3)
				loaded_pill_bottle.maptext_label = label
				loaded_pill_bottle.update_icon()
	else if(href_list["setcolor"])
		// Checking for state changes
		if(!loaded_pill_bottle)
			return

		if(!Adjacent(usr))
			return

		loaded_pill_bottle.choose_color()

	else if(href_list["close"])
		close_browser(user, "chemmaster")
		user.unset_interaction()
		return

	if(beaker)
		if(href_list["add"])
			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				transfer_chemicals(src, beaker, amount, id)

		else if(href_list["addcustom"])
			var/id = href_list["addcustom"]
			useramount = tgui_input_number(usr, "Select the amount to transfer.", "Transfer amount", useramount)
			transfer_chemicals(src, beaker, useramount, id)

		else if(href_list["addall"])
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				var/amount = beaker.volume
				transfer_chemicals(src, beaker, amount, R.id)

		else if(href_list["remove"])
			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if(mode)
					transfer_chemicals(beaker, src, amount, id)
				else
					transfer_chemicals(null, src, amount, id)


		else if(href_list["removecustom"])
			var/id = href_list["removecustom"]
			useramount = tgui_input_number(usr, "Select the amount to transfer.", "Transfer amount", useramount)
			if(mode)
				transfer_chemicals(beaker, src, useramount, id)
			else
				transfer_chemicals(null, src, useramount, id)

		else if(href_list["removeall"])
			for(var/datum/reagent/R in src.reagents.reagent_list)
				var/amount = src.reagents.total_volume
				if(mode)
					transfer_chemicals(beaker, src, amount, R.id)
				else
					transfer_chemicals(null, src, amount, R.id)

		else if(href_list["toggle"])
			mode = !mode

		else if(href_list["main"])
			attack_hand(user)
			return
		else if(href_list["eject"])
			if(!beaker)
				return

			if(!Adjacent(usr) || !usr.put_in_hands(beaker))
				beaker.forceMove(loc)

			beaker = null
			reagents.clear_reagents()
			update_icon()

		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if(href_list["createpill_multiple"])
				count = clamp(tgui_input_number(user, "Select the number of pills to make. (max: [max_pill_count])", "Pills to make", pillamount, max_pill_count, 1), 0, max_pill_count)
				if(!count)
					return

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			for(var/datum/reagent/R in reagents.reagent_list)
				if(R.flags & REAGENT_NOT_INGESTIBLE)
					to_chat(user, SPAN_WARNING("[R.name] must be administered intravenously and cannot be made into a pill."))
					return

			var/amount_per_pill = reagents.total_volume/count
			if(amount_per_pill > 60) amount_per_pill = 60

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			var/was_logged = FALSE

			while (count--)
				var/obj/item/reagent_container/pill/P = new/obj/item/reagent_container/pill(loc)
				P.pill_desc = "A custom pill."
				P.icon_state = "pill"+pillsprite
				reagents.trans_to(P,amount_per_pill)
				if(loaded_pill_bottle)
					if(length(loaded_pill_bottle.contents) < loaded_pill_bottle.max_storage_space)
						loaded_pill_bottle.handle_item_insertion(P, TRUE)
						updateUsrDialog()

				if(!was_logged)
					var/list/reagents_in_pill = list()
					for(var/datum/reagent/R in P.reagents.reagent_list)
						reagents_in_pill += R.name
					var/contained = english_list(reagents_in_pill)
					msg_admin_niche("[key_name(usr)] created one or more pills (total pills to synthesize: [count+1]) (REAGENTS: [contained]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
					was_logged = TRUE

		else if(href_list["createglass"])
			if(!condi)
				var/name = reject_bad_text(input(user,"Label:","Enter label!", reagents.get_master_reagent_name()) as text|null)
				if(!name)
					return

				var/obj/item/reagent_container/glass/P
				if(href_list["createbottle"])
					P = new/obj/item/reagent_container/glass/bottle()
					P.name = "[name] bottle"
					P.icon_state = "bottle-"+bottlesprite
					reagents.trans_to(P, 60)
				else if(href_list["createvial"])
					P = new/obj/item/reagent_container/glass/beaker/vial()
					P.name = "[name] vial"
					reagents.trans_to(P, 30)

				P.update_icon()

				if(href_list["store"])
					connected.add_local_item(P)
				else if(!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)

			else
				var/obj/item/reagent_container/food/condiment/P = new/obj/item/reagent_container/food/condiment()
				reagents.trans_to(P, 50)

				if(!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)
		else if(href_list["change_pill"])
			var/dat = "<table>"
			for(var/i = 1 to PILL_ICON_CHOICES)
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "Change Pill Type", "chem_master")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			for(var/i = 1 to BOTTLE_ICON_CHOICES)
				dat += "<tr><td><a href=\"?src=\ref[src]&bottle_sprite=[i]\"><img src=\"bottle-[i].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "Change Bottle Type", "chem_master")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	if(href_list["transferp"])
		if(!loaded_pill_bottle)
			return

		if(QDELETED(connected))
			to_chat(user, SPAN_WARNING("Connect a smartfridge first."))
			return

		if(src.z != connected.z || get_dist(src, connected) > tether_range)
			to_chat(user, SPAN_WARNING("Smartfridge is out of range. Connection severed."))
			cleanup()
			attack_hand(user)
			return

		connected.add_local_item(loaded_pill_bottle)
		loaded_pill_bottle = null

	// Connecting a smartfridge
	if(href_list["connect"])
		connect_smartfridge()

	//src.updateUsrDialog()
	attack_hand(user)

/obj/structure/machinery/chem_master/ui_data(mob/user)
	. = ..()

	.["is_connected"] = !!connected
	.["mode"] = mode
	.["pillsprite"] = pillsprite
	.["bottlesprite"] = bottlesprite

	.["pill_bottle"] = null
	if(loaded_pill_bottle)
		var/datum/component/label/label = loaded_pill_bottle.GetComponent(/datum/component/label)
		.["pill_bottle"] = list(
			"size" = length(loaded_pill_bottle.contents),
			"max_size" = loaded_pill_bottle.max_storage_space,
			"label" = label ? label.label_name : null
		)

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

	.["pill_bottle_icon"] = "['icons/obj/items/chemistry.dmi']"
	.["pill_icon_choices"] = PILL_ICON_CHOICES
	.["bottle_icon_choices"] = BOTTLE_ICON_CHOICES

	.["is_pillmaker"] = pill_maker
	.["is_condiment"] = condi
	.["is_vialmaker"] = vial_maker

/obj/structure/machinery/chem_master/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/mob/user = ui.user
	if(!Adjacent(user))
		return

	switch(action)
		if("eject_pill")
			if(!loaded_pill_bottle)
				return

			if(!user.put_in_hands(loaded_pill_bottle))
				loaded_pill_bottle.forceMove(loc)

			loaded_pill_bottle = null

			return TRUE

		if("label_pill")
			if(!loaded_pill_bottle)
				return

			var/label = copytext(reject_bad_text(params["text"]), 1, MAX_NAME_LEN)
			if(!label)
				return

			loaded_pill_bottle.AddComponent(/datum/component/label, label)
			if(length(label) < 3)
				loaded_pill_bottle.maptext_label = label
				loaded_pill_bottle.update_icon()

			return TRUE

		if("color_pill")
			if(!loaded_pill_bottle)
				return

			loaded_pill_bottle.choose_color(user)

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

			var/to_create = floor(clamp(params["number"], 1, max_pill_count))

			if(reagents.total_volume / to_create < 1)
				return

			var/list/reagents_in_pill = list()
			for(var/datum/reagent/contained_reagent in reagents.reagent_list)
				if(contained_reagent.flags & REAGENT_NOT_INGESTIBLE)
					to_chat(user, SPAN_WARNING("[contained_reagent.name] must be administered intravenously, and cannot be made into a pill."))
					return

				reagents_in_pill += contained_reagent.name

			var/amount_per_pill = clamp(reagents.total_volume / to_create, 0, 60)

			msg_admin_niche("[key_name(user)] created one or more pills (total pills to synthesize: [to_create]) (REAGENTS: [english_list(reagents_in_pill)]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
			for(var/iterator in 1 to to_create)
				var/obj/item/reagent_container/pill/creating_pill = new(loc)
				creating_pill.pill_desc = "A custom pill."
				creating_pill.icon_state = "pill[pillsprite]"

				reagents.trans_to(creating_pill, amount_per_pill)
				if(loaded_pill_bottle && length(loaded_pill_bottle.contents) < loaded_pill_bottle.max_storage_space)
					loaded_pill_bottle.handle_item_insertion(creating_pill, TRUE)

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
					new_container.name = "[name] Bottle"
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

			if(params["store"])
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
			if(!loaded_pill_bottle)
				return

			if(QDELETED(connected))
				to_chat(user, SPAN_WARNING("Connect a smartfridge first."))
				return

			if(src.z != connected.z || get_dist(src, connected) > tether_range)
				to_chat(user, SPAN_WARNING("Smartfridge is out of range. Connection severed."))
				cleanup()
				attack_hand(user)
				return

			connected.add_local_item(loaded_pill_bottle)
			loaded_pill_bottle = null
			return TRUE

		if("connect")
			connect_smartfridge()
			return TRUE


/obj/structure/machinery/chem_master/attack_hand(mob/living/user)
	if(stat & BROKEN)
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use this."))
		return

	tgui_interact(usr)
	user.set_interaction(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to PILL_ICON_CHOICES)
				user << browse_rsc(icon('icons/obj/items/chemistry.dmi', "pill" + num2text(i)), "pill[i].png")
			for(var/i = 1 to BOTTLE_ICON_CHOICES)
				user << browse_rsc(icon('icons/obj/items/chemistry.dmi', "bottle-" + num2text(i)), "bottle-[i].png")
	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(pill_maker)
			if(loaded_pill_bottle)
				dat += "<A href='?src=\ref[src];ejectp=1;user=\ref[user]'>Eject Pill Bottle \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
			else
				dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		dat += "<A href='?src=\ref[src];eject=1;user=\ref[user]'>Eject beaker and Clear Buffer</A><BR><BR>"
		if(pill_maker)
			if(loaded_pill_bottle)
				dat += "<A href='?src=\ref[src];ejectp=1;user=\ref[user]'>Eject [loaded_pill_bottle] \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR>"
				dat += "<A href='?src=\ref[src];addlabelp=1;user=\ref[user]'>Add label to [loaded_pill_bottle] \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR>"
				dat += "<A href='?src=\ref[src];setcolor=1;user=\ref[user]'>Set color to [loaded_pill_bottle] \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
				dat += "<A href='?src=\ref[src];transferp=1;'>Transfer [loaded_pill_bottle] \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.max_storage_space]\] to the smartfridge</A><BR><BR>"
			else
				dat += "No pill bottle inserted.<BR><BR>"
		if(!connected && pill_maker)
			dat += "<A href='?src=\ref[src];connect=1'>Connect Smartfridge</A><BR><BR>"
		if(!beaker.reagents.total_volume)
			dat += "Beaker is empty."
		else
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in beaker.reagents.reagent_list)
				dat += "[G.name] , [G.volume] Units - "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=1'>1</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=5'>5</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=10'>10</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=30'>30</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=60'>60</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=[G.volume]'>All</A> "
				dat += "<A href='?src=\ref[src];addcustom=[G.id]'>Custom</A><BR>"
			dat += "<A href='?src=\ref[src];addall=[beaker]'>All reagents</A><BR>"

		dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.name] , [N.volume] Units - "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=1'>1</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=5'>5</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=10'>10</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=30'>30</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=60'>60</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=[N.volume]'>All</A> "
				dat += "<A href='?src=\ref[src];removecustom=[N.id]'>Custom</A><BR>"
			dat += "<A href='?src=\ref[src];removeall=[src]'>All reagents</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			if(pill_maker)
				dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (60 units max)</A><a href=\"?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
				dat += "<A href='?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
			dat += "<A href='?src=\ref[src];createglass=1;createbottle=1;user=\ref[user]'>Create bottle (60 units max)<a href=\"?src=\ref[src]&change_bottle=1\"><img src=\"bottle-[bottlesprite].png\" /></A>"
			if(connected)
				dat += "<BR><A href='?src=\ref[src];createglass=1;createbottle=1;store=1;user=\ref[user]'>Store bottle in smartfridge (60 units max)</A>"
			if(vial_maker)
				dat += "<BR><BR><A href='?src=\ref[src];createglass=1;createvial=1;user=\ref[user]'>Create vial (30 units max)</A>"
				if(connected)
					dat += "<BR><A href='?src=\ref[src];createglass=1;createvial=1;store=1;user=\ref[user]'>Store vial in smartfridge (30 units max)</A>"
		else
			dat += "<A href='?src=\ref[src];createglass=1;user=\ref[user]'>Create bottle (50 units max)</A>"
	if(!condi)
		show_browser(user, "[name] menu:<BR><BR>[dat]", name, "chem_master", "size=460x520")
	else
		show_browser(user, "Condimaster menu:<BR><BR>[dat]", name, "chem_master")
	return

/obj/structure/machinery/chem_master/proc/cleanup()
	SIGNAL_HANDLER
	if(connected)
		connected = null

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
