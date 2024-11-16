


//FLOORS-----------------------------------//
//Snow Floor
/turf/open/snow
	name = "snow layer"
	icon = 'icons/turf/floors/snow2.dmi'
	icon_state = "snow_0"
	is_groundmap_turf = TRUE
	scorchable = TRUE

	//PLACING/REMOVING/BUILDING
/turf/open/snow/attackby(obj/item/I, mob/user)

	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already \a [L] at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = TRUE
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.forceMove(src)
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.set_light(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)



//Update icon and sides on start, but skip nearby check for turfs.
/turf/open/snow/Initialize(mapload, ...)
	. = ..()
	update_icon(1,1)

/turf/open/snow/Entered(atom/movable/AM)
	if(bleed_layer > 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			var/slow_amount = 0.75
			var/can_stuck = 1
			if(istype(C, /mob/living/carbon/xenomorph)||isyautja(C))
				slow_amount = 0.25
				can_stuck = 0
			var/new_slowdown = C.next_move_slowdown + (slow_amount * bleed_layer)
			if(prob(2))
				to_chat(C, SPAN_WARNING("Moving through [src] slows you down.")) //Warning only
			else if(can_stuck && bleed_layer == 3 && prob(2))
				to_chat(C, SPAN_WARNING("You get stuck in [src] for a moment!"))
				new_slowdown += 10
			C.next_move_slowdown = new_slowdown
	..()


//Update icon
/turf/open/snow/update_icon(update_full, skip_sides)
	icon_state = "snow_[bleed_layer]"
	setDir(pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))
	switch(bleed_layer)
		if(0)
			name = "dirt floor"
		if(1)
			name = "shallow [initial(name)]"
		if(2)
			name = "deep [initial(name)]"
		if(3)
			name = "very deep [initial(name)]"

	//Update the side overlays
	if(update_full)
		var/turf/open/T
		if(!skip_sides)
			for(var/dirn in GLOB.alldirs)
				var/turf/open/snow/D = get_step(src,dirn)
				if(istype(D))
					//Update turfs that are near us, but only once
					D.update_icon(1,1)

		overlays.Cut()

		for(var/dirn in GLOB.alldirs)
			T = get_step(src, dirn)
			if(istype(T))
				if(bleed_layer > T.bleed_layer && T.bleed_layer < 1)
					var/image/I = new('icons/turf/floors/snow2.dmi', "snow_[(dirn & (dirn-1)) ? "outercorner" : pick("innercorner", "outercorner")]", dir = dirn)
					switch(dirn)
						if(NORTH)
							I.pixel_y = 32
						if(SOUTH)
							I.pixel_y = -32
						if(EAST)
							I.pixel_x = 32
						if(WEST)
							I.pixel_x = -32
						if(NORTHEAST)
							I.pixel_x = 32
							I.pixel_y = 32
						if(SOUTHEAST)
							I.pixel_x = 32
							I.pixel_y = -32
						if(NORTHWEST)
							I.pixel_x = -32
							I.pixel_y = 32
						if(SOUTHWEST)
							I.pixel_x = -32
							I.pixel_y = -32

					I.layer = layer + 0.001 + bleed_layer * 0.0001
					overlays += I


//Explosion act
/turf/open/snow/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(20) && bleed_layer)
				bleed_layer--
				update_icon(1, 0)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(60) && bleed_layer)
				bleed_layer = max(bleed_layer - 2, 0)
				update_icon(1, 0)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(bleed_layer)
				bleed_layer = 0
				update_icon(1, 0)

//Flames act
/turf/open/snow/scorch(heat_level)
	if(bleed_layer <= 0)
		return
	switch(heat_level)
		if(1 to 19)
			bleed_layer--
			update_icon(update_full = TRUE, skip_sides = FALSE)
		if(20 to 39)
			bleed_layer = max(bleed_layer - 2, 0)
			update_icon(update_full = TRUE, skip_sides = FALSE)
		if(40 to INFINITY)
			bleed_layer = 0
			update_icon(update_full = TRUE, skip_sides = FALSE)


//SNOW LAYERS-----------------------------------//
/turf/open/snow/layer0
	icon_state = "snow_0"
	bleed_layer = 0

/turf/open/snow/layer1
	icon_state = "snow_1"
	bleed_layer = 1

/turf/open/snow/layer2
	icon_state = "snow_2"
	bleed_layer = 2

/turf/open/snow/layer3
	icon_state = "snow_3"
	bleed_layer = 3
