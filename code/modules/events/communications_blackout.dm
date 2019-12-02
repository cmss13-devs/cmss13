/datum/event/communications_blackout/announce()
	var/alert = "Ionic radiation flare detected from nearby star. Imminent telecommunication failu*3mga;b4;'1v�-BZZZT"

	for(var/mob/living/silicon/ai/A in player_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, SPAN_WARNING("<b>[alert]</b>"))
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		marine_announcement(alert, "Problem Detected", 'sound/misc/interference.ogg')


/datum/event/communications_blackout/start()
	for(var/obj/structure/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
