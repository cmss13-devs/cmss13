
/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/is_mob_restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/verb/warcry_macro()
	set name = "warcry"
	set hidden = 1

	to_chat(usr, SPAN_WARNING("Your species doesn't have a warcry associated with it!"))

/mob/living/carbon/human/warcry_macro()
	emote("warcry", player_caused = TRUE)

/mob/living/carbon/human/yautja/warcry_macro()
	emote("roar", player_caused = TRUE)

/mob/living/carbon/Xenomorph/warcry_macro()
	emote("roar", player_caused = TRUE)

/mob/living/carbon/verb/medic_macro()
	set name = "medic"
	set hidden = 1

	to_chat(usr, SPAN_WARNING("Your species doesn't have a help cry associated with it!"))

/mob/living/carbon/human/medic_macro()
	emote("medic", player_caused = TRUE)

/mob/living/carbon/human/yautja/medic_macro()
	emote("click", player_caused = TRUE)

/mob/living/carbon/Xenomorph/medic_macro()
	emote("needhelp", player_caused = TRUE)