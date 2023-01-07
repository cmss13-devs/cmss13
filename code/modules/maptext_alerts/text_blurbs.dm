//Based on code ported from Nebula. https://github.com/NebulaSS13/Nebula/pull/357

///Reads out a description of game time, game date, main ship and current area. Originally for displaying roundstart messages on a conventional SS13 server.
/proc/show_location_blurb(list/mob/targets, area/A, duration)
	set waitfor = 0
	var/areaname = replacetext(A.name, "\improper", "") //The \improper flickers "ÿ" briefly

	var/text = "[worldtime2text("hhmm")], [time2text(REALTIMEOFDAY, "DD-MMM-[game_year]")]\n[station_name], [areaname]"

	show_blurb(targets, duration, text, TRUE)

/**Shows operation start blurb to living marines. Slightly different for squad marines, pilots, and deploying ship crew/passengers.
exempt_ztraits = trait or list of traits of zlevels where any marines don't see the message, ex. marine faction survivors colonyside
shouldn't see the ship marines' drop message. Ex. ZTRAIT_GROUND by default.
unit = the unit the marines are from. FF, Dust Raiders etc. Military crew see this.
base = the base the marines are staging from. The ship, Whiskey Outpost etc. Noncombat crew see this.**/
/proc/show_blurb_uscm(list/exempt_ztraits = ZTRAIT_GROUND, unit = "2nd Bat. 'Falling Falcons'", base = station_name)
	if(!islist(exempt_ztraits))
		exempt_ztraits = list(exempt_ztraits)
	var/list/exempt_zlevels = SSmapping.levels_by_any_trait(exempt_ztraits)

	var/base_text = "<b>[uppertext(round_statistics.round_name)]</b>\n\
						[worldtime2text("hhmm hrs")], [uppertext(time2text(REALTIMEOFDAY, "DD-MMM-[game_year]"))]\n\
						[SSmapping.configs[GROUND_MAP].map_name]"

	var/list/post_text = list("combat" = "\n[unit]",
							"po" = "\nFlight Crew, [base]",
							"mp" = "\nSecurity, [base]",
							"eng" = "\nEngineering, [base]",
							"med" = "\nMedical, [base]",
							"req" = "\nLogistics, [base]",
							"cl" = "\nLiaison, [base]",
							"misc" = "\nCrew, [base]")

	//We'll save processing by showing the same message object to each marine in a category.
	var/list/mobarray = list("combat" = list(),
							"po" = list(),
							"mp" = list(),
							"eng" = list(),
							"med" = list(),
							"req" = list(),
							"cl" = list(),
							"misc" = list())

	for(var/mob/living/carbon/human/H as anything in GLOB.alive_human_list)
		if(H.faction != FACTION_MARINE || (H.z in exempt_zlevels))
			continue
		switch(H.job)
			if(BLURB_USCM_COMBAT)
				mobarray["combat"] += H
			if(BLURB_USCM_FLIGHT)
				mobarray["po"] += H
			if(BLURB_USCM_MP)
				mobarray["mp"] += H
			if(BLURB_USCM_ENGI)
				mobarray["eng"] += H
			if(BLURB_USCM_MEDICAL)
				mobarray["med"] += H
			if(BLURB_USCM_REQ)
				mobarray["req"] += H
			if(BLURB_USCM_WY)
				mobarray["cl"] += H
			else
				mobarray["misc"] += H

	for(var/L in mobarray)
		show_blurb(mobarray[L], 3 SECONDS, "[base_text][post_text[L]]", TRUE, blurb_key = "USCM")

/**Shows a ticker reading out the given text on a client's screen.
targets = mob or list of mobs to show it to.

duration = how long it lingers after it finishes ticking.

message = the message to display. Due to using maptext it isn't very flexible format-wise. 11px font, up to 480 pixels per line.
Use \n for line breaks. Single-character HTML tags (<b>, <i>, <u> etc.) are handled correctly but others display strangely.
Note that maptext can display text macros in strange ways, ex. \improper showing as "ÿ". Lines containing only spaces,
including ones only containing "\improper ", don't display.

scroll_down = by default each line pushes the previous line upwards - this tells it to start high and scroll down.
Ticks on \n - does not autodetect line breaks in long strings.

screen_position = screen loc for the bottom-left corner of the blurb.

text_alignment = "right", "left", or "center"

text_color = colour of the text.

blurb_key = a key used for specific blurb types so they are not shown repeatedly. Ex. someone who joins as CLF repeatedly only seeing the mission blurb the first time.

ignore_key = used to skip key checks. Ex. a USCM ERT member shouldn't see the normal USCM drop message,
but should see their own spawn message even if the player already dropped as USCM.**/
/proc/show_blurb(list/mob/targets, duration = 3 SECONDS, message, scroll_down, screen_position = "LEFT+0:16,BOTTOM+1:16",\
	text_alignment = "left", text_color = "#FFFFFF", blurb_key, ignore_key = FALSE, speed = 1)
	set waitfor = 0
	if(!islist(targets))
		targets = list(targets)
	if(!length(targets))
		return

	var/style = "font-family: Fixedsys, monospace; -dm-text-outline: 1 black; font-size: 11px; text-align: [text_alignment]; color: [text_color];" //This font doesn't seem to respect pixel sizes.
	var/list/linebreaks = list() //Due to singular /'s making text disappear for a moment and for counting lines.

	var/linebreak = findtext(message, "\n")
	while(linebreak)
		linebreak++ //Otherwise it picks up the character immediately before the linebreak.
		linebreaks += linebreak
		linebreak = findtext(message, "\n", linebreak)

	var/list/html_tags = list()
	var/html_tag = findtext(message, regex("<.>"))
	var/opener = TRUE
	while(html_tag)
		html_tag++
		if(opener)
			html_tags += list(html_tag, html_tag + 1, html_tag + 2)
			html_tag = findtext(message, regex("<.>"), html_tag + 2)
			if(!html_tag)
				opener = FALSE
				html_tag = findtext(message, regex("</.>"))
		else
			html_tags += list(html_tag, html_tag + 1, html_tag + 2, html_tag + 3)
			html_tag = findtext(message, regex("</.>"), html_tag + 3)

	var/atom/movable/screen/text/T = new()
	T.screen_loc = screen_position
	switch(text_alignment)
		if("center")
			T.maptext_x = -(T.maptext_width * 0.5 - 16) //Centering the textbox.
		if("right")
			T.maptext_x = -(T.maptext_width - 32) //Aligning the textbox with the right edge of the screen object.
	if(scroll_down)
		T.maptext_y = length(linebreaks) * 14

	for(var/mob/M as anything in targets)
		if(blurb_key)
			if(!ignore_key && (M.key in GLOB.blurb_witnesses[blurb_key]))
				continue
			LAZYDISTINCTADD(GLOB.blurb_witnesses[blurb_key], M.key)
		M.client?.screen += T

	for(var/i in 1 to length(message) + 1)
		if(i in linebreaks)
			if(scroll_down)
				T.maptext_y -= 14 //Move the object to keep lines in the same place.
			continue
		if(i in html_tags)
			continue
		T.maptext = "<span style=\"[style]\">[copytext(message,1,i)]</span>"
		sleep(speed)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), targets, T), duration)

/proc/fade_blurb(list/mob/targets, obj/T)
	animate(T, alpha = 0, time = 0.5 SECONDS)
	sleep(5)
	for(var/mob/M as anything in targets)
		M.client?.screen -= T
	qdel(T)
