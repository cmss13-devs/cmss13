/datum/xeno_strain/bulwark
	name = WARRIOR_BULWARK
	description = "You give up all of your normal abilities, some damage, speed, and tackle reliability in exchange for plasma, slightly stronger explosive resistance, and directional defenses. You take 50% less damage from wired cades, have a 75% chance to strike enemies behind wired cades, and gain bonus directional armor. Encasing Plates lets you enter a defensive stance that slows your movement but increases directional armor, makes you immune to knockbacks, and allows you to tear openings in walls. Plate Bash dashes up to 3 tiles and strikes a target; while encased, it instead launches the target 3 tiles away and knocks them down, but the cooldown is doubled. Tail Swing knocks down enemies around you, and if used on a grenade, reflects it up to 3 tiles away with a reduced cooldown. Plate Slam has a 3-second windup and then pins enemy down for 7 seconds if they are standing, 10 seconds if they were prone, to stop pinning down enemy, disengage encased plates or use ability twice on same target; being interrupted during windup causes a heavy cooldown penalty. Reflective Shield allows you to can stop this ability at any time to gain 1s used as 2s cooldown, reflecting bullets up to 10 seconds, high from the front, medium from the sides, and low from behind."
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
		/datum/action/xeno_action/activable/plate_slam, //5th
	)

	behavior_delegate_type = /datum/behavior_delegate/warrior_bulwark

/datum/xeno_strain/bulwark/apply_strain(mob/living/carbon/xenomorph/warrior/warrior)
	warrior.explosivearmor_modifier += XENO_EXPLOSIVE_ARMOR_TIER_1
	warrior.add_plasma += XENO_PLASMA_TIER_2
	warrior.speed += XENO_SPEED_TIER_1
	warrior.tackle_min_modifier += 2
	warrior.tackle_max_modifier += 1

	warrior.recalculate_everything()

//
// Passive benefits
//

#define BULWARK_FRONT_ARMOR 10
#define BULWARK_SIDE_ARMOR 5
#define BULWARK_GRENADE_SWEEP_THROW 2
#define BULWARK_REFLECTION_DURATION 10 SECONDS
#define BULWARK_REFLECTION_BASE_CHANCE 80
#define BULWARK_SIDE_REFLECTION_PROCENTAGE 0.8
#define BULWARK_BACK_REFLECTION_PROCENTAGE 0.35
#define BULWARK_REFLECTED_BULLET_DAMAGE 0.5

/datum/behavior_delegate/warrior_bulwark
	name = "Bulwark Warrior Behavior Delegate"

	var/frontal_armor = BULWARK_FRONT_ARMOR
	var/sided_armor = BULWARK_SIDE_ARMOR

	/// How much time is left on timer. (used for status)
	var/time_left = null
	/// Chance to reflect projectile when hit while reflective shield is active.
	var/reflective_shield_chance = 0
	/// Store target of plate slam ability.
	var/datum/weakref/plate_slam_target = null
	/// Shield slam addtimer ID (for deletion)
	var/shield_slam_timer_id = TIMER_ID_NULL

/datum/behavior_delegate/warrior_bulwark/append_to_stat()
	. = list()
	. += "Front Armor: +[frontal_armor + bound_xeno.front_armor]"
	. += "Side Armor: +[sided_armor + bound_xeno.side_armor]"
	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ENCLOSED_PLATES))
		. += "Encased Plates: -[XENO_DAMAGE_MOD_BULWARK] Claws Damage."
	var/datum/action/xeno_action/onclick/reflective_shield/ability_used = get_action(bound_xeno, /datum/action/xeno_action/onclick/reflective_shield)
	if(ability_used.reflective_start_time != -1)
		time_left = (BULWARK_REFLECTIVE_TIME - (world.time - ability_used.reflective_start_time)) / 10
		. += "Reflective Plates Remaining Time: [time_left] second\s."
		return

/datum/behavior_delegate/warrior_bulwark/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(apply_directional_armor))

/datum/behavior_delegate/warrior_bulwark/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno_player, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno_player.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(xeno_player.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += sided_armor
				return

/datum/behavior_delegate/warrior_bulwark/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ENCLOSED_PLATES) && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Warrior Shield"
		return TRUE

/datum/behavior_delegate/warrior_bulwark/handle_death()
	var/datum/action/xeno_action/activable/plate_slam/ability_used = get_action(bound_xeno, /datum/action/xeno_action/activable/plate_slam)
	ability_used.end_plate_slam()

