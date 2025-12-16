/datum/job/command/mech_op
	title = JOB_MECH_OP
	total_positions = 1
	spawn_positions = 1
	allow_additional = FALSE
	scaled = FALSE
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_CUSTOM_SPAWN|ROLE_HIDDEN
	gear_preset = /datum/equipment_preset/uscm/mech
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to support marines with your advanced Mechsuit."

/datum/job/command/mech_op/lead
	title = JOB_MECH_OP_L
	total_positions = 1
	spawn_positions = 1
	allow_additional = FALSE
	scaled = FALSE
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_CUSTOM_SPAWN|ROLE_HIDDEN
	gear_preset = /datum/equipment_preset/uscm/mech/lead
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to support marines with your advanced Mechsuit."
