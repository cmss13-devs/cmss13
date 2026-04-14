GLOBAL_DATUM_INIT(chemical_data, /datum/chemical_data, new)

/datum/chemical_data
	var/rsc_credits = 0
	var/clearance_level = 1
	///credits gained from survivor clearance cards
	var/credits_gained = 0
	var/clearance_x_access = FALSE
	var/reached_x_access = FALSE
	var/picked_chem = FALSE
	var/has_new_properties = FALSE
	var/ddi_discovered = FALSE
	var/list/research_documents = list()
	var/list/research_publications = list()
	var/list/research_property_data = list() //starter properties are stored here
	//chemicals that you get to pick
	var/list/contract_chems = list()
	///when will next reroll happen, time
	var/next_reroll = null
	var/list/chemical_networks = list()
	var/list/shared_item_storage = list()
	var/list/shared_item_quantity = list()
	var/list/chemical_objective_list = list() //List of all objective reagents indexed by ID associated with the objective value
	var/list/chemical_not_completed_objective_list = list() //List of not completed objective reagents indexed by ID associated with the objective value
	var/list/chemical_identified_list = list() //List of all identified objective reagents indexed by ID associated with the objective value
	var/list/research_computers = list()
	var/next_research_item_announcement = 0
	var/next_novel_research_item_announcement = 0

/datum/chemical_data/proc/update_credits(change)
	rsc_credits = max(0, rsc_credits + change)

/datum/chemical_data/proc/get_announceable_research_item_name(obj/item/research_item)
	if(!research_item || istype(research_item, /obj/item/research_upgrades/reroll))
		return null
	for(var/upgrade_type in subtypesof(/datum/research_upgrades))
		var/datum/research_upgrades/upgrade = upgrade_type
		if(upgrade.behavior != RESEARCH_UPGRADE_ITEM)
			continue
		var/announce_path = upgrade.item_reference
		if(!announce_path || announce_path == /obj/item/research_upgrades/reroll)
			continue
		if(research_item.type == announce_path)
			return upgrade.name
	return null

/datum/chemical_data/proc/save_document(obj/item/paper/research_report/R, document_type, title)
	if(!research_documents["[document_type]"])
		research_documents["[document_type]"] = list()
	var/save_time = worldtime2text()

	var/list/new_document = list(
		"document_title"=title,
		"time"=save_time,
		"document"=R
	)
	research_documents["[document_type]"] += list(new_document)

/datum/chemical_data/proc/get_report(doc_type, doc_title)
	var/obj/item/paper/research_report/report = null
	for(var/document_data in GLOB.chemical_data.research_documents[doc_type])
		if(document_data["document_title"] == doc_title)
			report = document_data["document"]
			break
	return report

/datum/chemical_data/proc/publish_document(obj/item/paper/research_report/R, document_type, title, mob/living/carbon/human/publisher = null)
	if(!research_publications["[document_type]"])
		research_publications["[document_type]"] = list()
	var/save_time = worldtime2text()

	var/list/new_document = list(
		"document_title"=title,
		"time"=save_time,
		"document"=R
	)
	research_publications["[document_type]"] += list(new_document)
	if(is_stim_report(R))
		announce_published_stim(R, publisher)

/datum/chemical_data/proc/unpublish_document(document_type, title)
	if(!research_publications["[document_type]"])
		return TRUE
	var/list/published_to_remove = list()
	var/list/docs = research_documents["[document_type]"]
	// find the document, in all research documents
	// the user might unpublish a different version to the published one
	for(var/research_doc in docs)
		if(research_doc["document_title"] == title)
			published_to_remove += research_doc
			break
	// collect all documents which match the name of the doc to unpublish
	var/chem_name = published_to_remove["document"]
	var/list/all_published_references = list()
	var/list/published_docs = research_publications["[document_type]"]
	for(var/published_doc in published_docs)
		var/doc_name = published_doc["document"]
		if(cmptext(doc_name, chem_name) == 1)
			all_published_references += list(published_doc)

	// remove all published references
	for(var/published_doc in all_published_references)
		published_docs -= list(published_doc)
	return TRUE

/datum/chemical_data/proc/is_stim_report(obj/item/paper/research_report/R)
	var/datum/reagent/stim = R?.data
	if(!istype(stim))
		return FALSE
	if(stim.flags & REAGENT_TYPE_STIMULANT)
		return TRUE
	for(var/datum/chem_property/property in stim.properties)
		if(property.category & PROPERTY_TYPE_STIMULANT)
			return TRUE
	return FALSE

