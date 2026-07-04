/**
 * Hardpoints are any items that attach to a base vehicle, such as wheels/treads, support systems and guns
 */
/obj/item/hardpoint
	//------MAIN VARS----------
	/// Which slot is this hardpoint in. Purely to check for conflicting hardpoints.
	var/slot
	/// The vehicle this hardpoint is installed on.
	var/obj/vehicle/multitile/owner

	health = 100
	w_class = SIZE_LARGE

	/// Determines how much of any incoming damage is actually taken.
	var/damage_multiplier = 1

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

	/// How fast this weapon can traverse. On a turret-mounted weapon, contributes to the shared turret's turn speed (see recalculate_turn_rate()). On a fixed-mount weapon, this is a static firing cone instead (see in_firing_arc()).
	var/traverse_arc = 0 //in degrees. 0 skips whole arc of fire check on fixed mounts

	/// If TRUE, this hardpoint runs its own independent mouse-aim rotation (current_angle/rotation_loop below) instead of following its holder's rotate() cascade - see /obj/item/hardpoint/secondary/proc/toggle_slaved_to_driver().
	var/self_gimballed = FALSE
	/// The hardpoint's live, continuously-simulated facing (0-360, north-clockwise). Distinct from dir, which stays snapped to a cardinal for sprite selection. Only meaningful for the turret itself, or a self_gimballed hardpoint.
	var/current_angle = 0
	/// Where the mouse currently wants this hardpoint to face (0-360, north-clockwise). current_angle chases this.
	var/desired_angle = 0
	/// Current turn speed, in degrees per tick, ramped toward max_angular_velocity.
	var/angular_velocity = 0
	/// Turn speed cap. For the turret, derived from the median traverse_arc of mounted weapons (see recalculate_turn_rate()). For a self_gimballed weapon, derived from its own traverse_arc.
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

/obj/item/hardpoint/Destroy()
	if(owner)
		owner.remove_hardpoint(src)
		owner.update_icon()
		owner = null
	QDEL_NULL_LIST(backup_clips)
	QDEL_NULL(ammo)
	set_target(null)
	return ..()

/obj/item/hardpoint/ex_act(severity)
	if(owner || explo_proof)
		return

	take_damage(severity / 2)
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

/obj/item/hardpoint/proc/can_take_damage()
	if(!damage_multiplier)
		return FALSE
	if(health > 0)
		return TRUE

/obj/item/hardpoint/proc/take_damage(damage)
	if(health <= 0)
		return
	health = max(0, health - damage * damage_multiplier)
	if(!health)
		on_destroy()

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

/// Remove hardpoint effects from vehicle and self.
/obj/item/hardpoint/proc/on_uninstall(obj/vehicle/multitile/vehicle)
	if(!vehicle) //in loose holder
		return
	UnregisterSignal(vehicle, COMSIG_GUN_RECALCULATE_ATTACHMENT_BONUSES)
	remove_buff(vehicle)
	//resetting values like set_gun_config_values() would be tidy, but unnecessary as it gets recalc'd on install anyway

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

/// Recalculates hardpoint values based on vehicle modifiers.
/obj/item/hardpoint/proc/recalculate_hardpoint_bonuses()
	scatter = initial(scatter) / owner.misc_multipliers["accuracy"]
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

/obj/item/hardpoint/proc/rotate(deg)
	if(!deg)
		return

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
		. += "It's busted!"
	else if(isobserver(user) || (ishuman(user) && (skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_NOVICE) || skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_CREWMAN))))
		. += "It's at [round(get_integrity_percent(), 1)]% integrity!"

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

	forceMove(ammo, get_turf(src))
	ammo.update_icon()
	ammo = A
	LAZYREMOVE(backup_clips, A)

	to_chat(user, SPAN_NOTICE("You reload \the [name]."))

