// --------------------------------------------
// *** Retrieve an experimental device ***
// --------------------------------------------
/datum/cm_objective/retrieve_item/almayer/device
	objective_flags = OBJ_DEAD_END
	prerequisites_required = PREREQUISITES_MAJORITY
	number_of_clues_to_generate = 8

/datum/cm_objective/retrieve_item/almayer/device/New(var/obj/item/device/D)
	if(istype(D))
		..()
	else
		error("DO001: no device found for an objective.")

/datum/cm_objective/retrieve_item/almayer/device/get_clue()
	return SPAN_DANGER("Retrieve <u>[target_item]</u> in <u>[initial_location]</u>.")

/datum/cm_objective/retrieve_item/almayer/device/get_related_label()
	var/obj/item/device/D = target_item
	return D.serial_number

// --------------------------------------------
// *** Experimental devices ***
// --------------------------------------------
/obj/item/device/mass_spectrometer/adv/objective
	var/datum/cm_objective/retrieve_item/almayer/device/objective
	unacidable = TRUE

/obj/item/device/mass_spectrometer/adv/objective/Initialize()
	. = ..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/almayer/device(src)
	name += " #[serial_number]"

/obj/item/device/mass_spectrometer/adv/objective/Destroy()
	objective = null
	// see [/datum/cm_objective/retrieve_item/proc/clean_up_ref]
	return ..()

/obj/item/device/reagent_scanner/adv/objective
	var/datum/cm_objective/retrieve_item/almayer/device/objective
	unacidable = TRUE

/obj/item/device/reagent_scanner/adv/objective/Initialize(mapload, ...)
	. = ..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/almayer/device(src)
	name += " #[serial_number]"

/obj/item/device/reagent_scanner/adv/objective/Destroy()
	objective = null
	// see [/datum/cm_objective/retrieve_item/proc/clean_up_ref]
	return ..()

/obj/item/device/healthanalyzer/objective
	var/datum/cm_objective/retrieve_item/almayer/device/objective
	unacidable = TRUE

/obj/item/device/healthanalyzer/objective/Initialize(mapload, ...)
	. = ..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/almayer/device(src)
	name += " #[serial_number]"

/obj/item/device/healthanalyzer/objective/Destroy()
	objective = null
	// see [/datum/cm_objective/retrieve_item/proc/clean_up_ref]
	return ..()

/obj/item/device/autopsy_scanner/objective
	var/datum/cm_objective/retrieve_item/almayer/device/objective
	unacidable = TRUE

/obj/item/device/autopsy_scanner/objective/Initialize(mapload, ...)
	. = ..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/almayer/device(src)
	name += " #[serial_number]"

/obj/item/device/autopsy_scanner/objective/Destroy()
	objective = null
	// see [/datum/cm_objective/retrieve_item/proc/clean_up_ref]
	return ..()
