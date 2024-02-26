/datum/admins/proc/restart()
	set name = "Restart Server"
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

/datum/admins/proc/togglejoin()
	set name = "Toggle Joining Round"
	set desc = "Players can still log into the server, but players won't be able to join the game as a new mob."
	set category = "Server"

	GLOB.enter_allowed = !GLOB.enter_allowed
	if(!GLOB.enter_allowed)
		to_world("<B>New players may no longer join the game.</B>")
	else
		to_world("<B>New players may now join the game.</B>")
	message_admins("[key_name_admin(usr)] toggled new player game joining.")
	world.update_status()

/datum/admins/proc/toggledsay()
	set name = "Toggle Server Deadchat"
	set desc = "Globally Toggles Deadchat"
	set category = "Server"

	GLOB.dsay_allowed = !GLOB.dsay_allowed
	if(GLOB.dsay_allowed)
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	message_admins("[key_name_admin(usr)] toggled deadchat.")

/datum/admins/proc/toggleooc()
	set name = "Toggle OOC"
	set desc = "Globally Toggles OOC"
	set category = "Server"

	GLOB.ooc_allowed = !GLOB.ooc_allowed
	if(GLOB.ooc_allowed)
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	message_admins("[key_name_admin(usr)] toggled OOC.")

/datum/admins/proc/togglelooc()
	set name = "Toggle LOOC"
	set desc = "Globally Toggles LOOC"
	set category = "Server"

	GLOB.looc_allowed = !GLOB.looc_allowed
	if(GLOB.looc_allowed)
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	message_admins("[key_name_admin(usr)] toggled LOOC.")
