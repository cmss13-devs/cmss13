/mob/living/carbon/human/guardian

/mob/living/carbon/human/guardian/death(cause, gibbed)
	if(stat != DEAD)
		var/obj/item/alien_embryo/larva_embryo = locate() in src
		if(larva_embryo)
			larva_embryo.start_bursting(new/mob/living/carbon/xenomorph/larva(src), src)
	. = ..()


/obj/item/alien_embryo/dormant/Initialize(mapload, ...)
	. = ..()
	stage = 6
	STOP_PROCESSING(SSobj, src)
