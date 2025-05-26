/datum/xeno_strain/vampire
	name = LURKER_VAMPIRE
	description = "You lose all of your abilities and you forefeit a chunk of your health and damage in exchange for a large amount of armor, a little bit of movement speed, increased attack speed, and brand new abilities that make you an assassin. Rush on your opponent to disorient them and Flurry to unleash a forward cleave that can hit and slow three talls and heal you for every tall you hit. Use your special AoE Tail Jab to knock talls away, doing more damage with direct hits and even more damage and a stun if they smack into walls. Finally, execute unconscious talls with a headbite to heal your wounds."
	flavor_description = "Show no mercy! Slaughter them all!"
	icon_state_prefix = "Vampire"

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/activable/tail_stab,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/pounce/rush,
		/datum/action/xeno_action/activable/flurry,
		/datum/action/xeno_action/activable/tail_jab,
		/datum/action/xeno_action/activable/headbite,
	)

/datum/xeno_strain/vampire/apply_strain(mob/living/carbon/xenomorph/lurker/lurker)
	lurker.plasmapool_modifier = 0
	lurker.health_modifier -= XENO_HEALTH_MOD_MED
	lurker.speed_modifier += XENO_SPEED_FASTMOD_TIER_1
	lurker.armor_modifier += XENO_ARMOR_MOD_LARGE
	lurker.damage_modifier -= XENO_DAMAGE_MOD_VERY_SMALL
	lurker.attack_speed_modifier -= 2

	var/datum/mob_hud/execute_hud = GLOB.huds[MOB_HUD_EXECUTE]
	execute_hud.add_hud_to(lurker, lurker)
	lurker.execute_hud = TRUE

	lurker.recalculate_everything()

/datum/action/xeno_action/activable/pounce/rush/additional_effects(mob/living/living_target) //pounce effects
	var/mob/living/carbon/target = living_target
	var/mob/living/carbon/xenomorph/xeno = owner
	target.sway_jitter(times = 2)
	xeno.animation_attack_on(target)
	xeno.flick_attack_overlay(target, "slash")   //fake slash to prevent disarm abuse
	target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	target.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest")
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh3.ogg', 30, TRUE)
	shake_camera(target, 2, 1)

/datum/action/xeno_action/activable/flurry/use_ability(atom/targeted_atom) //flurry ability
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return
	if (!xeno.check_state())
		return
	if (!action_cooldown_check())
		return

	xeno.visible_message(SPAN_DANGER("[xeno] drags its claws in a wide area in front of it!"),
	SPAN_XENOWARNING("We unleash a barrage of slashes!"))
	playsound(xeno, 'sound/effects/alien_tail_swipe2.ogg', 30)
	apply_cooldown()

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 1x3 area of turfs
	var/turf/root = get_turf(xeno)
	var/facing = get_dir(xeno, targeted_atom)
	var/turf/infront = get_step(root, facing)
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))

	temp_turfs += infront
	if (!(!infront || infront.density))
		temp_turfs += infront_left
	if (!(!infront || infront.density))
		temp_turfs += infront_right

	for (var/turf/current_turfs in temp_turfs)

		if (!istype(current_turfs))
			continue

		if (current_turfs.density)
			continue

		target_turfs += current_turfs
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(current_turfs, 2)

	for (var/turf/current_turfs in target_turfs)
		for (var/mob/living/carbon/target in current_turfs)
			if (target.stat == DEAD)
				continue

			if (!isxeno_human(target) || xeno.can_not_harm(target))
				continue

			if (HAS_TRAIT(target, TRAIT_NESTED))
				continue

			xeno.visible_message(SPAN_DANGER("[xeno] slashes [target]!"),
			SPAN_XENOWARNING("We slash [target] multiple times!"))
			xeno.flick_attack_overlay(target, "slash")
			target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
			log_attack("[key_name(xeno)] attacked [key_name(target)] with Flurry")
			target.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, rand_zone())
			playsound(get_turf(target), 'sound/weapons/alien_claw_flesh4.ogg', 30, TRUE)
			if(!xeno.on_fire)
				xeno.flick_heal_overlay(1 SECONDS, "#00B800")
				xeno.gain_health(30)
			xeno.animation_attack_on(target)

	xeno.emote("roar")
	return ..()

