/*
	As a rule of thumb, when defining some sort of coordinates for vehicles,
	define them as they should be when the vehicle is facing SOUTH (the BYOND default).

	This applies to for example interior entrances and hardpoint origins
*/

/// Order gear-transmission hotkeys/verbs step through. Clamped at both ends, no wraparound.
GLOBAL_LIST_INIT(vehicle_gear_order, list("P", "R", "N", "D", "1", "2"))

/obj/vehicle/multitile
	name = "multitile vehicle"
	desc = "Get inside to operate the vehicle."

	health = 1000

	/// Fraction of an incoming hit that actually reaches the hull's own frame health.
	var/hull_damage_multiplier = 0.2

	/// Cumulative post-multiplier Acid damage this vehicle's frame has taken. Drives the hull_melted wound family.
	var/hull_acid_damage_taken = 0
	/// Cumulative post-multiplier Brute damage this vehicle's frame has taken. Drives the hull_hole wound family.
	var/hull_brute_damage_taken = 0
	/// Hull wound family type path to current tier. Separate from any hardpoint's own wound_tiers.
	var/list/hull_wound_tiers
	/// This vehicle's progress on one Hull wound family's current tier.
	var/list/hull_wound_repair_progress

	/// Set the instant start_hull_cookoff_sequence() starts, so it can never fire more than once.
	var/hull_destroyed_sequence_started = FALSE
	/// cell_explosion() power at this vehicle's own exterior epicenter during hull-destruction cookoff.
	var/hull_cookoff_exterior_power = HULL_COOKOFF_EXTERIOR_EXPLOSION_POWER
	/// cell_explosion() falloff pairing with hull_cookoff_exterior_power.
	var/hull_cookoff_exterior_falloff = HULL_COOKOFF_EXTERIOR_EXPLOSION_FALLOFF
	/// cell_explosion() power for the separate interior blast if anyone's still trapped inside during cookoff.
	var/hull_cookoff_interior_power = HULL_COOKOFF_INTERIOR_EXPLOSION_POWER
	/// cell_explosion() falloff pairing with hull_cookoff_interior_power.
	var/hull_cookoff_interior_falloff = HULL_COOKOFF_INTERIOR_EXPLOSION_FALLOFF
	/// Seconds between the hull-death warning starting and the cookoff detonating.
	var/hull_cookoff_warning_time = HULL_COOKOFF_WARNING_TIME
	/// Seconds between repeats of the on-screen "get out now" banner during cookoff.
	var/hull_cookoff_passenger_warning_interval = HULL_COOKOFF_PASSENGER_WARNING_INTERVAL
	/// Radius of the small warning-phase napalm flame lit the instant the cookoff countdown starts.
	var/hull_cookoff_warning_flame_radius = HULL_COOKOFF_WARNING_FLAME_RADIUS
	var/hull_cookoff_fire_radius = 1

	/// Mobs currently riding atop this vehicle's hull.
	var/list/on_top_mobs = list()
	/// Objs currently riding atop this vehicle's hull.
	var/list/on_top_obj = list()
	/// Per-seat crew HUD. Seat to list of the 7 grid-cell screen objects shown while that seat is occupied.
	var/list/crew_hud_elements = list()

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

	var/vehicle_light_range = 5
	var/vehicle_light_power = 2

	//Yay! Working cameras in the vehicles at last!!
	var/obj/structure/machinery/camera/vehicle/camera = null
	var/obj/structure/machinery/camera/vehicle/camera_int = null

	/// Hidden rangefinder instance backing the gunner's Ctrl+Click rangefinding. Lazily created on first use.
	var/obj/item/device/binoculars/range/gunner_rangefinder

	var/nickname //used for single-use verb to name the vehicle. Put anything here to prevent naming

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
	/// Fraction of move_max_momentum above which this vehicle can't safely carry riders. 0 means always desant-able (tank, APC).
	var/desant_momentum_cap = 0
	// How much momentum is lost when turning/rotating the vehicle
	var/move_turn_momentum_loss_factor = 0.5
	// Determines how much slower the vehicle is when it lacks its full momentum
	// When the vehicle has 0 momentum, it's movement delay will be move_delay * momentum_build_factor
	// The movement delay gradually reduces up to move_delay when momentum increases
	//// This is mostly vestigial and it looks like it cancels itself out when calculating movement delay??? -bwsb
	var/move_momentum_build_factor = 1.3
	// How fast momentum decays when you stop moving.
	var/move_momentum_loss_factor = 1
	// How long do you have to go without moving for momentum decay to start
	// Slower moving vehicles like the tank require more time, or else they won't get past minimum speed.
	var/idle_time_required = 10 // 10 seconds. Tested to be OK on APC and Van.

	/// If TRUE, this vehicle uses the gear-transmission movement model instead of the legacy momentum model above.
	var/uses_gear_transmission = FALSE
	/// If TRUE, this vehicle can drive onto open_space turfs instead of crashng. Only ever set on the tank for now.
	var/can_enter_open_space = FALSE
	/// If TRUE, a charging Crusher's hit is resolved elsewhere (resolve_crusher_charge_hit()) instead of Collided()'s own generic ram. Only ever set on the tank for now.
	var/has_own_crusher_charge_handling = FALSE
	/// Debounce for resolve_crusher_charge_hit() so a diagonal Charge can't double up its hit in one collision.
	var/last_crusher_charge_hit = 0
	/// TRUE while knockback() is stepping this vehicle through a forced Crusher Charge/Ram shove.
	var/movement_locked = FALSE
	/// TRUE while the current movement_locked shove came from a Crusher caste ability specifically.
	var/knockback_crusher_source = FALSE
	/// Gear name to list("max_speed", "torque", "fuel_use"). Built by build_gear_stats().
	var/list/gear_stats
	/// Multiplier applied to every gear's max_speed and torque, on top of traction/part-condition scaling.
	var/gear_performance_mult = 1
	/// Same idea as gear_performance_mult, but torque-only. max_speed stays untouched.
	var/gear_torque_mult = 1
	/// Top speed (tiles/sec) in D/R gear. Gear 1/2's speeds and torques are derived from this.
	var/top_speed = 0
	/// Acceleration (tiles/sec^2) in D/R gear at 100% engine/tread condition and neutral traction.
	var/base_acceleration = 0
	/// Fuel use (units/sec) in D/R gear at full throttle.
	var/base_fuel_use = 0
	/// Multiplier applied to every idle-related fuel cost (ENGINE_IDLE_FUEL_USE, ENGINE_REV_FUEL_USE, and Park/Neutral's own base fuel_use). Defaults to the general 0.67 across-the-board idle reduction; override per-vehicle for a different rate.
	var/idle_fuel_use_mult = 0.67
	/// Fractional gear_performance_mult boost activate_overdrive() gives this vehicle. 0 disables the ability entirely.
	var/overdrive_speed_mult = 0
	/// world.time before which activate_overdrive() refuses to ttrigger again.
	var/overdrive_next = 0
	var/overdrive_cooldown = 15 SECONDS
	var/overdrive_duration = 3 SECONDS
	/// Sound played when activate_overdrive() triggers.
	var/overdrive_sound = 'sound/vehicles/overdrive_activate.ogg'
	/// Currently selected gear, one of GLOB.vehicle_gear_order.
	var/current_gear = "P"
	/// Current speed, in tiles/sec.
	var/current_speed = 0
	/// Deciseconds between turn-key presses in gear-transmission mode.
	var/gear_turn_delay = 8
	/// Direction the vehicle is actually moving under its own power.
	var/current_move_direction = SOUTH
	/// Complex acceleration only. Leftover speed on the axis the vehicle was facing before its last turn.
	var/drift_speed = 0
	/// The compass direction drift_speed is pushing toward.
	var/drift_direction = 0
	/// Whether drift_movement_loop() is currently running.
	var/drift_loop_active = FALSE
	/// Whether the current drift has been "engaged" by a fresh gas/brake input since the turn that created it.
	var/drift_braking = FALSE
	/// world.time until which the gas key is considered "still held".
	var/throttle_held_until = 0
	/// world.time until which the brake key is considered "still held".
	var/brake_held_until = 0
	/// Under Simple acceleration, discrete notch the driver has stepped up/down to.
	var/speed_notch = 0
	/// world.time before which gear_cruise_loop() won't passively decay speed_notch again.
	var/next_notch_decay = 0
	/// world.time before which gear_accelerate() won't step speed_notch up again.
	var/next_notch_climb_time = 0
	/// Set when an accelerate press actually changed current_speed, cleared by the next idle tick.
	var/simple_accel_pressed = FALSE
	/// world.time before which attempt_simple_accel_move() won't issue another try_move().
	var/next_simple_accel_move = 0
	/// If TRUE, gas/brake presses adjust cruise_control_target_speed instead of throttle/brake intent.
	var/cruise_control_enabled = FALSE
	/// Speed (tiles/sec) cruise control tries to reach and hold.
	var/cruise_control_target_speed = 0
	/// How much a single gas/brake press changes cruise_control_target_speed by, in tiles/sec.
	var/cruise_control_granularity = 0
	/// Throttles on_crash()/interior_crash_effect() from spamming on a repeated bump.
	var/next_crash_effect = 0
	/// Set when a vehicle-vs-vehicle collision already resolved its own crash response, so the generic one doesn't also run.
	var/skip_generic_crash_response = FALSE
	/// Set when a handle_vehicle_bump() override represents no real collision at all (e.g. a bump-opened door).
	var/skip_crash_response_entirely = FALSE
	/// Throttles check_engine_exhaust_smoke() so a sustained condition puffs steadily instead of every tick.
	var/next_exhaust_smoke_time = 0
	/// Throttles handle_vehicle_gas_exposure() re-checks from a Boiler glob's exterior cloud.
	var/next_gas_exposure_time = 0
	/// Throttles expose_to_acid_mine() so one detonation's overlapping tiles don't each re-apply the hit.
	var/next_acid_mine_damage_time = 0
	/// Throttles expose_to_lingering_acid() re-hits from sitting in or re-crossing the same puddle.
	var/next_lingering_acid_damage_time = 0
	/// Ignition state for gear-transmission vehicles. See set_engine_on().
	var/engine_on = TRUE
	/// world.time before which a just-started engine can't build any new torque yet.
	var/engine_spinup_until = 0
	/// Throttles the manual toggle_engine() verb so ignition can't be spammed.
	var/next_engine_toggle_time = 0
	/// Purely cosmetic. 0-1 "how revved up" the engine sounds while idling in Park/Neutral with gas held.
	var/engine_rev_level = 0
	/// Bitmask of which of the 4 independent turn signal lights are currently on.
	var/turn_signal_flags = 0
	/// Current blink phase of the turn signal overlays.
	var/turn_signal_blink_visible = FALSE
	/// Looping blinker-relay sound, active while any turn signal light is on.
	var/datum/looping_sound/turn_signal/turn_signal_soundloop
	/// Looping engine drone, active while engine_on is TRUE.
	var/datum/looping_sound/tank_engine/engine_soundloop
	/// Which tank_engine subtype (start/idle/shutdown sounds) engine_soundloop instantiates. Null by default, so no engine sound unless a vehicle sets this.
	var/engine_soundloop_type = null
	/// Looping track rattle, active only while current_speed > 0. Only instantiated if uses_tank_track_sound is TRUE.
	var/datum/looping_sound/tank_tracks/track_soundloop
	/// Looping skid sound, active only while drift_speed > 0. Only instantiated if uses_tank_track_sound is TRUE.
	var/datum/looping_sound/tank_drift/drift_soundloop
	/// Whether this vehicle has actual tracks to rattle/skid. FALSE by default (wheeled vehicles rely on movement_sound instead), TRUE only on the tank.
	var/uses_tank_track_sound = FALSE
	/// Whether this vehicle's IFF is currently broadcasting.
	var/iff_online = FALSE
	/// Dedicated CIC overwatch camera, parented to this vehicle. Independent of the standard security camera. Null unless setup_overwatch_camera() was called (opt-in per vehicle type).
	var/obj/structure/machinery/camera/overwatch/vehicle/overwatch_camera
	/// Squad this vehicle's overwatch is assigned to. Sticky: stays with the last driver's squad.
	var/datum/squad/overwatch_squad

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

	/// slot string to /image currently shown for that slot in this vehicle's hardpoint status HUD.
	var/list/hardpoint_hud_images = list()

	var/mob_size_required_to_hit = MOB_SIZE_XENO_SMALL

	//variable for various flags
	var/vehicle_flags = VEHICLE_CLASS_WEAK

	// References to the active/chosen hardpoint for each seat
	var/list/obj/item/hardpoint/active_hp = list(
		VEHICLE_DRIVER = null
	)

	// Map file name of the vehicle interior
	var/interior_map = null
	var/datum/interior/interior = null
	var/obj/structure/vehicle_intercom/intercom = null
	/// The telephone spawned inside this vehicle's interior, if the map has one.
	var/obj/structure/transmitter/phone = null

	//common passenger slots
	var/passengers_slots = 2
	//xenos passenger slots
	var/xenos_slots = 2
	//some vehicles have special slots for dead revivable corpses for various reasons
	//revivable corpses slots
	var/revivable_dead_slots = 0
	//To prevent the dead from taking up all passenger slots and making the vehicle un-enterable.
	var/perma_dead_slots = 2
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
	///Minimap flags to use for this vehicle
	var/minimap_flags = MINIMAP_FLAG_USCM
	///Minimap iconstate to use for this vehicle
	var/minimap_icon_state

	// Structures that we should collide with, but that aren't being collided with when we call T.Enter in multitile_movement
	// associative list should guarantee an O(1) lookup in case this needs to be expanded.
	var/static/list/blocking_structures = list(
	/obj/structure/shuttle/part = TRUE,
	/obj/structure/mineral_door/resin = TRUE,
	)

	var/momentum_decay_active = FALSE  // Track if momentum decay loop is running
	/// Whether gear_movement_loop() is currently running.
	var/movement_loop_active = FALSE
	var/last_input_time = 0  // Track when last movement input was received

