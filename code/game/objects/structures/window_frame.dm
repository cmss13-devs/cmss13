/obj/structure/window_frame
	name = "window frame"
	desc = "A big hole in the wall that used to sport a large window. Can be vaulted through"
	icon = 'icons/turf/walls/window_frames.dmi'
	icon_state = "window0_frame"
	layer = WINDOW_FRAME_LAYER
	density = 1
	throwpass = TRUE
	climbable = 1 //Small enough to vault over, but you do need to vault over it
	climb_delay = 15 //One second and a half, gotta vault fast
	var/obj/item/stack/sheet/sheet_type = /obj/item/stack/sheet/glass/reinforced
	var/obj/structure/window/framed/almayer/window_type = /obj/structure/window/framed/almayer
	var/basestate = "window"
	var/junction = 0
	var/reinforced = FALSE
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 2
	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM

	tiles_with = list(/turf/closed/wall)
	var/tiles_special[] = list(/obj/structure/machinery/door/airlock,
		/obj/structure/window/framed,
		/obj/structure/girder,
		/obj/structure/window_frame)

/obj/structure/window_frame/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	for(var/obj/structure/S in get_turf(mover))
		if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
			return 1
	return 0

/obj/structure/window_frame/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	return 1

/obj/structure/window_frame/New(loc, from_window_shatter)
	..()
	var/weed_found
	if(from_window_shatter)
		for(var/obj/effect/alien/weeds/weedwall/window/W in loc)
			weed_found = TRUE
			break
	spawn(0)
		relativewall()
		relativewall_neighbours()
		for(var/turf/closed/wall/W in orange(1))
			W.update_connections()
			W.update_icon()
		if(weed_found)
			new /obj/effect/alien/weeds/weedwall/frame(loc) //after smoothing to get the correct junction value


/obj/structure/window_frame/proc/update_nearby_icons()
	relativewall_neighbours()

/obj/structure/window_frame/update_icon()
	relativewall()

/obj/structure/window_frame/Dispose()
	density = 0
	update_nearby_icons()
	for(var/obj/effect/alien/weeds/weedwall/frame/WF in loc)
		qdel(WF)
	. = ..()

/obj/structure/window_frame/ex_act(var/power)
	switch(power)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return

/obj/structure/window_frame/attackby(obj/item/W, mob/living/user)
	if(istype(W, sheet_type))
		var/obj/item/stack/sheet/sheet = W
		if(sheet.get_amount() < 2)
			to_chat(user, SPAN_WARNING("You need more [W.name] to install a new window."))
			return
		user.visible_message(SPAN_NOTICE("[user] starts installing a new glass window on the frame."), \
		SPAN_NOTICE("You start installing a new window on the frame."))
		playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] installs a new glass window on the frame."), \
			SPAN_NOTICE("You install a new window on the frame."))
			sheet.use(2)
			new window_type(loc) //This only works on Almayer windows!
			qdel(src)

	else if(istype(W, /obj/item/tool/wrench))
		if(buildstacktype)
			to_chat(user, SPAN_NOTICE(" You start to deconstruct [src]."))
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			if(do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))	// takes 3 seconds to deconstruct
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				new buildstacktype(loc, buildstackamount)
				to_chat(user, SPAN_NOTICE(" You deconstruct [src]."))
				qdel(src)

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(isXeno(user)) return
		if(isliving(G.grabbed_thing))
			var/mob/living/M = G.grabbed_thing
			if(user.grab_level >= GRAB_AGGRESSIVE)
				if(get_dist(src, M) > 1)
					to_chat(user, SPAN_WARNING("[M] needs to be next to [src]."))
				else
					if(user.action_busy)
						return
					user.visible_message(SPAN_NOTICE("[user] starts pulling [M] onto [src]."),
					SPAN_NOTICE("You start pulling [M] onto [src]!"))
					var/oldloc = loc
					if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC, M) || loc != oldloc)
						return
					M.KnockDown(2)
					user.visible_message(SPAN_WARNING("[user] pulls [M] onto [src]."),
					SPAN_NOTICE("You pull [M] onto [src]."))
					M.forceMove(loc)
			else
				to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
	else
		. = ..()



/obj/structure/window_frame/almayer
	icon_state = "alm_window0_frame"
	basestate = "alm_window"

/obj/structure/window_frame/almayer/white
	icon_state = "white_window0_frame"
	basestate = "white_window"
	window_type = /obj/structure/window/framed/almayer/white

/obj/structure/window_frame/almayer/requisitions/attackby(obj/item/W, mob/living/user)
	if(istype(W, sheet_type))
		to_chat(user, SPAN_WARNING("You can't repair this window."))
		return
	..()

/obj/structure/window_frame/colony
	icon_state = "col_window0_frame"
	basestate = "col_window"

/obj/structure/window_frame/colony/reinforced
	icon_state = "col_rwindow0_frame"
	basestate = "col_rwindow"
	reinforced = TRUE

/obj/structure/window_frame/chigusa
	icon_state = "chig_window0_frame"
	basestate = "chig_window"

/obj/structure/window_frame/wood
	icon_state = "wood_window0_frame"
	basestate = "wood_window"

/obj/structure/window_frame/prison
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"

/obj/structure/window_frame/prison/reinforced
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"
	reinforced = TRUE

/obj/structure/window_frame/hangar
	icon_state = "hngr_window0"
	basestate = "hngr_window"

/obj/structure/window_frame/hangar/reinforced
	icon_state = "hngr_rwindow0"
	basestate = "hngr_rwindow"
	reinforced = TRUE

/obj/structure/window_frame/bunker
	icon_state = "bnkr_window0"
	basestate = "bnkr_window"

/obj/structure/window_frame/bunker/reinforced
	icon_state = "bnkr_rwindow0"
	basestate = "bnkr_rwindow"
	reinforced = TRUE