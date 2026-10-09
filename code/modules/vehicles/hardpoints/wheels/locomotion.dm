/obj/item/hardpoint/locomotion
	name = "locomotive aid hardpoint"
	desc = "I help the vehicle move :)"
	gender = PLURAL // it's always wheels or treads

	damage_multiplier = 0.15
	var/acid_resistant = FALSE //reduces damage dealt by acid spray

	/// world.time of the last acid spray hit this locomotion module took.
	var/last_spray_hit_time = 0
	/// How many acid-spray hits in a row, each one divides the next hit's damage further.
	var/spray_hit_streak = 0

	// these are used to change all vehicle's movement characteristics, 0 means no change
	var/move_delay = VEHICLE_SPEED_FASTNORMAL
	var/move_max_momentum = 0
	var/move_momentum_build_factor = 0
	var/move_turn_momentum_loss_factor = 0

	/// How much of a turf's traction deviation from neutral this locomotion type actually feels.
	var/traction_dampening = TRACTION_DAMPENING_WHEELS

	/// Acceleration malus for gear-transmission locomotion, multiplies torque. 1 is no penalty.
	var/gear_torque_mult = 1

/// Only swaps to the damaged sprite once fully destroyed, unlike other mounted parts.
/obj/item/hardpoint/locomotion/get_mounted_damage_suffix()
	return health <= 0 ? 1 : 0

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

/**
 * Dampens a turf's raw traction value by how much this locomotion type feels terrain.
 *
 * Arguments:
 * * turf_traction = Raw traction value of a turf (or the average of several).
 *
 * Returns:
 * * Effective traction multiplier, pulled toward 1.0 by (1 - traction_dampening).
 */
/obj/item/hardpoint/locomotion/proc/get_effective_traction(turf_traction)
	return 1 + (turf_traction - 1) * traction_dampening

//unique proc for locomotion modules, taking damage from acid spray and toxic waters and other stuff on ground
/obj/item/hardpoint/locomotion/proc/handle_acid_damage(atom/A)
	if(health <= 0)
		return
	var/damage_amount = 0
	if(istype(A, /obj/effect/xenomorph/spray))
		var/obj/effect/xenomorph/spray/acid = A

		damage_amount = acid.damage_amount
		//First we check source of acid. Due to traps generating 3x3 acid spray field and triggering only when at least 4 tiles
		//of vehicle enter the spray spawn area, it deals a huge amount of damage. But simply nerfing damage will also nerf it for
		//acid spraying castes like spitters and praetorians, which is not ideal.
		if(acid.cause_data.cause_name == "resin acid trap")
			damage_amount = floor(damage_amount / 3)

		// Repeated hits from the same spray do progressively less damage.
		if(world.time - last_spray_hit_time <= ACID_SPRAY_STREAK_WINDOW)
			spray_hit_streak++
		else
			spray_hit_streak = 0
		last_spray_hit_time = world.time
		damage_amount /= (spray_hit_streak + 1)

	else if(istype(A, /obj/effect/blocker/water/toxic))
		//multitile vehicles are, well, multitile and will be receiving damage for each tile, so damage is low per tile.
		damage_amount = 10

	else if(istype(A, /obj/effect/xenomorph/acid_damage_delay/boiler_landmine))
		var/obj/effect/xenomorph/acid_damage_delay/boiler_landmine/mine = A
		damage_amount = mine.damage * (mine.empowered ? 1.25 : 1)

	else if(istype(A, /obj/effect/lingering_acid))
		var/obj/effect/lingering_acid/puddle = A
		damage_amount = puddle.damage

	//then we check whether this locomotion module is acid-resistant
	if(acid_resistant)
		damage_amount = damage_amount / 2

	take_damage(damage_amount, "acid", A)

	if(!(world.time % 3))
		playsound(A, 'sound/bullets/acid_impact1.ogg', 10, 1)

	if(owner)
		owner.healthcheck()
