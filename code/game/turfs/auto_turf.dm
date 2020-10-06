/turf/open/auto_turf
	name = "auto-sand"
	icon = 'icons/turf/floors/auto_sand.dmi'
	icon_state = "sand_1"//editor icon
	is_groundmap_turf = TRUE
	var/icon_prefix = "sand"
	var/layer_name = new/list("layer 1", "layer2", "layer 3", "layer 4", "layer 5")
	var/variant = 0
	var/variant_prefix_name = ""

/turf/open/auto_turf/is_weedable()//for da xenos
	return TRUE

/turf/open/auto_turf/get_dirt_type()
	return DIRT_TYPE_GROUND //automatically diggable I guess

/turf/open/auto_turf/can_dig_xeno_tunnel()
	return TRUE //xenos can tunnel

//Update icon
/turf/open/auto_turf/update_icon()
	if(variant && (bleed_layer == initial(bleed_layer)))
		icon_state = "[icon_prefix]_[bleed_layer]_[variant]"
	else
		icon_state = "[icon_prefix]_[bleed_layer]"
	dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

	var/name_to_set
	switch(bleed_layer)
		if(0)
			name_to_set = layer_name[1]
		if(1)
			name_to_set = layer_name[2]
		if(2)
			name_to_set = layer_name[3]
		if(3)
			name_to_set = layer_name[4]
		if(4)
			name_to_set= layer_name[5]

	if(bleed_layer == initial(bleed_layer))
		name = variant_prefix_name + " " + name_to_set
	else
		name = name_to_set

	..()

/turf/open/auto_turf/proc/changing_layer(var/new_layer)
	if(isnull(new_layer) || new_layer == bleed_layer)
		return

	bleed_layer = max(0, new_layer)
	for(var/direction in alldirs)
		var/turf/open/T = get_step(src, direction)
		if(istype(T))
			T.update_icon()

	update_icon()

//Explosion act
/turf/open/auto_turf/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(20) && bleed_layer)
				var/new_bleed_layer = min(0, bleed_layer - 1)
				addtimer(CALLBACK(src, .proc/changing_layer, new_bleed_layer), 1)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(60) && bleed_layer)
				var/new_bleed_layer = max(bleed_layer - 2, 0)
				addtimer(CALLBACK(src, .proc/changing_layer, new_bleed_layer), 1)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			if(bleed_layer)
				addtimer(CALLBACK(src, .proc/changing_layer, 0), 1)


//Actual auto-turfs now


//Kutjevo & Trijent sand
/turf/open/auto_turf/sand
	layer_name = list("red dirt", "sand", "rocky sand", "this layer does not exist", "call a coder")

/turf/open/auto_turf/sand/get_dirt_type()
	return DIRT_TYPE_SAND

/turf/open/auto_turf/sand/layer0 //still have to manually define the layers for the editor
	icon_state = "sand_0"
	bleed_layer = 0

/turf/open/auto_turf/sand/layer1
	icon_state = "sand_1"
	bleed_layer = 1

/turf/open/auto_turf/sand/layer2
	icon_state = "sand_1_1"
	bleed_layer = 1
	variant = 1
	variant_prefix_name = "rocky"

//Ice colony snow
/turf/open/auto_turf/snow
	name = "auto-snow"
	icon = 'icons/turf/floors/snow2.dmi'
	icon_state = "snow_0"
	icon_prefix = "snow"
	layer_name = list("icy dirt", "shallow snow", "deep snow", "very deep snow", "rock filled snow")

/turf/open/auto_turf/snow/get_dirt_type()
	if(bleed_layer)
		return DIRT_TYPE_SNOW
	else
		return DIRT_TYPE_GROUND

/turf/open/auto_turf/snow/is_weedable()
	return !bleed_layer

/turf/open/auto_turf/snow/attackby(var/obj/item/I, var/mob/user)
	//Light Stick
	if(istype(I, /obj/item/lightstick))
		var/obj/item/lightstick/L = I
		if(locate(/obj/item/lightstick) in get_turf(src))
			to_chat(user, "There's already a [L]  at this position!")
			return

		to_chat(user, "Now planting \the [L].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		user.visible_message("\blue[user.name] planted \the [L] into [src].")
		L.anchored = 1
		L.icon_state = "lightstick_[L.s_color][L.anchored]"
		user.drop_held_item()
		L.x = x
		L.y = y
		L.pixel_x += rand(-5,5)
		L.pixel_y += rand(-5,5)
		L.SetLuminosity(2)
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)

//Digging up snow
/turf/open/auto_turf/snow/attack_alien(mob/living/carbon/Xenomorph/M)
	if(M.a_intent == INTENT_HELP)
		return FALSE

	if(!bleed_layer)
		to_chat(M, SPAN_WARNING("There is nothing to clear out!"))
		return FALSE

	M.visible_message(SPAN_NOTICE("[M] starts clearing out the [name]."), SPAN_NOTICE("You start clearing out the [name]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
	if(!do_after(M, 25, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		return FALSE

	if(!bleed_layer)
		to_chat(M, SPAN_WARNING("There is nothing to clear out!"))
		return

	M.visible_message(SPAN_NOTICE("[M] clears out [src]."), \
	SPAN_NOTICE("You clear out [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)

	var/new_layer = bleed_layer - 1
	changing_layer(new_layer)
	
/turf/open/auto_turf/snow/Entered(atom/movable/AM)
	if(bleed_layer > 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			var/slow_amount = 0.35
			var/can_stuck = 1
			if(istype(C, /mob/living/carbon/Xenomorph)||isYautja(C))
				slow_amount = 0.15
				can_stuck = 0
			var/new_slowdown = C.next_move_slowdown + (slow_amount * bleed_layer)
			if(prob(2))
				to_chat(C, SPAN_WARNING("Moving through [src] slows you down.")) //Warning only
			else if(can_stuck && bleed_layer == 4 && prob(2))
				to_chat(C, SPAN_WARNING("You get stuck in [src] for a moment!"))
				new_slowdown += 10
			C.next_move_slowdown = new_slowdown
	..()

/turf/open/auto_turf/snow/layer0 //still have to manually define the layers for the editor
	icon_state = "snow_0"
	bleed_layer = 0

/turf/open/auto_turf/snow/layer1
	icon_state = "snow_1"
	bleed_layer = 1

/turf/open/auto_turf/snow/layer2
	icon_state = "snow_2"
	bleed_layer = 2

/turf/open/auto_turf/snow/layer3
	icon_state = "snow_3"
	bleed_layer = 3

/turf/open/auto_turf/snow/layer4
	icon_state = "snow_4" //Add sorokyne rock decals to this one
	bleed_layer = 4
