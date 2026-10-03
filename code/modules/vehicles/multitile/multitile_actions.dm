/**
 * Shared base for a vehicle's driver/gunner HUD action buttons.
 * Resolves the vehicle via the seat chair rather than a stored reference, so it stays correct
 * across re-buckles.
 */
/datum/action/human_action/vehicle_action
	name = "Vehicle Action"

// Deliberately not auto-cleaning up via COMSIG_MOB_RESET_VIEW. That signal fires on every seat
// change, not just unbuckle, so it would self-destruct the button the instant it's granted.
// remove_seated_verbs() already handles cleanup on unbuckle.
/datum/action/human_action/vehicle_action/give_to(mob/user)
	. = ..()
	update_button_icon()

/datum/action/human_action/vehicle_action/proc/get_vehicle()
	var/mob/living/carbon/human/user = owner
	if(!istype(user) || !istype(user.buckled, /obj/structure/bed/chair/comfy/vehicle))
		return null
	var/obj/structure/bed/chair/comfy/vehicle/chair = user.buckled
	return chair.vehicle

// 1) Door Lock -------------------------------------------------------------------------

/datum/action/human_action/vehicle_action/toggle_door_lock
	name = "Toggle Door Locks"
	action_icon_state = "id_lock_unlocked"

/datum/action/human_action/vehicle_action/toggle_door_lock/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	action_icon_state = (vehicle && vehicle.door_locked) ? "id_lock_locked" : "id_lock_unlocked"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_door_lock/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.toggle_door_lock(owner)
	update_button_icon()

// 2) Cycle Active Hardpoint -------------------------------------------------------------

/datum/action/human_action/vehicle_action/cycle_hardpoint
	name = "Cycle Active Hardpoint"
	action_icon_state = "tank_cycle_primary"

/datum/action/human_action/vehicle_action/cycle_hardpoint/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/seat = vehicle?.get_mob_seat(owner)
	var/obj/item/hardpoint/current = seat ? vehicle.active_hp[seat] : null
	action_icon_state = istype(current, /obj/item/hardpoint/secondary) ? "tank_cycle_secondary" : "tank_cycle_primary"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/cycle_hardpoint/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.cycle_hardpoint(owner)
	update_button_icon()

// 3) Vehicle Ignition -----------------------------------------------------------------------------

/datum/action/human_action/vehicle_action/toggle_engine
	name = "Toggle Engine"
	action_icon_state = "engine"

/datum/action/human_action/vehicle_action/toggle_engine/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	action_icon_state = (vehicle && vehicle.engine_on) ? "engine_off" : "engine"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_engine/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.toggle_engine(owner)
	update_button_icon()

// 4) Vehicle Phone -----------------------------------------------------------------------------------

/**
 * Lets seated crew answer/place/hang up the vehicle's mounted phone without leaving their seat.
 * The button always shows the phone's own sprite, forced south-facing, and never touches the
 * actual in-game object's icon or dir.
 */
/datum/action/human_action/vehicle_action/use_phone
	name = "Use Vehicle Phone"
	action_icon_state = "wall_phone"

// Registers for the phone's update signal so the button flips to "ringing" the instant a call
// comes in, rather than waiting on the next unrelated icon refresh. Unregistered in remove_from().
/datum/action/human_action/vehicle_action/use_phone/give_to(mob/user)
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(vehicle?.phone)
		RegisterSignal(vehicle.phone, COMSIG_TRANSMITTER_UPDATE_ICON, PROC_REF(on_phone_icon_update))

/datum/action/human_action/vehicle_action/use_phone/remove_from(mob/L)
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(vehicle?.phone)
		UnregisterSignal(vehicle.phone, COMSIG_TRANSMITTER_UPDATE_ICON)
	return ..()

/datum/action/human_action/vehicle_action/use_phone/proc/on_phone_icon_update()
	SIGNAL_HANDLER
	update_button_icon()

/datum/action/human_action/vehicle_action/use_phone/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/obj/structure/transmitter/phone = vehicle?.phone
	var/base = phone?.base_icon_state || "wall_phone"

	if(phone && phone.attached_to && phone.attached_to.loc != phone)
		action_icon_state = "[base]_ear" // picked up/off the hook - mid-call
	else if(phone?.inbound_call)
		action_icon_state = "[base]_ring" // ringing, not yet answered
	else
		action_icon_state = base // idle, on the hook

	button.overlays.Cut()
	button.overlays += image('icons/obj/structures/phone.dmi', button, action_icon_state) // dir defaults to SOUTH

