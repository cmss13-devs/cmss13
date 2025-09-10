/datum/xeno_strain/shielder
	name = WARRIOR_SHIELDER
	description = "Test."
	flavor_description = "Where there's a sword, there's a shield."
	icon_state_prefix = "Shielder"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/warrior_punch,
		/datum/action/xeno_action/activable/lunge,
		/datum/action/xeno_action/activable/fling,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_plates, //1st
		/datum/action/xeno_action/activable/plates_bash, //2nd
		/datum/action/xeno_action/onclick/tail_swing, //3rd
		/datum/action/xeno_action/activable/plates_slam, //4th
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

/datum/behavior_delegate/warrior_shielder/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(xeno.dir))
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

/datum/action/xeno_action/verb/verb_toggle_plates()
	set category = "Alien"
	set name = "Toggle Encasing Plates"
	set hidden = TRUE
	var/action_name = "Toggle Plates Defense"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/onclick/toggle_plates
	name = "Toggle Encasing Plates"
	action_icon_state = "crest_defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_plates
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 3 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/speed_debuff = 1

/datum/action/xeno_action/onclick/toggle_plates/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	xeno.enclosed_plates = !xeno.enclosed_plates

	if(xeno.enclosed_plates)
		to_chat(xeno, SPAN_XENOWARNING("We raise our plates and form shield."))
		RegisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno.ability_speed_modifier += speed_debuff
		xeno.mob_size = MOB_SIZE_BIG //knockback immune
		button.icon_state = "template_active"
		xeno.front_plates += 10
		xeno.side_plates += 5
		xeno.update_icons()
	else
		to_chat(xeno, SPAN_XENOWARNING("We lower our plates."))
		UnregisterSignal(owner, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(check_directional_armor))
		xeno.ability_speed_modifier -= speed_debuff
		xeno.mob_size = MOB_SIZE_XENO //no longer knockback immune
		button.icon_state = "template"
		xeno.front_plates -= 10
		xeno.side_plates -= 5
		xeno.update_icons()

		if(xeno.plasma_channel_target)
			cancel_plasma_channel(xeno.plasma_channel_target, xeno, TRUE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/toggle_plates/proc/check_directional_armor(mob/living/carbon/xenomorph/xeno, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno.dir & REVERSE_DIR(projectile_direction))
		damagedata["armor"] += xeno.front_plates
	else
		for(var/side_direction in get_perpen_dir(xeno.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += xeno.side_plates
				return

//
// 2nd ability
//

/datum/action/xeno_action/verb/verb_plates_bash()
	set category = "Alien"
	set name = "Plates Bash"
	set hidden = TRUE
	var/action_name = "Plates Bash"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/plates_bash
	name = "Plates Bash"
	action_icon_state = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_plates_bash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

	var/base_damage = 20

/datum/action/xeno_action/activable/plates_bash/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!istype(target_atom, /mob/living/carbon))
		return

	if(!isxeno_human(target_atom) || xeno.can_not_harm(target_atom))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_and_use_plasma_owner())
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD)
		return

	var/distance = get_dist(xeno, carbone)
	var/max_distance = 2
	if(distance > max_distance)
		return

	if(!xeno.enclosed_plates)
		xeno.throw_atom(get_step_towards(carbone, xeno), 2, SPEED_SLOW, xeno, tracking=TRUE)
	if(!xeno.Adjacent(carbone))
		on_cooldown_end()
		return

	carbone.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	var/facing = get_dir(xeno, carbone)

	if(xeno.enclosed_plates)
		xeno.throw_carbon(carbone, facing, 3, SPEED_VERY_FAST, shake_camera = TRUE, immobilize = TRUE)
		carbone.KnockDown(1)
		xeno_cooldown *= 2
	else
		xeno.throw_carbon(carbone, facing, 1, SPEED_SLOW, shake_camera = FALSE, immobilize = FALSE)

	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

	if(carbone.stat != DEAD && (!(carbone.status_flags & XENO_HOST) || !HAS_TRAIT(carbone, TRAIT_NESTED)))
		carbone.apply_armoured_damage(get_xeno_damage_slash(carbone, base_damage), ARMOR_MELEE, BRUTE, "chest", 5)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] dashes at [carbone] with its armored plates!"),
	SPAN_XENOWARNING("We dash at [carbone] with our armored plates!"))

	xeno.face_atom(carbone)
	xeno.animation_attack_on(carbone)
	xeno.flick_attack_overlay(carbone, "punch")
	playsound(carbone,'sound/weapons/alien_claw_block.ogg', 50, 1)

	return ..()

