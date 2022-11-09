#define BASE_EXTINGUISHER_PWR 7
#define PYRO_EXTINGUISHER_PWR 48

/obj/item/tool/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	pickupsound = 'sound/handling/wrench_pickup.ogg'
	dropsound = 'sound/handling/wrench_drop.ogg'
	flags_atom = FPRINT|CONDUCT
	throwforce = 10
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 10.0
	flags_equip_slot = SLOT_WAIST
	matter = list("metal" = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	var/max_water = 50
	var/last_use = 1.0
	var/safety = 1
	var/sprite_name = "fire_extinguisher"
	var/power = BASE_EXTINGUISHER_PWR

/obj/item/tool/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	throwforce = 2
	w_class = SIZE_SMALL
	force = 3
	max_water = 30
	sprite_name = "miniFE"

/obj/item/tool/extinguisher/mini/integrated_flamer
	max_water = 60

// A solely internal extinguisher
/obj/item/tool/extinguisher/pyro
	name = "fire extinguisher"
	desc = "A heavy-duty fire extinguisher designed for extreme fires."
	w_class = SIZE_MEDIUM
	force = 3.0
	max_water = 500
	power = PYRO_EXTINGUISHER_PWR

/obj/item/tool/extinguisher/pyro/atmos_tank
	max_water = 500000 //so it never runs out, theoretically

/obj/item/tool/extinguisher/Initialize()
	. = ..()
	create_reagents(max_water)
	reagents.add_reagent("water", max_water)

/obj/item/tool/extinguisher/get_examine_text(mob/user)
	. = ..()
	. += "It contains [reagents.total_volume] units of water left!"

/obj/item/tool/extinguisher/attack_self(mob/user)
	..()
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	to_chat(user, "The safety is [safety ? "on" : "off"].")

/obj/item/tool/extinguisher/attack(mob/living/M, mob/living/user)
	if (M == user && !safety && reagents && reagents.total_volume > EXTINGUISHER_WATER_USE_AMT)
		return FALSE
	else
		return ..()

/obj/item/tool/extinguisher/afterattack(atom/target, mob/user , flag)
	if(istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(user,target) <= 1)
		var/obj/o = target
		o.reagents.trans_to(src, 50)
		to_chat(user, SPAN_NOTICE(" \The [src] is now refilled"))
		playsound(user, 'sound/effects/refill.ogg', 25, 1, 3)
		return

	if(safety || (!isturf(target) && !isturf(target.loc)))
		return ..()

	if(src.reagents.total_volume < 1)
		to_chat(usr, SPAN_DANGER("\The [src] is empty."))
		return

	if(world.time < src.last_use + 20)
		return

	src.last_use = world.time

	playsound(user, 'sound/effects/extinguish.ogg', 52, 1, 7)

	if(target == user)
		if(!isliving(user))
			return
		var/mob/living/M = user
		M.ExtinguishMob()
		var/obj/effect/particle_effect/water/water_effect = new /obj/effect/particle_effect/water(get_turf(user))
		QDEL_IN(water_effect, 1 SECONDS)
		reagents.total_volume -= EXTINGUISHER_WATER_USE_AMT
		return

	var/direction = get_dir(user, target)

	if(user.buckled && isobj(user.buckled) && !user.buckled.anchored)
		spawn(0)
			var/obj/structure/bed/chair/C = null
			if(istype(user.buckled, /obj/structure/bed/chair))
				C = user.buckled
			var/obj/B = user.buckled
			var/movementdirection = turn(direction,180)
			if(C)
				C.propelled = 4
			B.Move(get_step(user,movementdirection), movementdirection)
			sleep(1)
			B.Move(get_step(user,movementdirection), movementdirection)
			if(C)
				C.propelled = 3
			sleep(1)
			B.Move(get_step(user,movementdirection), movementdirection)
			sleep(1)
			B.Move(get_step(user,movementdirection), movementdirection)
			if(C)
				C.propelled = 2
			sleep(2)
			B.Move(get_step(user,movementdirection), movementdirection)
			if(C)
				C.propelled = 1
			sleep(2)
			B.Move(get_step(user,movementdirection), movementdirection)
			if(C)
				C.propelled = 0
			sleep(3)
			B.Move(get_step(user,movementdirection), movementdirection)
			sleep(3)
			B.Move(get_step(user,movementdirection), movementdirection)
			sleep(3)
			B.Move(get_step(user,movementdirection), movementdirection)

	var/turf/T = get_turf(target)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))

	var/list/targets = list(T, T1, T2)
	var/list/unpicked_targets = list()

	for(var/a in 0 to (EXTINGUISHER_WATER_USE_AMT-1))
		if (!unpicked_targets.len)
			unpicked_targets += targets
		var/turf/TT = pick(unpicked_targets)
		unpicked_targets -= TT
		INVOKE_ASYNC(src, .proc/release_liquid, TT, user)

	if(istype(user.loc, /turf/open/space) || (user.lastarea && user.lastarea.has_gravity == 0))
		user.inertia_dir = get_dir(target, user)
		step(user, user.inertia_dir)
	return

/obj/item/tool/extinguisher/proc/release_liquid(var/turf/target, var/mob/user)
	var/turf/T = get_turf(user)
	var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(T)
	W.create_reagents(5)
	reagents.trans_to(W, 1)
	for(var/b in 0 to (5-1))
		step_towards(W, target)
		if (!W || QDELETED(W))
			return
		else if (!W.reagents || get_turf(W) == T)
			break
		W.reagents.reaction(get_turf(W))
		for(var/atom/atm in get_turf(W))
			if(!W)
				return
			if(!W.reagents)
				break
			W.reagents.reaction(atm)
			if(istype(atm, /obj/flamer_fire))
				var/obj/flamer_fire/FF = atm
				if((FF.firelevel > power) && (!FF.fire_variant)) //If fire_variant = 0, default fire extinguish behavior.
					FF.firelevel -= power
					FF.update_flame()
				else //See: aliens.dm acid extinguishing behavior for more variant cases if needed.
					qdel(atm)
				continue
			if(isliving(atm)) //For extinguishing mobs on fire
				var/mob/living/M = atm
				M.ExtinguishMob()
			if(iscarbon(atm) || istype(atm, /obj/structure/barricade))
				atm.extinguish_acid()
		T = get_turf(W)
		if(T == target)
			break
		sleep(2)
	qdel(W)

#undef BASE_EXTINGUISHER_PWR
#undef PYRO_EXTINGUISHER_PWR
