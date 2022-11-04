//Requisitions Officer
/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	selection_class = "job_ro"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ro
	entry_message_body = "<a href='"+URL_WIKI_RO_GUIDE+"'>Your job</a> is to dispense supplies to the marines, including weapon attachments. Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off. While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed. A happy ship is a well-functioning ship."

AddTimelock(/datum/job/logistics/requisition, list(
	JOB_REQUISITION_ROLES = 10 HOURS,
	JOB_POLICE_ROLES = 1 HOURS
))

/obj/effect/landmark/start/requisition
	name = JOB_CHIEF_REQUISITION
	job = /datum/job/logistics/requisition
