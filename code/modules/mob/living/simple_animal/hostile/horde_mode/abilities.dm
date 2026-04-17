/datum/action/horde_mode_action
	hidden = TRUE
	var/cooldown_length = 4 SECONDS
	var/ability_type = HORDE_MODE_ABILITY_ACTIVE
	var/chance_to_activate = 100
	var/required_distance_to_target = 0
	COOLDOWN_DECLARE(ability_cooldown)

/datum/action/horde_mode_action/proc/can_use_ability(mob/living/target)
	if(!COOLDOWN_FINISHED(src, ability_cooldown) || !prob(chance_to_activate) || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		return FALSE
	if(required_distance_to_target > 0 && !target)
		return FALSE
	if(target && get_dist(owner, target) > required_distance_to_target + 1)
		return FALSE
	return TRUE

/datum/action/horde_mode_action/proc/use_ability(mob/living/target)

/datum/action/horde_mode_action/proc/apply_cooldown()
	COOLDOWN_START(src, ability_cooldown, cooldown_length)

//--------------------------------
// PLANT WEEDS

/datum/action/horde_mode_action/plant_weeds
	cooldown_length = 16 SECONDS
	///How far the mob has to be away from another (equal or weaker) resin node to plant another node.
	var/range_limit = 3
	var/weed_level = WEED_LEVEL_STANDARD
	var/node_type = /obj/effect/alien/weeds/node/horde_mode

/datum/action/horde_mode_action/plant_weeds/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	var/turf/turf = xeno.loc
	if(!istype(turf) || turf.density || !turf.is_weedable)
		return

	var/obj/effect/alien/weeds/node/node
	for(var/obj/effect/alien/weeds/node/closest_node in view(xeno, range_limit))
		node = closest_node

	//if there is a node within a certain distance and it's the same level or stronger, don't plant
	if(node && node.weed_strength <= weed_level && get_dist(xeno, node) <= range_limit)
		return

	if(node && node.weed_strength >= weed_level)
		return

	var/obj/effect/alien/resin/trap/resin_trap = locate() in turf
	if(resin_trap)
		return

	var/obj/effect/alien/weeds/weed = node || locate() in turf
	if(weed && weed.weed_strength >= WEED_LEVEL_HIVE)
		return

	for(var/obj/structure/struct in turf)
		if(struct.density && !(struct.flags_atom & ON_BORDER))
			return

	var/area/area = get_area(turf)
	if(isnull(area) || !(area.is_resin_allowed))
		return

	var/list/to_convert
	if(node)
		to_convert = node.children.Copy()

	xeno.visible_message(SPAN_XENONOTICE("[xeno] regurgitates a pulsating node and plants it on the ground!"))
	var/obj/effect/alien/weeds/node/new_node = new node_type(xeno.loc, null, null, xeno.hive)

	if(to_convert)
		for(var/cur_weed in to_convert)
			var/turf/target_turf = get_turf(cur_weed)
			if(target_turf && !target_turf.density)
				new /obj/effect/alien/weeds(target_turf, new_node)
			qdel(cur_weed)

	playsound(xeno.loc, "alien_resin_build", 25)
	apply_cooldown()

/datum/action/horde_mode_action/plant_weeds/weak
	weed_level = WEED_LEVEL_WEAK
	node_type = /obj/effect/alien/weeds/node/weak/horde_mode

//--------------------------------
// RESIN CONSTRUCTION -- HIVE CLUSTER

/datum/action/horde_mode_action/resin_construction
	cooldown_length = 20 SECONDS
	chance_to_activate = 50
	required_distance_to_target = 10
	var/time_to_construct = 5 SECONDS
	var/construction_effect = "xeno_telegraph_brown_anim"
	var/constructed_object = /obj/structure/horde_mode_resin/hive_cluster
	var/requires_weeds = FALSE
	var/distance_from_other_buildings = 5

/datum/action/horde_mode_action/resin_construction/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	if(get_dist(xeno, target) >= 3 || xeno.max_buildings <= 0)
		return

	for(var/obj/structure/horde_mode_resin/resin_structure in range(distance_from_other_buildings, xeno))
		return

	var/turf/construction_turf = get_turf(get_step(xeno, xeno.dir))
	if(requires_weeds && !(locate(/obj/effect/alien/weeds) in construction_turf) || construction_turf.density || construction_turf.opacity)
		return

	for(var/obj/object in construction_turf)
		if(object.density || istype(object, /obj/structure/horde_mode_resin))
			return

	apply_cooldown()

	var/obj/effect/resin_construct/con_effect = new(construction_turf)
	con_effect.icon_state = construction_effect
	xeno.stop_moving()
	xeno.visible_message(SPAN_XENODANGER("[xeno] starts regurgitating resin and reshaping it into something..."))

	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, "resin construction")
	playsound(xeno.loc, get_sfx("alien_resin_build"), 50)

	if(!do_after(xeno, time_to_construct))
		REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, "resin construction")
		qdel(con_effect)
		return

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, "resin construction")
	playsound(xeno.loc, get_sfx("alien_resin_build"), 50)
	xeno.max_buildings--
	new constructed_object(construction_turf, xeno.hive)
	qdel(con_effect)

