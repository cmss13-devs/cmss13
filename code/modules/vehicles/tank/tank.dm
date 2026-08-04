/obj/vehicle/multitile/tank
	name = "M34A2 Longstreet Light Tank"
	desc = "A giant piece of armor with a big gun, you know what to do. Entrance in the back."

	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48

	bound_width = 96
	bound_height = 96

	bound_x = -32
	bound_y = -32

	interior_map = /datum/map_template/interior/tank

	//tank always has 2 crewmen slot reserved and 1 general slot for other roles.
	passengers_slots = 1
	//this is done in case VCs die inside the tank, so that someone else can come in and take them out.
	revivable_dead_slots = 2
	xenos_slots = 4

	entrances = list(
		"back" = list(0, 2)
	)

	// Superseded by the tank_engine looping sound. Other vehicles keep this.
	movement_sound = null
	engine_soundloop_type = /datum/looping_sound/tank_engine
	honk_sound = 'sound/vehicles/honk_3_ambulence.ogg'
	uses_tank_track_sound = TRUE

	engine_on = FALSE

	required_skill = SKILL_VEHICLE_LARGE

	vehicle_flags = VEHICLE_CLASS_MEDIUM

	move_max_momentum = 2.63
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

	uses_gear_transmission = TRUE
	can_enter_open_space = TRUE
	has_own_crusher_charge_handling = TRUE
	current_gear = "P"
	top_speed = 2.63
	base_acceleration = 0.88
	// 0.5 * 0.67, part of the across-the-board fuel consumption reduction.
	base_fuel_use = 0.335

	vehicle_light_range = 7

	// Rest (all the guns) is handled by the tank turret hardpoint
	hardpoints_allowed = list(
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/hardpoint/support/weapons_sensor,
		/obj/item/hardpoint/support/overdrive_enhancer,
		/obj/item/hardpoint/support/artillery_module,
		/obj/item/hardpoint/armor/ballistic,
		/obj/item/hardpoint/armor/caustic,
		/obj/item/hardpoint/armor/concussive,
		/obj/item/hardpoint/armor/paladin,
		/obj/item/hardpoint/snowplow,
		/obj/item/hardpoint/locomotion/treads,
		/obj/item/hardpoint/locomotion/treads/robust,
		/obj/item/hardpoint/engine/tank,
		/obj/item/hardpoint/fuel_tank/uscm,
		/obj/item/hardpoint/radiator/uscm,
		/obj/item/hardpoint/battery/uscm,
		/obj/item/hardpoint/hatch/armored/uscm,
		// IFF module/visual sensors/turret ring/air filter mount on the turret itself, so removing it takes them with it.
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	health = 1000

	dmg_multipliers = list(
		"all" = 1,
		"acid" = 1.5, // Acid melts the tank
		"slash" = 0.7, // Slashing a massive, solid chunk of metal does very little except leave scratches
		"bullet" = 0.4,
		"explosive" = 0.8,
		"blunt" = 0.8,
		"abstract" = 1
	)

	explosive_resistance = 400
	minimap_icon_state = "tank"

	var/on_top_mobs_shooting_inaccuracy_time = 0 /// world_time must be bigger than this so mobs don't get penalized for shooting while atop the tank.

/obj/vehicle/multitile/tank/Initialize()
	. = ..()
	gear_stats = build_gear_stats()
	cruise_control_granularity = gear_stats["D"]["max_speed"] * CRUISE_CONTROL_DEFAULT_GRANULARITY_FRACTION
	setup_overwatch_camera()

/obj/vehicle/multitile/tank/update_next_move()
	var/anti_build_factor = 1/((max(abs(move_momentum), 1)/move_max_momentum) * move_momentum_build_factor)
	on_top_mobs_shooting_inaccuracy_time = world.time + move_delay * move_momentum_build_factor * anti_build_factor * misc_multipliers["move"] * 5
	. = ..()

/obj/vehicle/multitile/tank/initialize_cameras(change_tag = FALSE)
	if(!camera)
		camera = new /obj/structure/machinery/camera/vehicle(src)
	if(change_tag)
		camera.c_tag = "#[rand(1,100)] M34A2 \"[nickname]\" Tank" //this fluff allows it to be at the start of cams list
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior" //this fluff allows it to be at the start of cams list
	else
		camera.c_tag = "#[rand(1,100)] M34A2 Tank"
		if(camera_int)
			camera_int.c_tag = camera.c_tag + " interior" //this fluff allows it to be at the start of cams list

/obj/vehicle/multitile/tank/load_role_reserved_slots()
	var/datum/role_reserved_slots/RRS = new
	RRS.category_name = "Crewmen"
	RRS.roles = list(JOB_TANK_CREW, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN, JOB_ARMY_TANK)
	RRS.total = 2
	role_reserved_slots += RRS

/obj/vehicle/multitile/tank/load_hardpoints()
	add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)

