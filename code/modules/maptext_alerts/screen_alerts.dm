/*
* These are ported from TGMC and are hopefully more flexible than text blurbs
*/

/**
 * proc for playing a screen_text on a mob.
 * enqueues it if a screen text is running and plays i otherwise
 * Arguments:
 * * text: text we want to be displayed
 * * alert_type: typepath for screen text type we want to play here
 * * override_color: the color of the text to use
 */
/mob/proc/play_screen_text(text, alert_type = /atom/movable/screen/text/screen_text, override_color = "#FFFFFF")
	var/atom/movable/screen/text/screen_text/text_box = new alert_type()
	text_box.text_to_play = text
	text_box.player = client
	if(override_color)
		text_box.color = override_color

	LAZYADD(client.screen_texts, text_box)
	if(LAZYLEN(client.screen_texts) == 1) //lets only play one at a time, for thematic effect and prevent overlap
		INVOKE_ASYNC(text_box, TYPE_PROC_REF(/atom/movable/screen/text/screen_text, play_to_client))

/atom/movable/screen/text/screen_text
	icon = null
	icon_state = null
	alpha = 255

	maptext_height = 64
	maptext_width = 480
	maptext_x = 0
	maptext_y = 0
	screen_loc = "LEFT,TOP-3"

	///Time taken to fade in as we start printing text
	var/fade_in_time = 0
	///Time before fade out after printing is finished
	var/fade_out_delay = 2 SECONDS
	///Time taken when fading out after fade_out_delay
	var/fade_out_time = 0.5 SECONDS
	///delay between playing each letter. in general use 1 for fluff and 0.5 for time sensitive messsages
	var/play_delay = 0.5
	///letters to update by per text to per play_delay
	var/letters_per_update = 1

	///opening styling for the message
	var/style_open = "<span class='langchat' style=text-align:center valign='top'>"
	///closing styling for the message
	var/style_close = "</span>"
	///var for the text we are going to play
	var/text_to_play
	///The client that this text is for
	var/client/player

/atom/movable/screen/text/screen_text/command_order
	maptext_height = 64
	maptext_width = 480
	maptext_x = 0
	maptext_y = 0
	screen_loc = "LEFT,TOP-3"

	letters_per_update = 2
	fade_out_delay = 4.5 SECONDS
	style_open = "<span class='langchat' style=font-size:16pt;text-align:center valign='top'>"
	style_close = "</span>"

/atom/movable/screen/text/screen_text/command_order/tutorial
	letters_per_update = 4 // overall, pretty fast while not immediately popping in
	play_delay = 0.1
	fade_out_delay = 2.5 SECONDS
	fade_out_time = 0.5 SECONDS

/atom/movable/screen/text/screen_text/command_order/tutorial/end_play()
	if(!player)
		qdel(src)
		return

	if(player.mob || HAS_TRAIT(player.mob, TRAIT_IN_TUTORIAL))
		return ..()

	for(var/atom/movable/screen/text/screen_text/command_order/tutorial/tutorial_message in player.screen_texts)
		LAZYREMOVE(player.screen_texts, tutorial_message)
		qdel(tutorial_message)

	return ..()

///proc for actually playing this screen_text on a mob.
/atom/movable/screen/text/screen_text/proc/play_to_client()
	player?.add_to_screen(src)
	if(fade_in_time)
		animate(src, alpha = 255)
	var/list/lines_to_skip = list()
	var/static/html_locate_regex = regex("<.*>")
	var/tag_position = findtext(text_to_play, html_locate_regex)
	var/reading_tag = TRUE
	while(tag_position)
		if(reading_tag)
			if(text_to_play[tag_position] == ">")
				reading_tag = FALSE
			lines_to_skip += tag_position
			tag_position++
		else
			tag_position = findtext(text_to_play, html_locate_regex, tag_position)
			reading_tag = TRUE

	for(var/letter = 2 to length(text_to_play) + letters_per_update step letters_per_update)
		if(letter in lines_to_skip)
			continue
		maptext = "[style_open][copytext_char(text_to_play, 1, letter)][style_close]"
		sleep(play_delay)

	addtimer(CALLBACK(src, PROC_REF(after_play)), fade_out_delay)

///handles post-play effects like fade out after the fade out delay
/atom/movable/screen/text/screen_text/proc/after_play()
	if(!fade_out_time)
		end_play()
		return

	animate(src, alpha = 0, time = fade_out_time)
	addtimer(CALLBACK(src, PROC_REF(end_play)), fade_out_time)

///ends the play then deletes this screen object and plays the next one in queue if it exists
/atom/movable/screen/text/screen_text/proc/end_play()
	if(!player)
		qdel(src)
		return

	player.remove_from_screen(src)
	LAZYREMOVE(player.screen_texts, src)
	qdel(src)

	if(QDELETED(player))
		QDEL_NULL_LIST(player.screen_texts)
		return

	if(LAZYLEN(player.screen_texts))
		player.screen_texts[1].play_to_client() // Theres more?
/**
 * Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 * category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 * path is a type path of the actual alert type to throw
 * severity is an optional number that will be placed at the end of the icon_state for this alert
 * For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 * new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 * Clicks are forwarded to master
 * Override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */
