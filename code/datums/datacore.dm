GLOBAL_DATUM_INIT(data_core, /obj/effect/datacore, new)

/obj/effect/datacore
	name = "datacore"
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()

/obj/effect/datacore/proc/get_manifest(monochrome, OOC, nonHTML)
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
		for(var/datum/data/record/t in GLOB.data_core.general)
			if(t.fields["mob_faction"] != FACTION_MARINE)	//we process only USCM humans
				continue
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/squad = t.fields["squad"]
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

	for(var/datum/data/record/t in GLOB.data_core.general)
		if(t.fields["mob_faction"] != FACTION_MARINE)	//we process only USCM humans
			continue

		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/real_rank = t.fields["real_rank"]
		var/squad_name = t.fields["squad"]
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
			isactive[name] = t.fields["p_stat"]
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

/obj/effect/datacore/proc/manifest(var/nosleep = 0)
	spawn()
		if(!nosleep)
			sleep(40)

		var/list/jobs_to_check = ROLES_CIC + ROLES_AUXIL_SUPPORT + ROLES_MISC + ROLES_POLICE + ROLES_ENGINEERING + ROLES_REQUISITION + ROLES_MEDICAL + ROLES_MARINES
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(H.job in jobs_to_check)
				manifest_inject(H)
		return

/obj/effect/datacore/proc/manifest_modify(name, assignment, rank, p_stat)
	var/datum/data/record/foundrecord

	for(var/datum/data/record/t in GLOB.data_core.general)
		if (t)
			if(t.fields["name"] == name)
				foundrecord = t
				break

	if(foundrecord)
		if(assignment)
			foundrecord.fields["rank"] = assignment
		if (rank)
			foundrecord.fields["real_rank"] = rank
		if (p_stat)
			foundrecord.fields["p_stat"] = p_stat

/obj/effect/datacore/proc/manifest_inject(var/mob/living/carbon/human/H)
	var/assignment
	if(H.job)
		assignment = H.job
	else
		assignment = "Unassigned"

	var/id = add_zero(num2hex(H.gid), 6)	//this was the best they could come up with? A large random number? *sigh*
	//var/icon/front = new(get_id_photo(H), dir = SOUTH)
	//var/icon/side = new(get_id_photo(H), dir = WEST)

	//General Record
	var/datum/data/record/G = new()
	G.fields["id"]			= id
	G.fields["name"]		= H.real_name
	G.fields["real_rank"]	= H.job
	G.fields["rank"]		= assignment
	G.fields["squad"]		= H.assigned_squad ? H.assigned_squad.name : null
	G.fields["age"]			= H.age
	G.fields["p_stat"]		= "Active"
	G.fields["m_stat"]		= "Stable"
	G.fields["sex"]			= H.gender
	G.fields["species"]		= H.get_species()
	G.fields["home_system"]	= H.home_system
	G.fields["citizenship"]	= H.citizenship
	G.fields["faction"]		= H.personal_faction
	G.fields["mob_faction"]	= H.faction
	G.fields["religion"]	= H.religion
	//G.fields["photo_front"]	= front
	//G.fields["photo_side"]	= side

	if(H.gen_record && !jobban_isbanned(H, "Records"))
		G.fields["notes"] = H.gen_record
	else
		G.fields["notes"] = "No notes found."
	general += G

	//Medical Record
	var/datum/data/record/M = new()
	M.fields["id"]			= id
	M.fields["name"]		= H.real_name
	M.fields["b_type"]		= H.blood_type
	M.fields["mi_dis"]		= "None"
	M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
	M.fields["ma_dis"]		= "None"
	M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
	M.fields["alg"]			= "None"
	M.fields["alg_d"]		= "No allergies have been detected in this patient."
	M.fields["cdi"]			= "None"
	M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
	M.fields["last_scan_time"]		= null
	M.fields["last_scan_result"]		= "No scan data on record" // body scanner results
	M.fields["autodoc_data"] = list()
	M.fields["autodoc_manual"] = list()

	if(H.med_record && !jobban_isbanned(H, "Records"))
		M.fields["notes"] = H.med_record
	else
		M.fields["notes"] = "No notes found."
	medical += M

	//Security Record
	var/datum/data/record/S = new()
	S.fields["id"]			= id
	S.fields["name"]		= H.real_name
	S.fields["criminal"]	= "None"
	S.fields["incident"]	= ""
	security += S

	//Locked Record
	var/datum/data/record/L = new()
	L.fields["id"]			= md5("[H.real_name][H.job]")
	L.fields["name"]		= H.real_name
	L.fields["rank"] 		= H.job
	L.fields["age"]			= H.age
	L.fields["sex"]			= H.gender
	L.fields["b_type"]		= H.b_type
	L.fields["species"]		= H.get_species()
	L.fields["home_system"]	= H.home_system
	L.fields["citizenship"]	= H.citizenship
	L.fields["faction"]		= H.personal_faction
	L.fields["religion"]	= H.religion

	if(H.exploit_record && !jobban_isbanned(H, "Records"))
		L.fields["exploit_record"] = H.exploit_record
	else
		L.fields["exploit_record"] = "No additional information acquired."
	locked += L


proc/get_id_photo(var/mob/living/carbon/human/H)
	var/icon/preview_icon = null

	//var/g = "m"
	//if (H.gender == FEMALE)
	//	g = "f"

	var/icon/icobase = H.species.icobase
	var/icon/temp

	var/datum/ethnicity/ET = GLOB.ethnicities_list[H.ethnicity]
	var/datum/body_type/B = GLOB.body_types_list[H.body_type]

	var/e_icon
	var/b_icon

	if (!ET)
		e_icon = "western"
	else
		e_icon = ET.icon_name

	if (!B)
		b_icon = "mesomorphic"
	else
		b_icon = B.icon_name

	preview_icon = new /icon(icobase, get_limb_icon_name(H.species, b_icon, H.gender, "torso", e_icon))
	temp = new /icon(icobase, get_limb_icon_name(H.species, b_icon, H.gender, "groin", e_icon))
	preview_icon.Blend(temp, ICON_OVERLAY)
	temp = new /icon(icobase, get_limb_icon_name(H.species, b_icon, H.gender, "head", e_icon))
	preview_icon.Blend(temp, ICON_OVERLAY)

	for(var/obj/limb/E in H.limbs)
		if(E.status & LIMB_DESTROYED) continue
		temp = new /icon(icobase, get_limb_icon_name(H.species, b_icon, H.gender, E.name, e_icon))
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
