/datum/xeno_strain/shielder
	name = WARRIOR_SHIELDER
	description = "You give up all of your normal abilities, some damage, speed, and tackle reliability in exchange for plasma, slightly stronger explosive resistance, and directional defenses. You take 50% less damage from wired cades, have a 75% chance to strike enemies behind wired cades, and gain bonus directional armor. Encasing Plates lets you enter a defensive stance that slows your movement but increases directional armor, makes you immune to knockbacks, and allows you to tear openings in walls. Plate Bash dashes up to 3 tiles and strikes a target; while encased, it instead launches the target 3 tiles away and knocks them down, but the cooldown is doubled. Tail Swing knocks down enemies around you, and if used on a grenade, reflects it up to 3 tiles away with a reduced cooldown. Plate Slam has a 5-second windup and then pins a prone enemy, draining 20 plasma per second to extend knockdown up to 12 seconds; being interrupted during windup causes a heavy cooldown penalty. Reflective Shield locks your plates into a stance for 13 seconds, reflecting bullets based on your facing: high from the front, medium from the sides, and low from behind."
	flavor_description = "Where there's a sword, there's a shield."
	icon_state_prefix = "Shielder"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_plates, //1st
		/datum/action/xeno_action/activable/plate_bash, //2nd
		/datum/action/xeno_action/onclick/tail_swing, //3rd
		/datum/action/xeno_action/activable/plate_slam, //4th
		/datum/action/xeno_action/onclick/reflective_shield, //5th
	)

	behavior_delegate_type = /datum/behavior_delegate/warrior_shielder

/datum/xeno_strain/shielder/apply_strain(mob/living/carbon/xenomorph/warrior/warrior)
	warrior.damage_modifier -= XENO_DAMAGE_MOD_SHIELDER
	warrior.explosivearmor_modifier += XENO_EXPLOSIVE_ARMOR_TIER_1
	warrior.add_plasma += XENO_PLASMA_TIER_2
	warrior.speed += XENO_SPEED_TIER_1
	warrior.tackle_min_modifier += 2
	warrior.tackle_max_modifier += 1

	warrior.recalculate_everything()

//
// Passive benefits
//

/datum/behavior_delegate/warrior_shielder
	name = "Shielder Warrior Behavior Delegate"

	var/frontal_armor = 10
	var/side_armor = 5

/datum/behavior_delegate/warrior_shielder/append_to_stat()
	. = list()
	. += "Front Armor: +[frontal_armor + bound_xeno.front_plates]"
	. += "Side Armor: +[side_armor + bound_xeno.side_plates]"

/datum/behavior_delegate/warrior_shielder/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(apply_directional_armor))

/datum/behavior_delegate/warrior_shielder/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno_player, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno_player.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(xeno_player.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += side_armor
				return

/datum/behavior_delegate/warrior_shielder/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.enclosed_plates && bound_xeno.health > 0)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Warrior Shield"
		return TRUE

//
// 1st ability
//

/datum/action/xeno_action/onclick/toggle_plates
	name = "Toggle Encasing Plates"
	action_icon_state = "crest_defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_plates
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 3 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/speed_debuff = 1