/datum/chemical_data/proc/get_all_marine_research_targets()
	. = list()
	for(var/mob/living/carbon/human/recipient as anything in GLOB.alive_human_list)
		if(!recipient.client || recipient.stat != CONSCIOUS || isyautja(recipient))
			continue
		if(recipient.faction != FACTION_MARINE && !(FACTION_MARINE in recipient.faction_group))
			continue
		.[recipient] = TRUE

/datum/chemical_data/proc/send_research_update(list/targets, screen_message, chat_message)
	if(!length(targets) || !screen_message || !chat_message)
		return
	for(var/mob/living/carbon/human/recipient as anything in targets)
		playsound_client(recipient.client, 'sound/effects/radiostatic.ogg', recipient.loc, 25, FALSE)
		to_chat(recipient, SPAN_BLUE("<B>Research Update:</B> [chat_message]"), type = MESSAGE_TYPE_RADIO)
		recipient.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>Research Update</u></span><br>[screen_message]", /atom/movable/screen/text/screen_text/command_order, "#67d692")

/datum/chemical_data/proc/announce_published_stim(obj/item/paper/research_report/R, mob/living/carbon/human/publisher = null)
	var/datum/reagent/stim = R?.data
	if(!istype(stim))
		return
	var/list/targets = get_all_marine_research_targets()
	if(!length(targets))
		return

	var/duration_multiplier = stim.custom_metabolism ? round(REAGENTS_METABOLISM / stim.custom_metabolism, 0.1) : 0
	var/duration_text = duration_multiplier ? "[duration_multiplier]x" : "Unknown"
	var/publisher_name = publisher ? publisher.real_name : "Unknown"
	var/screen_message = "[stim.name] | OD [stim.overdose]u | Dur [duration_text]<br>Publisher: [publisher_name]"
	var/chat_message = "[stim.name] published by [publisher_name]. OD [stim.overdose]u. Duration [duration_text]."
	send_research_update(targets, screen_message, chat_message)

/datum/chemical_data/proc/announce_research_item_available(item_name, amount_available, mob/living/carbon/human/announcer = null)
	if(!item_name || !amount_available || !announcer)
		return FALSE
	if(world.time < next_research_item_announcement)
		return FALSE
	var/list/targets = get_all_marine_research_targets()
	if(!length(targets))
		return FALSE

	var/quantity_suffix = amount_available > 0 ? " (x[amount_available])" : ""
	var/screen_message = "[announcer.real_name] has made [item_name] available[quantity_suffix]."
	var/chat_message = "[announcer.real_name] has made [item_name] available[quantity_suffix]."
	next_research_item_announcement = world.time + 2 MINUTES
	send_research_update(targets, screen_message, chat_message)
	return TRUE

/datum/chemical_data/proc/announce_novel_product_caution(mob/living/carbon/human/announcer = null)
	if(!announcer)
		return FALSE
	if(world.time < next_novel_research_item_announcement)
		return FALSE
	var/list/targets = get_all_marine_research_targets()
	if(!length(targets))
		return FALSE

	next_novel_research_item_announcement = world.time + 10 MINUTES
	send_research_update(targets, "Novel product developed, advise caution.", "Novel product developed, advise caution.")
	return TRUE

/datum/chemical_data/proc/save_new_properties(list/properties)
	var/list/property_names = list()
	for(var/datum/chem_property/P in properties) //just save the names
		if(P.category & PROPERTY_TYPE_UNADJUSTABLE || P.category & PROPERTY_TYPE_ANOMALOUS)
			continue
		property_names += P.name
	for(var/datum/chem_property/property in research_property_data)
		property_names -= property.name
	if(LAZYLEN(property_names))
		has_new_properties = TRUE
		for(var/name in property_names)
			var/datum/chem_property/ref = GLOB.chemical_properties_list[name]
			var/datum/chem_property/P = new ref.type
			P.level = 0
			research_property_data += P

//Chem storage for various chem dispensers
/datum/chemical_data/proc/add_chem_storage(obj/structure/machinery/chem_storage/storage)
	if(chemical_networks.Find(storage.network))
		return FALSE
	else
		chemical_networks[storage.network] = storage

/datum/chemical_data/proc/remove_chem_storage(obj/structure/machinery/chem_storage/storage)
	if(!istype(storage))
		return FALSE
	return chemical_networks.Remove(storage.network)

/datum/chemical_data/proc/connect_chem_storage(network)
	var/obj/structure/machinery/chem_storage/storage = chemical_networks[network]
	if(!storage)
		return FALSE
	//Make the chem storage scale with number of dispensers
	storage.recharge_rate += 5
	storage.max_energy += 100
	storage.energy = storage.max_energy
	return storage

