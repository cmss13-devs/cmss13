/proc/CreateGeneralRecord()
	var/datum/data/record/gen_record = new /datum/data/record()
	gen_record.fields["name"] = "New Record"
	gen_record.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	gen_record.fields["rank"] = "Unassigned"
	gen_record.fields["real_rank"] = "Unassigned"
	gen_record.fields["sex"] = "Male"
	gen_record.fields["age"] = "Unknown"
	gen_record.fields["ethnicity"] = "Unknown"
	gen_record.fields["p_stat"] = "Active"
	gen_record.fields["m_stat"] = "Stable"
	gen_record.fields["species"] = "Human"
	gen_record.fields["origin"] = "Unknown"
	gen_record.fields["faction"] = "Unknown"
	gen_record.fields["mob_faction"] = "Unknown"
	gen_record.fields["religion"] = "Unknown"
	GLOB.data_core.general += gen_record
	return gen_record

/proc/CreateSecurityRecord(name as text, id as text)
	var/datum/data/record/sec_record = new /datum/data/record()
	sec_record.fields["name"] = name
	sec_record.fields["id"] = id
	sec_record.name = text("Security Record #[id]")
	sec_record.fields["incidents"] = "None"
	GLOB.data_core.security += sec_record
	return sec_record

/proc/create_medical_record(mob/living/carbon/human/H)
	var/datum/data/record/med_record = new /datum/data/record()
	med_record.fields["id"] = null
	med_record.fields["name"] = H.real_name
	med_record.fields["b_type"] = H.b_type
	med_record.fields["mi_dis"] = "None"
	med_record.fields["mi_dis_d"] = "No minor disabilities have been declared."
	med_record.fields["ma_dis"] = "None"
	med_record.fields["ma_dis_d"] = "No major disabilities have been diagnosed."
	med_record.fields["alg"] = "None"
	med_record.fields["alg_d"] = "No allergies have been detected in this patient."
	med_record.fields["cdi"] = "None"
	med_record.fields["cdi_d"] = "No diseases have been diagnosed at the moment."
	med_record.fields["last_scan_time"] = null
	med_record.fields["last_scan_result"] = "No scan data on record"
	med_record.fields["autodoc_data"] = list()
	med_record.fields["autodoc_manual"] = list()
	med_record.fields["ref"] = WEAKREF(H)
	GLOB.data_core.medical += med_record
	return med_record
