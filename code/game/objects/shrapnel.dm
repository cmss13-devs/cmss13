
/proc/create_shrapnel(turf/epicenter, shrapnel_number = 10, shrapnel_direction, shrapnel_spread = 45, datum/ammo/shrapnel_type = /datum/ammo/bullet/shrapnel, datum/cause_data/cause_data, ignore_source_mob = FALSE, on_hit_coefficient = 0.15, use_shrapnel_angle = FALSE)

	epicenter = get_turf(epicenter)

	if(!epicenter)
		return

	if(shrapnel_number <= 0)
		return

	var/initial_angle = 0
	var/angle_increment = 0

	if(use_shrapnel_angle && shrapnel_spread < 360)
		initial_angle = shrapnel_direction - shrapnel_spread
		angle_increment = shrapnel_spread * 2 / shrapnel_number
	else if(shrapnel_direction)
		initial_angle = dir2angle(shrapnel_direction) - shrapnel_spread
		angle_increment = shrapnel_spread * 2 / shrapnel_number
	else
		angle_increment = 360 / shrapnel_number
	var/angle_randomization = angle_increment / 2

	var/mob/living/mob_standing_on_turf
	var/mob/living/mob_lying_on_turf

	for(var/mob/living/target_mob in epicenter) //find a mob at the epicenter. Non-prone mobs take priority
		if(target_mob.density)
			if(!mob_standing_on_turf)
				mob_standing_on_turf = target_mob
			continue
		if(!mob_lying_on_turf)
			mob_lying_on_turf = target_mob

	var/mob/source_mob = cause_data?.resolve_mob()
	var/mob/living/direct_hit_target

	if(mob_standing_on_turf)
		if(!(ignore_source_mob && mob_standing_on_turf == source_mob)) //if a non-prone mob is on the same turf as the shrapnel explosion, some of the shrapnel hits him
			direct_hit_target = mob_standing_on_turf

	else if(mob_lying_on_turf)
		if(!(ignore_source_mob && mob_lying_on_turf == source_mob))
			direct_hit_target = mob_lying_on_turf

	var/atom/source = epicenter

	if(mob_standing_on_turf && isturf(mob_standing_on_turf.loc))
		source = mob_standing_on_turf//we designate any mob standing on the turf as the "source" so that they don't simply get hit by every projectile

	var/hit_prob = 100 * on_hit_coefficient
	var/direct_hits = 0

	if(direct_hit_target)
		for(var/i = 0, i < shrapnel_number, i++)
			if(prob(hit_prob))
				direct_hits++

	var/datum/ammo/shrapnel_ammo = new shrapnel_type

	for(var/i = 0, i < direct_hits, i++)
		var/obj/projectile/shrapnel_proj = new(epicenter, cause_data)
		shrapnel_proj.generate_bullet(shrapnel_ammo)
		shrapnel_proj.ammo.on_hit_mob(direct_hit_target, shrapnel_proj)
		shrapnel_proj.handle_mob(direct_hit_target)

	var/projectiles_to_fire = shrapnel_number - direct_hits
	var/current_angle = initial_angle

	for(var/i = 0, i < projectiles_to_fire, i++)
		var/obj/projectile/shrapnel_proj = new(epicenter, cause_data)
		shrapnel_proj.generate_bullet(shrapnel_ammo)
		var/angle = current_angle + rand(-angle_randomization, angle_randomization)
		current_angle += angle_increment
		var/atom/target = get_angle_target_turf(epicenter, angle, 20)
		shrapnel_proj.projectile_flags |= PROJECTILE_SHRAPNEL
		shrapnel_proj.fire_at(target, source_mob, source, shrapnel_proj.ammo.max_range, shrapnel_proj.ammo.shell_speed, null)
