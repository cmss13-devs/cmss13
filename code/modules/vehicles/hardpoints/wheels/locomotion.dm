/obj/item/hardpoint/locomotion
	name = "locomotive aid hardpoint"
	desc = "i help the vehicle move :)"

	damage_multiplier = 0.15

	// these are used to change all vehicle's movement characteristics, 0 means no change
	var/move_delay = VEHICLE_SPEED_FASTNORMAL
	var/move_max_momentum = 0
	var/move_momentum_build_factor = 0
	var/move_turn_momentum_loss_factor = 0

/obj/item/hardpoint/locomotion/deactivate()
	owner.move_delay = initial(owner.move_delay)
	owner.move_max_momentum = initial(owner.move_max_momentum)
	owner.move_momentum_build_factor = initial(owner.move_momentum_build_factor)
	owner.move_turn_momentum_loss_factor = initial(owner.move_turn_momentum_loss_factor)

/obj/item/hardpoint/locomotion/on_install(var/obj/vehicle/multitile/V)
	if(move_delay)
		V.move_delay = move_delay
	if(move_max_momentum)
		V.move_max_momentum = move_max_momentum
	if(move_momentum_build_factor)
		V.move_momentum_build_factor = move_momentum_build_factor
	if(move_turn_momentum_loss_factor)
		V.move_turn_momentum_loss_factor = move_turn_momentum_loss_factor

/obj/item/hardpoint/locomotion/on_uninstall(var/obj/vehicle/multitile/V)
	deactivate()
