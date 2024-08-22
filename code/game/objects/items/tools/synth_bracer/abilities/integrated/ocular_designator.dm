/obj/item/clothing/gloves/synth
	var/obj/item/device/binoculars/binos

/obj/item/clothing/gloves/synth/Initialize(mapload, ...)
	. = ..()
	binos = new(src)
	RegisterSignal(binos, COMSIG_ITEM_DROPPED, PROC_REF(return_binos))

/obj/item/clothing/gloves/synth/attackby(obj/item/I, mob/user)
	if(I == binos)
		return_binos()
		return
	return ..()

/obj/item/clothing/gloves/synth/dropped(mob/user)
	. = ..()
	return_binos()

/obj/item/clothing/gloves/synth/Destroy()
	QDEL_NULL(binos)
	return ..()

/obj/item/clothing/gloves/synth/proc/deploy_binos(mob/M)
	if(!M.put_in_active_hand(binos))
		M.put_in_inactive_hand(binos)

/obj/item/clothing/gloves/synth/proc/return_binos()
	if(QDELETED(binos))
		binos = null
		return

	if(ismob(binos.loc))
		var/mob/M = binos.loc
		M.drop_inv_item_to_loc(binos, src)
	else
		binos.forceMove(src)


/datum/action/human_action/synth_bracer/deploy_binoculars
	name = "Deploy Binoculars"
	action_icon_state = "far_sight"
	human_adaptable = TRUE

/datum/action/human_action/synth_bracer/deploy_ocular_binos/can_use_action()
	if(QDELETED(synth_bracer.binos) || synth_bracer.binos.loc != synth_bracer)
		to_chat(synth, SPAN_WARNING("The ocular device isn't inside the SIMI anymore."))
		return FALSE
	if(synth.l_hand && synth.r_hand)
		to_chat(synth, SPAN_WARNING("You need at least one free hand."))
		return FALSE
	return ..()

/datum/action/human_action/synth_bracer/deploy_binoculars/action_activate()
	..()
	if(COOLDOWN_FINISHED(synth_bracer, sound_cooldown))
		COOLDOWN_START(synth_bracer, sound_cooldown, 5 SECONDS)
		playsound(synth_bracer.loc,'sound/machines/click.ogg', 25, TRUE)
	if(synth_bracer.binos.loc == synth_bracer)
		to_chat(synth, SPAN_NOTICE("You deploy your binoculars."))
		synth_bracer.deploy_binos(synth)
	else
		to_chat(synth, SPAN_NOTICE("You return your binoculars."))
		synth_bracer.return_binos(synth)
