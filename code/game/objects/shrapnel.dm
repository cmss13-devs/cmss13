
/proc/create_shrapnel(turf/epicenter, shrapnel_number = 10, shrapnel_direction, shrapnel_spread = 45, datum/ammo/shrapnel_type = /datum/ammo/bullet/shrapnel, datum/cause_data/cause_data, ignore_source_mob = FALSE, on_hit_coefficient = 0.15)

	epicenter = get_turf(epicenter)

	var/initial_angle = 0
	var/angle_increment = 0

	if(shrapnel_direction)
		initial_angle = dir2angle(shrapnel_direction) - shrapnel_spread
		angle_increment = shrapnel_spread*2/shrapnel_number
	else
		angle_increment = 360/shrapnel_number
	var/angle_randomization = angle_increment/2

	var/mob/living/mob_standing_on_turf
	var/mob/living/mob_lying_on_turf
	var/atom/source = epicenter

	for(var/mob/living/current_mob in epicenter) //find a mob at the epicenter. Non-prone mobs take priority
		if(current_mob.density && !mob_standing_on_turf)
			mob_standing_on_turf = current_mob
		else if(!mob_lying_on_turf)
			mob_lying_on_turf = current_mob

	if(mob_standing_on_turf && isturf(mob_standing_on_turf.loc))
		source = mob_standing_on_turf//we designate any mob standing on the turf as the "source" so that they don't simply get hit by every projectile


	for(var/i=0;i<shrapnel_number;i++)

		var/obj/item/projectile/shrapnel = new(epicenter, cause_data)
		shrapnel.generate_bullet(new shrapnel_type)

		var/mob/source_mob = cause_data?.resolve_mob()
		if(!(ignore_source_mob && mob_standing_on_turf == source_mob) && mob_standing_on_turf && prob(100*on_hit_coefficient)) //if a non-prone mob is on the same turf as the shrapnel explosion, some of the shrapnel hits him
			shrapnel.ammo.on_hit_mob(mob_standing_on_turf, shrapnel)
			shrapnel.handle_mob(mob_standing_on_turf)
		else if (!(ignore_source_mob && mob_lying_on_turf == source_mob) && mob_lying_on_turf && prob(100*on_hit_coefficient))
			shrapnel.ammo.on_hit_mob(mob_lying_on_turf, shrapnel)
			shrapnel.handle_mob(mob_lying_on_turf)

		else
			var/angle = initial_angle + i*angle_increment + rand(-angle_randomization,angle_randomization)
			var/atom/target = get_angle_target_turf(epicenter, angle, 20)
			shrapnel.projectile_flags |= PROJECTILE_SHRAPNEL
			shrapnel.fire_at(target, source_mob, source, shrapnel.ammo.max_range, shrapnel.ammo.shell_speed, null)
