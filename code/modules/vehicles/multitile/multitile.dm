/*
	As a rule of thumb, when defining some sort of coordinates for vehicles,
	define them as they should be when the vehicle is facing SOUTH (the BYOND default).

	This applies to for example interior entrances and hardpoint origins
*/

var/global/list/all_multi_vehicles = list()

/obj/vehicle/multitile
	name = "multitile vehicle"
	desc = "Get inside to operate the vehicle."

	health = 1000

	//How big the vehicle is in pixels, defined facing SOUTH, which is the byond default (i.e. a 3x3 vehicle is going to be 96x96) ~Cakey
	bound_width = 32
	bound_height = 32

	//How much to offset the hitbox of the vehicle from the bottom-left source, defined facing SOUTH, which is the byond default (i.e. a 3x3 vehicle should have x/y at -32/-32) ~Cakey
	bound_x = 0
	bound_y = 0

	// List of verbs to give when a mob is seated in each seat type
	var/list/seat_verbs

	move_delay = VEHICLE_SPEED_SLOW
	// The next world.time when the vehicle can move
	var/next_move = 0
	// How much momentum the vehicle has. Increases by 1 each move
	var/momentum = 0
	// How much momentum the vehicle can achieve
	var/max_momentum = 4
	// Determines how much slower the vehicle is when it lacks its full momentum
	// When the vehicle has 0 momentum, it's movement delay will be move_delay * momentum_build_factor
	// The movement delay gradually reduces up to move_delay when momentum increases
	var/momentum_build_factor = 1.3
	// How much momentum is lost when turning/rotating the vehicle
	var/turn_momentum_loss_factor = 0.5
	// When the vehicle has momentum, the user may buffer a move input just before the move delay is up
	// This causes the vehicle to prioritize user input over attempting to move due to momentum
	var/buffered_move = null

	var/clamped = FALSE

	// The amount of skill required to drive the vehicle
	var/required_skill = SKILL_VEHICLE_SMALL

	var/movement_sound //Sound to play when moving
	var/next_sound_play = 0 //Cooldown for next sound to play

	req_access = list() //List of accesses you need to enter
	req_one_access = list() //List of accesses you need one of to enter
	locked = TRUE //Whether we should skip access checking for entry

	// List of all hardpoints attached to the vehicle
	var/list/hardpoints = list()
	//List of all hardpoints you can attach to this vehicle
	var/list/hardpoints_allowed = list()

	// References to the active/chosen hardpoint for each seat
	var/active_hp = list(
		VEHICLE_DRIVER = null
	)

	// Map file name of the vehicle interior
	var/interior_map = null
	var/datum/interior/interior = null
	// How many people can fit inside
	var/interior_capacity = 2

	// Whether or not entering the vehicle is ID restricted to crewmen only. Toggleable by the driver
	var/door_locked = TRUE
	req_one_access = list(
		ACCESS_MARINE_CREWMAN,
		// Officers always have access
		ACCESS_MARINE_BRIDGE,
		// You can't hide from the MPs
		ACCESS_MARINE_BRIG,
	)

	//All the connected entrances sorted by tag
	//Exits will be loaded by the interior manager and sorted by tag to match
	var/list/entrances = list()

	var/list/misc_multipliers = list(
		"move" = 1.0,
		"accuracy" = 1.0,
		"cooldown" = 1.0
	)

	//Changes how much damage the vehicle takes
	var/list/dmg_multipliers = list(
		"all" = 1.0, //for when you want to make it invincible
		"acid" = 1.0,
		"slash" = 1.0,
		"bullet" = 1.0,
		"explosive" = 1.0,
		"blunt" = 1.0,
		"abstract" = 1.0) //abstract for when you just want to hurt it

	// This is more important than you think.
	// Explosive waves can propagate through the vehicle and hit it multiple times
	var/explosive_resistance = 200

	//Placeholders
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "cargo_engine"

/obj/vehicle/multitile/Initialize()
	. = ..()

	if(interior_map)
		interior = new(src)
		interior.create_interior(interior_map)

		if(!interior)
			to_world("Interior [interior_map] failed to load for [src]! Tell a developer!")
			qdel(src)
			return

		interior.human_capacity = interior_capacity
		interior.xeno_capacity = interior_capacity

	var/angle_to_turn = turning_angle(SOUTH, dir)
	rotate_entrances(angle_to_turn)
	rotate_bounds(angle_to_turn)

	// Hardpoint rotation is handled by add_hardpoint
	load_hardpoints()

	load_damage()

	healthcheck()
	update_icon()

	if(all_multi_vehicles[name])
		all_multi_vehicles[name + " #[LAZYLEN(all_multi_vehicles)]"] += src
	else
		all_multi_vehicles[name] += src

