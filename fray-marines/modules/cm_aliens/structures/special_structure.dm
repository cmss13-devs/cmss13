/obj/structure/alien
	name = "alien building"
	desc = "Building that's alien"
	icon = 'fray-marines/icons/obj/structures/alien/Buildings.dmi'
	icon_state = "sunken"
	density = TRUE
	pixel_x = -16

	// var/xeno_tag = null				//see misc.dm

	health = 500
	var/maxHealth = 500

	var/dying = 0
	var/last_heal = 0
	var/heal = 40
	var/datum/hive_status/hive

/obj/structure/alien/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	hive = GLOB.hive_datum[XENO_HIVE_NORMAL]

/obj/structure/alien/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/structure/alien/flamer_fire_act()
	health -= 50
	healthcheck()

/obj/structure/alien/process(delta_time)
	if(dying)
		if(locate(/obj/effect/alien/weeds) in src.loc)
			dying = 0
		health = max(0, health-(25 * delta_time))
		if(health <= 0)
			die()
			return ..()
	if(health > maxHealth)
		health = maxHealth
	if(!(locate(/obj/effect/alien/weeds) in src.loc))
		dying = 1

	update_icon()

	if(world.time >= last_heal + heal && health < maxHealth && !dying)
		health += 5						//slowly regenerate on weed
		last_heal = world.time
	return 1

/obj/structure/alien/ex_act(severity)
	switch(severity)
		if(1)
			die()
		if(2,3)
			health -= rand(200 * (4-severity))
			healthcheck()

/obj/structure/alien/bullet_act(obj/item/projectile/P)
	health -= max(0, P.damage)
	bullet_ping(P)
	healthcheck()

/obj/structure/alien/proc/healthcheck()
	if(health <= 0)
		die()
		return
	if(health>=maxHealth)
		health = maxHealth

/obj/structure/alien/proc/die()
	visible_message("<span class='xenodanger'>[src] explodes into bloody gore!</span>")
	xgibs(src.loc)
	qdel(src)

// /obj/structure/alien/attack_alien(mob/living/carbon/xenomorph/M)
// 	if(islarva(M)) //Larvae can't do shit
// 		return

// 	if(M.a_intent == INTENT_HELP)
// 		return XENO_NO_DELAY_ACTION
// 	else
// 		M.animation_attack_on(src)
// 		M.visible_message(SPAN_XENONOTICE("\The [M] claws \the [src]!"), \
// 		SPAN_XENONOTICE("You claw \the [src]."))
// 		if(istype(src, /obj/effect/alien/resin/sticky))
// 			playsound(loc, "alien_resin_move", 25)
// 		else
// 			playsound(loc, "alien_resin_break", 25)

// 		health -= (M.melee_damage_upper + 50) //Beef up the damage a bit
// 		healthcheck()
// 	return XENO_ATTACK_ACTION

//Sunken Colony
/obj/structure/alien/sunken
	name = "Sunken Colony"
	desc = "A living stationary organism that strikes from below with its powerful claw."
	pixel_y = -8

	var/cooldown = 10 SECONDS
	var/can_attack = 1

	// xeno_tag = SUNKEN_COLONY

/obj/structure/alien/sunken/update_icon()
	if(health <= maxHealth/2)
		icon_state = "s_weak"
	else
		icon_state = "sunken"

/obj/structure/alien/sunken/process()
	. = ..()
	if(!.)
		return

	if(!can_attack)
		return

	var/turf/target = get_target()

	if (!target)
		return

	process_cooldown()
	strike(target)

/obj/structure/alien/sunken/proc/get_target()
	var/list/targets = list()

	for(var/atom/movable/targ in orange(7, src))
		var/turf/T = get_turf(targ)
		if(!T.can_dig_xeno_tunnel() || !is_ground_level(T.z) || get_dist(src, T) <= 3)
			continue
		if(ishuman(targ))
			var/mob/living/carbon/human/H = targ
			if(locate(/obj/item/alien_embryo) in H)
				continue
			if(!H.stat)
				targets += T

	if (targets.len > 0)
		return pick(targets)

	return null

/obj/structure/alien/sunken/proc/strike(turf/target)
	if(!istype(target))
		return 0
	if(!target)
		return 0

	visible_message("<span class='xenodanger'>[src] is about to strike!</span>")
	flick("s_hitting",src)

	var/obj/effect/impaler/I = new /obj/effect/impaler(target)
	addtimer(CALLBACK(I, PROC_REF(strike)), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(process_cooldown)), cooldown)

	return 1

/obj/structure/alien/sunken/proc/process_cooldown()
	can_attack = !can_attack

/obj/effect/impaler
	name = "impaling chitin"
	icon = 'fray-marines/icons/obj/structures/alien/Buildings.dmi'
	icon_state = "s_incoming"
	var/damage = 120

/obj/effect/impaler/Initialize(mapload, ...)
	. = ..()
	visible_message(SPAN_HIGHDANGER("Ground starts to rumble!"))
	playsound(loc, "alien_bite", 25, 1)

/obj/effect/impaler/proc/strike()
	icon_state = "strike"
	for(var/mob/living/carbon/human/L in src.loc)
		to_chat(L, "<span class='danger'>You've been hit by [src] from below!</span>")
		var/obj/limb/affecting = L.get_limb(pick("r_leg", "l_leg"))
		var/armor = L.getarmor_organ(affecting, ARMOR_MELEE)
		var/damage_result = armor_damage_reduction(GLOB.marine_melee, damage, armor, 0)
		L.apply_damage(damage_result, BRUTE, affecting, 0) //This should slicey dicey
		L.updatehealth()

	playsound(loc, "alien_bite", 25, 1)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), 5)