//--------------------------------
// RESIN CONSTRUCTION -- RECOVERY NODE

/datum/action/horde_mode_action/resin_construction/recovery
	cooldown_length = 20 SECONDS
	chance_to_activate = 75
	constructed_object = /obj/structure/horde_mode_resin/recovery
	requires_weeds = TRUE


//--------------------------------
// HEALING PHEREOS

/datum/action/horde_mode_action/heal
	cooldown_length = 10 SECONDS
	var/heal_strength = 0.2
	var/heal_strength_human = 0.05
	var/heal_range = 4

/datum/action/horde_mode_action/heal/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	owner.visible_message(SPAN_XENOBOLDNOTICE("[owner] starts emitting healing pheromones..."))
	for(var/mob/living/surrounding_mob in view(heal_range, owner))
		if(surrounding_mob.faction == owner.faction)
			if(ishuman(surrounding_mob))
				var/mob/living/carbon/human/friendly_human = surrounding_mob
				var/total_health = friendly_human.species.total_health
				friendly_human.heal_overall_damage(total_health * heal_strength_human, total_health * heal_strength_human)
				to_chat(friendly_human, SPAN_HELPFUL("[owner]'s pheromones appear to be closing your wounds!"))
			else
				surrounding_mob.health += surrounding_mob.maxHealth * heal_strength
				if(isanimalhordemode(surrounding_mob))
					var/mob/living/simple_animal/hostile/alien/horde_mode/alien = surrounding_mob
					alien.update_wounds()
			surrounding_mob.flick_heal_overlay(3 SECONDS, "#D9F500")
	apply_cooldown()


//--------------------------------
// ACID SLASH

/datum/action/horde_mode_action/acid_slash
	ability_type = HORDE_MODE_ABILITY_POSTATTACK

/datum/action/horde_mode_action/acid_slash/use_ability(mob/living/carbon/human/target)
	if(!can_use_ability(target))
		return

	if(!ishuman(target) || target.stat == DEAD)
		return

	for(var/datum/effects/acid/acid_effect in target.effects_list)
		qdel(acid_effect)
		break

	new /datum/effects/acid(target, src)

//--------------------------------
// NEURO SLASH

/datum/action/horde_mode_action/neuro_slash
	ability_type = HORDE_MODE_ABILITY_POSTATTACK
	cooldown_length = 6 SECONDS

/datum/action/horde_mode_action/neuro_slash/use_ability(mob/living/carbon/human/target)
	if(!can_use_ability(target))
		return

	if(!ishuman(target) || target.stat == DEAD)
		return

	target.apply_effect(0.5, SLOW)
	to_chat(target, SPAN_BOLDWARNING("You feel sluggish as [owner]'s claws inject you with neurotoxin!"))

//--------------------------------
// NEURO SLASH

/datum/action/horde_mode_action/lifesteal
	ability_type = HORDE_MODE_ABILITY_POSTATTACK
	cooldown_length = 0 SECONDS
	var/heal_amount = 0.2 //precentage

/datum/action/horde_mode_action/lifesteal/use_ability(mob/living/carbon/human/target)
	if(!can_use_ability(target))
		return

	if(!ishuman(target) || target.stat == DEAD)
		return

	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	xeno.health += xeno.maxHealth * heal_amount
	xeno.flick_heal_overlay(1 SECONDS, "#00B800")

//--------------------------------
// TAIL SWIPE

/datum/action/horde_mode_action/toss_mob/tail_swipe
	cooldown_length = 15 SECONDS
	damage_multiplier = 0.5
	var/swipe_range = 1

