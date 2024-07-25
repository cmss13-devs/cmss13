// Status display
// (formerly Countdown timer display)

// Use to show shuttle ETA/ETD times
// Alert status
// And arbitrary messages set by comms computer

#define CHARS_PER_LINE 5
#define STATUS_DISPLAY_BLANK 0
#define STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME 1
#define STATUS_DISPLAY_MESSAGE 2
#define STATUS_DISPLAY_ALERT 3
#define STATUS_DISPLAY_TIME 4
#define STATUS_DISPLAY_CUSTOM 99

/obj/structure/machinery/status_display
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "frame"
	name = "status display"
	desc = "A monitor depicting the ship's current status. It flickers every so often."
	anchored = TRUE
	density = FALSE
	use_power = FALSE
	idle_power_usage = 10
	var/mode = 0 // 0 = Blank
					// 1 = Shuttle timer
					// 2 = Arbitrary message(s)
					// 3 = alert picture
					// 4 = Supply shuttle timer

	var/picture_state // icon_state of alert picture
	var/message1 = "" // message line 1
	var/message2 = "" // message line 2
	var/index1 // display index for scrolling messages or 0 if non-scrolling
	var/index2

	var/frequency = 1435 // radio frequency

	var/friendc = 0   // track if Friend Computer mode
	var/ignore_friendc = 0

	maptext_height = 26
	maptext_width = 32

/obj/structure/machinery/status_display/Initialize()
	. = ..()
	set_picture("default")

	if(is_mainship_level(z))
		RegisterSignal(SSdcs, COMSIG_GLOB_SECURITY_LEVEL_CHANGED, PROC_REF(sec_changed))

/obj/structure/machinery/status_display/proc/sec_changed(datum/source, new_sec)
	SIGNAL_HANDLER
	switch(new_sec)
		if(SEC_LEVEL_GREEN)
			set_picture("default")
		if(SEC_LEVEL_BLUE)
			set_picture("bluealert")
		if(SEC_LEVEL_RED, SEC_LEVEL_DELTA)
			set_picture("redalert")

/obj/structure/machinery/status_display/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	set_picture("ai_bsod")
	..(severity)

// set what is displayed
/obj/structure/machinery/status_display/proc/update()
	if(friendc && !ignore_friendc)
		set_picture("ai_friend")
		return 1

	switch(mode)
		if(STATUS_DISPLAY_BLANK) //blank
			remove_display()
			return 1
		if(STATUS_DISPLAY_TRANSFER_SHUTTLE_TIME) //emergency shuttle timer
			message1 = "EVAC"
			message2 = SShijack.get_evac_eta()
			if(message2)
				if(length(message2) > CHARS_PER_LINE) message2 = "Error"
				update_display(message1, message2)
			else remove_display()
			return 1
		if(STATUS_DISPLAY_MESSAGE) //custom messages
			var/line1
			var/line2

			if(!index1)
				line1 = message1
			else
				line1 = copytext(message1+"|"+message1, index1, index1+CHARS_PER_LINE)
				var/message1_len = length(message1)
				index1 += SCROLL_SPEED
				if(index1 > message1_len)
					index1 -= message1_len

			if(!index2)
				line2 = message2
			else
				line2 = copytext(message2+"|"+message2, index2, index2+CHARS_PER_LINE)
				var/message2_len = length(message2)
				index2 += SCROLL_SPEED
				if(index2 > message2_len)
					index2 -= message2_len
			update_display(line1, line2)
			return 1
		if(STATUS_DISPLAY_TIME)
			message1 = "TIME"
			message2 = worldtime2text()
			update_display(message1, message2)
			return 1
	return 0

/obj/structure/machinery/status_display/get_examine_text(mob/user)
	. = ..()
	if(mode != STATUS_DISPLAY_BLANK && mode != STATUS_DISPLAY_ALERT)
		. += "The display says:<br>\t[strip_html(message1)]<br>\t[strip_html(message2)]"

