/obj/item/hardpoint/locomotion/treads
	name = "Treads"
	desc = "Integral to the movement of the vehicle"

	icon_state = "treads"
	disp_icon = "tank"
	disp_icon_state = "treads"

	slot = HDPT_TREADS

	health = 500

	move_speed = VEHICLE_SPEED_FASTER

/obj/item/hardpoint/locomotion/treads/robust
	name = "robus-treads"
	desc = "These treads are made of a tougher material and are more durable. However, the added weight slows the tank down slightly."

	health = 750

	move_speed = VEHICLE_SPEED_FASTNORMAL

/obj/item/hardpoint/locomotion/treads/on_install(var/obj/vehicle/multitile/V)
	for(var/obj/item/hardpoint/support/overdrive_enhancer/OD in V.hardpoints)
		if(OD.health > 0)
			OD.apply_buff(V)
	V.move_delay = move_speed

/obj/item/hardpoint/locomotion/treads/deactivate()
	for(var/obj/item/hardpoint/support/overdrive_enhancer/OD in owner.hardpoints)
		if(OD.health > 0)
			OD.remove_buff(owner)
	owner.move_delay = initial(owner.move_delay)