/obj/vehicle/multitile/Dispose()
	if(!interior.disposed)
		qdel(interior)
		interior = null

	for(var/obj/item/hardpoint/H in hardpoints)
		if(!H.disposed)
			qdel(H)
			hardpoints -= H

	all_multi_vehicles -= list(name = src)

	. = ..()

/obj/vehicle/multitile/get_explosion_resistance()
	return explosive_resistance

/obj/vehicle/multitile/update_icon()
	overlays.Cut()

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_frame")
		damage_overlay.alpha = 255 * (1 - (health / initial(health)))
		overlays += damage_overlay

	var/amt_hardpoints = LAZYLEN(hardpoints)
	if(amt_hardpoints)
		var/list/hardpoint_images[amt_hardpoints]
		var/list/C[HDPT_LAYER_MAX]

		// Counting sort the images into a list so we get the hardpoint images sorted by layer
		for(var/obj/item/hardpoint/H in hardpoints)
			C[H.hdpt_layer] += 1

		for(var/i = 2 to HDPT_LAYER_MAX)
			C[i] += C[i-1]

		for(var/obj/item/hardpoint/H in hardpoints)
			hardpoint_images[C[H.hdpt_layer]] = H.get_hardpoint_image()
			C[H.hdpt_layer] -= 1

		for(var/i = 1 to amt_hardpoints)
			overlays += hardpoint_images[i]

	if(clamped)
		var/image/J = image(icon, icon_state = "vehicle_clamp")
		overlays += J

//Normal examine() but tells the player what is installed and if it's broken
/obj/vehicle/multitile/examine(var/mob/user)
	..()

	for(var/obj/item/hardpoint/H in hardpoints)
		to_chat(user, "There is a [H] installed.")
		H.examine(user, TRUE)
	if(clamped)
		to_chat(user, "There is a vehicle clamp attached.")

/obj/vehicle/multitile/proc/load_hardpoints()
	return

/obj/vehicle/multitile/proc/load_damage()
	return

// Gets the dimensions of the vehicle hitbox, aka the dimensions of the vehicle itself
/obj/vehicle/multitile/proc/get_dimensions()
	return list("width" = (bound_width / world.icon_size), "height" = (bound_height / world.icon_size))

//Returns the ratio of damage to take, just a housekeeping thing
/obj/vehicle/multitile/proc/get_dmg_multi(var/type)
	if(!dmg_multipliers.Find(type)) return 0
	return dmg_multipliers[type] * dmg_multipliers["all"]

//Generic proc for taking damage
//ALWAYS USE THIS WHEN INFLICTING DAMAGE TO THE VEHICLES
/obj/vehicle/multitile/proc/take_damage_type(var/damage, var/type, var/atom/attacker)
	var/all_broken = TRUE
	for(var/obj/item/hardpoint/H in hardpoints)
		// Health check is done before the hardpoint takes damage
		// This way, the frame won't take damage at the same time hardpoints break
		if(H.health > 0)
			H.take_damage(damage * get_dmg_multi(type))
			all_broken = FALSE

	// If all hardpoints are broken, the vehicle frame begins taking damage
	if(all_broken)
		health = max(0, health - damage * get_dmg_multi(type))
		update_icon()

	if(istype(attacker, /mob))
		var/mob/M = attacker
		log_attack("[src] took [damage] [type] damage from [M] ([M.client ? M.client.ckey : "disconnected"]).")
	else
		log_attack("[src] took [damage] [type] damage from [attacker].")

/obj/vehicle/multitile/Entered(var/atom/movable/A)
	if(istype(A, /obj) && !istype(A, /obj/item/ammo_magazine/hardpoint))
		A.forceMove(src.loc)
		return
	return ..()

// Add/remove verbs that should be given when a mob sits down or unbuckles here
/obj/vehicle/multitile/proc/add_seated_verbs(var/mob/living/M, var/seat)
	return

/obj/vehicle/multitile/proc/remove_seated_verbs(var/mob/living/M, var/seat)
	return