/datum/action/xeno_action/activable/tail_jab/use_ability(atom/targeted_atom)

	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/hit_target = targeted_atom
	var/distance = get_dist(xeno, hit_target)

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(distance > 2)
		return

	var/list/turf/path = get_line(xeno, targeted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		var/atom/barrier = path_turf.handle_barriers(A = xeno , pass_flags = (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(istype(current_structure, /obj/structure/window/framed))
				var/obj/structure/window/framed/target_window = current_structure
				if(target_window.unslashable)
					return
				playsound(get_turf(target_window),'sound/effects/glassbreak3.ogg', 30, TRUE)
				target_window.shatter_window(TRUE)
				xeno.visible_message(SPAN_XENOWARNING("\The [xeno] strikes the window with their tail!"), SPAN_XENOWARNING("We strike the window with our tail!"))
				apply_cooldown(cooldown_modifier = 0.5)
				return
			if(current_structure.density && !current_structure.throwpass)
				to_chat(xeno, SPAN_WARNING("There's something blocking us from striking!"))
				return
	// find a target in the target turf
	if(!iscarbon(targeted_atom) || hit_target.stat == DEAD)
		for(var/mob/living/carbon/carbonara in get_turf(targeted_atom))
			hit_target = carbonara
			if(!xeno.can_not_harm(hit_target) && hit_target.stat != DEAD)
				break

	if(iscarbon(hit_target) && !xeno.can_not_harm(hit_target) && hit_target.stat != DEAD)
		if(targeted_atom == hit_target) //reward for a direct hit
			to_chat(xeno, SPAN_XENOHIGHDANGER("We attack [hit_target], with our tail, piercing their body!"))
			hit_target.apply_armoured_damage(15, ARMOR_MELEE, BRUTE, "chest")
		else
			to_chat(xeno, SPAN_XENODANGER("We attack [hit_target], slashing them with our tail!"))
	else
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.2)
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		return

	// FX
	var/stab_direction

	stab_direction = turn(get_dir(xeno, targeted_atom), 180)
	playsound(hit_target,'sound/weapons/alien_tail_attack.ogg', 50, TRUE)

	var/direction = Get_Compass_Dir(xeno, targeted_atom) //More precise than get_dir.

	if(!step(hit_target, direction))
		playsound(hit_target.loc, "punch", 25, 1)
		hit_target.visible_message(SPAN_DANGER("[hit_target] slams into an obstacle!"),
		isxeno(hit_target) ? SPAN_XENODANGER("We slam into an obstacle!") : SPAN_HIGHDANGER("You slam into an obstacle!"), null, 4, CHAT_TYPE_TAKING_HIT)
		hit_target.apply_damage(MELEE_FORCE_TIER_2)
		if (hit_target.mob_size < MOB_SIZE_BIG)
			hit_target.KnockDown(0.5)
		else
			hit_target.Slow(0.5)
	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = xeno.dir

	xeno.setDir(stab_direction)
	xeno.flick_attack_overlay(hit_target, "tail")
	xeno.animation_attack_on(hit_target)

	var/new_dir = xeno.dir
	addtimer(CALLBACK(src, PROC_REF(reset_direction), xeno, last_dir, new_dir), 0.5 SECONDS)

	hit_target.apply_armoured_damage(get_xeno_damage_slash(hit_target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest")
	hit_target.Slow(0.5)

	hit_target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	log_attack("[key_name(xeno)] attacked [key_name(hit_target)] with Tail Jab")

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/tail_jab/proc/reset_direction(mob/living/carbon/xenomorph/xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == xeno.dir)
		xeno.setDir(last_dir)

/datum/action/xeno_action/activable/headbite/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!iscarbon(target_atom))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(xeno.can_not_harm(target_carbon))
		return

	if(!(HAS_TRAIT(target_carbon, TRAIT_KNOCKEDOUT) || target_carbon.stat == UNCONSCIOUS)) //called knocked out because for some reason .stat seems to have a delay .
		to_chat(xeno, SPAN_XENOHIGHDANGER("We can only headbite an unconscious, adjacent target!"))
		return

	if(!xeno.Adjacent(target_carbon))
		to_chat(xeno, SPAN_XENOHIGHDANGER("We can only headbite an unconscious, adjacent target!"))
		return

	if(xeno.stat == UNCONSCIOUS)
		return

	if(xeno.stat == DEAD)
		return

	if(xeno.action_busy)
		return

	if(target_carbon.status_flags & XENO_HOST)
		for(var/obj/item/alien_embryo/embryo in target_carbon)
			if(HIVE_ALLIED_TO_HIVE(xeno.hivenumber, embryo.hivenumber))
				to_chat(xeno, SPAN_WARNING("We should not harm this host! It has a sister inside."))
				return

	xeno.visible_message(SPAN_DANGER("[xeno] grabs [target_carbon]’s head aggressively."),
	SPAN_XENOWARNING("We grab [target_carbon]’s head aggressively."))

	if(!do_after(xeno, 0.8 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 2)) // would be 0.75 but that doesn't really work with numticks
		return

	// To make sure that the headbite does nothing if the target is moved away.
	if(!xeno.Adjacent(target_carbon))
		to_chat(xeno, SPAN_XENOHIGHDANGER("We missed! Our target was moved away before we could finish headbiting them!"))
		return

	if(target_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENODANGER("They died before you could finish headbiting them! Be more careful next time!"))
		return

	to_chat(xeno, SPAN_XENOHIGHDANGER("We pierce [target_carbon]’s head with our inner jaw!"))
	playsound(target_carbon,'sound/weapons/alien_bite2.ogg', 50, TRUE)
	xeno.visible_message(SPAN_DANGER("[xeno] pierces [target_carbon]’s head with its inner jaw!"))
	xeno.flick_attack_overlay(target_carbon, "headbite")
	xeno.animation_attack_on(target_carbon, pixel_offset = 16)
	target_carbon.apply_armoured_damage(60, ARMOR_MELEE, BRUTE, "head", 5) //DIE
	target_carbon.death(create_cause_data("headbite execution", xeno), FALSE)
	if(!xeno.on_fire)
		xeno.gain_health(150)
		xeno.xeno_jitter(1 SECONDS)
		xeno.flick_heal_overlay(3 SECONDS, "#00B800")
	xeno.emote("roar")
	log_attack("[key_name(xeno)] was executed by [key_name(target_carbon)] with a headbite!")
	apply_cooldown()
	return ..()
