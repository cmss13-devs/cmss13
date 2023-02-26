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

	usr.show_message(t, SHOW_MESSAGE_VISIBLE)


/client/proc/cmd_admin_robotize(mob/M in GLOB.mob_list)
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

/client/proc/cmd_admin_animalize(mob/M in GLOB.mob_list)
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

/client/proc/cmd_admin_alienize(mob/M in GLOB.mob_list)
	set category = null
	set name = "Make Alien"

	if(!SSticker.mode)
		alert("Wait until the game starts")
		return
	if(ishuman(M))
		log_admin("[key_name(src)] has alienized [M.key].")
		spawn(10)
			M:Alienize()

		message_admins("[key_name_admin(usr)] made [key_name(M)] into an alien.")
	else
		alert("Invalid mob")

/client/proc/cmd_admin_change_hivenumber()
	set category = "Debug"
	set name = "Change Hivenumber"

	var/mob/living/carbon/X = tgui_input_list(src,"Select a xeno.", "Change Hivenumber", GLOB.living_xeno_list)
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
		message_admins("[key_name(src)] enabled checking for round-end.")
	else
		message_admins("[key_name(src)] disabled checking for round-end.")



//TODO: merge the vievars version into this or something maybe mayhaps
/client/proc/cmd_debug_del_all()
	set category = "Debug"
	set name = "Delete Instance"

	// to prevent REALLY stupid deletions
	var/blocked = list(/obj, /obj/item, /obj/effect, /obj/structure/machinery, /mob, /mob/living, /mob/living/carbon, /mob/living/carbon/xenomorph, /mob/living/carbon/human, /mob/dead, /mob/dead/observer, /mob/living/silicon, /mob/living/silicon/robot, /mob/living/silicon/ai)
	var/chosen_deletion = input(usr, "Type the path of the object you want to delete", "Delete:") as null|text
	if(chosen_deletion)
		chosen_deletion = text2path(chosen_deletion)
		if(ispath(chosen_deletion))
			var/hsbitem = tgui_input_list(usr, "Choose an object to delete.", "Delete:", typesof(chosen_deletion))
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
					message_admins("[key_name_admin(src)] has deleted all instances of [hsbitem] ([del_amt]).", 0)
		else
			to_chat(usr, SPAN_WARNING("Not a valid type path."))

/client/proc/cmd_debug_make_powernets()
	set category = "Debug"
	set name = "Generate Powernets"
	if(alert("Are you sure you want to do this?",, "Yes", "No") != "Yes") return
	makepowernets()
	message_admins("[key_name_admin(src)] has remade the powernets. makepowernets() called.", 0)


/client/proc/cmd_admin_grantfullaccess(mob/M in GLOB.mob_list)
	set category = null
	set name = "Grant Full Access"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return

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
			id.registered_ref = WEAKREF(H)
			id.assignment = "Captain"
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"
			H.equip_to_slot_or_del(id, WEAR_ID)
			H.update_inv_wear_id()
	else
		alert("Invalid mob")

	message_admins("[key_name_admin(usr)] has granted [M.key] full access.")

/client/proc/cmd_admin_grantallskills(mob/M in GLOB.mob_list)
	set category = null
	set name = "Give Null Skills"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return

	if(!SSticker.mode)
		alert("Wait until the game starts")
		return
	if(M)
		M.skills = null // No restrictions
	else
		alert("Invalid mob")

	message_admins("[key_name_admin(usr)] has given [M.key] null skills.")

/client/proc/admin_create_account(mob/target in GLOB.mob_list)
	set category = null
	set name = "Create Bank Account"

	if(!ishuman(target))
		to_chat(src, SPAN_WARNING("This only works on humans"))
		return

	var/mob/living/carbon/human/account_user = target

	if(account_user.mind?.initial_account)
		var/warning = tgui_alert(src, "They already have an account, proceeding will delete it. Are you sure you wish to continue?", "Confirm", list("Proceed", "Cancel"))
		if(warning != "Proceed")
			return
		else
			QDEL_NULL(account_user.mind.initial_account)

	var/datum/money_account/generated_account

	var/starting_amount = tgui_input_number(src, "How much money should they start with?", "Pick starting amount", 30, 100000, 0)
	if(!starting_amount)
		starting_amount = 0

	var/custom_paygrade = tgui_input_list(src, "Select paygrade of account", "Account paygrade", GLOB.paygrades)
	if(!custom_paygrade)
		to_chat(src, SPAN_WARNING("They must have a paygrade!"))
		return


	var/datum/paygrade/account_paygrade = GLOB.paygrades[custom_paygrade]
	var/obj/item/card/id/card = account_user.wear_id
	generated_account = create_account(account_user.real_name, starting_amount, account_paygrade)
	if(card)
		card.associated_account_number = generated_account.account_number
		card.paygrade = account_paygrade
	if(account_user.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[generated_account.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [generated_account.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> $[generated_account.money]<br>"

		if(generated_account.transaction_log.len)
			var/datum/transaction/T = generated_account.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		account_user.mind.store_memory(remembered_info)
		account_user.mind.initial_account = generated_account

/client/proc/cmd_assume_direct_control(mob/M in GLOB.mob_list)
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

	message_admins("[key_name_admin(usr)] assumed direct control of [M].")

/client/proc/cmd_debug_list_processing_items()
	set category = "Debug.Controllers"
	set name = "List Processing Items"
	set desc = "For scheduler debugging"

	var/list/individual_counts = list()
	for(var/datum/disease/M in active_diseases)
		individual_counts["[M.type]"]++
	for(var/mob/M in SShuman.processable_human_list)
		individual_counts["[M.type]"]++
	for(var/obj/structure/machinery/M in processing_machines)
		individual_counts["[M.type]"]++
	for(var/datum/powernet/M in powernets)
		individual_counts["[M.type]"]++
	for(var/mob/M in SSmob.living_misc_mobs)
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
