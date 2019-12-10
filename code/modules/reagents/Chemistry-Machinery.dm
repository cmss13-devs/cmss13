/obj/structure/machinery/chem_dispenser
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "dispenser"
	use_power = 0
	idle_power_usage = 40
	req_one_access = list(ACCESS_MARINE_CMO, ACCESS_MARINE_CHEMISTRY)
	layer = BELOW_OBJ_LAYER //So beakers reliably appear above it
	var/ui_title = "Chem Dispenser 5000"
	var/energy = 100
	var/max_energy = 100
	var/amount = 30
	var/accept_glass = 0 //At 0 ONLY accepts glass containers. Kinda misleading varname.
	var/obj/item/reagent_container/beaker = null
	var/recharged = 0
	var/hackedcheck = 0
	var/list/dispensable_reagents = list("hydrogen","lithium","carbon","nitrogen","oxygen","fluorine",
	"sodium","aluminum","silicon","phosphorus","sulfur","chlorine","potassium","iron",
	"copper","mercury","radium","water","ethanol","sugar","sacid")

/obj/structure/machinery/chem_dispenser/proc/recharge()
	if(stat & (BROKEN|NOPOWER)) return
	var/addenergy = 10
	var/oldenergy = energy
	energy = min(energy + addenergy, max_energy)
	if(energy != oldenergy)
		use_power(1500) // This thing uses up alot of power (this is still low as shit for creating reagents from thin air)
		nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/chem_dispenser/power_change()
	..()
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/chem_dispenser/process()
	if(recharged <= 0)
		recharge()
		recharged = 15
	else
		recharged -= 1

/obj/structure/machinery/chem_dispenser/New()
	..()
	recharge()
	dispensable_reagents = sortList(dispensable_reagents)
	start_processing()


/obj/structure/machinery/chem_dispenser/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return


