/obj/structure/window_frame
	name = "window frame"
	desc = "A big hole in the wall that used to sport a large window. Can be vaulted through"
	icon = 'icons/turf/walls/window_frames.dmi'
	icon_state = "window0_frame"
	layer = WINDOW_FRAME_LAYER
	density = TRUE
	throwpass = TRUE
	climbable = 1 //Small enough to vault over, but you do need to vault over it
	health = 600
	var/max_health = 600
	var/obj/item/stack/sheet/sheet_type = /obj/item/stack/sheet/glass/reinforced
	var/obj/structure/window/framed/almayer/window_type = /obj/structure/window/framed/almayer
	var/basestate = "window"
	var/junction = 0
	var/reinforced = FALSE
	var/buildstacktype = /obj/item/stack/sheet/metal
	var/buildstackamount = 2
	projectile_coverage = PROJECTILE_COVERAGE_MEDIUM
	surgery_duration_multiplier = SURGERY_SURFACE_MULT_UNSUITED

	tiles_with = list(/turf/closed/wall)
	var/tiles_special[] = list(/obj/structure/machinery/door/airlock,
		/obj/structure/window/framed,
		/obj/structure/girder,
		/obj/structure/window_frame)

/obj/structure/window_frame/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_OVER|PASS_TYPE_CRAWLER

/obj/structure/window_frame/BlockedPassDirs(atom/movable/mover, target_dir)
	for(var/obj/structure/S in get_turf(mover))
		if(S && S.climbable && !(S.flags_atom & ON_BORDER) && climbable && isliving(mover)) //Climbable non-border objects allow you to universally climb over others
			return NO_BLOCKED_MOVEMENT

	return ..()

/obj/structure/window_frame/New(loc, from_window_shatter)
	..()
	var/obj/effect/alien/weeds/node/weed_found
	if(from_window_shatter)
		for(var/obj/effect/alien/weeds/weedwall/window/W in loc)
			if(W.parent)
				weed_found = W.parent
				break
	spawn(0)
		relativewall()
		relativewall_neighbours()
		for(var/turf/closed/wall/W in orange(1))
			W.update_connections()
			W.update_icon()
		if(weed_found)
			new /obj/effect/alien/weeds/weedwall/frame(loc, weed_found) //after smoothing to get the correct junction value


/obj/structure/window_frame/proc/update_nearby_icons()
	relativewall_neighbours()

/obj/structure/window_frame/update_icon()
	relativewall()

/obj/structure/window_frame/Destroy()
	density = FALSE
	update_nearby_icons()
	for(var/obj/effect/alien/weeds/weedwall/frame/WF in loc)
		qdel(WF)
	. = ..()

/obj/structure/window_frame/ex_act(power)
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
		user.visible_message(SPAN_NOTICE("[user] starts installing a new glass window on the frame."),
		SPAN_NOTICE("You start installing a new window on the frame."))
		playsound(src, 'sound/items/Deconstruct.ogg', 25, 1)
		if(do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			user.visible_message(SPAN_NOTICE("[user] installs a new glass window on the frame."),
			SPAN_NOTICE("You install a new window on the frame."))
			sheet.use(2)
			new window_type(loc) //This only works on Almayer windows!
			SEND_SIGNAL(user, COMSIG_MOB_CONSTRUCT_WINDOW, window_type)
			qdel(src)

	else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		if(buildstacktype)
			to_chat(user, SPAN_NOTICE(" You start to deconstruct [src]."))
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			if(do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD)) // takes 3 seconds to deconstruct
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				to_chat(user, SPAN_NOTICE("You deconstruct [src]."))
				SEND_SIGNAL(user, COMSIG_MOB_DISASSEMBLE_W_FRAME, src)
				deconstruct()

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(isxeno(user))
			return
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
					M.apply_effect(2, WEAKEN)
					user.visible_message(SPAN_WARNING("[user] pulls [M] onto [src]."),
					SPAN_NOTICE("You pull [M] onto [src]."))
					M.forceMove(loc)
			else
				to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
	else
		. = ..()

