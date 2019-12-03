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
			log_admin("[usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)].", 1)
			STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)].<br>")
			STUI.processing |= 3
			var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has marked your request and is preparing to respond...</b>")

			to_chat(ref_person, msgplayer)

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			src.viewUnheardAhelps() //This SHOULD refresh the page

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
			log_admin("[usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)].", 1)
			STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)].<br>")
			STUI.processing |= 3
			var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has received your Adminhelp and marked it as 'No response necessary'. Either your Adminhelp is being handled, it's fixed, or it's nonsensical.</font></b>")

			to_chat(ref_person, msgplayer) //send a message to the player when the Admin clicks "Mark"
			ref_person << sound('sound/effects/adminhelp-error.ogg')

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			src.viewUnheardAhelps() //This SHOULD refresh the page

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
			log_admin("[usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)].", 1)
			STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)].<br>")
			STUI.processing |= 3
			var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has given you a <font color=red>warning</font>. Adminhelps are for serious inquiries only. Please do not abuse this system.</b>")

			to_chat(ref_person, msgplayer) //send a message to the player when the Admin clicks "Mark"
			ref_person << sound('sound/effects/adminhelp-error.ogg')

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			src.viewUnheardAhelps() //This SHOULD refresh the page

			ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
			spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
				if(ref_person)	ref_person.adminhelp_marked = 0

		if("autoresponse") // new verb on the Ahelp.  Will tell the person their message was received, and they probably won't get a response
			var/mob/ref_person = locate(href_list["extra"])
			if(!istype(ref_person))
				to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
				return
			if(ref_person && ref_person.adminhelp_marked && ref_person.adminhelp_marked_admin != usr.key)
				to_chat(usr, "<b>This Adminhelp is already being handled by another staff member. You can proceed but it's not recommended.</b>")
				usr << sound('sound/effects/adminhelp-error.ogg')
				if(alert(usr, "Are you sure you want to autoreply to this ahelp that is handled by another staff member?", "Confirmation", "Yes", "No") != "Yes")
					return

			if(ref_person && !ref_person.adminhelp_marked)
				to_chat(usr, "<b>This Adminhelp is not marked. You should mark ahelp first before autoresponding.</b>")
				return

			var/choice = input("Which autoresponse option do you want to send to the player?\n\n L - A webpage link.\n A - An answer to a common question.", "Autoresponse", "--CANCEL--") in list ("--CANCEL--", "IC Issue", "Being Handled", "Fixed", "Thanks", "Marine Law","Whitelist Player", "L: Xeno Quickstart Guide", "L: Marine quickstart guide", "L: Current Map", "A: No plasma regen", "A: Devour as Xeno", "J: Job bans", "E: Event in progress", "R: Radios", "B: Binoculars", "D: Joining disabled", "M: Macros", "C: Changelog")

			var/msgplayer
			switch(choice)
				if("IC Issue")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. This issue has been deemed an IC (In-Character) issue, and will not be handled by staff. In case it's relevant, you may wish to ask your <a href='http://cm-ss13.com/wiki/Rank'>Chain Of Command</a> about your issue if you believe <a href='http://cm-ss13.com/wiki/Marine_Law'>Marine Law</a> has been broken.</b>")
				if("Being Handled")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. The issue is already being dealt with.</b>")
				if("Fixed")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. The issue is already fixed.</b>")
				if("Thanks")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>! Have a CM day!</b>")
				if("Marine Law")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. This is a <a href='http://cm-ss13.com/wiki/Marine_Law'>marine law issue</a>. <a href='https://cm-ss13.com/viewforum.php?f=63'>Unless the MP's are breaking procedure in a significant way</a> we will not influence ic events. You do have the right to appeal your sentence and should try to appeal to the Captain first. </b>")
				if("L: Xeno Quickstart Guide")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Your answer can be found on the Xeno Quickstart Guide on our wiki. <a href='http://cm-ss13.com/wiki/Xeno_Quickstart_Guide'>Check it out here.</a></b>")
				if("L: Marine quickstart guide")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Your answer can be found on the Marine Quickstart Guide on our wiki. <a href='http://cm-ss13.com/wiki/Marine_Quickstart_Guide'>Check it out here.</a></b>")
				if("L: Current Map")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. If you need a map to the current game, you can (usually) find them on the front page of our wiki in the 'Maps' section. <a href='http://cm-ss13.com/wiki/Main_Page'>Check it out here.</a> If the map is not listed, it's a new or rare map and the overview hasn't been finished yet.</b>")
				if("A: No plasma regen")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. If you have low/no plasma regen, it's most likely because you are off weeds or are currently using a passive ability, such as the Runner's 'Hide' or emitting a pheromone.</b>")
				if("A: Devour as Xeno")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Devouring is useful to quickly transport incapacitated hosts from one place to another. In order to devour a host as a Xeno, grab the mob (CTRL+Click) and then click on yourself to begin devouring. The host can resist by breaking out of your belly, so make sure your target is incapacitated, or only have them devoured for a short time. To release your target, click 'Regurgitate' on the HUD to throw them back up.</b>")
				if("J: Job bans")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. All job bans, including xeno bans, are permenant until appealed. you can appeal it over on the forums at http://cm-ss13.com/viewforum.php?f=76</b>")
				if("E: Event in progress")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member.</b>")
				if("R: Radios")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Radios have been changed, the prefix for all squad marines is now ; to access your squad radio. Squad Medics have access to the medical channel using :m, Engineers have :e and the (acting) Squad Leader has :v for command.  Examine your radio headset to get a listing of the channels you have access to.</b>")
				if("B: Binoculars")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. To use your binoculars, take them into your hand and activate them by using Z (Hotkey Mode). Ctrl + Click on any open tile to set a laser. To switch between the lasers, Right Click the Binoculars in hand and press toggle mode or Alt + Click them. The Red laser is a CAS marker for pilots to fire upon, it must be held for the Pilot to drop ordinance on it. The green laser is a coordinate marker that will give you a longitude and a latitude to give to your Staff Officer and Requisitions Staff. They will give you access to a devastating Orbital Bombardment or to drop supplies for you and your squad. Your squad engineers can also use the coordinates to drop mortar shells on top of your enemies.</b>")
				if("D: Joining disabled")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. A staff member has disabled joining for new players as the current round is coming to an end, you can observe while it ends and wait for a new round to start.</b>")
				if("M: Macros")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. To set a macro right click the title bar, select Client->Macros. Binding unique-action to a key is useful for pumping shotguns etc; Binding load-from-attachment will activate any scopes etc; Binding resist and give to seperate keys is also handy. For more information on macros, head over to our guide, at: http://cm-ss13.com/wiki/Macros</b>")
				if("C: Changelog")
					msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. The answer to your question can be found in the changelog. Click the changelog button at the top-right of the screen to view it in-game, or visit https://cm-ss13.com/changelog/ to open it in your browser instead.</b>")
				else return
			msgplayer += " <b><i>You may click on the staff member's name to ask more about this response.</i></b>"
			message_staff("[usr.key] is autoresponding to [ref_person] with <font color='#009900'>'[choice]'</font>. They have been shown the following:\n[msgplayer]", 1)
			log_admin("[usr.key] is autoresponding to [ref_person] with <font color='#009900'>'[choice]'</font>.", 1) //No need to log the text we send them.
			STUI.staff.Add("\[[time_stamp()]][usr.key] is autoresponding to [ref_person] with [choice].<br>")
			STUI.processing |= 3
			to_chat(ref_person, msgplayer) //send a message to the player when the Admin clicks "Mark"
			ref_person << sound('sound/effects/adminhelp-reply.ogg')

			unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
			src.viewUnheardAhelps() //This SHOULD refresh the page

			ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
			spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
				if(ref_person)	ref_person.adminhelp_marked = 0

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

			var/msg = ahelp_msgs[C]
			ahelp_msgs.Remove(C)
			C.current_mhelp = new(C)
			if(msg)
				C.current_mhelp.send_message(C, msg)
			else
				C.current_mhelp.input_message(C)

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

			//Job + antagonist
			if(M.mind)
				special_role_description = "Role: <b>[M.mind.assigned_role]</b>; Antagonist: <font color='red'><b>[M.mind.special_role]</b></font>; Has been rev: [(M.mind.has_been_rev)?"Yes":"No"]"
			else
				special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>; Has been rev: <i>Mind datum missing</i>;"

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

			to_chat(src.owner, "<b>Info about [M.name]:</b> ")
			to_chat(src.owner, "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]")
			to_chat(src.owner, "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;")
			to_chat(src.owner, "Location = [location_description];")
			to_chat(src.owner, "[special_role_description]")
			to_chat(src.owner, "(<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>) (<A HREF='?src=\ref[src];ahelp=adminplayeropts;extra=\ref[M]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[M]'>VV</A>) (<A HREF='?src=\ref[src];subtlemessage=\ref[M]'>SM</A>) (<A HREF='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</A>)")
		if("adminplayeropts")
			var/mob/M = locate(href_list["extra"])
			show_player_panel(M)