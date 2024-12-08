#define IFF_HALT_COOLDOWN 0.5 SECONDS

/// A component that prevents gun (although you can attach it to anything else that shoot projectiles) from shooting when mob from the same faction stands in the way.
/// You can also pass number of ticks, to make gun have an additional delay if firing prevention comes into play, but it is not neccesary.
/datum/component/iff_fire_prevention
	var/iff_additional_fire_delay
	COOLDOWN_DECLARE(iff_halt_cooldown)

/datum/component/iff_fire_prevention/Initialize(additional_fire_delay = 0)
	. = ..()
	iff_additional_fire_delay = additional_fire_delay


/datum/component/iff_fire_prevention/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_GUN_BEFORE_FIRE, PROC_REF(check_firing_lane))
	RegisterSignal(parent, COMSIG_GUN_IFF_TOGGLED, PROC_REF(handle_iff_toggle))

/datum/component/iff_fire_prevention/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_GUN_BEFORE_FIRE,
		COMSIG_GUN_IFF_TOGGLED
	))

/datum/component/iff_fire_prevention/proc/check_firing_lane(obj/firing_weapon, obj/projectile/projectile_to_fire, atom/target, mob/living/user)
	SIGNAL_HANDLER

	var/angle = Get_Angle(user, target)

	var/range_to_check = user.get_maximum_view_range()

	var/extended_target_turf = get_angle_target_turf(user, angle, range_to_check)

	var/turf/starting_turf = get_turf(user)

	if(!starting_turf || !extended_target_turf)
		return COMPONENT_CANCEL_GUN_BEFORE_FIRE

	var/list/checked_turfs = get_line(starting_turf, extended_target_turf)

	//Don't shoot yourself, thanks
	if(target == user)
		if(COOLDOWN_FINISHED(src, iff_halt_cooldown) && user.client)
			playsound_client(user.client, 'sound/weapons/smartgun_fail.ogg', src, 25)
			to_chat(user, SPAN_WARNING("[firing_weapon] halts firing as an IFF marked target crosses your field of fire!"))
			COOLDOWN_START(src, iff_halt_cooldown, IFF_HALT_COOLDOWN)
		if(iff_additional_fire_delay)
			var/obj/item/weapon/gun/gun = firing_weapon
			if(istype(gun))
				LAZYSET(user.fire_delay_next_fire, gun, world.time + iff_additional_fire_delay)
		return COMPONENT_CANCEL_GUN_BEFORE_FIRE

	//At some angles (scatter or otherwise) the original target is not in checked_turfs so we put it in there in order based on distance from user
	//If we are literally clicking on someone with IFF then we don't want to fire, feels funny as a user otherwise
	if(projectile_to_fire.original)
		var/turf/original_target_turf = get_turf(projectile_to_fire.original)

		if(original_target_turf && !(original_target_turf in checked_turfs))
			var/user_to_target_dist = get_dist(starting_turf, original_target_turf)
			var/list/temp_checked_turfs = checked_turfs.Copy()
			checked_turfs = list()

			for(var/turf/checked_turf as anything in temp_checked_turfs)
				if(!(original_target_turf in checked_turfs) && user_to_target_dist < get_dist(starting_turf, checked_turf))
					checked_turfs += original_target_turf

				checked_turfs += checked_turf

	for(var/turf/checked_turf as anything in checked_turfs)

		//Wall, should block the bullet so we're good to stop checking.
		if(istype(checked_turf, /turf/closed))
			return

		for(var/mob/living/checked_living in checked_turf)
			if(checked_living == user) // sometimes it still happens
				continue
			if(checked_living.body_position == LYING_DOWN && projectile_to_fire.original != checked_living)
				continue

			if(checked_living.get_target_lock(user.faction_group))
				if(HAS_TRAIT(checked_living, TRAIT_CLOAKED))
					continue
				if(COOLDOWN_FINISHED(src, iff_halt_cooldown) && user.client)
					playsound_client(user.client, 'sound/weapons/smartgun_fail.ogg', src, 25)
					to_chat(user, SPAN_WARNING("[firing_weapon] halts firing as an IFF marked target crosses your field of fire!"))
					COOLDOWN_START(src, iff_halt_cooldown, IFF_HALT_COOLDOWN)
				if(iff_additional_fire_delay)
					var/obj/item/weapon/gun/gun = firing_weapon
					if(istype(gun))
						LAZYSET(user.fire_delay_next_fire, gun, world.time + iff_additional_fire_delay)
				return COMPONENT_CANCEL_GUN_BEFORE_FIRE

			return //if we have a target we *can* hit and find it before any IFF targets we want to fire

/// Disable fire prevention when IFF is toggled off and other way around
/datum/component/iff_fire_prevention/proc/handle_iff_toggle(obj/gun, iff_enabled)
	SIGNAL_HANDLER
	if(iff_enabled)
		RegisterSignal(parent, COMSIG_GUN_BEFORE_FIRE, PROC_REF(check_firing_lane))
	else
		UnregisterSignal(parent, COMSIG_GUN_BEFORE_FIRE)

#undef IFF_HALT_COOLDOWN
