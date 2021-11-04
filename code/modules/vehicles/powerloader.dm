/obj/vehicle/powerloader
	name = "\improper Caterpillar P-5000 Work Loader"
	icon = 'icons/obj/vehicles/powerloader.dmi'
	desc = "The Caterpillar P-5000 Work Loader is a commercial mechanized exoskeleton used for lifting heavy materials and objects, first designed in January 29, 2025 by Weyland Corporation. An old but trusted design used in warehouses, constructions and military ships everywhere."
	icon_state = "powerloader_open"
	layer = POWERLOADER_LAYER //so the top appears above windows and wall mounts
	anchored = 1
	density = 1
	luminosity = 5
	move_delay = 8
	buckling_y = 9
	health = 200
	maxhealth = 200
	pixel_x = -16
	pixel_y = -2
	var/base_state = "powerloader"
	var/open_state = "powerloader_open"
	var/overlay_state = "powerloader_overlay"
	var/wreckage = /obj/structure/powerloader_wreckage

/obj/vehicle/powerloader/Initialize()
	cell = new /obj/item/cell/apc
	for(var/i = 1, i <= 2, i++)
		var/obj/item/powerloader_clamp/PC = new(src)
		PC.linked_powerloader = src
	. = ..()

/obj/vehicle/powerloader/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated()) return
	if(world.time > l_move_time + move_delay)
		if(dir != direction)
			l_move_time = world.time
			setDir(direction)
			handle_rotation()
			pick(playsound(src.loc, 'sound/mecha/powerloader_turn.ogg', 25, 1), playsound(src.loc, 'sound/mecha/powerloader_turn2.ogg', 25, 1))
			. = TRUE
		else
			. = step(src, direction)
			if(.)
				pick(playsound(loc, 'sound/mecha/powerloader_step.ogg', 25), playsound(loc, 'sound/mecha/powerloader_step2.ogg', 25))

/obj/vehicle/powerloader/attack_hand(mob/user)
	if(buckled_mob && user != buckled_mob)
		buckled_mob.visible_message(SPAN_WARNING("[user] tries to move [buckled_mob] out of [src]."),\
		SPAN_DANGER("[user] tries to move you out of [src]!"))
		var/oldloc = loc
		var/olddir = dir
		var/old_buckled_mob = buckled_mob
		if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && dir == olddir && loc == oldloc && buckled_mob == old_buckled_mob)
			manual_unbuckle(user)
			playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 25)

/obj/vehicle/powerloader/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = W
		if(PC.linked_powerloader == src)
			unbuckle() //clicking the powerloader with its own clamp unbuckles the pilot.
			playsound(loc, 'sound/mecha/powerloader_unbuckle.ogg', 25)
			return 1
	. = ..()

/obj/vehicle/powerloader/afterbuckle(mob/M)
	. = ..()
	overlays.Cut()
	playsound(loc, 'sound/mecha/powerloader_buckle.ogg', 25)
	if(.)
		icon_state = base_state
		overlays += image(icon_state = overlay_state, layer = MOB_LAYER + 0.1)
		if(M.mind && M.skills)
			move_delay = max(4, move_delay - 2 * M.skills.get_skill_level(SKILL_POWERLOADER))
		var/clamp_equipped = 0
		for(var/obj/item/powerloader_clamp/PC in contents)
			if(!M.put_in_hands(PC)) PC.forceMove(src)
			else clamp_equipped++
		if(clamp_equipped != 2) unbuckle() //can't use the powerloader without both clamps equipped
	else
		move_delay = initial(move_delay)
		icon_state = open_state
		M.drop_held_items() //drop the clamp when unbuckling

/obj/vehicle/powerloader/buckle_mob(mob/M, mob/user)
	if(M != user) return
	if(!ishuman(M))	return
	var/mob/living/carbon/human/H = M
	if(!skillcheck(user, SKILL_POWERLOADER, SKILL_POWERLOADER_TRAINED))
		to_chat(H, SPAN_WARNING("You don't seem to know how to operate [src]."))
		return
	if(H.r_hand || H.l_hand)
		to_chat(H, SPAN_WARNING("You need your two hands to use [src]."))
		return
	. = ..()

/obj/vehicle/powerloader/verb/enter_powerloader(mob/M)
	set category = "Object"
	set name = "Enter Power Loader"
	set src in oview(1)

	buckle_mob(M, usr)

/obj/vehicle/powerloader/handle_rotation()
	if(buckled_mob)
		buckled_mob.setDir(dir)
		switch(dir)
			if(EAST) buckled_mob.pixel_x = 7
			if(WEST) buckled_mob.pixel_x = -7
			else buckled_mob.pixel_x = 0

/obj/vehicle/powerloader/explode()
	new wreckage(loc)
	playsound(loc, 'sound/effects/metal_crash.ogg', 75)
	..()

/obj/item/powerloader_clamp
	name = "\improper Power Loader Hydraulic Claw"
	icon = 'icons/obj/vehicles/vehicles.dmi'
	icon_state = "loader_clamp"
	force = 20
	flags_item = ITEM_ABSTRACT //to prevent placing the item on a table/closet.
								//We're controlling the clamp but the item isn't really in our hand.
	var/obj/vehicle/powerloader/linked_powerloader
	var/obj/loaded