//
// 1st ability
//

/datum/action/xeno_action/onclick/toggle_plates/use_ability()
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(!istype(xeno_player))
		return

	XENO_ACTION_CHECK(xeno_player)

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
			xeno_player.balloon_alert(xeno_player, "we need to stop reflective stance!", text_color = "#7d32bb", delay = 1 SECONDS)
			return
		REMOVE_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES, TRAIT_SOURCE_ABILITY("enclosed_plates"))
		to_chat(xeno_player, SPAN_XENOWARNING("We lower our plates."))
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno_player.ability_speed_modifier -= speed_debuff
		xeno_player.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template_xeno"
		xeno_player.front_armor -= BULWARK_FRONT_ARMOR
		xeno_player.side_armor -= BULWARK_SIDE_ARMOR
		xeno_player.damage_modifier += XENO_DAMAGE_MOD_BULWARK

		if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_PLATE_SLAM))
			end_plate_slam()
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

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_PLATE_SLAM))
		xeno_player.balloon_alert(xeno_player, "we need to stop pinning down the target!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

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
		xeno_cooldown *= 2
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

/datum/action/xeno_action/onclick/tail_swing/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.balloon_alert(xeno_player, "we need to loosen our plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] swings its tail in a wide circle!"),
	SPAN_XENOWARNING("We swing our tail in a wide circle!"))

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	xeno_player.spin_circle()
	playsound(xeno_player,'sound/effects/tail_swing.ogg', 25, 1)

	for(var/mob/living/carbon/carbon_target in orange(swing_range, get_turf(xeno_player)))
		if(!isxeno_human(carbon_target) || xeno_player.can_not_harm(carbon_target))
			continue
		if(carbon_target.stat == DEAD)
			continue
		if(HAS_TRAIT(carbon_target, TRAIT_NESTED))
			continue

		hit_enemy = TRUE
		step_away(carbon_target, xeno_player, swing_range, 2)
		xeno_player.flick_attack_overlay(carbon_target, "punch")
		carbon_target.last_damage_data = create_cause_data(xeno_player.caste_type, xeno_player)
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(xeno_player, 15), ARMOR_MELEE, BRUTE)
		shake_camera(carbon_target, 2, 1)

		if(carbon_target.mob_size < MOB_SIZE_BIG)
			carbon_target.apply_effect(get_xeno_stun_duration(carbon_target, 1), WEAKEN)

		to_chat(carbon_target, SPAN_XENOWARNING("You are struck by [xeno_player]'s tail swing!"))
		playsound(carbon_target,'sound/weapons/alien_claw_block.ogg', 50, 1)

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

/datum/action/xeno_action/onclick/reflective_shield/use_ability(atom/target_atom)
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

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_PLATE_SLAM))
		to_chat(xeno_player, SPAN_XENODANGER("We stop pinning down target to do our reflective stance!"))
		end_plate_slam()

	if(!check_and_use_plasma_owner(100))
		return

	ADD_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES, TRAIT_SOURCE_ABILITY("reflective_plates"))
	behavior.reflective_shield_chance = BULWARK_REFLECTION_BASE_CHANCE
	button.icon_state = "template_active"
	reflective_start_time = world.time
	reflective_safe_click_cooldown = world.time + 1 SECONDS

	xeno_player.add_filter("reflective_shield", 1, list("type" = "outline", "color" = "#2b8080", "size" = 1))
	to_chat(xeno_player, SPAN_XENOWARNING("We adjust our plates and get ready for incoming attacks!"))
	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] shifts its stance, its reflexive defense faltering."))

	if(reflective_shield_timer_id != TIMER_ID_NULL)
		deltimer(reflective_shield_timer_id)

	reflective_shield_timer_id = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/action/xeno_action, remove_reflective_shield)), BULWARK_REFLECTION_DURATION, TIMER_STOPPABLE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/proc/remove_reflective_shield()
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

	REMOVE_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES, TRAIT_SOURCE_ABILITY("reflective_plates"))
	behavior.reflective_shield_chance = 0
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

