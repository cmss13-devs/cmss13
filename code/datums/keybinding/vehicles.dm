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

/datum/keybinding/vehicles/shift_gear_up
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Shift gear up"
	full_name = "Shift Gear Up"
	keybind_signal = COMSIG_KB_VEHICLE_SHIFT_GEAR_UP

/datum/keybinding/vehicles/shift_gear_up/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.cycle_gear_up()
	return TRUE

/datum/keybinding/vehicles/shift_gear_down
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Shift gear down"
	full_name = "Shift Gear Down"
	keybind_signal = COMSIG_KB_VEHICLE_SHIFT_GEAR_DOWN

/datum/keybinding/vehicles/shift_gear_down/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.cycle_gear_down()
	return TRUE

/datum/keybinding/vehicles/toggle_cruise_control
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Toggle cruise control"
	full_name = "Toggle Cruise Control"
	keybind_signal = COMSIG_KB_VEHICLE_TOGGLE_CRUISE_CONTROL

/datum/keybinding/vehicles/toggle_cruise_control/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.toggle_cruise_control()
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

/**
 * Toggles the fire mode of hardpoints with more than one fire mode. currently only used for the primary and secondary
 * flamers
 */
/datum/keybinding/vehicles/toggle_hardpoint_fire_mode
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Toggle hardpoint fire mode"
	full_name = "Toggle Hardpoint Fire Mode"
	keybind_signal = COMSIG_KB_VEHICLE_TOGGLE_HARDPOINT_FIRE_MODE

/datum/keybinding/vehicles/toggle_hardpoint_fire_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	var/obj/item/hardpoint/HP = vehicle_user.get_mob_hp(user.mob)
	if(!HP)
		return
	HP.toggle_fire_mode(user.mob)
	// This bypasses the action button, so refresh its icon manually.
	for(var/datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode/action in user.mob.actions)
		action.update_button_icon()
	return TRUE

/// Same gunner-only toggle as the right-click verb and ALT+Click shortcut.
/datum/keybinding/vehicles/toggle_turret_safety
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "Toggle turret safety"
	full_name = "Toggle Turret Rotation and Hardpoint Safety"
	keybind_signal = COMSIG_KB_VEHICLE_TOGGLE_TURRET_SAFETY

/datum/keybinding/vehicles/toggle_turret_safety/down(client/user)
	. = ..()
	if(.)
		return
	var/obj/vehicle/multitile/vehicle_user = user.mob.interactee
	vehicle_user.toggle_turret_safety(user.mob)
	// Same icon refresh gap as toggle_hardpoint_fire_mode above.
	for(var/datum/action/human_action/vehicle_action/toggle_gyro/action in user.mob.actions)
		action.update_button_icon()
	return TRUE
