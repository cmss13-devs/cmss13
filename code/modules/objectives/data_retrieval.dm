// --------------------------------------------
// *** Slightly more complicated data retrieval ***
// --------------------------------------------
/datum/cm_objective/retrieve_data
	name = "Retrieve Important Data"
	var/data_total = 100
	var/data_retrieved = 0
	var/data_transfer_rate = 10
	var/area/initial_location
	objective_flags = OBJ_FAILABLE
	var/decryption_password
	display_category = "Data Retrieval"
	number_of_clues_to_generate = 2

/datum/cm_objective/retrieve_data/New()
	..()
	decryption_password = "[pick(alphabet_uppercase)][rand(100,999)][pick(alphabet_uppercase)][rand(10,99)]"

/datum/cm_objective/retrieve_data/check_completion()
	. = ..()
	if(data_retrieved >= data_total)
		complete()
		return TRUE

/datum/cm_objective/retrieve_data/process()
	if(..())
		if(data_is_avaliable())
			data_retrieved += data_transfer_rate

/datum/cm_objective/retrieve_data/proc/data_is_avaliable()
	if(objective_flags & OBJ_REQUIRES_COMMS)
		if(objectives_controller && objectives_controller.comms && objectives_controller.comms.is_complete())
			return TRUE
		else
			return FALSE
	return TRUE

/datum/cm_objective/retrieve_data/complete()
	if(..())
		if(intel_system)
			intel_system.store_objective(src)
		return TRUE
	return FALSE

// --------------------------------------------
// *** Upload data from a terminal ***
// --------------------------------------------
/datum/cm_objective/retrieve_data/terminal
	var/obj/structure/machinery/computer/objective/data_source
	priority = OBJECTIVE_HIGH_VALUE
	objective_flags = OBJ_FAILABLE | OBJ_REQUIRES_POWER | OBJ_REQUIRES_COMMS
	prerequisites_required = PREREQUISITES_MAJORITY

/datum/cm_objective/retrieve_data/terminal/New(var/obj/structure/machinery/computer/objective/D)
	data_source = D
	initial_location = get_area(data_source)
	..()

/datum/cm_objective/retrieve_data/terminal/get_related_label()
	return data_source.label

/datum/cm_objective/retrieve_data/terminal/complete()
	if(..())
		data_source.visible_message(SPAN_NOTICE("[data_source] pings softly as it finishes the upload."))
		playsound(data_source, 'sound/machines/screen_output1.ogg', 25, 1)

/datum/cm_objective/retrieve_data/terminal/get_clue()
	return SPAN_DANGER("Upload data from data terminal <b>[data_source.label]</b> in <u>[get_area(data_source)]</u>, the password is <b>[decryption_password]</b>")

/datum/cm_objective/retrieve_data/terminal/data_is_avaliable()
	. = ..()
	if(!data_source.powered())
		return FALSE
	if(!data_source.uploading)
		return FALSE

// --------------------------------------------
// *** Retrieve a disk and upload it ***
// --------------------------------------------
/datum/cm_objective/retrieve_data/disk
	var/obj/item/disk/objective/disk
	priority = OBJECTIVE_HIGH_VALUE
	prerequisites_required = PREREQUISITES_ONE

/datum/cm_objective/retrieve_data/disk/New(var/obj/item/disk/objective/O)
	disk = O
	data_total = disk.data_amount
	data_transfer_rate = disk.read_speed
	initial_location = get_area(disk)
	..()

/datum/cm_objective/retrieve_data/disk/get_related_label()
	return disk.label

/datum/cm_objective/retrieve_data/disk/complete()
	if(..())
		if(istype(disk.loc,/obj/structure/machinery/computer/disk_reader))
			var/obj/structure/machinery/computer/disk_reader/reader = disk.loc
			reader.visible_message("\The [reader] pings softly as the upload finishes and ejects the disk.")
			playsound(reader, 'sound/machines/screen_output1.ogg', 25, 1)
			disk.forceMove(reader.loc)
			disk.name = "[disk.name] (complete)"
			reader.disk = null
		return TRUE
	return FALSE

/datum/cm_objective/retrieve_data/disk/get_clue()
	return SPAN_DANGER("Retrieving <font color=[disk.display_color]><u>[disk.disk_color]</u></font> computer disk <b>[disk.label]</b> in <u>[initial_location]</u>, decryption password is <b>[decryption_password]</b>")

/datum/cm_objective/retrieve_data/disk/data_is_avaliable()
	. = ..()
	if(!istype(disk.loc,/obj/structure/machinery/computer/disk_reader))
		return FALSE
	var/obj/structure/machinery/computer/disk_reader/reader = disk.loc
	if(!reader.powered())
		return FALSE
	if(reader.z != MAIN_SHIP_Z_LEVEL)
		return FALSE

// --------------------------------------------
// *** Mapping objects ***
// *** Retrieve a disk and upload it ***
// --------------------------------------------
/obj/item/disk/objective
	name = "computer disk"
	var/label = ""
	desc = "A boring looking computer disk. The name label is just a gibberish collection of letters and numbers."
	var/data_amount = 500
	var/read_speed = 50
	unacidable = TRUE
	var/datum/cm_objective/retrieve_data/disk/objective
	var/display_color = "white"
	var/disk_color = "white"

