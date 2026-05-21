/datum/xeno_strain/bulwark
	name = WARRIOR_BULWARK
	description = "You give up all of your normal abilities, some damage, speed, and tackle reliability in exchange for plasma, slightly stronger explosive resistance, and directional defenses. You take 50% less damage from wired cades, have a 75% chance to strike enemies behind wired cades, and gain bonus directional armor. Encasing Plates lets you enter a defensive stance that slows your movement but increases directional armor, makes you immune to knockbacks, and allows you to tear openings in walls and allow to attack enemies. Plate Bash dashes up to 3 tiles and strikes a target; while encased, it instead launches the target 3 tiles away and knocks them down. Tail Swing trips down enemies around you, and if used on a grenade, reflects it up to 3 tiles away with a reduced cooldown. Siegeborn will stimulate your body functions, when body sustain enough damage in stimulated period of time, it will trigger regenerative properties, when used during Reflective Shield ability, it will instead boost your reflexes, decreasing angle at with enemy fire is reflected. Reflective Shield allows you to can stop this ability at any time to gain 1s used as 2s cooldown, reflecting bullets up to 10 seconds, high from the front, medium from the sides, and low from behind."
	flavor_description = "Where there's a sword, there's a shield."
	icon_state_prefix = "Bulwark"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_plates, //1st
		/datum/action/xeno_action/activable/plate_bash, //2nd
		/datum/action/xeno_action/onclick/tail_swing, //3rd
		/datum/action/xeno_action/onclick/reflective_shield, //4th
		/datum/action/xeno_action/onclick/siegeborn, //5th
	)

	behavior_delegate_type = /datum/behavior_delegate/warrior_bulwark

/datum/xeno_strain/bulwark/apply_strain(mob/living/carbon/xenomorph/warrior/warrior)
	warrior.explosivearmor_modifier += XENO_EXPLOSIVE_ARMOR_TIER_1
	warrior.health_modifier += XENO_HEALTH_MOD_VERY_LARGE
	warrior.add_plasma += XENO_PLASMA_TIER_2
	warrior.speed += XENO_SPEED_TIER_1
	warrior.tackle_max_modifier += 1

	warrior.recalculate_everything()

//
// bulwark config
//

#define BULWARK_FRONT_ARMOR 10
#define BULWARK_SIDE_ARMOR 5
#define BULWARK_GRENADE_SWEEP_THROW 2
#define BULWARK_REFLECTION_DURATION 10 SECONDS
#define BULWARK_REFLECTION_CHANCE_BASE 80
#define BULWARK_REFLECTION_CHANCE_SIDES 65
#define BULWARK_REFLECTION_CHANCE_BACK 30
#define BULWARK_REFLECTED_BULLET_DAMAGE 0.5

//
// Passive benefits
//

/datum/behavior_delegate/warrior_bulwark
	name = "Bulwark Warrior Behavior Delegate"

	var/frontal_armor = BULWARK_FRONT_ARMOR
	var/sided_armor = BULWARK_SIDE_ARMOR

/datum/behavior_delegate/warrior_bulwark/append_to_stat()
	. = list()
	. += "Front Armor: +[frontal_armor + bound_xeno.front_armor]"
	. += "Side Armor: +[sided_armor + bound_xeno.side_armor]"
	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ENCLOSED_PLATES))
		. += "Encased Plates: -[XENO_DAMAGE_MOD_BULWARK] Claws Damage."
	var/datum/action/xeno_action/onclick/reflective_shield/ability_used = get_action(bound_xeno, /datum/action/xeno_action/onclick/reflective_shield)
	if(ability_used.reflective_start_time != -1)
		var/time_left = null
		time_left = (BULWARK_REFLECTIVE_TIME - (world.time - ability_used.reflective_start_time)) / 10
		. += "Reflective Plates Remaining Time: [time_left] second\s."
		return

/datum/behavior_delegate/warrior_bulwark/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(apply_directional_armor))