/obj/vehicle/multitile/tank/add_seated_verbs(mob/living/M, seat)
	// Reassign this tank's CIC overwatch to the new driver's squad, if they're a Tank Crewman with one.
	// driver.mind is required so a map-placed dummy/mannequin can never trigger an assignment just by existing pre-buckled.
	if(seat == VEHICLE_DRIVER && ishuman(M))
		var/mob/living/carbon/human/driver = M
		if(driver.mind && driver.job == JOB_TANK_CREW && driver.assigned_squad)
			update_overwatch_squad(driver.assigned_squad)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
	))
	if(seat == VEHICLE_DRIVER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
			/obj/vehicle/multitile/proc/cycle_gear_up,
			/obj/vehicle/multitile/proc/cycle_gear_down,
			/obj/vehicle/multitile/proc/toggle_cruise_control,
			/obj/vehicle/multitile/proc/set_cruise_control_granularity,
			/obj/vehicle/multitile/proc/toggle_turn_signal_north,
			/obj/vehicle/multitile/proc/toggle_turn_signal_south,
			/obj/vehicle/multitile/proc/toggle_turn_signal_east,
			/obj/vehicle/multitile/proc/toggle_turn_signal_west,
			/obj/vehicle/multitile/proc/toggle_engine,
		))
		give_action(M, /datum/action/human_action/vehicle_action/toggle_door_lock)
		give_action(M, /datum/action/human_action/vehicle_action/toggle_engine)
		if(!(M.client.prefs.toggles_vehicle & VEHICLE_SIMPLE_ACCELERATION))
			give_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
			give_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
		RegisterSignal(M, COMSIG_MOB_VEHICLE_PREFS_CHANGED, PROC_REF(on_driver_prefs_changed))
		start_crew_hud(M, VEHICLE_DRIVER)
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_turret_safety,
			/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
			/obj/vehicle/multitile/proc/toggle_iff_module,
		))
		give_action(M, /datum/action/human_action/vehicle_action/toggle_gyro)
		give_action(M, /datum/action/human_action/vehicle_action/toggle_iff)
		// seats[VEHICLE_GUNNER] isn't written yet at this point, so gunner_seated is passed explicitly as TRUE.
		var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
		turret?.recalculate_gyro(TRUE)
		if(get_slavable_secondary())
			give_action(M, /datum/action/human_action/vehicle_action/slave_secondary)
		start_crew_hud(M, VEHICLE_GUNNER)
	if(seat == VEHICLE_DRIVER || seat == VEHICLE_GUNNER)
		if(get_artillery_module()?.is_functional())
			add_verb(M.client, list(
				/obj/vehicle/multitile/proc/toggle_artillery_optics,
				/obj/vehicle/multitile/proc/toggle_artillery_nvg,
			))
			give_action(M, /datum/action/human_action/vehicle_action/toggle_nvg)
			give_action(M, /datum/action/human_action/vehicle_action/toggle_artillery_range)
		if(length(get_activatable_hardpoints(seat)) >= 2)
			give_action(M, /datum/action/human_action/vehicle_action/cycle_hardpoint)
		if(active_hp[seat]?.get_flame_mode())
			give_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		give_action(M, /datum/action/human_action/vehicle_action/use_phone)
	// seats[seat] isn't written yet, so the conditional grants above use M directly instead of delegating to this.
	refresh_hardpoint_actions()
	// Auto-select a default weapon for this seat if it doesn't already have a valid one.
	ensure_active_hardpoint(seat)


