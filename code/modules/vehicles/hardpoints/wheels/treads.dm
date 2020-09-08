/obj/item/hardpoint/locomotion/treads
	name = "Treads"
	desc = "Integral to the movement of the vehicle"

	icon_state = "treads"
	disp_icon = "tank"
	disp_icon_state = "treads"

	slot = HDPT_TREADS

	point_cost = 300
	health = 500

	move_speed = VEHICLE_SPEED_FASTER

/obj/item/hardpoint/locomotion/treads/robust
	name = "robus-treads"
	desc = "These treads are made of a tougher material and are more durable. However, the added weight slows the tank down slightly."

	point_cost = 350
	health = 750

	move_speed = VEHICLE_SPEED_FASTNORMAL
