/datum/component/disk_reader
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Ref to the inserted disk
	var/obj/item/disk/objective/disk

/datum/component/disk_reader/Initialize()
	. = ..()
	if(!istype(parent, /obj/structure/machinery))
		return COMPONENT_INCOMPATIBLE

/datum/component/disk_reader/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/disk_reader/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_disk_insert))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	RegisterSignal(parent, COMSIG_INTEL_DISK_COMPLETED, PROC_REF(on_disk_complete))
	RegisterSignal(parent, COMSIG_INTEL_DISK_LOST_POWER, PROC_REF(on_power_lost))

/datum/component/disk_reader/UnregisterFromParent()
	..()
	handle_qdel()

/datum/component/disk_reader/proc/handle_qdel()
	SIGNAL_HANDLER
	QDEL_NULL(disk)

/datum/component/disk_reader/proc/on_disk_insert(datum/source, obj/item/disk/objective/potential_disk, mob/living/inserter, params)
	SIGNAL_HANDLER

	if(!istype(potential_disk) || !potential_disk.objective)
		return

	if(disk)
		to_chat(inserter, SPAN_WARNING("There's already a disk inside [parent], wait for it to finish first!"))
		return COMPONENT_NO_AFTERATTACK

	if(potential_disk.objective.state == OBJECTIVE_COMPLETE)
		to_chat(inserter, SPAN_WARNING("The reader displays a message stating this disk has already been read and refuses to accept it."))
		return COMPONENT_NO_AFTERATTACK

	INVOKE_ASYNC(src, PROC_REF(handle_disk_insert), potential_disk, inserter)
	return COMPONENT_NO_AFTERATTACK

/datum/component/disk_reader/proc/handle_disk_insert(obj/item/disk/objective/potential_disk, mob/living/inserter)
	if(tgui_input_text(inserter, "Enter the encryption key", "Decrypting [potential_disk]", "") != potential_disk.objective.decryption_password)
		to_chat(inserter, SPAN_WARNING("The reader buzzes, ejecting the disk."))
		return

	if(disk)
		to_chat(inserter, SPAN_WARNING("There's already a disk inside [parent], wait for it to finish first!"))
		return

	if(!(potential_disk in inserter.contents))
		return

	potential_disk.objective.activate()

	inserter.drop_inv_item_to_loc(potential_disk, parent)
	disk = potential_disk
	to_chat(inserter, SPAN_NOTICE("You insert [potential_disk] and enter the decryption key."))
	inserter.count_niche_stat(STATISTICS_NICHE_DISK)

/datum/component/disk_reader/proc/on_disk_complete(datum/source)
	SIGNAL_HANDLER
	var/atom/atom_parent = parent

	atom_parent.visible_message("[atom_parent] pings softly as the upload finishes and ejects [disk].")
	playsound(atom_parent, 'sound/machines/screen_output1.ogg', 25, 1)
	disk.forceMove(get_turf(atom_parent))
	disk.name = "[disk.name] (complete)"
	disk.objective.award_points()
	disk.retrieve_objective.state = OBJECTIVE_ACTIVE
	disk.retrieve_objective.activate()
	disk = null

/datum/component/disk_reader/proc/on_power_lost(datum/source)
	SIGNAL_HANDLER
	var/atom/atom_parent = parent

	atom_parent.visible_message(SPAN_WARNING("[atom_parent] powers down mid-operation as the area loses power."))
	playsound(atom_parent, 'sound/machines/terminal_shutdown.ogg', 25, 1)
	SSobjectives.stop_processing_objective(src)
	disk.forceMove(get_turf(atom_parent))
	disk = null