/obj/structure/machinery/chem_dispenser/on_stored_atom_del(atom/movable/AM)
	if(AM == beaker)
		beaker = null

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/structure/machinery/chem_dispenser/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	if (stat & (BROKEN|NOPOWER)) 
		return
	if (user.stat || user.is_mob_restrained()) 
		return

	// this is the data which will be sent to the ui
	var/list/data = list(
		"amount" = amount,
		"energy" = round(energy),
		"maxEnergy" = round(max_energy),
		"isBeakerLoaded" = istype(beaker),
		"glass" = accept_glass
	)
	var beakerContents[0]
	var beakerCurrentVolume = 0
	if (beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for (var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker.volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var chemicals[0]
	for (var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if (temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "chem_dispenser.tmpl", ui_title, 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/structure/machinery/chem_dispenser/Topic(href, href_list)
	if (stat & (NOPOWER|BROKEN))
		return FALSE // don't update UIs attached to this object

	if (href_list["amount"])
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		if (amount < 0) // Since the user can actually type the commands himself, some sanity checking
			amount = 0
		if (amount > 240)
			amount = 240

	if (href_list["dispense"])
		if (dispensable_reagents.Find(href_list["dispense"]) && beaker != null && beaker.is_open_container())
			var/obj/item/reagent_container/B = src.beaker
			var/datum/reagents/R = B.reagents
			var/space = R.maximum_volume - R.total_volume

			R.add_reagent(href_list["dispense"], min(amount, energy * 10, space))
			energy = max(energy - min(amount, energy * 10, space) / 10, 0)

	if (href_list["ejectBeaker"])
		if (!beaker)
			return FALSE

		if (!Adjacent(usr) || !usr.put_in_hands(beaker))
			beaker.forceMove(loc)
		beaker = null

	add_fingerprint(usr)
	attack_hand(usr)
	return TRUE // update UIs attached to this object

/obj/structure/machinery/chem_dispenser/attackby(var/obj/item/reagent_container/B as obj, var/mob/user as mob)
	if(isrobot(user))
		return
	if(src.beaker)
		to_chat(user, "Something is already loaded into the machine.")
		return
	if(istype(B, /obj/item/reagent_container/glass) || istype(B, /obj/item/reagent_container/food))
		if(!accept_glass && istype(B,/obj/item/reagent_container/food))
			to_chat(user, SPAN_NOTICE("This machine only accepts beakers"))
		if(user.drop_inv_item_to_loc(B, src))
			beaker =  B
			to_chat(user, "You set [B] on the machine.")
			nanomanager.update_uis(src) // update all UIs attached to src
		return

/obj/structure/machinery/chem_dispenser/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/chem_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	var/mob/living/carbon/human/H = user
	if(!check_access(H.wear_id))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	ui_interact(user)

/obj/structure/machinery/chem_dispenser/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	ui_title = "Soda Dispens-o-matic"
	energy = 100
	accept_glass = 1
	req_one_access = list()
	max_energy = 100
	dispensable_reagents = list("water","ice","coffee","cream","tea","icetea","cola","spacemountainwind","dr_gibb","space_up","tonic","sodawater","lemon_lime","sugar","orangejuice","limejuice","watermelonjuice")

/obj/structure/machinery/chem_dispenser/soda/attackby(var/obj/item/B as obj, var/mob/user as mob)
	..()
	if(istype(B, /obj/item/device/multitool))
		if(hackedcheck == 0)
			to_chat(user, "You change the mode from 'McNano' to 'Pizza King'.")
			dispensable_reagents += list("thirteenloko","grapesoda")
			hackedcheck = 1
			return

		else
			to_chat(user, "You change the mode from 'Pizza King' to 'McNano'.")
			dispensable_reagents -= list("thirteenloko","grapesoda")
			hackedcheck = 0
			return

/obj/structure/machinery/chem_dispenser/beer
	icon_state = "booze_dispenser"
	name = "booze dispenser"
	ui_title = "Booze Portal 9001"
	energy = 100
	accept_glass = 1
	max_energy = 100
	req_one_access = list()
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list("lemon_lime","sugar","orangejuice","limejuice","sodawater","tonic","beer","kahlua","whiskey","sake","wine","vodka","gin","rum","tequilla","vermouth","cognac","ale","mead")

/obj/structure/machinery/chem_dispenser/beer/attackby(var/obj/item/B as obj, var/mob/user as mob)
	..()

	if(istype(B, /obj/item/device/multitool))
		if(hackedcheck == 0)
			to_chat(user, "You disable the 'nanotrasen-are-cheap-bastards' lock, enabling hidden and very expensive boozes.")
			dispensable_reagents += list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 1
			return

		else
			to_chat(user, "You re-enable the 'nanotrasen-are-cheap-bastards' lock, disabling hidden and very expensive boozes.")
			dispensable_reagents -= list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 0
			return
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/structure/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	layer = BELOW_OBJ_LAYER //So bottles/pills reliably appear above it
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

/obj/structure/machinery/chem_master/New()
	..()
	var/datum/reagents/R = new/datum/reagents(240)
	reagents = R
	R.my_atom = src

/obj/structure/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return

/obj/structure/machinery/chem_master/attackby(obj/item/B, mob/living/user)

	if(istype(B, /obj/item/reagent_container/glass))

		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return
		beaker = B
		user.drop_inv_item_to_loc(B, src)
		to_chat(user, SPAN_NOTICE("You add the beaker to the machine!"))
		updateUsrDialog()
		icon_state = "mixer1"

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


	if (href_list["ejectp"])
		if (!loaded_pill_bottle)
			return

		if (!Adjacent(usr) || !usr.put_in_hands(loaded_pill_bottle))
			loaded_pill_bottle.forceMove(loc)

		loaded_pill_bottle = null
	else if(href_list["close"])
		close_browser(user, "chemmaster")
		user.unset_interaction()
		return

	if(beaker)
		if (href_list["add"])

			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				transfer_chemicals(src, beaker, amount, id)

		else if (href_list["addcustom"])

			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			transfer_chemicals(src, beaker, useramount, id)

		else if (href_list["remove"])

			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if(mode)
					transfer_chemicals(beaker, src, amount, id)
				else
					transfer_chemicals(null, src, amount, id)


		else if (href_list["removecustom"])

			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			if(mode)
				transfer_chemicals(beaker, src, useramount, id)
			else
				transfer_chemicals(null, src, useramount, id)

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["main"])
			attack_hand(user)
			return
		else if (href_list["eject"])
			if (!beaker)
				return

			if (!Adjacent(usr) || !usr.put_in_hands(beaker))
				beaker.forceMove(loc)

			beaker = null
			reagents.clear_reagents()
			icon_state = "mixer0"
		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if (href_list["createpill_multiple"])
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
			if (amount_per_pill > 60) amount_per_pill = 60

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

		else if (href_list["createbottle"])
			if (!condi)
				var/name = reject_bad_text(input(user,"Name:","Name your bottle!", reagents.get_master_reagent_name()) as text|null)
				if (!name)
					return
				
				var/obj/item/reagent_container/glass/bottle/P = new/obj/item/reagent_container/glass/bottle()
				P.name = "[name] bottle"
				P.icon_state = "bottle-"+bottlesprite
				reagents.trans_to(P, 60)
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.update_icon()

				if (!Adjacent(usr) || !usr.put_in_hands(P))
					P.forceMove(loc)
				
			else
				var/obj/item/reagent_container/food/condiment/P = new/obj/item/reagent_container/food/condiment()
				reagents.trans_to(P, 50)

				if (!Adjacent(usr) || !usr.put_in_hands(P))
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

	//src.updateUsrDialog()
	attack_hand(user)

/obj/structure/machinery/chem_master/attack_hand(mob/living/user)
	if(stat & BROKEN)
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
		dat += "<A href='?src=\ref[src];eject=1;user=\ref[user]'>Eject beaker and Clear Buffer</A><BR>"
		if(loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1;user=\ref[user]'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
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
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

//this machine does nothing
/obj/structure/machinery/disease2/diseaseanalyser
	name = "Disease Analyser"
	icon = 'icons/obj/structures/machinery/virology.dmi'
	icon_state = "analyser"
	anchored = 1
	density = 1


/obj/structure/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	density = 1
	anchored = 1
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "mixer0"
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/circuitboard/computer/pandemic
	var/temphtml = ""
	var/wait = null
	var/obj/item/reagent_container/glass/beaker = null
	var/list/discovered_diseases = list()


/obj/structure/machinery/computer/pandemic/set_broken()
	icon_state = (beaker?"mixer1_b":"mixer0_b")
	stat |= BROKEN


/obj/structure/machinery/computer/pandemic/power_change()
	..()
	if(stat & BROKEN)
		icon_state = (beaker?"mixer1_b":"mixer0_b")

	else if(!(stat & NOPOWER))
		icon_state = (beaker?"mixer1":"mixer0")

	else
		spawn(rand(0, 15))
			icon_state = (beaker?"mixer1_nopower":"mixer0_nopower")


/obj/structure/machinery/computer/pandemic/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN)) return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained()) return
	if(!in_range(src, user)) return

	user.set_interaction(src)
	if(!beaker) return

	if (href_list["create_vaccine"])
		if(!wait)
			var/path = href_list["create_vaccine"]
			var/vaccine_type = text2path(path)
			if(!(vaccine_type in discovered_diseases))
				return
			var/obj/item/reagent_container/glass/bottle/B = new/obj/item/reagent_container/glass/bottle(loc)
			if(B)
				var/datum/disease/D = null
				if(!vaccine_type)
					D = archive_diseases[path]
					vaccine_type = path
				else
					if(vaccine_type in diseases)
						D = new vaccine_type(0, null)

				if(D)
					B.name = "[D.name] vaccine bottle"
					B.reagents.add_reagent("vaccine",15,vaccine_type)
					wait = 1
					var/datum/reagent/blood/Blood = null
					for(var/datum/reagent/blood/L in beaker.reagents.reagent_list)
						if(L)
							Blood = L
							break
					var/list/res = Blood.data["resistances"]
					spawn(res.len*200)
						wait = null
		else
			temphtml = "The replicator is not ready yet."
		updateUsrDialog()
		return
	else if (href_list["create_virus_culture"])
		if(!wait)
			var/virus_type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
			if(!(virus_type in discovered_diseases))
				return
			var/obj/item/reagent_container/glass/bottle/B = new/obj/item/reagent_container/glass/bottle(src.loc)
			B.icon_state = "bottle3"
			var/datum/disease/D = null
			if(!virus_type)
				var/datum/disease/advance/A = archive_diseases[href_list["create_virus_culture"]]
				if(A)
					D = new A.type(0, A)
			else
				if(virus_type in diseases) // Make sure this is a disease
					D = new virus_type(0, null)
			var/list/data = list("viruses"=list(D))
			var/name = sanitize(input(user,"Name:","Name the culture",D.name))
			if(!name || name == " ") name = D.name
			B.name = "[name] culture bottle"
			B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
			B.reagents.add_reagent("blood",20,data)
			updateUsrDialog()
			wait = 1
			spawn(1000)
				wait = null
		else
			temphtml = "The replicator is not ready yet."
		updateUsrDialog()
		return
	else if (href_list["empty_beaker"])
		beaker.reagents.clear_reagents()
		updateUsrDialog()
		return
	else if (href_list["eject"])
		beaker.forceMove(loc)
		beaker = null
		icon_state = "mixer0"
		updateUsrDialog()
		return
	else if(href_list["clear"])
		temphtml = ""
		updateUsrDialog()
		return
	else if(href_list["name_disease"])
		var/new_name = stripped_input(user, "Name the Disease", "New Name", "", MAX_NAME_LEN)
		if(stat & (NOPOWER|BROKEN)) return
		if(user.stat || user.is_mob_restrained()) return
		if(!in_range(src, user)) return
		var/id = href_list["name_disease"]
		if(archive_diseases[id])
			var/datum/disease/advance/A = archive_diseases[id]
			A.AssignName(new_name)
			for(var/datum/disease/advance/AD in active_diseases)
				AD.Refresh()
		updateUsrDialog()


	else
		close_browser(user, "pandemic")
		updateUsrDialog()
		return

	add_fingerprint(user)
	return

/obj/structure/machinery/computer/pandemic/attack_hand(mob/living/user)
	if(..())
		return
	user.set_interaction(src)
	var/dat = ""
	if(temphtml)
		dat = "[temphtml]<BR><BR><A href='?src=\ref[src];clear=1'>Main Menu</A>"
	else if(!beaker)
		dat += "Please insert beaker.<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"
	else
		var/datum/reagent/blood/Blood = null
		for(var/datum/reagent/blood/B in beaker.reagents.reagent_list)
			if(B)
				Blood = B
				break
		if(!beaker.reagents.total_volume||!beaker.reagents.reagent_list.len)
			dat += "The beaker is empty<BR>"
		else if(!Blood)
			dat += "No blood sample found in beaker"
		else if(!Blood.data)
			dat += "No blood data found in beaker."
		else
			dat += "<h3>Blood sample data:</h3>"
			dat += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"


			if(Blood.data["viruses"])
				var/list/vir = Blood.data["viruses"]
				if(vir.len)
					for(var/datum/disease/D in Blood.data["viruses"])
						if(!D.hidden[PANDEMIC])

							if(!(D.type in discovered_diseases))
								discovered_diseases += D.type

							var/disease_creation = D.type
							if(istype(D, /datum/disease/advance))

								var/datum/disease/advance/A = D
								D = archive_diseases[A.GetDiseaseID()]
								disease_creation = A.GetDiseaseID()
								if(D.name == "Unknown")
									dat += "<b><a href='?src=\ref[src];name_disease=[A.GetDiseaseID()]'>Name Disease</a></b><BR>"

							if(!D)
								CRASH("We weren't able to get the advance disease from the archive.")

							dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='?src=\ref[src];create_virus_culture=[disease_creation]'>Create virus culture bottle</A>":"none"]<BR>"
							dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
							dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
							dat += "<b>Spread:</b> [(D.spread||"none")]<BR>"
							dat += "<b>Possible cure:</b> [(D.cure||"none")]<BR><BR>"

							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/A = D
								dat += "<b>Symptoms:</b> "
								var/english_symptoms = list()
								for(var/datum/symptom/S in A.symptoms)
									english_symptoms += S.name
								dat += english_list(english_symptoms)


			dat += "<BR><b>Contains antibodies to:</b> "
			if(Blood.data["resistances"])
				var/list/res = Blood.data["resistances"]
				if(res.len)
					dat += "<ul>"
					for(var/type in Blood.data["resistances"])
						var/disease_name = "Unknown"

						if(!ispath(type))
							var/datum/disease/advance/A = archive_diseases[type]
							if(A)
								disease_name = A.name
						else
							if(!(type in discovered_diseases))
								discovered_diseases += type
							var/datum/disease/D = new type(0, null)
							disease_name = D.name

						dat += "<li>[disease_name] - <A href='?src=\ref[src];create_vaccine=[type]'>Create vaccine bottle</A></li>"
					dat += "</ul><BR>"
				else
					dat += "nothing<BR>"
			else
				dat += "nothing<BR>"
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject beaker</A>[((beaker.reagents.total_volume && beaker.reagents.reagent_list.len) ? "-- <A href='?src=\ref[src];empty_beaker=1'>Empty beaker</A>":"")]<BR>"
		dat += "<A href='?src=\ref[user];mach_close=pandemic'>Close</A>"

	show_browser(user, "<TITLE>[name]</TITLE><BR>[dat]", name, "pandemic")
	return


/obj/structure/machinery/computer/pandemic/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/reagent_container/glass))
		if(stat & (NOPOWER|BROKEN)) return
		if(beaker)
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return

		beaker =  I
		user.drop_inv_item_to_loc(I, src)
		to_chat(user, SPAN_NOTICE("You add the beaker to the machine!"))
		updateUsrDialog()
		icon_state = "mixer1"

	else
		..()
	return
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/structure/machinery/reagentgrinder

	name = "All-In-One Grinder"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "juicer1"
	layer = ABOVE_TABLE_LAYER
	density = 0
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/obj/item/reagent_container/beaker = null
	var/limit = 10
	var/list/blend_items = list (

		//Sheets
		/obj/item/stack/sheet/mineral/phoron = list("phoron" = 20),
		/obj/item/stack/sheet/mineral/uranium = list("uranium" = 20),
		/obj/item/stack/sheet/mineral/silver = list("silver" = 20),
		/obj/item/stack/sheet/mineral/gold = list("gold" = 20),
		/obj/item/grown/nettle/death = list("pacid" = 0),
		/obj/item/grown/nettle = list("sacid" = 0),

		//Blender Stuff
		/obj/item/reagent_container/food/snacks/grown/soybeans = list("soymilk" = 0),
		/obj/item/reagent_container/food/snacks/grown/tomato = list("ketchup" = 0),
		/obj/item/reagent_container/food/snacks/grown/corn = list("cornoil" = 0),
		///obj/item/reagent_container/food/snacks/grown/wheat = list("flour" = -5),
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

/obj/structure/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/reagent_container/glass/beaker/large(src)
	return

/obj/structure/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return


/obj/structure/machinery/reagentgrinder/attackby(obj/item/O, mob/living/user)

	if (istype(O,/obj/item/reagent_container/glass) || \
		istype(O,/obj/item/reagent_container/food/drinks/drinkingglass) || \
		istype(O,/obj/item/reagent_container/food/drinks/shaker))

		if (beaker)
			return 1
		else
			beaker =  O
			user.drop_inv_item_to_loc(O, src)
			update_icon()
			updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, SPAN_WARNING("The machine cannot hold anymore items."))
		return 1

		updateUsrDialog()
		return 0

	if(istype(O,/obj/item/storage/bag/plants))
		var/obj/item/storage/bag/plants/B = O
		if(B.contents.len > 0)
			to_chat(user, SPAN_NOTICE("You start dumping the contents of [B] into [src]."))
			if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
			for(var/obj/item/I in B)
				if(holdingitems && holdingitems.len >= limit)
					to_chat(user, SPAN_WARNING("The machine cannot hold anymore items."))
					break
				else
					if (!is_type_in_list(I, blend_items) && !is_type_in_list(I, juice_items))
						to_chat(user, SPAN_WARNING("Cannot refine [I] into a reagent."))
						break
					else
						//B.remove_from_storage(I)
						user.drop_inv_item_to_loc(I, src)
						holdingitems += I
			playsound(user.loc, "rustle", 15, 1, 6)
			return 0

		else
			to_chat(user, SPAN_WARNING("[B] is empty."))
			return 1

	else if (!is_type_in_list(O, blend_items) && !is_type_in_list(O, juice_items))
		to_chat(user, SPAN_WARNING("Cannot refine into a reagent."))
		return 1

	user.drop_inv_item_to_loc(O, src)
	holdingitems += O
	updateUsrDialog()
	return 0

