/datum/xeno_strain/vampire
	name = LURKER_VAMPIRE
	description = "You lose all of your abilities and you forfeit a chunk of your health and damage in exchange for a large amount of armor, a little bit of movement speed, increased attack speed, and brand new abilities that make you an assassin. Rush on your opponent to disorient them and Flurry to unleash a forward cleave that can hit and slow three talls and heal you for every tall you hit. Use your special AoE Tail Jab to knock talls away, doing more damage with direct hits and even more damage and a stun if they smack into walls. Finally, execute unconscious talls with a headbite to heal your wounds."
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

	behavior_delegate_type = /datum/behavior_delegate/vampire
	// Vampire Lurker Bloodlust Stages

	#define VAMPIRE_EMPOWER_0 	0		// 0-2
	#define VAMPIRE_EMPOWER_1 	3		// 3-5
	#define VAMPIRE_EMPOWER_2 	6		// 6-8
	#define VAMPIRE_EMPOWER_MAX 9	// 9, max bloodlust
	#define VAMPIRE_HEADBITES_MAX 6 // how many headbites you can build, where each bite increases the minimum bloodlust by 1

/datum/xeno_strain/vampire/apply_strain(mob/living/carbon/xenomorph/lurker/lurker)
	lurker.plasmapool_modifier = 0
	lurker.health_modifier -= XENO_HEALTH_MOD_MED
	lurker.speed_modifier += XENO_SPEED_FASTMOD_TIER_1
	lurker.armor_modifier += XENO_ARMOR_MOD_LARGE
	lurker.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	lurker.attack_speed_modifier -= 2
	lurker.received_phero_caps["recovery"] = 1.5 //Prevents benefits from recovery pheromones entirely.
	lurker.healer_DNH = TRUE //Prevents healing from healer-strain drones and hurts fruit effectiveness.

	var/datum/mob_hud/execute_hud = GLOB.huds[MOB_HUD_EXECUTE]
	execute_hud.add_hud_to(lurker, lurker)
	lurker.execute_hud = TRUE

	lurker.recalculate_everything()

// Mutator delegate for Vampire Lurker
/datum/behavior_delegate/vampire
	name = "Vampire Lurker Behavior Delegate"

	// Bloodlust Config
	var/max_bloodlust = VAMPIRE_EMPOWER_MAX //separated in 3 stages, 3 per stage, increased up to 2 stages for every 2 hidebites
	var/bloodlust_decay_time = 15 // How many deciseconds between slashes until we start to decay bloodlust
	var/attack_delay_buff_per_stage = 0.4
	var/movement_speed_buff_per_stage = 0.03
	var/bloodlust_flurry_mod = 1
	var/bloodlust_headbite_mod = 1
	var/bloodlust_stun_mod = 1

	// Eviscerate config
	var/bloodlust_lock_duration = 5 SECONDS   // 5 seconds of max bloodlust
	var/bloodlust_cooldown_duration = 10 SECONDS  // 10 seconds of no bloodlust

	// State for tracking bloodlust
	var/bloodlust = 0
	var/minbloodlust = 0 //stage set by acquiring headbite kills
	var/last_slash_time = 0
	var/headbites_max = VAMPIRE_HEADBITES_MAX

	// Eviscerate state
	var/bloodlust_lock_start_time = 0
	var/bloodlust_cooldown_start_time = 0

/datum/action/xeno_action/activable/pounce/rush/additional_effects(mob/living/living_target) //pounce effects

	var/mob/living/carbon/target = living_target
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/vampire/behavior = xeno.behavior_delegate
	target.sway_jitter(times = 3)
	target.Slow(0.5 * behavior.bloodlust_stun_mod)
	xeno.animation_attack_on(target)
	xeno.flick_attack_overlay(target, "slash")   //fake slash to prevent disarm abuse
	target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	target.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest")
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh3.ogg', 30, TRUE)
	shake_camera(target, 3, 2)

	if(behavior.bloodlust == VAMPIRE_EMPOWER_MAX)
		knockdown = TRUE //runner pounce on max stacks
	else
		knockdown = FALSE


