/datum/internal_organ/brain
	name = "brain"
	removed_type = /obj/item/organ/brain
	robotic_type = /obj/item/organ/brain/prosthetic
	vital = 1
	min_bruised_integrity = LIMB_INTEGRITY_SERIOUS
	min_broken_integrity = LIMB_INTEGRITY_CRITICAL
	organ_tag = ORGAN_BRAIN

/datum/internal_organ/brain/prosthetic //used by synthetic species
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/brain/prosthetic

/datum/internal_organ/brain/xeno
	removed_type = /obj/item/organ/brain/xeno
	robotic_type = null

/datum/internal_organ/brain/on_malfunction(trait_source)
	..()
	RegisterSignal(owner, COMSIG_MOB_PRE_ITEM_ZOOM, .proc/block_zoom)
	//Add stuttering

/datum/internal_organ/brain/proc/block_zoom(obj/item/O)
	SIGNAL_HANDLER
	to_chat(owner, SPAN_WARNING("You try to look through [O], but the blood and pain clouding your vision forces you to rub your eyes, lowering it in the process!"))
	return COMPONENT_CANCEL_ZOOM
