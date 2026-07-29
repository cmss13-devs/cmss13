/**
 * Hardpoints are any items that attach to a base vehicle, such as wheels/treads, support systems and guns
 */
/obj/item/hardpoint
	//------MAIN VARS----------
	/// Which slot is this hardpoint in. Purely to check for conflicting hardpoints.
	var/slot
	/// Overrides which slot this hardpoint's wound families roll under. Null uses its real slot.
	var/wound_family_slot
	/// The vehicle this hardpoint is installed on.
	var/obj/vehicle/multitile/owner

	health = 100
	w_class = SIZE_LARGE

	/// Determines how much of any incoming damage is actually taken.
	var/damage_multiplier = 1

	/// Cumulative Acid damage taken, capped at max health. Drives acid wound rolls.
	var/acid_damage_taken = 0
	/// Cumulative Brute damage taken, capped at max health. Drives brute wound rolls.
	var/brute_damage_taken = 0
	/// wound_family_id -> current tier. Missing/0 means no wound of that family yet.
	var/list/wound_tiers
	/// wound_family_id -> list("tier", "step") tracking repair progress on the current tier.
	var/list/wound_repair_progress

	/// Power (units/sec) this hardpoint draws while installed and undamaged. 0 for most hardpoints.
	var/power_draw = 0

	/// Origin coords of the hardpoint relative to the vehicle.
	var/list/origins = list(0, 0)

	var/list/buff_multipliers
	var/list/type_multipliers

	var/buff_applied = FALSE

	//------ICON VARS----------
	icon = 'icons/obj/vehicles/hardpoints/tank.dmi'
	icon_state = "tires" //Placeholder

	//Strings, used to get the overlay for the armored vic
	var/disp_icon //This also differentiates tank vs apc vs other
	var/disp_icon_state

	/// List of pixel offsets for each direction.
	var/list/px_offsets

	// pivots used to calculate the correctt rotation both for secondary hardpoints and for primary hardpoints.
	// because the secondary hardpoints are rotating WITH the turret, but also AROUND themselves, they need two pivots.
	var/list/rotation_pivot
	var/list/gimbal_pivot

	/// Visual layer of hardpoint when on vehicle.
	var/hdpt_layer = HDPT_LAYER_WHEELS

	/// List of offsets for where to place the muzzle flash for each direction.
	var/list/muzzle_flash_pos = list(
		"1" = list(0, 0),
		"2" = list(0, 0),
		"4" = list(0, 0),
		"8" = list(0, 0)
	)

	// debug vars
	var/use_mz_px_offsets = FALSE
	var/use_mz_trt_offsets = FALSE

	var/const_mz_offset_x = 0
	var/const_mz_offset_y = 0

	//------SOUNDS VARS----------
	/// Sounds to play when the module activated/fired.
	var/list/activation_sounds



	//------INTERACTION VARS----------

	/// Which seat can use this module.
	var/allowed_seat = VEHICLE_GUNNER

	/// Whether hardpoint has activatable ability like shooting or zooming.
	var/activatable = 0

	/// Used to prevent welder click spam.
	var/being_repaired = FALSE

	/// How fast this weapon can traverse.
	var/traverse_arc = 0 //in degrees. 0 skips whole arc of fire check on fixed mounts

	/// If TRUE, this hardpoint runs its own independent mouse-aim rotation (current_angle/rotation_loop below) instead of following its holder's rotate() cascade - see /obj/item/hardpoint/secondary/proc/toggle_slaved_to_driver().
	var/self_gimballed = FALSE

	/// If TRUE, this hardpoint is mounted directly on the vehicle and gets live rotation tracking. TRUE on primary/secondary.
	var/uses_live_rotation_tracking = FALSE
	/// If TRUE, this hardpoint holds its own facing independent of hull rotation.
	var/gyro = FALSE
	/// Safety lock. While TRUE, forces gyro off and locks this hardpoint to hull facing.
	var/turret_safety_on = FALSE
	/// Looping rotation sound, active while this hardpoint is rotating.
	var/datum/looping_sound/tank_turret/rotation_soundloop
	/// If TRUE, tthis hardpoint loads star shells/star shell packets directly (attackby()) instead of swapping magazines, and fires them at a randomized point ahead of the vehicle. TRUE on the tank's turret and the APC's flare launcher.
	var/uses_starshell_ammo = FALSE
	/// Width, in degrees, of the arc in front of the hull a fired star shell can land within.
	var/flare_spread = 45
	/// Minimum tiles in front of the hull a fired star shell can land.
	var/flare_range_min = 5
	/// Maximum tiles in front of the hull a fired star shell can land.
	var/flare_range_max = 9
	/// The hardpoint's live, continuously-simulated facing (0-360, north-clockwise). Distinct from dir, which stays snapped to a cardinal for sprite selection. Only meaningful for the turret itself, or a self_gimballed hardpoint.
	var/current_angle = 0
	/// Where the mouse currently wants this hardpoint to face (0-360, north-clockwise). current_angle chases this.
	var/desired_angle = 0
	/// Current turn speed, in degrees per tick, ramped toward max_angular_velocity.
	var/angular_velocity = 0
	/// Turn speed cap for this hardpoint.
	var/max_angular_velocity = TURRET_DEFAULT_ANGULAR_VELOCITY
	/// How fast angular_velocity ramps up/down, in degrees per tick^2.
	var/angular_accel = TURRET_ANGULAR_ACCEL
	/// Guards against spawning more than one concurrent rotation_loop().
	var/rotation_active = FALSE
	/// world.time of the last processed mouse-move, used to rate-limit update_desired_angle().
	var/last_desired_update_time = 0
	/// While TRUE, update_desired_angle() no-ops - set on whichever object get_rotation_owner() resolves
	/// to while a track_and_charge() lock-on is in progress, so live mouse input can't fight it.
	var/aim_locked = FALSE
	/// Guards against spawning more than one concurrent track_and_charge() on this hardpoint.
	var/charging = FALSE
	/// Set by cancel_charge() (COMSIG_GUN_STOP_FIRE/COMSIG_GUN_INTERRUPT_FIRE) to abort an in-progress
	/// track_and_charge() loop. Distinct from fire_wait_cancelled, which guards a different wait
	/// (arc-entry, not an active charge) and could otherwise interfere if both were active at once.
	var/charge_cancelled = FALSE
	var/trigger_held = FALSE

	// Muzzleflash
	var/use_muzzle_flash = FALSE
	var/muzzleflash_icon_state = "muzzle_flash"
	var/underlayer_north_muzzleflash = FALSE
	var/angle_muzzleflash = TRUE

	//------AMMUNITION VARS----------

	/// Currently loaded ammo that we shoot from.
	var/obj/item/ammo_magazine/hardpoint/ammo
	/// The type of magazine this hardpoint accepts, cached from ammo's class-default in Initialize()
	/// unlike ammo itself, this stays set even while ammo is temporary null, so
	/// get_hardpoints_with_ammo()/try_add_clip()/the weapons loader can still recognize this
	/// hardpoint as reloadable and know whatt magazine type to accept
	var/ammo_type
	/// Spare magazines that we can reload from.
	var/list/backup_clips
	/// Maximum amount of spare mags.
	var/max_clips = 0

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to a projectile fired from the hardpoint.
	var/list/list/traits_to_give

	/// How much the bullet scatters when fired, in degrees.
	var/scatter = 0
	/// How many bullets the gun fired while burst firing/auto firing.
	var/shots_fired = 0
	/// Delay before a new firing sequence can start.
	COOLDOWN_DECLARE(fire_cooldown)
	/// Set by cancel_firing_arc_wait() to break out of wait_for_firing_arc() early.
	var/fire_wait_cancelled = FALSE

	// Firemodes.
	/// Current selected firemode of the gun.
	var/gun_firemode = GUN_FIREMODE_SEMIAUTO
	/// List of allowed firemodes.
	var/list/gun_firemode_list = list(
		GUN_FIREMODE_SEMIAUTO,
	)

	// Semi-auto and full-auto.
	/// For regular shots, how long to wait before firing again. Use modify_fire_delay and set_fire_delay instead of modifying this on the fly
	var/fire_delay = 0
	/// The multiplier for how much slower this should fire in automatic mode. 1 is normal, 1.2 is 20% slower, 2 is 100% slower, etc. Protected due to it never needing to be edited.
	var/autofire_slow_mult = 1
	/// If the gun is currently auto firing.
	var/auto_firing = FALSE

	// Burst fire.
	/// How many shots can the weapon shoot in burst? Anything less than 2 and you cannot toggle burst. Use modify_burst_amount and set_burst_amount instead of modifying this
	var/burst_amount = 1
	/// The delay in between shots. Lower = less delay = faster. Use modify_burst_delay and set_burst_delay instead of modifying this
	var/burst_delay = 1
	/// When burst-firing, this number is extra time before the weapon can fire again.
	var/extra_delay = 0
	/// If the gun is currently burst firing.
	var/burst_firing = FALSE

	/// Currently selected target to fire at. Set with set_target().
	var/atom/target
	/// The type of projectile to fire
	var/projectile_type = /obj/projectile
	/// How many ammo.current_rounds a single base handle_fire() shot costs. The flamer hardpoints (primary/flamer.dm, secondary/flamer.dm) set this to 0 and do their own reagent-based fuel deduction instead, since their ammo tracks real chemical volume rather than plain integer rounds.
	var/ammo_cost_per_shot = 1

//-----------------------------
//------GENERAL PROCS----------
//-----------------------------

