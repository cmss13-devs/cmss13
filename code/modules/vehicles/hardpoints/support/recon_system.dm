/obj/item/hardpoint/support/recon_system
	name = "\improper AQ-133 Acquisition System"
	desc = "A short-range Air-to-Ground LIDAR target acquisition system designed to actively track and profile non-IFF signatures in a localized range of detection."
	icon = 'icons/obj/vehicles/hardpoints/blackfoot.dmi'
	icon_state = "radar"
	disp_icon = "blackfoot"
	disp_icon_state = "radar"

	health = 250

	var/active = FALSE

/datum/action/human_action/blackfoot/recon_mode
	name = "Toggle Recon Mode"
	action_icon_state = "nightvision"

/obj/item/hardpoint/support/recon_system/on_install(obj/vehicle/multitile/blackfoot/vehicle)
	if(!vehicle)
		return

	RegisterSignal(src, COMSIG_BLACKFOOT_ACTIONS_UPDATE, PROC_REF(handle_action_update))

/obj/item/hardpoint/support/recon_system/on_uninstall(obj/vehicle/multitile/blackfoot/vehicle)
	if(!vehicle)
		return

	UnregisterSignal(src, COMSIG_BLACKFOOT_ACTIONS_UPDATE)

/obj/item/hardpoint/support/recon_system/proc/handle_action_update(datum/source, should_remove_action = FALSE)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = usr

	if(!user)
		return

	if(should_remove_action)
		remove_action(user, /datum/action/human_action/blackfoot/recon_mode)
	else
		give_action(user, /datum/action/human_action/blackfoot/recon_mode)

/datum/action/human_action/blackfoot/recon_mode/action_activate()
	var/obj/vehicle/multitile/blackfoot/vehicle = owner.interactee

	if(!istype(vehicle))
		return

	. = ..()

	for(var/obj/item/hardpoint/support/recon_system/recon_system in vehicle.hardpoints)
		if(recon_system.active)
			recon_system.deactivate()
		else
			recon_system.activate()

/obj/item/hardpoint/support/recon_system/get_icon_image(x_offset, y_offset, new_dir)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/image/icon = image(icon = disp_icon, icon_state = "[disp_icon_state]_[blackfoot_owner.get_sprite_state()]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	return icon

/obj/item/hardpoint/support/recon_system/deactivate()
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = blackfoot_owner.seats[VEHICLE_DRIVER]
	var/area/interior_area = blackfoot_owner.interior_area


	if(!user)
		return

	if(interior_area)
		interior_area.set_base_lighting(COLOR_WHITE, 255)

	active = FALSE
	blackfoot_owner.stealth_mode = FALSE

/obj/item/hardpoint/support/recon_system/proc/activate()
	set name = "Toggle Recon Mode"
	set desc = "Toggle between stowed and deployed mode."
	set category = "Vehicle"

	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/mob/user = blackfoot_owner.seats[VEHICLE_DRIVER]
	var/area/interior_area = blackfoot_owner.interior_area

	if(!user)
		return

	if(interior_area)
		interior_area.set_base_lighting("#BB3F3F", 200)

	active = TRUE
	blackfoot_owner.stealth_mode = TRUE
