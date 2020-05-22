// Clickable stat() button.
/obj/effect/statclick
	var/target

/obj/effect/statclick/New(text, target)
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
		return
	if(!class)
		if(istype(target, /datum/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe", "Supply Shuttle"))
	set category = "Debug"
	set name = "X: Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if (!admin_holder || !(usr.client.admin_holder.rights & R_DEBUG))
		return

	switch (controller)
		if ("Master")
			new/datum/controller/master()
		if ("Failsafe")
			new /datum/controller/failsafe()

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")


/proc/get_world_controllers()
	var/list/controllers = new

	for(var/v in world.vars)
		if(istype(world.vars[v], /datum/controller))
			controllers += world.vars[v]
	for(var/v in global.vars)
		if(istype(global.vars[v], /datum/controller))
			controllers += global.vars[v]
	for(var/datum/subsystem/ss in Master.subsystems)
		controllers += ss

	return controllers

/client/proc/debug_controller(controller in get_world_controllers())
	set category = "Debug"
	set name = "B: Debug Controller"
	set desc = "debug the various periodic loop controllers for the game (be careful!)."

	if (!admin_holder || !(usr.client.admin_holder.rights & R_DEBUG))
		return

	debug_variables(controller)
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
