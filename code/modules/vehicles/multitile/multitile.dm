/*
	As a rule of thumb, when defining some sort of coordinates for vehicles,
	define them as they should be when the vehicle is facing SOUTH (the BYOND default).

	This applies to for example interior entrances and hardpoint origins
*/

GLOBAL_LIST_EMPTY(all_multi_vehicles)

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

	can_buckle = FALSE

	//Yay! Working cameras in the vehicles at last!!
	var/obj/structure/machinery/camera/vehicle/camera_int = null
	var/nickname		//used for single-use verb to name the vehicle. Put anything here to prevent naming

	var/honk_sound = 'sound/vehicles/honk_4_light.ogg'
	var/next_honk = 0	//to prevent spamming

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

	var/mob_size_required_to_hit = MOB_SIZE_XENO_SMALL

	var/vehicle_flags = NO_FLAGS		//variable for various flags

	// References to the active/chosen hardpoint for each seat
	var/active_hp = list(
		VEHICLE_DRIVER = null
	)

	// Map file name of the vehicle interior
	var/interior_map = null
	var/datum/interior/interior = null

	//common passenger slots
	var/passengers_slots = 2
	//xenos passenger slots
	var/xenos_slots = 2
	//Special roles categories slots. These allow to set specific roles in categories with their own slots.
	//For example, (list(JOB_CREWMAN, JOB_UPP_CREWMAN) = 2) means that USCM and UPP crewman will always have 2 slots reserved for them.
	//Only first encounter of job will be checked for slots, so don't put job in more than one category.
	var/list/role_reserved_slots = list()

	var/wall_ram_damage = 30

	//vehicles with this off will be ignored by tacmap.
	var/visible_in_tacmap = TRUE

	//Amount of seconds spent on entering/leaving. Always the same when dragging stuff (2 seconds) and for xenos (1 second)
	var/entrance_speed = 1

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

	var/move_on_turn = FALSE

/obj/vehicle/multitile/Initialize()
	. = ..()

	if(interior_map)
		interior = new(src)
		interior.create_interior(interior_map)

		if(!interior)
			to_world("Interior [interior_map] failed to load for [src]! Tell a developer!")
			qdel(src)
			return

	var/angle_to_turn = turning_angle(SOUTH, dir)
	rotate_entrances(angle_to_turn)
	rotate_bounds(angle_to_turn)

	// Hardpoint rotation is handled by add_hardpoint
	load_hardpoints()

	load_damage()

	healthcheck()
	update_icon()

	initialize_cameras()

	load_role_reserved_slots()

	GLOB.all_multi_vehicles += src

/obj/vehicle/multitile/Destroy()
	if(!QDELETED(interior))
		QDEL_NULL(interior)

	QDEL_NULL_LIST(hardpoints)

	GLOB.all_multi_vehicles -= src

	. = ..()

/obj/vehicle/multitile/proc/initialize_cameras()
	return

/obj/vehicle/multitile/proc/toggle_cameras_status(var/on)
	if(!camera_int)
		return
	camera_int.toggle_cam_status(on)

/obj/vehicle/multitile/get_explosion_resistance()
	return explosive_resistance

/obj/vehicle/multitile/update_icon()
	overlays.Cut()

	if(health <= initial(health))
		var/image/damage_overlay = image(icon, icon_state = "damaged_frame", layer = layer+0.1)
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
			var/image/I = hardpoint_images[i]
			// get_hardpoint_image() can return a list of images
			if(istype(I))
				I.layer = layer + (i*0.1)
			overlays += I

	if(clamped)
		var/image/J = image(icon, icon_state = "vehicle_clamp", layer = layer+0.1)
		overlays += J

//Normal examine() but tells the player what is installed and if it's broken
/obj/vehicle/multitile/examine(var/mob/user)
	..()

	for(var/obj/item/hardpoint/H in hardpoints)
		to_chat(user, "There is a [H] module installed.")
		H.examine(user, TRUE)
	if(clamped)
		to_chat(user, "There is a vehicle clamp attached.")
	if(isXeno(user) && interior)
		var/passengers_amount = interior.passengers_taken_slots
		for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
			passengers_amount += RRS.taken
		if(passengers_amount > 0)
			to_chat(user, "You can sense approximately [passengers_amount] hosts inside.")

/obj/vehicle/multitile/proc/load_hardpoints()
	return

/obj/vehicle/multitile/proc/load_damage()
	return

// Gets the dimensions of the vehicle hitbox, aka the dimensions of the vehicle itself
/obj/vehicle/multitile/proc/get_dimensions()
	return list("width" = (bound_width / world.icon_size), "height" = (bound_height / world.icon_size))

//Returns the ratio of damage to take, just a housekeeping thing
/obj/vehicle/multitile/proc/get_dmg_multi(var/type)
	if(!dmg_multipliers || !dmg_multipliers.Find(type))
		return 1
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
	if(istype(A, /obj) && !istype(A, /obj/item/ammo_magazine/hardpoint) && !istype(A, /obj/item/hardpoint))
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
	if(QDELETED(M))
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

/obj/vehicle/multitile/proc/load_role_reserved_slots()
	return

//Special armored vic healthcheck that mainly updates the hardpoint states
/obj/vehicle/multitile/healthcheck()
	var/all_broken = 1 //Whether or not to call handle_all_modules_broken()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.health <= 0)
			H.deactivate()
			H.remove_buff(src)
		else
			all_broken = 0 //if something exists but isnt broken

	if(all_broken)
		toggle_cameras_status()
		handle_all_modules_broken()

	//vehicle is dead, no more lights
	if(health <= 0 && luminosity)
		SetLuminosity(0)
	update_icon()
