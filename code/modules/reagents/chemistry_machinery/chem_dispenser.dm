/obj/structure/machinery/chem_dispenser
	name = "chem dispenser"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "dispenser"
	use_power = USE_POWER_NONE
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
	var/static/list/possible_transfer_amounts = list(5,10,20,30,40)
	var/list/dispensable_reagents = list("hydrogen","lithium","carbon","nitrogen","oxygen","fluorine",
	"sodium","aluminum","silicon","phosphorus","sulfur","chlorine","potassium","iron",
	"copper","mercury","radium","water","ethanol","sugar","sulphuric acid")

/obj/structure/machinery/chem_dispenser/medbay
	network = "Medbay"

/obj/structure/machinery/chem_dispenser/research
	network = "Research"

/obj/structure/machinery/chem_dispenser/process()
	if(!chem_storage)
		chem_storage = chemical_data.connect_chem_storage(network)

/obj/structure/machinery/chem_dispenser/Initialize()
	. = ..()
	dispensable_reagents = sortList(dispensable_reagents)
	start_processing()

/obj/structure/machinery/chem_dispenser/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

/obj/structure/machinery/chem_dispenser/update_icon()
	. = ..()
	overlays.Cut()
	if(beaker)
		overlays += "+beaker[rand(1, 5)]"
		if(!inoperable())
			overlays += "+onlight"

/obj/structure/machinery/chem_dispenser/on_stored_atom_del(atom/movable/AM)
	if(AM == beaker)
		beaker = null

/obj/structure/machinery/chem_dispenser/proc/replace_beaker(mob/living/user, obj/item/reagent_container/new_beaker)
	if(beaker)
		beaker.forceMove(src.loc)
		if(user && Adjacent(user))
			user.put_in_hands(beaker)
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
	update_icon()
	SStgui.update_uis(src)
	return TRUE

/obj/structure/machinery/chem_dispenser/clicked(mob/user, list/mods)
	if(mods["alt"])
		if(!CAN_PICKUP(user, src))
			return ..()
		replace_beaker(user)
	return ..()

// TGUI \\


/obj/structure/machinery/chem_dispenser/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE

/obj/structure/machinery/chem_dispenser/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", name)
		ui.open()

/obj/structure/machinery/chem_dispenser/ui_static_data(mob/user)
	. = list()
	.["beakerTransferAmounts"] = possible_transfer_amounts

/obj/structure/machinery/chem_dispenser/ui_data(mob/user)
	. = list()
	.["amount"] = amount
	.["energy"] = round(chem_storage.energy)
	.["maxEnergy"] = round(chem_storage.max_energy)
	.["isBeakerLoaded"] = beaker ? 1 : 0

	var/list/beakerContents = list()
	var/beakerCurrentVolume = 0
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = R.name, "volume" = R.volume))  // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	.["beakerContents"] = beakerContents

	if (beaker)
		.["beakerCurrentVolume"] = beakerCurrentVolume
		.["beakerMaxVolume"] = beaker.volume
	else
		.["beakerCurrentVolume"] = null
		.["beakerMaxVolume"] = null

	var/list/chemicals = list()
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			var/chemname = temp.name
			chemicals.Add(list(list("title" = chemname, "id" = temp.id)))
	.["chemicals"] = chemicals

/obj/structure/machinery/chem_dispenser/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("amount")
			if(inoperable() || QDELETED(beaker))
				return
			var/target = text2num(params["target"])
			if(target in possible_transfer_amounts)
				amount = target
				. = TRUE
		if("dispense")
			if(inoperable() || QDELETED(beaker))
				return
			var/reagent_name = params["reagent"]
			if(beaker && dispensable_reagents.Find(reagent_name))
				var/obj/item/reagent_container/B = beaker
				var/datum/reagents/R = B.reagents
				var/space = R.maximum_volume - R.total_volume

				R.add_reagent(reagent_name, min(amount, chem_storage.energy * 10, space))
				chem_storage.energy = max(chem_storage.energy - min(amount, chem_storage.energy * 10, space) / 10, 0)

			. = TRUE

		if("remove")
			if(inoperable())
				return
			var/amount = text2num(params["amount"])
			if(beaker && (amount in possible_transfer_amounts))
				beaker.reagents.remove_any(amount)
				. = TRUE

		if("eject")
			replace_beaker(usr)
			. = TRUE

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
			SStgui.update_uis(src)
		update_icon()
		return