/obj/item/hardpoint/p_s(temp_gender)
	if(!temp_gender)
		temp_gender = gender
	if(temp_gender == PLURAL)
		. = "s"

/obj/item/hardpoint/Initialize()
	. = ..()
	set_bullet_traits()
	if(ammo)
		ammo_type = ammo.type
	AddComponent(/datum/component/automatedfire/autofire, fire_delay, burst_delay, burst_amount, gun_firemode, autofire_slow_mult, CALLBACK(src, PROC_REF(set_burst_firing)), CALLBACK(src, PROC_REF(reset_fire)), CALLBACK(src, PROC_REF(fire_wrapper)), callback_set_firing = CALLBACK(src, PROC_REF(set_auto_firing)))
	if(uses_live_rotation_tracking)
		rotation_soundloop = new(src)

/obj/item/hardpoint/Destroy()
	if(owner)
		owner.remove_hardpoint(src)
		owner.update_icon()
		owner = null
	QDEL_NULL_LIST(backup_clips)
	QDEL_NULL(ammo)
	set_target(null)
	QDEL_NULL(rotation_soundloop)
	return ..()

/obj/item/hardpoint/ex_act(severity)
	if(owner || explo_proof)
		return

	take_damage(severity / 2, "explosive")
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] disintegrates into useless pile of scrap under the damage it suffered."))
		deconstruct(TRUE)

/// Populate traits_to_give in this proc
/obj/item/hardpoint/proc/set_bullet_traits()
	return

/obj/item/hardpoint/proc/generate_bullet(mob/user, turf/origin_turf)
	var/obj/projectile/P = new projectile_type(origin_turf, create_cause_data(initial(name), user))
	P.generate_bullet(new ammo.default_ammo)
	P.effective_range_max = P.ammo.effective_range_max
	P.effective_range_min = P.ammo.effective_range_min
	// Apply bullet traits from gun
	for(var/entry in traits_to_give)
		var/list/L
		// Check if this is an ID'd bullet trait
		if(istext(entry))
			L = traits_to_give[entry].Copy()
		else
			// Prepend the bullet trait to the list
			L = list(entry) + traits_to_give[entry]
		P.apply_bullet_trait(L)
	return P

/**
 * Applies damage, tracks it into the Acid/Brute sub-pool, and rolls for a wound.
 *
 * Arguments:
 * * damage = Raw incoming damage, pre-damage_multiplier.
 * * type = Damage type used for wound rolling. Defaults to "abstract", which never rolls a wound.
 * * attacker = Who dealt the hit, if known. Used to aim wound effects like shrapnel.
 * * unmitigated = Skips damage_multiplier, but still rolls wounds.
 * * wound_chance_mult = Multiplies the wound roll chance for this hit.
 */
/obj/item/hardpoint/proc/take_damage(damage, type = "abstract", atom/attacker, unmitigated = FALSE, wound_chance_mult = 1)
	if(health <= 0)
		return
	var/applied_damage = unmitigated ? damage : damage * damage_multiplier
	health = max(0, health - applied_damage)

	var/mapped_type = wound_damage_type_for(type)
	if(mapped_type == WOUND_DAMTYPE_ACID)
		acid_damage_taken += applied_damage
	else if(mapped_type == WOUND_DAMTYPE_BRUTE)
		brute_damage_taken += applied_damage
	if(mapped_type)
		roll_wounds(applied_damage, mapped_type, attacker, wound_chance_mult)

	if(!health)
		on_destroy()
		owner?.ensure_active_hardpoint(VEHICLE_DRIVER)
		owner?.ensure_active_hardpoint(VEHICLE_GUNNER)

/**
 * Applies raw damage to health only. No wound tracking or rolling.
 * Used for splash damage bleeding between a parent and its mounted children.
 *
 * Arguments:
 * * damage = Raw incoming damage, pre-damage_multiplier.
 */
/obj/item/hardpoint/proc/deal_raw_damage(damage)
	if(health <= 0 || damage <= 0)
		return
	health = max(0, health - damage * damage_multiplier)
	if(!health)
		on_destroy()
		owner?.ensure_active_hardpoint(VEHICLE_DRIVER)
		owner?.ensure_active_hardpoint(VEHICLE_GUNNER)

/// Same as deal_raw_damage(), but also skips damage_multiplier for a fully unblocked hit.
/obj/item/hardpoint/proc/deal_unmitigated_damage(damage)
	if(health <= 0 || damage <= 0)
		return
	health = max(0, health - damage)
	if(!health)
		on_destroy()
		owner?.ensure_active_hardpoint(VEHICLE_DRIVER)
		owner?.ensure_active_hardpoint(VEHICLE_GUNNER)

/obj/item/hardpoint/proc/on_destroy()
	return

/obj/item/hardpoint/proc/is_activatable()
	if(health <= 0)
		return FALSE
	return activatable

//returns the integrity of the hardpoint module
/obj/item/hardpoint/proc/get_integrity_percent()
	return 100.0*health/initial(health)

/// Apply hardpoint effects to vehicle and self.
/obj/item/hardpoint/proc/on_install(obj/vehicle/multitile/vehicle)
	if(!vehicle) //in loose holder
		return
	RegisterSignal(vehicle, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES, PROC_REF(recalculate_hardpoint_bonuses))
	apply_buff(vehicle)
	vehicle.refresh_hardpoint_actions()
	if(uses_live_rotation_tracking)
		// Spawns facing dir's default (south) instead of current_angle's own default (north).
		current_angle = dir2angle(dir)
		desired_angle = current_angle
	recalculate_own_turn_rate()

/// Remove hardpoint effects from vehicle and self.
/obj/item/hardpoint/proc/on_uninstall(obj/vehicle/multitile/vehicle)
	if(!vehicle) //in loose holder
		return
	UnregisterSignal(vehicle, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)
	remove_buff(vehicle)
	//resetting values like set_gun_config_values() would be tidy, but unnecessary as it gets recalc'd on install anyway
	// Not calling refresh_hardpoint_actions() yet, still installed at this point.

/// Applying passive buffs like damage type resistance, speed, accuracy, cooldowns.
/obj/item/hardpoint/proc/apply_buff(obj/vehicle/multitile/vehicle)
	if(buff_applied)
		return
	if(LAZYLEN(type_multipliers))
		for(var/type in type_multipliers)
			vehicle.dmg_multipliers[type] *= LAZYACCESS(type_multipliers, type)
	if(LAZYLEN(buff_multipliers))
		for(var/type in buff_multipliers)
			vehicle.misc_multipliers[type] *= LAZYACCESS(buff_multipliers, type)
	buff_applied = TRUE
	SEND_SIGNAL(vehicle, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)

/// Removing passive buffs like damage type resistance, speed, accuracy, cooldowns.
/obj/item/hardpoint/proc/remove_buff(obj/vehicle/multitile/vehicle)
	if(!buff_applied)
		return
	if(LAZYLEN(type_multipliers))
		for(var/type in type_multipliers)
			vehicle.dmg_multipliers[type] *= 1 / LAZYACCESS(type_multipliers, type)
	if(LAZYLEN(buff_multipliers))
		for(var/type in buff_multipliers)
			vehicle.misc_multipliers[type] *= 1 / LAZYACCESS(buff_multipliers, type)
	buff_applied = FALSE
	SEND_SIGNAL(vehicle, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)

/**
 * Recalculates hardpoint values based on vehicle modifiers, wound effects, and raw integrity.
 */
/obj/item/hardpoint/proc/recalculate_hardpoint_bonuses()
	var/accuracy_mult = get_combined_weapon_mult("accuracy_mult", WEAPON_MIN_ACCURACY_MULT)
	var/scatter_mult = min(get_wound_effect_multiplier("scatter_mult"), WEAPON_MAX_SCATTER_MULT)
	scatter = initial(scatter) / (owner.misc_multipliers["accuracy"] * accuracy_mult) * scatter_mult
	var/cooldown_mult = owner.misc_multipliers["cooldown"]
	set_fire_delay(initial(fire_delay) * cooldown_mult)
	set_burst_delay(initial(burst_delay) * cooldown_mult)
	extra_delay = initial(extra_delay) * cooldown_mult

/// Setter for fire_delay.
/obj/item/hardpoint/proc/set_fire_delay(value)
	fire_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay)

/// Setter for burst_delay.
/obj/item/hardpoint/proc/set_burst_delay(value)
	burst_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_BURST_SHOT_DELAY_MODIFIED, burst_delay)

//this proc called on each move of vehicle
/obj/item/hardpoint/proc/on_move(turf/old, turf/new_turf, move_dir)
	return

/obj/item/hardpoint/proc/get_root_origins()
	return list(-owner.bound_x / world.icon_size, -owner.bound_y / world.icon_size)

// Resets the hardpoint rotation to south
/obj/item/hardpoint/proc/reset_rotation()
	rotate(turning_angle(dir, SOUTH))

/**
 * Rotates this hardpoint by deg degrees, updating its own origins, dir, and current_angle.
 *
 * Arguments:
 * * deg = Degrees to turn by.
 * * override_gyro = Bypasses the gyro lock.
 * * sync_angle = Whether to drag current_angle along by deg.
 *
 * Returns:
 * * TRUE if the rotation happened, FALSE if skipped (gyro-locked or deg was 0).
 */
