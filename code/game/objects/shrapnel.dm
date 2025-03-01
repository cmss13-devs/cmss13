/proc/create_shrapnel(turf/epicenter, shrapnel_number = 10, shrapnel_direction, shrapnel_spread = 45, datum/ammo/shrapnel_type = /datum/ammo/bullet/shrapnel, datum/cause_data/cause_data, ignore_source_mob = FALSE, on_hit_coefficient = 0.15, use_shrapnel_angle = FALSE)
    epicenter = get_turf(epicenter)

    // --- Damage tracking for the first two xenomorphs ---
    var/list/damage_tracker = list()

    // --- Original angle setup ---
    var/initial_angle = 0
    var/angle_increment = 0
    if(use_shrapnel_angle && shrapnel_spread < 360)
        initial_angle = shrapnel_direction - shrapnel_spread
        angle_increment = shrapnel_spread*2/shrapnel_number
    else if (shrapnel_direction)
        initial_angle = dir2angle(shrapnel_direction) - shrapnel_spread
        angle_increment = shrapnel_spread*2/shrapnel_number
    else
        angle_increment = 360/shrapnel_number
    var/angle_randomization = angle_increment/2

    // --- Original mob detection (first standing/lying mob) ---
    var/mob/living/mob_standing_on_turf
    var/mob/living/mob_lying_on_turf
    var/atom/source = epicenter

    for(var/mob/living/M in epicenter)
        if(M.density && !mob_standing_on_turf)
            mob_standing_on_turf = M
        else if(!mob_lying_on_turf)
            mob_lying_on_turf = M

    if(mob_standing_on_turf && isturf(mob_standing_on_turf.loc))
        source = mob_standing_on_turf

    // --- Process projectiles ---
    for(var/i=0;i<shrapnel_number;i++)
        var/obj/projectile/S = new(epicenter, cause_data)
        S.generate_bullet(new shrapnel_type)
        var/mob/source_mob = cause_data?.resolve_mob()

        // --- Prioritize standing mob ---
        if(!(ignore_source_mob && mob_standing_on_turf == source_mob) && mob_standing_on_turf && prob(100*on_hit_coefficient))
            if(istype(mob_standing_on_turf, /mob/living/carbon/xenomorph))
                var/mob/living/carbon/xenomorph/X = mob_standing_on_turf
                damage_tracker[X] = damage_tracker[X] || 0
                var/max_damage = X.maxHealth * 0.65
                var/remaining_damage = max_damage - damage_tracker[X]

                if(remaining_damage > 0)
                    var/damage_to_apply = min(initial(shrapnel_type.damage), remaining_damage)
                    S.ammo.damage = damage_to_apply
                    damage_tracker[X] += damage_to_apply
                    S.ammo.on_hit_mob(X, S)
                    S.handle_mob(X)
                else
                    goto MISS // Damage cap reached - treat as miss

            else
                S.ammo.on_hit_mob(mob_standing_on_turf, S)
                S.handle_mob(mob_standing_on_turf)

        // --- Fallback to lying mob ---
        else if (!(ignore_source_mob && mob_lying_on_turf == source_mob) && mob_lying_on_turf && prob(100*on_hit_coefficient))
            if(istype(mob_lying_on_turf, /mob/living/carbon/xenomorph))
                var/mob/living/carbon/xenomorph/X = mob_lying_on_turf
                damage_tracker[X] = damage_tracker[X] || 0
                var/max_damage = X.maxHealth * 0.5
                var/remaining_damage = max_damage - damage_tracker[X]

                if(remaining_damage > 0)
                    var/damage_to_apply = min(initial(shrapnel_type.damage), remaining_damage)
                    S.ammo.damage = damage_to_apply
                    damage_tracker[X] += damage_to_apply
                    S.ammo.on_hit_mob(X, S)
                    S.handle_mob(X)
                else
                    goto MISS

            else
                S.ammo.on_hit_mob(mob_lying_on_turf, S)
                S.handle_mob(mob_lying_on_turf)

        // --- Fixed spread pattern for misses ---
        else
            MISS:
            var/angle = initial_angle + i*angle_increment + rand(-angle_randomization, angle_randomization)
            var/atom/target = get_angle_target_turf(epicenter, angle, 20)
            S.projectile_flags |= PROJECTILE_SHRAPNEL
            S.fire_at(target, source_mob, source, S.ammo.max_range, S.ammo.shell_speed, null)
