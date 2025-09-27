#define MAX_COMMAND_MESSAGE_LEN 120

/atom/movable/screen/text/screen_text/command_order
	maptext_height = 64
	maptext_width = 400
	maptext_x = 0
	maptext_y = 0
	screen_loc = "LEFT,TOP-3"

	letters_per_update = 2
	fade_out_delay = 6 SECONDS
	style_open = "<span class='langchat' style=font-size:24pt;text-align:center valign='top'>"
	style_close = "</span>"

/atom/movable/screen/text/screen_text/command_order/yautja
	play_delay = 0.3
	fade_out_delay = 10 SECONDS
	fade_out_time = 3 SECONDS

/atom/movable/screen/text/screen_text/command_order/automated
	fade_out_delay = 3 SECONDS
	style_open = "<span class='langchat' style=font-size:20pt;text-align:center valign='top'>"

/datum/action/innate/message_squad
	name = "Send Order"
	action_icon_state = "screen_order_marine"

/datum/action/innate/message_squad/can_use_action()
	. = ..()
	if(!.)
		return
	if(owner.stat != CONSCIOUS)
		return FALSE
	if(TIMER_COOLDOWN_CHECK(owner, COOLDOWN_HUD_ORDER))
		to_chat(owner, SPAN_WARNING("You have [S_TIMER_COOLDOWN_TIMELEFT(owner, COOLDOWN_HUD_ORDER)] seconds left before you can send a HUD message!"))
		return FALSE
	if(!(HAS_TRAIT(owner, TRAIT_LEADERSHIP)))
		return FALSE

GLOBAL_LIST_INIT(ROLES_GLOBAL_FACTION_MESSAGE_EXCEPTION, list(JOB_WO_CO, JOB_WO_XO, JOB_CO, JOB_XO, JOB_SYNTH))

/datum/action/innate/message_squad/action_activate()
	. = ..()
	if(!can_use_action())
		return
	var/mob/living/carbon/human/human_owner = owner
	//if(istype(human_owner.wear_l_ear, /obj/item/device/radio/headset) || istype(human_owner.wear_r_ear, /obj/item/device/radio/headset))
	//	to_chat(human_owner, SPAN_NOTICE("You need a headset to send a HUD message!"))
	update_button_icon()
	var/override_color
	var/list/alert_receivers = list()
	var/sound_alert	= 'sound/effects/radiostatic.ogg'
	var/announcement_title

	if(human_owner.assigned_squad)
		if(human_owner.assigned_fireteam)
			var/list/current_squad = human_owner.assigned_squad.marines_list
			for(var/mob/living/carbon/human/alerted in current_squad)
				if(alerted.assigned_fireteam == human_owner.assigned_fireteam)
					alert_receivers += alerted
			announcement_title = "[human_owner.assigned_fireteam] Announcement"
		else
			alert_receivers = human_owner.assigned_squad.marines_list
			announcement_title = "Squad [human_owner.assigned_squad.name] Announcement"
			override_color = human_owner.assigned_squad.minimap_color
		sound_alert = 'sound/misc/notice2.ogg'
	else
		var/list/squads_being_overwatched_by_me = list()
		for(var/datum/squad/marine/overwatched_squad in GLOB.RoleAuthority.squads)
			if(overwatched_squad.overwatch_officer == human_owner)
				squads_being_overwatched_by_me.Add(overwatched_squad.name)
		if(human_owner.job in GLOB.ROLES_GLOBAL_FACTION_MESSAGE_EXCEPTION)
			squads_being_overwatched_by_me.Add(human_owner.faction)
		if(!squads_being_overwatched_by_me.len)
			return
		else
			var/choice
			if(squads_being_overwatched_by_me.len == 1)
				choice = squads_being_overwatched_by_me[1]
			else
				choice = tgui_input_list(human_owner, "Send a HUD message to a squad or globally to your faction?.", "Alert Type", squads_being_overwatched_by_me)
			if(choice)
				if(choice == human_owner.faction)
					for(var/mob/living/carbon/human/alerted in GLOB.human_mob_list)
						if(alerted.faction == human_owner.faction)
							alert_receivers += alerted
				else
					for(var/datum/squad/marine/alerted_squad in GLOB.RoleAuthority.squads)
						if(choice == alerted_squad.name)
							alert_receivers += alerted_squad.marines_list
							alert_receivers += human_owner
							override_color = alerted_squad.minimap_color
			else
				return
		sound_alert = 'sound/effects/sos-morse-code.ogg'
		announcement_title = "[human_owner.job]'s Announcement"
	var/text = tgui_input_text(human_owner, "Maximum message length [MAX_COMMAND_MESSAGE_LEN]", "Send message to squad",  max_length = MAX_COMMAND_MESSAGE_LEN, multiline = TRUE)
	if(!text)
		return
	log_game("[key_name(human_owner)] has broadcasted the hud message [text] at [AREACOORD(human_owner)]")
	TIMER_COOLDOWN_START(owner, COOLDOWN_HUD_ORDER, 30 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(update_button_icon)), 30 SECONDS + 1)
	alert_receivers += GLOB.observer_list

	//if(GLOB.radio_communication_clarity < 100)
	//	text = stars(text, GLOB.radio_communication_clarity)
	for(var/mob/mob_receiver in alert_receivers)
		playsound_client(mob_receiver.client, sound_alert, 35, channel = CHANNEL_ANNOUNCEMENTS)
		mob_receiver.play_screen_text("<span class='langchat' style=font-size:24pt;text-align:left valign='top'><u>[uppertext(announcement_title)]:</u></span><br>" + text, new /atom/movable/screen/text/screen_text/picture/potrait_custom_mugshot(null, null, owner), override_color)

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
