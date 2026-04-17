
#define FIRE_LAYER 1
#define ishordemodemob(A) (istype(A, /mob/living/simple_animal/hostile/alien/horde_mode))

#define HM_XENO_SPEED_VERY_SLOW 5
#define HM_XENO_SPEED_SLOW 4.5
#define HM_XENO_SPEED_AVERAGE 4
#define HM_XENO_SPEED_FAST 3.75
#define HM_XENO_SPEED_VERY_FAST 3.5
#define HM_XENO_SPEED_RUNNER 2.5

/mob/living/simple_animal/hostile/alien/horde_mode
	health = XENO_HEALTH_TIER_3
	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_damage_taken_multiplier = 3
	move_to_delay = HM_XENO_SPEED_AVERAGE
	icon_size = 48
	destroy_surroundings = FALSE
	///How much damage the mob takes from explosives.
	var/explosive_damage_multiplier = 1.5
	///How much damage the mob takes from fire.
	var/fire_damage_multiplier = 1
	///Used for tracking which mob hit this xeno last, so we can reward them points accordingly.
	var/mob/living/last_hit_by
	///Used for giving extra points on death, mainly for melee kills. Will be overridden to 0 if shot by a bullet.
	var/death_bonus = 0
	///How many points do you get for killing them?
	var/kill_reward = 150
	var/mob/target_mob
	affected_by_fire = TRUE

///Gives us a random target to hunt down.
/mob/living/simple_animal/hostile/alien/horde_mode/proc/find_random_target()
	if(length(SShorde_mode.corrupted_xenos) && prob(66))
		target_mob = pick(SShorde_mode.corrupted_xenos)
		return

	target_mob = SShorde_mode.return_random_player()

///Gives us a random target to hunt down.
/mob/living/simple_animal/hostile/alien/horde_mode/proc/find_random_xeno_target()
	target_mob = SShorde_mode.return_random_xeno()

///PROCS FOR HANDLING FIRE.
/mob/living/simple_animal/hostile/alien/horde_mode/IgniteMob()
	. = ..()
	if (. & IGNITE_IGNITED)
		roar_emote()

/mob/living/simple_animal/hostile/alien/horde_mode/handle_fire()
	. = ..()

	if(!last_damage_data)
		return

	var/mob/player_mob = last_damage_data.resolve_mob()
	last_hit_by = player_mob
	if(stat != DEAD && on_fire)
		SShorde_mode.update_points(player_mob, 10)
		balloon_alert(player_mob, "+10")

/mob/living/simple_animal/hostile/alien/horde_mode/update_fire()
	if(on_fire && fire_reagent)
		var/image/I
		if(mob_size >= MOB_SIZE_BIG)
			if((!initial(pixel_y) || body_position != LYING_DOWN)) // what's that pixel_y doing here??? (i don't know)
				I = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire", "layer"=-FIRE_LAYER)
			else
				I = image("icon"='icons/mob/xenos/overlay_effects64x64.dmi', "icon_state"="alien_fire_lying", "layer"=-FIRE_LAYER)
		else
			I = image("icon" = 'icons/mob/xenos/effects.dmi', "icon_state"="alien_fire", "layer"=-FIRE_LAYER)

		I.appearance_flags |= RESET_COLOR|RESET_ALPHA
		I.color = fire_reagent.burncolor
		overlays += I
	if(!on_fire)
		for(var/image/fire_overlay in overlays)
			if(fire_overlay.icon_state == "alien_fire" || fire_overlay.icon_state == "alien_fire_lying")
				overlays -= fire_overlay

/mob/living/simple_animal/hostile/alien/horde_mode/Destroy()
	. = ..()
	SShorde_mode.current_xenos -= src

/mob/living/simple_animal/hostile/alien/horde_mode/death(cause, gibbed, deathmessage)
	. = ..()
	if(!isnull(last_hit_by))
		if(last_hit_by.stat != DEAD)
			SShorde_mode.update_points(last_hit_by, kill_reward + death_bonus)
			balloon_alert(last_hit_by, "+[kill_reward + death_bonus]")

	SShorde_mode.current_xenos -= src

/mob/living/simple_animal/hostile/alien/horde_mode/bullet_act(obj/projectile/bullet)
	. = ..()
	var/mob/living/bullet_owner = bullet.firer

	if(ishuman(bullet_owner))
		death_bonus = 0
		last_hit_by = bullet_owner
		if(stat != DEAD)
			SShorde_mode.update_points(bullet_owner, 10)
			balloon_alert(bullet_owner, "+10")

