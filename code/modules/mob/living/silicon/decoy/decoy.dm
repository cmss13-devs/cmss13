/mob/living/silicon/decoy/ship_ai //For the moment, pending better pathing.
	var/silent_announcement_cooldown = 0

/mob/living/silicon/decoy/ship_ai/Initialize()
	. = ..()
	name = MAIN_AI_SYSTEM
	desc = "This is the artificial intelligence system for the [MAIN_SHIP_NAME]. Like many other military-grade AI systems, this one was manufactured by Weyland-Yutani."
	ai_headset = new(src)
	ai_mob_list += src

//Should likely just replace this with an actual AI mob in the future. Might as well.
/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/obj/structures/machinery/ai.dmi'
	icon_state = "hydra"
	anchored = TRUE
	canmove = 0
	density = TRUE //Do not want to see past it.
	bound_height = 64 //putting this in so we can't walk through our machine.
	bound_width = 96
	var/obj/item/device/radio/headset/almayer/mcom/ai/ai_headset //The thing it speaks into.

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
	icon_state = "hydra-off"
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), loc, -1, 0, 8, 12), 2 SECONDS)
	return ..()

/mob/living/silicon/decoy/say(message) //General communication across the ship.
	if(stat || !message)
		return FALSE

	message = trim(strip_html(message))

	var/message_mode = parse_message_mode(message) //I really prefer my rewrite of all this.

	switch(message_mode)
		if("headset") message = copytext(message, 2)
		if("broadcast") message_mode = "headset"
		else message = copytext(message, 3)

	ai_headset.talk_into(src, message, message_mode, "states", languages[1])
	return TRUE

/mob/living/silicon/decoy/parse_message_mode(message)
	. = "broadcast"

	if(length(message) >= 1 && copytext(message,1,2) == ";")
		return "headset"

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		channel_prefix = department_radio_keys[channel_prefix]
		if(channel_prefix) return channel_prefix


/*Specific communication to a terminal.
/mob/living/silicon/decoy/proc/transmit(message)
*/
