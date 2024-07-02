/datum/faction_relations
	var/relations[] = RELATIONS_MAP
	var/list/allies = list()
	var/list/datum/relations_action/relation_actions = list()
	var/datum/faction/faction
	var/atom/source

/datum/faction_relations/New(datum/faction/faction_to_set, atom/referenced_source)
	faction = faction_to_set
	if(referenced_source)
		source = referenced_source
	else
		source = src

/datum/faction_relations/proc/generate_relations_helper()
	spawn(30 SECONDS)
		for(var/i in FACTION_LIST_ALL)
			if(i == faction.faction_name)
				relations[i] = RELATIONS_SELF
				continue
			if(i in faction.relations_pregen)
				relations[i] = rand(faction.relations_pregen[i][1], faction.relations_pregen[i][2])
				if(RELATIONS_FRIENDLY[2] < faction.relations_pregen[i])
					allies += GLOB.faction_datum[i]
				continue
			relations[i] = RELATIONS_UNKNOWN

/datum/faction_relations/proc/can_acting(datum/faction/target_faction)
	if(isnull(relations[target_faction.faction_name]) || relations[target_faction.faction_name] < RELATIONS_WAR[1] || relations[target_faction.faction_name] > RELATIONS_MAX)
		return FALSE
	return TRUE

/datum/faction_relations/proc/gain_opinion(datum/faction/target_faction, opinion)
	relations[target_faction.faction_name] = clamp(relations[target_faction.faction_name] + opinion, RELATIONS_WAR[1], RELATIONS_MAX)

/datum/faction_relations/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, source, ui)
	if(!ui)
		ui = new(user, source, "FactionRelations", "[faction] Relations")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/faction_relations/ui_data(mob/user)
	. = list()
	var/list/relations_mapping = list()
	for(var/i in relations)
		if(relations[i] == null || relations[i] > 1000)
			continue
		relations_mapping += list(list("name" = GLOB.faction_datum[i].name, "desc" = GLOB.faction_datum[i].desc, "color" = GLOB.faction_datum[i].ui_color, "value" = relations[i]))

	.["actions"] = source != src ? TRUE : FALSE

	.["faction_color"] = faction.ui_color
	.["faction_relations"] = relations_mapping

/datum/faction_relations/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/faction_relations/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE
