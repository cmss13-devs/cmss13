
////////// BASE RAV POWERS

/datum/action/xeno_action/onclick/empower/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(xeno.mutation_type != RAVAGER_NORMAL)
		return

	if(!action_cooldown_check())
		return

	if(!activated_once)
		if (!check_and_use_plasma_owner())
			return

		xeno.visible_message(SPAN_XENODANGER("[xeno] starts empowering!"), SPAN_XENODANGER("You start empowering yourself!"))
		activated_once = TRUE
		button.icon_state = "template_active"
		get_inital_shield()
		addtimer(CALLBACK(src, PROC_REF(timeout)), time_until_timeout)
		apply_cooldown()
		..()
	else
		//Returns the number of enemies in range, used for the passive's bonus effects
		return actual_empower()

/datum/action/xeno_action/onclick/empower/proc/actual_empower()
	var/mob/living/carbon/xenomorph/xeno = owner
	activated_once = FALSE
	button.icon_state = "template"
	xeno.visible_message(SPAN_XENOWARNING("[xeno] gets empowered by the surrounding enemies!"), SPAN_XENOWARNING("You feel a rush of power from the surrounding enemies!"))
	xeno.create_empower()

	var/list/mobs_in_range = oviewers(empower_range, xeno)
	// Spook patrol
	xeno.emote("tail")

	var/accumulative_health = 0
	var/list/telegraph_atom_list = list()

	var/empower_targets
	for(var/mob/living/mob in mobs_in_range)
		if(empower_targets >= max_targets)
			break
		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue
		if(xeno.can_not_harm(mob))
			continue

		empower_targets++
		accumulative_health += shield_per_human
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(mob.loc, 1 SECONDS)
		shake_camera(mob, 2, 1)

	accumulative_health += main_empower_base_shield
	current_targets = empower_targets
	xeno.add_xeno_shield(accumulative_health, XENO_SHIELD_SOURCE_RAVAGER)
	xeno.overlay_shields()
	if(empower_targets >= super_empower_threshold) //you go in deep you reap the rewards
		super_empower(empower_targets)
	return empower_targets

/datum/action/xeno_action/onclick/empower/proc/super_empower()
	owner.visible_message(SPAN_DANGER("[owner] glows an eerie red as it empowers further with the strength of [current_targets] hostiles!"), SPAN_XENOHIGHDANGER("You begin to glow an eerie red, empowered by the [current_targets] enemies!"))
	owner.emote("roar")

	var/color = "#FF0000"
	var/alpha = 70
	color += num2text(alpha, 2, 16)
	owner.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, PROC_REF(weaken_superbuff)), super_empower_duration * 0.75)

/datum/action/xeno_action/onclick/empower/proc/weaken_superbuff()
	owner.remove_filter("empower_rage")
	var/color = "#FF0000"
	var/alpha = 35
	color += num2text(alpha, 2, 16)
	owner.add_filter("empower_rage", 1, list("type" = "outline", "color" = color, "size" = 3))

	addtimer(CALLBACK(src, PROC_REF(remove_superbuff)), super_empower_duration * 0.25)

/datum/action/xeno_action/onclick/empower/proc/remove_superbuff()
	current_targets = 0
	owner.visible_message(SPAN_DANGER("[owner]'s glow slowly dims."), SPAN_XENOHIGHDANGER("Your glow fades away, the power leaving your body!"))
	owner.remove_filter("empower_rage")

/datum/action/xeno_action/onclick/empower/proc/get_inital_shield()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!activated_once)
		return

	xeno.add_xeno_shield(initial_activation_shield, XENO_SHIELD_SOURCE_RAVAGER)
	xeno.overlay_shields()

/datum/action/xeno_action/onclick/empower/proc/timeout()
	if(!activated_once)
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	actual_empower(xeno)

/datum/action/xeno_action/onclick/empower/action_cooldown_check()
	if (cooldown_timer_id == TIMER_ID_NULL)
		return TRUE
	else if (activated_once)
		return TRUE
	else
		return FALSE

// Supplemental behavior for our charge
/datum/action/xeno_action/activable/pounce/charge/additional_effects(mob/living/victim)
	var/mob/living/carbon/human/human_victim = victim
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	var/datum/action/xeno_action/onclick/empower/empower_action = get_xeno_action_by_type(xeno_owner, /datum/action/xeno_action/onclick/empower)
	if(!empower_action || empower_action.current_targets < empower_action.super_empower_threshold)
		return

	xeno_owner.visible_message(SPAN_XENODANGER("The [xeno_owner] uses its shield to bash [human_victim] as it charges at them!"), SPAN_XENODANGER("You use your shield to bash [human_victim] as you charge at them!"))
	human_victim.apply_effect(knockdown_amount, WEAKEN)
	human_victim.attack_alien(xeno_owner, rand(xeno_owner.melee_damage_lower, xeno_owner.melee_damage_upper))

	var/facing = get_dir(xeno_owner, human_victim)
	var/turf/T = xeno_owner.loc
	var/turf/temp = xeno_owner.loc

	for(var/x in 0 to fling_distance-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	human_victim.throw_atom(T, fling_distance, SPEED_VERY_FAST, xeno_owner, TRUE)


/datum/action/xeno_action/activable/scissor_cut/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state())
		return

	// Determine whether or not we should daze here
	var/should_sslow = FALSE
	var/datum/action/xeno_action/onclick/empower/empower_action = get_xeno_action_by_type(xeno_owner, /datum/action/xeno_action/onclick/empower)
	if(empower_action && empower_action.current_targets > empower_action.super_empower_threshold)
		should_sslow = TRUE

	// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(xeno_owner, target_atom)
	var/turf/T = xeno_owner.loc
	var/turf/temp = xeno_owner.loc
	var/list/telegraph_atom_list = list()

	for (var/x in 0 to 3)
		temp = get_step(T, facing)
		if(facing in diagonals) // check if it goes through corners
			var/reverse_face = reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/structure_blocker in temp)
			if(istype(structure_blocker, /obj/structure/window/framed))
				var/obj/structure/window/framed/W = structure_blocker
				if(!W.unslashable)
					W.deconstruct(disassembled = FALSE)

			if(structure_blocker.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp
		target_turfs += T
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(T, 0.25 SECONDS)

	// Extract our 'optimal' turf, if it exists
	if (target_turfs.len >= 2)
		xeno_owner.animation_attack_on(target_turfs[target_turfs.len], 15)

	// Hmm today I will kill a marine while looking away from them
	xeno_owner.face_atom(target_atom)
	xeno_owner.emote("roar")
	xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] sweeps its claws through the area in front of it!"), SPAN_XENODANGER("You sweep your claws through the area in front of you!"))

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/turf/target_turf in target_turfs)
		for (var/mob/living/carbon/carbon_target in target_turf)
			if (carbon_target.stat == DEAD)
				continue

			if(xeno_owner.can_not_harm(carbon_target))
				continue
			xeno_owner.flick_attack_overlay(carbon_target, "slash")
			carbon_target.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE)
			playsound(get_turf(carbon_target), "alien_claw_flesh", 30, TRUE)

			if(should_sslow)
				new /datum/effects/xeno_slow/superslow/(carbon_target, xeno_owner, ttl = superslow_duration)

	apply_cooldown()
	..()
	return

///////////// BERSERKER POWERS

/datum/action/xeno_action/onclick/apprehend/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!istype(xeno_owner))
		return

	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	xeno_owner.speed_modifier -= speed_buff
	xeno_owner.recalculate_speed()

	addtimer(CALLBACK(src, PROC_REF(apprehend_off)), buff_duration, TIMER_UNIQUE)

	apply_cooldown()

	return ..()

/datum/action/xeno_action/onclick/apprehend/proc/apprehend_off()
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if (istype(xeno_owner))
		xeno_owner.speed_modifier += speed_buff
		xeno_owner.recalculate_speed()
		to_chat(xeno_owner, SPAN_XENOHIGHDANGER("You feel your speed wane!"))

/datum/action/xeno_action/activable/clothesline/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state())
		return

	if (!isXenoOrHuman(target) || xeno_owner.can_not_harm(target))
		to_chat(xeno_owner, SPAN_XENOWARNING("You must target a hostile!"))
		return

	if (!xeno_owner.Adjacent(target))
		to_chat(xeno_owner, SPAN_XENOWARNING("You must be adjacent to your target!"))
		return

	var/mob/living/carbon/carbon_target = target
	if (carbon_target.mob_size >= MOB_SIZE_BIG)
		to_chat(xeno_owner, SPAN_XENOWARNING("This creature is too massive to target"))
		return

	if (carbon_target.stat == DEAD)
		return

	if(heal == initial(heal))
		to_chat(xeno_owner, SPAN_XENOWARNING("Your rejuvenation was weaker without rage!"))

	// Damage
	var/obj/limb/head/head = carbon_target.get_limb("head")
	if(ishuman(carbon_target) && head)
		carbon_target.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "head")
	else
		carbon_target.apply_armoured_damage(get_xeno_damage_slash(carbon_target, damage), ARMOR_MELEE, BRUTE) // just for consistency

	// Heal
	if(!xeno_owner.on_fire)
		xeno_owner.gain_health(heal)

	// Fling
	var/facing = get_dir(xeno_owner, carbon_target)
	var/turf/T = xeno_owner.loc
	var/turf/temp = xeno_owner.loc

	for (var/x in 0 to fling_dist-1)
		temp = get_step(T, facing)
		if (!temp)
			break
		T = temp

	carbon_target.throw_atom(T, fling_dist, SPEED_VERY_FAST, xeno_owner, TRUE)

	// Negative stat effects
	if (debilitating)
		carbon_target.dazed += daze_amount

	apply_cooldown()
	..()
	return heal

/datum/action/xeno_action/activable/eviscerate/can_use_action()
	. = ..()
	if(!rage)
		return FALSE

/datum/action/xeno_action/activable/eviscerate/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check() || xeno.action_busy)
		return

	if(!xeno.check_state())
		return

	var/damage = base_damage
	var/range = 1
	var/windup_reduction = 0
	var/lifesteal_per_marine = 50
	var/max_lifesteal = 250
	var/lifesteal_range =  1

	damage = damage_at_rage_levels[Clamp(rage, 1, damage_at_rage_levels.len+1)]
	range = range_at_rage_levels[Clamp(rage, 1, damage_at_rage_levels.len+1)]
	windup_reduction = windup_reduction_at_rage_levels[Clamp(, 1, damage_at_rage_levels.len+1)]
	apply_cooldown()

	if (range > 1)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] begins digging in for a massive strike!"), SPAN_XENOHIGHDANGER("You begin digging in for a massive strike!"))
	else
		xeno.visible_message(SPAN_XENODANGER("[xeno] begins digging in for a strike!"), SPAN_XENOHIGHDANGER("You begin digging in for a strike!"))

	xeno.frozen = TRUE
	xeno.anchored = TRUE
	xeno.update_canmove()

	if (do_after(xeno, (activation_delay - windup_reduction), INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		xeno.emote("roar")
		xeno.spin_circle()

		for (var/mob/living/carbon/human in orange(xeno, range))
			if(!isXenoOrHuman(human) || xeno.can_not_harm(human))
				continue

			if (human.stat == DEAD)
				continue

			if(!check_clear_path_to_target(xeno, human))
				continue

			if (range > 1)
				xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] rips open the guts of [human]!"), SPAN_XENOHIGHDANGER("You rip open the guts of [human]!"))
				human.spawn_gibs()
				playsound(get_turf(human), 'sound/effects/gibbed.ogg', 30, TRUE)
				human.apply_effect(get_xeno_stun_duration(human, 1), WEAKEN)
			else
				xeno.visible_message(SPAN_XENODANGER("[xeno] claws [human]!"), SPAN_XENODANGER("You claw [human]!"))
				playsound(get_turf(human), "alien_claw_flesh", 30, 1)

			human.apply_armoured_damage(get_xeno_damage_slash(human, damage), ARMOR_MELEE, BRUTE, "chest", 20)

	var/valid_count = 0
	var/list/mobs_in_range = oviewers(lifesteal_range, xeno)

	for(var/mob/mob as anything in mobs_in_range)
		if(mob.stat == DEAD || HAS_TRAIT(mob, TRAIT_NESTED))
			continue

		if(xeno.can_not_harm(mob))
			continue

		valid_count++

	var/healed_amount
	// This is the heal
	if(!xeno.on_fire)
		healed_amount = xeno.gain_health(Clamp(valid_count * lifesteal_per_marine, 0, max_lifesteal))

	xeno.frozen = FALSE
	xeno.anchored = FALSE
	xeno.update_canmove()
	..()
	return healed_amount


////////// HEDGEHOG POWERS

/datum/action/xeno_action/onclick/spike_shield/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(shard_amount < shard_cost)
		to_chat(xeno, SPAN_DANGER("Not enough shards! You need [shard_cost - shard_amount] more!"))
		return

	xeno.visible_message(SPAN_XENODANGER("[xeno] ruffles its bone-shard quills, forming a defensive shell!"), SPAN_XENODANGER("You ruffle your bone-shard quills, forming a defensive shell!"))

	// Add our shield
	var/datum/xeno_shield/hedgehog_shield/shield = xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_HEDGE_RAV, /datum/xeno_shield/hedgehog_shield)
	if (shield)
		shield.owner = xeno
		shield.shrapnel_amount = shield_shrapnel_amount
		xeno.overlay_shields()

	xeno.create_shield(shield_duration)
	shield_active = TRUE
	button.icon_state = "template_active"
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), shield_duration)

	apply_cooldown()
	..()
	return TRUE