/obj/structure/machinery/reagentgrinder/attack_hand(mob/living/user)
	user.set_interaction(src)
	interact(user)

/obj/structure/machinery/reagentgrinder/interact(mob/living/user) // The microwave Menu
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Grind the reagents</a><BR>"
			dat += "<A href='?src=\ref[src];action=juice'>Juice the reagents</a><BR><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	show_browser(user, "<HEAD><TITLE>All-In-One Grinder</TITLE></HEAD><TT>[dat]</TT>", name, "reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/structure/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	usr.set_interaction(src)
	switch(href_list["action"])
		if ("grind")
			grind()
		if("juice")
			juice()
		if("eject")
			eject()
		if ("detach")
			detach()
	updateUsrDialog()
	return

/obj/structure/machinery/reagentgrinder/proc/detach()

	if (usr.stat != 0)
		return
	if (!beaker)
		return
	beaker.forceMove(loc)
	beaker = null
	update_icon()

/obj/structure/machinery/reagentgrinder/proc/eject()

	if (usr.stat != 0)
		return
	if (holdingitems && holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.forceMove(loc)
		holdingitems -= O
	holdingitems = list()

/obj/structure/machinery/reagentgrinder/proc/is_allowed(var/obj/item/reagent_container/O)
	for (var/i in blend_items)
		if(istype(O, i))
			return 1
	return 0

/obj/structure/machinery/reagentgrinder/proc/get_allowed_by_id(var/obj/item/grown/O)
	for (var/i in blend_items)
		if (istype(O, i))
			return blend_items[i]

/obj/structure/machinery/reagentgrinder/proc/get_allowed_snack_by_id(var/obj/item/reagent_container/food/snacks/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return blend_items[i]

/obj/structure/machinery/reagentgrinder/proc/get_allowed_juice_by_id(var/obj/item/reagent_container/food/snacks/O)
	for(var/i in juice_items)
		if(istype(O, i))
			return juice_items[i]

/obj/structure/machinery/reagentgrinder/proc/get_grownweapon_amount(var/obj/item/grown/O)
	if (!istype(O))
		return 5
	else if (O.potency == -1)
		return 5
	else
		return round(O.potency)

/obj/structure/machinery/reagentgrinder/proc/get_juice_amount(var/obj/item/reagent_container/food/snacks/grown/O)
	if (!istype(O))
		return 5
	else if (O.potency == -1)
		return 5
	else
		return round(5*sqrt(O.potency))

/obj/structure/machinery/reagentgrinder/proc/remove_object(var/obj/item/O)
	holdingitems -= O
	qdel(O)

/obj/structure/machinery/reagentgrinder/proc/juice()
	power_change()
	if(stat & (NOPOWER|BROKEN))
		return
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src.loc, 'sound/machines/juicer.ogg', 25, 1)
	inuse = 1
	spawn(50)
		inuse = 0
		interact(usr)
	//Snacks
	for (var/obj/item/reagent_container/food/snacks/O in holdingitems)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

		var/allowed = get_allowed_juice_by_id(O)
		if(isnull(allowed))
			break

		for (var/r_id in allowed)

			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = get_juice_amount(O)

			beaker.reagents.add_reagent(r_id, min(amount, space))

			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

		remove_object(O)

/obj/structure/machinery/reagentgrinder/proc/grind()

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
	inuse = 1
	spawn(60)
		inuse = 0
		interact(usr)
	//Snacks and Plants
	for (var/obj/item/reagent_container/food/snacks/O in holdingitems)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

		var/allowed = get_allowed_snack_by_id(O)
		if(isnull(allowed))
			break

		for (var/r_id in allowed)

			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if(amount <= 0)
				if(amount == 0)
					if (O.reagents != null && O.reagents.has_reagent("nutriment"))
						beaker.reagents.add_reagent(r_id, min(O.reagents.get_reagent_amount("nutriment"), space))
						O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))
				else
					if (O.reagents != null && O.reagents.has_reagent("nutriment"))
						beaker.reagents.add_reagent(r_id, min(round(O.reagents.get_reagent_amount("nutriment")*abs(amount)), space))
						O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))

			else
				O.reagents.trans_id_to(beaker, r_id, min(amount, space))

			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

		if(O.reagents.reagent_list.len == 0)
			remove_object(O)

	//Sheets
	for (var/obj/item/stack/sheet/O in holdingitems)
		var/allowed = get_allowed_by_id(O)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		for(var/i = 1; i <= round(O.amount, 1); i++)
			for (var/r_id in allowed)
				var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
				var/amount = allowed[r_id]
				beaker.reagents.add_reagent(r_id,min(amount, space))
				if (space < amount)
					break
			if (i == round(O.amount, 1))
				remove_object(O)
				break
	//Plants
	for (var/obj/item/grown/O in holdingitems)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/allowed = get_allowed_by_id(O)
		for (var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if (amount == 0)
				if (O.reagents != null && O.reagents.has_reagent(r_id))
					beaker.reagents.add_reagent(r_id,min(O.reagents.get_reagent_amount(r_id), space))
			else
				beaker.reagents.add_reagent(r_id,min(amount, space))

			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
		remove_object(O)

	//Cigarettes
	for (var/obj/item/clothing/mask/cigarette/O in holdingitems)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/amount = O.reagents.total_volume
		O.reagents.trans_to(beaker, amount)
		if(!O.reagents.total_volume)
			remove_object(O)

	//Everything else - Transfers reagents from it into beaker
	for (var/obj/item/reagent_container/O in holdingitems)
		if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/amount = O.reagents.total_volume
		O.reagents.trans_to(beaker, amount)
		if(!O.reagents.total_volume)
			remove_object(O)

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/structure/machinery/reagent_analyzer
	name = "Advanced XRF Scanner"
	desc = "A spectrometer that bombards a sample in high energy radiation to detect emitted fluorescent x-ray patterns. By using the emission spectrum of the sample it can identify its chemical composition."
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "reagent_analyzer"
	active_power_usage = 5000 //This is how many watts the big XRF machines usually take

	var/mob/last_used
	var/obj/item/reagent_container/sample = null //Object containing our sample
	var/clearance_level = 0
	var/sample_number = 1 //Just for printing fluff
	var/processing = 0
	var/status = 0

/obj/structure/machinery/reagent_analyzer/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still processing!"))
		return
	if(istype(B, /obj/item/card/id))
		var/obj/item/card/id/card = B
		if(ACCESS_WY_CORPORATE in card.access)
			var/setting = alert(usr,"How do you want to change the clearance settings?","[src]","Increase","Set to maximum","Set to minimum")
			if(!setting) return

			var/clearance_allowance = 6 - defcon_controller.current_defcon_level

			switch(setting)
				if("Increase")
					if(clearance_level < clearance_allowance)
						clearance_level = min(5,clearance_level + 1)
				if("Set to maximum")
					clearance_level = clearance_allowance
				if("Set to minimum")
					clearance_level = 0

			visible_message(SPAN_NOTICE("[user] swipes their ID card on the [src], updating the clearance to level [clearance_level]."))
		else
			visible_message(SPAN_NOTICE("[user] swipes their ID card on the [src], but it refused."))
		return
	if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/reagent_container/glass/beaker/vial))
		if(sample || status)
			to_chat(user, SPAN_WARNING("Something is already loaded into the [src]."))
			return

		if(user.drop_inv_item_to_loc(B, src))
			sample = B
			icon_state = "reagent_analyzer_sample"
			to_chat(user, SPAN_NOTICE("You insert [B] and start configuring the [src]."))
			updateUsrDialog()
			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
			processing = 1
			if(sample.reagents.total_volume < 30 || sample.reagents.reagent_list.len > 1)
				icon_state = "reagent_analyzer_error"
				start_processing()
			else
				icon_state = "reagent_analyzer_processing"
				start_processing()
			last_used = user
		return
	else
		to_chat(user, SPAN_WARNING("[src] only accepts samples in vials."))
		return