/obj/vehicle/multitile/tank/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/proc/switch_hardpoint,
	))
	SStgui.close_user_uis(M, src)
	if(seat == VEHICLE_DRIVER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_door_lock,
			/obj/vehicle/multitile/proc/activate_horn,
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
			/obj/vehicle/multitile/proc/cycle_gear_up,
			/obj/vehicle/multitile/proc/cycle_gear_down,
			/obj/vehicle/multitile/proc/toggle_cruise_control,
			/obj/vehicle/multitile/proc/set_cruise_control_granularity,
			/obj/vehicle/multitile/proc/toggle_turn_signal_north,
			/obj/vehicle/multitile/proc/toggle_turn_signal_south,
			/obj/vehicle/multitile/proc/toggle_turn_signal_east,
			/obj/vehicle/multitile/proc/toggle_turn_signal_west,
			/obj/vehicle/multitile/proc/toggle_engine,
		))
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_door_lock)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_engine)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_cruise_control)
		remove_action(M, /datum/action/human_action/vehicle_action/set_cruise_control_granularity)
		UnregisterSignal(M, COMSIG_MOB_VEHICLE_PREFS_CHANGED)
		stop_crew_hud(M, VEHICLE_DRIVER)
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_turret_safety,
			/obj/vehicle/multitile/proc/toggle_slave_secondary_to_driver,
			/obj/vehicle/multitile/proc/toggle_hardpoint_fire_mode,
			/obj/vehicle/multitile/proc/toggle_iff_module,
		))
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_gyro)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_iff)
		remove_action(M, /datum/action/human_action/vehicle_action/slave_secondary)
		// This seat is about to be vacated, so gunner_seated is passed explicitly as FALSE.
		var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
		turret?.recalculate_gyro(FALSE)
		stop_crew_hud(M, VEHICLE_GUNNER)
	if(seat == VEHICLE_DRIVER || seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/toggle_artillery_optics,
			/obj/vehicle/multitile/proc/toggle_artillery_nvg,
		))
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_nvg)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_artillery_range)
		remove_action(M, /datum/action/human_action/vehicle_action/cycle_hardpoint)
		remove_action(M, /datum/action/human_action/vehicle_action/toggle_hardpoint_fire_mode)
		remove_action(M, /datum/action/human_action/vehicle_action/use_phone)
		var/obj/item/hardpoint/support/artillery_module/AM = get_artillery_module()
		AM?.clear_user_effects(M)

/obj/vehicle/multitile/tank/proc/get_artillery_module() as /obj/item/hardpoint/support/artillery_module
	for(var/obj/item/hardpoint/support/artillery_module/AM in hardpoints)
		return AM
	return null

/**
 * Ensures active_hp[seat] holds a valid, activatable hardpoint whenever one exists.
 * Leaves an existing valid selection alone.
 *
 * Default priority when a new pick is needed:
 * * Gunner: mounted Primary, else mounted Secondary, else null.
 * * Driver: the turret's own flare launcher, else a Secondary slaved to the driver, else null.
 */
/obj/vehicle/multitile/tank/ensure_active_hardpoint(seat)
	if(seat != VEHICLE_DRIVER && seat != VEHICLE_GUNNER)
		return

	var/list/usable_hps = get_activatable_hardpoints(seat)
	var/obj/item/hardpoint/current = active_hp[seat]
	if(current && (current in usable_hps))
		return

	var/obj/item/hardpoint/new_active = null
	if(seat == VEHICLE_GUNNER)
		for(var/obj/item/hardpoint/primary/candidate in usable_hps)
			new_active = candidate
			break
		if(!new_active)
			for(var/obj/item/hardpoint/secondary/candidate in usable_hps)
				new_active = candidate
				break
	else
		for(var/obj/item/hardpoint/holder/tank_turret/candidate in usable_hps)
			new_active = candidate
			break
		if(!new_active)
			for(var/obj/item/hardpoint/secondary/candidate in usable_hps)
				new_active = candidate
				break

	if(current && !QDELETED(current))
		SEND_SIGNAL(current, COMSIG_GUN_INTERRUPT_FIRE)
	active_hp[seat] = new_active
	// Keeps action buttons that depend on the specific active hardpoint correct across every caller of this proc.
	refresh_hardpoint_actions()

/**
 * Re-evaluates which hardpoint-dependent action buttons each seated driver/gunner should have.
 * Also refreshes the icon of every tank action button that mob currently holds.
 */
