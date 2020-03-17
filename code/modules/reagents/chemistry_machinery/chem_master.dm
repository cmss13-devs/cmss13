/obj/structure/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	layer = BELOW_OBJ_LAYER //So bottles/pills reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_DOCTOR
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
	var/obj/structure/machinery/smartfridge/chemistry/connected

/obj/structure/machinery/chem_master/New()
	..()
	var/datum/reagents/R = new/datum/reagents(240)
	reagents = R
	R.my_atom = src
	connect_smartfridge()

/obj/structure/machinery/bodyscanner/Dispose()
	connected = null
	. = ..()

/obj/structure/machinery/chem_master/proc/connect_smartfridge()
	if(connected)
		return
	connected = locate(/obj/structure/machinery/smartfridge/chemistry) in range(3, src)
	visible_message(SPAN_NOTICE("<b>The [src] beeps:</b> Smartfridge connected."))

/obj/structure/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return


/obj/structure/machinery/chem_master/power_change()
	..()
	update_icon()

/obj/structure/machinery/chem_master/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker?"mixer1_b":"mixer0_b")
	else if(stat & NOPOWER)
		icon_state = (beaker?"mixer1_nopower":"mixer0_nopower")
	else
		icon_state = (beaker?"mixer1":"mixer0")


/obj/structure/machinery/chem_master/attackby(obj/item/B, mob/living/user)
	if(istype(B, /obj/item/reagent_container/glass))
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return
		beaker = B
		user.drop_inv_item_to_loc(B, src)
		to_chat(user, SPAN_NOTICE("You add the beaker to the machine!"))
		updateUsrDialog()
		update_icon()

	else if(istype(B, /obj/item/storage/pill_bottle))
		if(loaded_pill_bottle)
			to_chat(user, SPAN_WARNING("A pill bottle is already loaded into the machine."))
			return

		loaded_pill_bottle = B
		user.drop_inv_item_to_loc(B, src)
		to_chat(user, SPAN_NOTICE("You add the pill bottle into the dispenser slot!"))
		updateUsrDialog()
	return

/obj/structure/machinery/chem_master/proc/transfer_chemicals(var/obj/dest, var/obj/source, var/amount, var/reagent_id)
	if(istype(source))
		if(amount > 0 && source.reagents && amount <= source.reagents.maximum_volume)
			if(!istype(dest))
				source.reagents.remove_reagent(reagent_id, amount)
			else if(dest.reagents)
				source.reagents.trans_id_to(dest, reagent_id, amount)

/obj/structure/machinery/chem_master/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
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

		// Input the text and apply it
		add_label(loaded_pill_bottle, user)

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
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			transfer_chemicals(src, beaker, useramount, id)

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
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			if(mode)
				transfer_chemicals(beaker, src, useramount, id)
			else
				transfer_chemicals(null, src, useramount, id)

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
				count = Clamp(input("Select the number of pills to make. (max: [max_pill_count])", 10, pillamount) as num|null,0,max_pill_count)
				if(!count)
					return

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			for(var/datum/reagent/R in reagents.reagent_list)
				if(!R.ingestible)
					to_chat(user, SPAN_WARNING("[R.name] must be administered intravenously and cannot be made into a pill."))
					return

			var/amount_per_pill = reagents.total_volume/count
			if(amount_per_pill > 60) amount_per_pill = 60

			var/name = reject_bad_text(input(user,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill] units)") as text|null)
			if(!name)
				return

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count--)
				var/obj/item/reagent_container/pill/P = new/obj/item/reagent_container/pill(loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.pill_desc = "A [name] pill."
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				reagents.trans_to(P,amount_per_pill)
				if(loaded_pill_bottle)
					if(loaded_pill_bottle.contents.len < loaded_pill_bottle.max_storage_space)
						loaded_pill_bottle.handle_item_insertion(P, TRUE)
						updateUsrDialog()

		else if(href_list["createbottle"])
			if(!condi)
				var/name = reject_bad_text(input(user,"Name:","Name your bottle!", reagents.get_master_reagent_name()) as text|null)
				if(!name)
					return

				var/obj/item/reagent_container/glass/bottle/P = new/obj/item/reagent_container/glass/bottle()
				P.name = "[name] bottle"
				P.icon_state = "bottle-"+bottlesprite
				reagents.trans_to(P, 60)
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.update_icon()

				if(!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)

			else
				var/obj/item/reagent_container/food/condiment/P = new/obj/item/reagent_container/food/condiment()
				reagents.trans_to(P, 50)

				if(!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)
		else if(href_list["change_pill"])
			#define MAX_PILL_SPRITE 20 //max icon state of the pill sprites
			var/dat = "<table>"
			for(var/i = 1 to MAX_PILL_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "Change Pill Type", "chem_master")
			return
		else if(href_list["change_bottle"])
			#define MAX_BOTTLE_SPRITE 4 //max icon state of the bottle sprites
			var/dat = "<table>"
			for(var/i = 1 to MAX_BOTTLE_SPRITE)
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

		if(!connected)
			to_chat(user, SPAN_WARNING("Connect a smartfridge first."))
			return

		connected.add_item(loaded_pill_bottle)
		loaded_pill_bottle = null

	// Connecting a smartfridge
	if(href_list["connect"])
		connect_smartfridge()

	//src.updateUsrDialog()
	attack_hand(user)

/obj/structure/machinery/chem_master/attack_hand(mob/living/user)
	if(stat & BROKEN)
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use this."))
		return
	user.set_interaction(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to MAX_PILL_SPRITE)
				user << browse_rsc(icon('icons/obj/items/chemistry.dmi', "pill" + num2text(i)), "pill[i].png")
			for(var/i = 1 to MAX_BOTTLE_SPRITE)
				user << browse_rsc(icon('icons/obj/items/chemistry.dmi', "bottle-" + num2text(i)), "bottle-[i].png")
	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1;user=\ref[user]'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		dat += "<A href='?src=\ref[src];eject=1;user=\ref[user]'>Eject beaker and Clear Buffer</A><BR><BR>"
		if(loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1;user=\ref[user]'>Eject [loaded_pill_bottle] \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR>"
			dat += "<A href='?src=\ref[src];addlabelp=1;user=\ref[user]'>Add label to [loaded_pill_bottle] \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
			dat += "<A href='?src=\ref[src];transferp=1;'>Transfer [loaded_pill_bottle] \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\] to the smartfridge</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		if(!connected)	
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
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (60 units max)</A><a href=\"?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
			dat += "<A href='?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
			dat += "<A href='?src=\ref[src];createbottle=1;user=\ref[user]'>Create bottle (60 units max)<a href=\"?src=\ref[src]&change_bottle=1\"><img src=\"bottle-[bottlesprite].png\" /></A>"
		else
			dat += "<A href='?src=\ref[src];createbottle=1;user=\ref[user]'>Create bottle (50 units max)</A>"
	if(!condi)
		show_browser(user, "Chemmaster menu:<BR><BR>[dat]", "Chemmaster 3000", "chem_master")
	else
		show_browser(user, "Condimaster menu:<BR><BR>[dat]", "Condimaster 3000", "chem_master")
	return

/obj/structure/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	req_skill = null
	req_skill_level = null
	condi = 1