/obj/structure/machinery/reagent_analyzer/process()
	status++
	if(status <= 3)
		return
	else
		playsound(src.loc, 'sound/machines/fax.ogg', 15, 1)
		status = 0
		processing = 0
		stop_processing()
		sleep(40)
		if(sample.reagents.total_volume < 30 || sample.reagents.reagent_list.len > 1)
			if(sample.reagents.total_volume < 30)
				print_report(0, "SAMPLE SIZE INSUFFICIENT;<BR>\n<I>A sample size of 30 units is required for analysis.</I>")
			else if(sample.reagents.reagent_list.len > 1)
				print_report(0, "SAMPLE CONTAMINATED;<BR>\n<I>A pure sample is required for analysis.</I>")
			else
				print_report(0, "UNKNOWN.")
			icon_state = "reagent_analyzer_failed"
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 15, 1)
		else
			icon_state = "reagent_analyzer_finished"
			print_report(1)
			playsound(src.loc, 'sound/machines/twobeep.ogg', 15, 1)
	sample_number++
	return

/obj/structure/machinery/reagent_analyzer/attack_hand(mob/user as mob)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still processing!"))
		return
	if(!sample)
		to_chat(user, SPAN_WARNING("The [src] is empty."))
		return
	to_chat(user, SPAN_NOTICE("You remove the [sample] from the [src]."))
	user.put_in_active_hand(sample)
	sample = null
	icon_state = "reagent_analyzer"
	return

