/datum/job/logistics
	supervisors = "the acting commander"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 7

//Chief Engineer
/datum/job/logistics/engineering
	title = "Chief Engineer"
	flag = ROLE_CHIEF_ENGINEER
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	selection_color = "#ffeeaa"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief Engineer"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"Your job is to maintain the ship's engine and keep everything running.
If you have no idea how to set up the engine, or it's your first time, adminhelp so that a mentor can assist you.
You are also next in the chain of command, should the bridge crew fall in the line of duty."}

//Requisitions Officer
/datum/job/logistics/requisition
	title = "Requisitions Officer"
	flag = ROLE_REQUISITION_OFFICER
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	selection_color = "#9990B2"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Requisitions Officer"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"Your job is to dispense supplies to the marines, including weapon attachments.
Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off.
While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed.
A happy ship is a well-functioning ship."}

/datum/job/logistics/tech
	minimal_player_age = 3

//Maintenance Tech
/datum/job/logistics/tech/maint
	title = "Maintenance Tech"
	flag = ROLE_MAINTENANCE_TECH
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allow_additional = 1
	scaled = 1
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Maintenance Tech"

	set_spawn_positions(var/count)
		spawn_positions = mt_slot_formula(count)

	get_total_positions(var/latejoin = 0)
		return (latejoin ? mt_slot_formula(get_total_marines()) : spawn_positions)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"Your job is to make sure the ship is clean and the powergrid is operational.
Start with the ship's engine, and don't forget radiation equipment."}

//Cargo Tech. Don't ask why this is in engineering
/datum/job/logistics/tech/cargo
	title = "Cargo Technician"
	flag = ROLE_REQUISITION_TECH
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "the requisitions officer"
	selection_color = "#BAAFD9"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Cargo Technician"

	set_spawn_positions(var/count)
		spawn_positions = ct_slot_formula(count)

	get_total_positions(var/latejoin = 0)
		return (latejoin ? ct_slot_formula(get_total_marines()) : spawn_positions)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"Your job is to dispense supplies to the marines, including weapon attachments.
Stay in your department when possible to ensure the marines have full access to the supplies they may require.
Listen to the radio in case someone requests a supply drop via the overwatch system."}
