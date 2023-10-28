/*
	Hardpoints are any items that attach to a base vehicle, such as wheels/treads, support systems and guns
*/

/obj/item/hardpoint
	//------MAIN VARS----------
	// Which slot is this hardpoint in
	// Purely to check for conflicting hardpoints
	var/slot
	// The vehicle this hardpoint is installed on
	var/obj/vehicle/multitile/owner

	health = 100
	w_class = SIZE_LARGE

	// Determines how much of any incoming damage is actually taken
	var/damage_multiplier = 1

	// Origin coords of the hardpoint relative to the vehicle
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

	// List of pixel offsets for each direction
	var/list/px_offsets

	//visual layer of hardpoint when on vehicle
	var/hdpt_layer = HDPT_LAYER_WHEELS

	// List of offsets for where to place the muzzle flash for each direction
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
	// Sounds to play when the module activated/fired
	var/list/activation_sounds



	//------INTERACTION VARS----------

	//which seat can use this module
	var/allowed_seat = VEHICLE_GUNNER

	//Cooldown on use of the hardpoint
	var/cooldown = 100
	var/next_use = 0

	//whether hardpoint has activatable ability like shooting or zooming
	var/activatable = 0

	//used to prevent welder click spam
	var/being_repaired = FALSE

	//current user. We can have only one user at a time. Better never change that
	var/user

	//Accuracy of the hardpoint. (which is, in fact, a scatter. Need to change this system)
	var/accuracy = 1

	// The firing arc of this hardpoint
	var/firing_arc = 0 //in degrees. 0 skips whole arc of fire check

	// Muzzleflash
	var/use_muzzle_flash = FALSE
	var/muzzleflash_icon_state = "muzzle_flash"
	var/underlayer_north_muzzleflash = FALSE
	var/angle_muzzleflash = TRUE

	//------AMMUNITION VARS----------

	//Currently loaded ammo that we shoot from
	var/obj/item/ammo_magazine/hardpoint/ammo
	//spare magazines that we can reload from
	var/list/backup_clips
	//maximum amount of spare mags
	var/max_clips = 0


	/**How the bullet will behave once it leaves the gun, also used for basic bullet damage and effects, etc.
	Ammo will be replaced on New() for things that do not use mags.**/
	//var/datum/ammo/ammo = null
	///What is currently in the chamber. Most guns will want something in the chamber upon creation.
	//var/obj/projectile/in_chamber = null
	/*Ammo mags may or may not be internal, though the difference is a few additional variables. If they are not internal, don't call
	on those unique vars. This is done for quicker pathing. Just keep in mind most mags aren't internal, though some are.
	This is also the default magazine path loaded into a projectile weapon for reverse lookups on New(). Leave this null to do your own thing.*/
	//var/obj/item/ammo_magazine/internal/current_mag = null

	///How much the bullet scatters when fired.
	var/scatter = 0
	///Multiplier. Increases or decreases how much bonus scatter is added with each bullet during burst fire (wielded only).
	var/burst_scatter_mult = 4

	///What minimum range the weapon deals full damage, builds up the closer you get. 0 for no minimum.
	var/effective_range_min = 0
	///What maximum range the weapon deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum.
	var/effective_range_max = 0

	///For regular shots, how long to wait before firing again. Use modify_fire_delay and set_fire_delay instead of modifying this on the fly
	VAR_PROTECTED/fire_delay = 0
	///When it was last fired, related to world.time.
	var/last_fired = 0

	//Burst fire.
	///How many shots can the weapon shoot in burst? Anything less than 2 and you cannot toggle burst. Use modify_burst_amount and set_burst_amount instead of modifying this
	VAR_PROTECTED/burst_amount = 1
	///The delay in between shots. Lower = less delay = faster. Use modify_burst_delay and set_burst_delay instead of modifying this
	VAR_PROTECTED/burst_delay = 1
	///When burst-firing, this number is extra time before the weapon can fire again. Depends on number of rounds fired.
	var/extra_delay = 0

	// Full auto
	///Whether or not the gun is firing full-auto
	var/fa_firing = FALSE
	///How many full-auto shots to get to max scatter?
	var/fa_scatter_peak = 4
	///How bad does the scatter get on full auto?
	var/fa_max_scatter = 6.5

	var/flags_gun_features = GUN_AMMO_COUNTER

	/** An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	that will be given to a projectile with the current ammo datum**/
	var/list/list/traits_to_give

	///Current selected firemode of the gun.
	var/gun_firemode = GUN_FIREMODE_SEMIAUTO
	///List of allowed firemodes.
	var/list/gun_firemode_list = list()
	///How many bullets the gun fired while bursting/auto firing
	var/shots_fired = 0
	/// Currently selected target to fire at. Set with set_target()
	VAR_PRIVATE/atom/target
	/// Current operator (crew) of the hardpoint.
	VAR_PRIVATE/mob/hp_operator
	/// If this gun should spawn with semi-automatic fire. Protected due to it never needing to be edited.
	VAR_PROTECTED/start_semiauto = TRUE
	/// If this gun should spawn with automatic fire. Protected due to it never needing to be edited.
	VAR_PROTECTED/start_automatic = FALSE
	/// The type of projectile that this gun should shoot
	var/projectile_type = /obj/projectile
	/// The multiplier for how much slower this should fire in automatic mode. 1 is normal, 1.2 is 20% slower, 2 is 100% slower, etc. Protected due to it never needing to be edited.
	VAR_PROTECTED/autofire_slow_mult = 1

	/// Semi auto cooldown
	COOLDOWN_DECLARE(semiauto_fire_cooldown)
	/// How long between semi-auto shots this should wait, to reduce possible spam
	var/semiauto_cooldown_time = 0.2 SECONDS
	var/empty_alarm = 'sound/weapons/hmg_eject_mag.ogg'

