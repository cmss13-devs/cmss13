#define STAMINA_SPEED_VERYSLOW        4.50
#define STAMINA_SPEED_SLOW            3.75
#define STAMINA_SPEED_HIGH            2.75
#define STAMINA_SPEED_MED            1.50
#define STAMINA_SPEED_LOW            1

/datum/effects/stamina
    effect_name = "stamina"
    var/slowdown = 0
    duration = 30
    flags = INF_DURATION | NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE

/datum/effects/stamina/validate_atom(var/atom/A)
	if(isobj(A))
		return FALSE
	. = ..()

/datum/effects/stamina/human
    var/pain_message = ""
    var/emote_message = null
    var/do_once = TRUE

/datum/effects/stamina/human/process_mob()
    . = ..()
    if(!.)
        return FALSE

    var/mob/living/affected_mob = affected_atom
    if((duration % 20 == 0) && affected_mob.client && affected_mob.client.prefs && (CHAT_TYPE_PAIN & affected_mob.client.prefs.chat_display_preferences)) //Do it every fifth tick
        to_chat(affected_mob, SPAN_DANGER(pain_message))

    if(emote_message && (duration % 60 == 0))
        affected_mob.emote("me", 1, pick(emote_message), FALSE)

    return TRUE

/datum/effects/stamina/human/tier1

/datum/effects/stamina/human/tier1/process_mob()
	. = ..()
	return PROCESS_KILL

/datum/effects/stamina/human/tier2
    pain_message = "You feel very tired."
    slowdown = STAMINA_SPEED_MED


/datum/effects/stamina/human/tier3
    pain_message = "You feel exhausted."
    emote_message = list("yawns.")
    slowdown = STAMINA_SPEED_HIGH

/datum/effects/stamina/human/tier3/process_mob()
    . = ..()
    if(!.)
        return FALSE

    var/mob/living/carbon/affected_mob = affected_atom
    affected_mob.EyeBlur(2)
    affected_mob.TalkStutter(2)

    return TRUE


/datum/effects/stamina/human/tier4
    pain_message = "You feel like you could drop any moment now!"
    emote_message = list("is having trouble keeping their eyes open.")
    slowdown = STAMINA_SPEED_SLOW

/datum/effects/stamina/human/tier4/process_mob()
    . = ..()
    if(!.)
        return FALSE

    var/mob/living/carbon/affected_mob = affected_atom
    if(do_once)
        affected_mob.Daze(3)
        do_once = FALSE

    affected_mob.EyeBlur(2)
    affected_mob.TalkStutter(2)

    return TRUE


/datum/effects/stamina/human/tier5
    pain_message = "You feel like you could drop any moment now!"
    emote_message = list("is having trouble standing.")
    slowdown = STAMINA_SPEED_VERYSLOW

/datum/effects/stamina/human/tier5/process_mob()
    . = ..()
    if(!.)
        return FALSE

    var/mob/living/carbon/affected_mob = affected_atom
    affected_mob.EyeBlur(2)

    affected_mob.TalkStutter(2)
    affected_mob.KnockOut(2)

    return TRUE
