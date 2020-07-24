
/mob/living/carbon/human/Stun(amount)
	if(isYautja(src)) 
		amount *= 0.5
		if(round(amount) && src.contents && src.contents.len)
			for(var/obj/item/weapon/wristblades/W in src.contents)
				W = new /obj/item/weapon/wristblades

	..()

/mob/living/carbon/human/KnockDown(amount)
	if(isYautja(src))
		amount *= 0.5
		if(round(amount) && src.contents && src.contents.len)
			for(var/obj/item/weapon/wristblades/W in src.contents)
				W = new /obj/item/weapon/wristblades
	..()

/mob/living/carbon/human/KnockOut(var/amount, var/force = FALSE)
	if((isSynth(src) || isYautja(src)) && !force)	return
	..()