/obj/vehicle/multitile/Initialize()
	. = ..()

	var/angle_to_turn = turning_angle(SOUTH, dir)
	rotate_entrances(angle_to_turn)
	rotate_bounds(angle_to_turn)
	update_langchat_height()

	if(bound_width > world.icon_size || bound_height > world.icon_size)
		lighting_holder = new(src)
		lighting_holder.set_light_range(vehicle_light_range)
		lighting_holder.set_light_power(vehicle_light_power)
		lighting_holder.set_light_on(vehicle_light_range || vehicle_light_power)
	else if(light_range)
		set_light_on(TRUE)

	light_pixel_x = -bound_x
	light_pixel_y = -bound_y

	turn_signal_soundloop = new(src)
	if(engine_soundloop_type)
		engine_soundloop = new engine_soundloop_type(src)
	if(uses_tank_track_sound)
		track_soundloop = new(src)
		drift_soundloop = new(src)
	if(uses_gear_transmission)
		if(engine_on)
			engine_soundloop?.start()
		spawn(0)
			battery_power_loop()

	healthcheck()
	update_icon()
	update_minimap_icon()

	GLOB.all_multi_vehicles += src

	GLOB.vehicle_hardpoint_hud.add_to_hud(src)
	INVOKE_ASYNC(src, PROC_REF(hardpoint_hud_loop))

	return INITIALIZE_HINT_LATELOAD

