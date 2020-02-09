/obj/item/hardpoint/locomotion
	name = "locomotive aid hardpoint"
	desc = "i help the vehicle move :)"

	damage_multiplier = 0.15

	// How fast the vehicle goes when these wheels/treads/whatever are attached
	var/move_speed = VEHICLE_SPEED_NORMAL

/obj/item/hardpoint/locomotion/deactivate()
	owner.move_delay = initial(owner.move_delay)

/obj/item/hardpoint/locomotion/on_install(var/obj/vehicle/multitile/V)
	V.move_delay = move_speed

/obj/item/hardpoint/locomotion/on_uninstall(var/obj/vehicle/multitile/V)
	deactivate()
