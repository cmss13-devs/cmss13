/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("ADMIN : [key_name(src)] : [msg]")
	STUI.staff.Add("\[[time_stamp()]] <font color='#800080'>ADMIN: [key_name(src)] : [msg]</font><br>")
	STUI.processing |= 3

	var/color = "adminsay"
	if(ishost(usr))
		color = "headminsay"

	if(check_rights(R_ADMIN,0))
		msg = "<span class='[color]'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=admin_holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
		for(var/client/C in admins)
			if(R_ADMIN & C.admin_holder.rights)
				to_chat(C, msg)

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("MOD: [key_name(src)] : [msg]")
	STUI.staff.Add("\[[time_stamp()]] <font color='#b82e00'>MOD: [key_name(src)] : [msg]</font><br>")
	STUI.processing |= 3

	if (!msg)
		return
	var/color = "mod"
	if (check_rights(R_ADMIN,0))
		color = "adminmod"

	var/channel = "MOD:"
	channel = "[admin_holder.rank]:"
	for(var/client/C in admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			to_chat(C, "<span class='[color]'><span class='prefix'>[channel]</span> <EM>[key_name(src,1)]</EM> (<A HREF='?src=\ref[C.admin_holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>")
