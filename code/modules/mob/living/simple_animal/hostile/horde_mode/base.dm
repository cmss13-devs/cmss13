#define WEED_HEAL_FACTOR 0.05
#define OVERLAY_EFFECT_LAYER 8
#define ABILITY_COOLDOWN_LENGTH 0.5 SECONDS

/mob/living/simple_animal/hostile/alien/horde_mode
	icon = 'icons/mob/xenos/castes/tier_1/drone.dmi'
	icon_gib = "gibbed-a"
	attack_sound = "alien_claw_flesh"
	health = HORDE_MODE_HEALTH_MEDIUM
	maxHealth = HORDE_MODE_HEALTH_MEDIUM

	melee_damage_upper = HORDE_MODE_DAMAGE_MEDIUM
	melee_damage_lower = HORDE_MODE_DAMAGE_MEDIUM

	move_to_delay = HORDE_MODE_SPEED_NORMAL

	icon_size = 48
	pixel_x = -12
	old_x = -12
	langchat_color = "#b491c8"
	bubble_icon = "alien"
	mob_size = MOB_SIZE_XENO
	hivenumber = XENO_HIVE_HORDEMODE

	///A list of all currently displayed mob effects.
	var/list/effect_images = list()
	///Which hive this mob belongs to.
	var/datum/hive_status/hive
	///Has the mob used a preattack ability?
	var/preattack_move = FALSE

	var/attack_range
	var/cooldown_duration = 5 SECONDS
	var/strain_icon_path
	var/strain_icon_state
	///Is the strain an overlay (drone gardener, healer...) or a full sprite?
	var/strain_is_overlay = FALSE
	///Reference to the icon overlay for strains. Mostly used for drone strains.
	var/atom/movable/vis_obj/strain_overlay
	///List of all actions that the mob is supposed to have. Given during initialization.
	var/list/base_actions = list()
	///Temporary var for how many buildings the mob can build.
	var/max_buildings = 6
	///How long the interval is before the mob is able to use a melee attack again.
	var/slash_delay = HORDE_MODE_ATTACK_DELAY_NORMAL
	///How long the interval is before the mob is able to use a ranged attack again.
	var/ranged_delay
	///The distance at which this mob will attempt to use its ranged attack.
	var/ranged_distance
	///How for away the target has to be for the mob to attempt to use its ranged attack.
	var/ranged_distance_min = 0
	///The projectile the mob fires for ranged attacks.
	var/projectile_to_fire
	///SFX when a projectile gets fired.
	var/ranged_sfx = "acid_spit"
	///Cooldown dictating how long the mob has to wait before being able to use a melee attack.
	COOLDOWN_DECLARE(slash_cooldown)
	///Cooldown dictating how long the mob has to wait before being able to use a ranged attack.
	COOLDOWN_DECLARE(ranged_cooldown)
	///Cooldown dictating how long the mob has to wait before being able to use another ability.
	//this is used to stop xenos from immediately unleashing every single ability in one tick
	COOLDOWN_DECLARE(ability_cooldown)

//--------------------------------
// INIT AND ICONS

/mob/living/simple_animal/hostile/alien/horde_mode/Initialize()
	hive = GLOB.hive_datum[hivenumber]
	langchat_height = icon_size
	add_abilities()
	if(strain_icon_state && strain_is_overlay)
		strain_overlay = new(null, src)
		strain_overlay.icon = strain_icon_path
		strain_overlay.icon_state = "[strain_icon_state] Walking"
		vis_contents += strain_overlay
	//HORDE MODE MOBS ARE ADDED TO A DIFFERENT SUBSYSTEM IN horde_mode_mobs.dm, THEY DO NOT USE THE MISC MOBS SUBSYSTEM!!
	SShorde_mode.current_xenos += src
	//Boss enemies will always be a set strength.
	if(!istype(src, /mob/living/simple_animal/hostile/alien/horde_mode/boss))
		maxHealth *= SShorde_mode.xeno_health_mod
		melee_damage_upper *= SShorde_mode.xeno_damage_mod
		melee_damage_lower *= SShorde_mode.xeno_damage_mod
	find_random_target()
	ForceMoveToTarget()
	return ..()


