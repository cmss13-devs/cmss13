/datum/job/civilian/liaison/reporter
	title = JOB_COMBAT_REPORTER
	supervisors = "the press"
	gear_preset = /datum/equipment_preset/uscm_ship/reporter

/datum/job/civilian/liaison/reporter/generate_entry_message(mob/living/carbon/human/H)
	. = {"What a scoop! You've been assigned to the USS Almayer to see what kinda mischief they'd get into and it seems trouble is here!
This could be the story of the sector! 'Brave Marines responding to dangerous distress signal!' It'd surely get Mr. Parkerson to notice you in the office if you brought him a story like this!"}

/obj/effect/landmark/start/liaison/reporter
	name = JOB_COMBAT_REPORTER
	job = /datum/job/civilian/liaison/reporter
