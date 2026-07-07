/obj/item/hardpoint/support/artillery_module
	name = "\improper Artillery Module"
	desc = "Allows the user to look far into the distance, and offers a night vision overlay."

	icon_state = "artillery"
	disp_icon = "tank"
	disp_icon_state = "artillerymod"

	health = 250

	// Not fired/toggled through the normal active-hardpoint cycle anymore. Uses itts own verbs.
	activatable = FALSE

	var/view_buff = 10 //This way you can VV for more or less fun
	var/view_tile_offset = 2

	/// Mobs (driver and/or gunner) that currently have the magnified optics view toggled on for themselves.
	var/list/mob/living/optics_users = list()
	/// Mobs (driver and/or gunner) that currently have the night vision overlay toggled on for themselves.
	var/list/mob/living/nvg_users = list()

	/// Color used for the night vision overlay's tint.
	var/nvg_color = NV_COLOR_GREEN
	/// The alpha of darkness the user is set to see through while night vision is active.
	var/nvg_lighting_alpha = 100

/obj/item/hardpoint/support/artillery_module/proc/toggle_optics(mob/living/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is broken!"))
		return
	if(!user?.client)
		return

	if(user in optics_users)
		disable_optics(user)
	else
		enable_optics(user)

/obj/item/hardpoint/support/artillery_module/proc/enable_optics(mob/living/user)
	if(!user?.client || (user in optics_users))
		return
	optics_users += user

	var/obj/vehicle/multitile/vehicle = owner
	if(user == vehicle.seats[VEHICLE_GUNNER])
		apply_gunner_view(user)
	else
		apply_driver_view(user)

/obj/item/hardpoint/support/artillery_module/proc/disable_optics(mob/living/user)
	if(!(user in optics_users))
		return
	optics_users -= user
	reset_view(user)

/// Zooms the gunner's view and shifts it forward along the turret's current facing.
/obj/item/hardpoint/support/artillery_module/proc/apply_gunner_view(mob/living/user)
	if(!user || !user.client)
		return

	user.client.change_view(view_buff, owner)

	var/atom/holder = owner
	for(var/obj/item/hardpoint/holder/tank_turret/turret in owner.hardpoints)
		holder = turret
		break

	switch(holder.dir)
		if(NORTH)
			user.client.set_pixel_x(0)
			user.client.set_pixel_y(view_tile_offset * 32)
		if(SOUTH)
			user.client.set_pixel_x(0)
			user.client.set_pixel_y(-1 * view_tile_offset * 32)
		if(EAST)
			user.client.set_pixel_x(view_tile_offset * 32)
			user.client.set_pixel_y(0)
		if(WEST)
			user.client.set_pixel_x(-1 * view_tile_offset * 32)
			user.client.set_pixel_y(0)

/// Zooms the driver's view, centered on the tank instead of shifted forwards
/obj/item/hardpoint/support/artillery_module/proc/apply_driver_view(mob/living/user)
	if(!user || !user.client)
		return
	user.client.change_view(view_buff, owner)
	user.client.set_pixel_x(0)
	user.client.set_pixel_y(0)

/obj/item/hardpoint/support/artillery_module/proc/reset_view(mob/living/user)
	if(!user || !user.client)
		return
	user.client.change_view(8, owner)
	user.client.set_pixel_x(0)
	user.client.set_pixel_y(0)

/obj/item/hardpoint/support/artillery_module/proc/toggle_nvg(mob/living/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is broken!"))
		return
	if(!ishuman(user))
		return

	if(user in nvg_users)
		disable_nvg(user)
	else
		enable_nvg(user)

/obj/item/hardpoint/support/artillery_module/proc/enable_nvg(mob/living/carbon/human/user)
	if(!ishuman(user) || (user in nvg_users))
		return
	nvg_users += user

	RegisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT, PROC_REF(on_update_sight))
	user.add_client_color_matrix("tank_artillery_nvg", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string(nvg_color)))
	user.overlay_fullscreen("tank_artillery_nvg", /atom/movable/screen/fullscreen/flash/noise/nvg)
	user.overlay_fullscreen("tank_artillery_nvg_blur", /atom/movable/screen/fullscreen/brute/nvg, 3)
	user.update_sight()
	to_chat(user, SPAN_NOTICE("You activate \the [src]'s night vision overlay."))

/obj/item/hardpoint/support/artillery_module/proc/disable_nvg(mob/living/carbon/human/user)
	if(!(user in nvg_users))
		return
	nvg_users -= user

	UnregisterSignal(user, COMSIG_HUMAN_POST_UPDATE_SIGHT)
	user.remove_client_color_matrix("tank_artillery_nvg", 1 SECONDS)
	user.clear_fullscreen("tank_artillery_nvg", 0.5 SECONDS)
	user.clear_fullscreen("tank_artillery_nvg_blur", 0.5 SECONDS)
	user.update_sight()
	to_chat(user, SPAN_NOTICE("You deactivate \the [src]'s night vision overlay."))

/obj/item/hardpoint/support/artillery_module/proc/on_update_sight(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	if(nvg_lighting_alpha < 255)
		user.see_in_dark = 12
	user.lighting_alpha = nvg_lighting_alpha
	user.sync_lighting_plane_alpha()

/// Clears both effects off of one specific user
/obj/item/hardpoint/support/artillery_module/proc/clear_user_effects(mob/living/user)
	disable_optics(user)
	disable_nvg(user)

/// Clears both effects off of everyone currently using them if the module gets broken or uninstalled when used
/obj/item/hardpoint/support/artillery_module/deactivate()
	for(var/mob/living/user as anything in optics_users.Copy())
		disable_optics(user)
	for(var/mob/living/user as anything in nvg_users.Copy())
		disable_nvg(user)

/obj/item/hardpoint/support/artillery_module/on_uninstall(obj/vehicle/multitile/vehicle)
	deactivate()
	..()
