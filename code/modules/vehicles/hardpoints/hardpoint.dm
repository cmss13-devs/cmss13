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

	/// The firing arc of this hardpoint.
	var/firing_arc = 0 //in degrees. 0 skips whole arc of fire check

	// Muzzleflash
	var/use_muzzle_flash = FALSE
	var/muzzleflash_icon_state = "muzzle_flash"
	var/underlayer_north_muzzleflash = FALSE
	var/angle_muzzleflash = TRUE

	//------AMMUNITION VARS----------

	/// Currently loaded ammo that we shoot from.
	var/obj/item/ammo_magazine/hardpoint/ammo
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
		var/fire_return = try_fire(object, source, params)
		//end-of-fire, show ammo (if changed)
		if(fire_return == AUTOFIRE_CONTINUE)
			reset_fire()
			display_ammo(source)
	else
		SEND_SIGNAL(src, COMSIG_GUN_FIRE)

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

	if(!in_firing_arc(target))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return NONE

	return handle_fire(target, user, params)

/// Actually fires the gun, sets up the projectile and fires it.
/obj/item/hardpoint/proc/handle_fire(atom/target, mob/living/user, params)
	var/turf/origin_turf = get_origin_turf()

	var/obj/projectile/projectile_to_fire = generate_bullet(user, origin_turf)
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
	var/fire_angle = Get_Angle(curloc, targloc)
	var/total_scatter_angle = projectile_to_fire.scatter

	//Not if the gun doesn't scatter at all, or negative scatter.
	if(total_scatter_angle > 0)
		fire_angle += rand(-total_scatter_angle, total_scatter_angle)
		target = get_angle_target_turf(curloc, fire_angle, 30)

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
	if(!firing_arc || !ISINRANGE_EX(firing_arc, 0, 360))
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

	return abs(angle_diff) <= (firing_arc * 0.5)

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
	if(remover.stat > CONSCIOUS)
		return FALSE
	return TRUE
