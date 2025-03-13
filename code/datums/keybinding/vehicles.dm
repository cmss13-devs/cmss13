/datum/keybinding/vehicles
	category = CATEGORY_VEHICLE
	weight = WEIGHT_VEHICLE

/datum/keybinding/vehicles/can_use(client/user)
	if(!ishuman(user.mob))
		return FALSE
	var/obj/vehicle/multitile/vehicle_check = user.mob.interactee
	if(!istype(vehicle_check))
		return FALSE

	return TRUE

/datum/keybinding/vehicles/toggle_door_lock
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Toggle door locks"
	full_name = "Toggle Door Locks"
	keybind_signal = COMSIG_KB_VEHICLE_TOGGLE_LOCKS

/datum/keybinding/vehicles/toggle_door_lock/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_get = user.mob.interactee
	vehicle_get.toggle_door_lock()
	return TRUE

/datum/keybinding/vehicles/get_vehicle_status
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "See vehicle status"
	full_name = "See Vehicle Status"
	keybind_signal = COMSIG_KB_VEHICLE_GET_STATUS

/datum/keybinding/vehicles/get_vehicle_status/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.get_status_info()
	return TRUE

/datum/keybinding/vehicles/change_selected_hardpoint
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Change Active Hardpoint"
	full_name = "Change Active Hardpoint"
	keybind_signal = COMSIG_KB_VEHICLE_CHANGE_SELECTED_WEAPON

/datum/keybinding/vehicles/change_selected_hardpoint/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.cycle_hardpoint()

/datum/keybinding/vehicles/activate_horn
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Activate horn"
	full_name = "Activate Horn"
	keybind_signal = COMSIG_KB_VEHICLE_ACTIVATE_HORN

/datum/keybinding/vehicles/activate_horn/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.activate_horn()
	return TRUE

/datum/keybinding/vehicles/reload_weapon
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Reload weapon"
	full_name = "Reload Weapon"
	keybind_signal = COMSIG_KB_VEHICLE_RELOAD_WEAPON

/datum/keybinding/vehicles/reload_weapon/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.reload_firing_port_weapon()
	return TRUE
