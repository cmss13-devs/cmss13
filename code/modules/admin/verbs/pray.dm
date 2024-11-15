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

	var/prefix = SPAN_PURPLE("PRAY: ")
	var/receipt = "Your prayers have been received by the gods."
	if(job == JOB_CORPORATE_LIAISON)
		prefix = SPAN_PURPLE("LIAISON: ")
		receipt = "Your corporate overlords at Weyland-Yutani have received your message."

	msg = SPAN_BIGNOTICE("[prefix][key_name(src, 1)] [CC_MARK(src)] [ADMIN_PP(src)] [ADMIN_VV(src)] [ADMIN_SM(src)] [ADMIN_JMP_USER(src)] [ADMIN_SC(src)]: [msg]")
	log_admin(msg)
	for(var/client/admin in GLOB.admins)
		if(AHOLD_IS_MOD(admin.admin_holder))
			to_chat(admin, SPAN_STAFF_IC(msg))
			if(admin.prefs.toggles_sound & SOUND_ARES_MESSAGE)
				admin << 'sound/machines/terminal_alert.ogg'

	to_chat(usr, receipt)

/proc/high_command_announce(text , mob/Sender , iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "<b><big>[SPAN_STAFF_IC("<font color=orange>USCM[iamessage ?  "IA" : ""]:</font>")][key_name(Sender, 1)] [CC_MARK(Sender)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] [ADMIN_JMP_USER(Sender)] [CC_REPLY(Sender)]: [msg]</big></b>"
	log_admin(msg)
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			to_chat(C, msg)
			C << 'sound/effects/sos-morse-code.ogg'