/obj/vehicle/multitile/tank/refresh_hardpoint_actions()
	for(var/seat in list(VEHICLE_DRIVER, VEHICLE_GUNNER))
		var/mob/living/M = seats[seat]
		if(!istype(M) || !M.client)
			continue

		var/obj/item/hardpoint/support/artillery_module/AM = get_artillery_module()
		if(AM?.is_functional())
			give_action(M, /datum/action/human_action/vehicle_action/toggle_nvg)
			give_action(M, /datum/action/human_action/vehicle_action/toggle_artillery_range)
			add_verb(M.client, list(
				/obj/vehicle/multitile/proc/toggle_artillery_optics,
				/obj/vehicle/multitile/proc/toggle_artillery_nvg,
			))
		else
			remove_action(M, /datum/action/human_action/vehicle_action/toggle_nvg)
			remove_action(M, /datum/action/human_action/vehicle_action/toggle_artillery_range)
			remove_verb(M.client, list(
				/obj/vehicle/multitile/proc/toggle_artillery_optics,
				/obj/vehicle/multitile/proc/toggle_artillery_nvg,
			))

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

//Called when players try to move vehicle
//Another wrapper for try_move()
/obj/vehicle/multitile/tank/relaymove(mob/user, direction)
	if(movement_locked)
		return FALSE

	if(user == seats[VEHICLE_DRIVER])
		// Check if treads are installed
		if(!(locate(/obj/item/hardpoint/locomotion/treads) in hardpoints))
			return FALSE

		// Rider tracking now lives directly in try_move()/try_rotate(), so it fires for every caller.
		var/success = ..()
		if(success)
			revalidate_on_top()
			return TRUE

	// Gunner turret aiming is mouse-driven now (see crew_mousemove() in multitile_interaction.dm).
	return FALSE

// !!!! No point in keeping this now that you can freely climb onto the tank. !!!!
// Unless, maybe, you end up stuck in the center (turret) tile.

// /obj/vehicle/multitile/tank/MouseDrop_T(mob/dropped, mob/user)
// 	. = ..()
// 	if((dropped != user) || !isxeno(user))
// 		return

// 	if(health > 0)
// 		to_chat(user, SPAN_XENO("We can't jump over [src] until it is destroyed!"))
// 		return

// 	var/turf/current_turf = get_turf(user)
// 	var/dir_to_go = get_dir(current_turf, src)
// 	for(var/i in 1 to 3)
// 		current_turf = get_step(current_turf, dir_to_go)
// 		if(!(current_turf in locs))
// 			break

// 		if(current_turf.density)
// 			to_chat(user, SPAN_XENO("The path over [src] is obstructed!"))
// 			return

// 	// Now we check to make sure the turf on the other side of the tank isn't dense too
// 	current_turf = get_step(current_turf, dir_to_go)
// 	if(current_turf.density)
// 		to_chat(user, SPAN_XENO("The path over [src] is obstructed!"))
// 		return

// 	to_chat(user, SPAN_XENO("We begin to jump over [src]..."))
// 	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
// 		to_chat(user, SPAN_XENO("We stop jumping over [src]."))
// 		return

// 	user.forceMove(current_turf)
// 	to_chat(user, SPAN_XENO("We jump to the other side of [src]."))

/**
 * Applies a jousting effect when crashing above a certain speed.
 *
 * Because momentum defines how close a vehicle is to its top speed, 0.5 should mean that the tank will joust its riders...
 * ...After it crashes at anything while above half of its max speed.
 *
 * Keep in mind that momentum decays while standing still, and it can be negative in case we are moving backwards.
 *
 * Checked against whichever of move_momentum or drift_speed is larger, since a sideways skid can be real speed too.
 */
/obj/vehicle/multitile/tank/on_crash()
	if(max(abs(move_momentum), drift_speed) < move_max_momentum * 0.5)
		return
	_scatter_riders_on_crash(max(abs(move_momentum), drift_speed))
	revalidate_on_top()

/// The tank's own turret holder is the only accepted_hardpoints list anywhere that includes Visual Sensors.
/obj/vehicle/multitile/tank/supports_visual_sensors()
	return TRUE

/// Rangefinding is a tank-exclusive gunner feature.
/obj/vehicle/multitile/tank/has_gunner_rangefinder()
	return TRUE

/// Counts every flame mounted atop this tank's own hull. Drives extra engine heat.
/obj/vehicle/multitile/tank/get_mounted_flame_tile_count()
	. = 0
	for(var/obj/flamer_fire/mounted_flame in on_top_obj)
		. += 1

