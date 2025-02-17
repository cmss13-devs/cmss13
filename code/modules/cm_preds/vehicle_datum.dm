// Used to lock/unlock the vehicle doors to anyone without proper access
/datum/action/vehicle/multitile/proc/toggle_door_lock()
	listen_signal = COMSIG_KB_VEHICLE_TOGGLE_LOCKS


/datum/action/vehicle/multitile/proc/get_status_info()
	listen_signal = COMSIG_KB_VEHICLE_GET_STATUS

/datum/action/vehicle/multitile/proc/cycle_hardpoint()
	listen_signal = COMSIG_KB_VEHICLE_CHANGE_SELECTED_WEAPON

/datum/action/vehicle/multitile/proc/activate_horn() // cant wait for this to be annoying as hell
	listen_signal = COMSIG_KB_VEHICLE_ACTIVATE_HORN

/datum/action/vehicle/multitile/proc/reload_firing_port_weapon()
	listen_signal = COMSIG_KB_VEHICLE_RELOAD_WEAPON
