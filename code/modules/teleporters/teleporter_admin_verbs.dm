/client/proc/force_teleporter()
	set name = "Force Teleporter"
	set desc = "Force a teleporter to teleport"
	set category = "Admin.Game"

	var/available_teleporters = SSteleporter.teleporters

	var/datum/teleporter/teleporter = input("Which teleporter do you want to use?", "Select a teleporter:") as null|anything in available_teleporters
	if(!teleporter)
		return

	var/available_locations = teleporter.locations.Copy()

	var/source_location = input("Which location do you want to teleport from?", "Select a location:") as null|anything in available_locations
	if(!source_location)
		return

	available_locations -= source_location

	var/dest_location = input("Which location do you want to teleport to?", "Select a location:") as null|anything in available_locations

	if(!teleporter.check_teleport_cooldown() && alert("Error: Teleporter is on cooldown. Proceed anyways?", , "Yes", "No") != "Yes")
		return

	if((!teleporter.safety_check_source(source_location) || !teleporter.safety_check_destination(dest_location)) && alert("Error: Destination or source is unsafe. Proceed anyways?", , "Yes", "No") != "Yes")
		return

	teleporter.teleport(source_location, dest_location)
