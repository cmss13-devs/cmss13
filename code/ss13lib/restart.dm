/datum/ss13lib/proc/handle_reboot()
	for(var/ckey, launcher in ckey_to_launcher)
		var/datum/ss13lib_launcher/launcher_datum = launcher
		launcher_datum.restart("Server Restart")
