/*
	As a rule of thumb, when defining some sort of coordinates for vehicles,
	define them as they should be when the vehicle is facing SOUTH (the BYOND default).

	This applies to for example interior entrances and hardpoint origins
*/

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

	light_system = MOVABLE_LIGHT
	light_range = 5

	var/atom/movable/vehicle_light_holder/lighting_holder

	var/vehicle_light_range = 7
	var/vehicle_light_power = 2

	//Yay! Working cameras in the vehicles at last!!
	var/obj/structure/machinery/camera/vehicle/camera = null
	var/obj/structure/machinery/camera/vehicle/camera_int = null

	var/nickname //used for single-use verb to name the vehicle. Put anything here to prevent naming

	var/next_shout = 0 //to prevent spamming

	var/honk_sound = 'sound/vehicles/honk_4_light.ogg'
	var/next_honk = 0 //to prevent spamming

	// List of verbs to give when a mob is seated in each seat type
	var/list/seat_verbs

	move_delay = VEHICLE_SPEED_STATIC
	// The next world.time when the vehicle can move
	var/next_move = 0
	// How much momentum the vehicle has. Increases by 1 each move
	var/move_momentum = 0
	// How much momentum the vehicle can achieve
	var/move_max_momentum = 5
	// How much momentum is lost when turning/rotating the vehicle
	var/move_turn_momentum_loss_factor = 0.5
	// Determines how much slower the vehicle is when it lacks its full momentum
	// When the vehicle has 0 momentum, it's movement delay will be move_delay * momentum_build_factor
	// The movement delay gradually reduces up to move_delay when momentum increases
	var/move_momentum_build_factor = 1.3

	//Sound to play when moving
	var/movement_sound
	//Cooldown for next sound to play
	var/move_next_sound_play = 0

	//whether MP vehicle clamps are applied
	var/clamped = FALSE

	// The amount of skill required to drive the vehicle
	var/required_skill = SKILL_VEHICLE_SMALL


	req_access = list() //List of accesses you need to enter
	req_one_access = list() //List of accesses you need one of to enter
	locked = TRUE //Whether we should skip access checking for entry

	// List of all hardpoints attached to the vehicle
	var/list/hardpoints = list()
	//List of all hardpoints you can attach to this vehicle
	var/list/hardpoints_allowed = list()

	var/mob_size_required_to_hit = MOB_SIZE_XENO_SMALL

	//variable for various flags
	var/vehicle_flags = VEHICLE_CLASS_WEAK

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
	//some vehicles have special slots for dead revivable corpses for various reasons
	//revivable corpses slots
	var/revivable_dead_slots = 0
	//Special roles categories slots. These allow to set specific roles in categories with their own slots.
	//For example, (list(JOB_CREWMAN, JOB_UPP_CREWMAN) = 2) means that USCM and UPP crewman will always have 2 slots reserved for them.
	//Only first encounter of job will be checked for slots, so don't put job in more than one category.
	var/list/role_reserved_slots = list()

	//list of stuff we do NOT want to be pulled inside
	var/list/forbidden_atoms = list(
		/obj/structure/airlock_assembly,
		/obj/structure/barricade,
		/obj/structure/machinery/defenses,
		/obj/structure/machinery/m56d_post,
		/obj/structure/machinery/cm_vending,
		/obj/structure/machinery/vending,
		/obj/structure/window,
		/obj/structure/windoor_assembly,
	)

	var/wall_ram_damage = 30
	//allows more flexibility in ram damage
	var/vehicle_ram_multiplier = 1

	//vehicles with this off will be ignored by tacmap.
	var/visible_in_tacmap = TRUE

	//Amount of seconds spent on entering/leaving. Always the same when dragging stuff (2 seconds) and for xenos (1 second)
	var/entrance_speed = 1 SECONDS

	//Whether or not entering the vehicle is ID restricted to those with crewman, command or MP access only. Toggleable by the driver.
	//Having command/MP/Crewmen access won't matter if the faction of the vehicle is not yours, so you can't infiltrate the vehicle.
	var/door_locked = FALSE
	req_one_access = list(
		ACCESS_MARINE_CREWMAN,
		// Officers always have access
		ACCESS_MARINE_COMMAND,
		// You can't hide from the MPs
		ACCESS_MARINE_BRIG,
	)

	//used for IFF stuff. Determined by driver. It will remember faction of a last driver. IFF-compatible rounds won't damage vehicle.
	var/vehicle_faction = ""

	//All the connected entrances sorted by tag
	//Exits will be loaded by the interior manager and sorted by tag to match
	var/list/entrances = list()

	var/list/misc_multipliers = list(
		"move" = 1.0,
		"accuracy" = 1.0,
		"cooldown" = 1
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

	var/angle_to_turn = turning_angle(SOUTH, dir)
	rotate_entrances(angle_to_turn)
	rotate_bounds(angle_to_turn)

	healthcheck()
	update_icon()

	GLOB.all_multi_vehicles += src

	return INITIALIZE_HINT_LATELOAD

/obj/vehicle/multitile/LateInitialize()
	. = ..()

	if(interior_map)
		interior = new(src)
		INVOKE_ASYNC(src, PROC_REF(do_create_interior))

/obj/vehicle/multitile/New()
	. = ..()
	if(bound_width > world.icon_size || bound_height > world.icon_size)
		lighting_holder = new(src)
		lighting_holder.set_light_flags(LIGHT_ATTACHED)
		lighting_holder.set_light_range(vehicle_light_range)
		lighting_holder.set_light_power(vehicle_light_power)
		lighting_holder.set_light_on(vehicle_light_range || vehicle_light_power)
	else if(light_range)
		set_light_on(TRUE)

	light_pixel_x = -bound_x
	light_pixel_y = -bound_y

/obj/vehicle/multitile/proc/do_create_interior()
	interior.create_interior(interior_map)

	if(!interior)
		to_world("Interior [interior_map] failed to load for [src]! Tell a developer!")
		qdel(src)
		return

/obj/vehicle/multitile/Destroy()
	if(!QDELETED(interior))
		QDEL_NULL(interior)

	QDEL_NULL_LIST(hardpoints)

	QDEL_NULL(lighting_holder)

	GLOB.all_multi_vehicles -= src

	return ..()

/obj/vehicle/multitile/proc/initialize_cameras()
	return

/obj/vehicle/multitile/proc/toggle_cameras_status(on)
	if(camera)
		camera.toggle_cam_status(on)
	if(camera_int)
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
		for(var/obj/item/hardpoint/hardpoint in hardpoints)
			var/image/hardpoint_image = hardpoint.get_hardpoint_image()
			if(istype(hardpoint_image))
				hardpoint_image.layer = layer + hardpoint.hdpt_layer * 0.1
			else if(islist(hardpoint_image))
				var/list/image/hardpoint_image_list = hardpoint_image // Linter will complain about iterating on "an image" otherwise
				for(var/image/subimage in hardpoint_image_list)
					subimage.layer = layer + hardpoint.hdpt_layer * 0.1
			overlays += hardpoint_image

	if(clamped)
		var/image/J = image(icon, icon_state = "vehicle_clamp", layer = layer+0.1)
		overlays += J

//Normal examine() but tells the player what is installed and if it's broken
/obj/vehicle/multitile/get_examine_text(mob/user)
	. = ..()
	for(var/obj/item/hardpoint/H in hardpoints)
		. += "There is \a [H] module installed."
		H.examine(user, TRUE)
	if(clamped)
		. += "There is a vehicle clamp attached."
	if(isxeno(user) && interior)
		var/passengers_amount = interior.passengers_taken_slots
		for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
			passengers_amount += RRS.taken
		if(passengers_amount > 0)
			. += "You can sense approximately [passengers_amount] hosts inside."

/obj/vehicle/multitile/proc/load_hardpoints()
	return

/obj/vehicle/multitile/proc/load_damage()
	return

// Gets the dimensions of the vehicle hitbox, aka the dimensions of the vehicle itself
/obj/vehicle/multitile/proc/get_dimensions()
	return list("width" = (bound_width / world.icon_size), "height" = (bound_height / world.icon_size))

//Returns the ratio of damage to take, just a housekeeping thing
/obj/vehicle/multitile/proc/get_dmg_multi(type)
	if(!dmg_multipliers || !dmg_multipliers.Find(type))
		return 1
	return dmg_multipliers[type] * dmg_multipliers["all"]

//Generic proc for taking damage
//ALWAYS USE THIS WHEN INFLICTING DAMAGE TO THE VEHICLES
/obj/vehicle/multitile/proc/take_damage_type(damage, type, atom/attacker)
	var/all_broken = TRUE
	for(var/obj/item/hardpoint/H in hardpoints)
		// Health check is done before the hardpoint takes damage
		// This way, the frame won't take damage at the same time hardpoints break
		if(H.can_take_damage())
			H.take_damage(round(damage * get_dmg_multi(type)))
			all_broken = FALSE

	// If all hardpoints are broken, the vehicle frame begins taking full damage
	if(all_broken)
		health = max(0, health - damage * get_dmg_multi(type))
	else //otherwise, 1/10th of damage lands on the hull
		health = max(0, health - round(damage * get_dmg_multi(type) / 10))

	if(ismob(attacker))
		var/mob/M = attacker
		log_attack("[src] took [damage] [type] damage from [M] ([M.client ? M.client.ckey : "disconnected"]).")
	else
		log_attack("[src] took [damage] [type] damage from [attacker].")
	update_icon()

/obj/vehicle/multitile/Entered(atom/movable/A)
	if(istype(A, /obj) && !istype(A, /obj/item/ammo_magazine/hardpoint) && !istype(A, /obj/item/hardpoint))
		A.forceMove(loc)
		return
	return ..()

// Add/remove verbs that should be given when a mob sits down or unbuckles here
/obj/vehicle/multitile/proc/add_seated_verbs(mob/living/M, seat)
	return

/obj/vehicle/multitile/proc/remove_seated_verbs(mob/living/M, seat)
	return

/obj/vehicle/multitile/set_seated_mob(seat, mob/living/M)
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
	give_action(M, /datum/action/human_action/vehicle_unbuckle)

//It's breaking it, so we don't throwing it anyways
/obj/vehicle/multitile/throw_atom(atom/target, range, speed = 0, atom/thrower, spin, launch_type = NORMAL_LAUNCH, pass_flags = NO_FLAGS, list/end_throw_callbacks, list/collision_callbacks)
	return FALSE

/// Get crewmember of seat.
/obj/vehicle/multitile/proc/get_seat_mob(seat)
	return seats[seat]

/// Get seat of crewmember.
/obj/vehicle/multitile/proc/get_mob_seat(mob/M)
	for(var/seat in seats)
		if(seats[seat] == M)
			return seat
	return null

/// Get active hardpoint of crewmember.
/obj/vehicle/multitile/proc/get_mob_hp(mob/crew)
	var/seat = get_mob_seat(crew)
	if(seat)
		return active_hp[seat]
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

	if(lighting_holder)
		//vehicle is dead, no more lights
		if (health <= 0) lighting_holder.set_light_on(FALSE)
		else lighting_holder.set_light_on(TRUE)
	update_icon()

/*
** PRESETS SPAWNERS
*/
//These help spawning vehicles that don't end up as subtypes, causing problems later with various checks
//as well as allowing customizations, like properly turning on mapped in direction and so on.

/obj/effect/vehicle_spawner
	name = "Vehicle Spawner"

//Main proc which handles spawning and adding hardpoints/damaging the vehicle
/obj/effect/vehicle_spawner/proc/spawn_vehicle()
	return

//Installation of modules kit
/obj/effect/vehicle_spawner/proc/load_hardpoints(obj/vehicle/multitile/V)
	return

//Miscellaneous additions
/obj/effect/vehicle_spawner/proc/load_misc(obj/vehicle/multitile/V)

	V.load_role_reserved_slots()
	V.initialize_cameras()
	//transfer mapped in edits
	if(color)
		V.color = color
	if(name != initial(name))
		V.name = name
	if(desc)
		V.desc = desc

//Dealing enough damage to destroy the vehicle
/obj/effect/vehicle_spawner/proc/load_damage(obj/vehicle/multitile/V)
	V.take_damage_type(1e8, "abstract")
	V.take_damage_type(1e8, "abstract")
	V.healthcheck()

/obj/effect/vehicle_spawner/proc/handle_direction(obj/vehicle/multitile/M)
	switch(dir)
		if(EAST)
			M.try_rotate(90)
		if(WEST)
			M.try_rotate(-90)
		if(NORTH)
			M.try_rotate(90)
			M.try_rotate(90)

/obj/vehicle/multitile/get_applying_acid_time()
	return 3 SECONDS

//handling dangerous acidic environment, like acidic spray or toxic waters, maybe toxic vapor in future
/obj/vehicle/multitile/proc/handle_acidic_environment(atom/A)
	for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
		Loco.handle_acid_damage(A)

/atom/movable/vehicle_light_holder
	light_system = MOVABLE_LIGHT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/vehicle_light_holder/Initialize(mapload, ...)
	. = ..()

	var/atom/attached_to = loc

	forceMove(attached_to.loc)
	RegisterSignal(attached_to, COMSIG_MOVABLE_MOVED, PROC_REF(handle_parent_move))

/atom/movable/vehicle_light_holder/proc/handle_parent_move(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER

	forceMove(get_turf(mover))