//-----------------------------
//------GENERAL PROCS----------
//-----------------------------

/obj/item/hardpoint/Initialize()
	. = ..()

	//set_gun_config_values()
	set_bullet_traits()
	//setup_firemodes()
	//gun_firemode = gun_firemode_list[1] || GUN_FIREMODE_SEMIAUTO
	AddComponent(/datum/component/automatedfire/autofire, fire_delay, burst_delay, burst_amount, gun_firemode, autofire_slow_mult, CALLBACK(src, PROC_REF(set_bursting)), CALLBACK(src, PROC_REF(reset_fire)), CALLBACK(src, PROC_REF(fire_wrapper)), CALLBACK(src, PROC_REF(display_ammo)), CALLBACK(src, PROC_REF(set_auto_firing))) //This should go after handle_starting_attachment() and setup_firemodes() to get the proper values set.

/obj/item/hardpoint/Destroy()
	if(owner)
		owner.remove_hardpoint(src)
		owner.update_icon()
		owner = null
	QDEL_NULL_LIST(backup_clips)
	QDEL_NULL(ammo)
	ammo = null
	target = null
	hp_operator = null

	return ..()

/obj/item/hardpoint/ex_act(severity)
	if(owner || indestructible)
		return

	health = max(0, health - severity / 2)
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] disintegrates into useless pile of scrap under the damage it suffered."))
		deconstruct(TRUE)

/// Populate traits_to_give in this proc
/obj/item/hardpoint/proc/set_bullet_traits()
	return

/obj/item/hardpoint/proc/generate_bullet(mob/user, turf/origin_turf)
	var/obj/projectile/P = new(origin_turf, create_cause_data(initial(name), user))
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
	health = max(0, health - damage * damage_multiplier)

/obj/item/hardpoint/proc/is_activatable()
	if(health <= 0)
		return FALSE
	return activatable

//returns the integrity of the hardpoint module
/obj/item/hardpoint/proc/get_integrity_percent()
	return 100.0*health/initial(health)

/obj/item/hardpoint/proc/on_install(obj/vehicle/multitile/V)
	apply_buff(V)
	return

/obj/item/hardpoint/proc/on_uninstall(obj/vehicle/multitile/V)
	remove_buff(V)
	return

//applying passive buffs like damage type resistance, speed, accuracy, cooldowns
/obj/item/hardpoint/proc/apply_buff(obj/vehicle/multitile/V)
	if(buff_applied)
		return
	if(LAZYLEN(type_multipliers))
		for(var/type in type_multipliers)
			V.dmg_multipliers[type] *= LAZYACCESS(type_multipliers, type)
	if(LAZYLEN(buff_multipliers))
		for(var/type in buff_multipliers)
			V.misc_multipliers[type] *= LAZYACCESS(buff_multipliers, type)
	buff_applied = TRUE

