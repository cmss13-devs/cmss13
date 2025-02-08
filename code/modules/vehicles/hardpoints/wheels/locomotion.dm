/obj/item/hardpoint/locomotion
	name = "locomotive aid hardpoint"
	desc = "i help the vehicle move :)"
	gender = PLURAL // it's always wheels or treads

	damage_multiplier = 0.15
	var/acid_resistant = FALSE //reduces damage dealt by acid spray

	// these are used to change all vehicle's movement characteristics, 0 means no change
	var/move_delay = VEHICLE_SPEED_FASTNORMAL
	var/move_max_momentum = 0
	var/move_momentum_build_factor = 0
	var/move_turn_momentum_loss_factor = 0

/obj/item/hardpoint/locomotion/p_are(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "is"
	if(temp_gender == PLURAL)
		. = "are"

/obj/item/hardpoint/locomotion/p_they(capitalized, temp_gender)
	if(!temp_gender)
		temp_gender = gender
	. = "it"
	if(temp_gender == PLURAL)
		. = "they"
	if(capitalized)
		. = capitalize(.)

/obj/item/hardpoint/locomotion/deactivate()
	owner.move_delay = initial(owner.move_delay)
	owner.move_max_momentum = initial(owner.move_max_momentum)
	owner.move_momentum_build_factor = initial(owner.move_momentum_build_factor)
	owner.move_turn_momentum_loss_factor = initial(owner.move_turn_momentum_loss_factor)
	owner.next_move = world.time + move_delay

/obj/item/hardpoint/locomotion/on_install(obj/vehicle/multitile/V)
	if(move_delay)
		V.move_delay = move_delay
	if(move_max_momentum)
		V.move_max_momentum = move_max_momentum
	if(move_momentum_build_factor)
		V.move_momentum_build_factor = move_momentum_build_factor
	if(move_turn_momentum_loss_factor)
		V.move_turn_momentum_loss_factor = move_turn_momentum_loss_factor
	owner.next_move = world.time + move_delay

/obj/item/hardpoint/locomotion/on_uninstall(obj/vehicle/multitile/V)
	deactivate()

//unique proc for locomotion modules, taking damage from acid spray and toxic waters and other stuff on ground
/obj/item/hardpoint/locomotion/proc/handle_acid_damage(atom/A)
	if(health <= 0)
		return
	var/take_damage = 0
	if(istype(A, /obj/effect/xenomorph/spray))
		var/obj/effect/xenomorph/spray/acid = A

		take_damage = acid.damage_amount
		//First we check source of acid. Due to traps generating 3x3 acid spray field and triggering only when at least 4 tiles
		//of vehicle enter the spray spawn area, it deals a huge amount of damage. But simply nerfing damage will also nerf it for
		//acid spraying castes like spitters and praetorians, which is not ideal.
		if(acid.cause_data.cause_name == "resin acid trap")
			take_damage = floor(take_damage / 3)

	else if(istype(A, /obj/effect/blocker/toxic_water))
		//multitile vehicles are, well, multitile and will be receiving damage for each tile, so damage is low per tile.
		take_damage = 10

	//then we check whether this locomotion module is acid-resistant
	if(acid_resistant)
		take_damage = take_damage / 2
	health -= take_damage

	if(!(world.time % 3))
		playsound(A, 'sound/bullets/acid_impact1.ogg', 10, 1)

	if(owner)
		owner.healthcheck()
