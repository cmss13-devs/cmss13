/datum/admins/proc/topic_ahelps(var/href_list)
	switch(href_list["ahelp"])
		if("mark")
			var/mob/ref_person = locate(href_list["extra"])
			if(!istype(ref_person))
				to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
				return
			if(ref_person && ref_person.adminhelp_marked)
				to_chat(usr, "<b>This Adminhelp is already being handled.</b>")
				usr << sound('sound/effects/adminhelp-error.ogg')
				return

			message_staff("[usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)] and is preparing to respond...", 1)
			STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)].<br>")
			STUI.processing |= STUI_LOG_STAFF_CHAT
			var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has marked your request and is preparing to respond...</b>")

			to_chat(ref_person, msgplayer)

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			viewUnheardAhelps() //This SHOULD refresh the page

			ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
			ref_person.adminhelp_marked_admin = usr.key //To prevent others autoresponding
			spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
				if(ref_person)	ref_person.adminhelp_marked = 0

		if("noresponse")
			var/mob/ref_person = locate(href_list["extra"])
			if(!istype(ref_person))
				to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
				return
			if(ref_person && ref_person.adminhelp_marked && ref_person.adminhelp_marked_admin != usr.key)
				to_chat(usr, "<b>This Adminhelp is already being handled.</b>")
				usr << sound('sound/effects/adminhelp-error.ogg')
				return

			message_staff("[usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)]. The player has been notified that their issue 'is being handled, it's fixed, or it's nonsensical'.", 1)
			STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)].<br>")
			STUI.processing |= STUI_LOG_STAFF_CHAT
			var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has received your Adminhelp and marked it as 'No response necessary'. Either your Adminhelp is being handled, it's fixed, or it's nonsensical.</font></b>")

			to_chat(ref_person, msgplayer) //send a message to the player when the Admin clicks "Mark"
			ref_person << sound('sound/effects/adminhelp-error.ogg')

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			viewUnheardAhelps() //This SHOULD refresh the page

			ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
			spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
				if(ref_person)	ref_person.adminhelp_marked = 0

		if("warning")
			var/mob/ref_person = locate(href_list["extra"])
			if(!istype(ref_person))
				to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
				return
			if(ref_person && ref_person.adminhelp_marked && ref_person.adminhelp_marked_admin != usr.key)
				to_chat(usr, "<b>This Adminhelp is already being handled.</b>")
				usr << sound('sound/effects/adminhelp-error.ogg')
				return

			message_staff("[usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)]. The player has been warned for abusing the Adminhelp system.", 1)
			STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)].<br>")
			STUI.processing |= STUI_LOG_STAFF_CHAT
			var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has given you a <font color=red>warning</font>. Adminhelps are for serious inquiries only. Please do not abuse this system.</b>")

			to_chat(ref_person, msgplayer) //send a message to the player when the Admin clicks "Mark"
			ref_person << sound('sound/effects/adminhelp-error.ogg')

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			viewUnheardAhelps() //This SHOULD refresh the page

			ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
			spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
				if(ref_person)	ref_person.adminhelp_marked = 0

		if("autoresponse") // new verb on the Ahelp.  Will tell the person their message was received, and they probably won't get a response
			topic_autoresponses(href_list)

		if("defermhelp")
			var/client/C = locate(href_list["extra"])
			if(!C)
				return

			if(alert("Are you sure you want to turn this ahelp into an mhelp?","Defer","Yes","Cancel") == "Cancel")
				return

			if(C.current_mhelp && C.current_mhelp.open)
				to_chat(usr, SPAN_NOTICE("They already have a mentorhelp thread open!"))
				return

			to_chat(C.mob, SPAN_NOTICE("<b>NOTICE:</b> <font color=red>[usr.key]</font> has turned your adminhelp into a mentorhelp thread."))
			for(var/client/X in admins)
				if((R_ADMIN|R_MOD) & X.admin_holder.rights)
					to_chat(X, SPAN_NOTICE("<b>NOTICE:</b> <font color=red>[usr.key]</font> has turned <font color=red>[C.key]</font>'s adminhelp into a mentorhelp thread."))
			log_mhelp("[usr.key] turned [C.key]'s adminhelp into a mentorhelp thread")

			var/msg = ahelp_msgs[href_list["extra"]]
			ahelp_msgs.Remove(C)
			C.current_mhelp = new(C)
			if(msg)
				C.current_mhelp.send_message(C, msg)
			else
				C.current_mhelp.input_message(C)

			unansweredAhelps.Remove(C.computer_id) //It has been answered so take it off of the unanswered list
			viewUnheardAhelps() //This SHOULD refresh the page

		if("adminmoreinfo")
			var/mob/M = locate(href_list["extra"])
			if(!ismob(M))
				to_chat(usr, "This can only be used on instances of type /mob")
				return

			var/location_description = ""
			var/special_role_description = ""
			var/health_description = ""
			var/gender_description = ""
			var/turf/T = get_turf(M)

			//Location
			if(isturf(T))
				if(isarea(T.loc))
					location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
				else
					location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

			//Health
			if(isliving(M))
				var/mob/living/L = M
				var/status
				switch(M.stat)
					if(0) 
						status = "Alive"
					if(1) 
						status = "<font color='orange'><b>Unconscious</b></font>"
					if(2) 
						status = "<font color='red'><b>Dead</b></font>"
				health_description = "Status = [status]"
				health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getBrainLoss()]"
			else
				health_description = "This mob type has no health to speak of."

			//Gener
			switch(M.gender)
				if(MALE,FEMALE)	
					gender_description = "[M.gender]"
				else			
					gender_description = "<font color='red'><b>[M.gender]</b></font>"

			to_chat(owner, "<b>Info about [M.name]:</b> ")
			to_chat(owner, "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]")
			to_chat(owner, "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;")
			to_chat(owner, "Location = [location_description];")
			to_chat(owner, "[special_role_description]")
			to_chat(owner, "(<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>) (<A HREF='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[M]'>VV</A>) (<A HREF='?src=\ref[src];subtlemessage=\ref[M]'>SM</A>) (<A HREF='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</A>)")
		if("adminplayeropts")
			var/mob/M = locate(href_list["extra"])
			show_player_panel(M)