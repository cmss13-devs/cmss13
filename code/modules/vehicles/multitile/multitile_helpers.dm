
/*
This one currently doesn't work. Will rework adn readd it during interior update.
/client/proc/remove_players_from_vehicle()
	set name = "Remove All From Tank"
	set category = "Admin"

	for(var/obj/vehicle/multitile/R in view())
		R.remove_all_players()
		message_staff("[src] forcibly removed all players from [R]")
*/
/client/proc/cmd_admin_remove_clamp(obj/vehicle/multitile/M as obj in all_multi_vehicles)
	set name = "Vehicle Remove Clamp"
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	if(!istype(M))
		alert("Not a vehicle.")
		return

	M.detach_clamp()

	message_staff(WRAP_STAFF_LOG(usr, "forcibly removed vehicle clamp from [M] in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

/client/proc/cmd_admin_repair_multitile(obj/vehicle/multitile/M as obj in all_multi_vehicles)
	set name = "Vehicle Rejuvenate"
	set category = null

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	if(!istype(M))
		alert("Not a vehicle.")
		return

	M.rejuvenate_vehicle()

	message_staff(WRAP_STAFF_LOG(usr, "arepaired [M] in [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)

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
