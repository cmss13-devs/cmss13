GLOBAL_DATUM_INIT(crew_manifest, /datum/crew_manifest, new)

/datum/crew_manifest/New()
    . = ..()

/datum/crew_manifest/ui_static_data(mob/user)
    . = ..()

    var/list/departments = list(
        "Command" = GLOB.ROLES_CIC,
        "Auxiliary" = GLOB.ROLES_AUXIL_SUPPORT,
        "Security" = GLOB.ROLES_POLICE,
        "Engineering" = GLOB.ROLES_ENGINEERING,
        "Requisition" = GLOB.ROLES_REQUISITION,
        "Medical" = GLOB.ROLES_MEDICAL,
        "Marines" = GLOB.ROLES_MARINES,
        "Miscellaneous" = GLOB.ROLES_MISC
    )

    var/list/marine_roles_by_squad = GLOB.ROLES_SQUAD_ALL
    for(var/squad_name in marine_roles_by_squad)
        marine_roles_by_squad[squad_name] = GLOB.ROLES_MARINES

    departments += marine_roles_by_squad

    .["departments"] = departments

/datum/crew_manifest/proc/format_manifest_data()
    var/list/manifest = list()
    var/list/isactive = new()

    for(var/datum/data/record/record_entry in GLOB.data_core.general)
        if(record_entry.fields["mob_faction"] != FACTION_MARINE)
            continue

        var/name = record_entry.fields["name"]
        var/rank = record_entry.fields["rank"]
        var/squad = record_entry.fields["squad"]
        if(isnull(name) || isnull(rank))
            continue

        var/department_name = null
        var/list/entry = list(
            "name" = name,
            "rank" = rank,
            "squad" = squad,
            "is_active" = record_entry.fields["p_stat"]
        )

        for(var/department in .["departments"])
            if(department in GLOB.ROLES_SQUAD_ALL && squad != department)
                continue
            var/list/jobs = .["departments"][department]
            if(rank in jobs)
                department_name = department
                break

        if(department_name)
            if(!manifest[department_name])
                manifest[department_name] = list()
            manifest[department_name] += list(entry)
        else
            if(!manifest["Miscellaneous"])
                manifest["Miscellaneous"] = list()
            manifest["Miscellaneous"] += list(entry)

    return manifest

/datum/crew_manifest/ui_data(mob/user)
    . = ..()

    .["manifest"] = format_manifest_data()

/datum/crew_manifest/tgui_interact(mob/user, datum/tgui/ui)
    . = ..()

    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "CrewManifest", "Crew Manifest", 900, 600)
        ui.open()

/datum/crew_manifest/ui_state(mob/user)
    return GLOB.always_state

/datum/crew_manifest/proc/open_ui(mob/user)
    tgui_interact(user)