/datum/action/xeno_action/activable/flurry/use_ability(atom/targeted_atom) //flurry ability
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return
	if(!xeno.check_state())
		return
	if(!action_cooldown_check())
		return

	xeno.visible_message(SPAN_DANGER("[xeno] drags its claws in a wide area in front of it!"),
	SPAN_XENOWARNING("We unleash a barrage of slashes!"))
	playsound(xeno, 'sound/effects/alien_tail_swipe2.ogg', 30)
	apply_cooldown()

	var/datum/behavior_delegate/vampire/behavior = xeno.behavior_delegate

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
	if(!(!infront || infront.density))
		temp_turfs += infront_left
	if(!(!infront || infront.density))
		temp_turfs += infront_right

	for(var/turf/current_turfs in temp_turfs)

		if(!istype(current_turfs))
			continue

		if(current_turfs.density)
			continue

		target_turfs += current_turfs
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(current_turfs, 2)

	for(var/turf/current_turfs in target_turfs)
		for(var/mob/living/carbon/target in current_turfs)
			if(target.stat == DEAD)
				continue

			if(!isxeno_human(target) || xeno.can_not_harm(target))
				continue

			if(HAS_TRAIT(target, TRAIT_NESTED))
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
				xeno.gain_health(30 * behavior.bloodlust_flurry_mod) //function of stage/bloodlust
			xeno.animation_attack_on(target)

	xeno.emote("roar")
	return ..()

