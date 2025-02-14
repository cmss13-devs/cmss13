
/obj/structure/machinery/computer/ordnance
	name = "ordnance data terminal"
	desc = "A terminal for accessing ordnance technology data."
	icon_state = "engineering_terminal"
	var/list/jobs_allowed = list(JOB_ORDNANCE_TECH, JOB_SYNTH, JOB_CHIEF_ENGINEER)

/obj/structure/machinery/computer/ordnance/Initialize()
	. = ..()
	GLOB.ordnance_research.photocopier = locate(/obj/structure/machinery/photocopier) in range(2, src)

//TGUI stuff

/obj/structure/machinery/computer/ordnance/attack_hand(mob/user as mob)
	var/mob/living/carbon/human/player = user
	if(!jobs_allowed.Find(player.job))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	tgui_interact(user)

/obj/structure/machinery/computer/ordnance/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OrdnanceTerminal", name)
		ui.open()

/obj/structure/machinery/computer/ordnance/ui_data(mob/user)
	var/list/data = list()
	data["credits"] = GLOB.ordnance_research.technology_credits
	data["tech_upgrades"] = list()
	data["categories"] = list()

	for(var/tech_type in subtypesof(/datum/ordnance_tech))
		var/datum/ordnance_tech/tech = tech_type
		if(tech.add_category)
			data["categories"] += tech.name
			continue
		data["tech_upgrades"] += list(list(
			"name" = capitalize_first_letters(tech.name),
			"desc" = tech.desc,
			"cost" = tech.value,
			"ref" = tech_type,
			"category" = tech.item_type,
		))
	return data

/obj/structure/machinery/computer/ordnance/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("buy")
			var/to_print = text2path(params["ref"])
			start_print_tech(to_print, usr)

//printing items/tech

/obj/structure/machinery/computer/ordnance/proc/start_print_tech(tech_path, mob/user)
	if(stat & NOPOWER)
		return
	var/path_exists = FALSE
	var/datum/ordnance_tech/tech
	var/tech_datums
	for(tech_datums in subtypesof(/datum/ordnance_tech))
		tech = tech_datums
		if(tech.add_category)
			continue
		if(tech_path == tech_datums)
			path_exists = TRUE
			break
	if(!path_exists)
		to_chat(user, SPAN_WARNING("[src] beeps loudly and makes some smoke before powering down."))
		return
	var/datum/ordnance_tech/dupe_check = tech_path
	if(GLOB.ordnance_research.tech_bought.Find(dupe_check.name))
		to_chat(user, SPAN_WARNING("Technology already researched!"))
		return
	if(tech.value > GLOB.ordnance_research.technology_credits)
		to_chat(user, SPAN_WARNING("[src] beeps and flashes red, theres not enough credits to aquire this technology!"))
		return
	GLOB.ordnance_research.update_credits(-(tech.value))
	if(!tech.can_rebuy)
		GLOB.ordnance_research.tech_bought += tech.name
	print_tech(tech_path)

/obj/structure/machinery/computer/ordnance/proc/print_tech(tech_path)
	var/datum/ordnance_tech/item = new tech_path()
	item.purchase(loc)


