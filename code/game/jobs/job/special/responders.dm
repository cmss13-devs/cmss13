/datum/job/responder
	selection_class = "job_command"
	supervisors = "CMSS13 Administration Staff"
	total_positions = 1
	spawn_positions = 1

	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_RESPONDER

	gear_preset = /datum/equipment_preset/responder
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to assist the marines in collecting intelligence related</a> to the current operation to better inform command of their opposition. You are in charge of gathering any data disks, folders, and notes you may find on the operational grounds and decrypt them to grant the USCM additional resources."

/datum/job/responder/uscm_hc
	title = JOB_RESPONDER_USCM_HC
	gear_preset = /datum/equipment_preset/responder/uscm

/datum/job/responder/uscm_pvst
	title = JOB_RESPONDER_USCM_PVST
	gear_preset = /datum/equipment_preset/responder/uscm/provost

/datum/job/responder/wy
	title = JOB_RESPONDER_WY
	gear_preset = /datum/equipment_preset/responder/wey_yu

/datum/job/responder/upp
	title = JOB_RESPONDER_UPP
	gear_preset = /datum/equipment_preset/responder/upp

/datum/job/responder/twe
	title = JOB_RESPONDER_TWE
	gear_preset = /datum/equipment_preset/responder/twe

/datum/job/responder/clf
	title = JOB_RESPONDER_CLF
	gear_preset = /datum/equipment_preset/responder/clf