/obj/item/hardpoint/proc/rotate(deg, override_gyro = FALSE, sync_angle = TRUE)
	if(gyro && !override_gyro)
		return FALSE
	if(!deg)
		return FALSE

	// Update origins
	var/list/root_coords = get_root_origins()
	var/list/center_coords = list(owner.bound_width / (2*world.icon_size), owner.bound_height / (2*world.icon_size))
	var/list/origin_coords_abs = list(origins[1] + root_coords[1], origins[2] + root_coords[2])

	origin_coords_abs[1] = origin_coords_abs[1] + 0.5
	origin_coords_abs[2] = origin_coords_abs[2] + 0.5

	var/list/new_origin = RotateAroundAxis(origin_coords_abs, center_coords, deg)

	new_origin[1] = round(new_origin[1] - root_coords[1] - 0.5, 1)
	new_origin[2] = round(new_origin[2] - root_coords[2] - 0.5, 1)

	origins = new_origin

	// Update dir
	setDir(turn(dir, deg))

	if(sync_angle)
		// deg's rotational convention is the opposite sign of current_angle's.
		current_angle = ((current_angle - deg) %% 360 + 360) %% 360

	return TRUE

/**
 * Keeps gyro in sync with the gunner seat and turret_safety_on. Gyrostabilized while a gunner is
 * seated and safety is off, otherwise follows the hull like a fixed mount.
 *
 * Called whenever a gunner sits/stands or turret_safety_on is toggled.
 *
 * Arguments:
 * * gunner_seated = Pass TRUE/FALSE to skip reading the seat live. Needed by callers that run
 *   before the seat is actually updated.
 */
/obj/item/hardpoint/proc/recalculate_gyro(gunner_seated = null)
	if(isnull(gunner_seated))
		gunner_seated = !!(owner?.get_seat_mob(VEHICLE_GUNNER))
	gyro = gunner_seated && !turret_safety_on

/**
 * Toggles this hardpoint's safety lock. Turning it ON slowly turns it back to the hull's own
 * facing. Turning it OFF hands rotation control back to the gunner.
 */
/obj/item/hardpoint/proc/toggle_turret_safety(mob/user)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s stabilization systems are busted!"))
		return

	turret_safety_on = !turret_safety_on
	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s rotation and hardpoint safety [turret_safety_on ? "ON" : "OFF"]."))

	recalculate_gyro()
	aim_locked = turret_safety_on

	if(turret_safety_on && owner)
		desired_angle = dir2angle(owner.dir)
		start_rotation_if_needed()

//for le tgui
/obj/item/hardpoint/proc/get_tgui_info()
	var/list/data = list()

	data["name"] = name

	if(health <= 0)
		data["health"] = null
	else
		data["health"] = floor(get_integrity_percent())

	if(ammo)
		data["uses_ammo"] = TRUE
		data["current_rounds"] = ammo.current_rounds
		data["max_rounds"] = ammo.max_rounds
		data["mags"] = LAZYLEN(backup_clips)
		data["max_mags"] = max_clips
	else
		data["uses_ammo"] = FALSE

	data["wounds"] = get_wound_tgui_data()

	return data

//-----------------------------
//------INTERACTION PROCS----------
//-----------------------------

/obj/item/hardpoint/proc/deactivate()
	return

//used during bumping. Every mob we bump is getting affected by this proc from every module.
/obj/item/hardpoint/proc/livingmob_interact(mob/living/M)
	return

//examining a hardpoint
/obj/item/hardpoint/get_examine_text(mob/user)
	. = ..()
	if(health <= 0)
		. += SPAN_BOLDWARNING("It's busted!")
	else if(isobserver(user) || (ishuman(user) && (skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE) || skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_CREWMAN))))
		. += "It's at [round(get_integrity_percent(), 1)]% integrity!"
	. += get_wound_examine_lines(user)

/**
 * Handles clicks from get_wound_examine_lines() and the vehicle's part list: examining this
 * hardpoint, or showing a wound's repair info. Falls through to ..() for anything else.
 */
/obj/item/hardpoint/Topic(href, list/href_list)
	if(href_list["examine_hardpoint"])
		examine(usr)
		return
	if(href_list["wound_info"])
		show_wound_repair_info(usr, href_list["wound_info"])
		return
	return ..()

/**
 * Builds the examine feedback lines for every active wound on this hardpoint.
 *
 * Arguments:
 * * user = Whoever is examining this hardpoint.
 *
 * Returns:
 * * A list of examine-text lines, one per active wound. Empty if none.
 */
/obj/item/hardpoint/proc/get_wound_examine_lines(mob/user)
	. = list()
	var/is_xeno_examiner = isxeno(user)
	for(var/family_type in wound_tiers)
		var/list/tier_data = get_wound_tier_data(family_type)
		if(!tier_data)
			continue
		var/blurb = is_xeno_examiner ? tier_data["xeno_feedback"] : tier_data["marine_feedback_red"]
		if(!blurb)
			continue
		if(is_xeno_examiner)
			. += tier_data["bold_feedback"] ? SPAN_XENOBOLDNOTICE(blurb) : SPAN_XENOWARNING(blurb)
			continue
		var/line = tier_data["bold_feedback"] ? SPAN_BOLDWARNING(blurb) : SPAN_WARNING(blurb)
		line += " <a href='byond://?src=\ref[src];wound_info=[family_type]'>(Repair Info)</a>"
		. += line

//reloading hardpoint - take mag from backup clips and replace current ammo with it. Will change in future. Called via weapons loader
/obj/item/hardpoint/proc/reload(mob/user)
	if(!LAZYLEN(backup_clips))
		to_chat(usr, SPAN_WARNING("\The [name] has no remaining backup clips."))
		return

	var/obj/item/ammo_magazine/A = LAZYACCESS(backup_clips, 1)
	if(!A)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp and ask for a developer! Code: HP_RLDHP"))
		return

	to_chat(user, SPAN_NOTICE("You begin reloading \the [name]."))

	sleep(20)

	if(ammo)
		forceMove(ammo, get_turf(src))
		ammo.update_icon()
	ammo = A
	LAZYREMOVE(backup_clips, A)
	owner?.update_icon()

	to_chat(user, SPAN_NOTICE("You reload \the [name]."))

/// Whether this hardpoint will accept a given magazine for reloading. Eg, m56d cupola accepts m56d drums.
/obj/item/hardpoint/proc/accepts_magazine(obj/item/ammo_magazine/magazine)
	return istype(magazine, ammo_type)

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/proc/try_add_clip(obj/item/ammo_magazine/A, mob/user)
	if(!ammo_type)
		to_chat(user, SPAN_WARNING("\The [name] doesn't use ammunition.")) // UA flag
		return FALSE
	if(max_clips == 0)
		to_chat(user, SPAN_WARNING("\The [name] does not have room for additional ammo."))
		return FALSE
	else if(LAZYLEN(backup_clips) >= max_clips)
		to_chat(user, SPAN_WARNING("\The [name]'s reloader is full."))
		return FALSE

	to_chat(user, SPAN_NOTICE("You begin loading \the [A] into \the [name]."))

	if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("Something interrupted you while reloading \the [name]."))
		return FALSE

	if(LAZYLEN(backup_clips) >= max_clips)
		to_chat(user, SPAN_WARNING("\The [name]'s reloader is full."))
		return FALSE

	user.drop_inv_item_to_loc(A, src)

	playsound(loc, 'sound/machines/hydraulics_2.ogg', 50)
	LAZYADD(backup_clips, A)
	to_chat(user, SPAN_NOTICE("You load \the [A] into \the [name]. Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))
	return TRUE

/**
 * Offers wound-fix and integrity-repair together in one picker when a welder could do either.
 * Only reachable while detached.
 */
/obj/item/hardpoint/attackby(obj/item/O, mob/user)
	if(!owner && try_fix_detached_wound_with_tool(O, user))
		return
	if(iswelder(O))
		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		handle_repair(O, user)
		return
	..()

//repair procs
/obj/item/hardpoint/proc/handle_repair(obj/item/tool/weldingtool/WT, mob/user)
	if(user.is_mob_incapacitated())
		return

	if(health <= 0)
		to_chat(user, SPAN_WARNING("\The [src] crumbles in your hands to unsalvageable mess."))
		qdel(src)
		return
	if(health >= initial(health))
		to_chat(user, SPAN_WARNING("\The [src]s structural integrity is at 100%."))
		return
	if(!WT.isOn())
		to_chat(user, SPAN_WARNING("You need to light your [WT] first."))
		return
	if(WT.get_fuel() < 1)
		to_chat(user, SPAN_WARNING("You need to refill \the [WT] first."))
		return
	if(being_repaired)
		to_chat(user, SPAN_WARNING("\The [src] is already being repaired."))
		return
	if(user.action_busy)
		return

	//instead of making timer for repairing 10% of HP longer, we adjust how much % of max HP we fix per 1 second.
	//Using original 10% per welding as reference
	var/amount_fixed = 5 //in %
	switch(slot)
		if(HDPT_ARMOR)
			amount_fixed = 1.4
		if(HDPT_TURRET)
			amount_fixed = 1.6
		if(HDPT_PRIMARY)
			amount_fixed = 2
		if(HDPT_SECONDARY)
			amount_fixed = 2.5
		if(HDPT_SUPPORT)
			amount_fixed = 2.5
		if(HDPT_TREADS)
			amount_fixed = 3.3

	being_repaired = TRUE

	//skill level adjustment: instead of reducing welding time, we increase amount fixed.
	//Uses skill duration multiplier proc in order to not create a bicycle.
	var/amount_fixed_adjustment = user.get_skill_duration_multiplier(SKILL_ENGINEER)
	user.visible_message(SPAN_NOTICE("[user] starts repairing \the [name]."), SPAN_NOTICE("You start repairing \the [name]."))
	playsound(get_turf(user), 'sound/items/weldingtool_weld.ogg', 25)
	while(WT.get_fuel() > 1)
		if(!(world.time % 3))
			playsound(get_turf(user), 'sound/items/weldingtool_weld.ogg', 25)
		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
			break

		//we check for adjacency only if we are not installed. This is for turret for now
		if(!owner && !Adjacent(user))
			break

		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
			break

		WT.remove_fuel(1, user)

		//get_skill_duration_multiplier returns a multiplier, so we delete by it
		var/health_restored = initial(health)/100 * (amount_fixed / amount_fixed_adjustment)
		health += health_restored
		// Bleed down both sub-pools by the same amount health just recovered.
		acid_damage_taken = max(0, acid_damage_taken - health_restored)
		brute_damage_taken = max(0, brute_damage_taken - health_restored)
		if(health >= initial(health))
			health = initial(health)
			user.visible_message(SPAN_NOTICE("[user] finishes repairing \the [name]."), SPAN_NOTICE("You finish repairing \the [name]. The integrity of the module is at [SPAN_HELPFUL(floor(get_integrity_percent()))]%."))
			being_repaired = FALSE
			return
		to_chat(user, SPAN_NOTICE("The integrity of \the [src] is now at [SPAN_HELPFUL(floor(get_integrity_percent()))]%."))

	being_repaired = FALSE
	user.visible_message(SPAN_NOTICE("[user] stops repairing \the [name]."), SPAN_NOTICE("You stop repairing \the [name]. The integrity of the module is at [SPAN_HELPFUL(floor(get_integrity_percent()))]%."))
	return

/// Setter proc for the automatic firing flag.
/obj/item/hardpoint/proc/set_auto_firing(auto = FALSE)
	if(auto_firing != auto)
		auto_firing = auto
		if(!auto_firing) //end-of-fire, show changed ammo
			display_ammo()

/// Setter proc for the burst firing flag.
/obj/item/hardpoint/proc/set_burst_firing(burst = FALSE)
	if(burst_firing != burst)
		burst_firing = burst
		if(!burst_firing) //end-of-fire, show changed ammo
			display_ammo()

/// Clean all firing references.
/obj/item/hardpoint/proc/reset_fire()
	shots_fired = 0
	set_target(null)
	set_auto_firing(FALSE) //on abnormal exits automatic fire doesn't call set_auto_firing()

/// Set the target and take care of hard delete.
/obj/item/hardpoint/proc/set_target(atom/object)
	if(object == target || object == loc)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target))

