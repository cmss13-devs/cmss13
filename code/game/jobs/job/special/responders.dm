/datum/job/fax_responder
	title = JOB_FAX_RESPONDER
	gear_preset = /datum/equipment_preset/fax_responder
	selection_class = "job_command"
	supervisors = "CMSS13 Administration Staff"
	total_positions = 1
	spawn_positions = 1

	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_NO_ACCOUNT|ROLE_CUSTOM_SPAWN|ROLE_HIDDEN
	flags_whitelist = WHITELIST_FAX_RESPONDER

	gear_preset = /datum/equipment_preset/fax_responder
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to answer faxes sent to your fax machine. You are answering on behalf of the CMSS13 staff team and are therefore expected to behave appropriately. You are not able to authorise ERTs."

AddTimelock(/datum/job/fax_responder, list(
	JOB_POLICE_ROLES = 25 HOURS,
	JOB_COMMAND_ROLES = 75 HOURS,
))

/datum/job/fax_responder/uscm_hc
	title = JOB_FAX_RESPONDER_USCM_HC
	gear_preset = /datum/equipment_preset/fax_responder/uscm

/datum/job/fax_responder/uscm_pvst
	title = JOB_FAX_RESPONDER_USCM_PVST
	gear_preset = /datum/equipment_preset/fax_responder/uscm/provost

AddTimelock(/datum/job/fax_responder/uscm_pvst, list(
	JOB_POLICE_ROLES = 150 HOURS,
	JOB_COMMAND_ROLES = 50 HOURS,
))

/datum/job/fax_responder/wy
	title = JOB_FAX_RESPONDER_WY
	gear_preset = /datum/equipment_preset/fax_responder/wey_yu

AddTimelock(/datum/job/fax_responder/wy, list(
	JOB_CORPORATE_ROLES = 150 HOURS,
))

/datum/job/fax_responder/upp
	title = JOB_FAX_RESPONDER_UPP
	gear_preset = /datum/equipment_preset/fax_responder/upp

/datum/job/fax_responder/twe
	title = JOB_FAX_RESPONDER_TWE
	gear_preset = /datum/equipment_preset/fax_responder/twe

/datum/job/fax_responder/clf
	title = JOB_FAX_RESPONDER_CLF
	gear_preset = /datum/equipment_preset/fax_responder/clf
