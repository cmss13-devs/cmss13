#define IFF_HALT_COOLDOWN 0.5 SECONDS

/datum/component/iff_fire_prevention
	var/obj/parent_gun
	var/iff_additional_fire_delay
	COOLDOWN_DECLARE(iff_halt_cooldown)

/datum/component/iff_fire_prevention/Initialize(additional_fire_delay = 0)
	. = ..()
	parent_gun = parent
	iff_additional_fire_delay = additional_fire_delay


/datum/component/iff_fire_prevention/RegisterWithParent()
	. = ..()
	RegisterSignal(parent_gun, COMSIG_GUN_BEFORE_FIRE, PROC_REF(check_firing_lane))

/datum/component/iff_fire_prevention/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent_gun, COMSIG_GUN_BEFORE_FIRE)

/datum/component/iff_fire_prevention/Destroy(force, silent)
	handle_qdel()
	. = ..()

/datum/component/iff_fire_prevention/proc/handle_qdel()
	SIGNAL_HANDLER
	parent_gun = null

/datum/component/iff_fire_prevention/proc/check_firing_lane(obj/firing_weapon, obj/projectile/projectile_to_fire, atom/target, mob/living/user)
	SIGNAL_HANDLER

	var/angle = get_angle(user, target)

	var/range_to_check = user.get_maximum_view_range()

	var/extended_target_turf = get_angle_target_turf(user, angle, range_to_check)


	var/turf/starting_turf = get_turf(user)

	if(!starting_turf || !extended_target_turf)
		return COMPONENT_CANCEL_GUN_BEFORE_FIRE

	var/list/checked_turfs = getline2(starting_turf, extended_target_turf)

	checked_turfs -= starting_turf

	//At some angles (scatter or otherwise) the original target is not in checked_turfs so we put it in there in order based on distance from user
	//If we are literally clicking on someone with IFF then we don't want to fire, feels funny as a user otherwise
	if(projectile_to_fire.original)
		var/turf/original_target_turf = get_turf(projectile_to_fire.original)

		if(original_target_turf && !(original_target_turf in checked_turfs))
			var/user_to_target_dist = get_dist(starting_turf, original_target_turf)
			var/list/temp_checked_turfs = checked_turfs
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
			if(checked_living.lying && projectile_to_fire.original != checked_living)
				continue

			if(checked_living.get_target_lock(user.faction_group))
				if(COOLDOWN_FINISHED(src, iff_halt_cooldown))
					playsound_client(user.client, 'sound/weapons/smartgun_fail.ogg', src, 25)
					to_chat(user, SPAN_WARNING("[firing_weapon] halts firing as an IFF marked target crosses your field of fire!"))
					COOLDOWN_START(src, iff_halt_cooldown, IFF_HALT_COOLDOWN)
				if(iff_additional_fire_delay)
					var/obj/item/weapon/gun/gun = firing_weapon
					if(istype(gun))
						gun.modify_fire_delay(iff_additional_fire_delay)
				return COMPONENT_CANCEL_GUN_BEFORE_FIRE

			return //if we have a target we *can* hit and find it before any IFF targets we want to fire

#undef IFF_HALT_COOLDOWN
