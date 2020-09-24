// --------------------------------------------
// *** Find a document and read it ***
// These are intended as the initial breadcrumbs that lead to more objectives such as data retrieval
// --------------------------------------------
/datum/cm_objective/document
	name = "Document Clue"
	var/obj/item/document_objective/document
	var/area/initial_area
	var/important = 0
	priority = OBJECTIVE_LOW_VALUE
	objective_flags = OBJ_PROCESS_ON_DEMAND | OBJ_FAILABLE
	display_flags = OBJ_DISPLAY_HIDDEN
	prerequisites_required = PREREQUISITES_NONE
	display_category = "Documents"

/datum/cm_objective/document/New(var/obj/item/document_objective/D)
	..()
	document = D
	initial_area = get_area(document)
	important = rand(0,1)

/datum/cm_objective/document/get_related_label()
	return document.label

/datum/cm_objective/document/complete()
	if(..())
		if(important)
			if(objectives_controller)
				var/datum/cm_objective/O = new /datum/cm_objective/retrieve_item/almayer(document)
				O.priority = priority //retrieving item gets you double the points for whatever the item is worth, rather than EXTREME value each time
				objectives_controller.add_objective(O)

/datum/cm_objective/document/get_clue()
	return SPAN_DANGER("[document.name] in <u>[initial_area]</u>")

/datum/cm_objective/document/check_completion()
	. = ..()
	if(document)
		if(document.read)
			complete()
			return TRUE
	else
		fail()
		return FALSE

/datum/cm_objective/document/folder
	priority = OBJECTIVE_MEDIUM_VALUE
	prerequisites_required = PREREQUISITES_ONE
	display_flags = 0
	var/color
	var/display_color = "white"
	number_of_clues_to_generate = 2

/datum/cm_objective/document/progress_report
	priority = OBJECTIVE_MEDIUM_VALUE
	prerequisites_required = PREREQUISITES_NONE
	display_flags = 0

/datum/cm_objective/document/folder/get_clue()
	return SPAN_DANGER("A <font color=[display_color]><u>[color]</u></font> folder <b>[document.label]</b> in <u>[initial_area]</u>.")

/datum/cm_objective/document/technical_manual
	priority = OBJECTIVE_HIGH_VALUE
	prerequisites_required = PREREQUISITES_NONE
	display_flags = 0

// --------------------------------------------
// *** Mapping objects ***
// --------------------------------------------

/obj/item/document_objective
	var/datum/cm_objective/document/objective
	var/read = 0
	var/reading_time = 10
	var/objective_type = /datum/cm_objective/document
	unacidable = TRUE
	indestructible = 1
	var/label // label on the document
	var/renamed = FALSE //Once someone reads a document the item gets renamed based on the objective they are linked to)

/obj/item/document_objective/New()
	..()
	label = "[pick(alphabet_uppercase)][rand(100,999)]"
	objective = new objective_type(src)

/obj/item/document_objective/Destroy()
	if(objective)
		objective.fail()
	..()

/obj/item/document_objective/proc/display_read_message(mob/living/user)
	if(user && user.mind)
		user.mind.store_objective(objective)
	var/related_labels = ""
	for(var/datum/cm_objective/D in objective.enables_objectives)
		to_chat(user, SPAN_NOTICE("You make out something about [D.get_clue()]."))
		if (related_labels != "")
			related_labels+=","
		related_labels+=D.get_related_label()
	to_chat(user, SPAN_INFO("You finish reading \the [src]."))
	if (!renamed)
		src.name+= " ([related_labels])"
		renamed = TRUE

/obj/item/document_objective/proc/display_fail_message(mob/living/user)
	if(objective)
		to_chat(user, SPAN_NOTICE("You don't notice anything useful. You probably need to find its instructions on a paper scrap."))
	else
		to_chat(user, SPAN_NOTICE("You don't notice anything useful."))

/obj/item/document_objective/attack_self(mob/living/carbon/human/user)
	if(!objective.is_active())
		objective.activate() //Trying to rejig it just in case
	to_chat(user, SPAN_NOTICE("You start reading \the [src]."))

	if(!do_after(user, reading_time * user.get_skill_duration_multiplier(), INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC)) // Can move while reading intel
		to_chat(user, SPAN_WARNING("You get distracted and lose your train of thought, you'll have to start over reading this."))
		return FALSE

	if(!objective.is_active() && !objective.is_complete())
		display_fail_message(user)
		return FALSE
	
	read = 1
	objective.check_completion()
	display_read_message(user)
	if(objective.important && objective.is_complete())
		to_chat(user, SPAN_NOTICE("You feel this document is important and should be returned to the [MAIN_SHIP_NAME]."))
	return TRUE

/obj/item/document_objective/paper
	name = "Paper scrap"
	desc = "A scrap of paper, you think some of the words might still be readable."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_words"
	w_class = SIZE_TINY

/obj/item/document_objective/paper/New()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/item/document_objective/report
	name = "Progress report"
	desc = "A written report from someone for their supervisor about the status of some kind of project."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_p_words"
	w_class = SIZE_TINY
	reading_time = 60
	objective_type = /datum/cm_objective/document/progress_report

/obj/item/document_objective/report/New()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/item/document_objective/folder
	name = "intel folder"
	desc = "A folder with some documents inside."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "folder"
	var/folder_color = "white" //display color
	reading_time = 40
	objective_type = /datum/cm_objective/document/folder
	w_class = SIZE_TINY

/obj/item/document_objective/folder/New()
	..()
	var/datum/cm_objective/document/folder/F = objective
	var/col = pick("red", "black", "blue", "yellow", "white")
	switch(col)
		if ("red")
			folder_color = "#ed5353"
		if ("black")
			folder_color = "#8f9494" //can't display black on black!
		if ("blue")
			folder_color = "#5296e3"
		if ("yellow")
			folder_color = "#e3cd52"
		if ("white")
			folder_color = "#e8eded"
	icon_state = "folder_[col]"
	if(istype(F))
		F.color = col
		F.display_color = folder_color
	name = "[initial(name)] ([label])"
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/item/document_objective/folder/examine(mob/living/user)
	..()
	if(get_dist(user, src) < 2 && ishuman(user))
		to_chat(user, SPAN_INFO("\The [src] is labelled [label]."))


/obj/item/document_objective/technical_manual
	name = "Technical Manual"
	desc = "A highly specified technical manual, may be of use to someone in the relevant field."
	icon = 'icons/obj/items/books.dmi'
	icon_state = "book"
	reading_time = 200
	objective_type = /datum/cm_objective/document/technical_manual

/obj/item/document_objective/technical_manual/New()
	..()
	name = "[initial(name)] ([label])"