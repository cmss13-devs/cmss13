// --------------------------------------------
// *** Find a document and read it ***
// These are intended as the initial breadcrumbs that lead to more objectives such as data retrieval
// --------------------------------------------
/datum/cm_objective/document
	name = "Paper scrap objective"
	var/obj/item/document_objective/document
	var/area/initial_area
	value = OBJECTIVE_LOW_VALUE
	state = OBJECTIVE_ACTIVE
	controller = TREE_MARINE

/datum/cm_objective/document/New(obj/item/document_objective/D)
	. = ..()
	document = D
	initial_area = get_area(document)

/datum/cm_objective/document/pre_round_start()
	SSobjectives.statistics["documents_total_instances"]++

/datum/cm_objective/document/Destroy()
	document?.objective = null
	document = null
	initial_area = null
	return ..()

/datum/cm_objective/document/get_related_label()
	return document.label

/datum/cm_objective/document/complete(mob/living/carbon/human/user)
	. = ..()

	SSobjectives.statistics["documents_total_points_earned"] += value
	award_points()

	if (user && user.mind)
		user.mind.store_objective(document.retrieve_objective)

	// Enable child objectives
	for(var/datum/cm_objective/child_objective in enables_objectives)
		if(child_objective.state & OBJECTIVE_INACTIVE)
			child_objective.state = OBJECTIVE_ACTIVE
			if(child_objective.objective_flags & OBJECTIVE_START_PROCESSING_ON_DISCOVERY)
				child_objective.activate()

/datum/cm_objective/document/get_clue()
	return SPAN_DANGER("[document.name] in <u>[initial_area]</u>")

// Paper scrap
/datum/cm_objective/document/get_tgui_data()
	var/list/clue = list()

	clue["text"] = "Paper scrap"
	clue["location"] = initial_area.name

	return clue

// Progress report
/datum/cm_objective/document/progress_report
	name = "Progress report objective"
	value = OBJECTIVE_MEDIUM_VALUE

/datum/cm_objective/document/progress_report/get_tgui_data()
	var/list/clue = list()

	clue["text"] = "Progress report"
	clue["location"] = initial_area.name

	return clue

/datum/cm_objective/document/progress_report/get_clue()
	return SPAN_DANGER("A progress report in <u>[initial_area]</u>.")

// Folder
/datum/cm_objective/document/folder
	name = "Folder objective"
	value = OBJECTIVE_MEDIUM_VALUE
	var/color // Text name of the color
	var/display_color // Color of the sprite
	number_of_clues_to_generate = 2
	state = OBJECTIVE_INACTIVE

/datum/cm_objective/document/folder/get_tgui_data()
	var/list/clue = list()

	clue["text"] = "folder"
	clue["itemID"] = document.label
	clue["color"] = color
	clue["color_name"] = display_color
	clue["location"] = initial_area.name

	return clue

/datum/cm_objective/document/folder/get_clue()
	return SPAN_DANGER("A <font color=[display_color]><u>[color]</u></font> folder <b>[document.label]</b> in <u>[initial_area]</u>.")

// Technical manual
/datum/cm_objective/document/technical_manual
	name = "Technical manual objective"
	value = OBJECTIVE_HIGH_VALUE
	state = OBJECTIVE_INACTIVE
	number_of_clues_to_generate = 2

/datum/cm_objective/document/technical_manual/get_tgui_data()
	var/list/clue = list()

	clue["text"] = "Technical manual"
	clue["itemID"] = document.label
	clue["location"] = initial_area.name

	return clue

// --------------------------------------------
// *** Mapping objects ***
// --------------------------------------------

/obj/item/document_objective
	var/datum/cm_objective/document/objective
	var/datum/cm_objective/retrieve_item/document/retrieve_objective
	var/reading_time = 10
	var/objective_type = /datum/cm_objective/document
	unacidable = TRUE
	explo_proof = TRUE
	is_objective = TRUE
	ground_offset_x = 9
	ground_offset_y = 8
	var/label // label on the document
	var/renamed = FALSE //Once someone reads a document the item gets renamed based on the objective they are linked to)

/obj/item/document_objective/Initialize(mapload, ...)
	. = ..()
	label = "[pick(GLOB.alphabet_uppercase)][rand(100,999)]"
	objective = new objective_type(src)
	retrieve_objective = new /datum/cm_objective/retrieve_item/document(src)
	LAZYADD(objective.enables_objectives, retrieve_objective)

