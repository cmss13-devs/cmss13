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

/datum/cm_objective/document/complete()
	if(..())
		for(var/datum/cm_objective/C in enables_objectives)
			C.activate()
		if(important)
			if(objectives_controller)
				objectives_controller.add_objective(new /datum/cm_objective/retrieve_item/almayer(document))

/datum/cm_objective/document/get_clue()
	return "[document.name] in [initial_area]"

/datum/cm_objective/document/check_completion()
	. = ..()
	if(document)
		if(document.read)
			complete()
			return 1
	else
		fail()
		return 0

/datum/cm_objective/document/folder
	priority = OBJECTIVE_MEDIUM_VALUE
	prerequisites_required = PREREQUISITES_ONE
	display_flags = 0
	var/color

/datum/cm_objective/document/folder/get_clue()
	return SPAN_DANGER("A [color] folder in [initial_area], labelled [document.label]")

/datum/cm_objective/document/technical_manual
	priority = OBJECTIVE_MEDIUM_VALUE
	prerequisites_required = PREREQUISITES_ONE
	objective_flags = OBJ_PROCESS_ON_DEMAND | OBJ_DEAD_END | OBJ_DO_NOT_TREE
	display_flags = 0

// --------------------------------------------
// *** Mapping objects ***
// --------------------------------------------
#define DOCUMENT_SKILL_NONE 0
#define DOCUMENT_SKILL_SURGERY 1
#define DOCUMENT_SKILL_ENGINEERING 2
#define DOCUMENT_SKILL_WEAPONS 3

/obj/item/document_objective
	var/datum/cm_objective/document/objective
	var/read = 0
	var/reading_time = 10
	var/skill_required = DOCUMENT_SKILL_NONE
	var/objective_type = /datum/cm_objective/document
	unacidable = TRUE
	indestructible = 1
	var/label // label on the document

/obj/item/document_objective/New()
	..()
	var/list/letters = list("A","B","C","D","E","F","G","H","J","K","L","M","N","P","Q","R","T","U","V","X","Y","Z") // please find a better way to do this
	label = "[pick(letters)][rand(100,999)]"
	objective = new objective_type(src)

/obj/item/document_objective/Dispose()
	if(objective)
		objective.fail()
	..()

/obj/item/document_objective/proc/display_read_message(mob/living/user)
	if(user && user.mind)
		user.mind.store_objective(objective)

/obj/item/document_objective/proc/display_fail_message(mob/living/user)
	for(var/datum/cm_objective/C in objective.required_objectives)
		if(C.is_complete())
			to_chat(user, SPAN_WARNING("You aren't entirely sure what you're meant to be looking for in this document."))
			return
	if(objective)
		to_chat(user, SPAN_NOTICE("You don't notice anything useful. You probably need to find its instructions on a paper scrap."))
	else
		to_chat(user, SPAN_NOTICE("You don't notice anything useful."))

/obj/item/document_objective/attack_self(mob/living/carbon/human/user)
	switch(skill_required)
		if(DOCUMENT_SKILL_SURGERY)
			if(!skillcheck(user, SKILL_SURGERY, SKILL_SURGERY_BEGINNER))
				to_chat(user, SPAN_WARNING("You can't understand this."))
				return 0
		if(DOCUMENT_SKILL_ENGINEERING)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_OT))
				to_chat(user, SPAN_WARNING("You can't understand this."))
				return 0
		if(DOCUMENT_SKILL_WEAPONS)
			// Needs skill in any spec weapon
			if(!skillcheck(user, SKILL_SPEC_WEAPONS, 1))
				to_chat(user, SPAN_WARNING("You can't understand this."))
				return 0
	to_chat(user, SPAN_NOTICE("You start reading \the [src]."))
	if(!do_after(user, reading_time, INTERRUPT_INCAPACITATED|INTERRUPT_NEEDHAND, BUSY_ICON_GENERIC)) // Can move while reading intel
		to_chat(user, SPAN_WARNING("You get distracted and lose your train of thought, you'll have to start over reading this."))
		return 0
	if(!objective.is_active())
		var/fail = TRUE
		for(var/datum/cm_objective/OJ in objective.enables_objectives)
			if(OJ.is_active())
				fail = FALSE
		if(fail)
			display_fail_message(user)
			return 0
	read = 1
	objective.check_completion()
	display_read_message(user)
	if(objective.important && objective.is_complete())
		to_chat(user, SPAN_NOTICE("You feel this document is important and should be returned to the [MAIN_SHIP_NAME]."))
	return 1

/obj/item/document_objective/paper
	name = "Paper scrap"
	desc = "A scrap of paper, you think some of the words might still be readable."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_words"
	w_class = SIZE_TINY

/obj/item/document_objective/paper/display_read_message(mob/living/user)
	..()
	for(var/datum/cm_objective/document/D in objective.enables_objectives)
		to_chat(user, SPAN_NOTICE("You make out something about [D.get_clue()]."))
	to_chat(user, SPAN_INFO("You finish examining \the [src]."))

/obj/item/document_objective/report
	name = "Progress report"
	desc = "A written report from someone for their supervisor about the status of some kind of project."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_words"
	w_class = SIZE_TINY

/obj/item/document_objective/report/display_read_message(mob/living/user)
	..()
	for(var/datum/cm_objective/retrieve_item/device/D in objective.enables_objectives)
		to_chat(user, SPAN_NOTICE("You make out something about [D.get_clue()]."))
	to_chat(user, SPAN_INFO("You finish examining \the [src]."))

/obj/item/document_objective/folder
	name = "intel folder"
	desc = "A folder with some documents inside."
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "folder"
	reading_time = 50
	objective_type = /datum/cm_objective/document/folder
	w_class = SIZE_TINY

/obj/item/document_objective/folder/New()
	..()
	var/datum/cm_objective/document/folder/F = objective
	var/col = pick("red", "black", "blue", "yellow", "white")
	icon_state = "folder_[col]"
	if(istype(F))
		F.color = col
	name = "[initial(name)] ([label])"

/obj/item/document_objective/folder/examine(mob/living/user)
	..()
	if(get_dist(user, src) < 2 && ishuman(user))
		to_chat(user, SPAN_INFO("\The [src] is labelled [label]."))

/obj/item/document_objective/folder/display_read_message(mob/living/user)
	..()
	for(var/datum/cm_objective/D in objective.enables_objectives)
		to_chat(user, SPAN_NOTICE("You see a reference to [D.get_clue()]."))
	to_chat(user, SPAN_INFO("You finish sifting through the documents."))

/obj/item/document_objective/technical_manual
	name = "Technical Manual"
	desc = "A highly specified technical manual, may be of use to someone in the relevant field."
	icon = 'icons/obj/items/books.dmi'
	icon_state = "book"
	reading_time = 300
	objective_type = /datum/cm_objective/document/technical_manual

/obj/item/document_objective/technical_manual/display_read_message(mob/living/user)
	..()
	for(var/datum/cm_objective/document/D in objective.enables_objectives)
		to_chat(user, SPAN_NOTICE("You see a reference to [D.get_clue()]."))
	to_chat(user, SPAN_INFO("You finish reading the technical manual."))