/mob/living/carbon/xenomorph/warrior/get_reflection_chance(obj/projectile/bullet)
	var/datum/behavior_delegate/warrior_bulwark/behavior = src.behavior_delegate

	if(!istype(behavior))
		return

	if(!HAS_TRAIT(src, TRAIT_ABILITY_REFLECTIVE_PLATES))
		return

	if((bullet.ammo.flags_ammo_behavior & ARMOR_PENETRATION_TIER_10) || (bullet.ammo.flags_ammo_behavior & AMMO_ROCKET))
		return //we don't want to reflect wall penetrating bullets or rockets.

	var/base_chance = behavior.reflective_shield_chance
	var/projectile_dir = 0

	if(!bullet.firer)
		return

	projectile_dir = get_dir(bullet.firer.loc, src)

	if(projectile_dir == REVERSE_DIR(src.dir))
		return base_chance

	for(var/side_dir in get_perpen_dir(src.dir))
		if(projectile_dir == side_dir)
			return base_chance * BULWARK_SIDE_REFLECTION_PROCENTAGE //only gets ?% value of base reflection chance.

	return base_chance * BULWARK_BACK_REFLECTION_PROCENTAGE

/obj/projectile/proc/reflect_projectile_at_firer(mob/living/carbon/xenomorph/xeno_player, obj/projectile/bullet)
	if(!bullet.firer || !isturf(loc))
		return

	var/obj/projectile/new_proj = new(get_turf(xeno_player), create_cause_data("reflective shield"))
	new_proj.generate_bullet(bullet.ammo)
	new_proj.damage = bullet.damage * BULWARK_REFLECTED_BULLET_DAMAGE
	new_proj.accuracy = HIT_ACCURACY_TIER_8
	new_proj.projectile_flags |= PROJECTILE_SHRAPNEL

	var/angle = Get_Angle(xeno_player, bullet.firer) + rand(-45, 45)
	var/atom/target = get_angle_target_turf(xeno_player, angle, get_dist(xeno_player, bullet.firer))
	new_proj.fire_at(target, xeno_player, xeno_player, 7, speed = bullet.ammo.shell_speed)

	to_chat(xeno_player, SPAN_XENOWARNING("We reflect [bullet] back at [bullet.firer]!"))

//
// 5th ability
//