/obj/item/document_objective/Destroy()
	qdel(objective)
	objective = null
	qdel(retrieve_objective)
	retrieve_objective = null
	return ..()

/obj/item/document_objective/proc/display_read_message(mob/living/user)
	if(user && user.mind)
		user.mind.store_objective(objective)
	var/related_labels = ""
	for(var/datum/cm_objective/D in objective.enables_objectives)
		var/clue = D.get_clue()

		// Some objectives don't have clues.
		if (!clue)
			continue

		to_chat(user, SPAN_NOTICE("You make out something about [clue]."))
		if (related_labels != "")
			related_labels+=","
		related_labels+=D.get_related_label()
	to_chat(user, SPAN_INFO("You finish reading \the [src]."))

	// Our first time reading this successfully, add the clue labels.
	if(!(objective.state & OBJECTIVE_COMPLETE))
		src.name+= " ([related_labels])"
		renamed = TRUE

/obj/item/document_objective/attack_self(mob/living/carbon/human/user)
	. = ..()

	to_chat(user, SPAN_NOTICE("You start reading \the [src]."))

	if(!do_after(user, reading_time * user.get_skill_duration_multiplier(SKILL_INTEL), INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC)) // Can move while reading intel
		to_chat(user, SPAN_WARNING("You get distracted and lose your train of thought, you'll have to start over reading this."))
		return

	// Prerequisit objective not complete.
	if(objective.state & OBJECTIVE_INACTIVE)
		to_chat(user, SPAN_NOTICE("You don't notice anything useful. You probably need to find its instructions on a paper scrap."))
		return

	display_read_message(user)

	// Our first time reading this successfully.
	if(!(objective.state & OBJECTIVE_COMPLETE))
		objective.complete(user)
		SSobjectives.statistics["documents_completed"]++
		objective.state = OBJECTIVE_COMPLETE

/obj/item/document_objective/paper
	name = "Paper scrap"
	desc = "A scrap of paper, you think some of the words might still be readable."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_words"
	item_state = "paper"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	pickup_sound = 'sound/handling/paper_pickup.ogg'
	drop_sound = 'sound/handling/paper_drop.ogg'
	w_class = SIZE_TINY

/obj/item/document_objective/report
	name = "Progress report"
	desc = "A written report from someone for their supervisor about the status of some kind of project."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_p_words"
	item_state = "paper"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	pickup_sound = 'sound/handling/paper_pickup.ogg'
	drop_sound = 'sound/handling/paper_drop.ogg'
	w_class = SIZE_TINY
	reading_time = 60
	objective_type = /datum/cm_objective/document/progress_report

/obj/item/document_objective/folder
	name = "Intel folder"
	desc = "A folder with some documents inside."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "folder"
	var/folder_color = "white" //display color
	reading_time = 40
	objective_type = /datum/cm_objective/document/folder
	w_class = SIZE_TINY

/obj/item/document_objective/folder/Initialize(mapload, ...)
	. = ..()
	var/datum/cm_objective/document/folder/F = objective
	var/col = pick("Red", "Black", "Blue", "Yellow", "White")
	switch(col)
		if ("Red")
			folder_color = "#ed5353"
		if ("Black")
			folder_color = "#8f9494" //can't display black on black!
		if ("Blue")
			folder_color = "#5296e3"
		if ("Yellow")
			folder_color = "#e3cd52"
		if ("White")
			folder_color = "#e8eded"
	icon_state = "folder_[lowertext(col)]"
	F.color = col
	F.display_color = folder_color
	name = "[initial(name)] ([label])"

/obj/item/document_objective/folder/get_examine_text(mob/living/user)
	. = ..()
	if(get_dist(user, src) < 2 && ishuman(user))
		. += SPAN_INFO("\The [src] is labelled [label].")

/obj/item/document_objective/technical_manual
	name = "Technical Manual"
	desc = "A highly specified technical manual, may be of use to someone in the relevant field."
	icon = 'icons/obj/items/books.dmi'
	icon_state = "book"
	reading_time = 200
	objective_type = /datum/cm_objective/document/technical_manual

/obj/item/document_objective/technical_manual/Initialize(mapload, ...)
	. = ..()
	name = "[initial(name)] ([label])"
