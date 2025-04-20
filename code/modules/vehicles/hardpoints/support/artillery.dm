/obj/item/hardpoint/support/artillery_module
	name = "\improper Artillery Module"
	desc = "Allows the user to look far into the distance."

	icon_state = "artillery"
	disp_icon = "tank"
	disp_icon_state = "artillerymod"

	health = 250

	activatable = TRUE

	var/is_active = 0
	var/view_buff = 10 //This way you can VV for more or less fun
	var/view_tile_offset = 7

/obj/item/hardpoint/support/artillery_module/handle_fire(atom/target, mob/living/user, params)
	if(!user.client)
		return

	if(is_active)
		user.client.change_view(8, owner)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		is_active = FALSE
		return

	var/atom/holder = owner
	for(var/obj/item/hardpoint/holder/tank_turret/T in owner.hardpoints)
		holder = T
		break

	user.client.change_view(view_buff, owner)
	is_active = TRUE

	switch(holder.dir)
		if(NORTH)
			user.client.pixel_x = 0
			user.client.pixel_y = view_tile_offset * 32
		if(SOUTH)
			user.client.pixel_x = 0
			user.client.pixel_y = -1 * view_tile_offset * 32
		if(EAST)
			user.client.pixel_x = view_tile_offset * 32
			user.client.pixel_y = 0
		if(WEST)
			user.client.pixel_x = -1 * view_tile_offset * 32
			user.client.pixel_y = 0

/obj/item/hardpoint/support/artillery_module/deactivate()
	if(!is_active)
		return

	var/obj/vehicle/multitile/C = owner
	for(var/seat in C.seats)
		if(!ismob(C.seats[seat]))
			continue
		var/mob/user = C.seats[seat]
		if(!user.client)
			continue
		user.client.change_view(GLOB.world_view_size, owner)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	is_active = FALSE

/obj/item/hardpoint/support/artillery_module/try_fire(target, user, params)
	if(health <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] is broken!"))
		return NONE

	return handle_fire(target, user, params)
