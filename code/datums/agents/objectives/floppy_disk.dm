/datum/agent_objective/floppy_disk
	description = ""
	completed = FALSE

/datum/agent_objective/floppy_disk/New(datum/agent/A)
	. = ..()

	var/mob/living/carbon/human/H = belonging_to_agent.source_human

	var/obj/item/device/agents/floppy_disk/disk = new(H)
	if(!H.equip_to_slot_if_possible(disk, WEAR_IN_BACK))
		if(!H.equip_to_slot_if_possible(disk, WEAR_L_HAND))
			if(!H.equip_to_slot_if_possible(disk, WEAR_R_HAND))
				disk.loc = H.loc

	RegisterSignal(disk, COMSIG_AGENT_DISK_INSERTED, .proc/inserted_disk)

/datum/agent_objective/floppy_disk/generate_objective_body_message()
	var/obj/O = /obj/item/device/agents/floppy_disk
	return "Ruin the computer systems, by [SPAN_BOLD("[SPAN_BLUE("inserting")]")] the [SPAN_BOLD("[SPAN_RED("[initial(O.name)]")]")] in a sensor computer in CIC."

/datum/agent_objective/floppy_disk/generate_description()
	var/obj/O = /obj/item/device/agents/floppy_disk
	description = "Ruin the computer systems, by inserting the [initial(O.name)] in a sensor computer in CIC."

/datum/agent_objective/floppy_disk/proc/inserted_disk()
	SIGNAL_HANDLER
	if(completed)
		return

	completed = TRUE

/datum/agent_objective/floppy_disk/check_completion_round_end()
	. = ..()
	if(. && completed)
		return TRUE

	return FALSE
