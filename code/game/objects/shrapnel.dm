/proc/create_shrapnel(turf/epicenter, shrapnel_number = 10, shrapnel_direction, shrapnel_spread = 45, datum/ammo/shrapnel_type = /datum/ammo/bullet/shrapnel, datum/cause_data/cause_data, ignore_source_mob = FALSE, on_hit_coefficient = 0.15, use_shrapnel_angle = FALSE)
    epicenter = get_turf(epicenter)

    // --- Damage tracking for xenomorphs ---
    var/list/damage_tracker = list()

    // --- Angle setup ---
    var/initial_angle = 0
    var/angle_increment = 0
    if(use_shrapnel_angle && shrapnel_spread < 360)
        initial_angle = shrapnel_direction - shrapnel_spread
        angle_increment = shrapnel_spread * 2 / shrapnel_number
    else if (shrapnel_direction)
        initial_angle = dir2angle(shrapnel_direction) - shrapnel_spread
        angle_increment = shrapnel_spread * 2 / shrapnel_number
    else
        angle_increment = 360 / shrapnel_number
    var/angle_randomization = angle_increment / 2

    // --- Mob detection ---
    var/mob/living/mob_standing_on_turf
    var/atom/source = epicenter

    for(var/mob/living/M in epicenter)
        if(M.density && !mob_standing_on_turf)
            mob_standing_on_turf = M

    if(mob_standing_on_turf && isturf(mob_standing_on_turf.loc))
        source = mob_standing_on_turf // Designate standing mob as the source

    // --- Projectile loop ---
    for(var/i = 0; i < shrapnel_number; i++)
        var/obj/projectile/S = new(epicenter, cause_data)
        S.generate_bullet(new shrapnel_type)
        var/mob/source_mob = cause_data?.resolve_mob()

        // --- Standing mob logic with damage capping ---
        if(!(ignore_source_mob && mob_standing_on_turf == source_mob) && mob_standing_on_turf && prob(100 * on_hit_coefficient))
            if(istype(mob_standing_on_turf, /mob/living/carbon/xenomorph))
                var/mob/living/carbon/xenomorph/X = mob_standing_on_turf
                damage_tracker[X] = damage_tracker[X] || 0 // Initialize damage tracker if not already
                var/max_damage = X.maxHealth * 0.65 // Cap at 65% of max health
                var/remaining_damage = max_damage - damage_tracker[X]

                if(remaining_damage > 0)
                    var/damage_to_apply = min(initial(shrapnel_type.damage), remaining_damage)
                    S.ammo.damage = damage_to_apply // Adjust projectile damage
                    damage_tracker[X] += damage_to_apply // Update damage tracker
                    S.ammo.on_hit_mob(X, S)
                    S.handle_mob(X)
            else
                // Non-xenomorph mobs take full damage
                S.ammo.on_hit_mob(mob_standing_on_turf, S)
                S.handle_mob(mob_standing_on_turf)
        else
            // --- Fixed spread pattern for misses ---
            var/angle = initial_angle + i * angle_increment + rand(-angle_randomization, angle_randomization)
            var/atom/target = get_angle_target_turf(epicenter, angle, 20)
            S.projectile_flags |= PROJECTILE_SHRAPNEL
            S.fire_at(target, source_mob, source, S.ammo.max_range, S.ammo.shell_speed, null)
