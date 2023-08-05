/mob/living/simple_animal/hostile/alien/spawnable
	var/icon_name = "Drone"
	caste_name = null
	desc = "Bork."
	icon = 'fray-marines/icons/mob/xenos/lesser_xeno.dmi'
	icon_gib = "gibbed-a"
	layer = BIG_XENO_LAYER
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	status_flags = CANSTUN|CANKNOCKDOWN|CANPUSH
	move_to_delay = XENO_AI_SPEED_TIER_2
	meat_type = null
	health = XENO_HEALTH_LESSER_DRONE
	harm_intent_damage = 5
	melee_damage_lower = XENO_AI_DAMAGE_TIER_1
	melee_damage_upper = XENO_AI_DAMAGE_TIER_1
	attacktext = "slashes"
	a_intent = INTENT_HARM
	unsuitable_atoms_damage = 15
	attack_same = TRUE
	faction = FACTION_XENOMORPH
	hivenumber = XENO_HIVE_NORMAL
	wall_smash = 1
	minbodytemp = 0
	heat_damage_per_tick = 20
	stop_automated_movement_when_pulled = TRUE
	break_stuff_probability = 90
	mob_size = MOB_SIZE_XENO_SMALL

	pixel_x = 0
	old_x = 0

	var/special_attack_probability = XENO_AI_SPECIAL_ATTACK_PROBABILITY

/mob/living/simple_animal/hostile/alien/spawnable/generate_name()
	change_real_name(src, "\improper[caste_name] (WT-[rand(1, 999)])")

/mob/living/simple_animal/hostile/alien/spawnable/handle_icon()
	icon_state = "[icon_name] Running"
	icon_living = "[icon_name] Running"
	icon_dead = "[icon_name] Dead"

/mob/living/simple_animal/hostile/alien/spawnable/update_transform()
	if(lying != lying_prev)
		lying_prev = lying
	if(stat == DEAD)
		icon_state = "[icon_name] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "[icon_name] Sleeping"
		else
			icon_state = "[icon_name] Knocked Down"
	else
		icon_state = "[icon_name] Running"
	update_wounds()

/mob/living/simple_animal/hostile/alien/spawnable/FindTarget()
	var/atom/T = null
	stop_automated_movement = 0
	for(var/atom/A in ListTargets(10))

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = evaluate_target(A)
			if(L)
				stance = HOSTILE_STANCE_ATTACK
				T = L
				break

		if(istype(A, /obj/structure/machinery/bot))
			var/obj/structure/machinery/bot/B = A
			if (B.health > 0)
				stance = HOSTILE_STANCE_ATTACK
				T = B
				break
	return T

/mob/living/simple_animal/hostile/alien/spawnable/AttackingTarget()
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		if (evaluate_special_attack(L))
			return L
		L.attack_animal(src)
		src.animation_attack_on(L)
		src.flick_attack_overlay(L, "slash")
		playsound(src.loc, "alien_claw_flesh", 25, 1)
		return L

/mob/living/simple_animal/hostile/alien/spawnable/proc/evaluate_special_attack(mob/living/L)
	return FALSE

/mob/living/simple_animal/hostile/alien/spawnable/proc/evaluate_specific_behavior(mob/living/L)
	return FALSE

/mob/living/simple_animal/hostile/alien/spawnable/bullet_act(obj/item/projectile/P)
	if(!P || !istype(P))
		return

	var/damage = P.calculate_damage()
	var/damage_result = damage

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags

	if(ammo_flags & AMMO_FLAME)
		health = 0
		emote("bursts into flames!")
		return TRUE

	if(isxeno(P.firer))
		return -1

	if(P.ammo.debilitate && stat != DEAD && ( damage || (ammo_flags & AMMO_IGNORE_RESIST) ) )
		apply_effects(arglist(P.ammo.debilitate))

	. = TRUE
	if(damage)
		bullet_message(P)
		apply_damage(damage, P.ammo.damage_type, P.def_zone, 0, 0, P)
		handle_blood_splatter(get_dir(P.starting, loc))
		P.play_hit_effect(src)

	bullet_message(P) //Message us about the bullet, since damage was inflicted.

	SEND_SIGNAL(P, COMSIG_BULLET_ACT_XENO, src, damage, damage_result)

	return TRUE

/mob/living/simple_animal/hostile/alien/spawnable/death(cause, gibbed, deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw. The caustic acid starts melting the body away...")
	. = ..()
	if(!.)
		return //If they were already dead, it will return.
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(xgibs), get_turf(src)), 3 SECONDS)

/mob/living/simple_animal/hostile/alien/spawnable/spawn_gibs()
	xgibs(get_turf(src))

/mob/living/simple_animal/hostile/alien/spawnable/gib_animation()
	var/to_flick = "gibbed-a"
	var/icon_path = icon
	new /obj/effect/overlay/temp/gib_animation/xeno(loc, src, to_flick, icon_path)

/mob/living/simple_animal/hostile/alien/spawnable/handle_blood_splatter(splatter_dir, duration)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(loc, splatter_dir, duration)

/mob/living/simple_animal/hostile/alien/spawnable/handle_flamer_fire(obj/flamer_fire/fire, damage, delta_time)
	health = 0
	visible_message("[src] bursts into flames!")

/mob/living/simple_animal/hostile/alien/spawnable/handle_flamer_fire_crossed(obj/flamer_fire/fire)
	health = 0
	visible_message("[src] bursts into flames!")