/obj/vehicle/multitile/LateInitialize()
	. = ..()

	if(interior_map)
		interior = new(src)
		INVOKE_ASYNC(src, PROC_REF(do_create_interior))

/obj/vehicle/multitile/proc/do_create_interior()
	interior.create_interior(interior_map)

	if(!interior)
		to_world("Interior [interior_map] failed to load for [src]! Tell a developer!")
		qdel(src)
		return

/obj/vehicle/multitile/Destroy()
	// Clears this vehicle's own CIC overwatch link before the rest of destruction runs. No-op for a
	// vehicle that never set one up.
	overwatch_squad?.remove_overwatch_vehicle(src)
	overwatch_squad = null
	QDEL_NULL(overwatch_camera)

	for(var/mob/living/M in on_top_mobs.Copy())
		if(M)
			clear_on_top(M)
	for(var/obj/O in on_top_obj.Copy())
		if(O)
			obj_clear_on_top(O)
	on_top_mobs.Cut()
	on_top_obj.Cut()
	// Otherwise any barricade currently covered (update_covered_barricades()) would be stuck
	// rendering above a vehicle that no longer exists to be above.
	for(var/turf/T as anything in locs)
		for(var/obj/structure/barricade/B in T)
			B.covered_by_vehicle = FALSE
			B.update_icon()

	if(!QDELETED(interior))
		QDEL_NULL(interior)

	QDEL_NULL_LIST(hardpoints)
	QDEL_NULL(turn_signal_soundloop)
	QDEL_NULL(engine_soundloop)
	QDEL_NULL(track_soundloop)
	QDEL_NULL(drift_soundloop)
	QDEL_NULL(gunner_rangefinder)

	GLOB.vehicle_hardpoint_hud.remove_from_hud(src)
	hardpoint_hud_images = null

	GLOB.all_multi_vehicles -= src

	return ..()