/datum/behavior_delegate/warrior_bulwark/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno_player, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno_player.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += BULWARK_FRONT_ARMOR
	else
		for(var/side_direction in get_perpen_dir(xeno_player.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += BULWARK_SIDE_ARMOR
				return

/datum/behavior_delegate/warrior_bulwark/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ENCLOSED_PLATES) && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Warrior Shield"
		return TRUE

/datum/behavior_delegate/warrior_bulwark/melee_attack_additional_effects_target(mob/living/carbon/carbon_target)
	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ENCLOSED_PLATES))
		bound_xeno.flick_attack_overlay(carbon_target, "punch") // We shmwack them with plates!

//
// 1st ability
//

/datum/action/xeno_action/onclick/toggle_plates/use_ability()
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(!istype(xeno_player))
		return

	XENO_ACTION_CHECK(xeno_player)

	var/datum/action/xeno_action/onclick/reflective_shield/ability_used = get_action(xeno_player, /datum/action/xeno_action/onclick/reflective_shield)
	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
			to_chat(xeno_player, SPAN_WARNING("We break our reflective stance!"))
			ability_used.reflective_safe_click_cooldown = -1
			ability_used.remove_reflective_shield()
		REMOVE_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES, TRAIT_SOURCE_ABILITY("enclosed_plates"))
		to_chat(xeno_player, SPAN_XENOWARNING("We lower our plates."))
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno_player.ability_speed_modifier -= speed_debuff
		xeno_player.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template_xeno"
		xeno_player.front_armor -= BULWARK_FRONT_ARMOR
		xeno_player.side_armor -= BULWARK_SIDE_ARMOR
		xeno_player.damage_modifier += XENO_DAMAGE_MOD_BULWARK
		xeno_player.tackle_min_modifier -= 2
	else
		ADD_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES, TRAIT_SOURCE_ABILITY("enclosed_plates"))
		to_chat(xeno_player, SPAN_XENOWARNING("We raise our plates and form a shield."))
		RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno_player.ability_speed_modifier += speed_debuff
		xeno_player.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"
		xeno_player.front_armor += BULWARK_FRONT_ARMOR
		xeno_player.side_armor += BULWARK_SIDE_ARMOR
		xeno_player.damage_modifier -= XENO_DAMAGE_MOD_BULWARK
		xeno_player.tackle_min_modifier += 2

	xeno_player.recalculate_tackle()
	xeno_player.update_icons()

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/toggle_plates/proc/check_directional_armor(mob/living/carbon/xenomorph/xeno_player, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno_player.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += xeno_player.front_armor
		return
	for(var/side_direction in get_perpen_dir(xeno_player.dir))
		if(projectile_direction == side_direction)
			damagedata["armor"] += xeno_player.side_armor
			return

//
// 2nd ability
//

/datum/action/xeno_action/activable/plate_bash/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!iscarbon(target_atom))
		return

	if(!isxeno_human(target_atom) || xeno_player.can_not_harm(target_atom))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	var/mob/living/carbon/carbon_target = target_atom
	if(carbon_target.stat == DEAD)
		return

	var/distance = get_dist(xeno_player, carbon_target)
	var/max_distance = 2
	if(distance > max_distance)
		return

	if(!HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.throw_atom(get_step_towards(carbon_target, xeno_player), 2, SPEED_SLOW, xeno_player, tracking=TRUE)
	if(!xeno_player.Adjacent(carbon_target))
		on_cooldown_end()
		return

	carbon_target.last_damage_data = create_cause_data(xeno_player.caste_type, xeno_player)
	var/facing = get_dir(xeno_player, carbon_target)

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.throw_carbon(carbon_target, facing, 3, SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)
		carbon_target.KnockDown(1)
	else
		xeno_player.throw_carbon(carbon_target, facing, 1, SPEED_SLOW, shake_camera = TRUE, immobilize = FALSE)

	apply_custom_cooldown()

	if(carbon_target.stat != DEAD && (!(carbon_target.status_flags & XENO_HOST) || !HAS_TRAIT(carbon_target, TRAIT_NESTED)))
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(carbon_target, base_damage), ARMOR_MELEE, BRUTE, "chest", 5)

	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] dashes at [carbon_target] with its armored plates!"),
	SPAN_XENOWARNING("We dash at [carbon_target] with our armored plates!"))

	xeno_player.face_atom(carbon_target)
	xeno_player.animation_attack_on(carbon_target)
	xeno_player.flick_attack_overlay(carbon_target, "punch")
	playsound(carbon_target,'sound/weapons/alien_claw_block.ogg', 50, 1)

	return ..()

