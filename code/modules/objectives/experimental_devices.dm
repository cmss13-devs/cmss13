// --------------------------------------------
// *** Retrieve an experimental device ***
// --------------------------------------------
/datum/cm_objective/retrieve_item/device
	target_area = /area/almayer/command/securestorage
	priority = OBJECTIVE_EXTREME_VALUE
	objective_flags = OBJ_DEAD_END
	prerequisites_required = PREREQUISITES_MAJORITY

/datum/cm_objective/retrieve_item/device/New(var/obj/item/device/D)
	if(istype(D))
		..()
	else
		error("DO001: no device found for an objective.")

/datum/cm_objective/retrieve_item/device/get_clue()
	var/obj/item/device/D = target_item
	return "Retrieve [target_item] with serial number [D.serial_number] in [initial_location]"

// --------------------------------------------
// *** Experimental devices ***
// --------------------------------------------
/obj/item/device/mass_spectrometer/adv/objective
	var/datum/cm_objective/retrieve_item/device/objective
	unacidable = 1

/obj/item/device/mass_spectrometer/adv/objective/New()
	..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/device(src)

/obj/item/device/reagent_scanner/adv/objective
	var/datum/cm_objective/retrieve_item/device/objective
	unacidable = 1

/obj/item/device/reagent_scanner/adv/objective/New()
	..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/device(src)

/obj/item/device/healthanalyzer/objective
	var/datum/cm_objective/retrieve_item/device/objective
	unacidable = 1

/obj/item/device/healthanalyzer/objective/New()
	..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/device(src)

/obj/item/device/autopsy_scanner/objective
	var/datum/cm_objective/retrieve_item/device/objective
	unacidable = 1

/obj/item/device/autopsy_scanner/objective/New()
	..()
	if(prob(50))
		objective = new /datum/cm_objective/retrieve_item/device(src)
