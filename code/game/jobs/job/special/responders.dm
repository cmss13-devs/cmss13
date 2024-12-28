/datum/job/fax_responder
	title = JOB_FAX_RESPONDER
	gear_preset = /datum/equipment_preset/fax_responder
	selection_class = "job_command"
	supervisors = "CMSS13 Administration Staff"
	total_positions = 1
	spawn_positions = 1

	late_joinable = FALSE

	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_NO_ACCOUNT|ROLE_CUSTOM_SPAWN|ROLE_HIDDEN
	flags_whitelist = WHITELIST_FAX_RESPONDER

/datum/job/fax_responder/on_config_load()
	entry_message_body = "<a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_FAX_RESPONDER]'>Your job</a> is to answer faxes sent to your fax machine. You are answering on behalf of the CMSS13 staff team and are therefore expected to behave appropriately. Failure to adhere to expectations may result in loss of the role or a server ban. Non-staff players of this role are not able to authorise ERTs through their faxes."
	return ..()

/datum/job/fax_responder/uscm_hc
	title = JOB_FAX_RESPONDER_USCM_HC
	gear_preset = /datum/equipment_preset/fax_responder/uscm

AddTimelock(/datum/job/fax_responder/uscm_hc, list(
	JOB_POLICE_ROLES = 25 HOURS,
	JOB_COMMAND_ROLES = 75 HOURS,
))

/datum/job/fax_responder/uscm_pvst
	title = JOB_FAX_RESPONDER_USCM_PVST
	gear_preset = /datum/equipment_preset/fax_responder/uscm/provost

AddTimelock(/datum/job/fax_responder/uscm_pvst, list(
	JOB_POLICE_ROLES = 75 HOURS,
	JOB_COMMAND_ROLES = 75 HOURS,
))

/datum/job/fax_responder/wy
	title = JOB_FAX_RESPONDER_WY
	gear_preset = /datum/equipment_preset/fax_responder/wey_yu

AddTimelock(/datum/job/fax_responder/wy, list(
	JOB_CORPORATE_ROLES = 75 HOURS,
))

/datum/job/fax_responder/upp
	title = JOB_FAX_RESPONDER_UPP
	gear_preset = /datum/equipment_preset/fax_responder/upp

AddTimelock(/datum/job/fax_responder/upp, list(
	JOB_COMMAND_ROLES = 75 HOURS,
))

/datum/job/fax_responder/twe
	title = JOB_FAX_RESPONDER_TWE
	gear_preset = /datum/equipment_preset/fax_responder/twe

AddTimelock(/datum/job/fax_responder/twe, list(
	JOB_COMMAND_ROLES = 75 HOURS,
))

/datum/job/fax_responder/clf
	title = JOB_FAX_RESPONDER_CLF
	gear_preset = /datum/equipment_preset/fax_responder/clf

AddTimelock(/datum/job/fax_responder/clf, list(
	JOB_COMMAND_ROLES = 75 HOURS,
))

/datum/job/fax_responder/cmb
	title = JOB_FAX_RESPONDER_CMB
	gear_preset = /datum/equipment_preset/fax_responder/cmb

AddTimelock(/datum/job/fax_responder/cmb, list(
	JOB_POLICE_ROLES = 75 HOURS,
	JOB_COMMAND_ROLES = 25 HOURS,
))

/datum/job/fax_responder/press
	title = JOB_FAX_RESPONDER_PRESS
	gear_preset = /datum/equipment_preset/fax_responder/press

AddTimelock(/datum/job/fax_responder/press, list(
	JOB_CIVIL_ROLES = 25 HOURS,
))
