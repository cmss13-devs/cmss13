// --------------------------------------------
// *** Slightly more complicated data retrieval ***
// --------------------------------------------
/datum/cm_objective/retrieve_data
	name = "Retrieve Important Data"
	objective_flags = OBJECTIVE_DEAD_END
	var/data_total = 100
	var/data_retrieved = 0
	var/data_transfer_rate = 10
	var/area/initial_area
	controller = TREE_MARINE
	var/decryption_password
	number_of_clues_to_generate = 2

/datum/cm_objective/retrieve_data/New()
	. = ..()
	decryption_password = "[pick(GLOB.alphabet_uppercase)][rand(100,999)][pick(GLOB.alphabet_uppercase)][rand(10,99)]"

/datum/cm_objective/retrieve_data/pre_round_start()
	SSobjectives.statistics["data_retrieval_total_instances"]++

/datum/cm_objective/retrieve_data/Destroy()
	initial_area = null
	return ..()

/datum/cm_objective/retrieve_data/process()
	data_retrieved += data_transfer_rate

/datum/cm_objective/retrieve_data/check_completion()
	if(data_retrieved == data_total)
		complete()

/datum/cm_objective/retrieve_data/complete()
	SSobjectives.statistics["data_retrieval_total_points_earned"] += value
	SSobjectives.statistics["data_retrieval_completed"]++

// --------------------------------------------
// *** Upload data from a terminal ***
// --------------------------------------------
/datum/cm_objective/retrieve_data/terminal
	var/obj/structure/machinery/computer/objective/terminal
	var/uploading = FALSE
	value = OBJECTIVE_EXTREME_VALUE

/datum/cm_objective/retrieve_data/terminal/New(obj/structure/machinery/computer/objective/D)
	. = ..()
	terminal = D
	initial_area = get_area(terminal)

/datum/cm_objective/retrieve_data/terminal/Destroy()
	terminal?.objective = null
	terminal = null
	return ..()

/datum/cm_objective/retrieve_data/terminal/get_related_label()
	return terminal.label

/datum/cm_objective/retrieve_data/terminal/process()
	if(!terminal.powered())
		terminal.visible_message(SPAN_WARNING("\The [terminal] powers down mid-operation as the area looses power."))
		playsound(terminal, 'sound/machines/terminal_shutdown.ogg', 25, 1)
		SSobjectives.stop_processing_objective(src)
		uploading = FALSE
		return
	if(!SSobjectives.comms.state == OBJECTIVE_COMPLETE)
		terminal.visible_message(SPAN_WARNING("\The [terminal] stops mid-operation due to a network connection error."))
		playsound(terminal, 'sound/machines/terminal_shutdown.ogg', 25, 1)
		SSobjectives.stop_processing_objective(src)
		uploading = FALSE
		return

	..()

/datum/cm_objective/retrieve_data/terminal/complete()
	state = OBJECTIVE_COMPLETE
	uploading = FALSE
	terminal.visible_message(SPAN_NOTICE("[terminal] pings softly as it finishes the upload."))
	playsound(terminal, 'sound/machines/screen_output1.ogg', 25, 1)
	award_points()

	..()

/datum/cm_objective/retrieve_data/terminal/get_tgui_data()
	var/list/clue = list()

	clue["text"] = "Upload data from terminal"
	clue["itemID"] = terminal.label
	clue["key_text"] = ", password is "
	clue["key"] = decryption_password
	clue["location"] = initial_area.name

	return clue

/datum/cm_objective/retrieve_data/terminal/get_clue()
	return SPAN_DANGER("Upload data from data terminal <b>[terminal.label]</b> in <u>[get_area(terminal)]</u>, the password is <b>[decryption_password]</b>")

// --------------------------------------------
// *** Retrieve a disk and upload it ***
// --------------------------------------------
/datum/cm_objective/retrieve_data/disk
	var/obj/item/disk/objective/disk
	value = OBJECTIVE_HIGH_VALUE

/datum/cm_objective/retrieve_data/disk/New(obj/item/disk/objective/O)
	. = ..()
	disk = O
	initial_area = get_area(disk)

/datum/cm_objective/retrieve_data/disk/Destroy()
	disk?.objective = null
	disk = null
	return ..()

/datum/cm_objective/retrieve_data/disk/get_related_label()
	return disk.label

/datum/cm_objective/retrieve_data/disk/process()
	var/obj/structure/machinery/computer/disk_reader/reader = disk.loc
	if(!reader.powered())
		SEND_SIGNAL(reader, COMSIG_INTEL_DISK_LOST_POWER)
		return

	..()

/datum/cm_objective/retrieve_data/disk/complete()
	state = OBJECTIVE_COMPLETE
	SEND_SIGNAL(disk.loc, COMSIG_INTEL_DISK_COMPLETED)
	..()

