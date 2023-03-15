/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	msg = strip_html(msg)
	if(!msg) return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, SPAN_DANGER("You cannot pray (muted)."))
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/liaison = 0
	if(job == "Corporate Liaison")
		liaison = 1

	if(liaison)
		msg = SPAN_NOTICE("<b><font color=purple>LIAISON: </font>[key_name(src, 1)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[src]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminmoreinfo;extra=\ref[src]'>?</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=\ref[src]'>SM</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[src]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminspawncookie=\ref[src]'>SC</a>):</b> [msg]")
	else
		msg = SPAN_NOTICE("<b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ahelp=mark=\ref[src]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminmoreinfo;extra=\ref[src]'>?</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=\ref[src]'>SM</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[src]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminspawncookie=\ref[src]'>SC</a>):</b> [msg]")
	log_admin(msg)
	for(var/client/C in GLOB.admins)
		if(AHOLD_IS_MOD(C.admin_holder) && C.prefs.toggles_chat & CHAT_PRAYER)
			to_chat(C, msg)
	if(liaison)
		to_chat(usr, "Your corporate overlords at Weyland-Yutani have received your message.")
	else
		to_chat(usr, "Your prayers have been received by the gods.")

/proc/high_command_announce(text , mob/Sender , iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "<b>[SPAN_NOTICE("<font color=orange>USCM[iamessage ?  "IA" : ""]:</font>")][key_name(Sender, 1)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccmark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	log_admin(msg)
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			to_chat(C, msg)
			C << 'sound/effects/sos-morse-code.ogg'