/obj/structure/machinery/reagent_analyzer/proc/print_report(var/result, var/reason)
	var/obj/item/paper/report = new /obj/item/paper/(src.loc)
	report.name = "Analysis "
	report.icon_state = "paper_wy_words"
	if(result)
		var/datum/reagent/S = sample.reagents.reagent_list[1]
		report.name += "of [S.name]"
		report.info += "<center><img src = wylogo.png><HR><I><B>Official Weston-Yamada Document</B><BR>Automated A-XRF Report</I><HR><H2>Analysis of [S.name]</H2></center>"
		report.info += "<B>Results for sample</B> #[sample_number]:<BR>\n"
		report.info += "<B>ID:</B> <I>[S.name]</I><BR><BR>\n"
		report.info += "<B>Database Details:</B><BR>\n"
		if(S.chemclass >= CHEM_CLASS_ULTRA)
			if(clearance_level >= S.gen_tier)
				report.info += "<I>The following information relating to [S.name] is restricted with a level [S.gen_tier] clearance classification.</I><BR>"
				report.info += "<font size = \"2.5\">[S.description]</font>\n"
			else
				report.info += "CLASSIFIED:<I> Clearance level [S.gen_tier] required to read the database entry.</I><BR>\n"
		else if(S.chemclass >= CHEM_CLASS_SPECIAL)
			report.info += "CLASSIFIED:<I> Clearance level <B>X</B> required to read the database entry.</I><BR>\n"
		else if(S.description)
			report.info += "<BR><font size = \"2.5\">[S.description]</font><BR>\n"
		else
			report.info += "<I>No details on this reagent could be found in the database.</I><BR>\n"
		if(S.chemclass >= CHEM_CLASS_SPECIAL && !chemical_identified_list[S.id])
			report.info += "<BR><I>Saved emission spectrum of [S.name] to the database.</I><BR>\n"
			if(last_used)
				last_used.count_niche_stat(STATISTICS_NICHE_CHEMS)
			chemical_identified_list[S.id] = S.objective_value
			defcon_controller.check_defcon_level()
		report.info += "<BR><B>Composition Details:</B><BR>\n"
		if(chemical_reactions_list[S.id])
			var/datum/chemical_reaction/C = chemical_reactions_list[S.id]
			for(var/I in C.required_reagents)
				var/datum/reagent/R = chemical_reagents_list["[I]"]
				if(R.chemclass >= CHEM_CLASS_SPECIAL && !chemical_identified_list[R.id])
					report.info += "<font size = \"2\"><I> - Unknown emission spectrum</I></font><BR>\n"
				else
					var/U = C.required_reagents[I]
					report.info += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
			if(C.required_catalysts)
				if(C.required_catalysts.len)
					report.info += "<BR>Reaction would require the following catalysts:<BR>\n"
					for(var/I in C.required_catalysts)
						var/datum/reagent/R = chemical_reagents_list["[I]"]
						if(R.chemclass >= CHEM_CLASS_SPECIAL && !chemical_identified_list[R.id])
							report.info += "<font size = \"2\"><I> - Unknown emission spectrum</I></font><BR>\n"
						else
							var/U = C.required_catalysts[I]
							report.info += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
		else if(chemical_gen_classes_list["C1"].Find(S.id))
			report.info += "<font size = \"2\"><I> - [S.name]</I></font><BR>\n"
		else
			report.info += "<I>ERROR: Unable to analyze emission spectrum of sample.</I>" //A reaction to make this doesn't exist, so this is our IC excuse
		sample.name = "vial ([S.name])"
	else
		report.name += "ERROR"
		report.info += "<center><img src = wylogo.png><HR><I><B>Official Weston-Yamada Document</B><BR>Reagent Analysis Print</I><HR><H2>Analysis ERROR</H2></center>"
		report.info += "<B>Result:</B><BR>Analysis failed for sample #[sample_number].<BR><BR>\n"
		report.info += "<B>Reason for error:</B><BR><I>[reason]</I><BR>\n"
	report.info += "<BR><HR><font size = \"1\"><I>This report was automatically printed by the Advanced X-Ray Fluorescence Scanner.<BR>The USS Almayer,  [time2text(world.timeofday, "MM/DD")]/[game_year], [worldtime2text()]</I></font><BR>\n<span class=\"paper_field\"></span>"

