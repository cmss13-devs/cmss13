/datum/faction_module/relations
	var/relations[] = RELATIONS_MAP
	var/list/allies = list()
	var/list/datum/relations_action/relation_actions = list()
	var/datum/faction/faction
	var/atom/source

/datum/faction_module/relations/New(datum/faction/faction_to_set, atom/referenced_source)
	faction = faction_to_set
	if(referenced_source)
		source = referenced_source
	else
		source = src

/datum/faction_module/relations/proc/generate_relations_helper()
	spawn(30 SECONDS)
		for(var/code_identificator in GLOB.faction_datums)
			if(code_identificator == faction.code_identificator)
				relations[code_identificator] = RELATIONS_SELF
				continue
			if(code_identificator in faction.relations_pregen)
				relations[code_identificator] = rand(faction.relations_pregen[code_identificator][1], faction.relations_pregen[code_identificator][2])
				if(RELATIONS_FRIENDLY[2] < faction.relations_pregen[code_identificator])
					allies += GLOB.faction_datums[code_identificator]
				continue
			relations[code_identificator] = RELATIONS_UNKNOWN

/datum/faction_module/relations/proc/can_acting(datum/faction/target_faction)
	if(isnull(relations[target_faction.code_identificator]) || relations[target_faction.code_identificator] < RELATIONS_WAR[1] || relations[target_faction.code_identificator] > RELATIONS_MAX)
		return FALSE
	return TRUE

/datum/faction_module/relations/proc/gain_opinion(datum/faction/target_faction, opinion)
	relations[target_faction.code_identificator] = clamp(relations[target_faction.code_identificator] + opinion, RELATIONS_WAR[1], RELATIONS_MAX)

/datum/faction_module/relations/proc/break_alliances()
	if(!length(allies))
		return FALSE

	for(var/datum/faction/ally in allies)
		breake_alliance(ally, TRUE)
	return TRUE

/datum/faction_module/relations/proc/breake_alliance(datum/faction/ally, force = FALSE)
	allies -= ally
	var/opinion_before = relations[ally.code_identificator]
	relations[ally.code_identificator] = RELATIONS_FRIENDLY[1]
	var/opinion_difference = opinion_before - relations[ally.code_identificator]
	faction_announcement("Alliance with [faction] broken, opinion degrade for [opinion_difference] positions", "Relations", faction_to_display = ally)
	faction_announcement("We broke alliance with [ally], opinion degrade for [opinion_difference] positions", "Relations", faction_to_display = faction)

/datum/faction_module/relations/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, source, ui)
	if(!ui)
		ui = new(user, source, "FactionRelations", "[faction] Relations")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/faction_module/relations/ui_data(mob/user)
	. = list()
	var/list/relations_mapping = list()
	for(var/code_identificator in relations)
		if(relations[code_identificator] == null || relations[code_identificator] > 1000)
			continue
		var/datum/faction/faction = GLOB.faction_datums[code_identificator]
		relations_mapping += list(list("name" = faction.name, "desc" = faction.desc, "color" = faction.color, "value" = relations[code_identificator]))

	.["actions"] = source != src ? TRUE : FALSE

	.["faction_color"] = faction.color
	.["faction_relations"] = relations_mapping

/datum/faction_module/relations/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/faction_module/relations/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
