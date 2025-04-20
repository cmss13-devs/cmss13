GLOBAL_DATUM_INIT(crew_manifest, /datum/crew_manifest, new)

/datum/crew_manifest
	var/list/departments = list()

/datum/crew_manifest/New()
	. = ..()
	departments = list(
		"Command" = GLOB.ROLES_CIC,
		"Auxiliary" = GLOB.ROLES_AUXIL_SUPPORT,
		"Security" = GLOB.ROLES_POLICE,
		"Engineering" = GLOB.ROLES_ENGINEERING,
		"Requisitions" = GLOB.ROLES_REQUISITION,
		"Medical" = GLOB.ROLES_MEDICAL,
		"Miscellaneous" = GLOB.ROLES_MISC
	)

/datum/crew_manifest/ui_static_data(mob/user)
	. = ..()
	var/list/marine_roles_by_squad = GLOB.ROLES_SQUAD_ALL

	for(var/squad_name in marine_roles_by_squad)
		departments[squad_name] = GLOB.ROLES_MARINES

	var/list/departments_with_jobs = list()

	// Populate departments_with_jobs with role orders
	for(var/department in departments)
		var/list/jobs = departments[department]
		departments_with_jobs[department] = jobs.Copy()

	.["departments_with_jobs"] = departments_with_jobs
	.["departments"] = departments

/datum/crew_manifest/ui_data()
	. = ..()
	var/list/data = list()

	for(var/datum/data/record/record_entry in GLOB.data_core.general)
		var/name = record_entry.fields["name"]
		var/rank = record_entry.fields["rank"]
		var/squad = record_entry.fields["squad"]
		if(isnull(name) || isnull(rank))
			continue

		if(record_entry.fields["mob_faction"] != FACTION_MARINE && (rank != JOB_CORPORATE_LIAISON) && (rank != JOB_CORPORATE_SECURITY))
			continue

		var/entry_dept = null
		var/list/entry = list(
			"name" = name,
			"rank" = rank,
			"squad" = squad,
			"is_active" = record_entry.fields["p_stat"]
		)

		for(var/iterated_dept in departments)
			if(iterated_dept in GLOB.ROLES_SQUAD_ALL)
				if(isnull(squad) || lowertext(squad) != lowertext(iterated_dept))
					continue
			var/list/jobs = departments[iterated_dept]
			if(rank in jobs)
				entry_dept = iterated_dept
				break

			if(isnull(entry_dept) && squad)
				entry_dept = squad
				break

		if(entry_dept)
			LAZYADD(data[entry_dept], list(entry))
		else
			LAZYADD(data["Miscellaneous"], list(entry))

	return data

/datum/crew_manifest/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrewManifest", "Crew Manifest", 900, 600)
		ui.open()

/datum/crew_manifest/ui_state(mob/user)
	if(ishuman(user) && (user.faction == FACTION_MARINE || (user.faction in FACTION_LIST_WY) || user.faction == FACTION_FAX))
		return GLOB.conscious_state
	if(isnewplayer(user))
		return GLOB.new_player_state
	if(isobserver(user))
		return GLOB.observer_state

/datum/crew_manifest/proc/open_ui(mob/user)
	tgui_interact(user)
