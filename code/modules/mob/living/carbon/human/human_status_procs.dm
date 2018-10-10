
/mob/living/carbon/human/Stun(amount)
	if(HULK in mutations)	return
	if(isYautja(src)) 
		amount *= 0.5
		if(round(amount) && src.contents && src.contents.len)
			for(var/obj/item/weapon/wristblades/W in src.contents)
				if(istype(W,/obj/item/weapon/wristblades/scimitar))
					W = new /obj/item/weapon/wristblades/scimitar
				else
					W = new /obj/item/weapon/wristblades

	..()

/mob/living/carbon/human/KnockDown(amount)
	if(HULK in mutations)	return
	if(isYautja(src)) 
		amount *= 0.5
		if(round(amount) && src.contents && src.contents.len)
			for(var/obj/item/weapon/wristblades/W in src.contents)
				if(istype(W, /obj/item/weapon/wristblades/scimitar))
					W = new /obj/item/weapon/wristblades/scimitar
				else
					W = new /obj/item/weapon/wristblades
	..()

/mob/living/carbon/human/KnockOut(amount)
	if(HULK in mutations || isSynth(src) || isYautja(src))	return
	..()
