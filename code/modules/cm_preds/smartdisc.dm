/obj/item/explosive/grenade/spawnergrenade/smartdisc
	name = "smart-disc"
	spawner_type = /mob/living/simple_animal/hostile/smartdisc
	deliveryamt = 1
	desc = "A strange piece of alien technology. It has many jagged, whirring blades and bizarre writing."
	flags_item = ITEM_PREDATOR
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	icon_state = "disc"
	item_state = "pred_disc"
	w_class = SIZE_TINY
	det_time = 30
	unacidable = TRUE
	embeddable = FALSE

	force = 15
	throwforce = 25

/obj/item/explosive/grenade/spawnergrenade/smartdisc/launch_towards(datum/launch_metadata/LM)
	..()
	var/mob/user = usr
	if(!active && isyautja(user) && (icon_state == initial(icon_state)))
		boomerang(user)

/obj/item/explosive/grenade/spawnergrenade/smartdisc/proc/boomerang(mob/user)
	var/mob/living/L = find_target(user)
	icon_state = initial(icon_state) + "_active"
	if(L)
		throw_atom(get_turf(L), 4, SPEED_FAST, user)
	throw_atom(user, 12, SPEED_SLOW, user)
	addtimer(CALLBACK(src, PROC_REF(clear_boomerang)), 3 SECONDS)

/obj/item/explosive/grenade/spawnergrenade/smartdisc/proc/clear_boomerang()
	icon_state = initial(icon_state)

/obj/item/explosive/grenade/spawnergrenade/smartdisc/proc/find_target(mob/user)
	var/atom/T = null
	for(var/mob/living/A in listtargets(4))
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == user.faction)
				continue
			else if(isyautja(L))
				continue
			else if (L.stat == DEAD)
				continue
			else
				T = L
				break
	return T

/obj/item/explosive/grenade/spawnergrenade/smartdisc/proc/listtargets(dist = 3)
	var/list/L = hearers(src, dist)
	return L

/obj/item/explosive/grenade/spawnergrenade/smartdisc/attack_self(mob/user)
	. = ..()

	if(active)
		return

	if(!isyautja(user))
		if(prob(75))
			to_chat(user, SPAN_WARNING("You fiddle with the disc, but nothing happens. Try again maybe?"))
			return
	to_chat(user, SPAN_WARNING("You activate the smart-disc and it whirrs to life!"))
	activate(user)
	add_fingerprint(user)
	var/mob/living/carbon/carbon_user = user
	if(istype(carbon_user) && !carbon_user.throw_mode)
		carbon_user.toggle_throw_mode(THROW_MODE_NORMAL)

