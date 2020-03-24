/datum/job/logistics
	supervisors = "the acting commanding officer"
	total_positions = 1
	spawn_positions = 1

//Chief Engineer
/datum/job/logistics/engineering
	title = JOB_CHIEF_ENGINEER
	flag = ROLE_CHIEF_ENGINEER
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	selection_class = "job_ce"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief Engineer (CE)"
	minimum_playtimes = list(
		JOB_ORDNANCE_TECH = HOURS_6
	)

/datum/job/logistics/engineering/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to maintain the ship's engine and keep everything running. If you have no idea how to set up the engine, or it's your first time, mentorhelp so that a mentor can assist you. You are also next in the chain of command, should the bridge crew fall in the line of duty."
	return ..()

//Requisitions Officer
/datum/job/logistics/requisition
	title = JOB_CHIEF_REQUISITION
	flag = ROLE_REQUISITION_OFFICER
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	selection_class = "job_ro"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Requisitions Officer (RO)"
	minimum_playtimes = list(
		JOB_REQUISITION = HOURS_6
	)

/datum/job/logistics/requisition/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to dispense supplies to the marines, including weapon attachments. Your cargo techs can help you out, but you have final say in your department. Make sure they're not goofing off. While you may request paperwork for supplies, do not go out of your way to screw with marines, unless you want to get deposed. A happy ship is a well-functioning ship."
	return ..()

//Ordnance Technician
/datum/job/logistics/tech
	title = JOB_ORDNANCE_TECH
	flag = ROLE_ORDNANCE_TECH
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	faction = FACTION_MARINE
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	supervisors = "the chief engineer"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Ordnance Technician (OT)"
	minimum_playtimes = list(
		JOB_SQUAD_ENGI = HOURS_3
	)

/datum/job/logistics/tech/maint/set_spawn_positions(var/count)
	spawn_positions = ot_slot_formula(count)

/datum/job/logistics/tech/maint/get_total_positions(var/latejoin = 0)
	return (latejoin ? ot_slot_formula(get_total_marines()) : spawn_positions)

/datum/job/logistics/tech/maint/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to maintain the integrity of the USCM weapons, munitions and equipment, including the orbital cannon. You can use the workshop in the portside hangar to construct new armaments for the marines. However you remain one of the more flexible roles on the ship and as such may receive other menial tasks from your superiors."
	return ..()

//Cargo Tech. Don't ask why this is in engineering
/datum/job/logistics/tech/cargo
	title = JOB_REQUISITION
	flag = ROLE_REQUISITION_TECH
	department_flag = ROLEGROUP_MARINE_ENGINEERING
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 1
	supervisors = "the requisitions officer"
	selection_class = "job_ct"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Cargo Technician (CT)"

/datum/job/logistics/tech/cargo/set_spawn_positions(var/count)
	spawn_positions = ct_slot_formula(count)

/datum/job/logistics/tech/cargo/get_total_positions(var/latejoin = 0)
	return (latejoin ? ct_slot_formula(get_total_marines()) : spawn_positions)

/datum/job/logistics/tech/cargo/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to dispense supplies to the marines, including weapon attachments. Stay in your department when possible to ensure the marines have full access to the supplies they may require. Listen to the radio in case someone requests a supply drop via the overwatch system."
	return ..()
