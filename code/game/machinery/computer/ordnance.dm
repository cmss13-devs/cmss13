GLOBAL_DATUM_INIT(ordnance_research, /datum/ordnance_research, new)

/datum/ordnance_research
	var/technology_credits = 5 //this means we start with 10 since credits_to_allocate also happens at round start
	/// amount of credits earned every 10 minutes
	var/credits_to_allocate = 5
	/// technology bought so far
	var/list/tech_bought = list()

/datum/ordnance_research/proc/update_credits(change)
	technology_credits = max(0, technology_credits + change)

/datum/ordnance_research/proc/save_new_tech(tech)
	return

//the actual items

/obj/item/ordnance/tech_disk
	name = "you aren't supposed to have this"
	desc = "Insert this in an armylathe or, if applicable, a dropship part fabricator to obtain this technology"
	icon = 'icons/obj/items/disk.dmi'
	w_class = SIZE_TINY
	icon_state = "datadisk1"
	/// stuff that this unlocks when put in a lathe
	var/list/tech = list()

/obj/item/ordnance/data_analyzer
	name = "explosive data analyzer"
	desc = "Limits casing capacity but analyzes the explosion caused and the amount of targets hit, granting ordnance technology credits. Cannot be removed once attached."
	w_class = SIZE_TINY
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "eftpos"
	///amount of credits to reward per mob hit
	var/credits_to_award = 2
	///amount of max_container_volume to remove when attached, 2x if above casing_cutoff_point
	var/base_remove_amount = 30
	///point at which base_remove_amount is doubled
	var/casing_cutoff_point = 200
	///explosive we are attached to
	var/obj/item/explosive/attached
	///mobs hit
	var/list/mobs_hit = list()

/obj/item/ordnance/data_analyzer/ex_act(severity, explosion_direction)
	return

/obj/item/ordnance/data_analyzer/proc/apply_casing_limit(obj/item/explosive/item)
	if(!item.customizable)
		return
	if(item.max_container_volume <= casing_cutoff_point)
		item.max_container_volume = max(item.max_container_volume - base_remove_amount, 0)
	else
		item.max_container_volume = max(item.max_container_volume - base_remove_amount*2, 0)

/obj/item/ordnance/data_analyzer/proc/add_mob(mob/mob)
	if(mob.stat == DEAD)
		return
	if(mobs_hit.Find(mob))
		return
	if(ismonkey(mob)) //no farming points with monkeys
		return
	mobs_hit += mob
	beam(mob, "b_beam", time = 0.8 SECONDS)

//gives 5 seconds for the explosion to finish before sending credits
/obj/item/ordnance/data_analyzer/proc/activate()
	addtimer(CALLBACK(src, PROC_REF(finish)), 5 SECONDS)

/obj/item/ordnance/data_analyzer/proc/finish()
	var/counter = 0
	for(var/mob in mobs_hit)
		counter++
	GLOB.ordnance_research.update_credits(counter * credits_to_award)
	qdel(src)

//ordnance tech upgrades

/datum/ordnance_tech
	///name that shows up in the TGUI
	var/name = "Something."
	///desc of what it is
	var/desc = "You shouldn't be seeing this."
	///the price of the tech
	var/value = 1
	///path to the item
	var/item_path
	///if it's an unlock in a lathe, what unlock is it?
	var/list/tech_unlock = list()
	///is this tech or an actual item?
	var/item_type
	///should this add a new category? also stops from being purchaseable
	var/add_category = FALSE

/datum/ordnance_tech/proc/purchase(turf/location)
	if(isnull(item_path))
		return
	new item_path(location)
	playsound(location, 'sound/machines/twobeep.ogg', 15, 1)

//items

/datum/ordnance_tech/item
	name = "Items"
	item_type = ORDNANCE_UPGRADE_ITEM
	add_category = TRUE

/datum/ordnance_tech/item/analyzer
	name = "Data Analyzer"
	desc = "Analyzes the explosion caused by the casing and the amount of targets hit, granting ordnance technology credits."
	item_path = /obj/item/ordnance/data_analyzer
	add_category = FALSE

//upgrades

/datum/ordnance_tech/technology
	name = "Technologies"
	item_type = ORDNANCE_UPGRADE_TECH
	item_path = /obj/item/ordnance/tech_disk
	add_category = TRUE

/datum/ordnance_tech/technology/purchase(turf/location)
	if(isnull(item_path))
		return
	var/obj/item/ordnance/tech_disk/disk = new item_path(location)
	disk.name = "technology disk for [name]"
	disk.desc = "Insert this in an armylathe to obtain this technology."
	disk.tech += tech_unlock
	playsound(location, 'sound/machines/fax.ogg', 15, 1)

/datum/ordnance_tech/technology/plastic_explosive
	name = "C4 Plastic Casing"
	desc = "A custom plastic explosive."
	tech_unlock = CUSTOM_C4
	value = 5
	add_category = FALSE

/datum/ordnance_tech/technology/rocket
	name = "84mm Rocket"
	desc = "An 84mm custom rocket."
	tech_unlock = list(CUSTOM_ROCKET, CUSTOM_ROCKET_WARHEAD)
	value = 25
	add_category = FALSE

/datum/ordnance_tech/technology/shell
	name = "80mm Mortar Shell"
	desc = "An 80mm mortar shell."
	tech_unlock = list(CUSTOM_SHELL, CUSTOM_SHELL_WARHEAD, CUSTOM_SHELL_CAMERA)
	value = 20
	add_category = FALSE

//the computer

/obj/structure/machinery/computer/ordnance
	name = "ordnance data terminal"
	desc = "A terminal for accessing ordnance technology data."
	icon_state = "engineering_terminal"
	var/list/jobs_allowed = list(JOB_ORDNANCE_TECH, JOB_SYNTH, JOB_CHIEF_ENGINEER)

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
	if(tech.item_type == ORDNANCE_UPGRADE_TECH)
		GLOB.ordnance_research.tech_bought += tech.name
	print_tech(tech_path)

/obj/structure/machinery/computer/ordnance/proc/print_tech(tech_path)
	var/datum/ordnance_tech/item = new tech_path()
	item.purchase(loc)