/datum/action/horde_mode_action/toss_mob/tail_swipe/use_ability()
	if(!can_use_ability(target))
		return

	apply_cooldown()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	xeno.spin_circle()
	xeno.emote("tail")
	for(var/mob/living/target in view(swipe_range, xeno))
		if(target.stat == DEAD || target.mob_size >= MOB_SIZE_BIG || target.faction == xeno.faction)
			continue
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(human_target.check_shields(0, name))
				playsound(xeno.loc, "bonk", 75, FALSE)
				continue

		var/facing = get_dir(xeno, target)
		target.apply_damage(rand(xeno.melee_damage_upper, xeno.melee_damage_lower) * damage_multiplier, BRUTE)
		playsound(target,'sound/weapons/alien_claw_block.ogg', 75, 1)
		xeno.throw_mob(target, facing, throw_distance)
		if(paralyze)
			target.apply_effect(1, PARALYZE)
			target.apply_effect(1, WEAKEN)

//--------------------------------
// TOSS MOB

/datum/action/horde_mode_action/toss_mob
	ability_type = HORDE_MODE_ABILITY_PREATTACK
	cooldown_length = 10 SECONDS
	required_distance_to_target = 1
	var/paralyze = FALSE
	var/throw_distance = 4
	var/damage_multiplier = 1
	var/throw_sound = 'sound/weapons/alien_claw_block.ogg'
	var/mob_spin = TRUE

/datum/action/horde_mode_action/toss_mob/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	apply_cooldown()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner

	xeno.animation_attack_on(target)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.check_shields(0, name))
			playsound(xeno.loc, "bonk", 75, FALSE)
			return

	var/facing = get_dir(xeno, target)
	target.apply_damage(rand(xeno.melee_damage_upper, xeno.melee_damage_lower) * damage_multiplier, BRUTE)
	playsound(target, throw_sound, 75, 1)
	xeno.throw_mob(target, facing, throw_distance, SPEED_AVERAGE)
	if(paralyze)
		target.apply_effect(1, PARALYZE)
		target.apply_effect(1, WEAKEN)

// HEADBUTT
/datum/action/horde_mode_action/toss_mob/headbutt
	damage_multiplier = 0.33
	throw_distance = 2

/datum/action/horde_mode_action/toss_mob/headbutt/use_ability(mob/living/target)
	. = ..()
	owner.visible_message(SPAN_XENOWARNING("[owner] rams [target] with its armored crest!"))

// CLOTHESLINE
/datum/action/horde_mode_action/toss_mob/clothesline
	cooldown_length = 8 SECONDS
	damage_multiplier = 0.66
	throw_distance = 4

/datum/action/horde_mode_action/toss_mob/clothesline/use_ability(mob/living/target)
	. = ..()
	owner.visible_message(SPAN_XENOWARNING("[owner] clotheslines [target]! Their wounds seem to close up..."))
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	xeno.flick_attack_overlay(target, "slam")
	xeno.health += xeno.maxHealth * 0.05
	xeno.flick_heal_overlay(1 SECONDS, "#00B800")

// TAIL STAB
/datum/action/horde_mode_action/toss_mob/tail_jab
	ability_type = HORDE_MODE_ABILITY_ACTIVE
	damage_multiplier = 1
	throw_distance = 2
	required_distance_to_target = 2
	throw_sound = 'sound/weapons/alien_tail_attack.ogg'
	mob_spin = FALSE

/datum/action/horde_mode_action/toss_mob/tail_jab/use_ability(mob/living/target)
	. = ..()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	xeno.visible_message(SPAN_XENOWARNING("[xeno] pierces [target] with its sharp tail!"))
	xeno.flick_attack_overlay(target, "tail")

//--------------------------------
// LURKER INVISBILITY

/datum/action/horde_mode_action/invisibility
	cooldown_length = 0 SECONDS
	///What speed the mob will move at when invisible
	var/invisbility_speed = HORDE_MODE_SPEED_INSANELY_FAST
	///Mob's alpha level whe invisible
	var/invisibility_alpha = 50


/datum/action/horde_mode_action/invisibility/can_use_ability(mob/living/target)
	if(!target)
		return FALSE
	return TRUE

