#define DISPENSER_UNHACKABLE -1
#define DISPENSER_NOT_HACKED 0
#define DISPENSER_HACKED 1

/obj/structure/machinery/chem_dispenser
	name = "chemical dispenser"
	desc = "A complex machine for mixing elements into chemicals. A Wey-Yu product."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/machinery/science_machines.dmi'
	icon_state = "dispenser"
	use_power = USE_POWER_NONE
	wrenchable = FALSE
	idle_power_usage = 40
	layer = BELOW_OBJ_LAYER //So beakers reliably appear above it
	var/req_skill = SKILL_MEDICAL
	var/req_skill_level = SKILL_MEDICAL_DOCTOR
	var/ui_title = "Chem Dispenser 5000"
	var/obj/structure/machinery/chem_storage/chem_storage
	var/network = "Ground"
	var/amount = 30
	var/accept_beaker_only = TRUE
	var/pressurized_only = FALSE
	var/obj/item/reagent_container/beaker = null
	var/ui_check = 0
	var/static/list/possible_transfer_amounts = list(5,10,20,30,40)
	var/list/dispensable_reagents = list(
		"hydrogen",
		"lithium",
		"carbon",
		"nitrogen",
		"oxygen",
		"fluorine",
		"sodium",
		"aluminum",
		"silicon",
		"phosphorus",
		"sulfur",
		"chlorine",
		"potassium",
		"iron",
		"copper",
		"mercury",
		"radium",
		"water",
		"ethanol",
		"sugar",
		"sulphuric acid",
	)
	/// Has it been hacked
	var/hacked_check = DISPENSER_UNHACKABLE
	/// Additional reagents gotten when it is hacked
	var/hacked_reagents = list()

/obj/structure/machinery/chem_dispenser/medbay
	network = "Medbay"

/obj/structure/machinery/chem_dispenser/research
	network = "Research"

/obj/structure/machinery/chem_dispenser/process()
	if(!chem_storage)
		chem_storage = GLOB.chemical_data.connect_chem_storage(network)

/obj/structure/machinery/chem_dispenser/Initialize()
	. = ..()
	dispensable_reagents = sortList(dispensable_reagents)
	start_processing()

/obj/structure/machinery/chem_dispenser/Destroy()
	if(!chem_storage)
		chem_storage = GLOB.chemical_data.disconnect_chem_storage(network)
	return ..()

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

/obj/structure/machinery/chem_dispenser/corpsman/update_icon()
	if(stat & BROKEN)
		icon_state = (beaker ? "mixer1_b" : "mixer0_b")
	else if(stat & NOPOWER)
		icon_state = (beaker ? "[base_state]1_nopower" : "[base_state]0_nopower")
	else
		icon_state = (beaker ? "[base_state]1" : "[base_state]0")

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
	if(mods[ALT_CLICK])
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
	.["energy"] = floor(chem_storage.energy)
	.["maxEnergy"] = floor(chem_storage.max_energy)
	.["isBeakerLoaded"] = beaker ? 1 : 0

	var/list/beakerContents = list()
	var/beakerCurrentVolume = 0
	if(beaker && beaker.reagents && length(beaker.reagents.reagent_list))
		for(var/datum/reagent/current_reagent in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = current_reagent.name, "volume" = current_reagent.volume))  // list in a list because Byond merges the first list...
			beakerCurrentVolume += current_reagent.volume
	.["beakerContents"] = beakerContents

	if (beaker)
		.["beakerCurrentVolume"] = beakerCurrentVolume
		.["beakerMaxVolume"] = beaker.volume
	else
		.["beakerCurrentVolume"] = null
		.["beakerMaxVolume"] = null

	var/list/chemicals = list()
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
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
				var/obj/item/reagent_container/current_beaker = beaker
				var/datum/reagents/current_reagent = current_beaker.reagents
				var/space = current_reagent.maximum_volume - current_reagent.total_volume

				current_reagent.add_reagent(reagent_name, min(amount, chem_storage.energy * 10, space))
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

