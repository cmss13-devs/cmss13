/datum/emergency_call/show_join_message()
	. = ..()
	if(!mob_max || !SSticker.mode) //Just a supply drop, don't bother.
		return

	for(var/mob/dead/observer/M in GLOB.observer_list)
		if(M.client)
			M << sound('modular/sounds/sound/beeps_jingle.ogg', wait = 0, volume = 25) // SS220 ADD - ERT Sound
