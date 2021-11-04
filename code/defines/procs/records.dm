/proc/CreateGeneralRecord()
	var/datum/data/record/G = new /datum/data/record()
	G.fields["name"] = "New Record"
	G.fields["id"] = text("[]", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	G.fields["rank"] = "Unassigned"
	G.fields["real_rank"] = "Unassigned"
	G.fields["sex"] = "Male"
	G.fields["age"] = "Unknown"
	G.fields["ethnicity"] = "Unknown"
	G.fields["p_stat"] = "Active"
	G.fields["m_stat"] = "Stable"
	G.fields["species"] = "Human"
	G.fields["home_system"]	= "Unknown"
	G.fields["citizenship"]	= "Unknown"
	G.fields["faction"]		= "Unknown"
	G.fields["mob_faction"]	= "Unknown"
	G.fields["religion"]	= "Unknown"
	GLOB.data_core.general += G
	return G

/proc/CreateSecurityRecord(var/name as text, var/id as text)
	var/datum/data/record/R = new /datum/data/record()
	R.fields["name"] = name
	R.fields["id"] = id
	R.name = text("Security Record #[id]")
	R.fields["incidents"] = "None"
	GLOB.data_core.security += R
	return R

/proc/create_medical_record(var/mob/living/carbon/human/H)
	var/datum/data/record/M			= new /datum/data/record()
	M.fields["id"]					= null
	M.fields["name"]				= H.real_name
	M.fields["b_type"]				= H.b_type
	M.fields["mi_dis"]				= "None"
	M.fields["mi_dis_d"]			= "No minor disabilities have been declared."
	M.fields["ma_dis"]				= "None"
	M.fields["ma_dis_d"]			= "No major disabilities have been diagnosed."
	M.fields["alg"]					= "None"
	M.fields["alg_d"]				= "No allergies have been detected in this patient."
	M.fields["cdi"]					= "None"
	M.fields["cdi_d"]				= "No diseases have been diagnosed at the moment."
	M.fields["last_scan_time"]		= null
	M.fields["last_scan_result"]	= "No scan data on record"
	M.fields["autodoc_data"]		= list()
	M.fields["autodoc_manual"]		= list()
	M.fields["ref"]					= WEAKREF(H)
	GLOB.data_core.medical += M
	return M