//
// 3rd ability
//

/datum/action/xeno_action/verb/verb_tail_swing()
	set category = "Alien"
	set name = "Tail Swing"
	set hidden = TRUE
	var/action_name = "Tail Swing"
	handle_xeno_macro(src, action_name)

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
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(xeno.enclosed_plates)
		xeno.balloon_alert(xeno, "we need to lower plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] swing its tail in a wide circle!"),
	SPAN_XENOWARNING("We swing our tail in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

	xeno.spin_circle()
	playsound(xeno,'sound/effects/tail_swing.ogg', 25, 1)

	for(var/mob/living/carbon/carbone in orange(swing_range, get_turf(xeno)))
		if(!isxeno_human(carbone) || xeno.can_not_harm(carbone))
			continue
		if(carbone.stat == DEAD)
			continue
		if(HAS_TRAIT(carbone, TRAIT_NESTED))
			continue

		hit_enemy = TRUE
		step_away(carbone, xeno, swing_range, 2)
		xeno.flick_attack_overlay(carbone, "punch")
		carbone.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		carbone.apply_armoured_damage(get_xeno_damage_slash(xeno, 15), ARMOR_MELEE, BRUTE)
		shake_camera(carbone, 2, 1)

		if(carbone.mob_size < MOB_SIZE_BIG)
			carbone.apply_effect(get_xeno_stun_duration(carbone, 1), WEAKEN)

		to_chat(carbone, SPAN_XENOWARNING("You are struck by [xeno]'s tail swing!"))
		playsound(carbone,'sound/weapons/alien_claw_block.ogg', 50, 1)

	for(var/obj/item/explosive/grenade/grenade in orange(swing_range, get_turf(xeno)))
		hit_grenade = TRUE
		var/direction = get_dir(xeno, grenade)
		var/turf/target_destination = get_ranged_target_turf(grenade, direction, 3)
		if(target_destination)
			grenade.throw_atom(get_step_towards(target_destination, grenade), 3, SPEED_FAST, grenade)
			playsound(xeno,'sound/effects/grenade_hit.ogg', 50, 1)

	if(hit_grenade && !hit_enemy)
		xeno_cooldown *= 0.3

	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

	return ..()

//
// 4th ability
//

/datum/action/xeno_action/verb/verb_plates_slam()
	set category = "Alien"
	set name = "Plates Slam"
	set hidden = TRUE
	var/action_name = "Plates Slam"
	handle_xeno_macro(src, action_name)

/datum/action/xeno_action/activable/plates_slam
	name = "Plates Slam"
	action_icon_state = "burrow"
	macro_path = /datum/action/xeno_action/verb/verb_plates_slam
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 20 SECONDS

	var/action_types_to_cd = list(
		/datum/action/xeno_action/activable/plates_bash,
	)
	var/cooldown_duration = 15 SECONDS

/datum/action/xeno_action/activable/plates_slam/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!istype(target_atom, /mob/living/carbon))
		return

	if(!isxeno_human(target_atom) || xeno.can_not_harm(target_atom))
		to_chat(xeno, SPAN_DANGER("We need a target!"))
		return

	if(xeno.plasma_channel_target)
		if(xeno.plasma_channel_target == target_atom)
			cancel_plasma_channel(target_atom)
			return
		else
			to_chat(xeno, SPAN_DANGER("We are already pinning down our target!"))
			return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!check_plasma_owner(30))
		return

	var/mob/living/carbon/carbone = target_atom
	if(carbone.stat == DEAD)
		return

	if(!xeno.enclosed_plates)
		xeno.balloon_alert(xeno, "we need to encase ourself in plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	if(carbone.stat != DEAD && (!(carbone.status_flags & XENO_HOST) || !HAS_TRAIT(carbone, TRAIT_NESTED)))
		if(carbone.body_position != LYING_DOWN)
			to_chat(xeno, SPAN_DANGER("they need to be laying down!"))
			return
		to_chat(xeno, SPAN_DANGER("We are putting plates together and getting ready to pin the target!"))
		to_chat(carbone, SPAN_DANGER("You see plates tightening above you, getting ready to strike!"))
		if(!do_after(xeno, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			to_chat(xeno, SPAN_DANGER("We lost our balance!"))
			to_chat(carbone, SPAN_DANGER("You notice enemy lost their balance!"))
			xeno_cooldown *= 0.5
			check_xeno_cooldown()
			return
		if(!xeno.enclosed_plates)
			xeno.balloon_alert(xeno, "we need to keep our plates in position!", text_color = "#7d32bb", delay = 1 SECONDS)
			return
		if(carbone.body_position != LYING_DOWN) //We are making sure they are down before and after cast.
			to_chat(xeno, SPAN_DANGER("We missed our target!"))
			to_chat(carbone, SPAN_DANGER("You avoid shield and plates, they are smashing ground next to you!"))
			playsound(xeno, 'sound/effects/alien_footstep_charge3.ogg', 25, 0)
			xeno_cooldown *= 0.5
			check_xeno_cooldown()
			return
		if(ishuman(carbone))
			var/mob/living/carbon/human/human = carbone
			INVOKE_ASYNC(carbone, TYPE_PROC_REF(/mob, emote), "scream")
			human.update_xeno_hostile_hud()
		for(var/action_type in action_types_to_cd)
			var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
			if(!istype(xeno_action))
				continue
			xeno_action.apply_cooldown_override(cooldown_duration)
		xeno.emote("roar")
		carbone.anchored = TRUE
		xeno.anchored = TRUE
		ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Plates Slam"))
		start_plasma_channel(carbone)
		to_chat(carbone, SPAN_DANGER("You are slammed to the ground and pinned by armored plates!"))
		xeno.face_atom(carbone)
		xeno.animation_attack_on(carbone)

	else
		to_chat(xeno, SPAN_DANGER("We cannot do that!"))
		xeno_cooldown *= 0.5

	check_xeno_cooldown()

	return ..()

/datum/action/xeno_action/activable/plates_slam/proc/check_xeno_cooldown()
	apply_cooldown()
	xeno_cooldown = initial(xeno_cooldown)

/datum/action/xeno_action/proc/start_plasma_channel(mob/living/carbon/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno) || !istype(target))
		return

	cancel_plasma_channel(target)

	if(target.stat == DEAD || xeno.plasma_stored < 30)
		return

	xeno.plasma_channel_target = target

	ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plasma_channel"))
	ADD_TRAIT(target, TRAIT_FLOORED, TRAIT_SOURCE_ABILITY("plasma_channel"))

	plasma_channel_timer = addtimer(CALLBACK(src, PROC_REF(plasma_channel_tick), target), plasma_channel_tick, TIMER_STOPPABLE)

/datum/action/xeno_action/proc/plasma_channel_tick(mob/living/carbon/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno) || !istype(target) || target.stat == DEAD || xeno.plasma_stored < 30 || xeno.plasma_channel_target != target)
		cancel_plasma_channel(target, xeno, TRUE)
		return

	if(xeno.stat != CONSCIOUS)
		cancel_plasma_channel(target, xeno)
		return

	xeno.plasma_channel_elapsed += plasma_channel_tick

	if(xeno.plasma_channel_elapsed >= xeno.plasma_channel_hardcap)
		end_plasma_channel(target)
		target.anchored = FALSE
		xeno.anchored = FALSE
		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Plates Slam"))
		return

	xeno.plasma_stored -= 30

	plasma_channel_timer = addtimer(CALLBACK(src, PROC_REF(plasma_channel_tick), target), plasma_channel_tick, TIMER_STOPPABLE)

/datum/action/xeno_action/proc/end_plasma_channel(mob/living/carbon/target)
	plasma_channel_timer = null
	remove_plasma_channel_traits(target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(istype(xeno))
		xeno.plasma_channel_elapsed = 0
		xeno.plasma_channel_target = null

/datum/action/xeno_action/proc/cancel_plasma_channel(mob/living/carbon/target, mob/living/carbon/xenomorph/xeno)
	if(!istype(xeno) || !istype(target))
		return

	if(plasma_channel_timer)
		deltimer(plasma_channel_timer)
		plasma_channel_timer = null

	remove_plasma_channel_traits(target)
	xeno.plasma_channel_target = null
	xeno.plasma_channel_elapsed = 0
	target.anchored = FALSE
	xeno.anchored = FALSE
	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Plates Slam"))


/datum/action/xeno_action/proc/remove_plasma_channel_traits(mob/living/carbon/target)
	if(!istype(target))
		return
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("plasma_channel"))
	REMOVE_TRAIT(target, TRAIT_FLOORED, TRAIT_SOURCE_ABILITY("plasma_channel"))

//
// 5th ability
//

/datum/action/xeno_action/verb/verb_reflective_shield()
	set category = "Alien"
	set name = "Reflective Shield"
	set hidden = TRUE
	var/action_name = "Reflective Plates"
	handle_xeno_macro(src, action_name)

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
		/datum/action/xeno_action/activable/plates_slam,
	)
	var/cooldown_duration = 13 SECONDS

