GLOBAL_DATUM_INIT(data_core, /datum/datacore, new)

/datum/datacore
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()

/datum/datacore/proc/get_manifest(monochrome, OOC, nonHTML)
	var/list/cic = ROLES_CIC.Copy()
	var/list/auxil = ROLES_AUXIL_SUPPORT.Copy()
	var/list/misc = ROLES_MISC.Copy()
	var/list/mp = ROLES_POLICE.Copy()
	var/list/eng = ROLES_ENGINEERING.Copy()
	var/list/req = ROLES_REQUISITION.Copy()
	var/list/med = ROLES_MEDICAL.Copy()
	var/list/marines_by_squad = ROLES_SQUAD_ALL.Copy()
	for(var/squad_name in marines_by_squad)
		marines_by_squad[squad_name] = ROLES_MARINES.Copy()
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
		for(var/datum/data/record/data_record in GLOB.data_core.general)
			if(data_record.fields["mob_faction"] != FACTION_MARINE) //we process only USCM humans
				continue
			var/name = data_record.fields["name"]
			var/rank = data_record.fields["rank"]
			var/squad = data_record.fields["squad"]
			if(isnull(name) || isnull(rank))
				continue
			var/has_department = FALSE
			for(var/department in departments)
				// STOP SIGNING ALL MARINES IN ALPHA!
				if(department in ROLES_SQUAD_ALL)
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
	var/list/squad_sublists = ROLES_SQUAD_ALL.Copy() //Are there any marines in the squad?

	for(var/datum/data/record/data_record in GLOB.data_core.general)
		if(data_record.fields["mob_faction"] != FACTION_MARINE) //we process only USCM humans
			continue

		var/name = data_record.fields["name"]
		var/rank = data_record.fields["rank"]
		var/real_rank = data_record.fields["real_rank"]
		var/squad_name = data_record.fields["squad"]
		if(isnull(name) || isnull(rank) || isnull(real_rank))
			continue

		if(OOC)
			var/active = 0
			for(var/mob/current_mob in GLOB.player_list)
				if(current_mob.real_name == name && current_mob.client && current_mob.client.inactivity <= 10 * 60 * 10)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = data_record.fields["p_stat"]
			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line

		if(real_rank in ROLES_CIC)
			dept_flags |= FLAG_SHOW_CIC
			LAZYSET(cic[real_rank], name, rank)
		else if(real_rank in ROLES_AUXIL_SUPPORT)
			dept_flags |= FLAG_SHOW_AUXIL_SUPPORT
			LAZYSET(auxil[real_rank], name, rank)
		else if(real_rank in ROLES_MISC)
			dept_flags |= FLAG_SHOW_MISC
			LAZYSET(misc[real_rank], name, rank)
		else if(real_rank in ROLES_POLICE)
			dept_flags |= FLAG_SHOW_POLICE
			LAZYSET(mp[real_rank], name, rank)
		else if(real_rank in ROLES_ENGINEERING)
			dept_flags |= FLAG_SHOW_ENGINEERING
			LAZYSET(eng[real_rank], name, rank)
		else if(real_rank in ROLES_REQUISITION)
			dept_flags |= FLAG_SHOW_REQUISITION
			LAZYSET(req[real_rank], name, rank)
		else if(real_rank in ROLES_MEDICAL)
			dept_flags |= FLAG_SHOW_MEDICAL
			LAZYSET(med[real_rank], name, rank)
		else if(real_rank in ROLES_MARINES)
			if(isnull(squad_name))
				continue
			dept_flags |= FLAG_SHOW_MARINES
			squad_sublists[squad_name] = TRUE
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
		for(var/squad_name in ROLES_SQUAD_ALL)
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

		var/list/jobs_to_check = ROLES_CIC + ROLES_AUXIL_SUPPORT + ROLES_MISC + ROLES_POLICE + ROLES_ENGINEERING + ROLES_REQUISITION + ROLES_MEDICAL + ROLES_MARINES
		for(var/mob/living/carbon/human/human in GLOB.human_mob_list)
			if(is_admin_level(human.z))
				continue
			if(human.job in jobs_to_check)
				manifest_inject(human)

/datum/datacore/proc/manifest_modify(name, ref, assignment, rank, p_stat)
	var/datum/data/record/foundrecord

	var/use_name = isnull(ref)
	for(var/datum/data/record/data_record in GLOB.data_core.general)
		if(use_name)
			if(data_record.fields["name"] == name)
				foundrecord = data_record
				break
		else
			if(data_record.fields["ref"] == ref)
				foundrecord = data_record
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

