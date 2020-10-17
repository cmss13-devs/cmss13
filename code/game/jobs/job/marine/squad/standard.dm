/datum/job/marine/standard
	title = JOB_SQUAD_MARINE
	total_positions = -1
	spawn_positions = -1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM (Cryo) Squad Marine (PFC)"

/datum/job/marine/standard/generate_entry_message()
	entry_message_body = "You are a rank-and-file soldier of the USCM, and that is your strength. What you lack alone, you gain standing shoulder to shoulder with the men and women of the corps. Ooh-rah!"
	return ..()

/datum/job/marine/standard/equipped
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "USCM PFC (Pulse Rifle)"

/datum/job/marine/standard/equipped/whiskey
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "WO Dust Raider Squad Marine (PFC)"