//try adding magazine to hardpoint's backup clips. Called via weapons loader
/obj/item/hardpoint/proc/try_add_clip(obj/item/ammo_magazine/A, mob/user)
	if(!ammo)
		to_chat(user, SPAN_WARNING("\The [name] doesn't use ammunition."))
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
	to_chat(user, SPAN_NOTICE("You load \the [A] into \the [name]. Ammo: <b>[SPAN_HELPFUL(ammo.current_rounds)]/[SPAN_HELPFUL(ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))
	return TRUE

/obj/item/hardpoint/attackby(obj/item/O, mob/user)
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
		health += initial(health)/100 * (amount_fixed / amount_fixed_adjustment)
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

	if(ammo && ammo.current_rounds <= 0)
		click_empty(user)
		return NONE

	// stops you from firing at your own hull. prevents a bug found in testing where guns shoot straight up.
	if(owner && (get_turf(target) in owner.locs))
		to_chat(user, SPAN_WARNING("Invalid target!"))
		return NONE

	var/atom/original_target = target
	var/obj/item/hardpoint/holder/tank_turret/turret = loc
	var/turret_mounted = istype(turret)
	if((self_gimballed || turret_mounted) && gun_firemode != GUN_FIREMODE_SEMIAUTO)
		// Held-trigger fire modes (burst/automatic) don't wait for the turret to finish swinging onto target
		var/obj/item/hardpoint/facing_source = self_gimballed ? src : turret
		target = facing_source.redirect_to_current_facing(get_origin_turf(), target)
	else if(!in_firing_arc(target))
		// Turret-mounted weapons wait for the turret (or their own gimbal) to finish swinging onto the target before firing
		if(!turret_mounted || !wait_for_firing_arc(target, user))
			to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
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
		if(fire_wait_cancelled || QDELETED(src) || QDELETED(target) || health <= 0 || (ammo && ammo.current_rounds <= 0))
			. = FALSE
			break

	UnregisterSignal(src, list(COMSIG_GUN_STOP_FIRE, COMSIG_GUN_INTERRUPT_FIRE))

/obj/item/hardpoint/proc/cancel_firing_arc_wait()
	SIGNAL_HANDLER
	fire_wait_cancelled = TRUE

/**
 * Resolves which object actually owns continuous rotation (current_angle/desired_angle/rotation_loop)
 * for this hardpoint - itself if self_gimballed, or the shared turret holder if turret-mounted.
 * Mirrors the same dispatch already used implicitly by in_firing_arc()/check_gimbal_firing_arc()/
 * in_turret_firing_arc() above.
 */
/obj/item/hardpoint/proc/get_rotation_owner()
	if(self_gimballed)
		return src
	var/obj/item/hardpoint/holder/tank_turret/turret = loc
	if(istype(turret))
		return turret
	return src

/// Single choke point for locking/unlocking mouse-driven aim on whichever object get_rotation_owner()
/// resolves to, so ttrack_and_charge() below can lock/unlock symmetrically.
/obj/item/hardpoint/proc/lock_rotation(lock)
	get_rotation_owner().aim_locked = lock

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

		if(charge_cancelled || QDELETED(src) || QDELETED(target) || health <= 0 || (ammo && ammo.current_rounds <= 0))
			. = FALSE
			break

		var/turf/origin_turf = get_origin_turf()
		var/turf/target_turf = get_turf(target)
		if(origin_turf == target_turf)
			. = FALSE
			break

		// Angle uses the target atom itself, not target_turf
		var/angle_to_target = Get_Angle_Grounded(origin_turf, target)
		var/obj/item/hardpoint/rotation_owner = get_rotation_owner()
		var/obj/item/hardpoint/holder/tank_turret/mount = self_gimballed ? loc : null

		if(istype(mount)) // self-gimballed, mounted on a turret
			var/turret_facing = mount.current_angle
			var/raw_delta = angle_delta(angle_to_target, turret_facing)
			if(abs(raw_delta) > SLAVED_GIMBAL_ARC_HALF_WIDTH)
				to_chat(user, SPAN_WARNING("Target moved out of the firing arc!"))
				. = FALSE
				break
			var/swing = clamp(raw_delta, -SLAVED_GIMBAL_ARC_HALF_WIDTH, SLAVED_GIMBAL_ARC_HALF_WIDTH)
			rotation_owner.desired_angle = ((turret_facing + swing) % 360 + 360) % 360
		else
			rotation_owner.desired_angle = angle_to_target
			if(traverse_arc && abs(angle_delta(angle_to_target, rotation_owner.current_angle)) > traverse_arc * 0.5)
				to_chat(user, SPAN_WARNING("Target moved out of the firing arc!"))
				. = FALSE
				break

		rotation_owner.start_rotation_if_needed()
		on_track_tick(target)

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

	// Spawn projectile outside the vehicle hull so riders aren't hit.
	var/turf/spawn_turf = origin_turf
	if(owner && length(owner.locs) > 1)
		var/turf/target_turf = get_turf(target)
		var/list/path = get_line(origin_turf, target_turf)
		for(var/turf/T as anything in path)
			// preventts a bug where the projectile disappears if it occupies the same tile the projectile spawns in
			if(!(T in owner.locs) && T != target_turf)
				spawn_turf = T
				break

	var/obj/projectile/projectile_to_fire = generate_bullet(user, spawn_turf)
	ammo.current_rounds--
	SEND_SIGNAL(projectile_to_fire, COMSIG_BULLET_USER_EFFECTS, user)

	// turf-targeted projectiles are fired without scatter, because proc would raytrace them further away
	var/ammo_flags = projectile_to_fire.ammo.flags_ammo_behavior | projectile_to_fire.projectile_override_flags
	if(!HAS_FLAG(ammo_flags, AMMO_HITS_TARGET_TURF) && !HAS_FLAG(ammo_flags, AMMO_EXPLOSIVE)) //AMMO_EXPLOSIVE is also a turf-targeted projectile
		projectile_to_fire.scatter = scatter
		target = simulate_scatter(projectile_to_fire, target, origin_turf, get_turf(target), user)

	INVOKE_ASYNC(projectile_to_fire, TYPE_PROC_REF(/obj/projectile, fire_at), target, user, src, projectile_to_fire.ammo.max_range, projectile_to_fire.ammo.shell_speed)
	projectile_to_fire = null

	shots_fired++
	play_firing_sounds()
	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(origin_turf, target))

	set_fire_cooldown(gun_firemode)

	return AUTOFIRE_CONTINUE

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

/// Determines whether something is in firing arc of a hardpoint.
/obj/item/hardpoint/proc/in_firing_arc(atom/target)
	if(self_gimballed)
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
 * Firing-arc gate for a self-gimballed hardpoint (see toggle_slaved_to_driver()): current_angle
 * must have caught up to within FIRING_GATE_TOLERANCE of the angle from the weapon's own muzzle to
 * target. Same shape as /obj/item/hardpoint/holder/tank_turret/proc/in_turret_firing_arc(), but
 * measured against this hardpoint's own current_angle instead of a parent turret's.
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

	// Using the raw pixel-precise angle here aims at a tall sprite's visual midpoint instead of the tile it's
	// actually standing on, which is what actually needs to be hit. very shittty bug to fix during testing
	// which made the autocannon and minigun DPS plummet.
	desired_angle = Get_Angle_Grounded(origin_turf, aim_target)

	if(self_gimballed)
		var/obj/item/hardpoint/holder/tank_turret/turret = loc
		if(istype(turret))
			var/turret_facing = turret.current_angle
			var/swing = clamp(angle_delta(desired_angle, turret_facing), -SLAVED_GIMBAL_ARC_HALF_WIDTH, SLAVED_GIMBAL_ARC_HALF_WIDTH)
			desired_angle = ((turret_facing + swing) % 360 + 360) % 360

	start_rotation_if_needed()

/obj/item/hardpoint/proc/start_rotation_if_needed()
	if(rotation_active)
		return
	rotation_active = TRUE
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
			return

		var/delta = angle_delta(desired_angle, current_angle)
		if(abs(delta) < ROTATION_SETTLE_TOLERANCE)
			current_angle = desired_angle
			angular_velocity = 0
			drag_self_gimballed_weapons(delta)
			apply_current_angle()
			rotation_active = FALSE
			return

		// Accelerate toward max_angular_velocity, decelerate once we're close enough to stop in time.
		var/stopping_distance = (angular_velocity ** 2) / (2 * angular_accel)
		if(abs(delta) <= stopping_distance)
			angular_velocity = max(angular_velocity - angular_accel, 0)
		else
			angular_velocity = min(angular_velocity + angular_accel, max_angular_velocity)

		var/turn_sign = (delta > 0) - (delta < 0)
		var/step = min(angular_velocity, abs(delta)) * turn_sign
		current_angle = ((current_angle + step) % 360 + 360) % 360
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

/// Snaps a continuous angle down to the nearest 90-degree cardinal quadrant
/obj/item/hardpoint/proc/angle_to_cardinal(angle)
	angle = ((angle % 360) + 360) % 360
	if(angle >= 315 || angle < 45)
		return NORTH
	if(angle < 135)
		return EAST
	if(angle < 225)
		return SOUTH
	return WEST

/**
 * Keeps dir/origins in sync with current_angle's quadrant, then refreshes the vehicle's sprite.
 */
/obj/item/hardpoint/proc/apply_current_angle()
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

	angle = ((angle % 360) + 360) % 360
	var/lower_anchor = FLOOR(angle, 45)
	var/upper_anchor = (lower_anchor + 45) % 360

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

	// Once the barrel has fully caught up to its own tracked aim point, there's no
	// rotational lag left to simulate. fire directly at the target.
	if(abs(angle_delta(desired_angle, current_angle)) <= FIRING_GATE_TOLERANCE)
		return target

	var/range = get_dist_euclidian(origin_turf, target_turf)
	return get_angle_target_turf(origin_turf, current_angle, range)

//-----------------------------
//------ICON PROCS----------
//-----------------------------

//Returns an image for the hardpoint
/obj/item/hardpoint/proc/get_hardpoint_image()
	var/offset_x = 0
	var/offset_y = 0

	if(LAZYLEN(px_offsets) && loc)
		offset_x = px_offsets["[loc.dir]"][1]
		offset_y = px_offsets["[loc.dir]"][2]

	var/image/I = get_icon_image(offset_x, offset_y, dir)
	return I

//Returns the image object to overlay onto the root object
/obj/item/hardpoint/proc/get_icon_image(x_offset, y_offset, new_dir)
	var/is_broken = health <= 0
	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[is_broken ? "1" : "0"]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)
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
