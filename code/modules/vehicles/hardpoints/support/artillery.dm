/obj/item/hardpoint/artillery_module
	name = "Artillery Module"
	desc = "Allows the user to look far into the distance."

	icon_state = "artillery"
	disp_icon = "tank"
	disp_icon_state = "artillerymod"

	slot = HDPT_SUPPORT
	hdpt_layer = HDPT_LAYER_SUPPORT
	activatable = TRUE

	point_cost = 600
	health = 250
	damage_multiplier = 0.075

	activatable = TRUE

	var/is_active = 0
	var/view_buff = 12 //This way you can VV for more or less fun
	var/view_tile_offset = 5

/obj/item/hardpoint/artillery_module/activate(var/mob/user, var/atom/A)
	if(!user.client)
		return

	if(is_active)
		user.client.change_view(7)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		is_active = FALSE
		return

	user.client.change_view(view_buff)
	is_active = TRUE

	var/obj/vehicle/multitile/tank/C = owner
	switch(C.dir)
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

/obj/item/hardpoint/artillery_module/deactivate()
	if(!is_active)
		return

	var/obj/vehicle/multitile/C = owner
	for(var/seat in C.seats)
		if(!ismob(C.seats[seat]))
			continue
		var/mob/user = C.seats[seat]
		if(!user.client) continue
		user.client.change_view(7)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	is_active = FALSE

/obj/item/hardpoint/artillery_module/can_activate()
	if(health <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] is broken!"))
		return FALSE
	return TRUE