/mob/living/simple_animal/hostile/alien/horde_mode/attackby(obj/item/weapon, mob/user)
	. = ..()
	//We need to check for the weapon's force so players don't get rewarded with extra points for just hitting them with a pencil.
	if(stat != DEAD && weapon.force >= MELEE_FORCE_NORMAL)
		if(isgun(weapon))
			var/obj/item/weapon/gun/weapon_gun = weapon
			//Without this check, every PB would count as a melee hit.
			if(weapon_gun.PB_fired)
				return
		last_hit_by = user
		death_bonus = 100
		SShorde_mode.update_points(user, 20)
		balloon_alert(user, "+20")

/mob/living/simple_animal/hostile/alien/horde_mode/ex_act(severity, direction, datum/cause_data/explosion_cause_data)
	if(severity >= 30)
		flash_eyes()

	if(severity >= health && severity >= EXPLOSION_THRESHOLD_GIB)
		gib()
		return

	var/mob/explosion_source_mob = explosion_cause_data?.resolve_mob()
	if(explosion_source_mob)
		last_hit_by = explosion_source_mob
		SShorde_mode.update_points(explosion_source_mob, 20)
		balloon_alert(explosion_source_mob, "+20")

	apply_damage(severity * explosive_damage_multiplier, BRUTE)
	updatehealth()
	death_bonus = 0

	if(mob_size < MOB_SIZE_BIG)
		var/knock_value = min(round( severity*0.1, 1), 5)
		if(knock_value > 0)
			apply_effect(knock_value, WEAKEN)
			apply_effect(knock_value, PARALYZE)
			explosion_throw(severity, direction)

/mob/living/simple_animal/hostile/alien/horde_mode/make_jittery(amount)
	if(stat == DEAD) return
	jitteriness = min(1000, jitteriness + amount)
	if(jitteriness > 100 && !is_jittery)
		INVOKE_ASYNC(src, PROC_REF(jittery_process))

//BOSS ENEMIES
//////////////
/mob/living/simple_animal/hostile/alien/horde_mode/boss
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon = 'icons/mob/xenos/castes/tier_3/praetorian.dmi'
	icon_size = 64
	pixel_x = -16
	old_x = -16
	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	health = XENO_HEALTH_QUEEN
	move_to_delay = 4.5
	kill_reward = 3000
	mob_size = MOB_SIZE_BIG
	explosive_damage_multiplier = 0.25
	var/following_mob
	COOLDOWN_DECLARE(first_ability)
	COOLDOWN_DECLARE(second_ability)
	COOLDOWN_DECLARE(third_ability)
	COOLDOWN_DECLARE(fourth_ability)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/Life(delta_time)
	if(target_mob && (target_mob in ListTargets(10)))
		if(following_mob)
			following_mob = null
			walk_to(src, 0) //stop moving
		if(COOLDOWN_FINISHED(src, first_ability) && prob(75)) //DASH
			INVOKE_ASYNC(src, PROC_REF(first_ability))
		else if(COOLDOWN_FINISHED(src, second_ability) && prob(50)) //ACID LINE
			INVOKE_ASYNC(src, PROC_REF(second_ability))
		if(COOLDOWN_FINISHED(src, third_ability)) //SHRIEK
			INVOKE_ASYNC(src, PROC_REF(third_ability))
		if(COOLDOWN_FINISHED(src, fourth_ability) && Adjacent(target_mob)) //TAIL SWIPE
			INVOKE_ASYNC(src, PROC_REF(fourth_ability))

	. = ..()

	//Start following a random human player if there are no enemies to fight.
	//We are picking a random player because checking for the closest mob via a for() loop is pretty resource intensive.
	if(!target_mob && hivenumber == XENO_HIVE_CORRUPTED && body_position != LYING_DOWN && !following_mob)
		stop_automated_movement = 1
		following_mob = SShorde_mode.return_random_player()
		walk_to(src, following_mob, 4, move_to_delay)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_block))
	status_flags &= ~(CANKNOCKDOWN|CANSTUN|CANPUSH)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/check_block(mob/queen, turf/new_loc)
	SIGNAL_HANDLER
	for(var/mob/living/simple_animal/hostile/alien/horde_mode/xeno in new_loc.contents)
		if(xeno.hivenumber == hivenumber)
			xeno.KnockDown((5 DECISECONDS))
			playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	if(prob(65))
		fling(target_mob, 2, STUN = FALSE)
		return

	if(isliving(target_mob))
		var/mob/living/target = target_mob
		if(prob(50) || target.body_position == LYING_DOWN)
			INVOKE_ASYNC(src, PROC_REF(ravaging_attack), target)
		else
			target.attack_animal(src)
			animation_attack_on(target)
			flick_attack_overlay(target, "slash")
			playsound(loc, "alien_claw_flesh", 25, 1)
		return target

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/first_ability()
	if(Adjacent(target_mob))
		return

	COOLDOWN_START(src, first_ability, 8 SECONDS)
	roar_emote()
	var/outline_color = "#FF0000"
	var/alpha = 70
	outline_color += num2text(alpha, 2, 16)

	add_filter("outline", 1, outline_filter(size = 0, color = outline_color))
	transition_filter("outline", list(size = 2), 2 SECONDS, QUAD_EASING)

	visible_message(SPAN_HIGHDANGER("[src] begins to dash forward!"))
	move_to_delay -= 1.5
	MoveToTarget()
	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	sleep(3 SECONDS)

	alpha = 35
	outline_color += num2text(alpha, 2, 16)

	transition_filter("outline", list(size = 0, color = outline_color), 2 SECONDS, QUAD_EASING)
	move_to_delay += 1.5
	MoveToTarget()
	GetExactComponent(/datum/component/footstep).RemoveComponent()
	sleep(2 SECONDS)
	remove_filter("outline")

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/second_ability()
	COOLDOWN_START(src, second_ability, 8 SECONDS)
	playsound(loc, 'sound/effects/refill.ogg', 30, 1)
	visible_message(SPAN_XENOWARNING("[src] vomits a flood of acid!"))
	do_acid_spray_line(get_line(src, target_mob, include_start_atom = FALSE), /obj/effect/xenomorph/spray/strong/no_stun/short_duration, 7)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/third_ability()
	COOLDOWN_START(src, third_ability, 22 SECONDS)
	playsound(loc, pick('sound/voice/xenos_roaring.ogg'), 75)
	visible_message(SPAN_XENOHIGHDANGER("[src] emits a guttural roar! A strange healing mist starts surrounding them..."))
	for(var/mob/living/surrounding_mob in view(7, src))
		if(surrounding_mob.faction == faction)
			if(ishuman(surrounding_mob))
				var/mob/living/carbon/human/friendly_human = surrounding_mob
				var/total_health = friendly_human.species.total_health
				friendly_human.heal_overall_damage(total_health * 0.25, total_health * 0.25)
				to_chat(friendly_human, SPAN_HELPFUL("[src]'s pheromones appear to be closing your wounds!"))
			else
				surrounding_mob.health += maxHealth * 0.33
			surrounding_mob.flick_heal_overlay(3 SECONDS, "#D9F500")
	create_shriekwave(5)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/fourth_ability()
	COOLDOWN_START(src, fourth_ability, 14 SECONDS)
	tail_swipe(target_mob, 5, TRUE)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/death(cause, gibbed, deathmessage)
	. = ..()
	var/list/all_players
	for(var/list/player_in_list as anything in SShorde_mode.current_players)
		var/player_mob = player_in_list["mob"]
		all_players += player_mob
	for(var/mob/player in all_players)
		SShorde_mode.update_points(player, kill_reward / length(all_players))
		balloon_alert_to_viewers("+[kill_reward]")