/// A vehicle has no client of its own, so its stairwell vision goes to the seated driver/gunner instead.
/obj/vehicle/multitile/get_staircase_vision_clients()
	. = list()
	var/mob/living/driver = seats[VEHICLE_DRIVER]
	if(driver?.client)
		. += driver.client
	var/mob/living/gunner = seats[VEHICLE_GUNNER]
	if(gunner?.client)
		. += gunner.client

// No-op unless an intercom landmark spawned one into this vehicle's interior.
/obj/vehicle/multitile/hear_talk(mob/living/speaker, msg, verb = "says", datum/language/speaking, italics = 0)
	if(intercom)
		intercom.relay_exterior_speech(speaker, msg, verb, speaking, italics)
		if(!intercom.speaker_muted)
			for(var/seat_key in seats)
				var/mob/seated = seats[seat_key]
				if(seated?.client?.prefs && !seated.client.prefs.lang_chat_disabled && !seated.ear_deaf && seated.say_understands(speaker, speaking))
					speaker.langchat_display_image(seated)
	..()

// offsets langchat height to show, properly, above and around the middle of the vehicle.
/obj/vehicle/multitile/proc/update_langchat_height()
	langchat_height = bound_height - bound_y - 8

/obj/vehicle/multitile/get_maxptext_x_offset(image/maptext_image)
	return ..() - bound_x - 16

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

	if(turn_signal_flags && turn_signal_blink_visible)
		for(var/signal_direction in list(NORTH, SOUTH, EAST, WEST))
			if(turn_signal_flags & signal_direction)
				overlays += build_turn_signal_image(signal_direction)