//
// 3rd ability
//

/datum/action/xeno_action/onclick/tail_swing/use_ability()
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.balloon_alert(xeno_player, "we need to loosen our plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] swings its tail in a wide circle!"),
	SPAN_XENOWARNING("We swing our tail in a wide circle!"))

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	xeno_player.spin_circle()
	playsound(xeno_player,'sound/effects/tail_swing.ogg', 25, 1)

	var/hit_enemy = FALSE
	for(var/mob/living/carbon/carbon_target in orange(swing_range, get_turf(xeno_player)))
		if(!isxeno_human(carbon_target) || xeno_player.can_not_harm(carbon_target))
			continue
		if(carbon_target.stat == DEAD)
			continue
		if(HAS_TRAIT(carbon_target, TRAIT_NESTED))
			continue

		hit_enemy = TRUE
		xeno_player.flick_attack_overlay(carbon_target, "punch")
		carbon_target.last_damage_data = create_cause_data(xeno_player.caste_type, xeno_player)
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(xeno_player, 15), ARMOR_MELEE, BRUTE)
		shake_camera(carbon_target, 2, 1)

		if(carbon_target.mob_size < MOB_SIZE_BIG)
			carbon_target.apply_effect(get_xeno_stun_duration(carbon_target, 1), WEAKEN)

		to_chat(carbon_target, SPAN_XENOWARNING("You are tripped by [xeno_player]'s tail swing!"))
		playsound(carbon_target,'sound/weapons/alien_claw_block.ogg', 50, 1)

	var/hit_grenade = FALSE
	for(var/obj/item/explosive/grenade/grenade in orange(swing_range, get_turf(xeno_player)))
		hit_grenade = TRUE
		var/direction = get_dir(xeno_player, grenade)
		var/turf/target_destination = get_ranged_target_turf(grenade, direction, BULWARK_GRENADE_SWEEP_THROW)
		if(target_destination)
			grenade.throw_atom(target_destination, BULWARK_GRENADE_SWEEP_THROW, SPEED_FAST, grenade)
			playsound(xeno_player,'sound/effects/grenade_hit.ogg', 50, 1)

	if(!hit_enemy && hit_grenade)
		xeno_cooldown *= 0.3

	if(!hit_enemy)
		xeno_cooldown *= 0.3

	apply_custom_cooldown()

	return ..()

//
// 4th ability
//

