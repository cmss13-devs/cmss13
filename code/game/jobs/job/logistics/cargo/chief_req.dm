/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	selection_class = "job_qm"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/qm
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to dispense supplies to the marines, including weapon attachments. Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off. While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed. A happy ship is a well-functioning ship."

/obj/effect/landmark/start/requisition
	name = JOB_CHIEF_REQUISITION
	icon_state = "ro_spawn"
	job = /datum/job/logistics/requisition
