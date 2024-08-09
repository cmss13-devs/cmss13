/client/proc/toggle_newplayer_ghost_hud()
	set name = "Toggle Markers (Ghost)"
	set category = "Admin.Mentor"
	set desc = "Toggles observer pref for mentor markers."

	if(!admin_holder || !(admin_holder.rights & R_MENTOR))
		to_chat(src, "Only mentors may use this HUD!")
		return FALSE

	var/hud_choice = "New Player Markers"
	prefs.observer_huds[hud_choice] = !prefs.observer_huds[hud_choice]
	prefs.save_preferences()

	to_chat(src, SPAN_BOLDNOTICE("You toggled [hud_choice] to be [prefs.observer_huds[hud_choice] ? "ON" : "OFF"] by default when you are observer."))

	if(!isobserver(usr))
		return
	var/mob/dead/observer/observer_user = usr
	var/datum/mob_hud/the_hud
	the_hud = GLOB.huds[MOB_HUD_NEW_PLAYER]

	observer_user.HUD_toggled[hud_choice] = prefs.observer_huds[hud_choice]
	if(observer_user.HUD_toggled[hud_choice])
		the_hud.add_hud_to(observer_user, observer_user)
	else
		the_hud.remove_hud_from(observer_user, observer_user)

/client/proc/toggle_newplayer_ic_hud(sea_forced = FALSE)
	set category = "Admin.Mentor"
	set name = "Toggle Markers (IC)"
	set desc = "Toggles new player HUD while IC."

	if(!admin_holder || !(admin_holder.rights & R_MENTOR))
		if(!sea_forced)
			to_chat(src, "Only mentors may use this HUD!")
		return FALSE

	var/mob/living/carbon/human/mentor = mob
	if(!ishuman(mentor))
		to_chat(src, SPAN_WARNING("You cannot use this power as a non-human!"))
		return FALSE
	if(!mentor.looc_overhead)
		to_chat(src, SPAN_WARNING("You are not in a mentor role! (Overhead LOOC is disabled!)"))
		return FALSE

	var/datum/mob_hud/the_hud
	var/chosen_HUD = 3
	the_hud = GLOB.huds[MOB_HUD_NEW_PLAYER]

	if(mentor.inherent_huds_toggled[chosen_HUD])
		mentor.inherent_huds_toggled[chosen_HUD] = FALSE
		the_hud.remove_hud_from(mentor, mentor)
		to_chat(mentor, SPAN_INFO("<B>New Player Markers Disabled</B>"))
	else
		mentor.inherent_huds_toggled[chosen_HUD] = TRUE
		the_hud.add_hud_to(mentor, mentor)
		to_chat(mentor, SPAN_INFO("<B>New Player Markers Enabled</B>"))
	return TRUE