/datum/action/horde_mode_action/invisibility/use_ability(mob/living/target)

	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	//if we are really far away, start moving faster. we also have to stop moving for a brief moment, as speed is not updated until the pathfinding is done.
	if(get_dist(xeno, target) > 6)
		xeno.stop_moving()
		xeno.move_to_delay = invisbility_speed
		xeno.MoveToTarget()
	else
		xeno.stop_moving()
		xeno.move_to_delay = initial(xeno.move_to_delay)
		xeno.MoveToTarget()

	//once we're up close and personal, drop the cloak. otherwise keep being invisible
	if(xeno.stat == DEAD || get_dist(xeno, target) < 2)
		xeno.alpha = initial(xeno.alpha)
	else
		xeno.alpha = invisibility_alpha


//--------------------------------
// STEELCREST FORTIFY

/datum/action/horde_mode_action/steelcrest_fortify
	cooldown_length = 0 SECONDS
	///Whether the mob is currently fortified or not.
	var/fortified = FALSE

/datum/action/horde_mode_action/steelcrest_fortify/can_use_ability(mob/living/target)
	return TRUE

/datum/action/horde_mode_action/steelcrest_fortify/use_ability(mob/living/target)
	if(get_dist(owner, target) <= 4 && !fortified)
		fortify()

	else if(get_dist(owner, target) > 4 && fortified)
		fortify()

/datum/action/horde_mode_action/steelcrest_fortify/proc/fortify()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	fortified = !fortified
	switch(fortified)
		if(FALSE)
			xeno.icon_state = "Steelcrest Defender Walking"
			xeno.brute_damage_mod = 1
			xeno.move_to_delay -= HORDE_MODE_SPEED_MOD_MEDIUM
			xeno.status_flags |= CANSTUN
			xeno.mob_size = MOB_SIZE_XENO
		if(TRUE)
			xeno.icon_state = "Steelcrest Defender Fortify"
			xeno.brute_damage_mod = 0.66
			xeno.move_to_delay += HORDE_MODE_SPEED_MOD_MEDIUM
			xeno.status_flags &= ~CANSTUN
			xeno.mob_size = MOB_SIZE_BIG
	xeno.update_wounds()

//--------------------------------
// RUSH

/datum/action/horde_mode_action/rush
	cooldown_length = 14 SECONDS
	required_distance_to_target = 7
	var/speed_mod = HORDE_MODE_SPEED_MOD_HIGH
	var/rush_length = 2 SECONDS
	var/has_footstep = FALSE
	var/footstep_sound = "alien_footstep_large"

/datum/action/horde_mode_action/rush/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	if(in_range(owner, target))
		return

	apply_cooldown()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	xeno.emote("roar")

	var/outline_color = "#FF0000"
	outline_color += num2text(70, 2, 16)
	addtimer(CALLBACK(src, PROC_REF(remove_rush), outline_color), rush_length, TIMER_STOPPABLE)

	if(has_footstep)
		xeno.AddComponent(/datum/component/footstep, 2 , 35, 11, 4, footstep_sound)

	xeno.add_filter("outline_rush", 1, outline_filter(size = 0, color = outline_color))
	xeno.transition_filter("outline_rush", list(size = 2), 2 SECONDS, QUAD_EASING)

	xeno.visible_message(SPAN_DANGER("[xeno] begins to dash forward!"))
	xeno.move_to_delay -= speed_mod

/datum/action/horde_mode_action/rush/proc/remove_rush(outline_color)
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	if(has_footstep)
		qdel(xeno.GetComponent(/datum/component/footstep))

	xeno.move_to_delay += speed_mod

	if(!xeno.get_filter("outline_rush"))
		return

	outline_color += num2text(35, 2, 16)
	xeno.transition_filter("outline_rush", list(size = 0, color = outline_color), 2 SECONDS, QUAD_EASING)
	sleep(2 SECONDS)
	xeno.remove_filter("outline_rush")

//--------------------------------
// TREMOR

/datum/action/horde_mode_action/tremor
	cooldown_length = 16 SECONDS
	required_distance_to_target = 3

