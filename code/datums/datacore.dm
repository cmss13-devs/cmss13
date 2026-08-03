GLOBAL_DATUM_INIT(data_core, /datum/datacore, new)

/datum/datacore
	var/medical[] = list()
	var/general[] = list()
	var/security[] = list()
	//This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/locked[] = list()
	var/leveled_riflemen = 0
	var/leveled_riflemen_max = 7

/datum/datacore/proc/manifest(nosleep = 0)
	spawn()
		if(!nosleep)
			sleep(40)

		var/list/jobs_to_check = GLOB.ROLES_USCM + GLOB.ROLES_WO

		for(var/mob/living/carbon/human/current_human as anything in GLOB.human_mob_list)
			if(should_block_game_interaction(current_human))
				continue

			if(is_in_manifest(current_human))
				continue

			if(current_human.job in jobs_to_check)
				manifest_inject(current_human)

/datum/datacore/proc/is_in_manifest(mob/living/carbon/human/current_human)
	var/weakref = WEAKREF(current_human)

	for(var/datum/data/record/current_record as anything in general)
		if(current_record.fields["ref"] == weakref)
			return TRUE

	return FALSE

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

	var/manifest_title
	if(target?.assigned_equipment_preset.manifest_title)
		manifest_title = target.assigned_equipment_preset.manifest_title
	else
		manifest_title = target.job

	var/id = add_zero(num2hex(target.gid), 6) //this was the best they could come up with? A large random number? *sigh*
	var/icon/front = new(get_id_photo(target), dir = SOUTH)
	var/icon/side = new(get_id_photo(target), dir = WEST)


	//General Record
	var/datum/data/record/record_general = new()
	record_general.fields["id"] = id
	record_general.fields["name"] = target.real_name
	record_general.name = target.real_name
	record_general.fields["real_rank"] = assignment
	record_general.fields["rank"] = manifest_title
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
	record_general.fields["photo_front"] = front
	record_general.fields["photo_side"] = side

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
	record_medical.fields["blood_type"] = target.blood_type
	record_medical.fields["minor_disability"] = "None"
	record_medical.fields["minor_disability_details"] = "No minor disabilities have been declared."
	record_medical.fields["major_disability"] = "None"
	record_medical.fields["major_disability_details"] = "No major disabilities have been diagnosed."
	record_medical.fields["allergies"] = "None"
	record_medical.fields["allergies_details"] = "No allergies have been detected in this patient."
	record_medical.fields["diseases"] = "None"
	record_medical.fields["diseases_details"] = "No diseases have been diagnosed at the moment."
	record_medical.fields["last_scan_time"] = null
	record_medical.fields["last_scan_result"] = "No scan data on record" // body scanner results
	record_medical.fields["autodoc_data"] = list()
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
	record_locked.fields["blood_type"] = target.blood_type
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
		if(E.status & LIMB_DESTROYED)
			continue
		temp = new /icon(icobase, get_limb_icon_name(H.species, body_size_icon, body_type_icon, H.gender, E.name, skin_color_icon))
		if(E.status & LIMB_ROBOT)
			temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		preview_icon.Blend(temp, ICON_OVERLAY)

	//Tail
	if(H.species.tail)
		temp = new/icon("icon" = H.species.icobase, "icon_state" = "[H.species.tail]_s")
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
	clothes_s = new /icon('icons/mob/humans/body_mask.dmi', "marine_uniform")
	clothes_s.Blend(new /icon('icons/mob/humans/onmob/clothing/feet.dmi', "marine"), ICON_UNDERLAY)

	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(clothes_s)
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	qdel(eyes_s)
	qdel(clothes_s)

	return preview_icon