/obj/structure/machinery/centrifuge
	name = "Chemical Centrifuge"
	desc = "A machine that uses centrifugal forces to separate fluids of different densities. Needs a reagent container for input and a vialbox for output."
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "centrifuge_empty_open"
	active_power_usage = 500

	var/obj/item/reagent_container/glass/input_container = null //Our input beaker
	var/obj/item/storage/fancy/vials/output_container //Contains vials for the output

	var/processing = 0
	var/status = 0

/obj/structure/machinery/centrifuge/attackby(obj/item/B, mob/living/user)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still running!"))
		return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(B.is_open_container() || istype(B, /obj/item/reagent_container/blood))
		if(input_container)
			to_chat(user, SPAN_WARNING("A container is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			input_container = B
			if(output_container)
				icon_state = "centrifuge_on_closed"
			else
				icon_state = "centrifuge_on_open"
	else if(istype(B, /obj/item/storage/fancy/vials))
		if(output_container)
			to_chat(user, SPAN_WARNING("A vial box is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			output_container = B
			if(input_container)
				icon_state = "centrifuge_on_closed"
			else
				icon_state = "centrifuge_empty_closed"
	else
		to_chat(user, SPAN_WARNING("[B] doesn't fit in the [src]."))
		return
	if(input_container && output_container)
		to_chat(user, SPAN_NOTICE("You insert [B] and start configuring the [src]."))
		updateUsrDialog()
		if(!do_after(user, 15, INTERRUPT_ALL, BUSY_ICON_GENERIC)) return
		icon_state = "centrifuge_spinning"
		processing = 1
		playsound(src.loc, 'sound/machines/centrifuge.ogg', 30)
		start_processing()
	else
		to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))

/obj/structure/machinery/centrifuge/attack_hand(mob/user as mob)
	if(processing)
		to_chat(user, SPAN_WARNING("The [src] is still running!"))
		return
	if(!input_container && !output_container)
		to_chat(user, SPAN_WARNING("The [src] is empty."))
		return
	if(output_container)
		to_chat(user, SPAN_NOTICE("You remove the [output_container] from the [src]."))
		user.put_in_active_hand(output_container)
		output_container = null
		if(input_container)
			icon_state = "centrifuge_on_open"
		else
			icon_state = "centrifuge_empty_open"
	else if(input_container)
		to_chat(user, SPAN_NOTICE("You remove the [input_container] from the [src]."))
		user.put_in_active_hand(input_container)
		input_container = null
		icon_state = "centrifuge_empty_open"
	return

/obj/structure/machinery/centrifuge/process()
	status++
	if(status <= 1)
		centrifuge()
	if(status >= 2)
		status = 0
		processing = 0
		icon_state = "centrifuge_finish"
		stop_processing()
		return

/obj/structure/machinery/centrifuge/proc/centrifuge()
	if(!output_container.contents.len) return //Is output empty?

	var/initial_reagents = input_container.reagents.reagent_list.len
	var/list/vials = list()
	for(var/obj/item/reagent_container/glass/beaker/vial/V in output_container.contents)
		vials += V

	//Split reagent types best possible, if we have move volume that types available, split volume best possible
	if(initial_reagents)
		for(var/datum/reagent/R in input_container.reagents.reagent_list)

			//A filter mechanic for QoL, as you'd never want multiple full vials with the same reagent. Lets players use impure vials as filters.
			var/filter = 0
			for(var/obj/item/reagent_container/glass/beaker/vial/V in vials)
				if(V.reagents.has_reagent(R.id))
					if(V.reagents.reagent_list.len > 1 || V.reagents.total_volume == V.reagents.maximum_volume) //If the reagent is in an impure vial, or a full vial, we skip it
						filter = 1
						break
			if(filter) continue

			for(var/obj/item/reagent_container/glass/beaker/vial/V in vials)
				//Check the vial
				if(V.reagents.reagent_list.len > 1) //We don't work with impure vials
					continue
				if(V.reagents.get_reagents() && !V.reagents.has_reagent(R.id)) //We only add to vials with the same reagent
					continue
				if(V.reagents.total_volume == V.reagents.maximum_volume) //The vial is full
					continue

				//Calculate how much we are transfering
				var/amount_to_transfer = V.reagents.maximum_volume - V.reagents.total_volume
				if(R.volume < amount_to_transfer)
					amount_to_transfer = R.volume

				//Transfer to the vial
				V.reagents.add_reagent(R.id,amount_to_transfer,R.data)
				input_container.reagents.remove_reagent(R.id,amount_to_transfer)
				V.update_icon()

				break //Continue to next reagent

	//Label the vials
	for(var/obj/item/reagent_container/glass/beaker/vial/V in vials)
		if(!(V.reagents.reagent_list.len) || (V.reagents.reagent_list.len > 1))
			V.name = "vial"
		else
			V.name = "vial (" + V.reagents.reagent_list[1].name + ")"

	input_container.update_icon()
	output_container.contents = vials

#define PROGRAM_MEMORY 			1
#define PROGRAM_BOX 			2

/obj/structure/machinery/autodispenser
	name = "Turing Dispenser"
	desc = "A chem dispenser variant that can not be operated manually, but will instead automatically dispense chemicals based on a program of chemicals, loaded using a vial box. Despite having a digital screen the machine is mostly analog."
	icon = 'icons/obj/structures/machinery/chemical_machines.dmi'
	icon_state = "autodispenser_empty_open"
	active_power_usage = 40
	layer = BELOW_OBJ_LAYER
	density = 1

	var/obj/item/storage/fancy/vials/input_container //Contains vials for our program
	var/obj/item/reagent_container/glass/output_container //Our output beaker
	var/obj/structure/machinery/smartfridge/chemistry/linked_storage //Where we take chemicals from

	var/list/programs = list(list(),list()) //the program of chem datums to dispense, 1 = memory, 2 = box
	var/list/program_amount = list(list(),list()) //how much to dispense with each program item, 1 = memory, 2 = box
	var/program = PROGRAM_BOX
	var/multiplier = 1
	var/energy = 100
	var/max_energy = 100
	var/recharge_delay = 0
	var/cycle_limit = 1 //
	var/cycle = 0
	var/stage = 1 //Remember where we are
	var/stage_missing = 0 //How much we have left to dispense, if we didn't have enough
	var/status = 0 //0 = idle, <0 = stuck, 1 = finished, 2 = running
	var/error //Error status message
	var/automode = FALSE
	var/smartlink = TRUE

/obj/structure/machinery/autodispenser/Initialize()
	..()
	spawn(7)
		linked_storage = locate(/obj/structure/machinery/smartfridge/chemistry,get_step(src, dir))
	start_processing()

/obj/structure/machinery/autodispenser/attackby(obj/item/B, mob/living/user)
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	if(istype(B, /obj/item/storage/fancy/vials))
		if(input_container)
			to_chat(user, SPAN_WARNING("A vial box is already loaded into the [src]."))
			return
		else if(status == 2)
			to_chat(user, SPAN_WARNING("You can't insert a box while the [src] is running."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			input_container = B
			if(output_container)
				if(!automode)
					icon_state = "autodispenser_idle"
			else
				icon_state = "autodispenser_empty_closed"
		get_program()
	else if(B.is_open_container())
		if(output_container)
			to_chat(user, SPAN_WARNING("A container is already loaded into the [src]."))
			return
		if(user.drop_inv_item_to_loc(B, src))
			output_container = B
			if(input_container)
				if(!automode)
					icon_state = "autodispenser_idle"
			else
				icon_state = "autodispenser_full_open"
	else
		to_chat(user, SPAN_WARNING("[B] doesn't fit in the [src]."))
		return
	to_chat(user, SPAN_NOTICE("You insert [B] into the [src]."))
	if(input_container && output_container)
		if(automode)
			run_program()
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/autodispenser/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER)) return
	if(!skillcheck(user, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
		to_chat(user, SPAN_WARNING("You have no idea how to use this."))
		return
	ui_interact(user)

/obj/structure/machinery/autodispenser/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 0)
	var/list/data = list(
		"status" = status,
		"energy" = energy,
		"status" = status,
		"error" = error,
		"multiplier" = multiplier,
		"cycle_limit" = cycle_limit,
		"automode" = automode,
		"linked_storage" = linked_storage,
		"smartlink" = smartlink
	)
	if(output_container)
		data["output_container"] = list(
			"name" = output_container.name,
			"total" = output_container.reagents.total_volume,
			"max" = output_container.reagents.maximum_volume
		)
	if(input_container)
		data["input_container"] = input_container.name
	if(program_amount[PROGRAM_MEMORY])
		data["memory"] = program_amount[PROGRAM_MEMORY]
	if(program_amount[PROGRAM_BOX])
		data["box"] = program_amount[PROGRAM_BOX]

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "autodispenser.tmpl", "Turing Dispenser Console", 600, 480)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/autodispenser/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER)) return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/user = usr
	if(user.stat || user.is_mob_restrained()) return
	if(!in_range(src, user)) return

	if(href_list["ejectI"])
		if(input_container)
			input_container.forceMove(loc)
			input_container = null
		programs[PROGRAM_BOX] = list()
		program_amount[PROGRAM_BOX] = list()
		stop_program()
	else if(href_list["ejectO"])
		if(output_container)
			output_container.forceMove(loc)
			output_container = null
		stop_program()
	else if(href_list["runprogram"])
		run_program()
	else if(href_list["saveprogram"])
		get_program(PROGRAM_MEMORY)
	else if(href_list["clearmemory"])
		programs[PROGRAM_MEMORY] = list()
		program_amount[PROGRAM_MEMORY] = list()
		program = PROGRAM_BOX
		stop_program()
	else if(href_list["dispose"])
		output_container.reagents.clear_reagents()
	else if(href_list["setmulti"])
		var/list/multipliers = list(0.5,1,2,3,4,5,6,10)
		var/M = input("Set multiplier:","[src]") as null|anything in multipliers
		if(M)
			multiplier = M
	else if(href_list["setcycle"])
		var/L = input("Set cycle limit:","[src]") as num
		if(L)
			cycle_limit = L
	else if(href_list["toggleauto"])
		automode = !automode
	else if(href_list["togglesmart"])
		smartlink = !smartlink

	nanomanager.update_uis(src) // update all UIs attached to src
	add_fingerprint(user)
	attack_hand(usr)
	return 1

