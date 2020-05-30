/obj/item/tool/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
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

/obj/item/tool/extinguisher/mini
	name = "fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	throwforce = 2
	w_class = SIZE_SMALL
	force = 3.0
	max_water = 30
	sprite_name = "miniFE"

/obj/item/tool/extinguisher/Initialize()
	. = ..()
	create_reagents(max_water)
	reagents.add_reagent("water", max_water)

/obj/item/tool/extinguisher/examine(mob/user)
	..()
	to_chat(user, "It contains [reagents.total_volume] units of water left!")

/obj/item/tool/extinguisher/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The safety is [safety ? "on" : "off"]."
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

/obj/item/tool/extinguisher/attack(mob/living/M, mob/living/user, def_zone)
	if (M == user && !safety && reagents && reagents.total_volume > EXTINGUISHER_WATER_USE_AMT)
		return FALSE
	else
		return ..()

/obj/item/tool/extinguisher/afterattack(atom/target, mob/user , flag)
	if(istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(src,target) <= 1)
		var/obj/o = target
		o.reagents.trans_to(src, 50)
		to_chat(user, SPAN_NOTICE(" \The [src] is now refilled"))
		playsound(src.loc, 'sound/effects/refill.ogg', 25, 1, 3)
		return

	if(safety)
		return ..()
	
	if(src.reagents.total_volume < 1)
		to_chat(usr, SPAN_DANGER("\The [src] is empty."))
		return

	if(world.time < src.last_use + 20)
		return

	src.last_use = world.time

	playsound(src.loc, 'sound/effects/extinguish.ogg', 52, 1, 7)

	var/direction = get_dir(src, target)

	if(usr.buckled && isobj(usr.buckled) && !usr.buckled.anchored)
		spawn(0)
			var/obj/structure/bed/chair/C = null
			if(istype(usr.buckled, /obj/structure/bed/chair))
				C = usr.buckled
			var/obj/B = usr.buckled
			var/movementdirection = turn(direction,180)
			if(C)
				C.propelled = 4
			B.Move(get_step(usr,movementdirection), movementdirection)
			sleep(1)
			B.Move(get_step(usr,movementdirection), movementdirection)
			if(C)
				C.propelled = 3
			sleep(1)
			B.Move(get_step(usr,movementdirection), movementdirection)
			sleep(1)
			B.Move(get_step(usr,movementdirection), movementdirection)
			if(C)
				C.propelled = 2
			sleep(2)
			B.Move(get_step(usr,movementdirection), movementdirection)
			if(C)
				C.propelled = 1
			sleep(2)
			B.Move(get_step(usr,movementdirection), movementdirection)
			if(C)
				C.propelled = 0
			sleep(3)
			B.Move(get_step(usr,movementdirection), movementdirection)
			sleep(3)
			B.Move(get_step(usr,movementdirection), movementdirection)
			sleep(3)
			B.Move(get_step(usr,movementdirection), movementdirection)

	if(target == user)
		if(!isliving(user))
			return
		var/mob/living/M = user
		M.ExtinguishMob()
		new /obj/effect/particle_effect/water(get_turf(user))
		reagents.total_volume -= EXTINGUISHER_WATER_USE_AMT
		return

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
		INVOKE_ASYNC(src, .proc/release_liquid, TT)

	if(istype(usr.loc, /turf/open/space) || (usr.lastarea && usr.lastarea.has_gravity == 0))
		user.inertia_dir = get_dir(target, user)
		step(user, user.inertia_dir)
	return

/obj/item/tool/extinguisher/proc/release_liquid(var/turf/target)
	var/turf/T = get_turf(src)
	var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(T)
	W.create_reagents(5)
	reagents.trans_to(W, 1)
	for(var/b in 0 to (5-1))
		step_towards(W, target)
		if (!W || W.disposed) 
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
				if(FF.firelevel > 7)
					FF.firelevel -= 7
					FF.updateicon()
				else
					qdel(atm)
				continue
			if(isliving(atm)) //For extinguishing mobs on fire
				var/mob/living/M = atm
				M.ExtinguishMob()
				for(var/obj/item/clothing/mask/cigarette/C in M.contents)
					if(C.item_state == C.icon_on)
						C.die()
			if(iscarbon(atm) || istype(atm, /obj/structure/barricade))
				atm.extinguish_acid()
		T = get_turf(W)
		if(T == target) 
			break
		sleep(2)
	qdel(W)