/**
 * Pixel offset for a turn signal light's maptext overlay, per compass direction. Hand-tuned against
 * observed in-game rendering.
 *
 * Arguments:
 * * direction = NORTH, SOUTH, EAST or WEST.
 *
 * Returns:
 * * A 2-element list, list(maptext_x, maptext_y).
 */
/obj/vehicle/multitile/proc/get_turn_signal_offset(direction)
	var/base_x = (bound_width - 64) / 2
	var/base_y = bound_height - bound_y + 4

	switch(direction)
		if(NORTH)
			return list(base_x + 32, base_y - 16)
		if(WEST)
			return list(base_x - 24, base_y - 72)
		if(SOUTH)
			return list(base_x + 32, base_y - 128)
		if(EAST)
			return list(base_x + 96, base_y - 72)
	return list(base_x, base_y)

/**
 * Builds this vehicle's turn signal maptext overlay for one compass direction.
 *
 * Arguments:
 * * signal_direction = NORTH, SOUTH, EAST or WEST.
 *
 * Returns:
 * * A new /image, ready to add to overlays.
 */
/obj/vehicle/multitile/proc/build_turn_signal_image(signal_direction)
	var/glyph
	switch(signal_direction)
		if(NORTH)
			glyph = "&#9650;&#9650;"
		if(SOUTH)
			glyph = "&#9660;&#9660;"
		if(EAST)
			glyph = "&#9654;&#9654;"
		if(WEST)
			glyph = "&#9664;&#9664;"

	var/image/turn_signal_image = image(null, src)
	turn_signal_image.maptext_width = 64
	turn_signal_image.maptext_height = 32
	var/list/offset = get_turn_signal_offset(signal_direction)
	turn_signal_image.maptext_x = offset[1]
	turn_signal_image.maptext_y = offset[2]
	turn_signal_image.layer = 20
	// font-size kept small relative to maptext_height (32px) so the glyph doesn't get clipped.
	turn_signal_image.maptext = MAPTEXT("<span style='color:red;font-size:14px;font-weight:bold'>[glyph]</span>")
	return turn_signal_image

/**
 * Whether this vehicle currently has power to run its turn signals.
 *
 * Arguments:
 * * ignore_battery = Passed straight through to has_vehicle_power().
 */
/obj/vehicle/multitile/proc/can_use_turn_signals(ignore_battery = FALSE)
	return has_vehicle_power(ignore_battery)

/**
 * Force-switches off whatever turn signal is currently active if this vehicle can no longer power it.
 *
 * Arguments:
 * * ignore_battery = Passed straight through to can_use_turn_signals().
 */
/obj/vehicle/multitile/proc/recheck_turn_signals(ignore_battery = FALSE)
	if(turn_signal_flags && !can_use_turn_signals(ignore_battery))
		toggle_turn_signal(turn_signal_flags)

/**
 * Toggles one of this vehicle's 4 independent turn signal lights on/off. Only one can be active at once.
 * Purely manual, toggling the active direction again is the only way to turn it off.
 *
 * Arguments:
 * * direction = NORTH, SOUTH, EAST or WEST. Which light to toggle.
 */
/obj/vehicle/multitile/proc/toggle_turn_signal(direction)
	var/was_active = (turn_signal_flags != 0)
	var/turning_on = !(turn_signal_flags & direction)

	turn_signal_flags = turning_on ? direction : 0
	turn_signal_blink_visible = (turn_signal_flags != 0)
	update_icon()

	if(turning_on)
		if(!was_active)
			INVOKE_ASYNC(src, PROC_REF(turn_signal_blink_loop))
		turn_signal_soundloop?.stop()
		turn_signal_soundloop?.start()
		addtimer(CALLBACK(src, PROC_REF(stop_turn_signal_sound)), TURN_SIGNAL_SOUND_DURATION, TIMER_UNIQUE|TIMER_OVERRIDE)
	else
		turn_signal_soundloop?.stop()

/// Cuts the turn signal's relay sound after it's played for TURN_SIGNAL_SOUND_DURATION. The visual blink keeps going regardless. Audio spam = bad
/obj/vehicle/multitile/proc/stop_turn_signal_sound()
	if(turn_signal_flags != 0)
		turn_signal_soundloop?.stop()

/// Blinks the turn signal overlays on/off at a fixed cadence while a signal is active.
/obj/vehicle/multitile/proc/turn_signal_blink_loop()
	while(turn_signal_flags != 0)
		sleep(TURN_SIGNAL_BLINK_INTERVAL)
		turn_signal_blink_visible = !turn_signal_blink_visible
		update_icon()

	turn_signal_blink_visible = FALSE
	update_icon()

