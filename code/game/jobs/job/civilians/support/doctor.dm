// Doctor
/datum/job/civilian/doctor
	title = JOB_DOCTOR
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor
	entry_message_body = "You're a commissioned officer of the USCM, though you are not in the ship's chain of command. You are tasked with keeping the marines healthy and strong, usually in the form of surgery. You are also an expert when it comes to medication and treatment. If you do not know what you are doing, mentorhelp so a mentor can assist you."

/datum/job/civilian/doctor/set_spawn_positions(var/count)
	spawn_positions = doc_slot_formula(count)

/datum/job/civilian/doctor/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = doc_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/civilian/doctor, list(
	JOB_MEDIC_ROLES = 1 HOURS
))

/obj/effect/landmark/start/doctor
	name = JOB_DOCTOR
	job = /datum/job/civilian/doctor
