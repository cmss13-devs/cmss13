// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	var/target

INITIALIZE_IMMEDIATE(/obj/effect/statclick)

/obj/effect/statclick/Initialize(mapload, text, target)
	. = ..()
	name = text
	src.target = target
	if(isdatum(target)) //Harddel man bad
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(cleanup))

/obj/effect/statclick/Destroy()
	target = null
	return ..()

/obj/effect/statclick/proc/cleanup()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/clicked()
	if(!usr.client.admin_holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")
	return TRUE


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug.Controllers"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!admin_holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
			//SSblackbox.record_feedback("tally", "admin_verb", 1, "Restart Master Controller")
		if("Failsafe")
			new /datum/controller/failsafe()
			//SSblackbox.record_feedback("tally", "admin_verb", 1, "Restart Failsafe Controller")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/debug_controller()
	set category = "Debug.Controllers"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!admin_holder)
		return

	var/list/controllers = list()
	var/list/controller_choices = list()

	for (var/datum/controller/controller in world)
		if (istype(controller, /datum/controller/subsystem))
			continue
		controllers["[controller] (controller.type)"] = controller //we use an associated list to ensure clients can't hold references to controllers
		controller_choices += "[controller] (controller.type)"

	var/datum/controller/controller_string = input("Select controller to debug", "Debug Controller") as null|anything in controller_choices
	var/datum/controller/controller = controllers[controller_string]

	if (!istype(controller))
		return
	debug_variables(controller)

	//SSblackbox.record_feedback("tally", "admin_verb", 1, "Restart Failsafe Controller")
	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/debug_role_authority()
	set category = "Debug.Controllers"
	set name = "Debug Role Authority"

	if(!GLOB.RoleAuthority)
		to_chat(usr, "RoleAuthority not found!")
		return
	debug_variables(GLOB.RoleAuthority)
	message_admins("Admin [key_name_admin(usr)] is debugging the Role Authority.")