/// Set the target to its turf, so we keep shooting even when it was qdeled.
/obj/item/hardpoint/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/// Print how much ammo is left to chat.
/obj/item/hardpoint/proc/display_ammo(mob/user)
	if(!user)
		user = owner.get_seat_mob(allowed_seat)
	if(!user)
		return

	if(ammo)
		to_chat(user, SPAN_WARNING("[name] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

/// Reset variables used in firing and remove the gun from the autofire system.
/obj/item/hardpoint/proc/stop_fire(datum/source, atom/object, turf/location, control, params)
	trigger_held = FALSE
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)
	if(auto_firing)
		reset_fire() //automatic fire doesn't reset itself from COMSIG_GUN_STOP_FIRE

/// Update the target if you dragged your mouse.
/obj/item/hardpoint/proc/change_target(datum/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	set_target(get_turf_on_clickcatcher(over_object, source, params))

/// Check if the gun can fire and add it to bucket autofire system if needed, or just fire the gun if not.
/obj/item/hardpoint/proc/start_fire(datum/source, atom/object, turf/location, control, params)
	if(istype(object, /atom/movable/screen))
		return

	if(QDELETED(object))
		return

	if(!auto_firing && !burst_firing && !COOLDOWN_FINISHED(src, fire_cooldown))
		if(max(fire_delay, burst_delay + extra_delay) >= 2.0 SECONDS) //filter out guns with high firerate to prevent message spam.
			to_chat(source, SPAN_WARNING("You need to wait [SPAN_HELPFUL(COOLDOWN_SECONDSLEFT(src, fire_cooldown))] seconds before [name] can be used again."))
		return

	set_target(get_turf_on_clickcatcher(object, source, params))
	trigger_held = TRUE

	if(gun_firemode == GUN_FIREMODE_SEMIAUTO)
		INVOKE_ASYNC(src, PROC_REF(fire_semiauto), object, source, params)
	else
		SEND_SIGNAL(src, COMSIG_GUN_FIRE)

// Fires a single semi-auto shot and handles its result so it can be invoked asynchronous for linters
/obj/item/hardpoint/proc/fire_semiauto(atom/target, mob/living/user, params)
	var/fire_return = try_fire(target, user, params)
	if(fire_return == AUTOFIRE_CONTINUE)
		reset_fire()
		display_ammo(user)

/// Wrapper proc for the autofire system to ensure the important args aren't null.
/obj/item/hardpoint/proc/fire_wrapper(atom/target, mob/living/user, params)
	if(!target)
		target = src.target
	if(!user)
		user = owner.get_seat_mob(allowed_seat)
	if(!target || !user)
		return NONE

	return try_fire(target, user, params)

/// Tests if firing should be interrupted, otherwise fires.
/obj/item/hardpoint/proc/try_fire(atom/target, mob/living/user, params)
	if(health <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is broken!</b>"))
		return NONE

	// Turret safety locks out every hardpoint on this turret.
	var/obj/item/hardpoint/holder/tank_turret/safety_check_turret = loc
	if(istype(safety_check_turret) && safety_check_turret.turret_safety_on)
		to_chat(user, SPAN_WARNING("Turret Safety is ON!"))
		return NONE

	// A hardpoint can legitimately have no magazine installed at all. This is needed especifically so the
	// DRGN flamer and the secondary version can 'eject' their magazines to be refueled from a fuel source..
	// so, other guns can now eject their full magazines and have nothing loaded.
	if(!ammo)
		click_empty(user)
		return NONE

	if(ammo.current_rounds <= 0)
		click_empty(user)
		return NONE

	// stops you from firing at your own hull. prevents a bug found in testing where guns shoot straight up.
	if(owner && (get_turf(target) in owner.locs))
		to_chat(user, SPAN_WARNING("Invalid target!"))
		return NONE

	var/atom/original_target = target
	var/obj/item/hardpoint/holder/tank_turret/turret = loc
	var/turret_mounted = istype(turret)
	// Anything that actually gets live current_angle rotation: self-gimballed, holder-mounted, or a
	// plain vehicle-mounted weapon with uses_live_rotation_tracking (e.g. the APC's dualcannon).
	var/actively_tracked = self_gimballed || turret_mounted || uses_live_rotation_tracking
	if(actively_tracked && gun_firemode != GUN_FIREMODE_SEMIAUTO)
		// Held-trigger fire modes (burst/automatic) don't wait for the barrel to finish swinging onto target
		var/obj/item/hardpoint/facing_source = get_rotation_owner()
		target = facing_source.redirect_to_current_facing(get_origin_turf(), target)
	else if(!in_firing_arc(target))
		// A tracked weapon (turret-mounted, gimballed, or live-rotation) waits for its own facing to swing onto the target before firing
		if(!actively_tracked || !wait_for_firing_arc(target, user))
			to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
			return NONE

	if(!target)
		return NONE

	return handle_fire(target, user, params, original_target)

/**
 * Waits for in_firing_arc(target) to become true, instead of instantly rejecting the shot.
 *
 * Returns TRUE once in arc and ready to fire, FALSE if the wait was cancelled or the shot became
 * impossible for some other reason while waiting (weapon/target gone, broke, ran dry, trigger let go).
 */
/obj/item/hardpoint/proc/wait_for_firing_arc(atom/target, mob/user)
	fire_wait_cancelled = FALSE
	RegisterSignal(src, list(COMSIG_GUN_STOP_FIRE, COMSIG_GUN_INTERRUPT_FIRE), PROC_REF(cancel_firing_arc_wait))

	. = TRUE
	while(!in_firing_arc(target))
		sleep(1)
		if(fire_wait_cancelled || !trigger_held || QDELETED(src) || QDELETED(target) || health <= 0 || (ammo && ammo.current_rounds <= 0))
			. = FALSE
			break

	UnregisterSignal(src, list(COMSIG_GUN_STOP_FIRE, COMSIG_GUN_INTERRUPT_FIRE))

/obj/item/hardpoint/proc/cancel_firing_arc_wait()
	SIGNAL_HANDLER
	fire_wait_cancelled = TRUE

/// Resolves which object owns continuous rotation for this hardpoint.
/obj/item/hardpoint/proc/get_rotation_owner()
	RETURN_TYPE(/obj/item/hardpoint)
	if(self_gimballed)
		return src
	var/obj/item/hardpoint/holder/tank_turret/turret = loc
	if(istype(turret))
		return turret
	return src

/// Whether this hardpoint gets independently mouse-aimed rotation, separate from the vehicle's own hull facing.
/obj/item/hardpoint/proc/has_independent_aim()
	if(uses_live_rotation_tracking)
		return TRUE
	return self_gimballed && istype(loc, /obj/item/hardpoint/holder)

/// Single choke point for locking/unlocking mouse-driven aim on whichever object get_rotation_owner()
/// resolves to, so ttrack_and_charge() below can lock/unlock symmetrically.
/obj/item/hardpoint/proc/lock_rotation(lock)
	get_rotation_owner().aim_locked = lock

/**
 * Refreshes max_angular_velocity for a vehicle-mounted weapon that's its own rotation owner
 * (e.g. the APC's dualcannon). Scaled by the weapon's own integrity and the vehicle's Turret Ring.
 * No-ops for a fixed mount, a holder-nested weapon, or a self-gimballed one.
 */
/obj/item/hardpoint/proc/recalculate_own_turn_rate()
	if(!traverse_arc || !owner || self_gimballed || istype(loc, /obj/item/hardpoint/holder))
		return

	var/obj/item/hardpoint/turret_ring/ring = locate() in owner.hardpoints
	var/ring_scale = 0
	if(ring)
		ring_scale = ring.get_own_health_scale() * ring.get_wound_effect_multiplier("turn_rate_mult")
		if(!owner.has_vehicle_power())
			ring_scale *= TURRET_NO_POWER_TURN_RATE_FRACTION

	max_angular_velocity = max(TURRET_BASE_ANGULAR_VELOCITY * (traverse_arc / TURRET_ARC_NORMALIZATION), TURRET_MIN_ANGULAR_VELOCITY) * get_own_health_scale() * ring_scale
	if(ring_scale > 0)
		max_angular_velocity = max(max_angular_velocity, TURRET_ABSOLUTE_MIN_ANGULAR_VELOCITY)

/**
 * Locks onto target and keeps re-aiming at its live position for aim_time, cancellable if the target
 * drifts further behind the current facing than this hardpoint's own traverse_arc allows, giving the
 * mount a litttle bit of allowance to catch up before the shot is considered lost
 *
 * Recomputes the true world-space angle to the target fresh every tick from this hardpoint's current
 * position, so it needs no special-casing for the vehicle itself moving/turning mid-charge
 *
 *
 * Returns TRUE if the charge completed with the target still valid and in arc, FALSE if cancelled.
 */
/obj/item/hardpoint/proc/track_and_charge(atom/target, mob/living/user, aim_time)
	if(charging)
		return FALSE
	charging = TRUE

	set_target(target)
	lock_rotation(TRUE)
	charge_cancelled = FALSE
	RegisterSignal(src, list(COMSIG_GUN_STOP_FIRE, COMSIG_GUN_INTERRUPT_FIRE), PROC_REF(cancel_charge))
	start_aim_visuals(target, user)

	. = TRUE
	var/elapsed = 0
	while(elapsed < aim_time)
		sleep(1)
		elapsed += 1

		if(charge_cancelled || !trigger_held || QDELETED(src) || QDELETED(target) || health <= 0 || (ammo && ammo.current_rounds <= 0))
			. = FALSE
			break

		if(isliving(target))
			var/mob/living/living_target = target
			if(living_target.is_dead())
				. = FALSE
				break

		var/turf/origin_turf = get_origin_turf()
		var/turf/target_turf = get_turf(target)
		if(origin_turf == target_turf)
			. = FALSE
			break

		try
			// Uses target_turf, not the target atom, so pixel offsets don't throw the aim off.
			var/angle_to_target = Get_Angle_Grounded(origin_turf, target_turf)
			var/obj/item/hardpoint/rotation_owner = get_rotation_owner()
			var/obj/item/hardpoint/holder/tank_turret/mount = self_gimballed ? loc : null

			if(istype(mount)) // self-gimballed, mounted on a turret
				var/turret_facing = mount.current_angle
				var/raw_delta = angle_delta(angle_to_target, turret_facing)
				if(abs(raw_delta) > SLAVED_GIMBAL_ARC_HALF_WIDTH)
					to_chat(user, SPAN_WARNING("Target moved out of the firing arc!"))
					. = FALSE
				else
					var/swing = clamp(raw_delta, -SLAVED_GIMBAL_ARC_HALF_WIDTH, SLAVED_GIMBAL_ARC_HALF_WIDTH)
					// %% (not %) since plain % breaks on fractional angles.
					rotation_owner.desired_angle = ((turret_facing + swing) %% 360 + 360) %% 360
			else
				rotation_owner.desired_angle = angle_to_target
				if(traverse_arc && abs(angle_delta(angle_to_target, rotation_owner.current_angle)) > traverse_arc * 0.5)
					to_chat(user, SPAN_WARNING("Target moved out of the firing arc!"))
					. = FALSE
			if(. != FALSE)
				rotation_owner.start_rotation_if_needed()
				on_track_tick(target)
		catch(var/exception/tick_error)
			log_runtime(tick_error)
			. = FALSE

		if(. == FALSE)
			break

	UnregisterSignal(src, list(COMSIG_GUN_STOP_FIRE, COMSIG_GUN_INTERRUPT_FIRE))
	end_aim_visuals(target, user, .)
	lock_rotation(FALSE)
	charging = FALSE

/obj/item/hardpoint/proc/cancel_charge()
	SIGNAL_HANDLER
	charge_cancelled = TRUE

/// No-op hook - override to spawn lock-on visuals (overlays/beams) when a track_and_charge() begins.
// currently overriden by LTB and mounted BRUTE launcher only. Same goes for the other hooks below. - BWSB
/obj/item/hardpoint/proc/start_aim_visuals(atom/target, mob/living/user)
	return

/// No-op hook - override to tear down whatever start_aim_visuals() spawned. Always called, success or not.
/obj/item/hardpoint/proc/end_aim_visuals(atom/target, mob/living/user, success)
	return

/// No-op hook - called once per tick during track_and_charge(), after desired_angle has been updated.
/// Override to keep any tick-dependent visuals (e.g. a beam anchor) following the live muzzle position.
/obj/item/hardpoint/proc/on_track_tick(atom/target)
	return

/// Actually fires the gun, sets up the projectile and fires it.
/obj/item/hardpoint/proc/handle_fire(atom/target, mob/living/user, params, atom/original_target)
	if(isnull(original_target))
		original_target = target
	var/turf/origin_turf = get_origin_turf()

	// Spawn projectile outside the vehicle hull, and never on a dense turf, so it doesn't end up
	// stuck inside a wall the vehicle is pressed against.
	var/turf/spawn_turf = origin_turf
	if(owner && length(owner.locs) > 1)
		var/turf/target_turf = get_turf(target)
		// Flatten the target's z to origin's own so cross-z targets don't break the exit search.
		var/turf/search_target = target_turf ? (locate(target_turf.x, target_turf.y, origin_turf.z) || target_turf) : target_turf
		// Walk the line from the vehicle's center so diagonal aims exit the right hull tile.
		var/list/path = get_line(get_turf(owner), search_target)
		var/found_exit = FALSE
		for(var/turf/T as anything in path)
			// preventts a bug where the projectile disappears if it occupies the same tile the projectile spawns in
			if(!(T in owner.locs) && T != search_target)
				spawn_turf = T
				found_exit = TRUE
				break
		// Point-blank range: spawn at the target's own tile instead of falling back to the hull.
		if(!found_exit && search_target && !(search_target in owner.locs) && !search_target.density)
			spawn_turf = search_target
	if(!spawn_turf || spawn_turf.density || (owner && (spawn_turf in owner.locs)))
		spawn_turf = get_turf(owner) // last-resort fallback, always valid and non-dense

	var/obj/projectile/projectile_to_fire = generate_bullet(user, spawn_turf)
	ammo.current_rounds -= ammo_cost_per_shot
	SEND_SIGNAL(projectile_to_fire, COMSIG_BULLET_USER_EFFECTS, user)
	// The tank's own IFF module overrides whatever IFF the firer's ID card set.
	if(projectile_to_fire.runtime_iff_group && owner)
		var/obj/item/hardpoint/iff_module/iff = locate() in owner.get_hardpoints_copy()
		projectile_to_fire.runtime_iff_group = (iff && iff.is_functional()) ? iff.set_faction : null
	projectile_to_fire.original = original_target

	// Mirrors every handheld gun's own def_zone assignment (Fire(), gun.dm).
	if(isliving(user))
		projectile_to_fire.def_zone = user.zone_selected

	// turf-targeted projectiles are fired without scatter, because proc would raytrace them further away
	var/ammo_flags = projectile_to_fire.ammo.flags_ammo_behavior | projectile_to_fire.projectile_override_flags
	if(!HAS_FLAG(ammo_flags, AMMO_HITS_TARGET_TURF) && !HAS_FLAG(ammo_flags, AMMO_EXPLOSIVE)) //AMMO_EXPLOSIVE is also a turf-targeted projectile
		projectile_to_fire.scatter = scatter
		target = simulate_scatter(projectile_to_fire, target, origin_turf, get_turf(target), user)

	// Damaged weapons hit softer.
	projectile_to_fire.ammo.damage *= get_combined_weapon_mult("damage_mult", WEAPON_MIN_DAMAGE_MULT)

	// Primary weapons only: a slowed round also loses penetration by the same fraction.
	if(istype(src, /obj/item/hardpoint/primary))
		projectile_to_fire.ammo.penetration *= get_combined_weapon_mult("projectile_speed_mult", WEAPON_MIN_PROJECTILE_SPEED_MULT)

	// projectile_speed_mult: a fouled or bent barrel slows the round leaving it.
	var/wound_shell_speed = projectile_to_fire.ammo.shell_speed * get_combined_weapon_mult("projectile_speed_mult", WEAPON_MIN_PROJECTILE_SPEED_MULT)
	INVOKE_ASYNC(projectile_to_fire, TYPE_PROC_REF(/obj/projectile, fire_at), target, user, src, projectile_to_fire.ammo.max_range, wound_shell_speed)
	projectile_to_fire = null

	shots_fired++
	play_firing_sounds()
	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(origin_turf, target))

	set_fire_cooldown(gun_firemode)

	return AUTOFIRE_CONTINUE

/**
 * No-op by default - only the flamer hardpoints (primary/flamer.dm, secondary/flamer.dm) override
 * this to flip between FLAME_MODE_STTREAM and FLAME_MODE_GLOB
 */
/obj/item/hardpoint/proc/toggle_fire_mode(mob/user)
	return

/**
 * Null by default. Flamer hardpoints override this to return their own flame_mode, so the
 * Toggle Fire Mode action button can pick an icon without knowing the specific subtype.
 */
/obj/item/hardpoint/proc/get_flame_mode()
	return null

/**
 * Fires the flamer hardpoint's stream mode, drawing fuel properties from the loaded ammo's chem.
 *
 * Arguments:
 * * target = Where the stream is aimed.
 * * user = The gunner firing.
 * * flameshape = Spray pattern override. Falls back to the loaded chem's own flameshape.
 * * range_bonus = Flat extra tiles of range added to the loaded fuel's own reach.
 */
/obj/item/hardpoint/proc/fire_flame_stream(atom/target, mob/living/user, flameshape, range_bonus = 0)
	var/datum/reagent/chem = LAZYACCESS(ammo.reagents?.reagent_list, 1)
	if(!chem)
		click_empty(user)
		return NONE

	//step forward along path so flame starts outside hull
	var/list/turfs = get_line(get_origin_turf(), get_turf(target))
	var/turf/origin_turf
	for(var/turf/turf as anything in turfs)
		if(turf in owner.locs)
			continue
		origin_turf = turf
		break

	var/base_range = ((chem.rangefire == -1) ? ammo.reagents.max_fire_rad : chem.rangefire) + range_bonus
	var/weapon_mult = get_combined_weapon_mult("projectile_speed_mult", WEAPON_MIN_PROJECTILE_SPEED_MULT)
	var/effective_max_range = max(1, round(base_range * weapon_mult))
	var/distance = get_dist(origin_turf, get_turf(target))
	var/fire_amount = min(distance+1, effective_max_range)

	chem.intensityfire = clamp(chem.intensityfire, ammo.reagents.min_fire_int, ammo.reagents.max_fire_int)
	chem.durationfire = clamp(chem.durationfire, ammo.reagents.min_fire_dur, ammo.reagents.max_fire_dur)

	new /obj/flamer_fire(origin_turf, create_cause_data(initial(name), user), chem, fire_amount, ammo.reagents, flameshape || chem.flameshape, target, CALLBACK(src, PROC_REF(sync_ammo_from_reagents)), 1, chem.fire_type)
	sync_ammo_from_reagents()

	play_firing_sounds()

	COOLDOWN_START(src, fire_cooldown, fire_delay)

	return AUTOFIRE_CONTINUE

/**
 * Tank equivalent of the infantry M240's unleash_smoke(). Disperses the loaded chem as smoke
 * along the aimed line instead of fire.
 *
 * Arguments:
 * * target = Where the smoke is aimed.
 * * user = The gunner firing.
 * * smoke_range = Max tiles the smoke travels.
 * * units_in_smoke = Reagent units per dispersed smoke puff.
 */
/obj/item/hardpoint/proc/fire_smoke_stream(atom/target, mob/living/user, smoke_range = 4, units_in_smoke = 35)
	var/datum/reagent/chemical = LAZYACCESS(ammo.reagents?.reagent_list, 1)
	if(!chemical)
		click_empty(user)
		return NONE

	//step forward along path so the smoke starts outside the hull, same as fire_flame_stream()
	var/list/turfs = get_line(get_origin_turf(), get_turf(target))
	var/turf/origin_turf
	for(var/turf/turf as anything in turfs)
		if(turf in owner.locs)
			continue
		origin_turf = turf
		break

	if(!origin_turf)
		click_empty(user)
		return NONE

	var/use_multiplier = 3
	var/distance = 0

	var/datum/reagents/to_disperse = new()
	to_disperse.add_reagent(chemical.id, units_in_smoke)
	to_disperse.my_atom = src

	var/list/turf/travel_turfs = get_line(origin_turf, get_turf(target), FALSE)
	var/amount_required = min(length(travel_turfs), smoke_range) * use_multiplier
	for(var/turf/turf in travel_turfs)
		if(chemical.volume < amount_required)
			smoke_range = floor(chemical.volume / use_multiplier)

		if(distance >= smoke_range)
			break

		if(turf.density)
			break
		else
			var/obj/effect/particle_effect/smoke/chem/checker = new()
			var/atom/blocked = LinkBlocked(checker, origin_turf, turf)
			qdel(checker)
			if(blocked)
				break

		playsound(turf, 'sound/effects/smoke.ogg', 25, 1)
		var/datum/effect_system/smoke_spread/chem/smoke = new()
		smoke.set_up(to_disperse, 5, loca = turf)
		smoke.start()
		sleep(4)

		distance++

	var/amount_used = distance * use_multiplier
	chemical.volume = max(chemical.volume - amount_used, 0)
	ammo.reagents.total_volume = chemical.volume

	if(chemical.volume < use_multiplier) // not enough left for even one more tile of smoke - empty the tank, same as unleash_smoke()
		ammo.reagents.clear_reagents()

	sync_ammo_from_reagents()

	play_firing_sounds()

	COOLDOWN_START(src, fire_cooldown, fire_delay)

	return AUTOFIRE_CONTINUE

/**
 * Re-syncs ammo.current_rounds to match ammo.reagents.total_volume.sync_ammo_from_reagents()
 * Called both right after firing and again once a since reagent consumption happens asynchronously tile by tile
 * as the flame propagates, not all at once at the moment of firing. Also refreshes the mounted sprite
 * immediately.
 */
/obj/item/hardpoint/proc/sync_ammo_from_reagents()
	if(ammo && ammo.reagents)
		ammo.current_rounds = round(ammo.reagents.total_volume)
	owner?.update_icon()

/// Start cooldown to respect delay of firemode.
/obj/item/hardpoint/proc/set_fire_cooldown(firemode)
	var/cooldown_time = 0
	switch(firemode)
		if(GUN_FIREMODE_SEMIAUTO)
			cooldown_time = fire_delay
		if(GUN_FIREMODE_BURSTFIRE)
			cooldown_time = burst_delay + extra_delay
		if(GUN_FIREMODE_AUTOMATIC)
			cooldown_time = fire_delay
	COOLDOWN_START(src, fire_cooldown, cooldown_time)

/// Adjust target based on random scatter angle.
/obj/item/hardpoint/proc/simulate_scatter(obj/projectile/projectile_to_fire, atom/target, turf/curloc, turf/targloc)
	// without this, clicking a point-blank target that resolves to the same turf as the muzzle
	if(curloc == targloc)
		return target

	var/fire_angle = Get_Angle(curloc, targloc)
	var/total_scatter_angle = projectile_to_fire.scatter

	//Not if the gun doesn't scatter at all, or negative scatter.
	if(total_scatter_angle > 0)
		fire_angle += rand(-total_scatter_angle, total_scatter_angle)
		target = get_angle_target_turf(curloc, fire_angle, 30)

	if(curloc.z != targloc.z)
		target = locate(target.x, target.y, targloc.z)

	return target

/// Get turf at hardpoint origin offset, used as the muzzle.
/obj/item/hardpoint/proc/get_origin_turf()
	return get_offset_target_turf(get_turf(src), origins[1], origins[2])

/// Plays 'click' noise and announced to chat. Usually called when weapon empty.
/obj/item/hardpoint/proc/click_empty(mob/user)
	playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)
	if(user)
		to_chat(user, SPAN_WARNING("<b>*click*</b>"))

/// Selects and plays a firing sound from the list.
/obj/item/hardpoint/proc/play_firing_sounds()
	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

/**
 * Determines whether something is in firing arc of a hardpoint.
 *
 * A hardpoint that actually rotates checks how far current_angle has caught up to the target.
 * A hardpoint that never rotates checks against the vehicle's own snapped dir instead.
 */
/obj/item/hardpoint/proc/in_firing_arc(atom/target)
	if(has_independent_aim())
		return check_gimbal_firing_arc(target)

	var/obj/item/hardpoint/holder/tank_turret/turret = loc
	if(istype(turret))
		return turret.in_turret_firing_arc(src, target)

	if(!traverse_arc || !ISINRANGE_EX(traverse_arc, 0, 360))
		return TRUE

	var/turf/muzzle_turf = get_origin_turf()
	var/turf/target_turf = get_turf(target)

	//same tile angle returns EAST, returning FALSE to ensure consistency
	if(muzzle_turf == target_turf)
		return FALSE

	var/angle_diff = (dir2angle(dir) - Get_Angle(muzzle_turf, target_turf)) %% 360
	if(angle_diff < -180)
		angle_diff += 360
	else if(angle_diff > 180)
		angle_diff -= 360

	return abs(angle_diff) <= (traverse_arc * 0.5)

/**
 * Firing-arc gate for a hardpoint whose own current_angle is what actually rotates: a self-gimballed
 * hardpoint (see toggle_slaved_to_driver()), or a plain vehicle-mounted weapon with
 * uses_live_rotation_tracking set (e.g. the APC's dualcannon/frontalcannon). current_angle must have
 * caught up to within FIRING_GATE_TOLERANCE of the angle from the weapon's own muzzle to target. Same
 * shape as /obj/item/hardpoint/holder/tank_turret/proc/in_turret_firing_arc(), but measured against
 * this hardpoint's own current_angle instead of a parent turret's.
 */
/obj/item/hardpoint/proc/check_gimbal_firing_arc(atom/target)
	var/turf/muzzle_turf = get_origin_turf()
	var/turf/target_turf = get_turf(target)

	//same tile angle is undefined for Gett_Angle, returning FALSE to match the legacy static-arc check
	if(muzzle_turf == target_turf)
		return FALSE

	var/target_angle = Get_Angle(muzzle_turf, target_turf)
	return abs(angle_delta(target_angle, current_angle)) <= FIRING_GATE_TOLERANCE

/**
 * records where the mouse currently wants this hardpoint to face. Called on every processed
 * mouse-move while a relevant crew member is seated.
 *
 * A self_gimballed weapon's desired_angle gets clamped to within SLAVED_GIMBAL_ARC_HALF_WIDTH
 * degrees of the turret's own current continuous facing. the turret can sit anywhere within its own lean, e.g. 168
 * degrees, and the allowed swing needs to follow that actual angle, not snap to whichever cardinal it's nearest to.
 */
/obj/item/hardpoint/proc/update_desired_angle(atom/object, mob/user, params)
	if(health <= 0)
		return
	if(aim_locked) // a track_and_charge() lock-on is in progress - mouse input can't fight it
		return
	if(world.time == last_desired_update_time) // collapses same-tick MouseMove spam into one update
		return
	last_desired_update_time = world.time

	// Aim at the hovered mob/object itself, not its bare turf
	var/atom/aim_target
	if(ismob(object) || isobj(object))
		aim_target = object
	else
		aim_target = get_turf_on_clickcatcher(object, user, params)
	if(!aim_target)
		return
	var/turf/target_turf = get_turf(aim_target)
	var/turf/origin_turf = get_origin_turf()
	if(!origin_turf || target_turf == origin_turf)
		return

	desired_angle = Get_Angle_Grounded(origin_turf, target_turf)

	if(self_gimballed)
		var/obj/item/hardpoint/holder/tank_turret/turret = loc
		if(istype(turret))
			var/turret_facing = turret.current_angle
			var/swing = clamp(angle_delta(desired_angle, turret_facing), -SLAVED_GIMBAL_ARC_HALF_WIDTH, SLAVED_GIMBAL_ARC_HALF_WIDTH)
			// %% (not %) since plain % breaks on fractional angles.
			desired_angle = ((turret_facing + swing) %% 360 + 360) %% 360

	start_rotation_if_needed()

/obj/item/hardpoint/proc/start_rotation_if_needed()
	if(rotation_active)
		return
	rotation_active = TRUE
	on_rotation_started()
	spawn(0)
		rotation_loop()

/**
 * Ticks current_angle toward desired_angle with inertia (accelerating up to max_angular_velocity,
 * decelerating on approach). Self-terminates once current_angle settles within ROTATION_SETTLE_TOLERANCE of
 * desired_angle, and restarts on demand from update_desired_angle().
 */
/obj/item/hardpoint/proc/rotation_loop()
	while(TRUE)
		sleep(1)

		if(QDELETED(src) || health <= 0)
			angular_velocity = 0
			rotation_active = FALSE
			on_rotation_stopped()
			return

		var/delta = angle_delta(desired_angle, current_angle)
		if(abs(delta) < ROTATION_SETTLE_TOLERANCE)
			current_angle = desired_angle
			angular_velocity = 0
			drag_self_gimballed_weapons(delta)
			apply_current_angle()
			rotation_active = FALSE
			on_rotation_stopped()
			return

		// Accelerate toward max_angular_velocity, decelerate once we're close enough to stop in time.
		var/stopping_distance = (angular_velocity ** 2) / (2 * angular_accel)
		if(abs(delta) <= stopping_distance)
			angular_velocity = max(angular_velocity - angular_accel, 0)
		else
			angular_velocity = min(angular_velocity + angular_accel, max_angular_velocity)

		var/turn_sign = (delta > 0) - (delta < 0)
		var/step = min(angular_velocity, abs(delta)) * turn_sign
		// %% (not %) since plain % breaks on fractional angles.
		current_angle = ((current_angle + step) %% 360 + 360) %% 360
		drag_self_gimballed_weapons(step)
		apply_current_angle()

/**
 * No-op by default. /obj/item/hardpoint/holder/tank_turret overrides this to drag every
 * self_gimballed mounted weapon's own current_angle/desired_angle along by the same delta this
 * hardpoint's current_angle just moved by.
 *
 * Without this, a slaved weapon's current_angle stays a fixed absolute world angle.
 * This would be fine, but, since we can slave the secondaries to the driver, then they also need to drag by themselves.
 */
/obj/item/hardpoint/proc/drag_self_gimballed_weapons(delta)
	return

/// Starts rotation_soundloop, if this hardpoint has one, and bumps the Turret Ring's power draw.
/obj/item/hardpoint/proc/on_rotation_started()
	if(owner?.has_vehicle_power() && rotation_soundloop)
		rotation_soundloop.mid_sounds = is_damaged() ? 'sound/vehicles/turretdamaged.ogg' : 'sound/vehicles/tankturret.ogg'
		rotation_soundloop.start()
	set_turret_ring_power_draw(TURRET_RING_ROTATING_POWER_DRAW)

/// Stops rotation_soundloop and settles the Turret Ring's power draw back to idle.
/obj/item/hardpoint/proc/on_rotation_stopped()
	rotation_soundloop?.stop()
	set_turret_ring_power_draw(TURRET_RING_IDLE_POWER_DRAW)

/**
 * Whether this hardpoint is damaged enough for its rotation to grind instead of sounding normal.
 * Based on the vehicle's installed Turret Ring, not this hardpoint's own health.
 */
/obj/item/hardpoint/proc/is_damaged()
	if(!owner)
		return FALSE
	var/obj/item/hardpoint/turret_ring/ring = locate() in owner.hardpoints
	return ring && (ring.get_integrity_percent() <= 50 || LAZYLEN(ring.wound_tiers))

/**
 * Updates the vehicle's installed Turret Ring's power_draw. Rotating pulls more power than idling.
 *
 * Arguments:
 * * new_draw = Power draw (units/sec) to set the ring to.
 */
/obj/item/hardpoint/proc/set_turret_ring_power_draw(new_draw)
	if(!owner)
		return
	var/obj/item/hardpoint/turret_ring/ring = locate() in owner.hardpoints
	if(ring)
		ring.power_draw = new_draw

/// Snaps a continuous angle down to the nearest 90-degree cardinal quadrant
/obj/item/hardpoint/proc/angle_to_cardinal(angle)
	// %% (not %) since plain % breaks on fractional angles.
	angle = ((angle %% 360) + 360) %% 360
	if(angle >= 315 || angle < 45)
		return NORTH
	if(angle < 135)
		return EAST
	if(angle < 225)
		return SOUTH
	return WEST

/// Keeps dir in sync with current_angle's quadrant, then refreshes the vehicle's sprite.
/obj/item/hardpoint/proc/apply_current_angle()
	if(!istype(loc, /obj/item/hardpoint/holder))
		var/target_cardinal = angle_to_cardinal(current_angle)
		if(target_cardinal != dir)
			rotate(turning_angle(dir, target_cardinal), override_gyro = TRUE, sync_angle = FALSE)
	if(owner)
		owner.update_icon()

/**
 * Builds a matrix that rotates by tilt degrees around pivot (a local x,y point relative to the
 * icon's own center) instead of the icon's default center. pivot defaults to (0,0) if null/unset.
 *
 * (Translate(pivot), called last, applied last) - Translate(-pivot) -> Turn(tilt) -> Translate(pivot).
 */
/obj/item/hardpoint/proc/build_tilt_matrix(tilt, list/pivot)
	var/matrix/tilt_matrix = matrix()
	if(pivot && (pivot[1] || pivot[2]))
		tilt_matrix.Translate(-pivot[1], -pivot[2])
		tilt_matrix.Turn(tilt)
		tilt_matrix.Translate(pivot[1], pivot[2])
	else
		tilt_matrix.Turn(tilt)
	return tilt_matrix

/**
 * Like build_tilt_matrix(), but composes two nested rotations onto one matrix instead of one:
 * inner_tilt around inner_pivot is applied first (closest to the raw icon), then outter_tilt around
 * outer_pivot is applied on top of that, carrying the already-tilted icon along with it. Used to
 * render a self_gimballed weapon, its own idependent swivel (inner, pivoting around its own local
 * mount joint, gimbal_pivot) rides along with the turret's own lean (outer, pivoting around the
 * turret's own rotation center, rotation_pivot) instead of replacing it - two separate pivots of
 * rotation, one nested inside the other, same as a real two-stage gimbal mountted on a turret.
 */
/obj/item/hardpoint/proc/build_nested_tilt_matrix(inner_tilt, list/inner_pivot, outer_tilt, list/outer_pivot)
	var/matrix/tilt_matrix = build_tilt_matrix(inner_tilt, inner_pivot)
	if(outer_tilt)
		if(outer_pivot && (outer_pivot[1] || outer_pivot[2]))
			tilt_matrix.Translate(-outer_pivot[1], -outer_pivot[2])
			tilt_matrix.Turn(outer_tilt)
			tilt_matrix.Translate(outer_pivot[1], outer_pivot[2])
		else
			tilt_matrix.Turn(outer_tilt)
	return tilt_matrix

/**
 * Looks up the pivot for a given angle out of up to 8 keyed keyframes (dir constants, same
 * convention as dir2angle()), blending between a cardinal and an adjacent diagonal if that
 * diagonal has a tuned entry - otherwise hard-snaps to the cardinal (old angle_to_cardinal()
 * behavior), so untuned weapons render unchanged. Returns null if pivot_data is empty.
 *
 * Uses a direct equality switch rather than angle_to_dir() that proc rounds to the NEARESTT dir
 * and misresolves exact cardinal angles (0/90/180/270) to an adjacent diagonal, which a multiple of 45 avoids
 */
/obj/item/hardpoint/proc/interpolate_pivot(list/pivot_data, angle)
	if(!pivot_data)
		return null

	// %% (not %) since plain % breaks on fractional angles.
	angle = ((angle %% 360) + 360) %% 360
	var/lower_anchor = FLOOR(angle, 45)
	var/upper_anchor = (lower_anchor + 45) %% 360

	var/list/lower_pivot = LAZYACCESS(pivot_data, "[anchor_angle_to_dir(lower_anchor)]")
	var/list/upper_pivot = LAZYACCESS(pivot_data, "[anchor_angle_to_dir(upper_anchor)]")

	if(!lower_pivot)
		return upper_pivot
	if(!upper_pivot)
		return lower_pivot

	var/frac = (angle - lower_anchor) / 45
	return list(
		lower_pivot[1] + (upper_pivot[1] - lower_pivot[1]) * frac,
		lower_pivot[2] + (upper_pivot[2] - lower_pivot[2]) * frac,
	)

/// Exact reverse of dir2angle() for one of the 8 cardinal/diagonal 45-degree-multiple angles - see interpolate_pivot()'s doc comment for why this can't just reuse the global angle_to_dir() nearest-neighbor helper.
/obj/item/hardpoint/proc/anchor_angle_to_dir(angle)
	switch(angle)
		if(0)
			return NORTH
		if(45)
			return NORTHEAST
		if(90)
			return EAST
		if(135)
			return SOUTHEAST
		if(180)
			return SOUTH
		if(225)
			return SOUTHWEST
		if(270)
			return WEST
		if(315)
			return NORTHWEST
	return NORTH

/**
 * Redirects a target to preserve its range from origin_turf but along this hardpoint's actual
 * current facing (current_angle) instead of the originally-aimed direction. Used by held-ttrigger
 * fire modes (see try_fire()), which don't wait for the turret (or a self-gimballed weapon's own gimbal) to finish swinging onto target.
 */
/obj/item/hardpoint/proc/redirect_to_current_facing(turf/origin_turf, atom/target)
	var/turf/target_turf = get_turf(target)
	if(!origin_turf || !target_turf || origin_turf == target_turf)
		return target

	var/cross_z = (target_turf.z != origin_turf.z)

	// Once the barrel has fully caught up to its own tracked aim point, there's no
	// rotational lag left to simulate. fire directly at the target.
	if(abs(angle_delta(desired_angle, current_angle)) <= FIRING_GATE_TOLERANCE)
		return target

	var/range = get_dist_euclidian(origin_turf, target_turf)
	var/turf/redirected_turf = get_angle_target_turf(origin_turf, current_angle, range)
	// Reapply the target's real z if it crossed levels.
	if(redirected_turf && cross_z)
		redirected_turf = locate(redirected_turf.x, redirected_turf.y, target_turf.z)
	return redirected_turf

//-----------------------------
//------ICON PROCS----------
//-----------------------------

/// Returns an image for the hardpoint, with a tilt transform layered on for a rotation-tracked weapon.
/obj/item/hardpoint/proc/get_hardpoint_image()
	var/offset_x = 0
	var/offset_y = 0

	if(LAZYLEN(px_offsets) && loc)
		offset_x = px_offsets["[loc.dir]"][1]
		offset_y = px_offsets["[loc.dir]"][2]

	var/image/I = get_icon_image(offset_x, offset_y, dir)

	if(has_independent_aim())
		var/tilt = angle_delta(current_angle, dir2angle(dir))
		if(tilt)
			I.transform = build_tilt_matrix(tilt, interpolate_pivot(rotation_pivot, current_angle))

	return I

/**
 * The on-hull damage suffix used by get_icon_image(). 1 (damaged) once integrity drops below
 * threshold_pct or this hardpoint carries a tier-2+ wound, 0 (healthy) otherwise.
 */
/obj/item/hardpoint/proc/get_mounted_damage_suffix(threshold_pct = 50)
	if(get_integrity_percent() < threshold_pct)
		return 1
	for(var/family_type in wound_tiers)
		if(wound_tiers[family_type] >= 2)
			return 1
	return 0

//Returns the image object to overlay onto the root object
/obj/item/hardpoint/proc/get_icon_image(x_offset, y_offset, new_dir)
	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[get_mounted_damage_suffix()]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)
	switch(floor((health / initial(health)) * 100))
		if(0)
			I.color = "#888888"
		if(1 to 20)
			I.color = "#4e4e4e"
		if(21 to 40)
			I.color = "#6e6e6e"
		if(41 to 60)
			I.color = "#8b8b8b"
		if(61 to 80)
			I.color = "#bebebe"
		else
			I.color = null
	return I

