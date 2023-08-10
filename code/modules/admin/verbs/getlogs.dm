/*
	HOW DO I LOG RUNTIMES?
	Firstly, start dreamdeamon if it isn't already running. Then select "world>Log Session" (or press the F3 key)
	navigate the popup window to the data/logs/runtime/ folder from where your tgstation .dmb is located.
	(you may have to make this folder yourself)

	OPTIONAL: you can select the little checkbox down the bottom to make dreamdeamon save the log everytime you
				start a world. Just remember to repeat these steps with a new name when you update to a new revision!

	Save it with the name of the revision your server uses (e.g. r3459.txt).
	Game Masters will now be able to grant access any runtime logs you have archived this way!
	This will allow us to gather information on bugs across multiple servers and make maintaining the TG
	codebase for the entire /TG/station commuity a TONNE easier :3 Thanks for your help!
*/

//This proc allows Game Masters to grant a client access to the .getruntimelog verb
//Permissions expire at the end of each round.
//Runtimes can be used to meta or spot game-crashing exploits so it's advised to only grant coders that
//you trust access. Also, it may be wise to ensure that they are not going to play in the current round.
/client/proc/giveruntimelog()
	set name = ".giveruntimelog"
	set desc = "Give somebody access to any session logfiles saved to the /log/runtime/ folder."
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD) || !(admin_holder.rights & R_DEBUG))
		to_chat(src, "<font color='red'>Access denied.</font>")
		return

	var/client/target = tgui_input_list(src,"Choose somebody to grant access to the server's runtime logs (permissions expire at the end of each round):","Grant Permissions", GLOB.clients)
	if(!istype(target, /client))
		to_chat(src, "<font color='red'>Error: giveruntimelog(): Client not found.</font>")
		return

	message_admins("[key_name_admin(src)] granted [key_name_admin(target)] access to runtime logs this round.")
	target.verbs |= /client/proc/getruntimelog
	to_chat(target, "<font color='red'>You have been granted access to runtime logs. Please use them responsibly or risk being banned.</font>")

//This proc allows download of runtime logs saved within the data/logs/ folder by dreamdeamon.
//It works similarly to show-server-log.
/client/proc/getruntimelog()
	set name = ".getruntimelog"
	set desc = "Pick a logfile from data/logs/runtime to view."
	set category = null

	var/path = browse_files("data/logs/runtime/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))

//This proc allows download of past server logs saved within the data/logs/ folder.
//It works similarly to show-server-log.
/client/proc/getserverlog()
	set name = ".getserverlog"
	set desc = "Pick a logfile from data/logs to view."
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & (R_MOD) || !(admin_holder.rights & R_DEBUG)))
		to_chat(src, "<font color='red'>Access denied.</font>")
		return

	var/path = browse_files("data/logs/")
	if(!path)
		return

	if(file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))

//Other log stuff put here for the sake of organisation

/**Shows this round's server log*/
/datum/admins/proc/view_game_log()
	set name = "Show Server Game Log"
	set desc = "Shows this round's server game log."
	set category = "Server"

	if(!check_rights(R_MOD|R_DEBUG))
		return

	var/path = GLOB.world_game_log
	if(!fexists(path))
		to_chat(src, "<font color='red'>Error: view_log(): File not found/Invalid path([path]).</font>")
		return

	if(usr.client.file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))

/**Shows this round's attack log*/
/datum/admins/proc/view_attack_log()
	set name = "Show Server Attack Log"
	set desc = "Shows this round's server attack log."
	set category = "Server"

	if(!check_rights(R_MOD))
		return

	var/path = GLOB.world_attack_log
	if(!fexists(path))
		to_chat(src, "<font color='red'>Error: view_log(): File not found/Invalid path([path]).</font>")
		return

	if(usr.client.file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))

/**Shows this round's runtime log*/
/datum/admins/proc/view_runtime_log()
	set name = "Show Server Runtime Log"
	set desc = "Shows this round's server runtime log."
	set category = "Server"

	if(!check_rights(R_DEBUG))
		return

	var/path = GLOB.world_runtime_log
	if(!fexists(path))
		to_chat(src, "<font color='red'>Error: view_log(): File not found/Invalid path([path]).</font>")
		return

	if(usr.client.file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))

/**Shows this round's href log*/
/datum/admins/proc/view_href_log()
	set name = "Show Server HREF Log"
	set desc = "Shows this round's server HREF log."
	set category = "Server"

	if(!check_rights(R_DEBUG))
		return

	var/path = GLOB.world_href_log
	if(!fexists(path))
		to_chat(src, "<font color='red'>Error: view_log(): File not found/Invalid path([path]).</font>")
		return

	if(usr.client.file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))

/**Shows this round's tgui log*/
/datum/admins/proc/view_tgui_log()
	set name = "Show Server TGUI Log"
	set desc = "Shows this round's server TGUI log."
	set category = "Server"

	if(!check_rights(R_DEBUG))
		return

	var/path = GLOB.tgui_log
	if(!fexists(path))
		to_chat(src, "<font color='red'>Error: view_log(): File not found/Invalid path([path]).</font>")
		return

	if(usr.client.file_spam_check())
		return

	message_admins("[key_name_admin(src)] accessed file: [path]")
	to_chat(src, "Attempting to send file, this may take a fair few minutes if the file is very large.")
	src << ftp(file(path))
