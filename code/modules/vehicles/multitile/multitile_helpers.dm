
/*
This one currently doesn't work. Will rework adn readd it during interior update.
/client/proc/remove_players_from_vehicle()
	set name = "Remove All From Tank"
	set category = "Admin"

	for(var/obj/vehicle/multitile/R in view())
		R.remove_all_players()
		message_staff("[src] forcibly removed all players from [R]")
*/
/client/proc/cmd_admin_remove_clamp()
	set name = "Vehicle Remove Clamp"
	set desc = "Forcibly removes vehicle clamp from selected vehicle. dropping it under the vehicle."
	set category = "Admin.Events"
	set popup_menu = FALSE

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/obj/vehicle/multitile/Vehicle = input("Select a vehicle.", "Remove Clamp", null, null) as null|anything in GLOB.all_multi_vehicles

	if(!istype(Vehicle))
		alert("Not a vehicle.")
		return

	Vehicle.detach_clamp()

	message_staff(WRAP_STAFF_LOG(usr, "forcibly removed vehicle clamp from [Vehicle] in [get_area(Vehicle)] ([Vehicle.x],[Vehicle.y],[Vehicle.z])."), Vehicle.x, Vehicle.y, Vehicle.z)

/client/proc/cmd_admin_repair_multitile()
	set name = "Vehicle Rejuvenate"
	set desc = "Fully restores vehicle modules and hull."
	set category = "Admin.Events"
	set popup_menu = FALSE

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/obj/vehicle/multitile/Vehicle = input("Select a vehicle.", "Rejuvenate", null, null) as null|anything in GLOB.all_multi_vehicles

	if(!istype(Vehicle))
		alert("Not a vehicle.")
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