//removing buffs
/obj/item/hardpoint/proc/remove_buff(obj/vehicle/multitile/V)
	if(!buff_applied)
		return
	if(LAZYLEN(type_multipliers))
		for(var/type in type_multipliers)
			V.dmg_multipliers[type] *= 1 / LAZYACCESS(type_multipliers, type)
	if(LAZYLEN(buff_multipliers))
		for(var/type in buff_multipliers)
			V.misc_multipliers[type] *= 1 / LAZYACCESS(buff_multipliers, type)
	buff_applied = FALSE

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
		data["health"] = round(get_integrity_percent())

	if(ammo)
		data["uses_ammo"] = TRUE
		data["current_rounds"] = ammo.current_rounds
		data["max_rounds"] = ammo.max_rounds
		data["mags"] = LAZYLEN(backup_clips)
		data["max_mags"] = max_clips
	else
		data["uses_ammo"] = FALSE

	return data

// Traces backwards from the gun origin to the vehicle to check for obstacles between the vehicle and the muzzle
/obj/item/hardpoint/proc/clear_los(atom/A)

	if(origins[1] == 0 && origins[2] == 0) //skipping check for modules we don't need this
		return TRUE

	var/turf/muzzle_turf = locate(owner.x + origins[1], owner.y + origins[2], owner.z)

	var/turf/checking_turf = muzzle_turf
	while(!(owner in checking_turf))
		// Dense turfs block LoS
		if(checking_turf.density)
			return FALSE

		// Ensure that we can pass over all objects in the turf
		for(var/obj/O in checking_turf)
			// Since vehicles are multitile the
			if(O == owner)
				continue

			// Non-dense objects are irrelevant
			if(!O.density)
				continue

			// Make sure we can pass object from all directions
			if(!CHECK_BITFIELD(O.pass_flags.flags_can_pass_all, PASS_OVER_THROW_ITEM))
				if(!CHECK_BITFIELD(O.flags_atom, ON_BORDER))
					return FALSE
				//If we're behind the object, check the behind pass flags
				else if(dir == O.dir && !CHECK_BITFIELD(O.pass_flags.flags_can_pass_behind, PASS_OVER_THROW_ITEM))
					return FALSE
				//If we're in front, check front pass flags
				else if(dir == turn(O.dir, 180) && !CHECK_BITFIELD(O.pass_flags.flags_can_pass_front, PASS_OVER_THROW_ITEM))
					return FALSE

		// Trace back towards the vehicle
		checking_turf = get_step(checking_turf, turn(dir,180))

	return TRUE

//-----------------------------
//------INTERACTION PROCS----------
//-----------------------------

//If the hardpoint can be activated by current user
/obj/item/hardpoint/proc/can_activate(mob/user, atom/A)
	if(!owner)
		return

	var/seat = owner.get_mob_seat(user)
	if(!seat)
		return

	if(seat != allowed_seat)
		to_chat(user, SPAN_WARNING("<b>Only [allowed_seat] can use [name].</b>"))
		return

	if(health <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is broken!</b>"))
		return FALSE

	if(world.time < next_use)
		if(cooldown >= 20) //filter out guns with high firerate to prevent message spam.
			to_chat(user, SPAN_WARNING("You need to wait [SPAN_HELPFUL((next_use - world.time) / 10)] seconds before [name] can be used again."))
		return FALSE

	if(ammo && ammo.current_rounds <= 0)
		to_chat(user, SPAN_WARNING("<b>\The [name] is out of ammo!</b> Magazines: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))
		return FALSE

	if(!in_firing_arc(A))
		to_chat(user, SPAN_WARNING("<b>The target is not within your firing arc!</b>"))
		return FALSE

	if(!clear_los(A))
		to_chat(user, SPAN_WARNING("<b>You don't have a clear line of sight to the target!</b>"))
		return FALSE

	return TRUE

//Called when you want to activate the hardpoint, by default firing a gun
//This can also be used for some type of temporary buff or toggling mode, up to you
/obj/item/hardpoint/proc/activate(mob/user, atom/A)
	fire(user, A)

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
	else if(isobserver(user) || (ishuman(user) && (skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) || skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_CREWMAN))))
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
			user.visible_message(SPAN_NOTICE("[user] finishes repairing \the [name]."), SPAN_NOTICE("You finish repairing \the [name]. The integrity of the module is at [SPAN_HELPFUL(round(get_integrity_percent()))]%."))
			being_repaired = FALSE
			return
		to_chat(user, SPAN_NOTICE("The integrity of \the [src] is now at [SPAN_HELPFUL(round(get_integrity_percent()))]%."))

	being_repaired = FALSE
	user.visible_message(SPAN_NOTICE("[user] stops repairing \the [name]."), SPAN_NOTICE("You stop repairing \the [name]. The integrity of the module is at [SPAN_HELPFUL(round(get_integrity_percent()))]%."))
	return

//determines whether something is in firing arc of a hardpoint
/obj/item/hardpoint/proc/in_firing_arc(atom/A)
	if(!owner)
		return FALSE

	if(!firing_arc)
		return TRUE

	var/turf/T = get_turf(A)
	if(!T)
		return FALSE

	var/dx = T.x - (owner.x + origins[1]/2)
	var/dy = T.y - (owner.y + origins[2]/2)

	var/deg = 0
	switch(dir)
		if(EAST)
			deg = 0
		if(NORTH)
			deg = -90
		if(WEST)
			deg = 180
		if(SOUTH)
			deg = 90

	var/nx = dx * cos(deg) - dy * sin(deg)
	var/ny = dx * sin(deg) + dy * cos(deg)
	if(nx == 0)
		return firing_arc >= 90

	var/angle = arctan(ny/nx)
	if(nx < 0)
		angle += 180

	return abs(angle) <= (firing_arc/2)

//doing last preparation before actually firing gun
/obj/item/hardpoint/proc/fire(mob/user, atom/A)
	if(!ammo) //Prevents a runtime
		return
	if(ammo.current_rounds <= 0)
		return

	next_use = world.time + cooldown * owner.misc_multipliers["cooldown"]
	if(!prob((accuracy * 100) / owner.misc_multipliers["accuracy"]))
		A = get_step(get_turf(A), pick(cardinal))

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

	fire_projectile(user, A)

	to_chat(user, SPAN_WARNING("[name] Ammo: <b>[SPAN_HELPFUL(ammo ? ammo.current_rounds : 0)]/[SPAN_HELPFUL(ammo ? ammo.max_rounds : 0)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(backup_clips))]/[SPAN_HELPFUL(max_clips)]</b>"))

//finally firing the gun
/obj/item/hardpoint/proc/fire_projectile(mob/user, atom/A)
	set waitfor = 0

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/obj/projectile/P = generate_bullet(user, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, user)
	P.fire_at(A, user, src, P.ammo.max_range, P.ammo.shell_speed)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(origin_turf, A))

	ammo.current_rounds--

