/datum/equipment_preset/fax_responder
	//name = "Fax Responder"
	assignment = JOB_FAX_RESPONDER_RU

/datum/equipment_preset/fax_responder/uscm
	//name = "Fax Responder - USCM HC"
	assignment = JOB_FAX_RESPONDER_USCM_HC_RU

/datum/equipment_preset/fax_responder/uscm/provost
	//name = "Fax Responder - USCM Provost"
	assignment = JOB_FAX_RESPONDER_USCM_PVST_RU

/datum/equipment_preset/fax_responder/wey_yu
	//name = "Fax Responder - WY"
	assignment = JOB_FAX_RESPONDER_WY_RU

/datum/equipment_preset/fax_responder/upp
	//name = "Fax Responder - UPP"
	assignment = JOB_FAX_RESPONDER_UPP_RU

/datum/equipment_preset/fax_responder/twe
	//name = "Fax Responder - TWE"
	assignment = JOB_FAX_RESPONDER_TWE_RU

/datum/equipment_preset/fax_responder/clf
	//name = "Fax Responder - CLF"
	assignment = JOB_FAX_RESPONDER_CLF_RU

/datum/equipment_preset/fax_responder/cmb
	//name = "Fax Responder - CMB"
	assignment = JOB_FAX_RESPONDER_CMB_RU

/datum/equipment_preset/fax_responder/press
	//name = "Fax Responder - Press"
	assignment = JOB_FAX_RESPONDER_PRESS_RU

/datum/equipment_preset/fax_responder/get_fax_responder_name(client/target_client)
	var/datum/preferences/target_prefs = target_client.prefs
	var/new_name
	switch(assignment)
		if(JOB_FAX_RESPONDER_USCM_HC_RU)
			new_name = target_prefs.fax_name_uscm
		if(JOB_FAX_RESPONDER_USCM_PVST_RU)
			new_name = target_prefs.fax_name_pvst
		if(JOB_FAX_RESPONDER_WY_RU)
			new_name = target_prefs.fax_name_wy
		if(JOB_FAX_RESPONDER_UPP_RU)
			new_name = target_prefs.fax_name_upp
		if(JOB_FAX_RESPONDER_CLF_RU)
			new_name = target_prefs.fax_name_clf
		if(JOB_FAX_RESPONDER_CMB_RU)
			new_name = target_prefs.fax_name_cmb
		if(JOB_FAX_RESPONDER_PRESS_RU)
			new_name = target_prefs.fax_name_press
		if(JOB_FAX_RESPONDER_TWE_RU)
			new_name = target_prefs.fax_name_twe

	return new_name