/**
 * Off the hook, hangs up. Otherwise defers to the phone's own attack_hand(), same as clicking it.
 */
/datum/action/human_action/vehicle_action/use_phone/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/obj/structure/transmitter/phone = vehicle?.phone
	if(!phone)
		return

	if(phone.attached_to && phone.attached_to.loc != phone)
		phone.recall_phone()
	else
		phone.attack_hand(owner)
	update_button_icon()

// 5) Hardpoint Fire Mode (Flamer Glob/Stream) -----------------------------------------------------

/**
 * Toggles a flamer hardpoint between FLAME_MODE_GLOB and FLAME_MODE_STREAM. Only granted while
 * this seat's active hardpoint actually is a flamer.
 */
/datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode
	name = "Toggle Fire Mode"
	action_icon_state = "nozzle_ball"

/datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/obj/item/hardpoint/current = vehicle?.get_mob_hp(owner)
	action_icon_state = (current?.get_flame_mode() == FLAME_MODE_STREAM) ? "nozzle_spray" : "nozzle_ball"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/obj/item/hardpoint/current = vehicle?.get_mob_hp(owner)
	current?.toggle_fire_mode(owner)
	update_button_icon()

// 6) Cruise Control ---------------------------------------------------------------------------

/**
 * Only meaningful under Complex vehicle acceleration. on_driver_prefs_changed() listens for the
 * driver flipping that preference live and refreshes this button immediately.
 */
/datum/action/human_action/vehicle_action/toggle_cruise_control
	name = "Toggle Cruise Control"
	action_icon_state = "cruise_control"

/datum/action/human_action/vehicle_action/toggle_cruise_control/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	action_icon_state = (vehicle && vehicle.cruise_control_enabled) ? "cruise_control_off" : "cruise_control"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_cruise_control/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.toggle_cruise_control()
	update_button_icon()

// 7) Cruise Control Granularity -----------------------------------------------------------------

/// Same driver-only, Complex-acceleration-only availability as toggle_cruise_control above.
/datum/action/human_action/vehicle_action/set_cruise_control_granularity
	name = "Set Cruise Control Granularity"
	action_icon_state = "cruise_control_granularity"

/datum/action/human_action/vehicle_action/set_cruise_control_granularity/update_button_icon()
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/set_cruise_control_granularity/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.set_cruise_control_granularity()

// 8) IFF Toggle -------------------------------------------------------------------------------------

/datum/action/human_action/vehicle_action/toggle_iff
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_off"

/datum/action/human_action/vehicle_action/toggle_iff/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	action_icon_state = (vehicle && vehicle.iff_online) ? "iff_toggle_on" : "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_iff/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.toggle_iff_module(owner)
	update_button_icon()

// 9) Turret Rotation and Hardpoint Safety ----------------------------------------------------

/datum/action/human_action/vehicle_action/toggle_gyro
	name = "Turret Rotation and Hardpoint Safety"
	action_icon_state = "turret_gyro"

/datum/action/human_action/vehicle_action/toggle_gyro/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/obj/item/hardpoint/turret = vehicle?.get_gyro_hardpoint()
	action_icon_state = (turret && turret.turret_safety_on) ? "turret_gyro_off" : "turret_gyro"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_gyro/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.toggle_turret_safety(owner)
	update_button_icon()

// 10) Slave Secondary to Driver ------------------------------------------------------------

/datum/action/human_action/vehicle_action/slave_secondary
	name = "Slave Secondary to Driver"
	action_icon_state = "driver_slave"

/datum/action/human_action/vehicle_action/slave_secondary/update_button_icon()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	var/obj/item/hardpoint/secondary/current = vehicle?.get_slavable_secondary()
	action_icon_state = (current && current.self_gimballed) ? "driver_slave_off" : "driver_slave"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/slave_secondary/action_activate()
	. = ..()
	var/obj/vehicle/multitile/vehicle = get_vehicle()
	if(!vehicle)
		return
	vehicle.toggle_slave_secondary_to_driver(owner)
	update_button_icon()