/datum/action/xeno_action/onclick/toggle_plates/use_ability()
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(!istype(xeno_player))
		return

	if(!xeno_player.check_state())
		return

	if(!action_cooldown_check())
		return

	xeno_player.enclosed_plates = !xeno_player.enclosed_plates

	if(xeno_player.enclosed_plates)
		to_chat(xeno_player, SPAN_XENOWARNING("We raise our plate and form a shield."))
		RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno_player.ability_speed_modifier += speed_debuff
		xeno_player.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"
		xeno_player.front_plates += 10
		xeno_player.side_plates += 5
		xeno_player.update_icons()
	else
		to_chat(xeno_player, SPAN_XENOWARNING("We lower our plate."))
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno_player.ability_speed_modifier -= speed_debuff
		xeno_player.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template"
		xeno_player.front_plates -= 10
		xeno_player.side_plates -= 5
		xeno_player.update_icons()

		if(xeno_player.plasma_channel_target)
			cancel_plasma_channel(xeno_player.plasma_channel_target, xeno_player, TRUE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/toggle_plates/proc/check_directional_armor(mob/living/carbon/xenomorph/xeno_player, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno_player.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += xeno_player.front_plates
	else
		for(var/side_direction in get_perpen_dir(xeno_player.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += xeno_player.side_plates
				return

//
// 2nd ability
//

/datum/action/xeno_action/activable/plate_bash
	name = "Plate Bash"
	action_icon_state = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_plate_bash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

	var/base_damage = 20

/datum/action/xeno_action/activable/plate_bash/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!iscarbon(target_atom))
		return

	if(!isxeno_human(target_atom) || xeno_player.can_not_harm(target_atom))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	var/mob/living/carbon/carbon_target = target_atom
	if(carbon_target.stat == DEAD)
		return

	var/distance = get_dist(xeno_player, carbon_target)
	var/max_distance = 2
	if(distance > max_distance)
		return

	if(!xeno_player.enclosed_plates)
		xeno_player.throw_atom(get_step_towards(carbon_target, xeno_player), 2, SPEED_SLOW, xeno_player, tracking=TRUE)
	if(!xeno_player.Adjacent(carbon_target))
		on_cooldown_end()
		return

	carbon_target.last_damage_data = create_cause_data(xeno_player.caste_type, xeno_player)
	var/facing = get_dir(xeno_player, carbon_target)

	if(xeno_player.enclosed_plates)
		xeno_player.throw_carbon(carbon_target, facing, 3, SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)
		carbon_target.KnockDown(1)
		xeno_cooldown *= 2
	else
		xeno_player.throw_carbon(carbon_target, facing, 1, SPEED_SLOW, shake_camera = FALSE, immobilize = FALSE)

	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

	if(carbon_target.stat != DEAD && (!(carbon_target.status_flags & XENO_HOST) || !HAS_TRAIT(carbon_target, TRAIT_NESTED)))
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(carbon_target, base_damage), ARMOR_MELEE, BRUTE, "chest", 5)

	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] dashes at [carbon_target] with its armored plate!"),
	SPAN_XENOWARNING("We dash at [carbon_target] with our armored plate!"))

	xeno_player.face_atom(carbon_target)
	xeno_player.animation_attack_on(carbon_target)
	xeno_player.flick_attack_overlay(carbon_target, "punch")
	playsound(carbon_target,'sound/weapons/alien_claw_block.ogg', 50, 1)

	return ..()

//
// 3rd ability
//

/datum/action/xeno_action/onclick/tail_swing
	name = "Tail Swing"
	action_icon_state = "tail_sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_swing
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 20
	xeno_cooldown = 11 SECONDS

	var/swing_range = 1
	var/hit_enemy = FALSE
	var/hit_grenade = FALSE

