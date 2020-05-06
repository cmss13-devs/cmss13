/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	if(!src.mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send DSAY messages (muted)."))
		return

	if(!(prefs.toggles_chat & CHAT_DEAD))
		to_chat(src, SPAN_DANGER("You have deadchat muted."))
		return

	if (src.handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	var/stafftype = null

	stafftype = "[admin_holder.rank]"

	msg = strip_html(msg)
	log_admin("[key_name(src)] : [msg]")

	if (!msg)
		return

	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[stafftype]([src.admin_holder.fakekey ? pick("BADMIN", "hornigranny", "TLF", "scaredforshadows", "KSI", "Silnazi", "HerpEs", "BJ69", "SpoofedEdd", "Uhangay", "Wario90900", "Regarity", "MissPhareon", "LastFish", "unMportant", "Deurpyn", "Fatbeaver") : src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"

	for (var/mob/M in player_list)
		if (istype(M, /mob/new_player))
			continue

		if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD) && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD)) // show the message to admins who have deadchat toggled on
			M.show_message(rendered, 2)

		else if((M.stat == DEAD || isobserver(M)) && M && M.client && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD)) // show the message to regular ghosts who have deadchat toggled on
			M.show_message(rendered, 2)

	 