/**
 * Builds one clickable, wound-highlighted examine line for this hardpoint.
 *
 * Arguments:
 * * user = Mob examining, passed through to icon2html().
 * * mounted_on = Optional parent holder's name, shown if set.
 */
/obj/item/hardpoint/proc/build_examine_line(mob/user, mounted_on)
	var/line = mounted_on ? "There [p_are()] \a [src] module[p_s()] installed on [mounted_on]." : "There [p_are()] \a [src] module[p_s()] installed."
	// Style has to live inside the <a> tag's own text, or the link color wins over it.
	// A destroyed part always gets the DESTROYED callout, even with no active wound.
	var/is_destroyed = health <= 0
	var/name_text = is_destroyed ? "DESTROYED [name]" : name
	var/display_name = (is_destroyed || LAZYLEN(wound_tiers)) ? SPAN_BOLDWARNING(name_text) : name_text
	var/styled_name = "<a href='byond://?src=\ref[src];examine_hardpoint=1'>[display_name]</a>"
	line = replacetext(line, name, styled_name)
	return "[icon2html(src, user)] [line]"

/**
 * The common healthy/damaged suffix shared by simple 2-state modules. Damaged if integrity
 * drops below threshold_pct or this hardpoint has any active wound.
 */
/obj/item/hardpoint/proc/get_shared_damage_suffix(threshold_pct = 50)
	if(LAZYLEN(wound_tiers) || get_integrity_percent() < threshold_pct)
		return 1
	return 0