/datum/action/xeno_action/activable/tail_jab/use_ability(atom/targeted_atom)

	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/hit_target = targeted_atom
	var/distance = get_dist(xeno, hit_target)
	var/datum/behavior_delegate/vampire/behavior = xeno.behavior_delegate

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
		var/atom/barrier = path_turf.handle_barriers(attacker = xeno , pass_flags = (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
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
		apply_cooldown(cooldown_modifier = 0)
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
		if(hit_target.mob_size < MOB_SIZE_BIG)
			hit_target.KnockDown(0.5 * behavior.bloodlust_stun_mod)
		else
			hit_target.Slow(0.5 * behavior.bloodlust_stun_mod)
	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = xeno.dir

	xeno.setDir(stab_direction)
	xeno.flick_attack_overlay(hit_target, "tail")
	xeno.animation_attack_on(hit_target)

	var/new_dir = xeno.dir
	addtimer(CALLBACK(src, PROC_REF(reset_direction), xeno, last_dir, new_dir), 0.5 SECONDS)

	hit_target.apply_armoured_damage(get_xeno_damage_slash(hit_target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest")
	hit_target.Slow(1.5)

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
	var/datum/behavior_delegate/vampire/behavior = xeno.behavior_delegate

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
	xeno.armor_deflection_buff += 20 //damage reduction for the duration of headbite's doafter
	xeno.visible_message(SPAN_DANGER("[xeno] grabs [target_carbon]’s head aggressively- rooting itself into place."),
	SPAN_XENOWARNING("We grab [target_carbon]’s head aggressively, channeling our strength into defending our form. Then-"))

	if(!do_after(xeno, 0.8 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 2)) // would be 0.75 but that doesn't really work with numticks
		xeno.armor_deflection_buff -= 20
		return

	// To make sure that the headbite does nothing if the target is moved away.
	if(!xeno.Adjacent(target_carbon))
		to_chat(xeno, SPAN_XENOHIGHDANGER("We missed! Our target was moved away before we could finish headbiting them!"))
		xeno.armor_deflection_buff -= 20
		return

	to_chat(xeno, SPAN_XENOHIGHDANGER("We pierce [target_carbon]’s head with our inner jaw!"))
	playsound(target_carbon,'sound/weapons/alien_bite2.ogg', 50, TRUE)
	xeno.visible_message(SPAN_DANGER("[xeno] pierces [target_carbon]’s head with its inner jaw!"))
	xeno.flick_attack_overlay(target_carbon, "headbite")
	xeno.animation_attack_on(target_carbon, pixel_offset = 16)
	target_carbon.apply_armoured_damage(60, ARMOR_MELEE, BRUTE, "head", 5) //DIE
	if(behavior.minbloodlust <= (VAMPIRE_EMPOWER_2 - 1))
		behavior.minbloodlust += 1 //increase min bloodlust once per headbite, up until stage 2
	if(behavior.bloodlust != VAMPIRE_EMPOWER_MAX)
		behavior.bloodlust += 1 //increase the min too, helps beat edge cases where min increases above bloodlust
	target_carbon.death(create_cause_data("headbite execution", xeno), FALSE)
	if(!xeno.on_fire)
		xeno.gain_health(180 * behavior.bloodlust_headbite_mod)
		xeno.xeno_jitter(1 SECONDS)
		xeno.flick_heal_overlay(3 SECONDS, "#00B800")
	xeno.emote("roar")
	log_attack("[key_name(target_carbon)] was executed by [key_name(xeno)] with a headbite!")
	apply_cooldown()
	xeno.armor_deflection_buff -= 20  //final check to make sure the temporary deflection is gone
	return ..()


/datum/behavior_delegate/vampire/melee_attack_additional_effects_self()
	..()

	if(bloodlust != max_bloodlust && !bloodlust_cooldown_start_time)
		bloodlust = bloodlust + 1
		stage_up()
		bound_xeno.recalculate_armor()
		bound_xeno.recalculate_speed()
		last_slash_time = world.time

		if(bloodlust == max_bloodlust)
			bloodlust_lock()
			to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We feel a euphoric rush as we reach max bloodlust! We are LOCKED at max bloodlust!"))

/datum/behavior_delegate/vampire/append_to_stat()
	. = list()
	. += "Bloodlust: [bloodlust]/[max_bloodlust]"
	. += "Headbites: [minbloodlust]/[headbites_max]"

/datum/behavior_delegate/vampire/on_life()
	// Compute our current bloodlust (demerit if necessary)
	if(((last_slash_time + bloodlust_decay_time) < world.time) && !(bloodlust <= 0))
		decrement_bloodlust()

// Handles internal state from decrementing bloodlust
/datum/behavior_delegate/vampire/proc/decrement_bloodlust(amount = 1)
	if(bloodlust_lock_start_time)
		return
	var/real_amount = amount
	if(amount > bloodlust)
		real_amount = bloodlust
	if(bloodlust > minbloodlust)
		bloodlust -= real_amount
		stage_down()
		bound_xeno.recalculate_armor()
		bound_xeno.recalculate_speed()
	return

/datum/behavior_delegate/vampire/proc/reset_bloodlust()
	if(!bloodlust_lock_start_time)
		bloodlust = minbloodlust
		stage_down()
		return

/datum/behavior_delegate/vampire/proc/stage_up()

	switch(bloodlust)
		if(VAMPIRE_EMPOWER_1 to (VAMPIRE_EMPOWER_2 -1)) //stage 1, BL 3-5
			bound_xeno.attack_speed_modifier -= attack_delay_buff_per_stage
			bound_xeno.speed_modifier -= movement_speed_buff_per_stage
			bloodlust_flurry_mod = 1.25
			bloodlust_stun_mod = 1
		if(VAMPIRE_EMPOWER_2 to (VAMPIRE_EMPOWER_MAX -1)) //stage 2, BL 6-8
			bound_xeno.attack_speed_modifier -= attack_delay_buff_per_stage
			bound_xeno.speed_modifier -= movement_speed_buff_per_stage
			bloodlust_flurry_mod = 1.5 //45 damage per person hit by flurry
			bloodlust_headbite_mod = 1.5
			bloodlust_stun_mod = 2
		if(VAMPIRE_EMPOWER_MAX) //max stage, BL 9
			bound_xeno.attack_speed_modifier -= attack_delay_buff_per_stage
			bound_xeno.speed_modifier -= movement_speed_buff_per_stage
			bloodlust_flurry_mod = 2
			bloodlust_headbite_mod = 2 //that's 360 points of heal. Impressive!
			bloodlust_stun_mod = 3

/datum/behavior_delegate/vampire/proc/stage_down()

	switch(bloodlust)
		if(VAMPIRE_EMPOWER_MAX) //max stage, BL 9
			bound_xeno.attack_speed_modifier += attack_delay_buff_per_stage
			bound_xeno.speed_modifier += movement_speed_buff_per_stage
			bloodlust_flurry_mod = 2
			bloodlust_headbite_mod = 2
			bloodlust_stun_mod = 3
		if(VAMPIRE_EMPOWER_2 to (VAMPIRE_EMPOWER_MAX -1)) //stage 2, BL 6-8
			bound_xeno.attack_speed_modifier += attack_delay_buff_per_stage
			bound_xeno.speed_modifier += movement_speed_buff_per_stage
			bloodlust_flurry_mod = 1.5
			bloodlust_headbite_mod = 1.5
			bloodlust_stun_mod = 2
		if(VAMPIRE_EMPOWER_1 to (VAMPIRE_EMPOWER_2 -1)) //stage 1, BL 3-5
			bound_xeno.attack_speed_modifier += attack_delay_buff_per_stage
			bound_xeno.speed_modifier += movement_speed_buff_per_stage
			bloodlust_flurry_mod = 1.25
			bloodlust_headbite_mod = 1.25
			bloodlust_stun_mod = 1
		if(VAMPIRE_EMPOWER_0) //no stacks at all
			bound_xeno.attack_speed_modifier = 0
			bound_xeno.speed_modifier = 0
			bloodlust_flurry_mod = 1


/datum/behavior_delegate/vampire/proc/bloodlust_lock()
	bloodlust = max_bloodlust
	bloodlust_lock_start_time = world.time
	var/color = "#00000035"
	bound_xeno.add_filter("empower_bloodlust", 1, list("type" = "outline", "color" = color, "size" = 3))
	addtimer(CALLBACK(src, PROC_REF(bloodlust_lock_weaken)), bloodlust_lock_duration / 2)

/datum/behavior_delegate/vampire/proc/bloodlust_lock_weaken()
	bound_xeno.remove_filter("empower_bloodlust")
	var/color = "#00000027"
	bound_xeno.add_filter("empower_bloodlust", 1, list("type" = "outline", "color" = color, "size" = 3))
	addtimer(CALLBACK(src, PROC_REF(bloodlust_lock_callback)), bloodlust_cooldown_duration / 2)

/datum/behavior_delegate/vampire/proc/ignite_drain() //behavior for vampire being set on fire, should be called under ignite logic every 3-5 seconds while on fire

	if(!bound_xeno.on_fire)
		return
	bloodlust_lock_callback()
	if(bloodlust == minbloodlust) //if you've run out of slash stacks and are eating into your headbite supply, drain the headbite supply instead.
		minbloodlust -= 1
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("OUR STOLEN POWER IS FADING! EXTINGUISH THESE FLAMES NOW!"))
		addtimer(CALLBACK(src, PROC_REF(ignite_drain), 4 SECONDS)) //repeats until you aren't on fire
		return

/datum/behavior_delegate/vampire/proc/bloodlust_lock_callback()
	bound_xeno.remove_filter("empower_bloodlust")
	bloodlust_lock_start_time = 0
	bloodlust_cooldown_start_time = world.time
	reset_bloodlust() //decrement to the minimum set by headbites
	bound_xeno.remove_filter("berserker_bloodlust")
	if(bound_xeno.on_fire)
		addtimer(to_chat(bound_xeno, SPAN_XENOWARNING("FIRE has doused our bloodlust, put it out or we can't gain any more!")), 2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(ignite_drain), 4 SECONDS))
	else
		to_chat(bound_xeno, SPAN_XENOWARNING("Our adrenal glands spasm. We cannot gain any bloodlust for [bloodlust_cooldown_duration / 10] seconds."))
	addtimer(CALLBACK(src, PROC_REF(bloodlust_cooldown_callback)), bloodlust_cooldown_duration)
	bound_xeno.add_filter("berserker_lockdown", 1, list("type" = "outline", "color" = "#fcfcfcff", "size" = 1))

/datum/behavior_delegate/vampire/proc/bloodlust_cooldown_callback()
	bound_xeno.remove_filter("berserker_lockdown")
	bloodlust_cooldown_start_time = 0
	return

/datum/behavior_delegate/vampire/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if(!isxeno_human(target_carbon))
		return original_damage

	return original_damage