/obj/item/explosive/grenade/spawnergrenade/smartdisc/activate(mob/user)
	if(active)
		return

	if(user)
		msg_admin_attack("[key_name(user)] primed \a [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, 'sound/items/countdown.ogg', 25, 1)
	update_icon()
	spawn(det_time)
		prime()
		return

/obj/item/explosive/grenade/spawnergrenade/smartdisc/prime()
	if(spawner_type && deliveryamt)
		// Make a quick flash
		var/turf/T = get_turf(src)
		var/atom/movable/x = new spawner_type
		x.forceMove(T)

	qdel(src)
	return

/obj/item/explosive/grenade/spawnergrenade/smartdisc/launch_impact(atom/hit_atom)
	if(isyautja(hit_atom))
		var/mob/living/carbon/human/hooman = hit_atom
		if(hooman.put_in_hands(src))
			hit_atom.visible_message("[hit_atom] expertly catches [src] out of the air.","You catch [src] easily.")
			throwing = FALSE
		return
	..()

/mob/living/simple_animal/hostile/smartdisc
	name = "smart-disc"
	desc = "A furious, whirling array of blades and alien technology."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "disc_active"
	icon_living = "disc_active"
	icon_dead = "disc"
	icon_gib = "disc"
	speak_chance = 0
	turns_per_move = 1
	response_help = "stares at the"
	response_disarm = "bats aside the"
	response_harm = "hits the"
	speed = -2
	maxHealth = 60
	health = 60
	attack_same = 0
	density = FALSE
	mob_size = MOB_SIZE_SMALL

	harm_intent_damage = 10
	attacktext = "slices"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 5000

	break_stuff_probability = 0
	destroy_surroundings = 0

	faction = FACTION_YAUTJA
	var/lifetime = 8 //About 15 seconds.
	var/time_idle = 0


/mob/living/simple_animal/hostile/smartdisc/New()
	melee_damage_lower = 15
	melee_damage_upper = 25
	..()

/mob/living/simple_animal/hostile/smartdisc/Process_Spacemove(check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/smartdisc/Collided(atom/movable/AM)
	return

/mob/living/simple_animal/hostile/smartdisc/bullet_act(obj/projectile/Proj)
	if(prob(60 - Proj.damage))
		return 0

	if(!Proj || Proj.damage <= 0)
		return 0

	apply_damage(Proj.damage, BRUTE)
	return 1

/mob/living/simple_animal/hostile/smartdisc/death()
	visible_message("[src] stops whirring and spins out onto the floor.")
	new /obj/item/explosive/grenade/spawnergrenade/smartdisc(loc)
	. = ..()
	spawn(1)
		if(src)
			qdel(src)

/mob/living/simple_animal/hostile/smartdisc/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	visible_message("[src] explodes!")
	..(cause, icon_gib,1)
	spawn(1)
		if(src)
			qdel(src)

/mob/living/simple_animal/hostile/smartdisc/FindTarget()
	var/atom/T = null
	stop_automated_movement = 0

	for(var/atom/A in ListTargets(5))
		if(A == src)
			continue

		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == faction)
				continue
			else if(WEAKREF(L) in friends)
				continue
			else if(isyautja(L))
				continue
			else if (L.stat == DEAD)
				continue
			else
				if(!L.stat)
					stance = HOSTILE_STANCE_ATTACK
					T = L
					break
	return T

/mob/living/simple_animal/hostile/smartdisc/ListTargets(dist = 7)
	var/list/L = hearers(src, dist)
	return L

/mob/living/simple_animal/hostile/smartdisc/Life(delta_time)
	. = ..()
	if(!.)
		walk(src, 0)
		return 0
	if(client)
		return 0

	if(stance == HOSTILE_STANCE_IDLE)
		time_idle++
	else
		time_idle = 0

	lifetime--
	if(lifetime <= 0 || time_idle > 3)
		visible_message("\The [src] stops whirring and spins out onto the floor.")
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(src.loc)
		qdel(src)
		return

	if(!stat)
		switch(stance)
			if(HOSTILE_STANCE_IDLE)
				target_mob_ref = WEAKREF(FindTarget())

			if(HOSTILE_STANCE_ATTACK)
				MoveToTarget()

			if(HOSTILE_STANCE_ATTACKING)
				AttackTarget()

/mob/living/simple_animal/hostile/smartdisc/AttackTarget()
	stop_automated_movement = TRUE
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(!target_mob || SA_attackable(target_mob))
		LoseTarget()
		return FALSE
	if(!(target_mob in ListTargets(5)) || prob(20) || target_mob.stat)
		stance = HOSTILE_STANCE_IDLE
		return FALSE
	if(get_dist(src, target_mob) <= 1) //Attacking
		AttackingTarget()
		return TRUE

/mob/living/simple_animal/hostile/smartdisc/AttackingTarget()
	var/mob/living/target_mob = target_mob_ref?.resolve()
	if(!target_mob)
		return
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		target_mob.attack_animal(src)
		if(prob(5))
			target_mob.apply_effect(3, WEAKEN)
			target_mob.visible_message(SPAN_DANGER("[src] viciously slashes at [target_mob]!"))
			log_attack("[key_name(target_mob)] was knocked down by [src]")
		log_attack("[key_name(target_mob)] was attacked by [src]")
		return target_mob