/*
/obj/item/hardpoint/proc/setup_firemodes()
	var/old_firemode = gun_firemode
	gun_firemode_list.len = 0

	if(start_automatic)
		gun_firemode_list |= GUN_FIREMODE_AUTOMATIC

	if(start_semiauto)
		gun_firemode_list |= GUN_FIREMODE_SEMIAUTO

	if(burst_amount > BURST_AMOUNT_TIER_1)
		gun_firemode_list |= GUN_FIREMODE_BURSTFIRE

	if(!length(gun_firemode_list))
		CRASH("[src] called setup_firemodes() with an empty gun_firemode_list")

	else if(old_firemode in gun_firemode_list)
		gun_firemode = old_firemode

	else
		gun_firemode = gun_firemode_list[1]
*/

/// Setter proc to toggle burst firing
/obj/item/hardpoint/proc/set_bursting(bursting = FALSE)
	if(bursting)
		ENABLE_BITFIELD(flags_gun_features, GUN_BURST_FIRING)
	else
		DISABLE_BITFIELD(flags_gun_features, GUN_BURST_FIRING)

///Clean all references
/obj/item/hardpoint/proc/reset_fire()
	shots_fired = 0//Let's clean everything
	set_target(null)
	set_auto_firing(FALSE)

///Set the target and take care of hard delete
/obj/item/hardpoint/proc/set_target(atom/object)
	if(object == target || object == loc)
		return
	if(target)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
	target = object
	if(target)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(clean_target))

///Set the target to its turf, so we keep shooting even when it was qdeled
/obj/item/hardpoint/proc/clean_target()
	SIGNAL_HANDLER
	target = get_turf(target)

/// Setter proc for fa_firing
/obj/item/hardpoint/proc/set_auto_firing(auto = FALSE)
	fa_firing = auto

/obj/item/hardpoint/proc/display_ammo(mob/user)
	if(!user)
		user = hp_operator

	if(CHECK_BITFIELD(flags_gun_features, GUN_AMMO_COUNTER) && ammo)
		//var/chambered = in_chamber ? TRUE : FALSE
		to_chat(user, SPAN_DANGER("[ammo.current_rounds] / [ammo.max_rounds] ROUNDS REMAINING"))