/// Counts every flame burning on this tank's footprint without being mounted, e.g. fire it's driving over.
/obj/vehicle/multitile/tank/get_underneath_flame_tile_count()
	. = 0
	for(var/turf/occupied_turf in locs)
		for(var/obj/flamer_fire/underneath_flame in occupied_turf)
			if(!(underneath_flame in on_top_obj))
				. += 1

/**
 * Applies continuous acid damage from any lingering_acid puddle(s) mounted atop this tank's own hull.
 *
 * Unlike expose_to_lingering_acid()'s own cooldown-throttled hit, this applies every physics tick, but
 * only while the tank is moving. Scaled so the average damage-per-second stays comparable.
 *
 * Arguments:
 * * tick_dt = Delta time for this physics tick.
 */
/obj/vehicle/multitile/tank/apply_mounted_acid_damage(tick_dt)
	if(current_speed <= 0)
		return
	for(var/obj/effect/lingering_acid/puddle in on_top_obj)
		apply_weighted_module_hit(puddle.damage * tick_dt / (LINGERING_ACID_VEHICLE_DAMAGE_COOLDOWN / 10), "acid", null, ignore_aim = TRUE)

/// TRUE while `user` is a Praetorian Dancer with its Dodge ability active. Grants instant tank climbing.
/obj/vehicle/multitile/tank/has_instant_dancer_climb(mob/living/user)
	if(!isxeno(user))
		return FALSE
	var/mob/living/carbon/xenomorph/xeno_user = user
	var/datum/behavior_delegate/praetorian_dancer/dancer_behavior = xeno_user.behavior_delegate
	return istype(dancer_behavior) && dancer_behavior.dodge_activated

/**
 * How compromised the Hatch hardpoint currently is, from 0 (barely wounded) to 1 (about to be destroyed).
 * Takes whichever is further along: active wound tier count or raw integrity loss.
 *
 * Arguments:
 * * installed_hatch = The tank's Hatch hardpoint. Caller already confirmed it exists and isn't destroyed.
 */
/obj/vehicle/multitile/tank/proc/get_hatch_instability_scale(obj/item/hardpoint/hatch/installed_hatch)
	var/wound_fraction = LAZYLEN(installed_hatch.wound_tiers) / 2 // hatch_sticky_latch + hatch_bent_frame, one tier each today
	var/integrity_loss_fraction = 1 - (installed_hatch.get_integrity_percent() / 100)
	return clamp(max(wound_fraction, integrity_loss_fraction), 0, 1)

/**
 * Tank-specific override of get_hatch_lock_result(). Reads the Hatch's wound state instead of the base access rule.
 *
 * * Hatch destroyed, hull destroyed, or unlocked: same as unlocked and healthy, nobody blocked.
 * * Locked and Hatch healthy: entry blocked for anyone without valid access, xenos included. Exit is never blocked.
 * * Locked and Hatch wounded: never blocks, only scales delay.
 *   Marines get progressively slower, xenos faster, and an unauthorized marine is let through slowly instead of denied.
 */
/obj/vehicle/multitile/tank/get_hatch_lock_result(mob/M, entering = TRUE)
	if(!door_locked || health <= 0)
		return list("blocked" = FALSE, "delay_mult" = 1)

	var/obj/item/hardpoint/hatch/installed_hatch = get_hardpoint_by_slot(HDPT_HATCH)
	if(!installed_hatch || installed_hatch.health <= 0)
		return list("blocked" = FALSE, "delay_mult" = 1)

	var/is_authorized = ishuman(M) && allowed(M) && get_target_lock(M.faction_group)

	if(!LAZYLEN(installed_hatch.wound_tiers))
		if(entering && !is_authorized)
			to_chat(M, SPAN_WARNING("\The [src] is locked!"))
			return list("blocked" = TRUE, "delay_mult" = 1)
		return list("blocked" = FALSE, "delay_mult" = 1)

	if(is_authorized)
		var/marine_instability_scale = get_hatch_instability_scale(installed_hatch)
		return list("blocked" = FALSE, "delay_mult" = 1 + marine_instability_scale * (HATCH_WOUNDED_MARINE_MAX_DELAY_MULT - 1))

	if(ishuman(M))
		return list("blocked" = FALSE, "delay_mult" = HATCH_WOUNDED_NON_USCM_DELAY_MULT)

	if(isxeno(M))
		var/xeno_instability_scale = get_hatch_instability_scale(installed_hatch)
		return list("blocked" = FALSE, "delay_mult" = HATCH_WOUNDED_XENO_START_MULT - xeno_instability_scale * (HATCH_WOUNDED_XENO_START_MULT - HATCH_WOUNDED_XENO_MIN_MULT))

	if(entering)
		to_chat(M, SPAN_WARNING("\The [src] is locked!"))
		return list("blocked" = TRUE, "delay_mult" = 1)
	return list("blocked" = FALSE, "delay_mult" = 1)

