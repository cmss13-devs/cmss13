#define LEAP_COMPONENT "leap_component"

#define LEAP_COMPONENT_COOLDOWN "leap_component_cooldown"

/datum/component/leaping
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/leap_range = 4
	var/leap_cooldown = 3 SECONDS
	/// The timing for activating a leap by double tapping a movement key.
	var/double_tap_timing = 0.18 SECONDS
	/// Stores the time at which we last moved.
	var/last_mousedown_time
	/// Stores the direction of the last movement made.
	var/last_move_dir
	///allow_pass_flags flags applied to the leaper on leap
	var/leaper_allow_pass_flags

/datum/component/leaping/Initialize(_leap_range = 4, _leap_cooldown=3 SECONDS, _leaper_allow_pass_flags)
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	set_vars(_leap_range, _leap_cooldown, _leaper_allow_pass_flags)

/datum/component/leaping/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_KB_MOVEMENT_EAST_DOWN, COMSIG_KB_MOVEMENT_NORTH_DOWN, COMSIG_KB_MOVEMENT_SOUTH_DOWN, COMSIG_KB_MOVEMENT_WEST_DOWN, COMSIG_LIVING_CAN_LEAP))

/datum/component/leaping/InheritComponent(datum/component/new_component, original_component, _leap_range, _leap_cooldown, _leaper_allow_pass_flags)
	set_vars(_leap_range, _leap_cooldown, _leaper_allow_pass_flags)

/datum/component/leaping/proc/set_vars(_leap_range = 4, _leap_cooldown=3 SECONDS, _leaper_allow_pass_flags = PASS_OVER_THROW_MOB|PASS_OVER_FIRE|PASS_OVER_ACID_SPRAY|PASS_OVER)
	UnregisterSignal(parent, list(COMSIG_KB_MOVEMENT_EAST_DOWN, COMSIG_KB_MOVEMENT_NORTH_DOWN, COMSIG_KB_MOVEMENT_SOUTH_DOWN, COMSIG_KB_MOVEMENT_WEST_DOWN, COMSIG_LIVING_CAN_LEAP))
	RegisterSignal(parent, COMSIG_KB_MOVEMENT_EAST_DOWN, PROC_REF(leap_east))
	RegisterSignal(parent, COMSIG_KB_MOVEMENT_NORTH_DOWN, PROC_REF(leap_north))
	RegisterSignal(parent, COMSIG_KB_MOVEMENT_SOUTH_DOWN, PROC_REF(leap_south))
	RegisterSignal(parent, COMSIG_KB_MOVEMENT_WEST_DOWN, PROC_REF(leap_west))
	leap_range = _leap_range
	leap_cooldown = _leap_cooldown
	leaper_allow_pass_flags = _leaper_allow_pass_flags

/// Checks if we can leap to the east.
/datum/component/leaping/proc/leap_east()
	SIGNAL_HANDLER
	check_leap(EAST)

/// Checks if we can leap to the north.
/datum/component/leaping/proc/leap_north()
	SIGNAL_HANDLER
	check_leap(NORTH)

/// Checks if we can leap to the south.
/datum/component/leaping/proc/leap_south()
	SIGNAL_HANDLER
	check_leap(SOUTH)

/// Checks if we can leap to the west.
/datum/component/leaping/proc/leap_west()
	SIGNAL_HANDLER
	check_leap(WEST)

/// Checks if we can leap in the specified direction, and activates the ability if so.
/datum/component/leaping/proc/check_leap(direction)
	if(last_move_dir == direction && last_mousedown_time + double_tap_timing > world.time)
		if(TIMER_COOLDOWN_CHECK(parent, LEAP_COMPONENT_COOLDOWN))
			to_chat(parent, SPAN_WARNING("Catch your breath!"))
			return
		S_TIMER_COOLDOWN_START(parent, LEAP_COMPONENT_COOLDOWN, leap_cooldown)
		activate_leap(direction)
		return
	last_mousedown_time = world.time
	last_move_dir = direction

/// Does a leap in the specified direction.
/datum/component/leaping/proc/activate_leap(direction)
	var/atom/leaper = parent
	var/effective_leaper_allow_pass_flags = leaper_allow_pass_flags
	leaper.add_temp_pass_flags(effective_leaper_allow_pass_flags)
	var/mob/living/living_leaper
	if(isliving(parent))
		living_leaper = leaper
		if(living_leaper.body_position != LYING_DOWN)
			if(direction & EAST)
				living_leaper.set_lying_angle(90, FALSE)
			else if(direction & WEST)
				living_leaper.set_lying_angle(270, FALSE)
	playsound(get_turf(leaper), 'sound/weapons/thudswoosh.ogg', 50)
	var/original_layer = leaper.layer
	animate(leaper, pixel_z = leaper.pixel_z + 12, layer = max(MOB_UPPER_LAYER, original_layer), time = 0.3 SECONDS / 2, easing = CIRCULAR_EASING|EASE_OUT, flags = ANIMATION_END_NOW|ANIMATION_PARALLEL)
	animate(pixel_z = leaper.pixel_z - 12, layer = original_layer, time = 0.3 SECONDS / 2, easing = CIRCULAR_EASING|EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(end_jump), leaper, effective_leaper_allow_pass_flags), 0.2 SECONDS)
	ASYNC
		for(var/i=1 to leap_range)
			step(leaper, direction)
			sleep(1)

/datum/component/leaping/proc/end_jump(atom/leaper, effective_leaper_allow_pass_flags)
	var/mob/living/living_leaper
	if(isliving(parent))
		living_leaper = leaper
		if(living_leaper.body_position != LYING_DOWN)
			living_leaper.set_lying_angle(0, FALSE)
	leaper.remove_temp_pass_flags(effective_leaper_allow_pass_flags)

///Checks if this mob can leap
/mob/living/proc/can_leap()
	return SEND_SIGNAL(src, COMSIG_LIVING_CAN_LEAP)
