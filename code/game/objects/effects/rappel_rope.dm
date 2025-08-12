/obj/effect/rappel_rope
	name = "rope"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	icon_state = "rope"
	layer = ABOVE_LYING_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_ICON
	anchored = TRUE
	unacidable = TRUE
	var/obj/structure/dropship_equipment/rappel_system/linked_rappel = null
	var/is_hatch_rope = FALSE // true if this is the hatch rope


/obj/effect/rappel_rope/Initialize(mapload, ...)
	. = ..()

/obj/effect/rappel_rope/proc/handle_animation()
	if(is_hatch_rope)
		icon_state = "hatch_rope"
	else
		flick("rope_deploy", src)
		addtimer(CALLBACK(src, PROC_REF(set_icon_state), "rope"), 2 SECONDS)

/obj/effect/rappel_rope/proc/handle_animation_end()
	icon_state = "rope"

/obj/effect/rappel_rope/attack_hand(mob/living/carbon/human/user)
	if(!linked_rappel)
		return
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, SPAN_WARNING("You can't figure out how to use the rope."))
		return
	if(!linked_rappel.can_use_rappel(user))
		return
	var/turf/user_turf = get_turf(user)
	if(!user_turf || get_dist(user_turf, src.loc) > 1)
		to_chat(user, SPAN_WARNING("You must be next to the rope to use it."))
		return

	if(is_hatch_rope)
		in_use = TRUE
		icon_state = "hatch_rope"
		var/do_after_time = 100
		var/obj/effect/rappel_rope/target_rope = null
		if(linked_rappel.ground_ropes && length(linked_rappel.ground_ropes))
			var/list/available_ropes = list()
			for(var/obj/effect/rappel_rope/rope in linked_rappel.ground_ropes)
				var/occupied = FALSE
				for(var/mob/M in rope.loc)
					if(istype(M, /mob/living) && M != user)
						occupied = TRUE
						break
				if(!occupied)
					available_ropes += rope
			if(length(available_ropes))
				target_rope = pick(available_ropes)
				target_rope.icon_state = "rope_inuse"
		to_chat(user, SPAN_NOTICE("You begin climbing down the rope..."))
		var/success = do_after(user, do_after_time, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC, target = src)
		if(target_rope)
			target_rope.icon_state = "rope"
		if(success)
			if(target_rope)
				var/old_area = get_area(user)
				user.pixel_z = 32
				animate(user, time = 10, pixel_z = 0, flags = ANIMATION_PARALLEL)
				user.forceMove(target_rope.loc)
				var/new_area = get_area(user)
				update_dropship_hud_on_move(user, old_area, new_area)
				playsound(user, 'sound/items/rappel.ogg', 30, 1)
				target_rope.icon_state = "rope"
				user.visible_message(SPAN_NOTICE("[user] rappels down the rope!"))
			else
				if(linked_rappel.hatch_rope && linked_rappel.hatch_rope.loc)
					var/old_area = get_area(user)
					user.forceMove(linked_rappel.hatch_rope.loc)
					var/new_area = get_area(user)
					update_dropship_hud_on_move(user, old_area, new_area)
					user.visible_message(SPAN_NOTICE("[user] tried to climb down, but there was no rope!"))
		else
			to_chat(user, SPAN_WARNING("You were interrupted and let go of the rope!"))
		in_use = FALSE
		icon_state = "hatch_rope"
		if(linked_rappel.ground_ropes && length(linked_rappel.ground_ropes))
			for(var/obj/effect/rappel_rope/ground_rope in linked_rappel.ground_ropes)
				if(ground_rope.icon_state == "rope_inuse")
					ground_rope.icon_state = "rope"
	else
		if(in_use)
			to_chat(user, SPAN_WARNING("The rope is currently in use!"))
			return
		in_use = TRUE
		icon_state = "rope_inuse"
		to_chat(user, SPAN_NOTICE("You begin climbing up the rope..."))
		// Play authorized sound and message immediately when a human starts climbing
		playsound(linked_rappel, 'sound/machines/twobeep.ogg', 50, 1)
		linked_rappel.visible_message(SPAN_NOTICE("The [linked_rappel] beeps as it detects an authorized personnel!"))
		var/do_after_time = 80
		var/success = do_after(user, do_after_time, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC, target = src)
		if(success)
			if(linked_rappel.hatch_rope && linked_rappel.hatch_rope.loc)
				var/old_area = get_area(user)
				user.forceMove(linked_rappel.hatch_rope.loc)
				var/new_area = get_area(user)
				update_dropship_hud_on_move(user, old_area, new_area)
				user.visible_message(SPAN_NOTICE("[user] rappels up the rope!"))
		else
			to_chat(user, SPAN_WARNING("You were interrupted and let go of the rope!"))
		in_use = FALSE
		icon_state = "rope"

