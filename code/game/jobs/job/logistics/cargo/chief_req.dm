/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	selection_class = "job_qm"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/qm
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to dispense supplies to the marines, organize your cargo technicians, and supply the marine's operations. You may do this through vending supplies, or using your five crate launch pads. Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off. While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed. A happy ship is a well-functioning ship. You are 10th in line for Acting Commander, behind any intelligence officers."

AddTimelock(/datum/job/logistics/requisition, list(
	JOB_REQUISITION_ROLES = 10 HOURS,
))

/obj/effect/landmark/start/requisition
	name = JOB_CHIEF_REQUISITION
	icon_state = "ro_spawn"
	job = /datum/job/logistics/requisition