/obj/structure/window_frame/attack_alien(mob/living/carbon/xenomorph/user)
	if(!reinforced && user.claw_type >= CLAW_TYPE_SHARP)
		user.animation_attack_on(src)
		playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		take_damage((max_health / XENO_HITS_TO_DESTROY_WINDOW_FRAME) + 1)
		return XENO_ATTACK_ACTION
	else if (reinforced && user.claw_type >= CLAW_TYPE_SHARP)
		user.animation_attack_on(src)
		playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
		take_damage((max_health / XENO_HITS_TO_DESTROY_R_WINDOW_FRAME) + 1)
		return XENO_ATTACK_ACTION

	. = ..()

/obj/structure/window_frame/bullet_act(obj/projectile/P)
	bullet_ping(P)
	take_damage(P.damage)
	return TRUE

/obj/structure/window_frame/proc/take_damage(damage)
	health = max(0, (health - damage))
	health = min(health, max_health)

	if(health <= 0)
		deconstruct()

/obj/structure/window_frame/deconstruct(disassembled = TRUE)
	if(disassembled)
		new buildstacktype(loc, buildstackamount)
	return ..()

/obj/structure/window_frame/almayer
	icon_state = "alm_window0_frame"
	basestate = "alm_window"

/obj/structure/window_frame/almayer/white
	icon_state = "white_window0_frame"
	basestate = "white_window"
	window_type = /obj/structure/window/framed/almayer/white

/obj/structure/window_frame/almayer/aicore
	icon_state = "ai_window0_frame"
	basestate = "ai_window"
	window_type = /obj/structure/window/framed/almayer/aicore

/obj/structure/window_frame/almayer/aicore/white
	icon_state = "w_ai_window0_frame"
	basestate = "w_ai_window"
	window_type = /obj/structure/window/framed/almayer/aicore/white

/obj/structure/window_frame/almayer/aicore/black
	icon_state = "alm_window0_frame"
	basestate = "alm_window"
	window_type = /obj/structure/window/framed/almayer/aicore/black

/obj/structure/window_frame/almayer/requisitions/attackby(obj/item/W, mob/living/user)
	if(istype(W, sheet_type))
		to_chat(user, SPAN_WARNING("You can't repair this window."))
		return
	. = ..()

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
	icon_state = "hngr_window0_frame"
	basestate = "hngr_window"

/obj/structure/window_frame/hangar/reinforced
	icon_state = "hngr_rwindow0_frame"
	basestate = "hngr_rwindow"
	reinforced = TRUE

/obj/structure/window_frame/bunker
	icon_state = "bnkr_window0_frame"
	basestate = "bnkr_window"

/obj/structure/window_frame/bunker/reinforced
	icon_state = "bnkr_rwindow0_frame"
	basestate = "bnkr_rwindow"
	reinforced = TRUE

//strata frames

/obj/structure/window_frame/strata
	icon = 'icons/turf/walls/strata_windows.dmi'
	icon_state = "strata_window0_frame"
	basestate = "strata_window"

/obj/structure/window_frame/strata/reinforced
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	reinforced = TRUE

/obj/structure/window_frame/strata/hull
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	unslashable = TRUE
	unacidable = TRUE

//Kutjevo frames

/obj/structure/window_frame/kutjevo
	icon = 'icons/turf/walls/kutjevo/kutjevo_windows.dmi'
	icon_state = "kutjevo_window0_frame"
	basestate = "kutjevo_window"

/obj/structure/window_frame/kutjevo/reinforced
	icon_state = "kutjevo_window_alt0_frame"
	basestate = "kutjevo_window_alt"
	reinforced = TRUE

//Shivas Snowball (Ice v3) frame

/obj/structure/window_frame/shiva
	name = "poly-kevlon window frame"
	icon = 'icons/turf/walls/ice_colony/shiva_windows.dmi'
	icon_state = "shiva_window0_frame"
	basestate = "shiva_window"

//Solaris frames

