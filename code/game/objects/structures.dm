/obj/structure
	icon = 'icons/obj/structures/structures.dmi'
	var/climbable
	var/climb_delay = 50
	var/breakable
	var/parts
	var/list/debris = list()
	var/unslashable = FALSE
	var/wrenchable = FALSE
	health = 100
	anchored = 1
	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM
	can_block_movement = TRUE

/obj/structure/New()
	..()
	structure_list += src

	if(climbable)
		verbs += /obj/structure/proc/climb_on

/obj/structure/Dispose()
	//before ..() because the parent does loc = null
	for(var/atom/movable/A in contents_recursive())
		var/obj/O = A
		if(!istype(O))
			continue
		if(O.unacidable)
			O.forceMove(get_turf(loc))
	structure_list -= src
	. = ..()

/obj/structure/proc/destroy(deconstruct)
	if(parts)
		new parts(loc)
	density = 0
	qdel(src)

/obj/structure/attack_animal(mob/living/user)
	if(breakable)
		if(user.wall_smash)
			visible_message(SPAN_DANGER("[user] smashes [src] apart!"))
			destroy()

/obj/structure/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		toggle_anchored(W, user)
		return TRUE
	..()

/obj/structure/ex_act(severity, direction)
	if(indestructible)
		return

	if(src.health) //Prevents unbreakable objects from being destroyed
		src.health -= severity
		if(src.health <= 0)
			handle_debris(severity, direction)
			qdel(src)

/obj/structure/proc/handle_debris(severity = 0, direction = 0)
	if(!debris.len)
		return
	switch(severity)
		if(0)
			for(var/thing in debris)
				new thing(loc)
		if(0 to EXPLOSION_THRESHOLD_HIGH) //beyond EXPLOSION_THRESHOLD_HIGH, the explosion is too powerful to create debris. It's all atomized.
			for(var/thing in debris)
				var/obj/item/I = new thing(loc)
				I.explosion_throw(severity, direction)

/obj/structure/proc/climb_on()

	set name = "Climb structure"
	set desc = "Climbs onto a structure."
	set category = "Object"
	set src in oview(1)

	do_climb(usr)

/obj/structure/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //No making other people climb onto tables.
		return

	do_climb(target)

/obj/structure/proc/can_climb(var/mob/living/user)
	if(!climbable || !can_touch(user))
		return FALSE

	var/turf/T = get_turf(src)
	if(flags_atom & ON_BORDER)
		T = get_step(get_turf(src), dir)
		if(user.loc == T)
			T = get_turf(src)

	var/turf/U = get_turf(user)
	if(!istype(T) || !istype(U)) 
		return FALSE

	user.add_temp_pass_flags(PASS_MOB_THRU, PASS_OVER_THROW_MOB)
	var/atom/blocker = LinkBlocked(user, U, T, list(src))
	user.remove_temp_pass_flags(PASS_MOB_THRU, PASS_OVER_THROW_MOB)

	if(blocker)
		to_chat(user, SPAN_WARNING("\The [blocker] prevents you from climbing [src]."))
		return FALSE
	
	return TRUE

/obj/structure/proc/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message(SPAN_WARNING("[user] starts [flags_atom & ON_BORDER ? "leaping over":"climbing onto"] \the [src]!"))

	if(!do_after(user, climb_delay, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return

	if(!can_climb(user))
		return

	var/turf/TT = get_turf(src)
	if(flags_atom & ON_BORDER)
		TT = get_step(get_turf(src), dir)
		if(user.loc == TT)
			TT = get_turf(src)
	
	user.visible_message(SPAN_WARNING("[user] climbs onto \the [src]!"))
	user.forceMove(TT)

/obj/structure/proc/structure_shaken()

	for(var/mob/living/M in get_turf(src))

		if(M.lying) return //No spamming this on people.

		M.KnockDown(5)
		to_chat(M, SPAN_WARNING("You topple as \the [src] moves under you!"))

		if(prob(25))

			var/damage = rand(15,30)
			var/mob/living/carbon/human/H = M
			if(!istype(H))
				to_chat(H, SPAN_DANGER("You land heavily!"))
				M.apply_damage(damage, BRUTE)
				return

			var/obj/limb/affecting

			switch(pick(list("ankle","wrist","head","knee","elbow")))
				if("ankle")
					affecting = H.get_limb(pick("l_foot", "r_foot"))
				if("knee")
					affecting = H.get_limb(pick("l_leg", "r_leg"))
				if("wrist")
					affecting = H.get_limb(pick("l_hand", "r_hand"))
				if("elbow")
					affecting = H.get_limb(pick("l_arm", "r_arm"))
				if("head")
					affecting = H.get_limb("head")

			if(affecting)
				to_chat(M, SPAN_DANGER("You land heavily on your [affecting.display_name]!"))
				affecting.take_damage(damage, 0)
				if(affecting.parent)
					affecting.parent.add_autopsy_data("Misadventure", damage)
			else
				to_chat(H, SPAN_DANGER("You land heavily!"))
				H.apply_damage(damage, BRUTE)

			H.UpdateDamageIcon()
			H.updatehealth()
	return

/obj/structure/proc/can_touch(mob/user)
	if(!user)
		return 0
	if(!Adjacent(user) || !isturf(user.loc))
		return 0
	if(user.is_mob_restrained() || user.buckled)
		to_chat(user, SPAN_NOTICE("You need your hands and legs free for this."))
		return 0
	if(user.is_mob_incapacitated(TRUE) || user.lying)
		return 0
	if(isRemoteControlling(user))
		to_chat(user, SPAN_NOTICE("You need hands for this."))
		return 0
	return 1

/obj/structure/proc/toggle_anchored(obj/item/W, mob/user)
	if(!wrenchable)
		to_chat(user, SPAN_WARNING("The [src] cannot be [anchored ? "un" : ""]anchored."))
		return FALSE
	else
		// Wrenching is faster if we are better at engineering
		var/timer = max(10, 40 - user.skills.get_skill_level(SKILL_ENGINEER) * 10)
		if(do_after(usr, timer, INTERRUPT_ALL, BUSY_ICON_BUILD))
			anchored = !anchored
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			if(anchored)
				user.visible_message(SPAN_NOTICE("[user] anchors [src] into place."),SPAN_NOTICE("You anchor [src] into place."))
			else
				user.visible_message(SPAN_NOTICE("[user] unanchors [src]."),SPAN_NOTICE("You unanchor [src]."))
			return TRUE