/// Tank-only variant of get_vehicle(), typed and filtered down to the tank subtype.
/datum/action/human_action/vehicle_action/proc/get_tank()
	var/obj/vehicle/multitile/tank/vehicle = get_vehicle()
	return istype(vehicle) ? vehicle : null

// 1) Artillery Module: Night Vision -------------------------------------------------

/datum/action/human_action/vehicle_action/toggle_nvg
	name = "Toggle Night Vision"
	action_icon_state = "nvg"

/datum/action/human_action/vehicle_action/toggle_nvg/update_button_icon()
	var/obj/vehicle/multitile/tank/vehicle = get_tank()
	var/obj/item/hardpoint/support/artillery_module/AM = vehicle?.get_artillery_module()
	action_icon_state = (AM && (owner in AM.nvg_users)) ? "nvg_off" : "nvg"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_nvg/action_activate()
	. = ..()
	var/obj/vehicle/multitile/tank/vehicle = get_tank()
	if(!vehicle)
		return
	vehicle.toggle_artillery_nvg(owner)
	update_button_icon()

// 2) Artillery Module: Range (magnified optics) --------------------------------------

/datum/action/human_action/vehicle_action/toggle_artillery_range
	name = "Toggle Artillery Range"
	action_icon_state = "zoom_scope"

/datum/action/human_action/vehicle_action/toggle_artillery_range/update_button_icon()
	var/obj/vehicle/multitile/tank/vehicle = get_tank()
	var/obj/item/hardpoint/support/artillery_module/AM = vehicle?.get_artillery_module()
	action_icon_state = (AM && (owner in AM.optics_users)) ?"unzoom_scope" : "zoom_scope"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/human_action/vehicle_action/toggle_artillery_range/action_activate()
	. = ..()
	var/obj/vehicle/multitile/tank/vehicle = get_tank()
	if(!vehicle)
		return
	vehicle.toggle_artillery_optics(owner)
	update_button_icon()