/*
/obj/item/hardpoint/proc/try_fire()
	if(!ammo?.current_rounds)
		to_chat(hp_operator, SPAN_WARNING("<b>*click*</b>"))
		playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)
		return

	return fire_shot()

/obj/item/hardpoint/proc/fire_shot() //Bang Bang
	var/atom/T = target

	var/turf/origin_turf = get_turf(src)
	origin_turf = locate(origin_turf.x + origins[1], origin_turf.y + origins[2], origin_turf.z)

	var/obj/projectile/P = generate_bullet(hp_operator, origin_turf)
	SEND_SIGNAL(P, COMSIG_BULLET_USER_EFFECTS, hp_operator)
	P.fire_at(T, hp_operator, src, P.ammo.max_range, P.ammo.shell_speed)

	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)

	if(use_muzzle_flash)
		muzzle_flash(Get_Angle(origin_turf, T))

	ammo.current_rounds--
	if(!ammo.current_rounds)
		handle_ammo_out()

	return AUTOFIRE_CONTINUE
*/

/obj/item/hardpoint/proc/handle_ammo_out(mob/user)
	visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] [src] beeps steadily and its ammo light blinks red."))
	playsound(loc, empty_alarm, 25, 1)

/obj/item/hardpoint/proc/crew_mouseup(datum/source, atom/object, turf/location, control, params)
	if(!target)
		return

	if(gun_firemode == GUN_FIREMODE_AUTOMATIC)
		reset_fire()
		display_ammo()
	SEND_SIGNAL(src, COMSIG_GUN_STOP_FIRE)

///Update the target if you draged your mouse
/obj/item/hardpoint/proc/crew_mousedrag(datum/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	set_target(get_turf_on_clickcatcher(over_object, hp_operator, params))

///Check if the gun can fire and add it to bucket auto_fire system if needed, or just fire the gun if not
/obj/item/hardpoint/proc/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	//hp_operator = owner.get_seat_mob(allowed_seat)
	hp_operator = source

	if (CHECK_BITFIELD(flags_gun_features, GUN_BURST_FIRING))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] || modifiers["middle"] || modifiers["right"])
		return

	if(istype(object, /atom/movable/screen))
		return

	if(QDELETED(object))
		return

	set_target(get_turf_on_clickcatcher(object, hp_operator, params))
	if(gun_firemode == GUN_FIREMODE_SEMIAUTO && COOLDOWN_FINISHED(src, semiauto_fire_cooldown))
		COOLDOWN_START(src, semiauto_fire_cooldown, semiauto_cooldown_time)
		//try_fire(object, hp_operator, modifiers)
		fire_wrapper(object, hp_operator, modifiers)
		reset_fire()
		display_ammo()
		return
	else
		SEND_SIGNAL(src, COMSIG_GUN_FIRE)

/// Wrapper proc for the autofire subsystem to ensure the important args aren't null
/obj/item/hardpoint/proc/fire_wrapper(atom/target, mob/living/user, params)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!target)
		target = src.target
	if(!user)
		user = hp_operator
	if(!target || !user)
		return NONE
	return Fire(target, user, params)

/obj/item/hardpoint/proc/Fire(atom/target, mob/living/user, params)
	set waitfor = FALSE

	if(!able_to_fire(user) || !target || !get_turf(user) || !get_turf(target))
		return NONE

	/*
	This is where burst is established for the proceeding section. Which just means the proc loops around that many times.
	If burst = 1, you must null it if you ever RETURN during the for() cycle. If for whatever reason burst is left on while
	the gun is not firing, it will break a lot of stuff. BREAK is fine, as it will null it.
	*/
	if((gun_firemode == GUN_FIREMODE_BURSTFIRE) && burst_amount > BURST_AMOUNT_TIER_1)
		ENABLE_BITFIELD(flags_gun_features, GUN_BURST_FIRING)

	var/fire_return = handle_fire(target, user, params)
	if(!fire_return)
		return fire_return

	DISABLE_BITFIELD(flags_gun_features, GUN_BURST_FIRING) // We always want to turn off bursting when we're done, mainly for when we break early mid-burstfire.
	return AUTOFIRE_CONTINUE

/obj/item/hardpoint/proc/able_to_fire(mob/user)
	if(CHECK_BITFIELD(flags_gun_features, GUN_BURST_FIRING))
		return TRUE

	// The rest is delay-related. If we're firing full-auto it doesn't matter
	if(fa_firing)
		return TRUE

	var/next_shot = last_fired + fire_delay

	if(world.time >= next_shot + extra_delay) //check the last time it was fired.
		extra_delay = 0

	return TRUE

