/hook/startup/proc/createDatacore()
	data_core = new /obj/effect/datacore()
	return 1

/obj/effect/datacore
	name = "datacore"
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()

/obj/effect/datacore/proc/get_manifest(monochrome, OOC)
	var/list/cic = new()
	var/list/auxil = new()
	var/list/misc = new()
	var/list/mp = new()
	var/list/eng = new()
	var/list/req = new()
	var/list/med = new()
	var/list/mar = new()
	var/list/isactive = new()
	var/list/squads = new()

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

	for(var/datum/data/record/t in data_core.general)
		if(t.fields["mob_faction"] != FACTION_MARINE)	//we process only USCM humans
			continue

		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/real_rank = t.fields["real_rank"]
		var/squad_name = t.fields["squad"]

		if(OOC)
			var/active = 0
			for(var/mob/M in player_list)
				if(M.real_name == name && M.client && M.client.inactivity <= 10 * 60 * 10)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = t.fields["p_stat"]
			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line

		if(real_rank in ROLES_CIC)
			cic[name] = rank
		else if(real_rank in ROLES_AUXIL_SUPPORT)
			auxil[name] = rank
		else if(real_rank in ROLES_MISC)
			misc[name] = rank
		else if(real_rank in ROLES_POLICE)
			mp[name] = rank
		else if(real_rank in ROLES_ENGINEERING)
			eng[name] = rank
		else if(real_rank in ROLES_REQUISITION)
			req[name] = rank
		else if(real_rank in ROLES_MEDICAL)
			med[name] = rank
		else if(real_rank in ROLES_MARINES)
			squads[name] = squad_name
			mar[name] = rank

	//here we sort marines
	var/mar_sl = list()
	var/mar_spc = list()
	var/mar_sg = list()
	var/mar_med = list()
	var/mar_eng = list()
	var/mar_pfc = list()
	for(var/i in mar)
		if(mar[i] == JOB_SQUAD_LEADER)
			mar_sl[i] = mar[i]
		else if(mar[i] == JOB_SQUAD_SPECIALIST)
			mar_spc[i] = mar[i]
		else if(mar[i] == JOB_SQUAD_SMARTGUN)
			mar_sg[i] = mar[i]
		else if(mar[i] == JOB_SQUAD_MEDIC)
			mar_med[i] = mar[i]
		else if(mar[i] == JOB_SQUAD_ENGI)
			mar_eng[i] = mar[i]
		else if(mar[i] == JOB_SQUAD_MARINE)
			mar_pfc[i] = mar[i]
	mar.Cut()
	mar = mar_sl + mar_spc + mar_sg + mar_med + mar_eng + mar_pfc

	//here we fill manifest
	if(LAZYLEN(cic))
		dat += "<tr><th colspan=3>Command</th></tr>"
		for(name in cic)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[cic[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(LAZYLEN(auxil))
		dat += "<tr><th colspan=3>Auxiliary Combat Support</th></tr>"
		for(name in auxil)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[auxil[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(LAZYLEN(mar))
		dat += "<tr><th colspan=3>Marines</th></tr>"
		for(var/j in list(SQUAD_NAME_1, SQUAD_NAME_2, SQUAD_NAME_3, SQUAD_NAME_4))
			dat += "<tr><th colspan=3>[j]</th></tr>"
			for(name in mar)
				if(squads[name] == j)
					dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[mar[name]]</td><td>[isactive[name]]</td></tr>"
					even = !even
	if(LAZYLEN(mp))
		dat += "<tr><th colspan=3>Military Police</th></tr>"
		for(name in mp)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[mp[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(LAZYLEN(eng))
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(name in eng)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[eng[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(LAZYLEN(req))
		dat += "<tr><th colspan=3>Requisition</th></tr>"
		for(name in req)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[req[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(LAZYLEN(med))
		dat += "<tr><th colspan=3>Medbay</th></tr>"
		for(name in med)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[med[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(LAZYLEN(misc))
		dat += "<tr><th colspan=3>Other</th></tr>"
		for(name in misc)
			dat += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[misc[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even

	dat += "</table></div>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/obj/effect/datacore/proc/manifest(var/nosleep = 0)
	spawn()
		if(!nosleep)
			sleep(40)
		for(var/mob/living/carbon/human/H in player_list)
			if(H.species && H.species.name == "Yautja") 
				continue
			manifest_inject(H)
		return

/obj/effect/datacore/proc/manifest_modify(name, assignment, rank)
	var/datum/data/record/foundrecord

	for(var/datum/data/record/t in data_core.general)
		if (t)
			if(t.fields["name"] == name)
				foundrecord = t
				break

	if(foundrecord)
		foundrecord.fields["rank"] = assignment
		foundrecord.fields["real_rank"] = rank

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

	var/datum/ethnicity/ET = ethnicities_list[H.ethnicity]
	var/datum/body_type/B = body_types_list[H.body_type]

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

	var/datum/sprite_accessory/hair_style = hair_styles_list[H.h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[H.f_style]
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