//RANDOM ABILTIIES
//////////////////
/mob/living/simple_animal/hostile/alien/horde_mode/proc/tail_swipe(mob/living/target, distance = 3, paralyze = FALSE)
	if(stat == DEAD)
		return

	spin_circle()
	manual_emote("swipes its tail.")

	for(target in view(1, src))
		if(target.stat == DEAD || target.mob_size >= MOB_SIZE_BIG || target.faction == faction)
			continue
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(human_target.check_shields(0, name))
				playsound(loc, "bonk", 75, FALSE)
				continue

		var/facing = get_dir(src, target)
		target.apply_damage(rand(melee_damage_upper, melee_damage_lower), BRUTE)
		playsound(target,'sound/weapons/alien_claw_block.ogg', 75, 1)
		throw_mob(target, facing, distance)
		if(paralyze)
			target.apply_effect(1, PARALYZE)
			target.apply_effect(1, WEAKEN)

/mob/living/simple_animal/hostile/alien/horde_mode/boss/proc/ravaging_attack(mob/living/target)
	attacktext = "tears into"
	for(var/times_to_attack = pick(2, 3, 4), times_to_attack > 0, times_to_attack--)
		if(Adjacent(target) && target.stat == CONSCIOUS)
			target.attack_animal(src)
			src.animation_attack_on(target)
			src.flick_attack_overlay(target, "slash")
			playsound(loc, "alien_claw_flesh", 25, 1)
			sleep(0.35 SECONDS)
	attacktext = initial(attacktext)

