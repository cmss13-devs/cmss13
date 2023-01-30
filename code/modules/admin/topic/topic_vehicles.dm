/datum/admins/proc/topic_vehicles(href)
	switch(href)
		if("remove_clamp")
			owner.cmd_admin_remove_clamp()
		if("repair_vehicle")
			owner.cmd_admin_repair_multitile()

/client/proc/remove_players_from_vic()
	set name = "Remove All From Tank"
	set category = null

	for(var/obj/vehicle/multitile/CA in view())
		CA.handle_all_modules_broken()
		message_staff("[src] forcibly removed all players from [CA]")

/client/proc/cmd_admin_remove_clamp()
	set name = "Remove Vehicle Clamp"
	set desc = "Forcibly removes vehicle clamp from selected vehicle. dropping it under the vehicle."
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/list/targets = get_multi_vehicles_admin()

	var/choice = tgui_input_list(usr, "Select a vehicle.", "Remove Clamp", targets)
	var/obj/vehicle/multitile/Vehicle = targets[choice]

	if(!istype(Vehicle))
		return

	Vehicle.detach_clamp()

	message_staff(WRAP_STAFF_LOG(usr, "forcibly removed vehicle clamp from [Vehicle] in [get_area(Vehicle)] ([Vehicle.x],[Vehicle.y],[Vehicle.z])."), Vehicle.x, Vehicle.y, Vehicle.z)

/client/proc/cmd_admin_repair_multitile()
	set name = "Repair Vehicle"
	set desc = "Fully restores vehicle modules and hull."
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/list/targets = get_multi_vehicles_admin()

	alert("[length(targets)], [targets[1]] and [targets[targets[1]]]","Warning", "OK")

	var/choice = tgui_input_list(usr, "Select a vehicle.", "Repair Vehicle", targets)
	var/obj/vehicle/multitile/Vehicle = targets[choice]

	if(!istype(Vehicle))
		return

	Vehicle.rejuvenate_vehicle()

	message_staff(WRAP_STAFF_LOG(usr, "admin-repaired [Vehicle] in [get_area(Vehicle)]. ([Vehicle.x],[Vehicle.y],[Vehicle.z])"), Vehicle.x, Vehicle.y, Vehicle.z)

//used only for admin verb proc that repairs vehicles.
/obj/vehicle/multitile/proc/rejuvenate_vehicle()

	health = initial(health)
	var/list/hps = get_hardpoints_copy()
	for(var/obj/item/hardpoint/H in hps)
		H.health = initial(H.health)
		H.apply_buff(src)
		if(istype(H, /obj/item/hardpoint/locomotion))
			H.on_install(src)
	healthcheck()
	update_icon()