/datum/action/xeno_action/onclick/reflective_shield/use_ability()
	var/mob/living/carbon/xenomorph/warrior/xeno_player = owner

	var/datum/behavior_delegate/warrior_bulwark/behavior = xeno_player.behavior_delegate
	if(!istype(behavior))
		return

	XENO_ACTION_CHECK(xeno_player)

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
		remove_reflective_shield()
		return

	if(!HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.balloon_alert(xeno_player, "we need to tense up our plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	var/datum/action/xeno_action/onclick/siegeborn/ability_used = get_action(xeno_player, /datum/action/xeno_action/onclick/siegeborn)
	ability_used.button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, "siegeborn_enhance")

	if(!check_and_use_plasma_owner(80))
		return

	ADD_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES, TRAIT_SOURCE_ABILITY("reflective_plates"))
	button.icon_state = "template_active"
	reflective_start_time = world.time
	reflective_safe_click_cooldown = world.time + 1 SECONDS

	xeno_player.add_filter("reflective_shield", 1, list("type" = "outline", "color" = "#2b8080", "size" = 1))
	to_chat(xeno_player, SPAN_XENOWARNING("We adjust our plates and get ready for incoming attacks!"))
	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] shifts its stance, its reflexive defense faltering."))

	if(reflective_shield_timer_id != TIMER_ID_NULL)
		deltimer(reflective_shield_timer_id)

	reflective_shield_timer_id = addtimer(CALLBACK(src, PROC_REF(remove_reflective_shield)), BULWARK_REFLECTION_DURATION, TIMER_STOPPABLE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/reflective_shield/proc/remove_reflective_shield()
	var/mob/living/carbon/xenomorph/warrior/xeno_player = owner

	var/datum/behavior_delegate/warrior_bulwark/behavior = xeno_player.behavior_delegate
	if(!istype(behavior))
		return

	var/datum/action/xeno_action/onclick/reflective_shield/ability_used = get_action(xeno_player, /datum/action/xeno_action/onclick/reflective_shield)
	if(!istype(ability_used))
		return

	if(!HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
		return

	if(world.time < ability_used.reflective_safe_click_cooldown)
		to_chat(xeno_player, SPAN_XENOWARNING("We need a moment before breaking our reflective stance!"))
		return

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_SIEGEBORN))
		REMOVE_TRAIT(xeno_player, TRAIT_ABILITY_SIEGEBORN, TRAIT_SOURCE_ABILITY("siegeborn"))
		stop_yellow_visual()

	var/datum/action/xeno_action/onclick/siegeborn/siege_used = get_action(xeno_player, /datum/action/xeno_action/onclick/siegeborn)
	siege_used.button.overlays -= image('icons/mob/hud/actions_xeno.dmi', button, "siegeborn_enhance")

	REMOVE_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES, TRAIT_SOURCE_ABILITY("reflective_plates"))
	button.icon_state = "template_xeno"
	xeno_player.remove_filter("reflective_shield")
	to_chat(xeno_player, SPAN_XENOWARNING("We adjust our plates and stance back to normal."))

	if(ability_used.reflective_shield_timer_id != TIMER_ID_NULL)
		deltimer(ability_used.reflective_shield_timer_id)
		ability_used.reflective_shield_timer_id = TIMER_ID_NULL

	if(ability_used.reflective_start_time > 0)
		var/used_ratio = round((world.time - ability_used.reflective_start_time) / ability_used.duration, 0.1)
		ability_used.reflective_recharge_time = max(BULWARK_REFLECTION_DURATION * used_ratio * ability_used.reflective_refund_multiplier, 5 SECONDS)

	ability_used.reflective_start_time = -1
	apply_cooldown_override(ability_used.reflective_recharge_time)

/datum/action/xeno_action/onclick/reflective_shield/proc/stop_yellow_visual()
	owner.remove_filter("bulwark_yellow_outline")

/mob/living/carbon/xenomorph/warrior/get_reflection_chance(obj/projectile/bullet)
	var/datum/behavior_delegate/warrior_bulwark/behavior = src.behavior_delegate

	if(!istype(behavior))
		return

	if(!HAS_TRAIT(src, TRAIT_ABILITY_REFLECTIVE_PLATES))
		return

	if((bullet.ammo.flags_ammo_behavior & AMMO_SNIPER) || (bullet.ammo.flags_ammo_behavior & AMMO_ROCKET))
		return //we don't want to reflect sniper bullets or rockets.

	var/projectile_dir = 0

	if(!bullet.firer)
		return

	projectile_dir = bullet.dir

	if(src.dir & REVERSE_DIR(projectile_dir))
		return BULWARK_REFLECTION_CHANCE_BASE

	for(var/side_dir in get_perpen_dir(src.dir))
		if(projectile_dir == side_dir)
			return BULWARK_REFLECTION_CHANCE_SIDES

	return BULWARK_REFLECTION_CHANCE_BACK