//some strains are overlays while others are full icons (super wack). we need to take both into account.
/mob/living/simple_animal/hostile/alien/horde_mode/update_transform(instant_update)
	. = ..()

	if(strain_icon_state)
		if(strain_is_overlay)
			if(stat == DEAD)
				strain_overlay.icon_state = "[strain_icon_state] Dead"
			else if(body_position == LYING_DOWN)
				if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
					strain_overlay.icon_state = "[strain_icon_state] Sleeping"
				else
					strain_overlay.icon_state = "[strain_icon_state] Knocked Down"
			else
				strain_overlay.icon_state = "[strain_icon_state] Walking"

		else

			if(stat == DEAD)
				icon_state = "[strain_icon_state] Dead"
			else if(body_position == LYING_DOWN)
				if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
					icon_state = "[strain_icon_state] Sleeping"
				else
					icon_state = "[strain_icon_state] Knocked Down"
			else
				icon_state = "[strain_icon_state] Walking"

/mob/living/simple_animal/hostile/alien/horde_mode/handle_icon()
	if(strain_icon_state && !strain_is_overlay)
		icon_state = "[strain_icon_state] Walking"
		icon_living = "[strain_icon_state] Walking"
		icon_dead = "[strain_icon_state] Dead"
	else
		icon_state = "Normal [caste_name] Walking"
		icon_living = "Normal [caste_name] Walking"
		icon_dead = "Normal [caste_name] Dead"


// we need to make a special case for defenders due to lowered crests & fortify
/mob/living/simple_animal/hostile/alien/horde_mode/update_wounds()
	if(!wound_icon_holder)
		return

	wound_icon_holder.layer = layer + 0.01
	wound_icon_holder.dir = dir
	var/health_threshold = max(ceil((health * 4) / (maxHealth)), 0) //From 0 to 4, in 25% chunks
	if(health > health_threshold_dead)
		if(health_threshold > 3)
			wound_icon_holder.icon_state = "none"
		else if(body_position == LYING_DOWN)
			if(!HAS_TRAIT(src, TRAIT_INCAPACITATED) && !HAS_TRAIT(src, TRAIT_FLOORED))
				wound_icon_holder.icon_state = "[caste_name]_rest_[health_threshold]"
			else
				wound_icon_holder.icon_state = "[caste_name]_downed_[health_threshold]"
		else if(istype(src, /mob/living/simple_animal/hostile/alien/horde_mode/defender/steelcrest))
			var/mob/living/simple_animal/hostile/alien/horde_mode/defender/steelcrest/defender = src
			var/datum/action/horde_mode_action/steelcrest_fortify/fortify_ability = locate() in defender.actions
			if(fortify_ability.fortified)
				wound_icon_holder.icon_state = "[caste_name]_fortify_[health_threshold]"
			else if (defender.crest_lowered)
				wound_icon_holder.icon_state = "[caste_name]_crest_[health_threshold]"
		else
			wound_icon_holder.icon_state = "[caste_name]_walk_[health_threshold]"

//--------------------------------
// ABILITIES

/mob/living/simple_animal/hostile/alien/horde_mode/proc/add_abilities()
	if(!base_actions)
		return
	for(var/action_path in base_actions)
		give_action(src, action_path)

/mob/living/simple_animal/hostile/alien/horde_mode/proc/handle_abilities(ability_type, passed_arg)
	if(!COOLDOWN_FINISHED(src, ability_cooldown))
		return

	for(var/datum/action/horde_mode_action/action in actions)
		if(stat == DEAD || body_position == LYING_DOWN || action.ability_type != ability_type || !action.can_use_ability(passed_arg))
			continue

		INVOKE_ASYNC(action, TYPE_PROC_REF(/datum/action/horde_mode_action, use_ability), passed_arg)
		COOLDOWN_START(src, ability_cooldown, ABILITY_COOLDOWN_LENGTH)
		if(ability_type == HORDE_MODE_ABILITY_PREATTACK)
			preattack_move = TRUE
		return

//--------------------------------
// ATTACKING

/mob/living/simple_animal/hostile/alien/horde_mode/AttackingTarget()
	if(!COOLDOWN_FINISHED(src, slash_cooldown))
		return

	if(Adjacent(target_mob))
		handle_abilities(HORDE_MODE_ABILITY_PREATTACK, target_mob)

	if(preattack_move)
		return

	COOLDOWN_START(src, slash_cooldown, slash_delay)
	.  = ..()

	if(.)
		handle_abilities(HORDE_MODE_ABILITY_POSTATTACK, target_mob)