/**
 * Toggles this vehicle's ignition state. While off, gear_cruise_loop() can't generate torque and the
 * tank_engine sound loop stops. Turning it on starts a fresh ENGINE_SPINUP_TIME window before it can build
 * any new torque. Existing speed still coasts freely, only gaining more speed is gated.
 *
 * Arguments:
 * * new_state = TRUE to start the engine, FALSE to shut it off.
 */
/obj/vehicle/multitile/proc/set_engine_on(new_state)
	if(engine_on == new_state)
		return
	engine_on = new_state
	if(engine_on)
		engine_spinup_until = world.time + ENGINE_SPINUP_TIME
		engine_soundloop?.start()
		start_momentum_decay_if_needed()
	else
		engine_soundloop?.stop()

	// Engine state feeds into has_vehicle_power(), so refresh everything that depends on it immediately.
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
	if(turret)
		turret.recalculate_turn_rate()
	recheck_iff_module()
	recheck_support_modules()
	recheck_turn_signals()
	recheck_visual_sensors()

	// Keeps the Toggle Engine action button's icon in sync when something other than the driver flips engine_on.
	refresh_hardpoint_actions()

/**
 * Every client physically inside this vehicle's interior, seated or not.
 *
 * Returns:
 * * A list of /client. Empty if this vehicle has no interior instance yet.
 */
/obj/vehicle/multitile/proc/get_interior_mob_clients()
	var/list/clients = list()
	if(!interior)
		return clients

	var/list/bounds = interior.get_bound_turfs()
	for(var/turf/interior_turf as anything in block(bounds[1], bounds[2]))
		for(var/mob/living/interior_mob in interior_turf)
			if(interior_mob.client)
				clients += interior_mob.client
	return clients

/// Normal examine() but a compact one-line-per-part list, each linking to its own full examine popup.
/obj/vehicle/multitile/get_examine_text(mob/user)
	. = ..()
	for(var/obj/item/hardpoint/H in hardpoints)
		. += H.build_examine_line(user)
		// Holders (e.g. the turret) mount their own weapons in a nested hardpoints list, list those inline too.
		if(istype(H, /obj/item/hardpoint/holder))
			var/obj/item/hardpoint/holder/sub_holder = H
			for(var/obj/item/hardpoint/sub in sub_holder.hardpoints)
				. += sub.build_examine_line(user, "\the [sub_holder]")
	. += get_missing_hardpoint_slot_lines(hardpoints_allowed, hardpoints)
	// Same reasoning as above, but for a holder's own empty nested slots.
	for(var/obj/item/hardpoint/holder/sub_holder in hardpoints)
		. += get_missing_hardpoint_slot_lines(sub_holder.accepted_hardpoints, sub_holder.hardpoints)
	var/is_xeno_examiner = isxeno(user)
	for(var/family_type in hull_wound_tiers)
		var/tier = hull_wound_tiers[family_type]
		var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
		if(!family || tier > length(family.tiers))
			continue
		var/list/tier_data = family.tiers[tier]
		var/blurb = is_xeno_examiner ? tier_data["xeno_feedback"] : tier_data["marine_feedback_red"]
		if(!blurb)
			continue
		if(is_xeno_examiner)
			. += tier_data["bold_feedback"] ? SPAN_XENOBOLDNOTICE(blurb) : SPAN_XENOWARNING(blurb)
			continue
		var/line = tier_data["bold_feedback"] ? SPAN_BOLDWARNING(blurb) : SPAN_WARNING(blurb)
		line += " <a href='byond://?src=\ref[src];hull_wound_info=[family_type]'>(Repair Info)</a>"
		. += line
	if(clamped)
		. += "There is a vehicle clamp attached."
	if(isxeno(user) && interior)
		var/passengers_amount = interior.passengers_taken_slots
		for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
			passengers_amount += RRS.taken
		if(passengers_amount > 0)
			. += "You can sense approximately [passengers_amount] host\s inside."

/// Resolves the "(Repair Info)" link the Hull wound lines above add. No in-place repair action for Hull wounds yet.
/obj/vehicle/multitile/Topic(href, list/href_list)
	if(href_list["hull_wound_info"])
		show_hull_wound_repair_info(usr, href_list["hull_wound_info"])
		return
	return ..()

/// Same shape as /obj/item/hardpoint/proc/show_wound_repair_info(), reads hull_wound_tiers instead.
/obj/vehicle/multitile/proc/show_hull_wound_repair_info(mob/user, family_type_text)
	var/family_type = text2path(family_type_text)
	var/tier = LAZYACCESS(hull_wound_tiers, family_type)
	if(!tier)
		return
	var/datum/hardpoint_wound_family/family = GLOB.hardpoint_wound_families_by_type[family_type]
	if(!family || tier > length(family.tiers))
		return
	var/list/tier_data = family.tiers[tier]
	to_chat(user, SPAN_NOTICE("[SPAN_BOLD(tier_data["wound_name"])]: [format_repair_info_sentence(tier_data)]"))

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