/datum/action/xeno_action/onclick/spike_shield/can_use_action()
	. = ..()
	if (shard_amount < shard_cost)
		return FALSE

/datum/action/xeno_action/onclick/spike_shield/proc/remove_shield()
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!shield_active)
		return

	shield_active = FALSE
	button.icon_state = "template"

	for (var/datum/xeno_shield/shield in xeno.xeno_shields)
		if (shield.shield_source == XENO_SHIELD_SOURCE_HEDGE_RAV)
			shield.on_removal()
			qdel(shield)
			break

	to_chat(xeno, SPAN_XENODANGER("You feel your shard shield dissipate!"))
	xeno.overlay_shields()
	return

/datum/action/xeno_action/activable/rav_spikes/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(xeno_owner.loc) || !xeno_owner.check_state())
		return

	if (shard_amount < shard_cost)
		to_chat(xeno_owner, SPAN_DANGER("Not enough shards! You need [shard_cost - shard_amount] more!"))
		return

	xeno_owner.visible_message(SPAN_XENOWARNING("The [xeno_owner] fires their spikes at [A]!"), SPAN_XENOWARNING("You fire your spikes at [A]!"))

	var/turf/target = locate(A.x, A.y, A.z)
	var/obj/item/projectile/spikes = new /obj/item/projectile(xeno_owner.loc, create_cause_data(initial(xeno_owner.caste_type), xeno_owner))

	var/datum/ammo/spikes_ammo = GLOB.ammo_list[ammo_type]

	spikes.generate_bullet(spikes_ammo)

	spikes.fire_at(target, xeno_owner, xeno_owner, spikes_ammo.max_range, spikes_ammo.shell_speed)
	playsound(xeno_owner, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	..()
	return TRUE

/datum/action/xeno_action/activable/rav_spikes/can_use_action()
	. = ..()
	if (shard_amount < shard_cost)
		return FALSE

/datum/action/xeno_action/onclick/spike_shed/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state())
		return

	if (shard_amount < shard_cost)
		to_chat(xeno_owner, SPAN_DANGER("Not enough shards! You need [shard_cost - shard_amount] more!"))
		return

	xeno_owner.visible_message(SPAN_XENOWARNING("The [xeno_owner] sheds their spikes, firing them in all directions!"), SPAN_XENOWARNING("You shed your spikes, firing them in all directions!!"))
	xeno_owner.spin_circle()
	create_shrapnel(get_turf(xeno_owner), shrapnel_amount, null, null, ammo_type, create_cause_data(initial(xeno_owner.caste_type), owner), TRUE)
	playsound(xeno_owner, 'sound/effects/spike_spray.ogg', 25, 1)

	apply_cooldown()
	..()
	return TRUE

/datum/action/xeno_action/onclick/spike_shed/can_use_action()
	. = ..()
	if (shard_amount < shard_cost)
		return FALSE