/obj/structure/machinery/chem_dispenser/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/chem_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use this."))
		return
	tgui_interact(user)

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
	dispensable_reagents = list(
		"water",
		"ice",
		"coffee",
		"cream",
		"tea",
		"cola",
		"spacemountainwind",
		"dr_gibb",
		"space_up",
		"tonic",
		"sodawater",
		"lemon_lime",
		"sugar",
		"orangejuice",
		"limejuice",
		"watermelonjuice",
		"tomatojuice",
		"carrotjuice",
		"berryjuice",
		"grapejuice",
		"lemonjuice",
		"banana",
	)
	var/hackedcheck = 0

/obj/structure/machinery/chem_dispenser/soda/attackby(obj/item/B as obj, mob/user as mob)
	..()
	if(HAS_TRAIT(B, TRAIT_TOOL_MULTITOOL))
		if(hackedcheck == 0)
			to_chat(user, "You change the mode from 'Soda Magic' to 'Milking Time'.")
			dispensable_reagents += list("milk","soymilk")
			hackedcheck = 1
			return

		else
			to_chat(user, "You change the mode from 'Milking Time' to 'Soda Magic'.")
			dispensable_reagents -= list("milk","soymilk")
			hackedcheck = 0
			return
	else if(HAS_TRAIT(B, TRAIT_TOOL_WRENCH))
		if(!wrenchable) return

		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!src) return
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			switch (anchored)
				if (FALSE)
					anchored = TRUE
					user.visible_message("[user] tightens the bolts securing \the [src] to the surface.", "You tighten the bolts securing \the [src] to the surface.")
				if (TRUE)
					user.visible_message("[user] unfastens the bolts securing \the [src] to the surface.", "You unfasten the bolts securing \the [src] to the surface.")
					anchored = FALSE
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
	dispensable_reagents = list("water","ice","sodawater","sugar","tonic","beer","kahlua","whiskey","sake","wine","vodka","gin","rum","vermouth","cognac","ale","mead","thirteenloko","tequila")
	var/hackedcheck = 0

/obj/structure/machinery/chem_dispenser/beer/attackby(obj/item/B as obj, mob/user as mob)
	..()

	if(HAS_TRAIT(B, TRAIT_TOOL_MULTITOOL))
		if(hackedcheck == 0)
			to_chat(user, "You disable the 'Weyland-Yutani-are-cheap-bastards' lock, enabling hidden and very expensive boozes.")
			dispensable_reagents += list("goldschlager","patron","absinthe")
			hackedcheck = 1
			return

		else
			to_chat(user, "You re-enable the 'Weyland-Yutani-are-cheap-bastards' lock, disabling hidden and very expensive boozes.")
			dispensable_reagents -= list("goldschlager","patron","absinthe")
			hackedcheck = 0
			return
	else if(HAS_TRAIT(B, TRAIT_TOOL_WRENCH))
		if(!wrenchable) return

		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(!src) return
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			switch (anchored)
				if (FALSE)
					anchored = TRUE
					user.visible_message("[user] tightens the bolts securing \the [src] to the surface.", "You tighten the bolts securing \the [src] to the surface.")
				if (TRUE)
					user.visible_message("[user] unfastens the bolts securing \the [src] to the surface.", "You unfasten the bolts securing \the [src] to the surface.")
					anchored = FALSE
		return