/datum/action/xeno_action/onclick/reflective_shield/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		return

	if(!xeno.enclosed_plates)
		xeno.balloon_alert(xeno, "we need to encase ourself in plates!", text_color = "#7d32bb", delay = 1 SECONDS)
		return

	xeno.activate_reflective_shield(10 SECONDS, 80) // A: how long, B: how much % is reflected. (remember to edit reflection chance)

	for(var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
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
	to_chat(src, SPAN_XENOWARNING("We adjust plates and getting ready for incomming attacks!"))
	visible_message(SPAN_XENOWARNING("[src]'s changes stance and adjusting its plates!"))
	src.balloon_alert(src, "we adjust our plates!", text_color = "#326dbb")

	addtimer(CALLBACK(src, PROC_REF(remove_reflective_shield)), duration)

/mob/living/carbon/xenomorph/proc/remove_reflective_shield()
	if(!reflective_shield_active)
		return

	reflective_shield_active = FALSE
	reflective_shield_chance = 0

	src.remove_filter("reflective_shield")
	to_chat(src, SPAN_XENOWARNING("We adjust plates back to their position."))
	src.balloon_alert(src, "we adjust plates back to normal.", text_color = "#326dbb")

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
			return base_chance * 0.8 //only gets 75% value of original number.

	return base_chance * 0.35
	/// numbers are how much % get reflected depending on facing direction.

/obj/projectile/proc/reflect_projectile_at_firer(mob/living/carbon/xenomorph/xeno, obj/projectile/bullet)
	if(!bullet.firer || !isturf(loc))
		return

	var/obj/projectile/new_proj = new(get_turf(xeno), create_cause_data("reflective shield"))
	new_proj.generate_bullet(bullet.ammo)
	new_proj.damage = bullet.damage * 0.5
	new_proj.accuracy = HIT_ACCURACY_TIER_8
	new_proj.projectile_flags |= PROJECTILE_SHRAPNEL

	var/angle = Get_Angle(xeno, bullet.firer) + rand(-45, 45)
	var/atom/target = get_angle_target_turf(xeno, angle, get_dist(xeno, bullet.firer))
	new_proj.fire_at(target, xeno, xeno, 7, speed = bullet.ammo.shell_speed)

	to_chat(xeno, SPAN_XENOWARNING("You reflect [bullet] back at [bullet.firer]!"))

