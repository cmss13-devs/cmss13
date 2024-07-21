/client/proc/dsay(msg as text)
	set category = "Admin.Events"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = TRUE
	if(!check_rights(R_MOD))
		return
	if(!mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send DSAY messages (muted)."))
		return

	if(!(prefs.toggles_chat & CHAT_DEAD))
		to_chat(src, SPAN_DANGER("You have deadchat muted."))
		return

	if(handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	var/stafftype = null

	stafftype = "[player_data?.admin_holder.admin_rank.rank]"

	msg = strip_html(msg)
	log_admin("DEAD: [key_name(src)] : [msg]")

	if (!msg)
		return

	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[stafftype]([src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"

	for (var/mob/M in GLOB.player_list)
		if (istype(M, /mob/new_player))
			continue

		if(M.client && check_client_rights(M.client, R_MOD, FALSE) && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD)) // show the message to admins who have deadchat toggled on
			M.show_message(rendered, SHOW_MESSAGE_AUDIBLE)

		else if((M.stat == DEAD || isobserver(M)) && M && M.client && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD)) // show the message to regular ghosts who have deadchat toggled on
			M.show_message(rendered, SHOW_MESSAGE_AUDIBLE)

/client/proc/get_dead_say()
	var/msg = input(src, null, "dsay \"text\"") as text|null

	if (isnull(msg))
		return

	dsay(msg)