//-----------------------------
// ammo cookoff.
//-----------------------------

/// Kicks off the shared cookoff sequence (multitile_cookoff.dm) the instant hull health first reaches 0.
/obj/vehicle/multitile/tank/on_hull_destroyed()
	start_hull_cookoff_sequence()

/// The tank's one "something special" to eject once the hull cooks off: its turret, with every nested weapon.
/obj/vehicle/multitile/tank/launch_special_wreckage()
	launch_turret_wreckage()

/**
 * Physically launches the Turret holder into the air as wreckage. Every nested weapon comes along for free since they live inside it.
 * Bypasses remove_hardpoint() (which would qdel() it outright) and hand-rolls the reparenting instead, so the wreckage persists and lands somewhere.
 */
/obj/vehicle/multitile/tank/proc/launch_turret_wreckage()
	var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
	if(!turret)
		return

	// The exterior explosion is still lingering here, so mark the wreckage immune before moving it onto this turf.
	turret.explo_proof = TRUE

	for(var/obj/item/hardpoint/nested in turret.hardpoints)
		nested.explo_proof = TRUE

	hardpoints -= turret
	turret.owner = null

	var/turf/launch_turf = get_turf(src)
	turret.forceMove(launch_turf)
	turret.pixel_y = initial(turret.pixel_y)
	render_turret_wreck_visuals(turret)

	playsound(launch_turf, 'sound/effects/metal_crash.ogg', 60, TRUE)
	var/datum/effect_system/spark_spread/launch_sparks = new
	launch_sparks.set_up(5, 0, launch_turf)
	launch_sparks.start()

	// Brief "shoots up" beat before drop_turret_wreckage() wraps it in a droppod and drops it at the landing turf.
	animate(turret, pixel_y = 48, time = 0.3 SECONDS, easing = QUAD_EASING)
	addtimer(CALLBACK(src, PROC_REF(drop_turret_wreckage), turret, launch_turf), 0.3 SECONDS)

/// Builds the turret's own standalone appearance now that it's a loose object again, instead of the vehicle's usual overlay compositing.
/obj/vehicle/multitile/tank/proc/render_turret_wreck_visuals(obj/item/hardpoint/holder/tank_turret/turret)
	turret.update_icon()

/// Wraps the airborne turret in a droppod and sends it falling toward a random turf near where it launched.
/obj/vehicle/multitile/tank/proc/drop_turret_wreckage(obj/item/hardpoint/holder/tank_turret/turret, turf/launch_turf)
	turret.pixel_y = initial(turret.pixel_y)
	var/turf/landing_turf = get_turret_wreckage_landing_turf(launch_turf)
	var/obj/structure/droppod/wreck/pod = new(launch_turf, turret)
	pod.launch(landing_turf)

/**
 * Picks a random valid, open turf near `origin` for a piece of turret wreckage to land on.
 * Widens the search outward if the normal ring is entirely blocked. Only returns `origin` itself as a last resort.
 */
/obj/vehicle/multitile/tank/proc/get_turret_wreckage_landing_turf(turf/origin)
	var/list/candidates = get_valid_turret_landing_turfs(origin, HULL_COOKOFF_TURRET_LAUNCH_MIN_RANGE, HULL_COOKOFF_TURRET_LAUNCH_MAX_RANGE)
	if(length(candidates))
		return pick(candidates)

	for(var/search_range = HULL_COOKOFF_TURRET_LAUNCH_MAX_RANGE + 1, search_range <= 10, search_range++)
		candidates = get_valid_turret_landing_turfs(origin, search_range, search_range)
		if(length(candidates))
			return pick(candidates)

	return origin

