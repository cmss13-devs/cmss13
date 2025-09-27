/client/proc/screen_alert_menu()
	set name = "Send Screen Alert"
	set category = "Game Master.Extras"

	if(!check_rights(R_ADMIN))
		return
	var/icon_choice
	var/icon_choice_state
	var/selectable_factions = list(FACTION_MARINE, FACTION_UPP, FACTION_WY, FACTION_CLF, FACTION_FREELANCER, FACTION_TWE)
	var/selectable_icons = list(
		"marine",
		"marine_2",
		"requisition",
		"requisition_2",
		"overwatch",
		"overwatch_2",
		"overwatch_3",
		"spacesuit",
		"robot",
		"pilot",
		"pilot_2",
		"beret",
		"beret_2",
		"trooper",
		"trooper_2",
		"scientist",
		"messiah",
		"militia",
		"guy",
		"agent",
		"operator",
		"vip",
		"woman_fleet",
		"pmc_bald",
		)
	var/portrait_color
	var/name
	var/faction_to_send = tgui_input_list(src, "Choose what faction this will be sent to, leave blank to send to everyone.", "Faction Type", selectable_factions)
	var/alert_type = tgui_input_list(src, "Choose what type of screen alert you would like to send out.", "Alert Type", list("Standard","Portrait"))
	if(!alert_type)
		return
	if(alert_type == "Portrait")
		icon_choice = tgui_input_list(src, "Upload Icon? (64x64 for best result)", "Icon", list("Yes","No"))
		if(icon_choice == "Yes")
			icon_choice = input(usr, "Choose an icon", "Upload Icon") as null|file
			icon_choice_state = tgui_input_text(src, "Portrait icon state, leave blank for unknown.", "Icon state")
		else
			icon_choice = 'icons/ui_icons/screen_alert_images.dmi'
			icon_choice_state = tgui_input_list(src, "Portrait icon state.", "Icon state", selectable_icons)
			portrait_color = tgui_input_list(src, "Portrait color, leave blank for default.", "Icon state", list("red", "green", "blue"))
			if(!portrait_color)
				portrait_color = "green"
			icon_choice_state = icon_choice_state + "_[portrait_color]"
		if(!icon_choice_state)
			icon_choice_state = "unknown"
	var/text = tgui_input_text(src, "Enter the body text for the screen alert.", title = "Announcement Body", multiline = TRUE, encode = FALSE)
	if(!text)
		return
	if(alert_type == "Portrait")
		name = tgui_input_text(src, "Enter the name to be put inside the portrait.", title = "Name")
	var/title = tgui_input_text(src, "Enter the title of the screen alert. Leave blank for the default title.", title = "Announcement Title")
	if(!title)
		title = COMMAND_ANNOUNCE
	var/list/alert_receivers = list()
	for(var/mob/living/carbon/human/human as anything in GLOB.alive_human_list)
		if(!faction_to_send)
			alert_receivers += human
		else if(faction_to_send == human.faction)
			alert_receivers += human
	alert_receivers += GLOB.observer_list
	for(var/mob/mob_receiver in alert_receivers)
		if(alert_type == "Standard")
			mob_receiver.play_screen_text("<span class='langchat' style=font-size:16pt;text-align:center valign='top'><u>[uppertext(title)]</u></span><br>" + text, /atom/movable/screen/text/screen_text/command_order)
		else
			mob_receiver.play_screen_text("<span class='langchat' style=font-size:24pt;text-align:left valign='top'><u>[uppertext(title)]</u></span><br>" + text, new /atom/movable/screen/text/screen_text/potrait(null, null, name, icon_choice, icon_choice_state))
	message_admins("[key_name_admin(src)] has made an admin screen alert.")
	log_admin("[key_name_admin(src)] made an admin screen alert: [text]")