/datum/chemical_data/proc/disconnect_chem_storage(network)
	var/obj/structure/machinery/chem_storage/storage = chemical_networks[network]
	if(!storage)
		return FALSE
	//Make the chem storage scale with number of dispensers
	storage.recharge_rate -= 5
	storage.max_energy -= 100
	storage.energy = storage.max_energy
	return TRUE

/datum/chemical_data/proc/complete_chemical(datum/reagent/chem)
	chemical_identified_list[chem.id] = chem.objective_value
	chemical_not_completed_objective_list -= chem.id
	GLOB.chemical_data.chemical_identified_list[chem.id] = chem

	SSobjectives.statistics["chemicals_completed"]++
	SSobjectives.statistics["chemicals_total_points_earned"] += chem.objective_value

	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(chem.objective_value)
	GLOB.chemical_data.update_credits(chem.credit_reward)

/datum/chemical_data/proc/add_chemical_objective(datum/reagent/chem)
	chemical_objective_list[chem.id] = chem.objective_value
	chemical_not_completed_objective_list[chem.id] = chem.objective_value

/datum/chemical_data/proc/reroll_chemicals()
	if(!isnull(contract_chems))
		for(var/i in 1 to RESEARCH_CONTRACT_CHEM_AMOUNT)
			if(contract_chems["contract-chem-[i]"] != null) //chances are, player picked something and list is shorter now.
				qdel(contract_chems["contract-chem-[i]"])

	contract_chems = list()
	for(var/i in 1 to RESEARCH_CONTRACT_CHEM_AMOUNT)
		var/datum/reagent/generated/contract_chemical = new /datum/reagent/generated
		contract_chemical.id = "contract-chem-[i]"// we don't actually create the recipe for it or give it a proper id, frankly that would be too much pain to remove when we reroll them
		contract_chemical.generate_name()
		contract_chemical.gen_tier = rand(1,3) //easy, hard and medium
		contract_chemical.generate_stats()
		var/roll = rand(1, 100)
		switch(contract_chemical.gen_tier) // pick a reagent hint.
			if(1)
				contract_chemical.credit_reward = 3
				if(roll <= 60)
					contract_chemical.reagent_recipe_hint = pick(GLOB.chemical_gen_classes_list["C1"])
				else
					contract_chemical.reagent_recipe_hint = pick(GLOB.chemical_gen_classes_list["C2"])
			if(2)
				contract_chemical.credit_reward = 5
				if(roll <= 40)
					contract_chemical.reagent_recipe_hint = pick(GLOB.chemical_gen_classes_list["C2"])
				else
					contract_chemical.reagent_recipe_hint = pick(GLOB.chemical_gen_classes_list["C3"])
			if(3)
				contract_chemical.credit_reward = 7
				contract_chemical.reagent_recipe_hint = pick(GLOB.chemical_gen_classes_list["H1"]) //hard chemicals *always* contain a hydro exclusive chem
		contract_chemical.property_hint = pick(contract_chemical.properties)
		contract_chems[contract_chemical.id] = contract_chemical
	next_reroll = world.time + RESEARCH_CONTRACT_NOT_PICKED
	if(picked_chem)
		picked_chem = FALSE
	for(var/obj/structure/machinery/computer in research_computers)
		var/list/heard = get_mobs_in_view(7, computer.loc)
		var/message = "Chemical contracts have been updated!"
		give_notification(computer, heard, message)
		computer.update_static_data_for_all_viewers()

/datum/chemical_data/proc/give_notification(obj/structure/machinery/comp, list/group, message)
	comp.langchat_speech(message, group, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("langchat_small"))
	comp.visible_message("[icon2html(comp, viewers(comp))] \The <b>[comp]</b> speaks: [message]")
	playsound(comp.loc, 'sound/machines/twobeep.ogg', 50, 1, 7)

///Makes the chemical "exist", given a proper ID, proper reaction, and added to global lists. Used when contract chemical is picked and it needs to be completed.
/datum/chemical_data/proc/legalize_chem(datum/reagent/generated/chem)
	contract_chems[chem.id] = null
	chem.id = "tau-[length(GLOB.chemical_gen_classes_list["tau"])]"
	GLOB.chemical_gen_classes_list["tau"] += chem.id
	GLOB.chemical_reagents_list[chem.id] = chem
	chem.generate_assoc_recipe(null, list(chem.reagent_recipe_hint))
	return chem.id

/datum/chemical_data/proc/get_tgui_data(chemid)
	var/datum/reagent/chem = GLOB.chemical_reagents_list[chemid]
	if(!chem)
		error("Invalid chemid [chemid]")
		return
	var/list/clue = list()

	clue["text"] = chem.name

	return clue