/obj/structure/window_frame/solaris
	icon = 'icons/turf/walls/solaris/solaris_windows.dmi'
	icon_state = "solaris_window0_frame"
	basestate = "solaris_window"

/obj/structure/window_frame/solaris/reinforced
	icon_state = "solaris_window0_frame"
	basestate = "solaris_window"
	reinforced = TRUE

//Greybox development windows

/obj/structure/window_frame/dev
	icon = 'icons/turf/walls/dev/dev_windows.dmi'
	icon_state = "dev_window0_frame"
	basestate = "dev_window"

/obj/structure/window_frame/dev/reinforced
	icon_state = "dev_rwindow0_frame"
	basestate = "dev_rwindow"
	reinforced = TRUE

//Corsat frames

/obj/structure/window_frame/corsat
	icon = 'icons/turf/walls/windows_corsat.dmi'
	icon_state = "padded_rwindow0_frame"
	basestate = "padded_rwindow"
	reinforced = TRUE
	window_type = /obj/structure/window/framed/corsat

/obj/structure/window_frame/corsat/research
	window_type = /obj/structure/window/framed/corsat/research

/obj/structure/window_frame/corsat/security
	window_type = /obj/structure/window/framed/corsat/security


// Hybrisa Window Frames

// Research
/obj/structure/window_frame/hybrisa/research
	icon = 'icons/turf/walls/hybrisaresearchbrown_windows.dmi'
	icon_state = "strata_window0_frame"
	basestate = "strata_window"

/obj/structure/window_frame/hybrisa/research/reinforced
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	reinforced = TRUE

/obj/structure/window_frame/hybrisa/research/hull
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	unslashable = TRUE
	unacidable = TRUE

// Marshalls
/obj/structure/window_frame/hybrisa/marshalls
	icon = 'icons/turf/walls/hybrisa_marshalls_windows.dmi'
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"

/obj/structure/window_frame/hybrisa/marshalls/reinforced
	icon = 'icons/turf/walls/hybrisa_marshalls_windows.dmi'
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"
	reinforced = TRUE

// Colony
/obj/structure/window_frame/hybrisa/colony
	icon = 'icons/turf/walls/hybrisa_colony_window.dmi'
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
/obj/structure/window_frame/hybrisa/colony/reinforced
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	reinforced = TRUE
/obj/structure/window_frame/hybrisa/colony/hull
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	unslashable = TRUE
	unacidable = TRUE

// Hosptial

/obj/structure/window_frame/hybrisa/colony/hospital
	icon = 'icons/turf/walls/hybrisa_hospital_colonywindows.dmi'
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
/obj/structure/window_frame/hybrisa/colony/hospital/reinforced
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	reinforced = TRUE
/obj/structure/window_frame/hybrisa/colony/hospital/hull
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	unslashable = TRUE
	unacidable = TRUE

// Offices

/obj/structure/window_frame/hybrisa/colony/office
	icon = 'icons/turf/walls/hybrisa_offices_windows.dmi'
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
/obj/structure/window_frame/hybrisa/colony/office/reinforced
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	reinforced = TRUE
/obj/structure/window_frame/hybrisa/colony/office/hull
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	unslashable = TRUE
	unacidable = TRUE

// Engineering
/obj/structure/window_frame/hybrisa/colony/engineering
	icon = 'icons/turf/walls/hybrisa_engineering_windows.dmi'
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
/obj/structure/window_frame/hybrisa/colony/engineering/reinforced
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	reinforced = TRUE
/obj/structure/window_frame/hybrisa/colony/engineering/hull
	icon_state = "strata_window0_frame"
	basestate = "strata_window"
	unslashable = TRUE
	unacidable = TRUE

// Space-Port
/obj/structure/window_frame/hybrisa/spaceport
	icon = 'icons/turf/walls/hybrisa_spaceport_windows.dmi'
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"

/obj/structure/window_frame/hybrisa/spaceport/reinforced
	icon = 'icons/turf/walls/hybrisa_spaceport_windows.dmi'
	icon_state = "prison_rwindow0_frame"
	basestate = "prison_rwindow"
	reinforced = TRUE