/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE)
	if(!category || QDELETED(src))
		return

	var/atom/movable/screen/alert/thealert
	if(alerts[category])
		thealert = alerts[category]
		if(thealert.override_alerts)
			return FALSE
		if(new_master && new_master != thealert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [thealert.master]")

			clear_alert(category)
			return .()
		else if(thealert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == thealert.severity)
			if(thealert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return FALSE
	else
		thealert = new type()
		thealert.override_alerts = override
		if(override)
			thealert.timeout = null
	thealert.owner = src

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		thealert.overlays += new_master
		new_master.layer = old_layer
		new_master.plane = old_plane
		thealert.icon_state = "template" // We'll set the icon to the client's ui pref in reorganize_alerts()
		thealert.master = new_master
	else
		thealert.icon_state = "[initial(thealert.icon_state)][severity]"
		thealert.severity = severity

	alerts[category] = thealert
	if(client && hud_used)
		hud_used.reorganize_alerts()
	thealert.transform = matrix(32, 6, MATRIX_TRANSLATE)
	animate(thealert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	if(thealert.timeout)
		addtimer(CALLBACK(src, PROC_REF(alert_timeout), thealert, category), thealert.timeout)
		thealert.timeout = world.time + thealert.timeout - world.tick_lag
	return thealert

/mob/proc/alert_timeout(atom/movable/screen/alert/alert, category)
	if(alert.timeout && alerts[category] == alert && world.time >= alert.timeout)
		clear_alert(category)

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/atom/movable/screen/alert/alert = alerts[category]
	if(!alert)
		return FALSE
	if(alert.override_alerts && !clear_override)
		return FALSE

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.remove_from_screen(alert)
	qdel(alert)

/atom/movable/screen/alert
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "default"
	name = "Alert"
	desc = "Something seems to have gone wrong with this alert, so report this bug please"
	mouse_opacity = MOUSE_OPACITY_ICON
	/// If set to a number, this alert will clear itself after that many deciseconds
	var/timeout = 0
	var/severity = 0
	var/alerttooltipstyle = ""
	/// If it is overriding other alerts of the same type
	var/override_alerts = FALSE
	/// Alert owner
	var/mob/owner

	/// Boolean. If TRUE, the Click() proc will attempt to Click() on the master first if there is a master.
	var/click_master = TRUE

/atom/movable/screen/alert/MouseEntered(location,control,params)
	. = ..()
	if(!QDELETED(src))
		openToolTip(usr, src, params, title = name, content = desc, theme = alerttooltipstyle)

/atom/movable/screen/alert/MouseExited(location, control, params)
	. = ..()
	closeToolTip(usr)

/atom/movable/screen/alert/notify_action
	name = "Notification"
	desc = "A new notification. You can enter it."
	icon_state = "template"
	timeout = 15 SECONDS
	var/atom/target = null
	var/action = NOTIFY_JUMP

/atom/movable/screen/alert/notify_action/Click()
	var/mob/dead/observer/ghost_user = usr
	if(!istype(ghost_user) || usr != owner)
		return
	if(!ghost_user.client)
		return
	if(!target)
		return
	switch(action)
		if(NOTIFY_ATTACK)
			target.attack_ghost(ghost_user)
		if(NOTIFY_JUMP)
			var/turf/gotten_turf = get_turf(target)
			if(gotten_turf)
				ghost_user.forceMove(gotten_turf)
		if(NOTIFY_ORBIT)
			ghost_user.do_observe(target)
		if(NOTIFY_JOIN_XENO)
			ghost_user.join_as_alien()
		if(NOTIFY_USCM_TACMAP)
			GLOB.uscm_tacmap_status.tgui_interact(ghost_user)
		if(NOTIFY_XENO_TACMAP)
			GLOB.xeno_tacmap_status.tgui_interact(ghost_user)

/atom/movable/screen/alert/buckled
	name = "Buckled"
	desc = "You've been buckled to something. Click the alert to unbuckle unless you're handcuffed."
	icon_state = ALERT_BUCKLED

/atom/movable/screen/alert/restrained/handcuffed
	name = "Handcuffed"
	desc = "You're handcuffed and can't act. If anyone drags you, you won't be able to move. Click the alert to free yourself."
	click_master = FALSE

/atom/movable/screen/alert/restrained/legcuffed
	name = "Legcuffed"
	desc = "You're legcuffed, which slows you down considerably. Click the alert to free yourself."
	click_master = FALSE

/atom/movable/screen/alert/restrained/clicked()
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner

	if(!living_owner.can_resist())
		return

//	living_owner.changeNext_move(CLICK_CD_RESIST) // handled in resist proc
	if((living_owner.mobility_flags & MOBILITY_MOVE) && (living_owner.last_special <= world.time))
		return living_owner.resist_restraints()

/atom/movable/screen/alert/buckled/clicked()
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner

	if(!living_owner.can_resist())
		return
//	living_owner.changeNext_move(CLICK_CD_RESIST) // handled in resist proc
	if(living_owner.last_special <= world.time)
		return living_owner.resist_buckle()

/atom/movable/screen/alert/clicked(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	if(usr != owner)
		return FALSE
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK)) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr, SPAN_BOLDNOTICE("[name]</span> - <span class='info'>[desc]"))
		return FALSE
	if(master && click_master)
		return usr.client.Click(master, location, control, params)

	return TRUE

/atom/movable/screen/alert/Destroy()
	. = ..()
	severity = 0
	master = null
	owner = null
	screen_loc = ""