// debug proc
/obj/item/hardpoint/proc/set_offsets(dir, x, y)
	if(isnull(px_offsets))
		px_offsets = list(
			"1" = list(0, 0),
			"2" = list(0, 0),
			"4" = list(0, 0),
			"8" = list(0, 0)
		)
	px_offsets[dir] = list(x,y)

	owner.update_icon()

/obj/item/hardpoint/proc/muzzle_flash(angle)
	if(isnull(angle))
		return

	// The +48 and +64 centers the muzzle flash
	var/muzzle_flash_x = muzzle_flash_pos["[dir]"][1] + 48
	var/muzzle_flash_y = muzzle_flash_pos["[dir]"][2] + 64

	// Account for turret rotation
	if(istype(loc, /obj/item/hardpoint/holder))
		var/obj/item/hardpoint/holder/H = loc
		if(LAZYLEN(H.px_offsets))
			muzzle_flash_x += H.px_offsets["[H.loc.dir]"][1]
			muzzle_flash_y += H.px_offsets["[H.loc.dir]"][2]

	var/image_layer = owner.layer + 0.1
	if(underlayer_north_muzzleflash && dir == NORTH)
		image_layer = owner.layer - 0.1

	if(!angle_muzzleflash)
		angle = dir2angle(dir)

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',src,muzzleflash_icon_state,image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Turn(angle)
	rotate.Translate(muzzle_flash_x, muzzle_flash_y)
	I.transform = rotate
	I.flick_overlay(owner, 3)

// debug proc
/obj/item/hardpoint/proc/set_mf_offset(dir, x, y)
	if(!muzzle_flash_pos)
		muzzle_flash_pos = list(
			"1" = list(0,0),
			"2" = list(0,0),
			"4" = list(0,0),
			"8" = list(0,0)
		)

	muzzle_flash_pos[dir] = list(x,y)

// debug proc
/obj/item/hardpoint/proc/set_mf_use_px(use)
	use_mz_px_offsets = use

// debug proc
/obj/item/hardpoint/proc/set_mf_use_trt(use)
	use_mz_trt_offsets = use

/obj/item/hardpoint/get_applying_acid_time()
	return 10 SECONDS //you are not supposed to be able to easily combat-melt irreplaceable things.

/// Proc to be overridden if you want to have special conditions preventing the removal of the hardpoint. Add chat messages in this proc if you want to tell the player why
/obj/item/hardpoint/proc/can_be_removed(mob/remover)
	SHOULD_CALL_PARENT(TRUE)

	if(remover.stat > CONSCIOUS)
		return FALSE
	return TRUE
