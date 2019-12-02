/datum/admins/proc/restart()
	set name = "A: Restart Server"
	set desc = "Restarts the world"
	set category = "Server"

	if (!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world(SPAN_DANGER("<b>Restarting world!</b> [SPAN_NOTICE("Initiated by [usr.client.admin_holder.fakekey ? "Admin" : usr.key]!")]"))
		log_admin("[key_name(usr)] initiated a reboot.")

		sleep(50)
		world.Reboot()

/datum/admins/proc/toggleguests()
	set name = "Toggle Guest Joining"
	set desc = "Guests can't enter"
	set category = "Server"

	guests_allowed = !( guests_allowed )
	if (!( guests_allowed ))
		to_world("<B>Guests may no longer enter the game.</B>")
	else
		to_world("<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [guests_allowed?"":"dis"]allowed.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled guests game entering [guests_allowed ? "":"dis"]allowed."), 1)

/datum/admins/proc/togglejoin()
	set name = "Toggle Marines Joining"
	set desc = "Players can still log into the server, but Marines won't be able to join the game as a new mob."
	set category = "Server"

	enter_allowed = !( enter_allowed )
	if (!( enter_allowed ))
		to_world("<B>New players may no longer join the game.</B>")
	else
		to_world("<B>New players may now join the game.</B>")
	log_admin("[key_name(usr)] toggled new player game joining.")
	message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled new player game joining."), 1)
	world.update_status()

/datum/admins/proc/toggledsay()
	set name = "Toggle Deadchat"
	set desc = "Globally Toggles Deadchat"
	set category = "Server"

	dsay_allowed = !( dsay_allowed )
	if(dsay_allowed)
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled deadchat.")
	message_admins("[key_name_admin(usr)] toggled deadchat.")

/datum/admins/proc/toggleooc()
	set name = "Toggle OOC"
	set desc = "Globally Toggles OOC"
	set category = "Server"

	ooc_allowed = !( ooc_allowed )
	if (ooc_allowed)
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.")

/datum/admins/proc/togglelooc()
	set name = "Toggle LOOC"
	set desc = "Globally Toggles LOOC"
	set category = "Server"

	looc_allowed = !( looc_allowed )
	if (looc_allowed)
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled LOOC.")
	message_admins("[key_name_admin(usr)] toggled LOOC.")