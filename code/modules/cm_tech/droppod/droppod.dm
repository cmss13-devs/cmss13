/obj/structure/droppod
	name = "\improper droppod"

	icon = 'icons/obj/structures/droppod_32x64.dmi'
	icon_state = "techpod_closed"
	health = 350

	climbable = TRUE
	climb_delay = 2

	density = FALSE
	wrenchable = TRUE

	var/droppod_flags = NO_FLAGS

	var/land_damage = 5000
	var/tiles_to_take = 15

	var/drop_time = 0
	var/dropping_time = 2 SECONDS
	var/open_time = 3 SECONDS

	var/open_sound = 'sound/machines/techpod/techpod_open.ogg'
	var/close_sound = 'sound/machines/techpod/techpod_toggle.ogg'
	var/landing_sound = 'sound/machines/techpod/techpod_drilling.ogg'
	var/land_sound = 'sound/machines/techpod/techpod_hit.ogg'

	layer = ABOVE_FLY_LAYER
	var/land_layer = MOB_LAYER
	appearance_flags = TILE_BOUND | KEEP_TOGETHER

	var/obj/effect/warning/droppod/warning_zone

/obj/structure/droppod/proc/launch(var/turf/T)
	if(!forceMove(T))
		return

	invisibility = 101
	droppod_flags &= ~(DROPPOD_RETURNING|DROPPOD_DROPPED|DROPPOD_DROPPING)

	warn_turf(loc)
	addtimer(CALLBACK(src, .proc/drop_on_target, loc), drop_time)
	update_icon()


/obj/structure/droppod/Destroy()
	if(warning_zone)
		qdel(warning_zone)
		warning_zone = null
	return ..()

/obj/structure/droppod/update_icon()
	overlays.Cut()
	if(!(droppod_flags & DROPPOD_DROPPED))
		overlays += image(icon, src, "chute_cables_static")
		var/image/I = image('icons/obj/structures/droppod_64x64.dmi', src, "chute_static")

		I.pixel_x -= 16
		I.pixel_y += 16

		overlays += I

	if(droppod_flags & DROPPOD_OPEN)
		icon_state = "techpod_open"
	else
		icon_state = "techpod_closed"

	if(droppod_flags & DROPPOD_STRIPPED)
		icon_state = "[icon_state]_stripped"

/obj/structure/droppod/attackby(obj/item/W, mob/user)
	if(!ishuman(user))
		return . = ..()

	var/mob/living/carbon/human/H = user

	if(H.action_busy)
		return . = ..()

	/*
	if(droppod_flags & DROPPOD_STRIPPED)
		return . = ..()

	if(iscrowbar(W))
		visible_message(SPAN_NOTICE("[H] begins to pry off the external plating on [src]."))
		playsound(loc, 'sound/items/Crowbar.ogg', 75)

		if(!do_after(H, 5 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src, INTERRUPT_ALL))
			return

		if(droppod_flags & DROPPOD_STRIPPED)
			return

		visible_message(SPAN_NOTICE("[H] pries off the external plating on [src]."))
		droppod_flags |= DROPPOD_STRIPPED

		new/obj/item/stack/sheet/metal/small_stack(loc)
		new/obj/item/stack/sheet/plasteel(loc, 5)

		update_icon()
	else
		. = ..()
	*/
	. = ..()

/obj/structure/droppod/proc/open(mob/user)
	playsound(loc, open_sound, sound_range = 8)

	droppod_flags |= DROPPOD_OPEN
	update_icon()

/obj/structure/droppod/proc/close(mob/user)
	playsound(loc, close_sound, sound_range = 8)

	droppod_flags &= ~DROPPOD_OPEN
	update_icon()

/obj/structure/droppod/proc/warn_turf(var/turf/T)
	if(warning_zone)
		qdel(warning_zone)

	warning_zone = new(T)

/obj/structure/droppod/proc/drop_on_target(var/turf/T)
	droppod_flags |= DROPPOD_DROPPING

	invisibility = 0

	pixel_y = 32*tiles_to_take
	playsound(loc, landing_sound, 100, TRUE, 15)
	animate(src, pixel_y = 0, time = dropping_time, easing = LINEAR_EASING)

	addtimer(CALLBACK(src, .proc/land, T), dropping_time)

/obj/structure/droppod/proc/land(var/turf/T)
	playsound(T, land_sound, 100, FALSE, sound_range = 15)

	if(warning_zone)
		qdel(warning_zone)
		warning_zone = null

	droppod_flags &= ~DROPPOD_DROPPING
	layer = land_layer

	forceMove(T)

	droppod_flags |= DROPPOD_DROPPED
	update_icon()

	post_land()

/obj/structure/droppod/proc/post_land()
	density = TRUE
	for(var/mob/M in loc)
		M.gib(initial(name))

	for(var/obj/structure/O in loc)
		O.update_health(-land_damage)

	for(var/mob/M in view(7, loc))
		shake_camera(M, 4, 5)

	addtimer(CALLBACK(src, .proc/open), open_time)

/obj/structure/droppod/proc/recall()
	if(droppod_flags & DROPPOD_RETURNING)
		return

	if(droppod_flags & DROPPOD_OPEN)
		close()

	droppod_flags &= ~(DROPPOD_DROPPED)
	droppod_flags |= DROPPOD_RETURNING

	update_icon()

	wrenchable = FALSE
	density = FALSE
	anchored = TRUE

	var/pixels_to_take = 32*tiles_to_take
	animate(src, pixel_y = pixels_to_take, time = dropping_time, easing = QUAD_EASING)
	addtimer(CALLBACK(src, .proc/post_recall), dropping_time)

/obj/structure/droppod/proc/post_recall()
	qdel(src)
