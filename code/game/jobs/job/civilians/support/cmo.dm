/datum/job/civilian/professor
	title = JOB_CMO
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commander"
	selection_class = "job_cmo"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/cmo
	entry_message_body = "You're a commissioned officer of the USCM. <a href='"+WIKI_PLACEHOLDER+"'>You have authority over everything related to Medbay and Research</a>, only able to be overridden by the Acting Commander, or Commanding Officer. You are in charge of medical staff, surgery, chemistry, chemical synthesis, biological testing, mental diagnosis, and keeping the marines healthy overall.  You are 5th in line for Acting Commander, behind the Chief MP."

AddTimelock(/datum/job/civilian/professor, list(
	JOB_MEDIC_ROLES = 21 HOURS,
	JOB_DOCTOR = 9 HOURS,
	JOB_RESEARCHER = 6 HOURS
))

/obj/effect/landmark/start/professor
	name = JOB_CMO
	icon_state = "cmo_spawn"
	job = /datum/job/civilian/professor
