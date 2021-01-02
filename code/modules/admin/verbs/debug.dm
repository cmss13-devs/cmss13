GLOBAL_VAR(AdminProcCaller)
GLOBAL_PROTECT(AdminProcCaller)
GLOBAL_VAR_INIT(AdminProcCallCount, FALSE)
GLOBAL_PROTECT(AdminProcCallCount)
GLOBAL_VAR(LastAdminCalledTargetRef)
GLOBAL_PROTECT(LastAdminCalledTargetRef)
GLOBAL_VAR(LastAdminCalledTarget)
GLOBAL_PROTECT(LastAdminCalledTarget)
GLOBAL_VAR(LastAdminCalledProc)
GLOBAL_PROTECT(LastAdminCalledProc)
GLOBAL_LIST_EMPTY(AdminProcCallSpamPrevention)
GLOBAL_PROTECT(AdminProcCallSpamPrevention)

/client/proc/proccall_atom(datum/A as null|area|mob|obj|turf)
	set category = null
	set name = "Atom ProcCall"
	set waitfor = FALSE

	if(!check_rights(R_DEBUG))
		return

	/// Holds a reference to the client incase something happens to them
	var/client/starting_client = usr.client

	var/procname = input("Proc name, eg: attack_hand", "Proc:", null) as text|null
	if(!procname)
		return

	if(!hascall(A, procname))
		to_chat(starting_client, "<font color='red'>Error: callproc_datum(): type [A.type] has no proc named [procname].</font>")
		return

	var/list/lst = starting_client.admin_holder.get_callproc_args()
	if(!lst)
		return

	if(!A || !IsValidSrc(A))
		to_chat(starting_client, "<span class='warning'>Error: callproc_datum(): owner of proc no longer exists.</span>")
		return

	log_admin("[key_name(usr)] called [A]'s [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
	message_admins("[key_name_admin(usr)] called [A]'s [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")

	var/returnval = WrapAdminProcCall(A, procname, lst) // Pass the lst as an argument list to the proc
	. = starting_client.admin_holder.get_callproc_returnval(returnval, procname)
	if(.)
		to_chat(usr, .)


/client/proc/proccall_advanced()
	set category = "Debug"
	set name = "Advanced ProcCall"
	set waitfor = FALSE

	if(!check_rights(R_DEBUG))
		return

	var/datum/target = null
	var/targetselected = 0
	var/returnval = null

	switch(alert("Proc owned by something?",, "Yes", "No"))
		if("Yes")
			targetselected = TRUE
			var/list/value = usr.client.vv_get_value(default_class = VV_ATOM_REFERENCE, classes = list(VV_ATOM_REFERENCE, VV_DATUM_REFERENCE, VV_MOB_REFERENCE, VV_CLIENT))
			if(!value["class"] || !value["value"])
				return
			target = value["value"]
		if("No")
			target = null
			targetselected = FALSE

	var/procname = input("Proc path, eg: /proc/attack_hand(mob/living/user)")
	if(!procname)
		return

	//strip away everything but the proc name
	var/list/proclist = splittext(procname, "/")
	if(!length(proclist))
		return

	procname = proclist[length(proclist)]

	var/proctype = "proc"
	if("verb" in proclist)
		proctype = "verb"


	var/procpath
	if(targetselected && !hascall(target, procname))
		to_chat(usr, "<font color='red'>Error: callproc(): type [target.type] has no [proctype] named [procname].</font>")
		return
	else if(!targetselected)
		procpath = text2path("/[proctype]/[procname]")
		if(!procpath)
			to_chat(usr, "<font color='red'>Error: callproc(): proc [procname] does not exist. (Did you forget the /proc/ part?)</font>")
			return

	var/list/lst = usr.client.admin_holder.get_callproc_args()
	if(!lst)
		return

	if(targetselected)
		if(!target)
			to_chat(usr, "<font color='red'>Error: callproc(): owner of proc no longer exists.</font>")
			return
		log_admin("[key_name(usr)] called [target]'s [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
		message_admins("[key_name_admin(usr)] called [target]'s [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
		returnval = WrapAdminProcCall(target, procname, lst) // Pass the lst as an argument list to the proc
	else
		//this currently has no hascall protection. wasn't able to get it working.
		log_admin("[key_name(usr)] called [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
		message_admins("[key_name_admin(usr)] called [procname]() with [length(lst) ? "the arguments [list2params(lst)]" : "no arguments"].")
		returnval = WrapAdminProcCall(GLOBAL_PROC, procpath, lst) // Pass the lst as an argument list to the proc

	. = usr.client.admin_holder.get_callproc_returnval(returnval, procname)
	if(.)
		to_chat(usr, .)

/datum/admins/proc/get_callproc_returnval(returnval, procname)
	. = ""
	if(islist(returnval))
		var/list/returnedlist = returnval
		. = "<span class='notice'>"
		if(length(returnedlist))
			var/assoc_check = returnedlist[1]
			if(istext(assoc_check) && (returnedlist[assoc_check] != null))
				. += "[procname] returned an associative list:"
				for(var/key in returnedlist)
					. += "\n[key] = [returnedlist[key]]"

			else
				. += "[procname] returned a list:"
				for(var/elem in returnedlist)
					. += "\n[elem]"
		else
			. = "[procname] returned an empty list"
		. += "</font>"

	else
		. = "<span class='notice'>[procname] returned: [!isnull(returnval) ? returnval : "null"]</font>"


/datum/admins/proc/get_callproc_args()
	var/argnum = input("Number of arguments", "Number:", 0) as num|null
	if(isnull(argnum))
		return

	. = list()
	var/list/named_args = list()
	while(argnum--)
		var/named_arg = input("Leave blank for positional argument. Positional arguments will be considered as if they were added first.", "Named argument") as text|null
		var/value = usr.client.vv_get_value(restricted_classes = list(VV_RESTORE_DEFAULT))
		if (!value["class"])
			return
		if(named_arg)
			named_args[named_arg] = value["value"]
		else
			. += value["value"]
	if(LAZYLEN(named_args))
		. += named_args


/client/proc/callproc(var/datum/target_datum=null)
	set waitfor = 0

	if(!check_rights(R_DEBUG) || (CONFIG_GET(flag/debugparanoid) && !check_rights(R_ADMIN)))
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
					target = input("Enter target:","Target",usr) as obj in GLOB.object_list
				if("Mob")
					target = input("Enter target:","Target",usr) as mob in GLOB.mob_list
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

	if (targetselected)
		if(QDELETED(target))
			return
		if(istype(target) && target.is_datum_protected())
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
				lst[i] = input("Select reference:","Reference",usr) as mob in GLOB.mob_list

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
				var/mob/temp = input("Select mob", "Selection", usr) as mob in GLOB.mob_list
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


/client/proc/cmd_admin_robotize(var/mob/M in GLOB.mob_list)
	set category = null
	set name = "Make Robot"

	if(!SSticker.mode)
		alert("Wait until the game starts")
		return
	if(istype(M, /mob/living/carbon/human))
		log_admin("[key_name(src)] has robotized [M.key].")
		spawn(10)
			M:Robotize()

	else
		alert("Invalid mob")

/client/proc/cmd_admin_animalize(var/mob/M in GLOB.mob_list)
	set category = null
	set name = "Make Simple Animal"

	if(!SSticker.mode)
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

/client/proc/cmd_admin_alienize(var/mob/M in GLOB.mob_list)
	set category = null
	set name = "Make Alien"

	if(!SSticker.mode)
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
	set name = "Change Hivenumber"

	var/mob/living/carbon/X = input(src,"Select a xeno.", null, null) in GLOB.living_xeno_list
	if(!istype(X))
		to_chat(usr, "This can only be done to instances of type /mob/living/carbon")
		return

	cmd_admin_change_their_hivenumber(X)

/client/proc/cmd_debug_toggle_should_check_for_win()
	set category = "Debug"
	set name = "Toggle Round End Checks"

	if(!SSticker.mode)
		to_chat(usr, "Mode not found?")
	round_should_check_for_win = !round_should_check_for_win
	if (round_should_check_for_win)
		message_staff(SPAN_NOTICE("[key_name(src)] enabled checking for round-end."), 1)
	else
		message_staff(SPAN_NOTICE("[key_name(src)] disabled checking for round-end."), 1)



//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Delete Instance"

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
	set name = "Fire OB"

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
	set name = "Generate Powernets"
	if(alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	makepowernets()
	message_staff("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)


/client/proc/cmd_admin_grantfullaccess(var/mob/M in GLOB.mob_list)
	set category = null
	set name = "Grant Full Access"

	if (!SSticker.mode)
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

/client/proc/cmd_admin_grantallskills(var/mob/M in GLOB.mob_list)
	set category = null
	set name = "Grant All Skills"

	if(!SSticker.mode)
		alert("Wait until the game starts")
		return
	if(M)
		M.skills = null // No restrictions
	else
		alert("Invalid mob")

	message_staff(SPAN_NOTICE("[key_name_admin(usr)] has granted [M.key] all skills."), 1)

/client/proc/cmd_assume_direct_control(var/mob/M in GLOB.mob_list)
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

/client/proc/cmd_debug_list_processing_items()
	set category = "Debug.Controllers"
	set name = "List Processing Items"
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
	for(var/mob/M in GLOB.xeno_mob_list)
		individual_counts["[M.type]"]++

	var/str = ""
	for(var/tmp in individual_counts)
		str += "[tmp],[individual_counts[tmp]]<BR>"


	show_browser(usr, "<TT>[str]</TT>", "Ticker Count", "tickercount")
