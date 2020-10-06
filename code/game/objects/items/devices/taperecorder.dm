/obj/item/device/taperecorder
	desc = "A device that can record up to an hour of dialogue and play it back. It automatically translates the content in playback."
	name = "universal recorder"
	icon_state = "taperecorderidle"
	item_state = "analyzer"
	w_class = SIZE_SMALL

	matter = list("metal" = 60,"glass" = 30)

	var/recording = 0.0
	var/playing = 0.0
	var/timerecorded = 0.0
	var/playsleepseconds = 0.0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/canprint = 1
	flags_atom = FPRINT|CONDUCT
	throwforce = 2
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/device/taperecorder/hear_talk(mob/living/M as mob, msg, var/verb="says", var/speaking, var/italics = 0)
	if(recording)
		timestamp+= timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] [M.name] [verb], \"[italics ? "<i>" : null][msg][italics ? "</i>" : null]\""
		return

/obj/item/device/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_DANGER("[src] explodes!"))
	if(T)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/device/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.stat)
		return
	icon_state = "taperecorderrecording"
	if(timerecorded < 3600 && playing == 0)
		to_chat(usr, SPAN_NOTICE("Recording started."))
		recording = 1
		timestamp+= timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording started."
		for(timerecorded, timerecorded<3600)
			if(recording == 0)
				break
			timerecorded++
			sleep(10)
		recording = 0
		icon_state = "taperecorderidle"
		return
	else
		to_chat(usr, SPAN_NOTICE("Either [src]'s memory is full, or it is currently playing back its memory."))


/obj/item/device/taperecorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.stat)
		return
	if(recording == 1)
		recording = 0
		timestamp+= timerecorded
		storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording stopped."
		to_chat(usr, SPAN_NOTICE("Recording stopped."))
		icon_state = "taperecorderidle"
		return
	else if(playing == 1)
		playing = 0
		var/turf/T = get_turf(src)
		T.visible_message("<font color=Maroon><B>[src]</B>: Playback stopped.</font>")
		icon_state = "taperecorderidle"
		return


/obj/item/device/taperecorder/verb/clear_memory()
	set name = "Clear Memory"
	set category = "Object"

	if(usr.stat)
		return
	if(recording == 1 || playing == 1)
		to_chat(usr, SPAN_NOTICE("You can't clear the memory while playing or recording!"))
		return
	else
		if(storedinfo)	storedinfo.Cut()
		if(timestamp)	timestamp.Cut()
		timerecorded = 0
		to_chat(usr, SPAN_NOTICE("Memory cleared."))
		return


/obj/item/device/taperecorder/verb/playback_memory()
	set name = "Playback Memory"
	set category = "Object"

	if(usr.stat)
		return
	if(recording == 1)
		to_chat(usr, SPAN_NOTICE("You can't playback when recording!"))
		return
	if(playing == 1)
		to_chat(usr, SPAN_NOTICE("You're already playing!"))
		return
	playing = 1
	icon_state = "taperecorderplaying"
	to_chat(usr, SPAN_NOTICE("Playing started."))
	for(var/i=1,timerecorded<3600,sleep(10 * (playsleepseconds) ))
		if(playing == 0)
			break
		if(storedinfo.len < i)
			break
		var/turf/T = get_turf(src)
		T.visible_message("<font color=Maroon><B>[src]</B>: [storedinfo[i]]</font>")
		if(storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.visible_message("<font color=Maroon><B>[src]</B>: End of recording.</font>")
		else
			playsleepseconds = timestamp[i+1] - timestamp[i]
		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.visible_message("<font color=Maroon><B>[src]</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		i++
	icon_state = "taperecorderidle"
	playing = 0


/obj/item/device/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.stat)
		return
	if(!canprint)
		to_chat(usr, SPAN_NOTICE("The recorder can't print that fast!"))
		return
	if(recording == 1 || playing == 1)
		to_chat(usr, SPAN_NOTICE("You can't print the transcript while playing or recording!"))
		return
	to_chat(usr, SPAN_NOTICE("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,storedinfo.len >= i,i++)
		t1 += "[storedinfo[i]]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	addtimer(VARSET_CALLBACK(src, canprint, TRUE), 30 SECONDS)


/obj/item/device/taperecorder/attack_self(mob/user)
	if(recording == 0 && playing == 0)
		if(usr.stat)
			return
		icon_state = "taperecorderrecording"
		if(timerecorded < 3600 && playing == 0)
			to_chat(usr, SPAN_NOTICE(" Recording started."))
			recording = 1
			timestamp+= timerecorded
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording started."
			for(timerecorded, timerecorded<3600)
				if(recording == 0)
					break
				timerecorded++
				sleep(10)
			recording = 0
			icon_state = "taperecorderidle"
			return
		else
			to_chat(usr, SPAN_DANGER("Either [src]'s memory is full, or it is currently playing back its memory."))
	else
		if(usr.stat)
			to_chat(usr, "Not when you're incapacitated.")
			return
		if(recording == 1)
			recording = 0
			timestamp+= timerecorded
			storedinfo += "\[[time2text(timerecorded*10,"mm:ss")]\] Recording stopped."
			to_chat(usr, SPAN_NOTICE(" Recording stopped."))
			icon_state = "taperecorderidle"
			return
		else if(playing == 1)
			playing = 0
			var/turf/T = get_turf(src)
			for(var/mob/O in hearers(world_view_size-1, T))
				O.show_message("<font color=Maroon><B>[src]</B>: Playback stopped.</font>",2)
			icon_state = "taperecorderidle"
			return
		else
			to_chat(usr, SPAN_DANGER("Stop what?"))
			return