/datum/action/xeno_action/onclick/tail_swing/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	if(!action_cooldown_check())
		return

	if(xeno_player.enclosed_plates)
		xeno_player.balloon_alert(xeno_player, "we need to lower our plate!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno_player.visible_message(SPAN_XENOWARNING("[xeno_player] swing its tail in a wide circle!"),
	SPAN_XENOWARNING("We swing our tail in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

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
		var/turf/target_destination = get_ranged_target_turf(grenade, direction, 3)
		if(target_destination)
			grenade.throw_atom(get_step_towards(target_destination, grenade), 3, SPEED_FAST, grenade)
			playsound(xeno_player,'sound/effects/grenade_hit.ogg', 50, 1)

	if(hit_grenade && !hit_enemy)
		xeno_cooldown *= 0.3

	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

	return ..()

//
// 4th ability
//

/datum/action/xeno_action/activable/plate_slam
	name = "Plate Slam"
	action_icon_state = "burrow"
	macro_path = /datum/action/xeno_action/verb/verb_plate_slam
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 20 SECONDS

	var/action_types_to_cd = list(
		/datum/action/xeno_action/activable/plate_bash,
	)
	var/cooldown_duration = 15 SECONDS

/datum/action/xeno_action/activable/plate_slam/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_player = owner

	if(!iscarbon(target_atom))
		return

	if(!isxeno_human(target_atom) || xeno_player.can_not_harm(target_atom))
		to_chat(xeno_player, SPAN_DANGER("We need a target!"))
		return

	if(xeno_player.plasma_channel_target)
		if(xeno_player.plasma_channel_target == target_atom)
			cancel_plasma_channel(target_atom)
			return
		else
			to_chat(xeno_player, SPAN_DANGER("We are already pinning down our target!"))
			return

	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	if(!action_cooldown_check())
		return

	if(!check_plasma_owner(30))
		return

	var/mob/living/carbon/carbon_target = target_atom
	if(carbon_target.stat == DEAD)
		return

	if(!xeno_player.enclosed_plates)
		xeno_player.balloon_alert(xeno_player, "we need to encase ourself in plate!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	if(carbon_target.stat != DEAD && (!(carbon_target.status_flags & XENO_HOST) || !HAS_TRAIT(carbon_target, TRAIT_NESTED)))
		if(carbon_target.body_position != LYING_DOWN)
			to_chat(xeno_player, SPAN_DANGER("They need to be lying down!"))
			return
		to_chat(xeno_player, SPAN_DANGER("We press our plate together, preparing to pin the target!"))
		to_chat(carbon_target, SPAN_DANGER("You see plate closing in above you, ready to strike!"))
		if(!do_after(xeno_player, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(xeno_player, SPAN_DANGER("We lose our balance!"))
			to_chat(carbon_target, SPAN_DANGER("You notice the enemy lose their balance!"))
			xeno_cooldown *= 0.5
			check_xeno_cooldown()
			return
		if(!xeno_player.enclosed_plates)
			xeno_player.balloon_alert(xeno_player, "we need to keep our plates in position!", text_color = "#7d32bb", delay = 1 SECONDS)
			return
		if(carbon_target.body_position != LYING_DOWN) //We are making sure they are down before and after cast.
			to_chat(xeno_player, SPAN_DANGER("We miss our target!"))
			to_chat(carbon_target, SPAN_DANGER("You slip past the shield of plate as they smash into the ground beside you!"))
			playsound(xeno_player, 'sound/effects/alien_footstep_charge3.ogg', 25, 0)
			xeno_cooldown *= 0.5
			check_xeno_cooldown()
			return
		if(ishuman(carbon_target))
			var/mob/living/carbon/human/human = carbon_target
			INVOKE_ASYNC(carbon_target, TYPE_PROC_REF(/mob, emote), "scream")
			human.update_xeno_hostile_hud()
		for(var/action_type in action_types_to_cd)
			var/datum/action/xeno_action/xeno_action = get_action(xeno_player, action_type)
			if(!istype(xeno_action))
				continue
			xeno_action.apply_cooldown_override(cooldown_duration)
		xeno_player.emote("roar")
		carbon_target.anchored = TRUE
		xeno_player.anchored = TRUE
		ADD_TRAIT(xeno_player, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Plate Slam"))
		start_plasma_channel(carbon_target)
		to_chat(carbon_target, SPAN_DANGER("You are slammed to the ground and pinned by armored plate!"))
		xeno_player.face_atom(carbon_target)
		xeno_player.animation_attack_on(carbon_target)

	else
		to_chat(xeno_player, SPAN_DANGER("We cannot do that!"))
		xeno_cooldown *= 0.5

	check_xeno_cooldown()

	return ..()

/datum/action/xeno_action/activable/plate_slam/proc/check_xeno_cooldown()
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

/datum/action/xeno_action/proc/start_plasma_channel(mob/living/carbon/target)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(!istype(xeno_player) || !istype(target))
		return

	cancel_plasma_channel(target)

	if(target.stat == DEAD || xeno_player.plasma_stored < 30)
		return

	xeno_player.plasma_channel_target = target

	ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plasma_channel"))
	ADD_TRAIT(target, TRAIT_FLOORED, TRAIT_SOURCE_ABILITY("plasma_channel"))

	plasma_channel_timer = addtimer(CALLBACK(src, PROC_REF(plasma_channel_tick), target), plasma_channel_tick, TIMER_STOPPABLE)

/datum/action/xeno_action/proc/plasma_channel_tick(mob/living/carbon/target)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(!istype(xeno_player) || !istype(target) || target.stat == DEAD || xeno_player.plasma_stored < 30 || xeno_player.plasma_channel_target != target)
		cancel_plasma_channel(target, xeno_player, TRUE)
		return

	if(xeno_player.stat != CONSCIOUS)
		cancel_plasma_channel(target, xeno_player)
		return

	xeno_player.plasma_channel_elapsed += plasma_channel_tick

	if(xeno_player.plasma_channel_elapsed >= xeno_player.plasma_channel_hardcap)
		end_plasma_channel(target)
		target.anchored = FALSE
		xeno_player.anchored = FALSE
		REMOVE_TRAIT(xeno_player, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Plate Slam"))
		return

	xeno_player.plasma_stored -= 30

	plasma_channel_timer = addtimer(CALLBACK(src, PROC_REF(plasma_channel_tick), target), plasma_channel_tick, TIMER_STOPPABLE)

/datum/action/xeno_action/proc/end_plasma_channel(mob/living/carbon/target)
	plasma_channel_timer = null
	remove_plasma_channel_traits(target)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	if(istype(xeno_player))
		xeno_player.plasma_channel_elapsed = 0
		xeno_player.plasma_channel_target = null

/datum/action/xeno_action/proc/cancel_plasma_channel(mob/living/carbon/target, mob/living/carbon/xenomorph/xeno_player)
	if(!istype(xeno_player) || !istype(target))
		return

	if(plasma_channel_timer)
		deltimer(plasma_channel_timer)
		plasma_channel_timer = null

	remove_plasma_channel_traits(target)
	xeno_player.plasma_channel_target = null
	xeno_player.plasma_channel_elapsed = 0
	target.anchored = FALSE
	xeno_player.anchored = FALSE
	REMOVE_TRAIT(xeno_player, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Plate Slam"))


/datum/action/xeno_action/proc/remove_plasma_channel_traits(mob/living/carbon/target)
	if(!istype(target))
		return
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plasma_channel"))
	REMOVE_TRAIT(target, TRAIT_FLOORED, TRAIT_SOURCE_ABILITY("plasma_channel"))

//
// 5th ability
//

/datum/action/xeno_action/onclick/reflective_shield
	name = "Reflective Shield"
	action_icon_state = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_reflective_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5
	plasma_cost = 100
	xeno_cooldown = 30 SECONDS

	var/action_types_to_cd = list(
		/datum/action/xeno_action/onclick/toggle_plates,
		/datum/action/xeno_action/activable/plate_slam,
	)
	var/cooldown_duration = 13 SECONDS

/datum/action/xeno_action/onclick/reflective_shield/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_player = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno_player)

	if(!action_cooldown_check())
		return

	if(!xeno_player.enclosed_plates)
		xeno_player.balloon_alert(xeno_player, "we need to encase ourself in plate!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno_player.activate_reflective_shield(10 SECONDS, 80) // A: how long, B: how much % is reflected. (remember to edit reflection chance)

	for(var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/xeno_action = get_action(xeno_player, action_type)
		if(!istype(xeno_action))
			continue
		xeno_action.apply_cooldown_override(cooldown_duration)

	apply_cooldown()

	return ..()

/mob/living/carbon/xenomorph/proc/activate_reflective_shield(duration, chance)
	if(reflective_shield_active)
		return

	reflective_shield_active = TRUE
	reflective_shield_chance = chance

	src.add_filter("reflective_shield", 1, list("type" = "outline", "color" = "#2b8080", "size" = 1))
	to_chat(src, SPAN_XENOWARNING("We adjust plate and stance to get ready for incomming attacks!"))
	visible_message(SPAN_XENOWARNING("[src]'s changes stance and adjusting its plate!"))

	addtimer(CALLBACK(src, PROC_REF(remove_reflective_shield)), duration)

/mob/living/carbon/xenomorph/proc/remove_reflective_shield()
	if(!reflective_shield_active)
		return

	reflective_shield_active = FALSE
	reflective_shield_chance = 0

	src.remove_filter("reflective_shield")
	to_chat(src, SPAN_XENOWARNING("We adjust our plate and stance back to normal."))

/mob/living/carbon/xenomorph/proc/get_reflection_chance(obj/projectile/bullet)
	if(!reflective_shield_active)
		return 0

	var/base_chance = reflective_shield_chance
	var/projectile_dir = 0

	if(!bullet.firer)
		return 0

	projectile_dir = get_dir(bullet.firer.loc, src)

	if(projectile_dir == REVERSE_DIR(src.dir))
		return base_chance

	for(var/side_dir in get_perpen_dir(src.dir))
		if(projectile_dir == side_dir)
			return base_chance * 0.8 //only gets 80% value of original number.

	return base_chance * 0.35
	/// numbers are how much % get reflected depending on facing direction.

/obj/projectile/proc/reflect_projectile_at_firer(mob/living/carbon/xenomorph/xeno_player, obj/projectile/bullet)
	if(!bullet.firer || !isturf(loc))
		return

	var/obj/projectile/new_proj = new(get_turf(xeno_player), create_cause_data("reflective shield"))
	new_proj.generate_bullet(bullet.ammo)
	new_proj.damage = bullet.damage * 0.5
	new_proj.accuracy = HIT_ACCURACY_TIER_8
	new_proj.projectile_flags |= PROJECTILE_SHRAPNEL

	var/angle = Get_Angle(xeno_player, bullet.firer) + rand(-45, 45)
	var/atom/target = get_angle_target_turf(xeno_player, angle, get_dist(xeno_player, bullet.firer))
	new_proj.fire_at(target, xeno_player, xeno_player, 7, speed = bullet.ammo.shell_speed)

	to_chat(xeno_player, SPAN_XENOWARNING("We reflect [bullet] back at [bullet.firer]!"))

