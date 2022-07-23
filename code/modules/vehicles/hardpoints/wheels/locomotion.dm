/obj/item/hardpoint/locomotion
	name = "locomotive aid hardpoint"
	desc = "i help the vehicle move :)"

	damage_multiplier = 0.15
	var/acid_resistant = FALSE	//reduces damage dealt by acid spray

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
	owner.next_move = world.time + move_delay

/obj/item/hardpoint/locomotion/on_install(var/obj/vehicle/multitile/V)
	if(move_delay)
		V.move_delay = move_delay
	if(move_max_momentum)
		V.move_max_momentum = move_max_momentum
	if(move_momentum_build_factor)
		V.move_momentum_build_factor = move_momentum_build_factor
	if(move_turn_momentum_loss_factor)
		V.move_turn_momentum_loss_factor = move_turn_momentum_loss_factor
	owner.next_move = world.time + move_delay

/obj/item/hardpoint/locomotion/on_uninstall(var/obj/vehicle/multitile/V)
	deactivate()

//unique proc for locomotion modules, taking damage from acid spray on ground
/obj/item/hardpoint/locomotion/proc/handle_acid_spray(var/obj/effect/xenomorph/spray/acid)
	var/take_damage = acid.damage_amount
	//First we check source of acid. Due to traps generating 3x3 acid spray field and triggering only when at least 4 tiles
	//of vehicle enter the spray spawn area, it deals a huge amount of damage. But simply nerfing damage will also nerf it for
	//acid spraying castes like spitters and praetorians, which is not ideal.
	if(acid.cause_data.cause_name == "resin acid trap")
		take_damage = round(take_damage / 3)
	//then we check whether this locomotion module is acid-resistant
	if(acid_resistant)
		take_damage = take_damage / 2
	health -= take_damage
	if(owner)
		owner.healthcheck()
