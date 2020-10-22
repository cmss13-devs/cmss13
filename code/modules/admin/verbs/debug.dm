/* 21st Sept 2010
Updated by Skie -- Still not perfect but better!
Stuff you can't do:
Call proc /mob/proc/make_dizzy() for some player
Because if you select a player mob as owner it tries to do the proc for
/mob/living/carbon/human/ instead. And that gives a run-time error.
But you can call procs that are of type /mob/living/carbon/human/proc/ for that player.
*/

// Wrapper verb for advanced proccall
/client/proc/advproccall()
	set category = "Debug"
	set name = "A: Advanced ProcCall"

	callproc(null)

/client/proc/callproc(var/datum/target_datum=null)
	set waitfor = 0

	if(!check_rights(R_DEBUG) || (config.debugparanoid && !check_rights(R_ADMIN)))
		return

	var/datum/target = target_datum
	var/targetselected = 1
	var/lst[] // List reference
	lst = new/list() // Make the list
	var/returnval = null
	var/class = null

	if(isnull(target))
		targetselected = 0
		if(alert("Proc owned by something?",,"Yes","No") == "Yes")
			targetselected = 1
			var/list/options = list("Obj","Mob","Area or Turf","Client", "World")
			if(admin_holder && admin_holder.marked_datums.len)
				options += "Marked datum"

			class = input("Proc owned by...","Owner",null) as null|anything in options
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
				if("Marked datum")
					var/datum/D = input_marked_datum(admin_holder.marked_datums)
					target = D
				if("World")
					target = world
				else
					return

	if(target.is_datum_protected())
		to_chat(usr, SPAN_WARNING("This datum is protected. Access Denied"))
		return

	var/procname = input("Proc path, eg: /proc/fake_blood","Path:", null) as text|null
	if(!procname)	
		return

	var/argnum = input("Number of arguments","Number:",0) as num|null
	if(!argnum && (argnum!=0))	
		return

	lst.len = argnum // Expand to right length
	//TODO: make a list to store whether each argument was initialised as null.
	//Reason: So we can abort the proccall if say, one of our arguments was a mob which no longer exists
	//this will protect us from a fair few errors ~Carn

	var/i
	for(i=1, i<argnum+1, i++) // Lists indexed from 1 forwards in byond

		// Make a list with each index containing one variable, to be given to the proc
		class = input("What kind of variable?","Variable Type") in list("text","num","type","reference","mob reference","icon","file","client","mob's area","marked datum","CANCEL")
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
				for(var/mob/M in GLOB.player_list)
					keys += M.client
				lst[i] = input("Please, select a player!", "Selection", null, null) as null|anything in keys

			if("mob's area")
				var/mob/temp = input("Select mob", "Selection", usr) as mob in mob_list
				lst[i] = temp.loc

			if("marked datum")
				var/datum/D = input_marked_datum(admin_holder.marked_datums)
				lst[i] = D

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

	to_chat(usr, SPAN_BLUE("[procname] returned: [returnval ? returnval : "null"]"))




/client/proc/callatomproc(atom/A)
	set category = "Debug"
	set name = "B: Atom ProcCall"
	set waitfor = 0

	if(!check_rights(R_DEBUG) || (config.debugparanoid && !check_rights(R_ADMIN))) 
		return

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
	if(!argnum && (argnum!=0))	
		return

	lst.len = argnum

	var/i
	for(i=1, i<argnum+1, i++) // Lists indexed from 1 forwards in byond

		// Make a list with each index containing one variable, to be given to the proc
		class = input("What kind of variable?","Variable Type") in list("text","num","type","reference","mob reference","icon","file","client","mob's area","marked datum","CANCEL")
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
				for(var/mob/M in GLOB.player_list)
					keys += M.client
				lst[i] = input("Please, select a player!", "Selection", null, null) as null|anything in keys

			if("mob's area")
				var/mob/temp = input("Select mob", "Selection", usr) as mob in mob_list
				lst[i] = temp.loc

			if("marked datum")
				var/datum/D = input_marked_datum(admin_holder.marked_datums)
				lst[i] = D

	message_staff(SPAN_NOTICE("[key_name_admin(src)] called [A]'s [procname]() with [lst.len ? "the arguments [list2params(lst)]":"no arguments"]."))
	returnval = call(A,procname)(arglist(lst)) // Pass the lst as an argument list to the proc
	to_chat(usr, SPAN_BLUE("[procname] returned: [returnval ? returnval : "null"]"))





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