/obj/structure/machinery/status_display/proc/set_message(m1, m2)
	if(m1)
		index1 = (length(m1) > CHARS_PER_LINE)
		message1 = m1
	else
		message1 = ""
		index1 = 0

	if(m2)
		index2 = (length(m2) > CHARS_PER_LINE)
		message2 = m2
	else
		message2 = ""
		index2 = 0

/obj/structure/machinery/status_display/proc/set_picture(state)
	picture_state = state
	mode = 3
	remove_display()
	overlays += image('icons/obj/structures/machinery/status_display.dmi', icon_state=picture_state)

/obj/structure/machinery/status_display/proc/update_display(line1, line2)
	var/new_text = {"<div style="font-size:[FONT_SIZE];color:[DEFAULT_FONT_COLOR];font:'[FONT_STYLE]';text-align:center;" valign="top">[line1]<br>[line2]</div>"}
	if(maptext != new_text)
		maptext = new_text

/obj/structure/machinery/status_display/proc/get_supply_shuttle_timer()
	var/datum/shuttle/ferry/supply/shuttle = GLOB.supply_controller.shuttle
	if (!shuttle)
		return "Error"

	if(shuttle.has_arrive_time())
		var/timeleft = round((shuttle.arrive_time - world.time) / 10,1)
		if(timeleft < 0)
			return "Late"
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""

/obj/structure/machinery/status_display/proc/remove_display()
	LAZYCLEARLIST(overlays)
	if(maptext)
		maptext = ""

/obj/structure/machinery/status_display/proc/set_sec_level_picture()
	switch(GLOB.security_level)
		if(SEC_LEVEL_GREEN)
			set_picture("default")
		if(SEC_LEVEL_BLUE)
			set_picture("bluealert")
		if(SEC_LEVEL_RED, SEC_LEVEL_DELTA)
			set_picture("redalert")

/obj/structure/machinery/ai_status_display
	icon = 'icons/obj/structures/machinery/status_display.dmi'
	icon_state = "frame"
	name = "AI display"
	anchored = TRUE
	density = FALSE

	var/mode = 0 // 0 = Blank
					// 1 = AI emoticon
					// 2 = Blue screen of death

	var/picture_state // icon_state of ai picture

	var/emotion = "Neutral"

/obj/structure/machinery/ai_status_display/emp_act(severity)
	. = ..()
	if(inoperable())
		return
	set_picture("ai_bsod")

/obj/structure/machinery/ai_status_display/proc/update()
	if(mode==0) //Blank
		overlays.Cut()
		return

	if(mode==1) // AI emoticon
		switch(emotion)
			if("Very Happy")
				set_picture("ai_veryhappy")
			if("Happy")
				set_picture("ai_happy")
			if("Neutral")
				set_picture("ai_neutral")
			if("Unsure")
				set_picture("ai_unsure")
			if("Confused")
				set_picture("ai_confused")
			if("Sad")
				set_picture("ai_sad")
			if("Surprised")
				set_picture("ai_surprised")
			if("Upset")
				set_picture("ai_upset")
			if("Angry")
				set_picture("ai_angry")
			if("BSOD")
				set_picture("ai_bsod")
			if("Blank")
				set_picture("ai_off")
			if("Problems?")
				set_picture("ai_trollface")
			if("Awesome")
				set_picture("ai_awesome")
			if("Dorfy")
				set_picture("ai_urist")
			if("Facepalm")
				set_picture("ai_facepalm")
			if("Friend Computer")
				set_picture("ai_friend")
		return

	if(mode==2) // BSOD
		set_picture("ai_bsod")
		return


/obj/structure/machinery/ai_status_display/proc/set_picture(state)
	picture_state = state
	LAZYCLEARLIST(overlays)
	overlays += image('icons/obj/structures/machinery/status_display.dmi', icon_state=picture_state)

#undef DEFAULT_FONT_COLOR
#undef FONT_STYLE
#undef SCROLL_SPEED
