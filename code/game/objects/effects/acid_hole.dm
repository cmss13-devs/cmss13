/obj/effect/acid_hole
	name = "hole"
	desc = "What could have done this?"
	icon = 'icons/effects/new_acid.dmi'
	icon_state = "hole_0"
	anchored = TRUE
	unacidable = TRUE
	layer = LOWER_ITEM_LAYER
	var/turf/closed/wall/holed_wall

/obj/effect/acid_hole/Initialize()
	. = ..()
	if(istype(loc, /turf/closed/wall))
		var/turf/closed/wall/W = loc
		W.acided_hole = src
		holed_wall = W
		holed_wall.opacity = FALSE
		setDir(W.acided_hole_dir)

/obj/effect/acid_hole/Destroy()
	if(holed_wall)
		holed_wall.opacity = initial(holed_wall.opacity)
		holed_wall.acided_hole = null
		holed_wall = null
	. = ..()

/obj/effect/acid_hole/ex_act(severity)
	return

/obj/effect/acid_hole/fire_act()
	return


/obj/effect/acid_hole/MouseDrop_T(mob/M, mob/user)
	if (!holed_wall)
		return

	if(M == user && isxeno(user))
		use_wall_hole(user)


/obj/effect/acid_hole/attack_alien(mob/living/carbon/xenomorph/user)
	if(!holed_wall)
		qdel(src) //no wall?! then cease existence...
		return

	if(!use_wall_hole(user))
		if(user.mob_size >= MOB_SIZE_BIG)
			expand_hole(user)
			return XENO_NO_DELAY_ACTION

/obj/effect/acid_hole/attack_larva(mob/living/carbon/xenomorph/larva/M)
	attack_alien(M)

/obj/effect/acid_hole/proc/expand_hole(mob/living/carbon/xenomorph/user)
	if(user.action_busy || user.is_mob_incapacitated())
		return

	playsound(src, "pry", 25, 1)
	xeno_attack_delay(user)
	if(do_after(user, 60, INTERRUPT_ALL, BUSY_ICON_GENERIC) && !QDELETED(src) && holed_wall && istype(holed_wall))
		holed_wall.take_damage(rand(2000,3500))
		user.emote("roar")

/obj/effect/acid_hole/proc/use_wall_hole(mob/living/user)

	if(user.mob_size >= MOB_SIZE_BIG || user.is_mob_incapacitated() || user.buckled || user.anchored)
		return FALSE

	var/mob_dir = get_dir(user, src)
	var/crawl_dir = dir & mob_dir
	if(!crawl_dir)
		crawl_dir = turn(dir,180) & mob_dir
	if(!crawl_dir)
		return

	var/entrance_dir = crawl_dir ^ mob_dir

	var/turf/T = get_step(src, crawl_dir)

	if (!T || T.density)
		to_chat(user, "This hole leads nowhere!")
		return

	if(entrance_dir)
		if(!step(user, entrance_dir))
			to_chat(user, SPAN_WARNING("You can't reach the hole's entrance."))
			return

	for(var/obj/O in T)
		if(O.BlockedPassDirs(user, crawl_dir))
			to_chat(user, SPAN_WARNING("The hole's exit is blocked by something!"))
			return

	if(user.action_busy)
		return

	to_chat(user, SPAN_NOTICE("You start crawling through the hole."))

	if(do_after(user, 15, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		if(!user.is_mob_incapacitated() && !user.buckled)
			if (T.density)
				return
			for(var/obj/O in T)
				if(O.BlockedPassDirs(user, crawl_dir))
					return
			if(user.pulling)
				user.stop_pulling()
				to_chat(user, SPAN_WARNING("You release what you're pulling to fit into the tunnel!"))
			user.forceMove(T)

			// If the wall is on fire, ignite the xeno.
			var/turf/wall = get_turf(src)
			var/obj/flamer_fire/fire = locate(/obj/flamer_fire) in wall

			if (fire)
				user.handle_flamer_fire_crossed(fire)


//Throwing Shiet
/obj/effect/acid_hole/attackby(obj/item/W, mob/user)

	var/mob_dir = get_dir(user, src)
	var/crawl_dir = dir & mob_dir
	if(!crawl_dir)
		crawl_dir = turn(dir,180) & mob_dir
	if(!crawl_dir)
		return
	var/turf/Target = get_step(src, crawl_dir)

	//Throwing Grenades
	if(istype(W,/obj/item/explosive/grenade))
		var/obj/item/explosive/grenade/G = W

		if(!Target ||Target.density)
			to_chat(user, SPAN_WARNING("This hole leads nowhere!"))
			return

		to_chat(user, SPAN_NOTICE("You take the position to throw [G]."))
		if(do_after(user,10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(Target.density)
				return
			user.visible_message(SPAN_WARNING("[user] throws [G] through [src]!"),
								SPAN_WARNING("You throw [G] through [src]"))
			user.drop_held_item()
			G.forceMove(Target)
			G.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			step_away(G,src,rand(2,5))
			if(!G.active)
				G.activate(user)
		return

	//Throwing Flares and flashlights
	else if(istype(W,/obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = W

		if(!Target ||Target.density)
			to_chat(user, SPAN_WARNING("This hole leads nowhere!"))
			return

		to_chat(user, SPAN_NOTICE("You take the position to throw [F]."))
		if(do_after(user,10, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(Target.density)
				return
			user.visible_message(SPAN_WARNING("[user] throws [F] through [src]!"),
								SPAN_WARNING("You throw [F] through [src]"))
			user.drop_held_item()
			F.forceMove(Target)
			F.setDir(pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
			step_away(F,src,rand(1,5))
			F.set_light(0)
			if(F.on && loc != user)
				F.set_light_on(F.on)
		return
