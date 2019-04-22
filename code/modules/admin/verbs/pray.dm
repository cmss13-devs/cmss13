/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, "<span class='danger'>You cannot pray (muted).</span>")
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/liaison = 0
	if(src.mind)
		if(src.mind.assigned_role == "Corporate Liaison")
			liaison = 1

	if(liaison)
		msg = SPAN_NOTICE("<b><font color=purple>LIAISON: </font>[key_name(src, 1)] (<A HREF='?_src_=admin_holder;ccmark=\ref[src]'>Mark</A>) (<A HREF='?_src_=admin_holder;adminmoreinfo=\ref[src]'>?</A>) (<A HREF='?_src_=admin_holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=admin_holder;subtlemessage=\ref[src]'>SM</A>) (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[src]'>JMP</A>) (<A HREF='?_src_=admin_holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=admin_holder;adminspawncookie=\ref[src]'>SC</a>):</b> [msg]")
	else
		msg = SPAN_NOTICE("<b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A HREF='?_src_=admin_holder;mark=\ref[src]'>Mark</A>) (<A HREF='?_src_=admin_holder;adminmoreinfo=\ref[src]'>?</A>) (<A HREF='?_src_=admin_holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=admin_holder;subtlemessage=\ref[src]'>SM</A>) (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[src]'>JMP</A>) (<A HREF='?_src_=admin_holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=admin_holder;adminspawncookie=\ref[src]'>SC</a>):</b> [msg]")
	log_admin(msg)
	for(var/client/C in admins)
		if(C.prefs.toggles_chat & CHAT_PRAYER)
			C << msg
	if(liaison)
		to_chat(usr, "Your corporate overlords at Weyland-Yutani have received your message.")
	else
		to_chat(usr, "Your prayers have been received by the gods.")

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/Centcomm_announce(var/text , var/mob/Sender , var/iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "<span class='notice'><b><font color=orange>USCM[iamessage ?  "IA" : ""]:</span></font>[key_name(Sender, 1)] (<A HREF='?_src_=admin_holder;ccmark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=admin_holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=admin_holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=admin_holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	for(var/client/C in admins)
		log_admin(msg)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			C << msg
			C << 'sound/effects/sos-morse-code.ogg'

/proc/Syndicate_announce(var/text , var/mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = SPAN_NOTICE("<b><font color=crimson>SYNDICATE:</font>[key_name(Sender, 1)] (<A HREF='?_src_=admin_holder;mark=\ref[Sender]'>Mark</A>) (<A HREF='?_src_=admin_holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=admin_holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=admin_holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=admin_holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=admin_holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]")
	log_admin(msg)
	for(var/client/C in admins)
		if(R_ADMIN & C.admin_holder.rights)
			C << msg
