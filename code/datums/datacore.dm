GLOBAL_DATUM_INIT(data_core, /datum/datacore, new)

/datum/datacore
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()
	var/leveled_riflemen = 0
	var/leveled_riflemen_max = 7
	var/update_flags = NONE

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
	for(var/datum/data/record/record_entry in general)
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
		update_flags |= FLAG_DATA_CORE_GENERAL_UPDATED
		return TRUE
	return FALSE

/datum/datacore/proc/manifest_delete_all_medical()
	msg_admin_niche("[key_name_admin(usr)] deleted all medical records.")
	QDEL_LIST(medical)
	update_flags |= FLAG_DATA_CORE_MEDICAL_UPDATED

/datum/datacore/proc/manifest_medical_emp_act(severity)
	for(var/datum/data/record/R as anything in medical)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					msg_admin_niche("The medical record name of [R.fields["name"]] was scrambled!")
					R.fields["name"] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields["sex"] = pick("Male", "Female")
					msg_admin_niche("The medical record sex of [R.fields["name"]] was scrambled!")
				if(3)
					R.fields["age"] = rand(5, 85)
					msg_admin_niche("The medical record age of [R.fields["name"]] was scrambled!")
				if(4)
					R.fields["b_type"] = pick("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
					msg_admin_niche("The medical record blood type of [R.fields["name"]] was scrambled!")
				if(5)
					R.fields["p_stat"] = pick("*SSD*", "Active", "Physically Unfit", "Disabled")
					msg_admin_niche("The medical record physical state of [R.fields["name"]] was scrambled!")
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
					msg_admin_niche("The medical record mental state of [R.fields["name"]] was scrambled!")
			continue

		else if(prob(1))
			msg_admin_niche("The medical record of [R.fields["name"]] was lost!")
			medical -= R
			qdel(R)
			continue
	update_flags |= FLAG_DATA_CORE_MEDICAL_UPDATED

/datum/datacore/proc/manifest_delete_all_security()
	msg_admin_niche("[key_name_admin(usr)] deleted all security records.")
	QDEL_LIST(security)

	update_flags |= FLAG_DATA_CORE_SECURITY_UPDATED

/datum/datacore/proc/manifest_security_emp_act(severity)
	for(var/datum/data/record/R in security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					msg_admin_niche("The employment record name of [R.fields["name"]] was scrambled!")
					R.fields["name"] = "[pick(pick(GLOB.first_names_male), pick(GLOB.first_names_female))] [pick(GLOB.last_names)]"
				if(2)
					R.fields["sex"] = pick("Male", "Female")
					msg_admin_niche("The employment record sex of [R.fields["name"]] was scrambled!")
				if(3)
					R.fields["age"] = rand(5, 85)
					msg_admin_niche("The employment record age of [R.fields["name"]] was scrambled!")
				if(4)
					R.fields["criminal"] = pick("None", "*Arrest*", "Incarcerated", "Released")
					msg_admin_niche("The employment record criminal status of [R.fields["name"]] was scrambled!")
				if(5)
					R.fields["p_stat"] = pick("*Unconscious*", "Active", "Physically Unfit")
					msg_admin_niche("The employment record physical state of [R.fields["name"]] was scrambled!")
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
					msg_admin_niche("The employment record mental state of [R.fields["name"]] was scrambled!")
			continue

		else if(prob(1))
			msg_admin_niche("The employment record of [R.fields["name"]] was lost!")
			security -= R
			qdel(R)
			continue
	update_flags |= FLAG_DATA_CORE_SECURITY_UPDATED

/datum/datacore/proc/manifest_delete_medical_record(datum/data/record/target)
	if(!istype(target, /datum/data/record))
		return
	for(var/datum/data/record/R as anything in medical)
		if ((R.fields["name"] == target.fields["name"] || R.fields["id"] == target.fields["id"]))
			medical -= R
			qdel(R)
	msg_admin_niche("[key_name_admin(usr)] deleted all employment records for [target.fields["name"]] ([target.fields["id"]]).")
	QDEL_NULL(target)
	update_flags |= FLAG_DATA_CORE_MEDICAL_UPDATED

/datum/datacore/proc/manifest_inject_medical_record(datum/data/record/record)
	medical += record
	update_flags |= FLAG_DATA_CORE_MEDICAL_UPDATED

/datum/datacore/proc/manifest_delete(mob/living/carbon/human/target)
	//Delete them from datacore.
	var/target_ref = WEAKREF(target)
	for(var/datum/data/record/R as anything in medical)
		if((R.fields["ref"] == target_ref))
			medical -= R
			qdel(R)
	for(var/datum/data/record/T in security)
		if((T.fields["ref"] == target_ref))
			security -= T
			qdel(T)
	for(var/datum/data/record/G in general)
		if((G.fields["ref"] == target_ref))
			general -= G
			qdel(G)
	update_flags |= FLAG_DATA_CORE_MEDICAL_UPDATED|FLAG_DATA_CORE_SECURITY_UPDATED|FLAG_DATA_CORE_GENERAL_UPDATED

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
	record_general.fields["sex"] = capitalize(target.gender)
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
	manifest_inject_medical_record(record_medical)

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
	update_flags |= FLAG_DATA_CORE_MEDICAL_UPDATED|FLAG_DATA_CORE_SECURITY_UPDATED|FLAG_DATA_CORE_GENERAL_UPDATED


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
	clothes_s = new /icon('icons/mob/humans/onmob/clothing/uniforms/underwear_uniforms.dmi', "marine_underpants_s")
	clothes_s.Blend(new /icon('icons/mob/humans/onmob/clothing/feet.dmi', "black"), ICON_UNDERLAY)
	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	qdel(eyes_s)
	qdel(clothes_s)

	return preview_icon