/datum/action/xeno_action/activable/plate_slam/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!iscarbon(target_atom))
		return

	var/mob/living/carbon/carbon_target = target_atom

	if(!isxeno_human(carbon_target) || xeno_player.can_not_harm(carbon_target))
		to_chat(xeno_player, SPAN_DANGER("We need a target!"))
		return

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_REFLECTIVE_PLATES))
		to_chat(xeno_player, SPAN_DANGER("We need to stop our reflective stance!"))
		return

	if(HAS_TRAIT(xeno_player, TRAIT_ABILITY_PLATE_SLAM))
		if(HAS_TRAIT(carbon_target, TRAIT_ABILITY_PLATE_SLAM))
			end_plate_slam()
			return
		to_chat(xeno_player, SPAN_DANGER("We are already pinning down our target!"))
		return

	if(HAS_TRAIT(carbon_target, TRAIT_ABILITY_PLATE_SLAM))
		to_chat(xeno_player, SPAN_DANGER("This target is already pinned down!"))
		return

	if(get_dist(xeno_player, carbon_target) > 1)
		to_chat(xeno_player, SPAN_DANGER("We need to get closer to target!"))
		return

	XENO_ACTION_CHECK(xeno_player)

	if(carbon_target.stat == DEAD)
		return

	if(!HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.balloon_alert(xeno_player, "we need to tense up our plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	for(var/datum/effects/floored_target/floored_target in carbon_target.effects_list)
		qdel(floored_target)

	if((carbon_target.status_flags & XENO_HOST) || HAS_TRAIT(carbon_target, TRAIT_NESTED))
		to_chat(xeno_player, SPAN_DANGER("We don't want to harm this host!"))
		return

	xeno_player.visible_message(SPAN_XENODANGER("[xeno_player] gets ready to pin [carbon_target] down!"), SPAN_XENODANGER("We start to get ready to pin [carbon_target] down with our plates!"))

	if(!do_after(xeno_player, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(xeno_player, SPAN_DANGER("We lose our balance!"))
		to_chat(carbon_target, SPAN_DANGER("You notice the enemy lose their balance!"))
		xeno_cooldown *= 0.5
		apply_custom_cooldown()
		return

	if(HAS_TRAIT(carbon_target, TRAIT_ABILITY_PLATE_SLAM))
		to_chat(xeno_player, SPAN_DANGER("This target is already pinned down!"))
		return

	if(get_dist(xeno_player, carbon_target) > 1)
		to_chat(xeno_player, SPAN_DANGER("We miss our target!"))
		to_chat(carbon_target, SPAN_DANGER("You slip past the shield of plates as they smash into the ground beside you!"))
		playsound(xeno_player, 'sound/effects/alien_footstep_charge3.ogg', 25, 0)
		xeno_cooldown *= 0.5
		apply_custom_cooldown()
		return

	if(!HAS_TRAIT(xeno_player, TRAIT_ABILITY_ENCLOSED_PLATES))
		xeno_player.balloon_alert(xeno_player, "we need to keep our plates tensed up!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	if(carbon_target.stat == DEAD)
		return

	if(ishuman(carbon_target))
		var/mob/living/carbon/human/human = carbon_target
		INVOKE_ASYNC(carbon_target, TYPE_PROC_REF(/mob, emote), "scream")
		human.update_xeno_hostile_hud()

	xeno_player.emote("roar")

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	xeno_player.face_atom(carbon_target)
	xeno_player.animation_attack_on(carbon_target)

	carbon_target.anchored = TRUE
	xeno_player.anchored = TRUE

	ADD_TRAIT(carbon_target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plate_slam"))
	ADD_TRAIT(carbon_target, TRAIT_FLOORED, TRAIT_SOURCE_ABILITY("plate_slam"))
	ADD_TRAIT(xeno_player, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plate_slam"))

	ADD_TRAIT(xeno_player, TRAIT_ABILITY_PLATE_SLAM, TRAIT_SOURCE_ABILITY("plate_slam"))
	ADD_TRAIT(carbon_target, TRAIT_ABILITY_PLATE_SLAM, TRAIT_SOURCE_ABILITY("plate_slam"))

	var/datum/behavior_delegate/warrior_bulwark/behavior = xeno_player.behavior_delegate
	behavior.plate_slam_target = WEAKREF(carbon_target)

	if(carbon_target.body_position != LYING_DOWN)
		behavior.shield_slam_timer_id = addtimer(CALLBACK(src, PROC_REF(end_plate_slam)), 7 SECONDS, TIMER_STOPPABLE)
		new /datum/effects/floored_target(carbon_target, xeno_player, , , 7 SECONDS)
		xeno_player.visible_message(SPAN_XENODANGER("[xeno_player] bashes [carbon_target] down!"), SPAN_XENODANGER("We bash [carbon_target] down and pin them with our plates!"))
		carbon_target.apply_effect(1, WEAKEN)
		playsound(xeno_player, 'sound/effects/hit_kick.ogg', 35, 1)
	else
		behavior.shield_slam_timer_id = addtimer(CALLBACK(src, PROC_REF(end_plate_slam)), 10 SECONDS, TIMER_STOPPABLE)
		new /datum/effects/floored_target(carbon_target, xeno_player, , , 10 SECONDS)
		xeno_player.visible_message(SPAN_XENODANGER("[xeno_player] pins [carbon_target] down!"), SPAN_XENODANGER("We pin [carbon_target] down with our plates!"))

	if(ishuman(carbon_target))
		var/mob/living/carbon/human/target_human = carbon_target
		target_human.update_xeno_hostile_hud()

	to_chat(carbon_target, SPAN_DANGER("You are slammed to the ground and pinned down by armored plates!"))

	apply_custom_cooldown()

	return ..()


/datum/action/xeno_action/proc/end_plate_slam()
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!istype(xeno_player))
		return

	var/datum/behavior_delegate/warrior_bulwark/behavior = xeno_player.behavior_delegate
	target = behavior.plate_slam_target.resolve()

	deltimer(target, behavior.shield_slam_timer_id)

	target.anchored = FALSE
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plate_slam"))
	REMOVE_TRAIT(target, TRAIT_FLOORED, TRAIT_SOURCE_ABILITY("plate_slam"))
	REMOVE_TRAIT(target, TRAIT_ABILITY_PLATE_SLAM, TRAIT_SOURCE_ABILITY("plate_slam"))

	xeno_player.anchored = FALSE
	REMOVE_TRAIT(xeno_player, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plate_slam"))
	REMOVE_TRAIT(xeno_player, TRAIT_ABILITY_PLATE_SLAM, TRAIT_SOURCE_ABILITY("plate_slam"))

	for(var/datum/effects/floored_target/floored_target in target.effects_list)
		qdel(floored_target)

//
// Custom Proc(s)
//

/datum/action/xeno_action/proc/apply_custom_cooldown()
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown) //We revert cooldown back to original value (after it got applied)
