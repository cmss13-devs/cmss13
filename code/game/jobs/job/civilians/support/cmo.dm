/datum/job/civilian/professor
	title = JOB_CMO
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commanding officer"
	selection_class = "job_cmo"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/cmo
	entry_message_body = "You're a commissioned officer of the USCM. <a href='"+URL_WIKI_CMO_GUIDE+"'>You have authority over everything related to Medbay and Research</a>, only able to be overriden by the XO and CO. You are in charge of medical staff, surgery, chemistry, stimulants and keeping the marines healthy overall."

AddTimelock(/datum/job/civilian/professor, list(
	JOB_MEDIC_ROLES = 10 HOURS
))

/obj/effect/landmark/start/professor
	name = JOB_CMO
	job = /datum/job/civilian/professor