/client/proc/cmd_admin_robotize(var/mob/M in mob_list)
	set category = null
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
	set category = null
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
	set category = null
	set name = "Make Alien"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()

		message_staff(SPAN_NOTICE("[key_name_admin(usr)] made [key_name(M)] into an alien."), 1)
	else
		alert("Invalid mob")

/client/proc/cmd_admin_change_hivenumber()
	set category = "Debug"
	set name = "E: Change Hivenumber"

	var/mob/living/carbon/X = input(src,"Select a xeno.", null, null) in living_xeno_list
	if(!istype(X))
		to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
		return

	cmd_admin_change_their_hivenumber(X)

/client/proc/cmd_debug_toggle_should_check_for_win()
	set category = "Debug"
	set name = "H: Toggle Round End Checks"

	if(!ticker || !ticker.mode)
		to_chat(usr, "Mode not found?")
	round_should_check_for_win = !round_should_check_for_win
	if (round_should_check_for_win)
		message_staff(SPAN_NOTICE("[key_name(src)] enabled checking for round-end."), 1)
	else
		message_staff(SPAN_NOTICE("[key_name(src)] disabled checking for round-end."), 1)



//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "E: Delete Instance"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /obj/item, /obj/effect, /obj/structure/machinery, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/Xenomorph, /mob/living/carbon/human, /mob/dead, /mob/dead/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/chosen_deletion = input(usr, "Type the path of the object you want to delete", "Delete:") as null|text
	if(chosen_deletion)
		chosen_deletion = text2path(chosen_deletion)
		if(ispath(chosen_deletion))
			var/hsbitem = input(usr, "Choose an object to delete.", "Delete:") as null|anything in typesof(chosen_deletion)
			if(hsbitem)
				var/do_delete = 1
				if(hsbitem in blocked)
					if(alert("Are you REALLY sure you wish to delete all instances of [hsbitem]? This will lead to catastrophic results!",,"Yes","No") != "Yes")
						do_delete = 0
				var/del_amt = 0
				if(do_delete)
					var/is_turf = ispath(hsbitem, /turf)
					for(var/atom/O in world)
						if(istype(O, hsbitem))
							if(is_turf)
								var/turf/T = O
								T.ScrapeAway()
							else
								qdel(O)
							del_amt++
					message_staff("[key_name_admin(src)] has deleted all instances of [hsbitem] ([del_amt]).", 0)
		else
			to_chat(usr, SPAN_WARNING("Not a valid type path."))