/obj/structure/machinery/chem_dispenser/attackby(obj/item/reagent_container/attacking_object, mob/user)
	if(istype(attacking_object, /obj/item/reagent_container/glass) || istype(attacking_object, /obj/item/reagent_container/food))
		if(accept_beaker_only && istype(attacking_object,/obj/item/reagent_container/food))
			to_chat(user, SPAN_NOTICE("This machine only accepts beakers"))
			return
		if(pressurized_only && !istype(attacking_object, /obj/item/reagent_container/glass/pressurized_canister))
			to_chat(user, SPAN_NOTICE("This machine only accepts pressurized canisters"))
			return
		if(user.drop_inv_item_to_loc(attacking_object, src))
			var/obj/item/old_beaker = beaker
			beaker = attacking_object
			if(old_beaker)
				to_chat(user, SPAN_NOTICE("You swap out [old_beaker] for [attacking_object]."))
				user.put_in_hands(old_beaker)
			else
				to_chat(user, SPAN_NOTICE("You set [attacking_object] on the machine."))
			SStgui.update_uis(src)
		update_icon()
		return

	if(HAS_TRAIT(attacking_object, TRAIT_TOOL_MULTITOOL))
		switch(hacked_check)
			if(DISPENSER_UNHACKABLE)
				to_chat(user, SPAN_NOTICE("[src] cannot be hacked."))
			if(DISPENSER_NOT_HACKED)
				user.visible_message("[user] modifies [src] with [attacking_object], turning a light on.", "You enable a light in [src].")
				dispensable_reagents += hacked_reagents
				hacked_check = DISPENSER_HACKED
			if(DISPENSER_HACKED)
				user.visible_message("[user] modifies [src] with [attacking_object], turning a light off.", "You disable a light in [src].")
				dispensable_reagents -= hacked_reagents
				hacked_check = DISPENSER_NOT_HACKED

	if(HAS_TRAIT(attacking_object, TRAIT_TOOL_WRENCH))
		if(!wrenchable)
			to_chat(user, "[src] cannot be unwrenched.")
			return

		if(!do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return
		if(!src)
			return

		playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
		anchored = !anchored
		if(anchored)
			user.visible_message("[user] tightens the bolts securing [src] to the surface.", "You tighten the bolts securing [src] to the surface.")
			return

		user.visible_message("[user] unfastens the bolts securing [src] to the surface.", "You unfasten the bolts securing [src] to the surface.")

/obj/structure/machinery/chem_dispenser/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/chem_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("[src] is inoperative."))
		return
	if(req_skill && !skillcheck(user, req_skill, req_skill_level))
		to_chat(user, SPAN_WARNING("You don't have the training to use [src]."))
		return
	tgui_interact(user)

/obj/structure/machinery/chem_dispenser/corpsman
	name = "pressurized chemical dispenser"
	desc = "A more basic chemical dispenser, designed for use with pressurized reagent canisters. A Wey-Yu product."
	icon_state = "mixer0"
	ui_title = "Chem Dispenser 4000"
	req_skill_level = SKILL_MEDICAL_MEDIC
	accept_beaker_only = FALSE
	pressurized_only = TRUE
	dispensable_reagents = list(
		"bicaridine",
		"kelotane",
		"anti_toxin",
		"dexalin",
		"dexalinp",
		"inaprovaline",
		"adrenaline",
		"peridaxon",
		"tramadol",
		"oxycodone",
		"tricordrazine",
	)

	var/base_state = "mixer"

/obj/structure/machinery/chem_dispenser/yauja

	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	breakable = FALSE

/obj/structure/machinery/chem_dispenser/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	ui_title = "Soda Dispens-o-matic"
	req_skill = null
	req_skill_level = null
	accept_beaker_only = FALSE
	wrenchable = TRUE
	network = "Misc"
	hacked_check = DISPENSER_NOT_HACKED
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
	hacked_reagents = list(
		"milk",
		"soymilk",
	)

/obj/structure/machinery/chem_dispenser/soda/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	breakable = FALSE

/obj/structure/machinery/chem_dispenser/soda/beer
	icon_state = "booze_dispenser"
	name = "booze dispenser"
	ui_title = "Booze Portal 9001"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list(
		"water",
		"ice",
		"sodawater",
		"sugar",
		"tonic",
		"beer",
		"kahlua",
		"whiskey",
		"sake",
		"wine",
		"vodka",
		"gin",
		"rum",
		"vermouth",
		"cognac",
		"ale",
		"mead",
		"thirteenloko",
		"tequila",
	)
	hacked_reagents = list(
		"goldschlager",
		"patron",
		"absinthe",
	)

/obj/structure/machinery/chem_dispenser/soda/beer/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	breakable = FALSE

#undef DISPENSER_UNHACKABLE
#undef DISPENSER_NOT_HACKED
#undef DISPENSER_HACKED