// take_damage_type() now lives in hardpoint_wounds.dm, alongside the rest of the
// single-target damage resolution machinery it depends on (get_attack_target_slot(),
// resolve_targeted_hardpoint(), apply_hull_damage(), etc).

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

/**
 * Re-evaluates any per-seat HUD action buttons that depend on currently-installed hardpoints.
 * Generic DRIVER/GUNNER handling only. A vehicle with its own holder/support-module logic (e.g.
 * the tank's turret, artillery module, and slavable secondary) overrides this instead.
 */
/obj/vehicle/multitile/proc/refresh_hardpoint_actions()
	for(var/seat in list(VEHICLE_DRIVER, VEHICLE_GUNNER))
		var/mob/living/M = seats[seat]
		if(!istype(M) || !M.client)
			continue

		if(length(get_activatable_hardpoints(seat)) >= 2)
			give_action(M, /datum/action/human_action/vehicle_action/cycle_hardpoint)
			// give_action() no-ops when this seat already has the action, so force the icon refresh here too.
			for(var/datum/action/human_action/vehicle_action/cycle_hardpoint/action in M.actions)
				action.update_button_icon()
		else
			remove_action(M, /datum/action/human_action/vehicle_action/cycle_hardpoint)

		if(active_hp[seat]?.get_flame_mode())
			give_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		else
			remove_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)

		if(seat == VEHICLE_GUNNER)
			if(get_slavable_secondary())
				give_action(M, /datum/action/human_action/vehicle_action/slave_secondary)
			else
				remove_action(M, /datum/action/human_action/vehicle_action/slave_secondary)

		if(seat == VEHICLE_DRIVER)
			if(!(M.client.prefs.toggles_vehicle & VEHICLE_SIMPLE_ACCELERATION))
				give_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
				give_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
			else
				remove_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
				remove_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)

		for(var/datum/action/human_action/vehicle_action/action in M.actions)
			action.update_button_icon()

/**
 * Ensures active_hp[seat] holds a valid, currently-activatable hardpoint whenever one exists.
 * Leaves an existing valid selection alone. Generic DRIVER/GUNNER pick: the first mounted Primary,
 * else the first mounted Secondary. A vehicle with its own holder-based weapon (e.g. the tank's
 * turret) overrides this instead.
 */
/obj/vehicle/multitile/proc/ensure_active_hardpoint(seat)
	if(seat != VEHICLE_DRIVER && seat != VEHICLE_GUNNER)
		return

	var/list/usable_hps = get_activatable_hardpoints(seat)
	var/obj/item/hardpoint/current = active_hp[seat]
	if(current && (current in usable_hps))
		return

	var/obj/item/hardpoint/new_active = null
	for(var/obj/item/hardpoint/primary/candidate in usable_hps)
		new_active = candidate
		break
	if(!new_active)
		for(var/obj/item/hardpoint/secondary/candidate in usable_hps)
			new_active = candidate
			break
	if(!new_active)
		for(var/obj/item/hardpoint/support/candidate in usable_hps)
			new_active = candidate
			break

	if(current && !QDELETED(current))
		SEND_SIGNAL(current, COMSIG_GUN_INTERRUPT_FIRE)
	active_hp[seat] = new_active
	// Keeps action buttons that depend on the specific active hardpoint correct across every caller of this proc.
	refresh_hardpoint_actions()

/**
 * Registered on the driver while seated, so a live preference toggle re-evaluates this seat's action buttons.
 * Also force-disengages cruise control if the driver just toggled into Simple Acceleration while already engaged.
 */
/obj/vehicle/multitile/proc/on_driver_prefs_changed(datum/source)
	SIGNAL_HANDLER
	if(cruise_control_enabled && (get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION))
		cruise_control_enabled = FALSE
		var/mob/driver = source
		if(istype(driver))
			to_chat(driver, SPAN_WARNING("Cruise control disengaged - not available with simple vehicle acceleration."))
	refresh_hardpoint_actions()

