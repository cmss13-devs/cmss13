GLOBAL_DATUM_INIT(data_core, /datum/datacore, new)

/datum/datacore
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()

/datum/datacore/proc/get_manifest(monochrome, OOC, nonHTML)
	var/list/cic = GLOB.ROLES_CIC.Copy()
	var/list/auxil = GLOB.ROLES_AUXIL_SUPPORT.Copy()
	var/list/misc = GLOB.ROLES_MISC.Copy()
	var/list/mp = GLOB.ROLES_POLICE.Copy()
	var/list/eng = GLOB.ROLES_ENGINEERING.Copy()
	var/list/req = GLOB.ROLES_REQUISITION.Copy()
	var/list/med = GLOB.ROLES_MEDICAL.Copy()
	var/list/marines_by_squad = GLOB.ROLES_SQUAD_ALL.Copy()
	for(var/squad_name in marines_by_squad)
		marines_by_squad[squad_name] = GLOB.ROLES_MARINES.Copy()
	var/list/isactive = new()

// If we need not the HTML table, but list
	if(nonHTML)
		var/list/departments = list(
			"Command" = cic,
			"Auxiliary" = auxil,
			"Security" = mp,
			"Engineering" = eng,
			"Requisition" = req,
			"Medical" = med
		)
		departments += marines_by_squad
		var/list/manifest_out = list()
		for(var/datum/data/record/record_entry in GLOB.data_core.general)
			if(record_entry.fields["mob_faction"] != FACTION_MARINE) //we process only USCM humans
				continue
			var/name = record_entry.fields["name"]
			var/rank = record_entry.fields["rank"]
			var/squad = record_entry.fields["squad"]
			if(isnull(name) || isnull(rank))
				continue
			var/has_department = FALSE
			for(var/department in departments)
				// STOP SIGNING ALL MARINES IN ALPHA!
				if(department in GLOB.ROLES_SQUAD_ALL)
					if(squad != department)
						continue
				var/list/jobs = departments[department]
				if(rank in jobs)
					if(!manifest_out[department])
						manifest_out[department] = list()
					manifest_out[department] += list(list(
						"name" = name,
						"rank" = rank
					))
					has_department = TRUE
					break
			if(!has_department)
				if(!manifest_out["Miscellaneous"])
					manifest_out["Miscellaneous"] = list()
				manifest_out["Miscellaneous"] += list(list(
					"name" = name,
					"rank" = rank
				))
		return manifest_out

	var/dat = {"
	<div align='center'>
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome?"black":"#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: #DEF"]}
	</style></head>
	<table class="manifest">
	<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
	"}

	var/even = 0

	// sort mobs
	var/dept_flags = NO_FLAGS //Is there anybody in the department?.
	var/list/squad_sublists = GLOB.ROLES_SQUAD_ALL.Copy() //Are there any marines in the squad?

	for(var/datum/data/record/record_entry in GLOB.data_core.general)
		if(record_entry.fields["mob_faction"] != FACTION_MARINE) //we process only USCM humans
			continue

		var/name = record_entry.fields["name"]
		var/rank = record_entry.fields["rank"]
		var/real_rank = record_entry.fields["real_rank"]
		var/squad_name = record_entry.fields["squad"]
		if(isnull(name) || isnull(rank) || isnull(real_rank))
			continue

		if(OOC)
			var/active = 0
			for(var/mob/M in GLOB.player_list)
				if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = record_entry.fields["p_stat"]
			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line

		if(real_rank in GLOB.ROLES_CIC)
			dept_flags |= FLAG_SHOW_CIC
			LAZYSET(cic[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_AUXIL_SUPPORT)
			dept_flags |= FLAG_SHOW_AUXIL_SUPPORT
			LAZYSET(auxil[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_MISC)
			dept_flags |= FLAG_SHOW_MISC
			LAZYSET(misc[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_POLICE)
			dept_flags |= FLAG_SHOW_POLICE
			LAZYSET(mp[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_ENGINEERING)
			dept_flags |= FLAG_SHOW_ENGINEERING
			LAZYSET(eng[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_REQUISITION)
			dept_flags |= FLAG_SHOW_REQUISITION
			LAZYSET(req[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_MEDICAL)
			dept_flags |= FLAG_SHOW_MEDICAL
			LAZYSET(med[real_rank], name, rank)
		else if(real_rank in GLOB.ROLES_MARINES)
			if(isnull(squad_name))
				continue
			dept_flags |= FLAG_SHOW_MARINES
			squad_sublists[squad_name] = TRUE
			///If it is a real squad in the USCM squad list to prevent the crew manifest from breaking
			if(!(squad_name in GLOB.ROLES_SQUAD_ALL))
				continue
			LAZYSET(marines_by_squad[squad_name][real_rank], name, rank)

	//here we fill manifest
	var/name
	var/real_rank
	if(dept_flags & FLAG_SHOW_CIC)
		dat += "<tr><th colspan=3>Command</th></tr>"
		for(real_rank in cic)
			for(name in cic[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[cic[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even
	if(dept_flags & FLAG_SHOW_AUXIL_SUPPORT)
		dat += "<tr><th colspan=3>Auxiliary Combat Support</th></tr>"
		for(real_rank in auxil)
			for(name in auxil[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[auxil[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even
	if(dept_flags & FLAG_SHOW_MARINES)
		dat += "<tr><th colspan=3>Marines</th></tr>"
		for(var/squad_name in GLOB.ROLES_SQUAD_ALL)
			if(!squad_sublists[squad_name])
				continue
			dat += "<tr><th colspan=3>[squad_name]</th></tr>"
			for(real_rank in marines_by_squad[squad_name])
				for(name in marines_by_squad[squad_name][real_rank])
					dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[marines_by_squad[squad_name][real_rank][name]]</td><td>[isactive[name]]</td></tr>"
					even = !even
	if(dept_flags & FLAG_SHOW_POLICE)
		dat += "<tr><th colspan=3>Military Police</th></tr>"
		for(real_rank in mp)
			for(name in mp[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[mp[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even
	if(dept_flags & FLAG_SHOW_ENGINEERING)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(real_rank in eng)
			for(name in eng[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[eng[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even
	if(dept_flags & FLAG_SHOW_REQUISITION)
		dat += "<tr><th colspan=3>Requisition</th></tr>"
		for(real_rank in req)
			for(name in req[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[req[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even
	if(dept_flags & FLAG_SHOW_MEDICAL)
		dat += "<tr><th colspan=3>Medbay</th></tr>"
		for(real_rank in med)
			for(name in med[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[med[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even
	if(dept_flags & FLAG_SHOW_MISC)
		dat += "<tr><th colspan=3>Other</th></tr>"
		for(real_rank in misc)
			for(name in misc[real_rank])
				dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[misc[real_rank][name]]</td><td>[isactive[name]]</td></tr>"
				even = !even


	dat += "</table></div>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifest(nosleep = 0)
	spawn()
		if(!nosleep)
			sleep(40)

		var/list/jobs_to_check = GLOB.ROLES_CIC + GLOB.ROLES_AUXIL_SUPPORT + GLOB.ROLES_MISC + GLOB.ROLES_POLICE + GLOB.ROLES_ENGINEERING + GLOB.ROLES_REQUISITION + GLOB.ROLES_MEDICAL + GLOB.ROLES_MARINES
		for(var/mob/living/carbon/human/H as anything in GLOB.human_mob_list)
			if(should_block_game_interaction(H))
				continue
			if(H.job in jobs_to_check)
				manifest_inject(H)

/datum/datacore/proc/manifest_modify(name, ref, assignment, rank, p_stat)
	var/datum/data/record/foundrecord

	var/use_name = isnull(ref)
	for(var/datum/data/record/record_entry in GLOB.data_core.general)
		if(use_name)
			if(record_entry.fields["name"] == name)
				foundrecord = record_entry
				break
		else
			if(record_entry.fields["ref"] == ref)
				foundrecord = record_entry
				break

	if(foundrecord)
		if(assignment)
			foundrecord.fields["rank"] = assignment
		if(rank)
			foundrecord.fields["real_rank"] = rank
		if(p_stat)
			foundrecord.fields["p_stat"] = p_stat
		if(!use_name)
			if(name)
				foundrecord.fields["name"] = name
		return TRUE
	return FALSE

/datum/datacore/proc/manifest_inject(mob/living/carbon/human/target)
	var/assignment
	if(target.job)
		assignment = target.job
	else
		assignment = "Unassigned"

	var/id = add_zero(num2hex(target.gid), 6) //this was the best they could come up with? A large random number? *sigh*
	//var/icon/front = new(get_id_photo(H), dir = SOUTH)
	//var/icon/side = new(get_id_photo(H), dir = WEST)

	//General Record
	var/datum/data/record/record_general = new()
	record_general.fields["id"] = id
	record_general.fields["name"] = target.real_name
	record_general.name = target.real_name
	record_general.fields["real_rank"] = target.job
	record_general.fields["rank"] = assignment
	record_general.fields["squad"] = target.assigned_squad ? target.assigned_squad.name : null
	record_general.fields["age"] = target.age
	record_general.fields["p_stat"] = "Active"
	record_general.fields["m_stat"] = "Stable"
	record_general.fields["sex"] = target.gender
	record_general.fields["species"] = target.get_species()
	record_general.fields["origin"] = target.origin
	record_general.fields["faction"] = target.personal_faction
	record_general.fields["mob_faction"] = target.faction
	record_general.fields["religion"] = target.religion
	record_general.fields["ref"] = WEAKREF(target)
	//record_general.fields["photo_front"] = front
	//record_general.fields["photo_side"] = side

	if(target.gen_record && !jobban_isbanned(target, "Records"))
		record_general.fields["notes"] = target.gen_record
	else
		record_general.fields["notes"] = "No notes found."
	general += record_general

	//Medical Record
	var/datum/data/record/record_medical = new()
	record_medical.fields["id"] = id
	record_medical.fields["name"] = target.real_name
	record_medical.name = target.name
	record_medical.fields["b_type"] = target.blood_type
	record_medical.fields["mi_dis"] = "None"
	record_medical.fields["mi_dis_d"] = "No minor disabilities have been declared."
	record_medical.fields["ma_dis"] = "None"
	record_medical.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
	record_medical.fields["alg"] = "None"
	record_medical.fields["alg_d"] = "No allergies have been detected in this patient."
	record_medical.fields["cdi"] = "None"
	record_medical.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
	record_medical.fields["last_scan_time"] = null
	record_medical.fields["last_scan_result"] = "No scan data on record" // body scanner results
	record_medical.fields["autodoc_data"] = list()
	record_medical.fields["autodoc_manual"] = list()
	record_medical.fields["ref"] = WEAKREF(target)

	if(target.med_record && !jobban_isbanned(target, "Records"))
		record_medical.fields["notes"] = target.med_record
	else
		record_medical.fields["notes"] = "No notes found."
	medical += record_medical

	//Security Record
	var/datum/data/record/record_security = new()
	record_security.fields["id"] = id
	record_security.fields["name"] = target.real_name
	record_security.name = target.real_name
	record_security.fields["criminal"] = "None"
	record_security.fields["incident"] = ""
	record_security.fields["ref"] = WEAKREF(target)

	if(target.sec_record && !jobban_isbanned(target, "Records"))
		var/new_comment = list("entry" = target.sec_record, "created_by" = list("name" = "\[REDACTED\]", "rank" = "Military Police"), "deleted_by" = null, "deleted_at" = null, "created_at" = "Pre-Deployment")
		record_security.fields["comments"] = list("1" = new_comment)
		record_security.fields["notes"] = target.sec_record
	security += record_security


	//Locked Record
	var/datum/data/record/record_locked = new()
	record_locked.fields["id"] = md5("[target.real_name][target.job]")
	record_locked.fields["name"] = target.real_name
	record_locked.name = target.real_name
	record_locked.fields["rank"] = target.job
	record_locked.fields["age"] = target.age
	record_locked.fields["sex"] = target.gender
	record_locked.fields["b_type"] = target.b_type
	record_locked.fields["species"] = target.get_species()
	record_locked.fields["origin"] = target.origin
	record_locked.fields["faction"] = target.personal_faction
	record_locked.fields["religion"] = target.religion
	record_locked.fields["ref"] = WEAKREF(target)

	if(target.exploit_record && !jobban_isbanned(target, "Records"))
		record_locked.fields["exploit_record"] = target.exploit_record
	else
		record_locked.fields["exploit_record"] = "No additional information acquired."
	locked += record_locked


/proc/get_id_photo(mob/living/carbon/human/H)
	var/icon/preview_icon = null

	//var/g = "m"
	//if (H.gender == FEMALE)
	// g = "f"

	var/icon/icobase = H.species.icobase
	var/icon/temp

	var/datum/skin_color/set_skin_color = GLOB.skin_color_list[H.skin_color]
	var/datum/body_type/set_body_type = GLOB.body_type_list[H.body_type]
	var/datum/body_size/set_body_size = GLOB.body_size_list[H.body_size]

	var/skin_color_icon
	var/body_type_icon
	var/body_size_icon

	if(!set_skin_color)
		skin_color_icon = "pale2"
	else
		skin_color_icon = set_skin_color.icon_name

	if(!set_body_type)
		body_type_icon = "lean"
	else
		body_type_icon = set_body_type.icon_name

	if(!set_body_size)
		body_size_icon = "avg"
	else
		body_size_icon = set_body_size.icon_name

	preview_icon = new /icon(icobase, get_limb_icon_name(H.species, body_size_icon, body_type_icon, H.gender, "torso", skin_color_icon))
	temp = new /icon(icobase, get_limb_icon_name(H.species, body_size_icon, body_type_icon, H.gender, "groin", skin_color_icon))
	preview_icon.Blend(temp, ICON_OVERLAY)
	temp = new /icon(icobase, get_limb_icon_name(H.species, body_size_icon, body_type_icon, H.gender, "head", skin_color_icon))
	preview_icon.Blend(temp, ICON_OVERLAY)

	for(var/obj/limb/E in H.limbs)
		if(E.status & LIMB_DESTROYED) continue
		temp = new /icon(icobase, get_limb_icon_name(H.species, body_size_icon, body_type_icon, H.gender, E.name, skin_color_icon))
		if(E.status & LIMB_ROBOT)
			temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		preview_icon.Blend(temp, ICON_OVERLAY)

	//Tail
	if(H.species.tail)
		temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[H.species.tail]_s")
		preview_icon.Blend(temp, ICON_OVERLAY)


	var/icon/eyes_s = new/icon("icon" = 'icons/mob/humans/onmob/human_face.dmi', "icon_state" = H.species ? H.species.eyes : "eyes_s")

	eyes_s.Blend(rgb(H.r_eyes, H.g_eyes, H.b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = GLOB.hair_styles_list[H.h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[H.f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	var/icon/clothes_s = null
	clothes_s = new /icon('icons/mob/humans/onmob/uniform_0.dmi', "marine_underpants_s")
	clothes_s.Blend(new /icon('icons/mob/humans/onmob/feet.dmi', "black"), ICON_UNDERLAY)
	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	qdel(eyes_s)
	qdel(clothes_s)

	return preview_icon
