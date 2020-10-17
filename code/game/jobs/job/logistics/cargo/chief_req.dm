//Requisitions Officer
/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	selection_class = "job_ro"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Requisitions Officer (RO)"

/datum/job/logistics/requisition/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to dispense supplies to the marines, including weapon attachments. Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off. While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed. A happy ship is a well-functioning ship."
	return ..()

AddTimelock(/datum/job/logistics/requisition, list(
	JOB_REQUISITION_ROLES = 10 HOURS
))