/client/proc/cmd_debug_fire_ob()
	set category = "Debug"
	set desc = "Fire an OB warhead at your current location."
	set name = "E: Fire OB"

	if(!check_rights(R_DEBUG))
		return

	if(alert("Are you SURE you want to do this? It will create an OB explosion without delay or a sound cue!",, "Yes", "No") == "No") return

	// Select the warhead.
	var/list/warheads = subtypesof(/obj/structure/ob_ammo/warhead/)
	var/choice = input("Select the warhead:") as null|anything in warheads
	var/obj/structure/ob_ammo/warhead/warhead = new choice
	var/turf/target = get_turf(usr.loc)
	target.ceiling_debris_check(5)
	warhead.warhead_impact(target)

	message_staff("[key_name(usr)] has fired \an [warhead.name] at ([target.x],[target.y],[target.z]).")

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "X: Generate Powernets"
	if(alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	makepowernets()
	message_staff("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)


/client/proc/cmd_admin_grantfullaccess(var/mob/M in mob_list)
	set category = null
	set name = "Grant Full Access"

	if (!ticker)
		alert("Wait until the game starts")
		return
	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if (H.wear_id)
			var/obj/item/card/id/id = H.wear_id
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

	message_staff(SPAN_NOTICE("[key_name_admin(usr)] has granted [M.key] full access."), 1)

/client/proc/cmd_admin_grantallskills(var/mob/M in mob_list)
	set category = null
	set name = "Grant All Skills"

	if(!ticker)
		alert("Wait until the game starts")
		return
	if(M)
		M.skills = null // No restrictions
	else
		alert("Invalid mob")

	message_staff(SPAN_NOTICE("[key_name_admin(usr)] has granted [M.key] all skills."), 1)

/client/proc/cmd_assume_direct_control(var/mob/M in mob_list)
	set name = "Control Mob"
	set desc = "Assume control of the mob"
	set category = null

	if(!check_rights(R_DEBUG|R_ADMIN))	
		return

	if(QDELETED(M)) 
		return //mob is garbage collected

	if(M.ckey)
		if(alert("This mob is being controlled by [M.ckey]. Are you sure you wish to assume control of it? [M.ckey] will be made a ghost.",,"Yes","No") != "Yes")
			return
		
		M.ghostize()

	if(M.mind)
		if(M.mind.player_entity)
			M.track_death_calculations()
		M.mind.player_entity = setup_player_entity(src.ckey)
		M.statistic_tracked = FALSE

	usr.mind.transfer_to(M, TRUE)

	message_staff(SPAN_NOTICE("[key_name_admin(usr)] assumed direct control of [M]."), 1)

/client/proc/cmd_debug_mob_lists()
	set category = "Debug"
	set name = "E: Debug Mob Lists"
	set desc = "For when you just gotta know"

	switch(input("Which list?") in list("Players","Admins","Clients","Mobs","Living Mobs","Dead Mobs","Human Mobs","Living Human Mobs","Xeno Mobs","Xeno Living Mobs","Yautja Mobs"))
		if("Mobs")
			if(mob_list.len)
				to_chat(usr, jointext(mob_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Living Mobs")
			if(living_mob_list.len)
				to_chat(usr, jointext(living_mob_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Dead Mobs")
			if(dead_mob_list.len)
				to_chat(usr, jointext(dead_mob_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Human Mobs")
			if(human_mob_list.len)
				to_chat(usr, jointext(human_mob_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Living Human Mobs")
			if(living_human_list.len)
				to_chat(usr, jointext(living_human_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Xeno Mobs")
			if(xeno_mob_list.len)
				to_chat(usr, jointext(xeno_mob_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Xeno Living Mobs")
			if(living_xeno_list.len)
				to_chat(usr, jointext(living_xeno_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))
		if("Yautja Mobs")
			if(yautja_mob_list.len)
				to_chat(usr, jointext(yautja_mob_list," | "))
			else
				to_chat(usr, SPAN_WARNING("No mobs in player list found."))


/client/proc/cmd_debug_list_processing_items()
	set category = "Debug"
	set name = "C: List Processing Items"
	set desc = "For scheduler debugging"

	var/list/individual_counts = list()
	for(var/datum/disease/M in active_diseases)
		individual_counts["[M.type]"]++
	for(var/mob/M in processable_human_list)
		individual_counts["[M.type]"]++
	for(var/obj/structure/machinery/M in processing_machines)
		individual_counts["[M.type]"]++
	for(var/datum/powernet/M in powernets)
		individual_counts["[M.type]"]++
	for(var/mob/M in living_misc_mobs)
		individual_counts["[M.type]"]++
	for(var/datum/nanoui/M in nanomanager.processing_uis)
		individual_counts["[M.type]"]++
	for(var/datum/powernet/M in powernets)
		individual_counts["[M.type]"]++
	for(var/datum/M in power_machines)
		individual_counts["[M.type]"]++
	for(var/mob/M in xeno_mob_list)
		individual_counts["[M.type]"]++

	var/str = ""
	for(var/tmp in individual_counts)
		str += "[tmp],[individual_counts[tmp]]<BR>"


	show_browser(usr, "<TT>[str]</TT>", "Ticker Count", "tickercount")