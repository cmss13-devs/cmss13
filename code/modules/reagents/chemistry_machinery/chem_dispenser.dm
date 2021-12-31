/obj/structure/machinery/chem_dispenser
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "dispenser"
	use_power = 0
	idle_power_usage = 40
	layer = BELOW_OBJ_LAYER //So beakers reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_DOCTOR
	var/ui_title = "Chem Dispenser 5000"
	var/obj/structure/machinery/chem_storage/chem_storage
	var/network = "Ground"
	var/amount = 30
	var/accept_glass = 0 //At 0 ONLY accepts glass containers. Kinda misleading varname.
	var/obj/item/reagent_container/beaker = null
	var/ui_check = 0
	var/list/dispensable_reagents = list("hydrogen","lithium","carbon","nitrogen","oxygen","fluorine",
	"sodium","aluminum","silicon","phosphorus","sulfur","chlorine","potassium","iron",
	"copper","mercury","radium","water","ethanol","sugar","sacid")

/obj/structure/machinery/chem_dispenser/medbay
	network = "Medbay"

/obj/structure/machinery/chem_dispenser/research
	network = "Research"

/obj/structure/machinery/chem_dispenser/power_change()
	..()
	nanomanager.update_uis(src) // update all UIs attached to src

/obj/structure/machinery/chem_dispenser/process()
	if(!chem_storage)
		chem_storage = chemical_data.connect_chem_storage(network)
	if(ui_check <= 0)
		nanomanager.update_uis(src) // update all UIs attached to src
		ui_check = 15
	else
		ui_check -= 1

/obj/structure/machinery/chem_dispenser/Initialize()
	. = ..()
	dispensable_reagents = sortList(dispensable_reagents)
	start_processing()

/obj/structure/machinery/chem_dispenser/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
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
	if(inoperable() || !chem_storage)
		return
	if(user.stat || user.is_mob_restrained())
		return

	// this is the data which will be sent to the ui
	var/list/data = list(
		"amount" = amount,
		"energy" = round(chem_storage.energy),
		"maxEnergy" = round(chem_storage.max_energy),
		"isBeakerLoaded" = istype(beaker),
		"glass" = accept_glass
	)
	var beakerContents[0]
	var beakerCurrentVolume = 0
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if(beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker.volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var chemicals[0]
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "chem_dispenser.tmpl", ui_title, 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/structure/machinery/chem_dispenser/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable())
		return FALSE // don't update UIs attached to this object

	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		if(amount < 0) // Since the user can actually type the commands himself, some sanity checking
			amount = 0
		if(amount > 240)
			amount = 240

	if(href_list["dispense"])
		if(dispensable_reagents.Find(href_list["dispense"]) && beaker != null && (beaker.is_open_container() || beaker.flags_atom & CAN_BE_DISPENSED_INTO))
			var/obj/item/reagent_container/B = beaker
			var/datum/reagents/R = B.reagents
			var/space = R.maximum_volume - R.total_volume

			R.add_reagent(href_list["dispense"], min(amount, chem_storage.energy * 10, space))
			chem_storage.energy = max(chem_storage.energy - min(amount, chem_storage.energy * 10, space) / 10, 0)

	if(href_list["ejectBeaker"])
		if(!beaker)
			return FALSE

		if(!Adjacent(usr) || !usr.put_in_hands(beaker))
			beaker.forceMove(loc)
		beaker = null

	add_fingerprint(usr)
	attack_hand(usr)
	return TRUE // update UIs attached to this object

/obj/structure/machinery/chem_dispenser/attackby(obj/item/reagent_container/B, mob/user)
	if(isrobot(user))
		return
	if(istype(B, /obj/item/reagent_container/glass) || istype(B, /obj/item/reagent_container/food))
		if(!accept_glass && istype(B,/obj/item/reagent_container/food))
			to_chat(user, SPAN_NOTICE("This machine only accepts beakers"))
		if(user.drop_inv_item_to_loc(B, src))
			var/obj/item/old_beaker = beaker
			beaker = B
			if(old_beaker)
				to_chat(user, SPAN_NOTICE("You swap out \the [old_beaker] for \the [B]."))
				user.put_in_hands(old_beaker)
			else
				to_chat(user, SPAN_NOTICE("You set \the [B] on the machine."))
			nanomanager.update_uis(src) // update all UIs attached to src
		return

/obj/structure/machinery/chem_dispenser/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/chem_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use this."))
		return
	ui_interact(user)

/obj/structure/machinery/chem_dispenser/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	ui_title = "Soda Dispens-o-matic"
	req_skill = null
	req_skill_level = null
	accept_glass = 1
	wrenchable = TRUE
	network = "Misc"
	dispensable_reagents = list("water","ice","coffee","cream","tea","icetea","cola","spacemountainwind","dr_gibb","space_up","tonic","sodawater","lemon_lime","sugar","orangejuice","limejuice","watermelonjuice")
	var/hackedcheck = 0

/obj/structure/machinery/chem_dispenser/soda/attackby(var/obj/item/B as obj, var/mob/user as mob)
	..()
	if(HAS_TRAIT(B, TRAIT_TOOL_MULTITOOL))
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
	req_skill = null
	req_skill_level = null
	accept_glass = 1
	wrenchable = TRUE
	network = "Misc"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list("lemon_lime","sugar","orangejuice","limejuice","sodawater","tonic","beer","kahlua","whiskey","sake","wine","vodka","gin","rum","tequilla","vermouth","cognac","ale","mead")
	var/hackedcheck = 0

/obj/structure/machinery/chem_dispenser/beer/attackby(var/obj/item/B as obj, var/mob/user as mob)
	..()

	if(HAS_TRAIT(B, TRAIT_TOOL_MULTITOOL))
		if(hackedcheck == 0)
			to_chat(user, "You disable the 'Weyland-Yutani-are-cheap-bastards' lock, enabling hidden and very expensive boozes.")
			dispensable_reagents += list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 1
			return

		else
			to_chat(user, "You re-enable the 'Weyland-Yutani-are-cheap-bastards' lock, disabling hidden and very expensive boozes.")
			dispensable_reagents -= list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 0
			return
