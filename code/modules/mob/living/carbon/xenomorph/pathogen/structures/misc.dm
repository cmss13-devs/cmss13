/datum/construction_template/xenomorph/patho_plasma
	name = PATHOGEN_STRUCTURE_PLASMA
	description = "Gives out small bursts of plasma, replenishing the reserves of the sisters around it."
	build_type = /obj/effect/alien/resin/special/plasma_tree/pathogen
	build_icon_state = "recovery_plasma"

/datum/construction_template/xenomorph/patho_plasma/set_structure_image()
	build_icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'

/datum/construction_template/xenomorph/patho_recovery
	name = PATHOGEN_STRUCTURE_RECOVERY
	description = "Hastily recovers the strength of sisters resting around it."
	build_type = /obj/effect/alien/resin/special/recovery/pathogen
	build_icon_state = "recovery"

/datum/construction_template/xenomorph/patho_recovery/set_structure_image()
	build_icon = 'icons/mob/pathogen/pathogen_structures64x64.dmi'