/mob/living/simple_animal/hostile/alien/horde_mode/ranged/proc/ranged_attack_checks(mob/living/target)
	if(!(target_mob in ListTargets(attack_range)) || Adjacent(target_mob))
		return

	if(COOLDOWN_FINISHED(src, ranged_cooldown))
		var/datum/ammo/projectile_type = GLOB.ammo_list[projectile_to_fire]
		visible_message(SPAN_XENOWARNING("[src] spits at [target_mob]!"))
		playsound(loc, pick('sound/voice/alien_spitacid.ogg', 'sound/voice/alien_spitacid2.ogg'), 25, 1)

		var/obj/projectile/projectile = new /obj/projectile(loc, create_cause_data(src))
		projectile.generate_bullet(projectile_type)
		projectile.permutated += src
		projectile.fire_at(target_mob, src, src, projectile_type.max_range, projectile_type.shell_speed)
		COOLDOWN_START(src, ranged_cooldown, cooldown_duration)

//--------------------------------
// STATUS EFFECT HANDLING

//the AI gets funky when it gets stunned midcombat. this will help them get back into the fight more organically.
/mob/living/simple_animal/hostile/alien/horde_mode/on_immobilized_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/alien/horde_mode/on_knockedout_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

/mob/living/simple_animal/hostile/alien/horde_mode/on_incapacitated_trait_loss(datum/source)
	. = ..()
	find_target_on_trait_loss()

///Proc for handling the AI post-status effect.
/mob/living/simple_animal/hostile/alien/horde_mode/proc/find_target_on_trait_loss()
	FindTarget()
	MoveToTarget()

//--------------------------------
// LIFE() PROCS

/mob/living/simple_animal/hostile/alien/horde_mode/Life(delta_time)
	AdjustKnockDown(-0.5)

	var/obj/effect/alien/weeds/weed = locate() in loc
	if(weed?.hivenumber == hivenumber)
		health += maxHealth * WEED_HEAL_FACTOR

	if(preattack_move)
		preattack_move = FALSE
	if(length(actions) && stat != DEAD)
		handle_abilities(HORDE_MODE_ABILITY_ACTIVE, target_mob)

	//handling ranged attacks
	if(projectile_to_fire && get_dist(src, target_mob) <= ranged_distance && get_dist(src, target_mob) > ranged_distance_min && COOLDOWN_FINISHED(src, ranged_cooldown) && body_position != LYING_DOWN)
		var/datum/ammo/projectile_type = GLOB.ammo_list[projectile_to_fire]
		visible_message(SPAN_XENOWARNING("[src] spits at [target_mob]!"))
		playsound(loc, ranged_sfx, 25, 1)

		var/obj/projectile/projectile = new /obj/projectile(loc, create_cause_data(src))
		projectile.generate_bullet(projectile_type)
		projectile.permutated += src
		projectile.fire_at(target_mob, src, src, projectile_type.max_range, projectile_type.shell_speed)
		COOLDOWN_START(src, ranged_cooldown, ranged_delay)

	if(!target_mob && hivenumber != XENO_HIVE_CORRUPTED)
		find_random_target()
		ForceMoveToTarget()
	else if(!target_mob && hivenumber == XENO_HIVE_CORRUPTED)
		find_random_xeno_target()
		ForceMoveToTarget()

	return ..()

/mob/living/simple_animal/hostile/alien/horde_mode/ranged/Life(delta_time)
	if(target_mob)
		INVOKE_ASYNC(src, PROC_REF(ranged_attack_checks), target_mob)

	. = ..()

//--------------------------------
// TARGET HANDLING

//MoveToTarget() checks for targets within view. If there is nothing in view they'll revert to being idle.
//This is not ideal for enemies that just spawn. We need to force them to move regardless of vision.
/mob/living/simple_animal/hostile/alien/horde_mode/proc/ForceMoveToTarget()
	if(target_mob && body_position != LYING_DOWN)
		walk_to(src, target_mob, 1, move_to_delay)

//range is no longer a factor when it comes to losing targets.
/mob/living/simple_animal/hostile/alien/horde_mode/AttackTarget()
	stop_automated_movement = TRUE
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return
	if(get_dist(src, target_mob) <= 1) //Attacking
		AttackingTarget()
		return TRUE

//--------------------------------
// MOVEMENT

