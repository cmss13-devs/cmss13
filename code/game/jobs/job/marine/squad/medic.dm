/datum/job/marine/medic
	title = JOB_SQUAD_MEDIC
	total_positions = 16
	spawn_positions = 16
	allow_additional = 1
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADD_TO_SQUAD
	gear_preset = "USCM (Cryo) Squad Medic"

/datum/job/marine/medic/generate_entry_message()
	entry_message_body = "You must tend the wounds of your squad mates and make sure they are healthy and active. You may not be a fully-fledged doctor, but you stand between life and death when it matters."
	return ..()

/datum/job/marine/medic/set_spawn_positions(var/count)
	for(var/datum/squad/sq in RoleAuthority.squads)
		if(sq)
			sq.max_medics = medic_slot_formula(count)

/datum/job/marine/medic/get_total_positions(var/latejoin=0)
	var/slots = medic_slot_formula(get_total_marines())

	if(slots <= total_positions_so_far)
		slots = total_positions_so_far
	else
		total_positions_so_far = slots

	if(latejoin)
		for(var/datum/squad/sq in RoleAuthority.squads)
			if(sq)
				sq.max_medics = slots

	return (slots*4)

/datum/job/marine/medic/equipped
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "USCM Cryo Medic (Equipped)"

/datum/job/marine/medic/equipped/whiskey
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = "WO Dust Raider Squad Medic"

AddTimelock(/datum/job/marine/medic, list(
	JOB_MEDIC_ROLES = 1 HOURS,
	JOB_SQUAD_ROLES = 1 HOURS
))