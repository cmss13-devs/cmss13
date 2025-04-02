/datum/moba_caste/runner
	equivalent_caste_path = /datum/caste_datum/runner
	equivalent_xeno_path = /mob/living/carbon/xenomorph/runner
	name = XENO_CASTE_RUNNER
	desc = {"
		Extremely mobile yet fragile caste focused on ambushes.<br>
		<b>P:</b> After landing three slashes on a target in short succession, quickly make a fourth attack.<br>
		<b>1:</b> Launch bone spurs at a target, dealing damage and slowing them.<br>
		<b>2:</b> Pounce at a nearby enemy, slashing them twice and slowing them.<br>
		<b>3:</b> Kick dirt in a cone behind you, slowing and blurring the vision of any enemies hit.<br>
		<b>U:</b> Gain a speed bonus and ignore some attacks for a short time.
	"}
	category = MOBA_ARCHETYPE_ASSASSIN
	icon_state = "runner"
	ideal_roles = list(MOBA_LANE_JUNGLE)
	starting_health = 360
	ending_health = 1200
	starting_health_regen = 1.3
	ending_health_regen = 5.1
	starting_plasma = 300
	ending_plasma = 650
	starting_plasma_regen = 3
	ending_plasma_regen = 6.2
	starting_armor = 0
	ending_armor = 5
	starting_acid_armor = 0
	ending_acid_armor = 5
	speed = -0.1
	attack_delay_modifier = 0.6
	starting_attack_damage = 37.5
	ending_attack_damage = 60
	abilities_to_add = list(
		/datum/action/xeno_action/activable/pounce/runner/moba,
		/datum/action/xeno_action/activable/runner_skillshot/moba,
		/datum/action/xeno_action/onclick/moba_kick_dirt,
		/datum/action/xeno_action/onclick/in_the_zone,
	)

/datum/moba_caste/runner/apply_caste(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum)
	. = ..()
	xeno.apply_status_effect(/datum/status_effect/stacking/rapid_claws)

// Basic bitch pounce - now with some free slashes!
/datum/action/xeno_action/activable/pounce/runner/moba
	desc = "Lunge towards a tile or target within 6 tiles. If you hit an enemy, you automatically make two attacks against them while slowing them by 30/50/70% for 1 second. Cooldown 19/17/15 seconds. Plasma cost of 70."
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 19 SECONDS
	plasma_cost = 70

	knockdown = FALSE
	freeze_self = FALSE

	var/slow = 0.3

/datum/action/xeno_action/activable/pounce/runner/moba/use_ability(atom/affected_atom)
	. = ..()
	if(!.)
		return
	playsound(owner, 'sound/voice/alien_pounce.ogg', 25, TRUE)

/datum/action/xeno_action/activable/pounce/runner/moba/additional_effects(mob/living/living)
	var/mob/living/carbon/target = living
	var/mob/living/carbon/xenomorph/xeno = owner

	xeno.a_intent_change(INTENT_HARM)
	target.attack_alien(xeno)
	if(isxeno(target))
		target.apply_status_effect(/datum/status_effect/slow, target.cur_speed * slow, 1 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(additional_slash), target, xeno), 0.3 SECONDS)
	SEND_SIGNAL(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, target)

/datum/action/xeno_action/activable/pounce/runner/moba/proc/additional_slash(mob/living/carbon/target, mob/living/carbon/xenomorph/xeno)
	target.attack_alien(xeno)
	xeno.next_move -= 0.3 SECONDS // redeeming cd from additional slash

/datum/action/xeno_action/activable/pounce/runner/moba/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((new_level - 1) * (2 SECONDS))
	slow = src::slow + ((new_level - 1) * 0.2)

	desc = "Lunge towards a tile or target within 6 tiles. If you hit an enemy, you automatically make two attacks against them while slowing them by [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 30, 50, 70)]% for 1 second. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 19, 17, 15)] seconds. Plasma cost of 70."

// [Insert bone joke here]
/datum/action/xeno_action/activable/runner_skillshot/moba
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 12 SECONDS
	plasma_cost = 70
	ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba

/datum/action/xeno_action/activable/runner_skillshot/moba/use_ability(atom/affected_atom)
	. = ..()
	if(!.)
		return
	playsound(owner, 'sound/effects/spike_spray.ogg', 25, TRUE)

/datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba
	damage = 40
	var/duration = 1 SECONDS
	var/slow = 0.3

/datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba/on_bullet_generation(obj/projectile/generated_projectile, mob/living/carbon/xenomorph/bullet_generator)
	. = ..()
	generated_projectile.damage = damage + (bullet_generator.melee_damage_upper * 0.25)
	var/list/armorpen_list = list()
	SEND_SIGNAL(bullet_generator, COMSIG_MOBA_GET_PHYS_PENETRATION, armorpen_list)
	generated_projectile.ammo.penetration = armorpen_list[1] // we can just do this since the ammo doesn't have inbuilt pen

/datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba/on_hit_mob(mob/living/M, obj/projectile/P)
	if(ishuman_strict(M) || isxeno(M))
		playsound(M, 'sound/effects/spike_hit.ogg', 25, 1, 1)
		M.apply_status_effect(/datum/status_effect/slow, M.cur_speed * slow, duration)
	SEND_SIGNAL(P.firer, COMSIG_XENO_PHYSICAL_ABILITY_HIT, M)

/datum/action/xeno_action/activable/runner_skillshot/moba/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((new_level - 1) * (2 SECONDS))
	switch(new_level)
		if(1)
			ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba
		if(2)
			ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba/lvl_two
		if(3)
			ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba/lvl_three

	desc = "Launch bone spurs at a target. On hit, deals [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 40, 52.5, 65)] (+25% AD) physical damage and slows the target by [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 40, 60, 75)]% for [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 1, 1.5, 2)] seconds. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 12, 10, 8)] seconds. Plasma cost of 70."

/datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba/lvl_two
	damage = 52.5
	duration = 1.5 SECONDS
	slow = 0.5

/datum/ammo/xeno/bone_chips/spread/runner_skillshot/moba/lvl_three
	damage = 65
	duration = 2 SECONDS
	slow = 0.7

// Send sand in the end
/datum/action/xeno_action/onclick/moba_kick_dirt
	name = "Kick Dirt"
	desc = "Kick dirt up in an area behind you. All enemies within the region have their vision blurred and their speed reduced by 10/15/20% for 2/3/4 seconds. Cooldown 22/20/18 seconds. Plasma cost of 90."
	action_icon_state = "unburrow"
	xeno_cooldown = 22 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 90
	var/distance = 4
	var/slow = 0.1
	var/blur = 1
	var/duration = 2 SECONDS

/datum/action/xeno_action/onclick/moba_kick_dirt/use_ability()
	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.animation_attack_on(get_step(get_turf(xeno), reverse_direction(xeno.dir)))

	var/list/cone = cone(get_turf(xeno), distance, reverse_direction(xeno.dir))
	for(var/turf/turf as anything in cone)
		if(turf.density)
			continue
		new /obj/effect/xenomorph/xeno_telegraph/runner_kick_dirt(turf, 7)
		for(var/mob/living/target in turf)
			if(target.stat == DEAD)
				continue
			if(xeno.hive.is_ally(target))
				continue
			var/is_blocked = FALSE
			for(var/turf/path_turf in get_line(xeno, target))
				if(path_turf.density)
					is_blocked = TRUE
			if(is_blocked)
				continue
			target.apply_status_effect(/datum/status_effect/slow, target.cur_speed * slow, duration)
			target.EyeBlur(50)
			addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, ReduceEyeBlur), 50), duration)
			SEND_SIGNAL(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, target)

	playsound(get_turf(xeno), 'sound/effects/bamf.ogg', 50, TRUE)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/moba_kick_dirt/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((new_level - 1) * (2 SECONDS))
	slow = src::slow + ((new_level - 1) * 0.05)
	duration = src::duration + ((new_level - 1) * 10)

	desc = "Kick dirt up in an area behind you. All enemies within the region have their vision blurred and their speed reduced by [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 10, 15, 20)]% for [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 2, 3, 4)] seconds. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 22, 20, 18)] seconds. Plasma cost of 90."

/proc/cone(turf/loc, distance, direction)
	. = list()
	var/true_direction = turn(direction, 45)
	var/stairs_step = loc
	for(var/current_step in 1 to distance)
		stairs_step = get_step(stairs_step, true_direction)
		if(!stairs_step)
			break
		. += stairs_step
		var/cone_floor = stairs_step
		for(var/i in 1 to (current_step * 2))
			cone_floor = get_step(cone_floor, turn(direction, -90))
			if(!cone_floor)
				break
			. += cone_floor

/obj/effect/xenomorph/xeno_telegraph/runner_kick_dirt
	icon_state = "xeno_telegraph_lash_anim"
	layer = BELOW_MOB_LAYER

// Nyooom vrrrrrrmmmmm
/datum/action/xeno_action/onclick/in_the_zone
	name = "In The Zone"
	action_icon_state = "tumble"
	xeno_cooldown = 120 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_cost = 100
	var/speed_bonus = -0.4
	var/evasion = 15 // %
	var/duration = 6 SECONDS

/datum/action/xeno_action/onclick/in_the_zone/use_ability()
	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.apply_status_effect(/datum/status_effect/in_the_zone, evasion, speed_bonus, duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/in_the_zone/level_up_ability(new_level)
	xeno_cooldown = src::xeno_cooldown - ((new_level - 1) * (15 SECONDS))
	evasion = src::evasion + ((new_level - 1) * 10)
	duration = src::duration + ((new_level - 1) * (2 SECONDS))

	desc = "For [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 6, 8, 10)] seconds, gain a -0.4 speed bonus and ignore [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 15, 25, 35)]% of all attacks targeted at you. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 120, 105, 90)] seconds. Plasma cost of 100."