/obj/effect/rappel_rope/proc/set_icon_state(state)
	icon_state = state

/obj/effect/rappel_rope/proc/release_rope()
	in_use = FALSE
	icon_state = is_hatch_rope ? "hatch_rope" : "rope"

/obj/effect/rappel_rope/Destroy()
	flick("rope_up", src)
	spawn(5)
		..()
	return QDEL_HINT_IWILLGC

/obj/effect/rappel_rope/New(loc, is_hatch = FALSE)
	is_hatch_rope = is_hatch
	..()
	if(is_hatch_rope)
		icon_state = "hatch_rope"
	else
		icon_state = "rope"
		flick("rope_deploy", src)
		spawn(20)
			icon_state = "rope"

/obj/effect/rappel_rope/attack_alien(mob/living/carbon/xenomorph/user)
	if(!linked_rappel)
		return XENO_NO_DELAY_ACTION

	if(!user.can_ventcrawl())
		to_chat(user, SPAN_WARNING("You're too large to pull yourself up the rope!"))
		return XENO_NO_DELAY_ACTION

	var/turf/user_turf = get_turf(user)
	if(!user_turf || get_dist(user_turf, src.loc) > 1)
		to_chat(user, SPAN_WARNING("You must be next to the rope to use it."))
		return XENO_NO_DELAY_ACTION

	if(is_hatch_rope)
		in_use = TRUE
		icon_state = "hatch_rope"
		var/do_after_time = 40
		var/obj/effect/rappel_rope/target_rope = null
		if(linked_rappel.ground_ropes && length(linked_rappel.ground_ropes))
			var/list/available_ropes = list()
			for(var/obj/effect/rappel_rope/rope in linked_rappel.ground_ropes)
				var/occupied = FALSE
				for(var/mob/M in rope.loc)
					if(istype(M, /mob/living) && M != user)
						occupied = TRUE
						break
				if(!occupied)
					available_ropes += rope
			if(length(available_ropes))
				target_rope = pick(available_ropes)
				target_rope.icon_state = "rope_inuse"
		to_chat(user, SPAN_NOTICE("You begin crawling down the rope..."))
		var/success = do_after(user, do_after_time, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC, target = src)
		if(target_rope)
			target_rope.icon_state = "rope"
		if(success)
			if(target_rope)
				var/old_area = get_area(user)
				user.pixel_z = 32
				animate(user, time = 10, pixel_z = 0, flags = ANIMATION_PARALLEL)
				user.forceMove(target_rope.loc)
				var/new_area = get_area(user)
				update_dropship_hud_on_move(user, old_area, new_area)
				playsound(user, 'sound/items/rappel.ogg', 30, 1)
				target_rope.icon_state = "rope"
				user.visible_message(SPAN_NOTICE("[user] swiftly scales down the rope!"))
			else
				if(linked_rappel.hatch_rope && linked_rappel.hatch_rope.loc)
					var/old_area = get_area(user)
					user.forceMove(linked_rappel.hatch_rope.loc)
					var/new_area = get_area(user)
					update_dropship_hud_on_move(user, old_area, new_area)
					user.visible_message(SPAN_NOTICE("[user] tried to crawl down, but there was no rope!"))
		else
			to_chat(user, SPAN_WARNING("You were interrupted and let go of the rope!"))
		in_use = FALSE
		icon_state = "hatch_rope"
		if(linked_rappel.ground_ropes && length(linked_rappel.ground_ropes))
			for(var/obj/effect/rappel_rope/ground_rope in linked_rappel.ground_ropes)
				if(ground_rope.icon_state == "rope_inuse")
					ground_rope.icon_state = "rope"
	else
		if(in_use)
			to_chat(user, SPAN_WARNING("The rope is currently in use!"))
			return
		in_use = TRUE
		icon_state = "rope_inuse"
		// Play warning sound and message immediately when a xeno starts climbing
		playsound(linked_rappel, 'sound/machines/beepalert.ogg', 50, 1)
		linked_rappel.visible_message(SPAN_WARNING("The [linked_rappel] beeps as it detects an unknown signature!"))
		to_chat(user, SPAN_NOTICE("You begin crawling up the rope..."))
		var/do_after_time = 30
		var/success = do_after(user, do_after_time, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC, target = src)
		if(success)
			if(linked_rappel.hatch_rope && linked_rappel.hatch_rope.loc)
				var/old_area = get_area(user)
				user.forceMove(linked_rappel.hatch_rope.loc)
				var/new_area = get_area(user)
				update_dropship_hud_on_move(user, old_area, new_area)
				user.visible_message(SPAN_NOTICE("[user] quickly crawls up the rope!"))
		else
			to_chat(user, SPAN_WARNING("You were interrupted and let go of the rope!"))
		in_use = FALSE
		icon_state = "rope"

	return XENO_NONCOMBAT_ACTION
