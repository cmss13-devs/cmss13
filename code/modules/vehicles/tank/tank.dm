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

	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_3_ambulence.ogg'

	required_skill = SKILL_VEHICLE_LARGE

	vehicle_flags = VEHICLE_CLASS_MEDIUM

	move_max_momentum = 3
	move_momentum_build_factor = 1.8
	move_turn_momentum_loss_factor = 0.6

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
		/obj/item/hardpoint/armor/snowplow,
		/obj/item/hardpoint/locomotion/treads,
		/obj/item/hardpoint/locomotion/treads/robust,
	)

	seats = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

	active_hp = list(
		VEHICLE_DRIVER = null,
		VEHICLE_GUNNER = null,
	)

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

	var/list/on_top_mobs = list() /// keeps track of all mobs currently atop the tank
	var/on_top_mobs_shooting_inaccuracy_time = 0 /// world_time must be bigger than this so mobs don't get penalized for shooting while atop the tank.

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
	RRS.roles = list(JOB_TANK_CREW, JOB_WO_CREWMAN, JOB_UPP_CREWMAN, JOB_PMC_CREWMAN)
	RRS.total = 2
	role_reserved_slots += RRS

/obj/vehicle/multitile/tank/load_hardpoints()
	add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)

/obj/vehicle/multitile/tank/add_seated_verbs(mob/living/M, seat)
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
		))
	else if(seat == VEHICLE_GUNNER)
		add_verb(M.client, list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_gyrostabilizer,
		))


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
		))
	else if(seat == VEHICLE_GUNNER)
		remove_verb(M.client, list(
			/obj/vehicle/multitile/proc/cycle_hardpoint,
			/obj/vehicle/multitile/proc/toggle_gyrostabilizer,
		))

//Called when players try to move vehicle
//Another wrapper for try_move()
/obj/vehicle/multitile/tank/relaymove(mob/user, direction)
	if(user == seats[VEHICLE_DRIVER])
		// Check if treads are installed
		if(!(locate(/obj/item/hardpoint/locomotion/treads) in hardpoints))
			return FALSE

		// this if statement seems redundant with var/success = ..() below
		// but it prevents a massive performance overhead:
		// we only run transform math when we are ready to move...
		// ...instead of every instant while a movement key is held
		if(!(world.time < next_move))
			// PRE-STATE snapshot
			var/list/oldc = _current_center()
			var/old_cx = oldc[1]
			var/old_cy = oldc[2]
			var/old_dir = dir

			var/success = ..()
			if(success)
				// POST-STATE snapshot
				var/list/newc = _current_center()
				var/new_cx = newc[1]
				var/new_cy = newc[2]
				var/new_dir = dir
				if(new_cx != old_cx || new_cy != old_cy || new_dir != old_dir)
					_update_riders_after_motion(old_cx, old_cy, old_dir, new_cx, new_cy, new_dir)
				revalidate_on_top()
				return TRUE

	if(user != seats[VEHICLE_GUNNER])
		return FALSE
	var/obj/item/hardpoint/holder/tank_turret/T = null
	for(var/obj/item/hardpoint/holder/tank_turret/TT in hardpoints)
		T = TT
		break
	if(!T)
		return FALSE

	if(direction == GLOB.reverse_dir[T.dir] || direction == T.dir)
		return FALSE

	T.user_rotation(user, turning_angle(T.dir, direction))
	update_icon()
	return TRUE

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
 * This is a somewhat hacky implementation, since the maximum momentum of vehicles
 * can change based on the type of wheels used. IE: Reinforced treads make it easier to attain
 * the needed 1.6 momentum, while it's a bit harder with normal treads.
 *
 * 1.6, while a magic number and a code smell, was the value that worked best to prevent riders from being scattered
 * at low speeds, while also ensuring they were scattered after the tank accelerated 2 tiles on normal treads.
 */
/obj/vehicle/multitile/tank/on_crash()
	if(abs(move_momentum) < 1.6)
		return
	_scatter_riders_on_crash()
	revalidate_on_top()

/**
 * Collided handles what happens when something bumps into the tank.
 *
 * If we are being bumped by our riders, we'll do nothing.
 * Otherwise, we will attempt to climb if we pass through the edge cases on each if statement.
 *
 * Arguments:
 * * atom/movable/AM - The atom bumping into the tank.
 */
/obj/vehicle/multitile/tank/Collided(atom/movable/AM)
	if(_is_our_rider(AM))
		return

	if(!ismob(AM))
		if(istype(AM, /obj))
			var/obj/O = AM
			if(O.buckled_mob)
				Collided(O.buckled_mob)
		return ..()

	var/mob/living/M = AM
	if(!istype(M))
		return ..()
	if(M.action_busy)
		return
	if(M.pulledby || M.throwing)
		return
	var/turf/facing_turf = get_step(get_turf(M), M.dir)
	if(!facing_turf)
		return ..()
	if(M.resting)
		M.forceMove(facing_turf)
		return ..()
	if(get_turf(M) in locs)
		return

	climb_onto(M, facing_turf)
	return