/obj/vehicle/multitile/set_seated_mob(var/seat, var/mob/living/M)
	// Give/remove verbs
	if(isnull(M))
		var/mob/living/L = seats[seat]
		remove_seated_verbs(L, seat)
	else
		add_seated_verbs(M, seat)

	seats[seat] = M

	// Checked here because we want to be able to null the mob in a seat
	if(!istype(M))
		return

	M.set_interaction(src)
	M.reset_view(src)

/obj/vehicle/multitile/proc/get_seat_mob(var/seat)
	return seats[seat]

/obj/vehicle/multitile/proc/get_mob_seat(var/mob/M)
	for(var/seat in seats)
		if(seats[seat] == M)
			return seat
	return null

/obj/vehicle/multitile/proc/get_passengers()
	if(interior)
		return interior.get_passengers()
	return null

//Used to swap which module a position is using
//e.g. swapping primary gunner from the minigun to the smoke launcher
/obj/vehicle/multitile/proc/switch_hardpoint()
	set name = "Change Active Hardpoint"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints()
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return

	var/obj/item/hardpoint/HP = input("Select a hardpoint.") in usable_hps
	if(!HP)
		return

	V.active_hp[seat] = HP
	to_chat(M, SPAN_NOTICE("You select \the [HP]."))

/obj/vehicle/multitile/proc/cycle_hardpoint()
	set name = "Cycle Active Hardpoint"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return

	var/list/usable_hps = V.get_activatable_hardpoints()
	if(!LAZYLEN(usable_hps))
		to_chat(M, SPAN_WARNING("None of the hardpoints can be activated or they are all broken."))
		return
	var/new_hp = usable_hps.Find(V.active_hp[seat])
	if(!new_hp)
		new_hp = 0

	new_hp = (new_hp % usable_hps.len) + 1
	var/obj/item/hardpoint/HP = usable_hps[new_hp]
	if(!HP)
		return

	V.active_hp[seat] = HP
	to_chat(M, SPAN_NOTICE("You select \the [HP]."))	

// Used to lock/unlock the vehicle doors to anyone without proper access
/obj/vehicle/multitile/proc/toggle_door_lock()
	set name = "Toggle Door Locks"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/multitile/V = M.interactee
	if(!V || !istype(V))
		return

	var/seat = V.get_mob_seat(M)
	if(!seat)
		return
	if(seat != VEHICLE_DRIVER)
		return

	V.door_locked = !V.door_locked
	to_chat(M, SPAN_NOTICE("You [V.door_locked ? "lock" : "unlock"] the vehicle doors."))

// Returns all hardpoints that are attached to the vehicle, including ones held by holder hardpoints (e.g. turrets)
/obj/vehicle/multitile/proc/get_hardpoints()
	var/list/all_hardpoints = hardpoints.Copy()
	for(var/obj/item/hardpoint/holder/H in hardpoints)
		if(!H.hardpoints)
			continue
		all_hardpoints += H.hardpoints.Copy()

	return all_hardpoints

/obj/vehicle/multitile/proc/get_activatable_hardpoints()
	var/list/hps = list()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H
			if(!HP.hardpoints)
				continue
			hps += HP.get_activatable_hardpoints()
		if(!H.is_activatable())
			continue
		hps += H
	return hps

// Returns a hardpoint by its name
/obj/vehicle/multitile/proc/find_hardpoint(var/name)
	for(var/obj/item/hardpoint/H in hardpoints)
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/HP = H

			var/obj/item/hardpoint/nested_hp = HP.find_hardpoint(name)
			if(nested_hp)
				return nested_hp

		if(H.name == name)
			return H
	return null

/obj/vehicle/multitile/proc/get_gun_hardpoints()
	var/list/guns
	for(var/obj/item/hardpoint/gun/G in get_hardpoints())
		LAZYADD(guns, G)
	return guns

//Special armored vic healthcheck that mainly updates the hardpoint states
/obj/vehicle/multitile/healthcheck()
	var/all_broken = 1 //Whether or not to call handle_all_modules_broken()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.health <= 0)
			H.deactivate()
			if(istype(H, /obj/item/hardpoint/buff))
				var/obj/item/hardpoint/buff/B = H
				B.remove_buff(src)
		else
			all_broken = 0 //if something exists but isnt broken

	if(all_broken)
		handle_all_modules_broken()
	update_icon()