/obj/item/powerloader_clamp/dropped(mob/user)
	if(!linked_powerloader)
		qdel(src)
	..()
	forceMove(linked_powerloader)
	if(linked_powerloader.buckled_mob && linked_powerloader.buckled_mob == user)
		linked_powerloader.unbuckle() //drop a clamp, you auto unbuckle from the powerloader.


/obj/item/powerloader_clamp/attack(mob/living/M, mob/living/user)
	if(M == linked_powerloader.buckled_mob)
		unbuckle() //if the pilot clicks themself with the clamp, it unbuckles them.
		return TRUE
	else
		return ..()

/obj/item/powerloader_clamp/afterattack(atom/target, mob/user, proximity)

	if(!proximity) return

	if(loaded)
		if(isturf(target))
			var/turf/T = target
			if(!T.density)
				for(var/atom/movable/AM in T.contents)
					if(AM.density)
						to_chat(user, SPAN_WARNING("You can't drop [loaded] here, [AM] blocks the way."))
						return
				if(loaded.bound_height > 32)
					var/turf/next_turf = get_step(T, NORTH)
					if(next_turf.density)
						to_chat(user, SPAN_WARNING("You can't drop [loaded] here, something blocks the way."))
						return
					for(var/atom/movable/AM in next_turf.contents)
						if(AM.density)
							to_chat(user, SPAN_WARNING("You can't drop [loaded] here, [AM] blocks the way."))
							return
				if(loaded.bound_width > 32)
					var/turf/next_turf = get_step(T, EAST)
					if(next_turf.density)
						to_chat(user, SPAN_WARNING("You can't drop [loaded] here, something blocks the way."))
						return
					for(var/atom/movable/AM in next_turf.contents)
						if(AM.density)
							to_chat(user, SPAN_WARNING("You can't drop [loaded] here, [AM] blocks the way."))
							return
				if(istype(loaded, /obj/structure/bed/chair))
					var/obj/structure/bed/chair/unloading_chair = loaded
					unloading_chair.dir = user.dir
					unloading_chair.update_overlays()
				user.visible_message(SPAN_NOTICE("[user] drops [loaded] on [T] with [src]."),
				SPAN_NOTICE("You drop [loaded] on [T] with [src]."))
				loaded.forceMove(T)
				loaded = null
				playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
				update_icon()

	else if(istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/C = target
		if(!C.anchored && !C.store_mobs)
			for(var/X in C)
				if(ismob(X)) //just in case.
					to_chat(user, SPAN_WARNING("Can't grab [loaded], it has a creature inside!"))
					return
			if(linked_powerloader)
				C.forceMove(linked_powerloader)
				loaded = C
				playsound(src, 'sound/machines/hydraulics_2.ogg', 40, 1)
				update_icon()
				user.visible_message(SPAN_NOTICE("[user] grabs [loaded] with [src]."),
				SPAN_NOTICE("You grab [loaded] with [src]."))
		else
			to_chat(user, SPAN_WARNING("Can't grab [loaded]."))

	else if(istype(target, /obj/structure/largecrate))
		var/obj/structure/largecrate/LC = target
		if(!LC.anchored)
			if(linked_powerloader)
				LC.forceMove(linked_powerloader)
				loaded = LC
				playsound(src, 'sound/machines/hydraulics_2.ogg', 40, 1)
				update_icon()
				user.visible_message(SPAN_NOTICE("[user] grabs [loaded] with [src]."),
				SPAN_NOTICE("You grab [loaded] with [src]."))
		else
			to_chat(user, SPAN_WARNING("Can't grab [loaded]."))

	else if(istype(target, /obj/structure/bed/chair))
		var/obj/structure/bed/chair/CS = target
		if(!CS.stacked_size)
			return
		if(linked_powerloader)
			CS.forceMove(linked_powerloader)
			loaded = CS
			playsound(src, 'sound/machines/hydraulics_2.ogg', 40, 1)
			update_icon()
			user.visible_message(SPAN_NOTICE("[user] grabs [loaded] with [src]."),
			SPAN_NOTICE("You grab [loaded] with [src]."))

/obj/item/powerloader_clamp/update_icon()
	if(loaded) icon_state = "loader_clamp_full"
	else icon_state = "loader_clamp"

/obj/item/powerloader_clamp/attack_self(mob/user)
	..()
	if(linked_powerloader)
		linked_powerloader.unbuckle()

/obj/structure/powerloader_wreckage
	name = "\improper Caterpillar P-5000 Work Loader wreckage"
	desc = "Remains of some unfortunate Power Loader. Completely unrepairable."
	icon = 'icons/obj/vehicles/powerloader.dmi'
	icon_state = "wreck"
	density = 1
	anchored = 0
	opacity = 0
	pixel_x = -18
	pixel_y = -5

/obj/structure/powerloader_wreckage/jd
	name = "\improper John Deere 4300 Power Loader wreckage"
	icon_state = "wreck_jd"

/obj/vehicle/powerloader/jd
	name = "\improper John Deere 4300 Power Loader"
	desc = "John Deere 4300 Work Loader is a commercial mechanized exoskeleton used for lifting heavy materials and objects based on the Caterpillar P-5000, first designed in January 29, 2025 by Weyland Corporation. An old but trusted design used in warehouses, constructions and military ships everywhere. This one has a signature green and yellow livery."
	icon_state = "powerloader_open_jd"
	base_state = "powerloader_jd"
	open_state = "powerloader_open_jd"
	overlay_state = "powerloader_overlay_jd"
	wreckage = /obj/structure/powerloader_wreckage/jd