/obj/vehicle/multitile/set_seated_mob(seat, mob/living/M)
	// Give/remove verbs
	if(QDELETED(M))
		var/mob/living/L = seats[seat]
		remove_seated_verbs(L, seat)
	else
		add_seated_verbs(M, seat)

	seats[seat] = M

	// add_seated_verbs() above grants this seat's action buttons before seats[seat] is set, so their first
	// icon render can't find the seat's real active_hp yet. Refresh again now that seats[] is correct.
	refresh_hardpoint_actions()

	// Checked here because we want to be able to null the mob in a seat
	if(!istype(M))
		return FALSE

	M.set_interaction(src)
	M.reset_view(src)
	give_action(M, /datum/action/human_action/vehicle_unbuckle)
	return TRUE

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
	// A vehicle with zero installed hardpoints (e.g. mid-Initialize(), before the spawner adds any) has
	// nothing to be "all broken" about, so don't default this TRUE regardless of hardpoints.
	var/all_broken = length(hardpoints) > 0 //Whether or not to call handle_all_modules_broken()
	for(var/obj/item/hardpoint/H in hardpoints)
		if(H.health <= 0)
			H.deactivate()
			H.remove_buff(src)
		else
			all_broken = 0 //if something exists but isn't broken

	if(all_broken)
		toggle_cameras_status()
		handle_all_modules_broken()

	//vehicle is dead, no more lights
	if(health <= 0 && lighting_holder.light_range)
		lighting_holder.set_light_on(FALSE)
		update_minimap_icon()
	else
		if(!lighting_holder.light)
			lighting_holder.set_light_on(TRUE)

	for(var/seat_key in seats)
		update_visual_sensor_overlay(seats[seat_key])

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

/**
 * Handling dangerous acidic environment, like acidic spray or toxic waters, maybe toxic vapor in future.
 *
 * Spray Acid and Despoiler's lingering acid puddles get a dedicated tank-only redirect
 * (expose_to_weighted_acid()) instead of the plain Treads-only hit below. Acid Mine and toxic water keep
 * the original Treads-only path, since Acid Mine already has its own explicit Treads + Hull design.
 */
/obj/vehicle/multitile/proc/handle_acidic_environment(atom/A)
	if(istype(src, /obj/vehicle/multitile/tank) && (istype(A, /obj/effect/xenomorph/spray) || istype(A, /obj/effect/lingering_acid)))
		var/obj/vehicle/multitile/tank/tank = src
		tank.expose_to_weighted_acid(A)
		return

	for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
		Loco.handle_acid_damage(A)

/**
 * Handles one Acid Mine detonation tile touching this vehicle. A parked tank's 3x3 footprint can overlap
 * several of one cast's simultaneously-detonating tiles at once, deduped via next_acid_mine_damage_time so
 * that only applies once. Hits Treads like the acid spray does, plus a direct Hull hit on top.
 */
/obj/vehicle/multitile/proc/expose_to_acid_mine(obj/effect/xenomorph/acid_damage_delay/boiler_landmine/mine)
	if(world.time < next_acid_mine_damage_time)
		return
	next_acid_mine_damage_time = world.time + ACID_MINE_VEHICLE_DAMAGE_COOLDOWN

	handle_acidic_environment(mine)

	var/hull_damage = mine.damage * (mine.empowered ? 1.25 : 1) * get_hull_incoming_damage_wound_multiplier(WOUND_DAMTYPE_ACID)
	health = max(0, health - hull_damage)
	hull_acid_damage_taken += hull_damage
	roll_hull_wounds(hull_damage, WOUND_DAMTYPE_ACID, mine.linked_xeno)

/**
 * Handles a Despoiler acid puddle (Oozing Wounds) touching this vehicle. Unlike Acid Mine's one-shot
 * detonation, a puddle lasts 15-20 seconds and can be sat in or re-crossed repeatedly, deduped via
 * next_lingering_acid_damage_time. Treads-only, no bonus Hull hit like Acid Mine gets.
 */
/obj/vehicle/multitile/proc/expose_to_lingering_acid(obj/effect/lingering_acid/puddle)
	if(world.time < next_lingering_acid_damage_time)
		return
	next_lingering_acid_damage_time = world.time + LINGERING_ACID_VEHICLE_DAMAGE_COOLDOWN

	handle_acidic_environment(puddle)

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

/obj/vehicle/multitile/proc/is_blocking_structure(atom/A)
	for(var/blocked_type in blocking_structures)
		if(ispath(A.type, blocked_type))
			return TRUE
	return FALSE

/// Whether A is a "directional" ON_BORDER obstacle that only blocks one edge of its tile (barricades, non-full-tile windows, flipped tables).
/obj/vehicle/multitile/proc/is_directional_obstacle(atom/A)
	if(istype(A, /obj/structure/barricade))
		return TRUE
	if(istype(A, /obj/structure/window))
		var/obj/structure/window/W = A
		return !W.is_full_window()
	if(istype(A, /obj/structure/surface/table))
		var/obj/structure/surface/table/table = A
		return table.flipped
	return FALSE

///Updates the vehicles minimap icon
/obj/vehicle/multitile/proc/update_minimap_icon(modules_broken)
	if(!minimap_icon_state)
		return
	SSminimaps.remove_marker(src)
	minimap_icon_state = initial(minimap_icon_state)
	if(health <= 0 || modules_broken)
		minimap_icon_state += "_wreck"
	SSminimaps.add_marker(src, minimap_flags, image('icons/ui_icons/map_blips_large.dmi', null, minimap_icon_state, HIGH_FLOAT_LAYER))