/datum/cm_objective/retrieve_data/disk/get_tgui_data()
	var/list/clue = list()

	if(disk.disk_color == null || disk.display_color == null)
		clue = null
		return clue

	clue["text"] = "disk"
	clue["itemID"] = disk.label
	clue["color"] = disk.disk_color
	clue["color_name"] = disk.display_color
	clue["key_text"] = ", decryption key is "
	clue["key"] = decryption_password
	clue["location"] = initial_area.name

	return clue

/datum/cm_objective/retrieve_data/disk/get_clue()
	return SPAN_DANGER("Retrieve <font color=[disk.display_color]><u>[disk.disk_color]</u></font> computer disk <b>[disk.label]</b> in <u>[initial_area]</u>, decryption password is <b>[decryption_password]</b>")

// --------------------------------------------
// *** Mapping objects ***
// *** Retrieve a disk and upload it ***
// --------------------------------------------
/obj/item/disk/objective
	name = "computer disk"
	var/label = ""
	desc = "A boring looking computer disk. The name label is just a gibberish collection of letters and numbers."
	unacidable = TRUE
	explo_proof = TRUE
	is_objective = TRUE
	var/datum/cm_objective/retrieve_data/disk/objective
	var/datum/cm_objective/retrieve_item/document/retrieve_objective
	var/display_color = "white"
	var/disk_color = "White"
	ground_offset_x = 9
	ground_offset_y = 8

/obj/item/disk/objective/Initialize(mapload, ...)
	. = ..()
	var/diskvar = rand(1,15)
	icon_state = "disk_[diskvar]"

	switch(diskvar)
		if (1,2)
			disk_color = "Grey"
			display_color = "#8f9494"
		if (3 to 5)
			disk_color = "White"
			display_color = "#e8eded"
		if (6,7)
			disk_color = "Green"
			display_color = "#64c242"
		if (8 to 10)
			disk_color = "Red"
			display_color = "#ed5353"
		if (11 to 13)
			disk_color = "Blue"
			display_color = "#5296e3"
		if (14)
			disk_color = "Cracked blue"
			display_color = "#5296e3"
		if (15)
			disk_color = "Bloodied blue"
			display_color = "#5296e3"

	label = "[pick(GLOB.greek_letters)]-[rand(100,999)]"
	name = "[disk_color] computer disk [label]"
	objective = new /datum/cm_objective/retrieve_data/disk(src)
	retrieve_objective = new /datum/cm_objective/retrieve_item/document(src)
	w_class = SIZE_TINY

/obj/item/disk/objective/Destroy()
	qdel(objective)
	objective = null
	qdel(retrieve_objective)
	retrieve_objective = null
	return ..()

// --------------------------------------------
// *** Upload data from a terminal ***
// --------------------------------------------
/obj/structure/machinery/computer/objective
	name = "data terminal"
	var/label = ""
	desc = "A computer data terminal with an incomprehensible label."
	var/uploading = 0
	icon_state = "medlaptop"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	var/datum/cm_objective/retrieve_data/terminal/objective

/obj/structure/machinery/computer/objective/Initialize()
	. = ..()
	label = "[pick(GLOB.greek_letters)]-[rand(100,999)]"
	name = "data terminal [label]"
	objective = new /datum/cm_objective/retrieve_data/terminal(src)

///Disabled explosions due to issues with the Objectives UI should it be destroyed.
/obj/structure/machinery/computer/objective/ex_act(severity)
	return

/obj/structure/machinery/computer/objective/Destroy()
	objective?.terminal = null
	qdel(objective)
	objective = null
	return ..()

/obj/structure/machinery/computer/objective/attack_hand(mob/living/user)
	if (!check_if_usable(user))
		return

	if(input(user,"Enter the password","Password","") != objective.decryption_password)
		to_chat(user, SPAN_WARNING("The terminal rejects the password."))
		return

	// Check if the terminal became unusable since we started entering the password.
	if (!check_if_usable(user))
		return

	uploading = 1
	objective.activate()
	to_chat(user, SPAN_NOTICE("You start uploading the data."))
	user.count_niche_stat(STATISTICS_NICHE_UPLOAD)

/obj/structure/machinery/computer/objective/proc/check_if_usable(mob/living/user)
	if(!powered())
		to_chat(user, SPAN_WARNING("This terminal has no power!"))
		return
	if(!SSobjectives.comms.state == OBJECTIVE_COMPLETE)
		to_chat(user, SPAN_WARNING("The terminal flashes a network connection error."))
		return
	if(objective.state == OBJECTIVE_COMPLETE)
		to_chat(user, SPAN_WARNING("There's a message on the screen that the data upload finished successfully."))
		return
	if(uploading)
		to_chat(user, SPAN_WARNING("Looks like the terminal is already uploading, better make sure nothing interupts it!"))
		return

	return TRUE

// --------------------------------------------
// *** Upload data from an inserted disk ***
// --------------------------------------------
/obj/structure/machinery/computer/disk_reader
	name = "universal disk reader"
	desc = "A console able to read any format of disk known to man."
	var/obj/item/disk/objective/disk
	icon_state = "medlaptop"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/computer/disk_reader/Initialize()
	. = ..()
	AddComponent(/datum/component/disk_reader)
