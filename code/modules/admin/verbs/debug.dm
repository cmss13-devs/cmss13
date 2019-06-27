/client/proc/Debug2()
	set category = "Debug"
	set name = "Debugging Mode"
	if(alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	if(!check_rights(R_DEBUG))	return

	if(Debug2)
		Debug2 = 0
		message_admins("[key_name(src)] toggled debugging off.")
		log_admin("[key_name(src)] toggled debugging off.")
	else
		Debug2 = 1
		message_admins("[key_name(src)] toggled debugging on.")
		log_admin("[key_name(src)] toggled debugging on.")

	feedback_add_details("admin_verb","DG2") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!



/* 21st Sept 2010
Updated by Skie -- Still not perfect but better!
Stuff you can't do:
Call proc /mob/proc/make_dizzy() for some player
Because if you select a player mob as owner it tries to do the proc for
/mob/living/carbon/human/ instead. And that gives a run-time error.
But you can call procs that are of type /mob/living/carbon/human/proc/ for that player.
*/

/client/proc/callproc()
	set category = "Debug"
	set name = "Advanced ProcCall"
	set waitfor = 0

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/target = null
	var/targetselected = 0
	var/lst[] // List reference
	lst = new/list() // Make the list
	var/returnval = null
	var/class = null

	switch(alert("Proc owned by something?",,"Yes","No"))
		if("Yes")
			targetselected = 1
			class = input("Proc owned by...","Owner",null) as null|anything in list("Obj","Mob","Area or Turf","Client")
			switch(class)
				if("Obj")
					target = input("Enter target:","Target",usr) as obj in object_list
				if("Mob")
					target = input("Enter target:","Target",usr) as mob in mob_list
				if("Area or Turf")
					target = input("Enter target:","Target",usr.loc) as area|turf in world
				if("Client")
					var/list/keys = list()
					for(var/client/C)
						keys += C
					target = input("Please, select a player!", "Selection", null, null) as null|anything in keys
				else
					return
		if("No")
			target = null
			targetselected = 0

	var/procname = input("Proc path, eg: /proc/fake_blood","Path:", null) as text|null
	if(!procname)	return

	var/argnum = input("Number of arguments","Number:",0) as num|null
	if(!argnum && (argnum!=0))	return

	lst.len = argnum // Expand to right length
	//TODO: make a list to store whether each argument was initialised as null.
	//Reason: So we can abort the proccall if say, one of our arguments was a mob which no longer exists
	//this will protect us from a fair few errors ~Carn

	var/i
	for(i=1, i<argnum+1, i++) // Lists indexed from 1 forwards in byond

		// Make a list with each index containing one variable, to be given to the proc
		class = input("What kind of variable?","Variable Type") in list("text","num","type","reference","mob reference","icon","file","client","mob's area","CANCEL")
		switch(class)
			if("CANCEL")
				return

			if("text")
				lst[i] = input("Enter new text:","Text",null) as text

			if("num")
				lst[i] = input("Enter new number:","Num",0) as num

			if("type")
				lst[i] = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

			if("reference")
				lst[i] = input("Select reference:","Reference",src) as mob|obj|turf|area in world

			if("mob reference")
				lst[i] = input("Select reference:","Reference",usr) as mob in mob_list

			if("file")
				lst[i] = input("Pick file:","File") as file

			if("icon")
				lst[i] = input("Pick icon:","Icon") as icon

			if("client")
				var/list/keys = list()
				for(var/mob/M in player_list)
					keys += M.client
				lst[i] = input("Please, select a player!", "Selection", null, null) as null|anything in keys

			if("mob's area")
				var/mob/temp = input("Select mob", "Selection", usr) as mob in mob_list
				lst[i] = temp.loc

	if(targetselected)
		if(!target)
			to_chat(usr, "<font color='red'>Error: callproc(): owner of proc no longer exists.</font>")
			return

		var/actual_name = procname
		//Remove the "/proc/" in front of the actual name
		if(findtext(procname, "/proc/"))
			actual_name = replacetext(procname, "/proc/", "")
		else if(findtext(procname, "/proc"))
			actual_name = replacetext(procname, "/proc", "")
		else if(findtext(procname, "proc/"))
			actual_name = replacetext(procname, "proc/", "")
		//Remove Parenthesis if any
		actual_name = replacetext(actual_name, "()", "")

		if(!hascall(target,actual_name))
			to_chat(usr, "<font color='red'>Error: callproc(): target has no such call [procname].</font>")
			return
		log_admin("[key_name(src)] called [target]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")
		returnval = call(target,actual_name)(arglist(lst)) // Pass the lst as an argument list to the proc
	else
		//this currently has no hascall protection. wasn't able to get it working.
		log_admin("[key_name(src)] called [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")
		returnval = call(procname)(arglist(lst)) // Pass the lst as an argument list to the proc

	to_chat(usr, "<font color='blue'>[procname] returned: [returnval ? returnval : "null"]</font>")
	feedback_add_details("admin_verb","APC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!



/client/proc/callatomproc(atom/A)
	set category = "Debug"
	set name = "Atom ProcCall"
	set waitfor = 0

	if(!check_rights(R_DEBUG)) return
	if(config.debugparanoid && !check_rights(R_ADMIN)) return

	var/lst[] // List reference
	lst = new/list() // Make the list
	var/returnval = null
	var/class = null

	var/procname = input("Proc name, eg: attack_hand","Proc:", null) as text|null
	if(!procname)
		return

	if(!hascall(A,procname))
		to_chat(usr, "<font color='red'>Error: callatomproc(): type [A.type] has no proc named [procname].</font>")
		return

	var/argnum = input("Number of arguments","Number:",0) as num|null
	if(!argnum && (argnum!=0))	return

	lst.len = argnum

	var/i
	for(i=1, i<argnum+1, i++) // Lists indexed from 1 forwards in byond

		// Make a list with each index containing one variable, to be given to the proc
		class = input("What kind of variable?","Variable Type") in list("text","num","type","reference","mob reference","icon","file","client","mob's area","CANCEL")
		switch(class)
			if("CANCEL")
				return

			if("text")
				lst[i] = input("Enter new text:","Text",null) as text

			if("num")
				lst[i] = input("Enter new number:","Num",0) as num

			if("type")
				lst[i] = input("Enter type:","Type") in typesof(/obj,/mob,/area,/turf)

			if("reference")
				lst[i] = input("Select reference:","Reference",src) as mob|obj|turf|area in world

			if("mob reference")
				lst[i] = input("Select reference:","Reference",usr) as mob in mob_list

			if("file")
				lst[i] = input("Pick file:","File") as file

			if("icon")
				lst[i] = input("Pick icon:","Icon") as icon

			if("client")
				var/list/keys = list()
				for(var/mob/M in player_list)
					keys += M.client
				lst[i] = input("Please, select a player!", "Selection", null, null) as null|anything in keys

			if("mob's area")
				var/mob/temp = input("Select mob", "Selection", usr) as mob in mob_list
				lst[i] = temp.loc

	log_admin("[key_name(src)] called [A]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"].")
	message_admins(SPAN_NOTICE("[key_name_admin(src)] called [A]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"]."))
	returnval = call(A,procname)(arglist(lst)) // Pass the lst as an argument list to the proc
	to_chat(usr, "<font color='blue'>[procname] returned: [returnval ? returnval : "null"]</font>")
	feedback_add_details("admin_verb","AAPC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!




/client/proc/Cell()
	set category = "Debug"
	set name = "Cell"
	if(!mob)
		return
	var/turf/T = mob.loc

	if (!( istype(T, /turf) ))
		return

	var/list/air_info = T.return_air()

	var/t = SPAN_NOTICE("Coordinates: [T.x],[T.y],[T.z]\n")
	t += SPAN_DANGER("Temperature: [air_info[2]]\n")
	t += SPAN_DANGER("Pressure: [air_info[3]]kPa\n")
	t += SPAN_NOTICE("Gas Type: [air_info[1]]\n")

	usr.show_message(t, 1)
	feedback_add_details("admin_verb","ASL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_robotize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Robot"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Simple Animal"

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(!M)
		alert("That mob doesn't seem to exist, close the panel and try again.")
		return

	if(istype(M, /mob/new_player))
		alert("The mob must not be a new_player.")
		return

	log_admin("[key_name(src)] has animalized [M.key].")
	spawn(10)
		M.Animalize()

/client/proc/cmd_admin_alienize(var/mob/M in mob_list)
	set category = "Fun"
	set name = "Make Alien"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()
			feedback_add_details("admin_verb","MKAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		log_admin("[key_name(usr)] made [key_name(M)] into an alien.")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] made [key_name(M)] into an alien."), 1)
	else
		alert("Invalid mob")

/client/proc/cmd_admin_change_hivenumber()
	set category = "Debug"
	set name = "Change Hivenumber"

	var/mob/living/carbon/Xenomorph/X = input(src,"Select a xeno.", null, null) in living_xeno_list
	if(!istype(X))
		to_chat(usr, "This can only be done to instances of type /mob/living/carbon/Xenomorph")
		return

	cmd_admin_change_their_hivenumber(X)

/client/proc/cmd_admin_change_their_hivenumber(var/mob/living/carbon/Xenomorph/X)
	set category = "Admin"
	set name = "Change Their Hivenumber"

	var/hivenumber_status = X.hivenumber
	var/list/namelist = list("Normal","Corrupted","Alpha","Beta","Zeta")

	var/newhive = input(src,"Select a hive.", null, null) in namelist

	if(!X)
		to_chat(usr, "This xeno no longer exists")
		return
	var/newhivenumber
	switch(newhive)
		if("Normal")
			newhivenumber = XENO_HIVE_NORMAL
		if("Corrupted")
			newhivenumber = XENO_HIVE_CORRUPTED
		if("Alpha")
			newhivenumber = XENO_HIVE_ALPHA
		if("Beta")
			newhivenumber = XENO_HIVE_BETA
		if("Zeta")
			newhivenumber = XENO_HIVE_ZETA
	if(X.hivenumber != hivenumber_status)
		to_chat(usr, "Someone else changed this xeno while you were deciding")
		return

	X.set_hivenumber_and_update(newhivenumber)
	feedback_add_details("admin_verb","CHHN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins(SPAN_NOTICE("[key_name(src)] changed hivenumber of [X] to [X.hivenumber]."), 1)


/client/proc/cmd_admin_change_their_name(var/mob/living/carbon/X)
	set category = "Admin"
	set name = "Change Their Name"

	var/newname = input(usr, "What do you want to name them?", "Name:") as null|text
	if(!newname)
		return

	if(!X)
		to_chat(usr, "This mob no longer exists")
		return

	X.name = newname
	X.real_name = newname
	if(istype(X, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = X
		if(H.wear_id)
			H.wear_id.name = "[H.real_name]'s ID Card"
			H.wear_id.registered_name = "[H.real_name]"
			if(H.wear_id.assignment)
				H.wear_id.name += " ([H.wear_id.assignment])"
	feedback_add_details("admin_verb","CHTN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins(SPAN_NOTICE("[key_name(src)] changed name of [X] to [newname]."), 1)

/client/proc/cmd_debug_toggle_should_check_for_win()
	set category = "Debug"
	set name = "Toggle Round End Checks"

	feedback_add_details("admin_verb","CHCKWIN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(!ticker || !ticker.mode)
		to_chat(usr, "Mode not found?")
	round_should_check_for_win = !round_should_check_for_win
	if (round_should_check_for_win)
		message_admins(SPAN_NOTICE("[key_name(src)] enabled checking for round-end."), 1)
	else
		message_admins(SPAN_NOTICE("[key_name(src)] disabled checking for round-end."), 1)



//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Delete Instance"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /obj/item, /obj/effect, /obj/mecha, /obj/machinery, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/Xenomorph, /mob/living/carbon/human, /mob/dead, /mob/dead/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/chosen_deletion = input(usr, "Type the path of the object you want to delete", "Delete:") as null|text
	if(chosen_deletion)
		chosen_deletion = text2path(chosen_deletion)
		if(ispath(chosen_deletion))
			if(!ispath(/mob) && !ispath(/obj))
				to_chat(usr, SPAN_WARNING("Only works for types of /obj or /mob."))
			else
				var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(chosen_deletion)
				if(hsbitem)
					var/do_delete = 1
					if(hsbitem in blocked)
						if(alert("Are you REALLY sure you wish to delete all instances of [hsbitem]? This will lead to catastrophic results!",,"Yes","No") != "Yes")
							do_delete = 0
					var/del_amt = 0
					if(do_delete)
						for(var/atom/O in world)
							if(istype(O, hsbitem))
								del_amt++
								qdel(O)
						log_admin("[key_name(src)] has deleted all instances of [hsbitem] ([del_amt]).")
						message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem] ([del_amt]).", 0)
		else
			to_chat(usr, SPAN_WARNING("Not a valid type path."))
	feedback_add_details("admin_verb","DELA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Generate Powernets"
	if(alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	makepowernets()
	log_admin("[key_name(src)] has remade the powernet. makepowernets() called.")
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)
	feedback_add_details("admin_verb","MPWN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_debug_tog_aliens()
	set category = "Server"
	set name = "Toggle Aliens"

	aliens_allowed = !aliens_allowed
	log_admin("[key_name(src)] has turned aliens [aliens_allowed ? "on" : "off"].")
	message_admins("[key_name_admin(src)] has turned aliens [aliens_allowed ? "on" : "off"].", 0)
	feedback_add_details("admin_verb","TAL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_grantfullaccess(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Grant Full Access"

	if (!ticker)
		alert("Wait until the game starts")
		return
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (H.wear_id)
			var/obj/item/card/id/id = H.wear_id
			if(istype(H.wear_id, /obj/item/device/pda))
				var/obj/item/device/pda/pda = H.wear_id
				id = pda.id
			id.icon_state = "gold"
			id:access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access()
		else
			var/obj/item/card/id/id = new/obj/item/card/id(M);
			id.icon_state = "gold"
			id:access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access()
			id.registered_name = H.real_name
			id.assignment = "Captain"
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, WEAR_ID)
			H.update_inv_wear_id()
	else
		alert("Invalid mob")
	feedback_add_details("admin_verb","GFA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] full access.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] has granted [M.key] full access."), 1)

/client/proc/cmd_admin_grantallskills(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Grant All Skills"

	if (!ticker)
		alert("Wait until the game starts")
		return
	if(M.mind)
		M.mind.cm_skills = null // No restrictions
	else
		alert("Invalid mob")
	feedback_add_details("admin_verb","GAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(src)] has granted [M.key] all skills.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] has granted [M.key] all skills."), 1)

/client/proc/cmd_assume_direct_control(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Assume direct control"
	set desc = "Direct intervention"

	if(!check_rights(R_DEBUG|R_ADMIN))	return
	if(M.disposed) return //mob is garbage collected
	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		else
			var/mob/dead/observer/ghost = new/mob/dead/observer(M,1)
			ghost.ckey = M.ckey
			if(ghost.client) ghost.client.change_view(world.view)
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] assumed direct control of [M]."), 1)
	log_admin("[key_name(usr)] assumed direct control of [M].")
	var/mob/adminmob = src.mob
	M.ckey = src.ckey
	if(M.client) M.client.change_view(world.view)
	if( isobserver(adminmob) )
		qdel(adminmob)
	feedback_add_details("admin_verb","ADC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!






/client/proc/cmd_admin_areatest()
	set category = "Mapping"
	set name = "Test areas"
	if(!ishost(usr) || alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	var/list/areas_all = list()
	var/list/areas_with_APC = list()
	var/list/areas_with_air_alarm = list()
	var/list/areas_with_RC = list()
	var/list/areas_with_light = list()
	var/list/areas_with_LS = list()
	var/list/areas_with_intercom = list()
	var/list/areas_with_camera = list()

	for(var/area/A in all_areas)
		if(!(A.type in areas_all))
			areas_all.Add(A.type)

	for(var/obj/machinery/power/apc/APC in machines)
		var/area/A = get_area(APC)
		if(!(A.type in areas_with_APC))
			areas_with_APC.Add(A.type)

	for(var/obj/machinery/alarm/alarm in machines)
		var/area/A = get_area(alarm)
		if(!(A.type in areas_with_air_alarm))
			areas_with_air_alarm.Add(A.type)

	for(var/obj/machinery/requests_console/RC in machines)
		var/area/A = get_area(RC)
		if(!(A.type in areas_with_RC))
			areas_with_RC.Add(A.type)

	for(var/obj/machinery/light/L in machines)
		var/area/A = get_area(L)
		if(!(A.type in areas_with_light))
			areas_with_light.Add(A.type)

	for(var/obj/machinery/light_switch/LS in machines)
		var/area/A = get_area(LS)
		if(!(A.type in areas_with_LS))
			areas_with_LS.Add(A.type)

	for(var/obj/item/device/radio/intercom/I in item_list)
		var/area/A = get_area(I)
		if(!(A.type in areas_with_intercom))
			areas_with_intercom.Add(A.type)

	for(var/obj/machinery/camera/C in machines)
		var/area/A = get_area(C)
		if(!(A.type in areas_with_camera))
			areas_with_camera.Add(A.type)

	var/list/areas_without_APC = areas_all - areas_with_APC
	var/list/areas_without_air_alarm = areas_all - areas_with_air_alarm
	var/list/areas_without_RC = areas_all - areas_with_RC
	var/list/areas_without_light = areas_all - areas_with_light
	var/list/areas_without_LS = areas_all - areas_with_LS
	var/list/areas_without_intercom = areas_all - areas_with_intercom
	var/list/areas_without_camera = areas_all - areas_with_camera

	to_world("<b>AREAS WITHOUT AN APC:</b>")
	for(var/areatype in areas_without_APC)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT AN AIR ALARM:</b>")
	for(var/areatype in areas_without_air_alarm)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT A REQUEST CONSOLE:</b>")
	for(var/areatype in areas_without_RC)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY LIGHTS:</b>")
	for(var/areatype in areas_without_light)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT A LIGHT SWITCH:</b>")
	for(var/areatype in areas_without_LS)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY INTERCOMS:</b>")
	for(var/areatype in areas_without_intercom)
		to_world("* [areatype]")

	to_world("<b>AREAS WITHOUT ANY CAMERAS:</b>")
	for(var/areatype in areas_without_camera)
		to_world("* [areatype]")

/client/proc/test_ceilings()
	set category = "Mapping"
	set name = "Test Ceilings"
	if(!ishost(usr) || alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	var/list/areas_all = list()
	for(var/area/A in all_areas)
		if(!(A in areas_all))
			areas_all.Add(A)
	for(var/area/C in areas_all)
		switch(C.ceiling)
			if(CEILING_NONE)
				for(var/turf/T in C)
					T.color = "#00ff00"
			if(CEILING_GLASS)
				for(var/turf/T in C)
					T.color = "#eeff00"
			else
				for(var/turf/T in C)
					T.color = "#ff0000"

/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players","Admins","Mobs","Living Mobs","Dead Mobs", "Clients"))
		if("Players")
			usr << list2text(player_list,",")
		if("Admins")
			usr << list2text(admins,",")
		if("Mobs")
			usr << list2text(mob_list,",")
		if("Living Mobs")
			usr << list2text(living_mob_list,",")
		if("Dead Mobs")
			usr << list2text(dead_mob_list,",")
		if("Clients")
			usr << list2text(clients,",")


/client/proc/cmd_debug_list_processing_items()
	set category = "Debug"
	set name = "List Processing Items"
	set desc = "For scheduler debugging"

	var/list/individual_counts = list()
	for(var/obj/machinery/M in active_diseases)
		individual_counts["[M.type]"]++
	for(var/datum/event/M in events)
		individual_counts["[M.type]"]++
	for(var/obj/machinery/M in human_mob_list)
		individual_counts["[M.type]"]++
	for(var/obj/machinery/M in processing_machines)
		individual_counts["[M.type]"]++
	for(var/datum/powernet/M in powernets)
		individual_counts["[M.type]"]++
	for(var/obj/machinery/M in living_misc_mobs)
		individual_counts["[M.type]"]++
	for(var/datum/nanoui/M in nanomanager.processing_uis)
		individual_counts["[M.type]"]++
	for(var/datum/powernet/M in powernets)
		individual_counts["[M.type]"]++
	for(var/datum/M in power_machines)
		individual_counts["[M.type]"]++
	for(var/obj/machinery/M in xeno_mob_list)
		individual_counts["[M.type]"]++

	for(var/area/A in active_areas)
		if(A.master == A)
			if(A.powerupdate)
				for(var/obj/machinery/M in A.area_machines)
					individual_counts["[M.type]"]++

	var/str = ""
	for(var/tmp in individual_counts)
		str += "[tmp],[individual_counts[tmp]]<BR>"


	usr << browse("<HEAD><TITLE>Ticker count</TITLE></HEAD><TT>[str]</TT>", "window=tickercount")
