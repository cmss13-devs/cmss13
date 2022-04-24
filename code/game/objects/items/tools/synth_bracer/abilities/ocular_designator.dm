/obj/item/clothing/gloves/synth
	var/obj/item/device/binoculars/range/designator/scout/designator

/obj/item/clothing/gloves/synth/Initialize(mapload, ...)
	. = ..()
	designator = new(src)
	RegisterSignal(designator, COMSIG_ITEM_DROPPED, .proc/return_designator)

/obj/item/clothing/gloves/synth/attackby(obj/item/I, mob/user)
	if(I == designator)
		return_designator()
		return
	return ..()

/obj/item/clothing/gloves/synth/dropped(mob/user)
	. = ..()
	return_designator()

/obj/item/clothing/gloves/synth/Destroy()
	QDEL_NULL(designator)
	return ..()

/obj/item/clothing/gloves/synth/proc/deploy_designator(var/mob/M)
	if(!M.put_in_active_hand(designator))
		M.put_in_inactive_hand(designator)

/obj/item/clothing/gloves/synth/proc/return_designator()
	if(QDELETED(designator))
		designator = null
		return

	if(ismob(designator.loc))
		var/mob/M = designator.loc
		M.drop_inv_item_to_loc(designator, src)
	else
		designator.forceMove(src)


/datum/action/human_action/synth_bracer/deploy_ocular_designator
	name = "Deploy Ocular Designator"
	action_icon_state = "toggle_queen_zoom"

/datum/action/human_action/synth_bracer/deploy_ocular_designator/can_use_action()
	if(QDELETED(synth_bracer.designator) || synth_bracer.designator.loc != synth_bracer)
		to_chat(synth, SPAN_WARNING("The designator isn't inside the SIMI anymore."))
		return FALSE
	if(synth.l_hand && synth.r_hand)
		to_chat(synth, SPAN_WARNING("You need at least one free hand."))
		return FALSE
	return ..()

/datum/action/human_action/synth_bracer/deploy_ocular_designator/action_activate()
	..()

	to_chat(synth, SPAN_NOTICE("You deploy your ocular designator."))
	synth_bracer.deploy_designator(synth)