/obj/projectile/proc/reflect_projectile_at_firer(mob/living/carbon/xenomorph/xeno_player, obj/projectile/bullet)
	if(!bullet.firer || !isturf(loc))
		return

	var/obj/projectile/new_proj = new(get_turf(xeno_player), create_cause_data("reflective shield"))
	new_proj.generate_bullet(bullet.ammo)
	new_proj.damage = bullet.damage * BULWARK_REFLECTED_BULLET_DAMAGE
	new_proj.accuracy = HIT_ACCURACY_TIER_8
	new_proj.projectile_flags |= PROJECTILE_SHRAPNEL

	var/angle_spread = 45

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
		if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_SIEGEBORN))
			angle_spread = 15

	var/angle = Get_Angle(xeno_player, bullet.firer) + rand(-angle_spread, angle_spread)
	var/atom/target = get_angle_target_turf(xeno_player, angle, get_dist(xeno_player, bullet.firer))
	new_proj.fire_at(target, xeno_player, xeno_player, 7, speed = bullet.ammo.shell_speed)

	to_chat(xeno_player, SPAN_XENOWARNING("We reflect [bullet] back at [bullet.firer]!"))

//
// 5th ability
//

/datum/action/xeno_action/onclick/siegeborn/use_ability()
	var/mob/living/carbon/xenomorph/xeno_player = owner

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	ADD_TRAIT(xeno_player, TRAIT_ABILITY_SIEGEBORN, TRAIT_SOURCE_ABILITY("siegeborn"))
	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
		xeno_player.add_filter("bulwark_yellow_outline", 1, list("type" = "outline", "color" = "#e4d614af", "size" = 1))
		xeno_player.balloon_alert(xeno_player, "our reflexes are improved!")
		to_chat(xeno_player, SPAN_XENONOTICE("We improve our reflective stance!"))
		apply_cooldown()
		return

	RegisterSignal(xeno_player, COMSIG_MOB_TAKE_DAMAGE, PROC_REF(damage_accumulate))
	addtimer(CALLBACK(src, PROC_REF(stop_accumulating)), 5 SECONDS)

	xeno_player.balloon_alert(xeno_player, "we stimulate our regeneration!")
	to_chat(xeno_player, SPAN_XENONOTICE("We begin to accumulate incoming damage!"))

	xeno_player.add_filter("bulwark_red_outline", 1, list("type" = "outline", "color" = "#721010", "size" = 1))

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/siegeborn/proc/damage_accumulate(owner, damage_data, damage_type)
	SIGNAL_HANDLER

	damage_accumulated += damage_data["damage"]

	if(damage_accumulated >= damage_threshold)
		addtimer(CALLBACK(src, PROC_REF(accumulated), owner))
		UnregisterSignal(owner, COMSIG_MOB_TAKE_DAMAGE)

/datum/action/xeno_action/onclick/siegeborn/proc/stop_accumulating()
	UnregisterSignal(owner, COMSIG_MOB_TAKE_DAMAGE)

	damage_accumulated = 0
	to_chat(owner, SPAN_XENONOTICE("We did not accumulate enough damage."))
	owner.remove_filter("bulwark_red_outline")
	REMOVE_TRAIT(owner, TRAIT_ABILITY_SIEGEBORN, TRAIT_SOURCE_ABILITY("siegeborn"))

/datum/action/xeno_action/onclick/siegeborn/proc/accumulated()

	REMOVE_TRAIT(owner, TRAIT_ABILITY_SIEGEBORN, TRAIT_SOURCE_ABILITY("siegeborn"))
	owner.remove_filter("bulwark_red_outline")
	owner.flick_heal_overlay(3 SECONDS, "#00B800")
	owner.visible_message(SPAN_XENOWARNING("[owner] carapace start to rapidly mend!"),
	SPAN_XENOWARNING("We feel our body react to damage and rapidly heal!"))

	var/mob/living/carbon/xenomorph/xeno_player = owner
	new /datum/effects/heal_over_time(xeno_player, heal_amount = 100)

//
// Custom Proc(s)
//

/datum/action/xeno_action/proc/apply_custom_cooldown()
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown) //We revert cooldown back to original value (after it got applied)