/obj/structure/machinery/autodispenser/process()
	if(stat & (BROKEN|NOPOWER))
		return
	//We're always recharging
	if(energy < max_energy)
		if(recharge_delay <= 0)
			recharge()
		else
			recharge_delay--
		nanomanager.update_uis(src)

	if(status == 0 || status == 1) //Nothing to do
		return

	var/space = output_container.reagents.maximum_volume - output_container.reagents.total_volume
	if(!space || cycle >= cycle_limit) //We done boys
		stop_program(1)
		icon_state = "autodispenser_full"
		nanomanager.update_uis(src)
		return

	for(var/i=stage,i<=programs[1].len + programs[2].len && i != 0,i++)
		if(status < 0) //We're waiting for new chems to be stored
			status++
			if(status == 0)
				status = 2
				icon_state = "autodispenser_running"
				nanomanager.update_uis(src)
			else
				break

		var/datum/reagent/R = programs[program][stage]
		var/amount
		if(stage_missing)
			amount = stage_missing
		else
			amount = min(program_amount[program]["[R.name]"] * multiplier, space)

		//Check and use stored chemicals first. This doesn't consume energy.
		if(smartlink && linked_storage)
			var/skip
			for(var/obj/item/reagent_container/C in linked_storage.contents)
				var/O = C.reagents.get_reagent_amount(R.id)
				if(O)
					//Check if there's enough and note if there isn't, then transfer
					if(O < amount)
						stage_missing = amount - O
						amount = stage_missing
					else
						stage_missing = 0

					C.reagents.trans_to(output_container,amount)
					//We don't care about keeping empty bottles stored
					if(C.reagents.total_volume <= 0 && istypestrict(C,/obj/item/reagent_container/glass/bottle))
						linked_storage.item_quants[C.name]--
						qdel(C) //Might want to connect it to a disposal system later instead

					if(!stage_missing)
						next_stage()
						skip = TRUE
						break
			if(skip) continue
		if(R.chemclass != CHEM_CLASS_BASIC && R.chemclass != CHEM_CLASS_COMMON)
			//We have to wait until the chem is stored
			icon_state = "autodispenser_stuck"
			error = R.name + " NOT FOUND"
			status = -5
			nanomanager.update_uis(src)
		else //We can dispense any basic or common chemical directly. This does use energy as we're creating stuff from thin air
			//Check if we have enough energy to afford dispensing
			var/savings = max(energy - min(amount, energy * 10) / 10, 0)
			if(savings < 0) //Check if we can afford dispensing the chemical
				break
			output_container.reagents.add_reagent(R.id,amount)
			energy = savings
			stage_missing = 0
			next_stage()