/datum/action/horde_mode_action/tremor/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	playsound(xeno.loc, 'sound/effects/alien_footstep_charge3.ogg', 50, 0)
	xeno.visible_message(SPAN_XENODANGER("[xeno] digs itself into the ground and shakes the earth itself, causing violent tremors!"))
	xeno.create_stomp()
	apply_cooldown()

	for(var/mob/living/carbon/carbon_target in range(5, xeno.loc))
		if(xeno.hive.is_ally(carbon_target))
			continue
		to_chat(carbon_target, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(carbon_target, 2, 3)
		switch(get_dist(xeno, carbon_target))
			if(0 to 2)
				carbon_target.apply_effect(2, SLOW)
				shake_camera(carbon_target, 5, 4)
			if(2 to 5)
				carbon_target.apply_effect(1, SLOW)
				shake_camera(carbon_target, 2, 3)

//--------------------------------
// EVISCERATE

/datum/action/horde_mode_action/eviscerate
	cooldown_length = 10 SECONDS
	required_distance_to_target = 3

/datum/action/horde_mode_action/eviscerate/can_use_ability(mob/living/target)
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	if(xeno.get_filter("outline_rush"))
		return FALSE
	return ..()

/datum/action/horde_mode_action/eviscerate/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	apply_cooldown()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner
	xeno.manual_emote("roars!")
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] lets out a massive roar as it starts eviscerating everything in its proximity!"))
	playsound(xeno, 'sound/voice/alien_heavy_roar.ogg', 75, 1)
	ADD_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
	xeno.anchored = TRUE

	var/list/effect_tiles = list()

	for(var/turf/affected_turf in (orange(3, owner) - orange(2, owner)))
		var/obj/effect/xenomorph/xeno_telegraph/red/telegraph_effect = new(affected_turf, 10 SECONDS)
		effect_tiles += telegraph_effect

	for(var/times_to_attack = 3, times_to_attack > 0, times_to_attack--)
		xeno.spin_circle(2)
		for(var/mob/living/victim in range(xeno, 3))
			if(xeno.body_position == LYING_DOWN)
				break
			if(xeno.hive.is_ally(victim) || victim.stat == DEAD)
				continue
			victim.apply_effect(0.5, WEAKEN)
			victim.apply_damage(rand(xeno.melee_damage_upper, xeno.melee_damage_lower) * 0.25, BRUTE)
			playsound(victim, "alien_claw_flesh", 75, 1)
			shake_camera(victim, 2, 3)
			xeno.flick_attack_overlay(victim, "slash")
			victim.handle_blood_splatter(get_dir(xeno.loc, victim.loc))
			if(prob(15))
				xeno.throw_mob(victim, get_dir(xeno, target), 2, SPEED_AVERAGE)
			sleep(rand(0.1 SECONDS, 0.15 SECONDS))
		sleep(0.2 SECONDS)

	for(var/effect in effect_tiles)
		qdel(effect)

	REMOVE_TRAIT(xeno, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Eviscerate"))
	xeno.anchored = FALSE

//--------------------------------
// SCISSOR CUT

/datum/action/horde_mode_action/scissor_cut
	cooldown_length = 6 SECONDS
	required_distance_to_target = 2

/datum/action/horde_mode_action/scissor_cut/use_ability(mob/living/target)
	if(!can_use_ability(target))
		return

	apply_cooldown()
	var/mob/living/simple_animal/hostile/alien/horde_mode/xeno = owner

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(xeno)
	var/facing = Get_Compass_Dir(xeno, target)
	var/turf/infront = get_step(root, facing)
	var/turf/left = get_step(root, turn(facing, 90))
	var/turf/right = get_step(root, turn(facing, -90))
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront

	if(!(!infront || infront.density) && !(!left || left.density))
		temp_turfs += infront_left
	if(!(!infront || infront.density) && !(!right || right.density))
		temp_turfs += infront_right

	for(var/turf/turf in temp_turfs)
		if(!istype(turf))
			continue

		if(turf.density)
			continue

		target_turfs += turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(turf, 0.25 SECONDS)

		var/turf/next_turf = get_step(turf, facing)
		if(!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(next_turf, 0.25 SECONDS)

	if(!length(target_turfs))
		return

	// Get list of target mobs
	var/list/target_mobs = list()

	for(var/turf/path_turf as anything in target_turfs)
		for(var/mob/living/victim in path_turf.contents)
			if(xeno.hive.is_ally(victim))
				continue

			if(!(victim in target_mobs))
				target_mobs += victim

	for(var/mob/living/victim in target_mobs)
		victim.apply_damage(rand(xeno.melee_damage_upper, xeno.melee_damage_lower), BRUTE)
		playsound(victim, "alien_claw_flesh", 75, 1)
		xeno.flick_attack_overlay(victim, "slash")
		victim.handle_blood_splatter(get_dir(xeno.loc, victim.loc))
