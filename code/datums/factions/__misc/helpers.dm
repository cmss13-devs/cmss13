
GLOBAL_LIST_INIT_TYPED(objectives_reward_list, /datum/objectives_reward, create_objectives_rewards_list())
GLOBAL_LIST_EMPTY_TYPED(objective_controller, /datum/objectives_datum)
GLOBAL_LIST_INIT(objectives_links, list(
	"objective" = list(/obj/item/storage/fancy/vials/random, /obj/item/disk/objective, /obj/item/document_objective/technical_manual, /obj/item/document_objective/paper),
	"close" = list(/obj/item/disk/objective, /obj/item/document_objective/technical_manual, /obj/item/document_objective/folder, /obj/item/document_objective/report, /obj/item/document_objective/paper),
	"medium" = list(/obj/item/device/mass_spectrometer/adv/objective, /obj/item/device/reagent_scanner/adv/objective, /obj/item/device/healthanalyzer/objective, /obj/item/device/autopsy_scanner/objective, /obj/item/document_objective/paper),
	"far" = list(/obj/item/storage/fancy/vials/random, /obj/item/paper/research_notes, /obj/item/disk/objective,/obj/item/document_objective/folder, /obj/item/document_objective/report, /obj/item/document_objective/paper),
	"science" = list(/obj/item/storage/fancy/vials/random, /obj/item/paper/research_notes, /obj/item/document_objective/paper)
))

GLOBAL_LIST_INIT(task_gen_list, list("sector_control" = list(/datum/faction_task/sector_control/occupy, /datum/faction_task/sector_control/occupy/hold)))
GLOBAL_LIST_INIT(task_gen_list_game_enders, list("game_enders" = list(/datum/faction_task/dominate, /datum/faction_task/hold)))

GLOBAL_LIST_INIT_TYPED(faction_datum, /datum/faction, setup_faction_list())

/proc/setup_faction_list()
	. = list()
	for(var/faction_to_get in FACTION_LIST_DEFCONED)
		var/datum/objectives_datum/objectives_datum = new (faction_to_get)
		GLOB.objective_controller[faction_to_get] = objectives_datum
	for(var/path in typesof(/datum/faction))
		var/datum/faction/faction = new path
		.[faction.faction_name] = faction
		faction.relations_datum.generate_relations_helper()

GLOBAL_LIST_INIT_TYPED(custom_event_info_list, /datum/custom_event_info, setup_custom_event_info())

/proc/setup_custom_event_info()
	. = list()
	var/datum/custom_event_info/CEI = new()
	CEI.faction_name = "Global"
	.[CEI.faction_name] = CEI
	for(var/faction_to_get in FACTION_LIST_ALL)
		var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
		CEI = new()
		CEI.faction_name = faction.name
		CEI.faction = faction
		.[CEI.faction_name] = CEI