/**
 * climb_onto is called by Collided to allow a mob to climb onto the tank.
 *
 * We run a number of edge case checks first, then we begin the process of climbing properly.
 * It takes 1.5 seconds, and, after that, if the spot is still reachable (AKA, if the tank hasn't driven away)
 * then we'll climb up!
 *
 * We also call _carry_move_with_grabs to pull grabbed mobs in with us.
 * ^^ Kind of how you can grab people when stepping into a window frame to pull them in.
 *
 * Arguments:
 * * mob/living/user - The mob trying to get atop the tank
 * * turf/preferred  - The exact 'turf' of the tank we want to climb upon.
 * *    As in: Bumping into the middle tile of a side shouldn't make you climb up onto another tile.
 */
/obj/vehicle/multitile/tank/proc/climb_onto(mob/living/user, turf/preferred)
	if(!istype(user))
		return
	if(user.action_busy)
		return
	if(!_validate_climb_target(user, preferred, TRUE)) {
		to_chat(user, SPAN_WARNING("You can't climb there."))
		return
	}
	user.visible_message(
		SPAN_WARNING("[user] starts climbing onto [src]."),
		SPAN_WARNING("You start climbing onto [src]."))
	if(!do_after(user, 1.5 SECONDS, INTERRUPT_MOVED, BUSY_ICON_CLIMBING)) {
		to_chat(user, SPAN_WARNING("You stop climbing onto [src]."))
		return
	}
	if(!_validate_climb_target(user, preferred, TRUE)) {
		to_chat(user, SPAN_WARNING("The spot on [src] is no longer reachable."))
		return
	}
	_carry_move_with_grabs(user, preferred, TRUE)
	user.visible_message(
		SPAN_WARNING("[user] climbs onto [src]."),
		SPAN_WARNING("You climb onto [src]."))
	return

/**
 * climb_down is called inside living.dm by _handle_tank_edge_move(), which is called by Move()
 *
 * This proc handles climbing down normally, and, if allowed to run, will result in a successful disembark.
 *
 * Climbing down was a bit more tricky to implement than climbing up, since we need to block movement into-
 * what would otherwise be a 'free', open tile.
 *
 * The code is pretty self-explanatory. Of note is the fact that we only interrupt on an incapacitation. This is to allow
 * easier disembarking even when the tank is moving.
 * Arguments:
 * * mob/living/user - The mob trying to get down the tank
 * * turf/target     - The exact 'turf' of the tank we want to climb down onto.
 */
/obj/vehicle/multitile/tank/proc/climb_down(mob/living/user, turf/target)
	if(user.action_busy)
		return

	if(!_validate_climb_target(user, target, FALSE)) {
		return
	}

	user.visible_message(
		SPAN_WARNING("[user] starts climbing down from [src]."),
		SPAN_WARNING("You start climbing down from [src]."))

	if(!do_after(user, 1 SECONDS, INTERRUPT_INCAPACITATED, BUSY_ICON_GENERIC)) {
		to_chat(user, SPAN_WARNING("You stop climbing down from [src]."))
		return
	}
	// edge case where tank moves while we're climbing down
	if(!_validate_climb_target(user, target, FALSE)) {
		to_chat(user, SPAN_WARNING("The spot is no longer reachable."))
		return
	}
	clear_on_top(user)
	user.forceMove(target)
	user.visible_message(
		SPAN_WARNING("[user] climbs down from [src]."),
		SPAN_WARNING("You climb down from [src]."))
	return

/**
 * mark_on_top marks mobs as riders of a specific tank.
 *
 * This proc does three things:
 *
 * It adds a mob to the tank's list of passengers (on_top_mobs)
 * It adds the tank to a mob's tank_on_top_of var
 * It calls _apply_rider_visuals() to set the layer atop the tank's
 *
 * Arguments:
 * * mob/living/M - The mob being marked ontop.
 */
/obj/vehicle/multitile/tank/proc/mark_on_top(mob/living/M)
	if(!istype(M))
		return
	if(M.z != z)
		return
	if(!(get_turf(M) in locs))
		return
	if(M.tank_on_top_of == src)
		return
	on_top_mobs |= M
	M.tank_on_top_of = src
	_apply_rider_visuals(M)

/**
 * clear_on_top removes rider effects from a mob who was previously atop the tank.
 *
 * This proc resets the layer and plane of a rider.
 * This proc removes a rider from the on_top_mobs list of the tank.
 * This proc sets the tank_on_top_of variable of a mob to null.
 *
 * Arguments:
 * * mob/living/M - The mob who has disembarked.
 */
/obj/vehicle/multitile/tank/proc/clear_on_top(mob/living/M)
	if(!istype(M))
		return
	on_top_mobs -= M
	if(M.tank_on_top_of == src)
		M.tank_on_top_of = null
	M.layer   = initial(M.layer)
	M.plane   = initial(M.plane)
	M.pixel_y = initial(M.pixel_y)

/**
 * Destroy proc. This shouldn't normally be called, but just in case.
 *
 * This proc ensures all mobs atop the tank are cleared.
 * we also cut the on_top_mobs list, just in case DM doesn't have garbage collection.
 *
 */