/datum/datacore/proc/manifest_inject(mob/living/carbon/human/human)
	var/assignment
	if(human.job)
		assignment = human.job
	else
		assignment = "Unassigned"

	var/id = add_zero(num2hex(human.gid), 6) //this was the best they could come up with? A large random number? *sigh*
	//var/icon/front = new(get_id_photo(human), dir = SOUTH)
	//var/icon/side = new(get_id_photo(human), dir = WEST)

	//General Record
	var/datum/data/record/gen_record = new()
	gen_record.fields["id"] = id
	gen_record.fields["name"] = human.real_name
	gen_record.fields["real_rank"] = human.job
	gen_record.fields["rank"] = assignment
	gen_record.fields["squad"] = human.assigned_squad ? human.assigned_squad.name : null
	gen_record.fields["age"] = human.age
	gen_record.fields["p_stat"] = "Active"
	gen_record.fields["m_stat"] = "Stable"
	gen_record.fields["sex"] = human.gender
	gen_record.fields["species"] = human.get_species()
	gen_record.fields["origin"] = human.origin
	gen_record.fields["faction"] = human.personal_faction
	gen_record.fields["mob_faction"] = human.faction
	gen_record.fields["religion"] = human.religion
	gen_record.fields["ref"] = WEAKREF(human)
	//gen_record.fields["photo_front"] = front
	//gen_record.fields["photo_side"] = side

	if(human.gen_record && !jobban_isbanned(human, "Records"))
		gen_record.fields["notes"] = human.gen_record
	else
		gen_record.fields["notes"] = "No notes found."
	general += gen_record

	//Medical Record
	var/datum/data/record/current_mob = new()
	current_mob.fields["id"] = id
	current_mob.fields["name"] = human.real_name
	current_mob.fields["b_type"] = human.blood_type
	current_mob.fields["mi_dis"] = "None"
	current_mob.fields["mi_dis_d"] = "No minor disabilities have been declared."
	current_mob.fields["ma_dis"] = "None"
	current_mob.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
	current_mob.fields["alg"] = "None"
	current_mob.fields["alg_d"] = "No allergies have been detected in this patient."
	current_mob.fields["cdi"] = "None"
	current_mob.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
	current_mob.fields["last_scan_time"] = null
	current_mob.fields["last_scan_result"] = "No scan data on record" // body scanner results
	current_mob.fields["autodoc_data"] = list()
	current_mob.fields["autodoc_manual"] = list()
	current_mob.fields["ref"] = WEAKREF(human)

	if(human.med_record && !jobban_isbanned(human, "Records"))
		current_mob.fields["notes"] = human.med_record
	else
		current_mob.fields["notes"] = "No notes found."
	medical += current_mob

	//Security Record
	var/datum/data/record/sec_record = new()
	sec_record.fields["id"] = id
	sec_record.fields["name"] = human.real_name
	sec_record.fields["criminal"] = "None"
	sec_record.fields["incident"] = ""
	sec_record.fields["ref"] = WEAKREF(human)
	security += sec_record

	//Locked Record
	var/datum/data/record/lock_record = new()
	lock_record.fields["id"] = md5("[human.real_name][human.job]")
	lock_record.fields["name"] = human.real_name
	lock_record.fields["rank"] = human.job
	lock_record.fields["age"] = human.age
	lock_record.fields["sex"] = human.gender
	lock_record.fields["b_type"] = human.b_type
	lock_record.fields["species"] = human.get_species()
	lock_record.fields["origin"] = human.origin
	lock_record.fields["faction"] = human.personal_faction
	lock_record.fields["religion"] = human.religion
	lock_record.fields["ref"] = WEAKREF(human)

	if(human.exploit_record && !jobban_isbanned(human, "Records"))
		lock_record.fields["exploit_record"] = human.exploit_record
	else
		lock_record.fields["exploit_record"] = "No additional information acquired."
	locked += lock_record


/proc/get_id_photo(mob/living/carbon/human/human)
	var/icon/preview_icon = null

	//var/g = "m"
	//if (human.gender == FEMALE)
	// g = "f"

	var/icon/icobase = human.species.icobase
	var/icon/temp

	var/datum/ethnicity/ET = GLOB.ethnicities_list[human.ethnicity]
	var/datum/body_type/body = GLOB.body_types_list[human.body_type]

	var/e_icon
	var/b_icon

	if (!ET)
		e_icon = "western"
	else
		e_icon = ET.icon_name

	if (!body)
		b_icon = "mesomorphic"
	else
		b_icon = body.icon_name

	preview_icon = new /icon(icobase, get_limb_icon_name(human.species, b_icon, human.gender, "torso", e_icon))
	temp = new /icon(icobase, get_limb_icon_name(human.species, b_icon, human.gender, "groin", e_icon))
	preview_icon.Blend(temp, ICON_OVERLAY)
	temp = new /icon(icobase, get_limb_icon_name(human.species, b_icon, human.gender, "head", e_icon))
	preview_icon.Blend(temp, ICON_OVERLAY)

	for(var/obj/limb/current_limb in human.limbs)
		if(current_limb.status & LIMB_DESTROYED) continue
		temp = new /icon(icobase, get_limb_icon_name(human.species, b_icon, human.gender, current_limb.name, e_icon))
		if(current_limb.status & LIMB_ROBOT)
			temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		preview_icon.Blend(temp, ICON_OVERLAY)

	//Tail
	if(human.species.tail)
		temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[human.species.tail]_s")
		preview_icon.Blend(temp, ICON_OVERLAY)


	var/icon/eyes_s = new/icon("icon" = 'icons/mob/humans/onmob/human_face.dmi', "icon_state" = human.species ? human.species.eyes : "eyes_s")

	eyes_s.Blend(rgb(human.r_eyes, human.g_eyes, human.b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = GLOB.hair_styles_list[human.h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(human.r_hair, human.g_hair, human.b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list[human.f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(human.r_facial, human.g_facial, human.b_facial), ICON_ADD)
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