/obj/structure/machinery/autodispenser/proc/get_program(var/save_to = PROGRAM_BOX)
	for(var/obj/item/reagent_container/glass/beaker/vial/V in input_container.contents)
		if(!V.reagents.get_reagents()) //Ignore empty vials
			continue
		if(V.reagents.reagent_list.len > 1) //We don't work with impure vials
			continue
		var/datum/reagent/R = V.reagents.reagent_list[1]
		if(program_amount[save_to]["[R.name]"])
			program_amount[save_to]["[R.name]"] += V.reagents.total_volume
		else
			programs[save_to] += R
			var/list/L[0]
			L["[R.name]"] = V.reagents.total_volume
			program_amount[save_to] += L

/obj/structure/machinery/autodispenser/proc/recharge()
	energy = min(energy + 10, max_energy)
	recharge_delay = 10 //a 3rd faster than the manual dispenser
	use_power(1500)

/obj/structure/machinery/autodispenser/proc/run_program()
	if(programs[PROGRAM_MEMORY].len)
		program = PROGRAM_MEMORY
	else
		program = PROGRAM_BOX
	if(programs[program].len && output_container)
		status = 2
		icon_state = "autodispenser_running"
	else
		stop_program()

/obj/structure/machinery/autodispenser/proc/next_stage()
	stage++
	if(stage > programs[program].len) //End of program
		if(programs[PROGRAM_MEMORY].len && programs[PROGRAM_BOX].len)
			if(program == PROGRAM_BOX)
				cycle++
				program--
			else
				program++
		else
			cycle++
		stage = 1

/obj/structure/machinery/autodispenser/proc/stop_program(var/set_status = 0)
	stage = 1
	cycle = 0
	stage_missing = 0
	error = 0
	status = set_status
	if(input_container && output_container)
		icon_state = "autodispenser_idle"
	else if(input_container && !output_container)
		icon_state = "autodispenser_empty_closed"
	else if(output_container && !input_container)
		icon_state = "autodispenser_full_open"
	else
		icon_state = "autodispenser_empty_open"

#undef PROGRAM_MEMORY
#undef PROGRAM_BOX