/obj/vehicle/multitile/tank/Destroy()
	for(var/mob/living/M in on_top_mobs.Copy())
		if(M)
			clear_on_top(M)
	on_top_mobs.Cut()
	return ..()

/**
 * revalidate_on_top checks if a mob is still atop the tank.
 *
 * This proc goes through all of the mobs in the tank's on_top_mobs list and either:
 *  - removes them from the list if they're not on the same tile anymore
 *  - refreshes rider visuals
 *
 * This proc probably doesn't need to be called, and you might be able to get away with removing it if it's a performance issue.
 * It's just there for safety.
 */
/obj/vehicle/multitile/tank/proc/revalidate_on_top()
	for(var/mob/living/M in on_top_mobs.Copy())
		if(!M || M.z != z || !(get_turf(M) in locs))
			clear_on_top(M)
		else
			_apply_rider_visuals(M)

/**
 * BlockedPassDirs allows us to move atop the tank if we're on top of it.
 *
 * You might've noticed that this method is in UpperCamelCase instead of snake_case.
 * This is because we're overriding a method from /atom.
 *
 * This proc checks if the atom mover is a mob, and, if it is, allows it to move freely atop the tank.
 *
 * * Arguments:
 * * atom/movable/mover - The atom attempting to move in a tank turf.
 * * target_dir         - The direction we're moving towards.
 */
/obj/vehicle/multitile/tank/BlockedPassDirs(atom/movable/mover, target_dir)
	if(ismob(mover))
		var/mob/living/M = mover
		if(istype(M) && M.tank_on_top_of == src)
			var/turf/start = get_turf(M)
			var/turf/target = get_step(start, target_dir)
			if(target && (target in src.locs))
				return NO_BLOCKED_MOVEMENT
	var/ret = ..()
	if(ret != null)
		return ret
	return null

/**
 * take_damage_type handles taking damage when the tank gets attacked.
 *
 * Because xenos can now hop atop the tank to attack it in a fairly one-sided display of force, I've introduced
 * this function to make destroying the tank a bit slower. This might be removed if/once someone (i) get(s) around to
 * making tank hardpoints repairable.
 *
 * Xenos atop the tank are flat-out unable to hit the Treads module. This is to allow the tank to run back
 * towards marines. Also, it's impossible to break the treads from ontop. How are you going to reach them?
 *
 * Xenos atop the tank also suffer a 30% damage penalty, again, to give time for tank crewmembers to retreat to
 * safety.
 *
 * * Arguments:
 * * damage        -  Numeric value of damage.
 * * type          -  Damage type. Brute, Slash, Acid...
 * * atom/attacker -  Whoever is damaging the tank
 */
/obj/vehicle/multitile/tank/take_damage_type(damage, type, atom/attacker)
	if(type == "slash" && istype(attacker, /mob/living/carbon/xenomorph))
		var/mob/living/carbon/xenomorph/X = attacker

		// must actually be on top of THIS tank (exterior), same z, and stading on one of our tiles
		if(X.tank_on_top_of == src && X.z == z)
			var/turf/xturf = get_turf(X)
			if(xturf && (xturf in src.locs))
				var/adj_damage = damage * 0.7
				var/all_broken = TRUE
				var/dmg_multi = get_dmg_multi(type)

				for(var/obj/item/hardpoint/H in hardpoints)
					if(istype(H, /obj/item/hardpoint/locomotion/treads))
						continue
					// turret doesn't count as a 'hardpoint' for all_broken, otherwise the tank is... too tanky.
					if(istype(H, /obj/item/hardpoint/holder/tank_turret))
						H.take_damage(floor(adj_damage * dmg_multi))
						continue
					if(H.can_take_damage())
						H.take_damage(floor(adj_damage * dmg_multi))
						all_broken = FALSE

				// If all *eligible* hardpoints are broken, the frame begins taking full damage...
				// ...otherwise, the frame takes one tenth, just like the base behavior.
				if(all_broken)
					health = max(0, health - adj_damage * dmg_multi)
				else
					health = max(0, health - floor(adj_damage * dmg_multi / 10))
				if(ismob(attacker))
					var/mob/M = attacker
					log_attack("[src] took [adj_damage] [type] damage (top-hit penalty) from [M] ([M.client ? M.client.ckey : "disconnected"]).")
				else
					log_attack("[src] took [adj_damage] [type] damage (top-hit penalty) from [attacker].")
				update_icon()
				return
	return ..()

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

//PRESET: turret, treads installed
/obj/effect/vehicle_spawner/tank/plain/load_hardpoints(obj/vehicle/multitile/tank/V)
	V.add_hardpoint(new /obj/item/hardpoint/holder/tank_turret)
	V.add_hardpoint(new /obj/item/hardpoint/locomotion/treads)

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
	for(var/obj/item/hardpoint/holder/tank_turret/TT in V.hardpoints)
		TT.add_hardpoint(new /obj/item/hardpoint/primary/autocannon)
		TT.add_hardpoint(new /obj/item/hardpoint/secondary/towlauncher)
		break