//ACID SPRAY PROCS
//////////////////
/mob/living/simple_animal/hostile/alien/proc/do_acid_spray_line(list/turflist, spray_path = /obj/effect/xenomorph/spray, distance_max = 5)
	if(isnull(turflist) || stat == DEAD)
		return
	var/turf/prev_turf = loc

	var/distance = 0
	for(var/turf/T in turflist)
		distance++

		if(!prev_turf && length(turflist) > 1)
			prev_turf = get_turf(src)
			continue //So we don't burn the tile we be standin on

		if(T.density || istype(T, /turf/open/space))
			break
		if(distance > distance_max)
			break

		var/atom/movable/temp = new spray_path()
		var/atom/movable/AM = LinkBlocked(temp, prev_turf, T)
		qdel(temp)
		if(AM)
			if(ishordemodemob(AM))
				var/mob/living/simple_animal/hostile/alien/horde_mode/alien = AM
				if(alien.faction != src.faction)
					AM.acid_spray_act(src)
					break
			else
				AM.acid_spray_act(src)
				break

		prev_turf = T
		new spray_path(T, create_cause_data(src))
		sleep(0.5)

//SHRIEK PROC
/////////////
/mob/living/simple_animal/hostile/alien/horde_mode/proc/create_shriekwave(shriekwaves_left)
	var/offset_y = 8
	if(mob_size == MOB_SIZE_XENO)
		offset_y = 24
	if(mob_size == MOB_SIZE_IMMOBILE)
		offset_y = 28

	//the shockwave center is updated eachtime shockwave is called and offset relative to the mob_size.
	//due to the speed of the shockwaves, it isn't required to be tied to the exact mob movements
	var/epicenter = loc //center of the shockwave, set at the center of the tile that the mob is currently standing on
	var/easing = QUAD_EASING | EASE_OUT
	var/stage1_radius = rand(11, 12)
	var/stage2_radius = rand(9, 11)
	var/stage3_radius = rand(8, 10)
	var/stage4_radius = 7.5

	//shockwaves are iterated, counting down once per shriekwave, with the total amount being determined on the respective xeno ability tile
	if(shriekwaves_left > 12)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage1_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 2)
		return
	if(shriekwaves_left > 8)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage2_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 3)
		return
	if(shriekwaves_left > 4)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage3_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 3)
		return
	if(shriekwaves_left > 1)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, stage4_radius, 0.5, easing, offset_y)
		addtimer(CALLBACK(src, PROC_REF(create_shriekwave), shriekwaves_left), 3)
		return
	if(shriekwaves_left == 1)
		shriekwaves_left--
		new /obj/effect/shockwave(epicenter, 10.5, 0.6, easing, offset_y)

//LUNGE PROC
////////////
/mob/living/simple_animal/hostile/alien/horde_mode/proc/lunge(mob/living/target, lunge_distance)
	if(stat == DEAD)
		return

	manual_emote("lunges at [target]!")
	animation_attack_on(target)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.check_shields(0, name))
			playsound(loc, "bonk", 75, FALSE)
			return

	throw_atom(get_step_towards(target, src), lunge_distance, SPEED_FAST, src)
	if(Adjacent(target))
		target.apply_effect(0.5, ROOT)
		to_chat(target_mob, SPAN_USERDANGER("[src]'s strong grip roots you in place!"))
		flick_attack_overlay(target, "grab")
		if(ishuman(target))
			INVOKE_ASYNC(target, TYPE_PROC_REF(/mob, emote), "scream")

//FLINGING PROCS
////////////////
/mob/living/simple_animal/hostile/alien/horde_mode/proc/fling(mob/living/target, fling_distance = 5, stun = FALSE)
	if(body_position == LYING_DOWN || !Adjacent(target) || target.mob_size >= MOB_SIZE_BIG || stat == DEAD)
		return

	animation_attack_on(target)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.check_shields(0, name))
			playsound(loc, "bonk", 75, FALSE)
			return

	if(!stun)
		visible_message(SPAN_XENOWARNING("[src] effortlessly flings [target] to the side!"))
	else
		visible_message(SPAN_XENOWARNING("The force of [src]'s blow effortlessly throws [target] away!"))
		if(isanimal(target))
			target.apply_effect(1, WEAKEN)
			target.apply_effect(1, PARALYZE)
		if(stun)
			target.apply_effect(0.25, WEAKEN)
		if(prob(50))
			roar_emote()

	playsound(target,'sound/weapons/alien_claw_block.ogg', 75, 1)
	target.last_damage_data = create_cause_data(src)

	var/facing = get_dir(src, target)
	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(!stun)
		target.apply_damage(damage * 0.5, BRUTE)
	else
		target.apply_damage(damage, BRUTE)

	face_atom(target)
	animation_attack_on(target)
	flick_attack_overlay(target, "disarm")
	throw_mob(target, facing, fling_distance, SPEED_VERY_FAST, shake_camera = TRUE)

#undef FIRE_LAYER
#undef HM_XENO_SPEED_VERY_SLOW
#undef HM_XENO_SPEED_SLOW
#undef HM_XENO_SPEED_AVERAGE
#undef HM_XENO_SPEED_FAST
#undef HM_XENO_SPEED_VERY_FAST
#undef HM_XENO_SPEED_RUNNER