/// Every genuinely open, non-dense, non-space turf between min_range and max_range tiles of origin.
/obj/vehicle/multitile/tank/proc/get_valid_turret_landing_turfs(turf/origin, min_range, max_range)
	. = list()
	for(var/turf/open/candidate_turf in range(max_range, origin))
		if(istype(candidate_turf, /turf/open/space) || candidate_turf.density)
			continue
		var/distance = get_dist(origin, candidate_turf)
		if(distance < min_range || distance > max_range)
			continue
		. += candidate_turf

/*
** PRESETS SPAWNERS
*/
/obj/effect/vehicle_spawner/tank
	name = "Tank Spawner"
	icon = 'icons/obj/vehicles/tank.dmi'
	icon_state = "tank_base"
	pixel_x = -48
	pixel_y = -48

/obj/effect/vehicle_spawner/tank/Initialize()
	. = ..()
	spawn_vehicle()
	qdel(src)

//PRESET: turret, no hardpoints (not the one without turret for convenience, you still expect to have turret when you spawn "no hardpoints tank")
/obj/effect/vehicle_spawner/tank/spawn_vehicle()
	var/obj/vehicle/multitile/tank/TANK = new (loc)

	load_misc(TANK)
	load_hardpoints(TANK)
	handle_direction(TANK)
	TANK.update_icon()

	return TANK

/obj/effect/vehicle_spawner/tank/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	load_logistics_hardpoints(V)

/**
 * Installs the baseline logistics parts every non-bare-hull tank preset spawns with, plus the modules mounted on the turret.
 * Requires a turret to already be installed on `V`.
 */
/obj/effect/vehicle_spawner/tank/proc/load_logistics_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/engine/tank)
	V.add_hardpoint(new /obj/item/hardpoint/fuel_tank/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/radiator/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/battery/uscm)
	V.add_hardpoint(new /obj/item/hardpoint/hatch/armored/uscm)

	for(var/obj/item/hardpoint/holder/tank_turret/turret in V.hardpoints)
		turret.add_hardpoint(new /obj/item/hardpoint/iff_module/uscm)
		turret.add_hardpoint(new /obj/item/hardpoint/visual_sensors/uscm)
		turret.add_hardpoint(new /obj/item/hardpoint/turret_ring/uscm)
		turret.add_hardpoint(new /obj/item/hardpoint/air_filter/uscm)
		break

//PRESET: turret, treads installed
/obj/effect/vehicle_spawner/tank/plain/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	load_logistics_hardpoints(V)

//PRESET: no hardpoints
/obj/effect/vehicle_spawner/tank/hull/load_hardpoints(obj/vehicle/multitile/tank/V)
	return

//Just the hull and it's broken TOO, you get the full experience
/obj/effect/vehicle_spawner/tank/hull/broken/spawn_vehicle()
	var/obj/vehicle/multitile/tank/tonk = ..()
	load_damage(tonk)
	tonk.update_icon()

//PRESET: default hardpoints, destroyed
/obj/effect/vehicle_spawner/tank/decrepit/spawn_vehicle()
	var/obj/vehicle/multitile/tank/TANK = new (loc)

	load_misc(TANK)
	handle_direction(TANK)
	load_hardpoints(TANK)
	load_damage(TANK)
	TANK.update_icon()

/obj/effect/vehicle_spawner/tank/decrepit/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	V.add_hardpoint(new /obj/item/hardpoint/armor/paladin)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	load_logistics_hardpoints(V)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/cannon)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola)
		break

//PRESET: default hardpoints
/obj/effect/vehicle_spawner/tank/fixed/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	V.add_hardpoint(new /obj/item/hardpoint/armor/paladin)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	load_logistics_hardpoints(V)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/cannon)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/m56cupola)
		break

//PRESET: minigun kit
/obj/effect/vehicle_spawner/tank/fixed/minigun/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/weapons_sensor)
	V.add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	load_logistics_hardpoints(V)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/minigun)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/small_flamer)
		break

//PRESET: dragon flamer kit
/obj/effect/vehicle_spawner/tank/fixed/flamer/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/overdrive_enhancer)
	V.add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	load_logistics_hardpoints(V)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/flamer)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/grenade_launcher)
		break

//PRESET: autocannon kit
/obj/effect/vehicle_spawner/tank/fixed/autocannon/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/support/artillery_module)
	V.add_hardpoint(new /obj/item/hardpoint/armor/ballistic)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	load_logistics_hardpoints(V)
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/autocannon)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/towlauncher)
		break
