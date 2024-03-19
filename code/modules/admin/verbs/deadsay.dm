/client/proc/dsay(msg as text)
	set category = "Admin.Events"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = TRUE
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
	log_admin("DEAD: [key_name(src)] : [msg]")

	if (!msg)
		return

	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[stafftype] ([src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"

	show_to_deadsay(rendered)

/client/proc/get_dead_say()
	var/msg = input(src, null, "dsay \"text\"") as text|null

	if (isnull(msg))
		return

	dsay(msg)

///Dsay but larger
/client/proc/dooc(msg as text)
	set category = "Admin.Events"
	set name = "Dooc"
	set hidden = TRUE
	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, SPAN_DANGER("Only administrators may use this command."))
		return
	if(!mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send DOOC messages (muted)."))
		return

	if(!(prefs.toggles_chat & CHAT_DEAD))
		to_chat(src, SPAN_DANGER("You have deadchat muted."))
		return

	if (handle_spam_prevention(msg, MUTE_DEADCHAT))
		return

	var/stafftype = null

	stafftype = "[admin_holder.rank]"

	msg = strip_html(msg)
	log_admin("DEAD: [key_name(src)] : [msg]")

	if (!msg)
		return

	var/rendered = "<span class='dooc'><span class='prefix'>DEAD:</span> <span class='name'>[stafftype] ([src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"

	show_to_deadsay(rendered)

/client/proc/show_to_deadsay(message)
	for (var/mob/mob in GLOB.observer_list)
		if (istype(mob, /mob/new_player))
			continue

		if(mob.client && mob.client.admin_holder && (mob.client.admin_holder.rights & R_MOD) && mob.client.prefs && (mob.client.prefs.toggles_chat & CHAT_DEAD)) // show the message to admins who have deadchat toggled on
			mob.show_message(message, SHOW_MESSAGE_AUDIBLE)

		else if((mob.stat == DEAD || isobserver(mob)) && mob && mob.client && mob.client.prefs && (mob.client.prefs.toggles_chat & CHAT_DEAD)) // show the message to regular ghosts who have deadchat toggled on
			mob.show_message(message, SHOW_MESSAGE_AUDIBLE)