/obj/item/hardpoint/proc/handle_fire(atom/target, mob/living/user, params)
	var/turf/curloc = get_turf(src) //In case the target or we are expired.
	var/turf/targloc = get_turf(target)

	var/atom/original_target = target //This is for burst mode, in case the target changes per scatter chance in between fired bullets.

	//The gun should return the bullet that it already loaded from the end cycle of the last Fire().
	//var/obj/projectile/projectile_to_fire = load_into_chamber(user) //Load a bullet in or check for existing one.
	var/obj/projectile/projectile_to_fire = generate_bullet(user, curloc)
	if(!projectile_to_fire) //If there is nothing to fire, click.
		click_empty(user)
		DISABLE_BITFIELD(flags_gun_features, GUN_BURST_FIRING)
		return NONE

	/*
	apply_bullet_effects(projectile_to_fire, user) //User can be passed as null.
	SEND_SIGNAL(projectile_to_fire, COMSIG_BULLET_USER_EFFECTS, user)
	*/

	if(QDELETED(original_target)) //If the target's destroyed, shoot at where it was last.
		target = targloc
	else
		target = original_target
		targloc = get_turf(target)

	projectile_to_fire.original = target

	/*
	// turf-targeted projectiles are fired without scatter, because proc would raytrace them further away
	var/ammo_flags = projectile_to_fire.ammo.flags_ammo_behavior | projectile_to_fire.projectile_override_flags
	if(!CHECK_BITFIELD(ammo_flags, AMMO_HITS_TARGET_TURF))
		target = simulate_scatter(projectile_to_fire, target, curloc, targloc, user)

	var/bullet_velocity = projectile_to_fire?.ammo?.shell_speed + velocity_add
	*/

	/*
	if(params) // Apply relative clicked position from the mouse info to offset projectile
		if(!params["click_catcher"])
			if(params["vis-x"])
				projectile_to_fire.p_x = text2num(params["vis-x"])
			else if(params["icon-x"])
				projectile_to_fire.p_x = text2num(params["icon-x"])
			if(params["vis-y"])
				projectile_to_fire.p_y = text2num(params["vis-y"])
			else if(params["icon-y"])
				projectile_to_fire.p_y = text2num(params["icon-y"])
			var/atom/movable/clicked_target = original_target
			if(istype(clicked_target))
				projectile_to_fire.p_x -= clicked_target.bound_width / 2
				projectile_to_fire.p_y -= clicked_target.bound_height / 2
			else
				projectile_to_fire.p_x -= world.icon_size / 2
				projectile_to_fire.p_y -= world.icon_size / 2
		else
			projectile_to_fire.p_x -= world.icon_size / 2
			projectile_to_fire.p_y -= world.icon_size / 2
	*/

	play_firing_sounds(projectile_to_fire, user)

	if(targloc != curloc)
		//This is where the projectile leaves the barrel and deals with projectile code only.
		//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
		//in_chamber = null // It's not in the gun anymore
		INVOKE_ASYNC(projectile_to_fire, TYPE_PROC_REF(/obj/projectile, fire_at), target, user, src, projectile_to_fire?.ammo?.max_range, projectile_to_fire?.ammo?.shell_speed, original_target)
		projectile_to_fire = null // Important: firing might have made projectile collide early and ALREADY have deleted it. We clear it too.
		//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

		. = TRUE

		shots_fired++
	else
		return TRUE

	//>>POST PROCESSING AND CLEANUP BEGIN HERE.<<
	var/angle = round(Get_Angle(user, target)) //Let's do a muzzle flash.
	muzzle_flash(angle,user)

	//This is where we load the next bullet in the chamber.
	//if(!reload_into_chamber(user)) // It has to return a bullet, otherwise it's empty.
	if(!ammo.current_rounds)
		click_empty(user)
		return TRUE //Nothing else to do here, time to cancel out.
	return TRUE

/obj/item/hardpoint/proc/click_empty(mob/user)
	if(user)
		to_chat(user, SPAN_WARNING("<b>*click*</b>"))
		playsound(user, 'sound/weapons/gun_empty.ogg', 25, 1, 5) //5 tile range
	else
		playsound(src, 'sound/weapons/gun_empty.ogg', 25, 1, 5)

/obj/item/hardpoint/proc/play_firing_sounds(obj/projectile/projectile_to_fire, mob/user)
	if(LAZYLEN(activation_sounds))
		playsound(get_turf(src), pick(activation_sounds), 60, 1)


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
	switch(round((health / initial(health)) * 100))
		if(0 to 20)
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
	if(isnull(angle)) return

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