/mob/living/simple_animal/hostile/alien/horde_mode/MoveToTarget()
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_INCAPACITATED) || HAS_TRAIT(src, TRAIT_FLOORED) || HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return

	stop_automated_movement = TRUE
	if(!target_mob || SA_attackable(target_mob))
		stance = HOSTILE_STANCE_IDLE
	if(target_mob)
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target_mob, 0, move_to_delay)

/mob/living/simple_animal/hostile/alien/horde_mode/stop_moving()
	walk_to(src, 0)

//--------------------------------
// BLOOD, GUTS AND GIBS

/mob/living/simple_animal/hostile/alien/horde_mode/gib_animation()
	playsound(src, 'sound/voice/alien_death.ogg', 50, 1)
	new /obj/effect/overlay/temp/gib_animation/xeno(loc, src, "gibbed-a", icon)

/mob/living/simple_animal/hostile/alien/horde_mode/generate_name()
	change_real_name(src, "[caste_name] (XX-[rand(1, 999)])")

/mob/living/simple_animal/hostile/alien/horde_mode/handle_blood_splatter(splatter_dir)
	if(prob(33))
		add_splatter_floor(loc, FALSE)
	new /obj/effect/bloodsplatter/xenosplatter(loc, splatter_dir)

/mob/living/simple_animal/hostile/alien/horde_mode/spawn_gibs()
	xgibs(get_turf(src))

/mob/living/simple_animal/hostile/alien/horde_mode/add_splatter_floor(turf/turf, small_drip, b_color)
	if(!turf)
		turf = get_turf(src)

	if(!turf.can_bloody)
		return

	var/obj/effect/decal/cleanable/blood/xeno/xeno_blood = locate() in turf.contents
	if(!xeno_blood)
		xeno_blood = new(turf)
		xeno_blood.color = get_blood_color()

/mob/living/simple_animal/hostile/alien/horde_mode/get_blood_color()
	return BLOOD_COLOR_XENO


//--------------------------------
// EXTRA PROCS

/mob/living/simple_animal/hostile/alien/horde_mode/proc/throw_mob(mob/living/target, direction, distance, speed = SPEED_VERY_FAST, shake_camera = TRUE, mob_spin = TRUE)
	if(target.mob_size >= MOB_SIZE_BIG)
		return

	if(!direction)
		direction = get_dir(src, target)
	var/turf/target_destination = get_ranged_target_turf(target, direction, distance)

	target.throw_atom(target_destination, distance, speed, src, spin = mob_spin)
	if(shake_camera)
		shake_camera(target, 10, 1)


/mob/living/simple_animal/hostile/alien/horde_mode/proc/create_stomp()
	remove_effect_layer()

	var/image/overlay = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state" = "stomp", "layer" = OVERLAY_EFFECT_LAYER)
	effect_images += overlay
	overlays += overlay
	addtimer(CALLBACK(src, PROC_REF(remove_effect_layer)), 1 SECONDS)

/mob/living/simple_animal/hostile/alien/horde_mode/proc/remove_effect_layer()
	for(var/image/effect_overlay in effect_images)
		overlays -= effect_overlay
		effect_images -= effect_overlay
		qdel(effect_overlay)

//TURN INTO CORRUPTED
/////////////////////
/mob/living/simple_animal/hostile/alien/horde_mode/proc/turn_corrupt()
	make_jittery(105)
	sleep(1 SECONDS)

	LoseTarget()

	visible_message(SPAN_XENOHIGHDANGER("[src] falls to the ground, its limbs and head twitching erradically in horrid pain!"))
	playsound(loc, "alien_help", 25, 1)
	manual_emote("writhes in pain!")
	animate(src, time = 4 SECONDS, easing = QUAD_EASING, color = "#80ff80")

	melee_damage_upper *= 2
	melee_damage_lower *= 2
	move_to_delay *= 0.8
	maxHealth *= 1.5

	apply_effect(5, WEAKEN)
	apply_effect(5, PARALYZE)

	health = maxHealth
	flick_heal_overlay(3 SECONDS, "#D9F500")

	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	hivenumber = XENO_HIVE_CORRUPTED
	hive = GLOB.hive_datum[hivenumber]
	name = "Corrupted [initial(name)] (XX-[rand(1, 999)])"
	langchat_color = "#80ff80"


#undef WEED_HEAL_FACTOR
#undef OVERLAY_EFFECT_LAYER
