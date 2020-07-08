/datum/effects/pain/human
	var/pain_message = ""
	var/emote_message = null
	var/do_once = TRUE

/datum/effects/pain/human/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/affected_mob = affected_atom
	if((duration % 20 == 0) && affected_mob.client && affected_mob.client.prefs && (CHAT_TYPE_PAIN & affected_mob.client.prefs.chat_display_preferences)) //Do it every fifth tick
		to_chat(affected_mob, SPAN_DANGER(pain_message))

	if(emote_message && (duration % 60 == 0))
		affected_mob.emote("me", 1, pick(emote_message), FALSE)

	return TRUE


/datum/effects/pain/human/mild
	pain_message = "You grimace in pain."


/datum/effects/pain/human/moderate
	pain_message = "You really need some painkillers!"


/datum/effects/pain/human/modsevere
	pain_message = "The pain is excruciating!"
	emote_message = list("grimaces in pain.")

/datum/effects/pain/human/modsevere/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.EyeBlur(0.2)
	if(affected_mob.pain && affected_mob.pain.feels_pain)
		affected_mob.TalkStutter(2)

	return TRUE


/datum/effects/pain/human/severe
	pain_message = "You feel like you could die any moment now!"
	emote_message = list("is having trouble keeping their eyes open.")

/datum/effects/pain/human/severe/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	if(do_once)
		affected_mob.KnockOut(3)
		do_once = FALSE

	affected_mob.EyeBlur(0.5)
	if(affected_mob.pain && affected_mob.pain.feels_pain)
		affected_mob.TalkStutter(2)
	if(!affected_mob.reagents || !affected_mob.reagents.has_reagent("inaprovaline"))
		affected_mob.apply_damage(0.5, OXY)

	return TRUE


/datum/effects/pain/human/very_severe
	pain_message = "You feel like you could die any moment now!"
	emote_message = list("is having trouble standing.")

/datum/effects/pain/human/very_severe/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.EyeBlur(2)
	if(affected_mob.pain && affected_mob.pain.feels_pain)
		affected_mob.TalkStutter(2)
	affected_mob.KnockOut(2)
	if(!affected_mob.reagents || !affected_mob.reagents.has_reagent("inaprovaline"))
		affected_mob.apply_damage(3, OXY)

	return TRUE