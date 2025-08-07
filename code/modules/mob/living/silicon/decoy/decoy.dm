//Should likely just replace this with an actual AI mob in the future. Might as well.
/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/obj/structures/machinery/ai.dmi'
	icon_state = "hydra"
	anchored = TRUE
	density = TRUE //Do not want to see past it.
	bound_height = 64 //putting this in so we can't walk through our machine.
	bound_width = 96
	custom_slashed_sound = "alien_claw_metal"
	var/obj/item/device/radio/headset/almayer/mcom/ai/ai_headset //The thing it speaks into.
	maxHealth = 1000
	health = 1000

/mob/living/silicon/decoy/ship_ai //For the moment, pending better pathing.
	var/silent_announcement_cooldown = 0

/mob/living/silicon/decoy/ship_ai/Initialize()
	. = ..()
	name = MAIN_AI_SYSTEM
	desc = "This is the artificial intelligence system for the [MAIN_SHIP_NAME]. Like many other military-grade AI systems, this one was manufactured by Weyland-Yutani."
	ai_headset = new(src)
	GLOB.ai_mob_list += src
	real_name = MAIN_AI_SYSTEM
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_INHERENT)

/mob/living/silicon/decoy/ship_ai/Destroy()
	QDEL_NULL(ai_headset)
#ifdef UNIT_TESTS
	GLOB.ai_mob_list -= src // Or should we always remove them?
#endif
	return ..()

/mob/living/silicon/decoy/Life(delta_time)
	if(stat == DEAD)
		return FALSE
	if(health <= HEALTH_THRESHOLD_DEAD && stat != DEAD)
		death()

/mob/living/silicon/decoy/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()

/mob/living/silicon/decoy/death(cause, gibbed, deathmessage = "sparks up and falls silent...")
	if(stat == DEAD)
		return FALSE

	//ARES sends out last messages
	ares_final_words()
	icon_state = "hydra-off"
	var/datum/cause_data/cause_data = create_cause_data("rapid unscheduled disassembly", src, src)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), loc, -1, 0, 8, 12, TRUE, FALSE, 0, cause_data), 2 SECONDS)
	return ..()

/mob/living/silicon/decoy/say(message) //General communication across the ship.
	if(stat || !message)
		return FALSE

	message = trim(strip_html(message))

	var/message_mode = parse_message_mode(message) //I really prefer my rewrite of all this.

	switch(message_mode)
		if("headset")
			message = copytext(message, 2)
		if("broadcast")
			message_mode = "headset"
		else
			message = copytext(message, 3)

	ai_headset.talk_into(src, message, message_mode, "states", languages[1])
	return TRUE

/mob/living/silicon/decoy/parse_message_mode(message)
	. = "broadcast"

	if(length(message) >= 1 && copytext(message,1,2) == ";")
		return "headset"

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		channel_prefix = GLOB.department_radio_keys[channel_prefix]
		if(channel_prefix)
			return channel_prefix


/*Specific communication to a terminal.
/mob/living/silicon/decoy/proc/transmit(message)
*/
