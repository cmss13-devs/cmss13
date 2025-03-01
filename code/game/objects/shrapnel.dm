/proc/create_shrapnel(turf/epicenter, shrapnel_number = 10, shrapnel_direction, shrapnel_spread = 45, datum/ammo/shrapnel_type = /datum/ammo/bullet/shrapnel, datum/cause_data/cause_data, ignore_source_mob = FALSE, on_hit_coefficient = 0.15, use_shrapnel_angle = FALSE)
	epicenter = get_turf(epicenter)

	// --- Damage tracking for xenomorphs ---
	var/list/damage_tracker = list() // Tracks total damage dealt to each xenomorph

	// --- Angle calculations ---
	var/initial_angle = 0
	var/angle_increment = use_shrapnel_angle && shrapnel_spread < 360 ? shrapnel_direction - shrapnel_spread : shrapnel_direction ? dir2angle(shrapnel_direction) - shrapnel_spread : 0
	angle_increment = shrapnel_direction ? shrapnel_spread * 2 / shrapnel_number : 360 / shrapnel_number
	var/angle_randomization = angle_increment / 2

	// --- Find mobs on the turf ---
	var/mob/living/mob_standing_on_turf
	var/mob/living/mob_lying_on_turf
	var/list/mob/living/carbon/xenomorph/xenos_on_turf = list()

	for(var/mob/living/M in epicenter)
		if(istype(M, /mob/living/carbon/xenomorph))
			xenos_on_turf += M
		else if(M.density && !mob_standing_on_turf)
			mob_standing_on_turf = M
		else if(!mob_lying_on_turf)
			mob_lying_on_turf = M

	// --- Set source for projectiles ---
	var/atom/source = mob_standing_on_turf && isturf(mob_standing_on_turf.loc) ? mob_standing_on_turf : epicenter
	var/mob/source_mob = cause_data?.resolve_mob()

	// --- Distribute shrapnel damage evenly among xenomorphs ---
	if(xenos_on_turf.len > 0)
		var/total_shrapnel_damage = shrapnel_number * initial(shrapnel_type.damage)
		var/list/available_xenos = xenos_on_turf.Copy()

		// --- Calculate each xenomorph's damage share ---
		while(total_shrapnel_damage > 0 && available_xenos.len > 0)
			var/damage_per_xeno = total_shrapnel_damage / available_xenos.len // Evenly distribute remaining damage

			for(var/mob/living/carbon/xenomorph/X in available_xenos)
				if(!damage_tracker[X])
					damage_tracker[X] = 0

				// --- Calculate damage cap based on tier ---
				var/damage_cap_percentage
				switch(X.caste.tier)
					if(1) damage_cap_percentage = 0.50 // T1: 50%
					if(2) damage_cap_percentage = 0.65 // T2: 65%
					if(3, 4) damage_cap_percentage = 0.75 // T3/T4: 75%
					else damage_cap_percentage = 0.50 // Default: 50%

				var/max_damage_per_xeno = X.maxHealth * damage_cap_percentage
				var/remaining_damage = max_damage_per_xeno - damage_tracker[X]

				if(remaining_damage > 0)
					var/damage_to_apply = min(damage_per_xeno, remaining_damage)
					damage_tracker[X] += damage_to_apply
					total_shrapnel_damage -= damage_to_apply

					// --- Create and fire a projectile for this damage ---
					var/obj/projectile/S = new(epicenter, cause_data)
					S.generate_bullet(new shrapnel_type)
					S.ammo.damage = damage_to_apply
					S.ammo.on_hit_mob(X, S)
					S.handle_mob(X)
				else
					available_xenos -= X // Remove xenomorphs that have reached their damage cap

	// --- Handle non-xenomorph mobs ---
	for(var/i = 0 to shrapnel_number - 1)
		if(!(ignore_source_mob && mob_standing_on_turf == source_mob) && mob_standing_on_turf && prob(100 * on_hit_coefficient))
			var/obj/projectile/S = new(epicenter, cause_data)
			S.generate_bullet(new shrapnel_type)
			S.ammo.on_hit_mob(mob_standing_on_turf, S)
			S.handle_mob(mob_standing_on_turf)
		else if(!(ignore_source_mob && mob_lying_on_turf == source_mob) && mob_lying_on_turf && prob(100 * on_hit_coefficient))
			var/obj/projectile/S = new(epicenter, cause_data)
			S.generate_bullet(new shrapnel_type)
			S.ammo.on_hit_mob(mob_lying_on_turf, S)
			S.handle_mob(mob_lying_on_turf)
		else
			var/angle = initial_angle + i * angle_increment + rand(-angle_randomization, angle_randomization)
			var/atom/target = get_angle_target_turf(epicenter, angle, 20)
			var/obj/projectile/S = new(epicenter, cause_data)
			S.generate_bullet(new shrapnel_type)
			S.projectile_flags |= PROJECTILE_SHRAPNEL
			S.fire_at(target, source_mob, source, S.ammo.max_range, S.ammo.shell_speed, null)