/obj/item/disk/objective/New()
	..()
	var/diskvar = rand(1,15)
	icon_state = "disk_[diskvar]"

	switch(diskvar)
		if (1,2)
			disk_color = "grey"
			display_color = "#8f9494"
		if (3 to 5)
			disk_color = "white"
			display_color = "#e8eded"
		if (6,7)
			disk_color = "green"
			display_color = "#64c242"
		if (8 to 10)
			disk_color = "red"
			display_color = "#ed5353"
		if (11 to 13)
			disk_color = "blue"
			display_color = "#5296e3"
		if (14)
			disk_color = "cracked blue"
			display_color = "#5296e3"
		if (15)
			disk_color = "bloodied blue"
			display_color = "#5296e3"

	label = "[pick(greek_letters)]-[rand(100,999)]"
	name = "[disk_color] computer disk [label]"
	objective = new /datum/cm_objective/retrieve_data/disk(src)
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	w_class = SIZE_TINY

/obj/item/disk/objective/Dispose()
	if(objective)
		objective.fail()
	..()

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
	var/datum/cm_objective/retrieve_data/terminal/objective

/obj/structure/machinery/computer/objective/New()
	..()
	label = "[pick(greek_letters)]-[rand(100,999)]"
	name = "data terminal [label]"
	objective = new /datum/cm_objective/retrieve_data/terminal(src)

/obj/structure/machinery/computer/objective/Dispose()
	if(objective)
		objective.fail()
	..()

/obj/structure/machinery/computer/objective/attack_hand(mob/living/user)
	if(!powered())
		to_chat(user, SPAN_WARNING("This terminal has no power!"))
		return FALSE
	if(objective.objective_flags & OBJ_REQUIRES_COMMS)
		if(!objectives_controller || !objectives_controller.comms || !objectives_controller.comms.is_complete())
			to_chat(user, SPAN_WARNING("The terminal flashes a network connection error."))
			return FALSE
	if(objective.is_complete())
		to_chat(user, SPAN_WARNING("There's a message on the screen that the data upload finished successfully."))
		return TRUE
	if(uploading)
		to_chat(user, SPAN_WARNING("Looks like the terminal is already uploading, better make sure nothing interupts it!"))
		return TRUE
	if(input(user,"Enter the password","Password","") != objective.decryption_password)
		to_chat(user, SPAN_WARNING("The terminal rejects the password."))
		return FALSE
	if(!objective.is_active())
		objective.activate(1) // force it active now, we have the password
	if(!powered())
		to_chat(user, SPAN_WARNING("This terminal has no power!"))
		return FALSE
	if(objective.objective_flags & OBJ_REQUIRES_COMMS)
		if(!objectives_controller || !objectives_controller.comms || !objectives_controller.comms.is_complete())
			to_chat(user, SPAN_WARNING("The terminal flashes a network connection error."))
			return FALSE
	if(uploading)
		to_chat(user, SPAN_WARNING("Looks like the terminal is already uploading, better make sure nothing interupts it!"))
		return TRUE
	uploading = 1
	to_chat(user, SPAN_NOTICE("You start uploading the data."))
	user.count_niche_stat(STATISTICS_NICHE_UPLOAD)

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

/obj/structure/machinery/computer/disk_reader/attack_hand(mob/living/user)
	if(isXeno(user))
		return
	if(disk)
		to_chat(user, SPAN_NOTICE("[disk] is currently loaded into the machine."))
		if(disk.objective)
			if(disk.objective.is_active() && !disk.objective.is_complete() && disk.objective.data_is_avaliable())
				to_chat(user, SPAN_NOTICE("Data is currently being uploaded to ARES."))
				return
		to_chat(user, SPAN_NOTICE("No data is being uploaded."))

/obj/structure/machinery/computer/disk_reader/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/disk/objective))
		if(istype(disk))
			to_chat(user, SPAN_WARNING("There is a disk in the drive being uploaded already!"))
			return FALSE
		var/obj/item/disk/objective/newdisk = W
		if(newdisk.objective.is_complete())
			to_chat(user, SPAN_WARNING("The reader displays a message stating this disk has already been read and refuses to accept it."))
			return FALSE
		if(input(user,"Enter the encryption key","Encryption key","") != newdisk.objective.decryption_password)
			to_chat(user, SPAN_WARNING("The reader asks for the encryption key for this disk, not having the correct key you eject the disk."))
			return FALSE
		if(!newdisk.objective.is_active())
			newdisk.objective.activate(1) // force it active now, we have the password
		if(istype(disk))
			to_chat(user, SPAN_WARNING("There is a disk in the drive being uploaded already!"))
			return FALSE

		if(!(newdisk in user.contents))
			return FALSE

		user.drop_inv_item_to_loc(W, src)
		disk = W
		to_chat(user, SPAN_NOTICE("You insert \the [W] and enter the decryption key."))
		user.count_niche_stat(STATISTICS_NICHE_DISK)
