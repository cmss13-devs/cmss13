/obj/structure/window
	name = "window"
	desc = "A glass window. It looks thin and flimsy. A few knocks with anything should shatter it."
	icon = 'icons/turf/walls/windows.dmi'
	icon_state = "window"
	density = 1
	anchored = 1
	layer = WINDOW_LAYER
	flags_atom = ON_BORDER|FPRINT
	health = 15
	var/state = 2
	var/reinf = 0
	var/basestate = "window"
	var/shardtype = /obj/item/shard
	var/windowknock_cooldown = 0
	var/static_frame = 0 //True/false. If true, can't move the window
	var/junction = 0 //Because everything is terrible, I'm making this a window-level var
	var/not_damageable = 0
	var/not_deconstructable = 0
	var/legacy_full = FALSE //for old fulltile windows

///fixes up layering on northern and southern windows, breaks fulltile windows, those shouldn't be used in the first place regardless.
/obj/structure/window/Initialize()
	. = ..()
	update_icon()

	if(shardtype)
		debris += shardtype

	if(reinf)
		debris += /obj/item/stack/rods

	if(is_full_window())
		debris += shardtype
		update_nearby_icons()

/obj/structure/window/Destroy()
	density = 0
	if(is_full_window())
		update_nearby_icons()
	. = ..()

/obj/structure/window/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_HIGH_OVER_ONLY, PASS_GLASS)

/obj/structure/window/proc/set_constructed_window(start_dir)
	state = 0
	anchored = 0

	if(start_dir)
		dir = start_dir

	if(is_full_window())
		update_nearby_icons()

	update_icon()


/obj/structure/window/update_icon(loc, direction)
	if(QDELETED(src))
		return
	if(flags_atom & ON_BORDER)
		if(direction)
			dir = direction
		switch(dir)
			if(NORTH)
				layer = BELOW_TABLE_LAYER
			if(SOUTH)
				layer = ABOVE_MOB_LAYER
			else
				layer = initial(layer)
	else if(legacy_full)
		junction = 0
		if(anchored)
			var/turf/TU
			for(var/dirn in cardinal)
				TU = get_step(src, dirn)
				var/obj/structure/window/W = locate() in TU
				if(W && W.anchored && W.density && W.legacy_full) //Only counts anchored, non-destroyed, legacy full-tile windows.
					junction |= dirn
		icon_state = "[basestate][junction]"
	..()

/obj/structure/window/Move()
	var/ini_dir = dir
	. = ..()
	dir = ini_dir


//create_debris creates debris like shards and rods. This also includes the window frame for explosions
//If an user is passed, it will create a "user smashes through the window" message. AM is the item that hits
//Please only fire this after a hit
/obj/structure/window/proc/healthcheck(make_hit_sound = 1, make_shatter_sound = 1, create_debris = 1, mob/user, atom/movable/AM)
	if(not_damageable)
		if(make_hit_sound) //We'll still make the noise for immersion's sake
			playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)
		return
	if(health <= 0)
		if(user && istype(user))
			user.count_niche_stat(STATISTICS_NICHE_DESCTRUCTION_WINDOWS, 1)
			raiseEvent(GLOBAL_EVENT, EVENT_WINDOW_DESTROYED + "\ref[user]", src.type, get_area(src))
			user.visible_message(SPAN_DANGER("[user] smashes through [src][AM ? " with [AM]":""]!"))
		if(make_shatter_sound)
			playsound(src, "shatter", 50, 1)
		shatter_window(create_debris)
	else
		if(make_hit_sound)
			playsound(loc, 'sound/effects/Glasshit.ogg', 25, 1)

/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)
	//Tasers and the like should not damage windows.
	var/ammo_flags = Proj.ammo.flags_ammo_behavior | Proj.projectile_override_flags
	if(Proj.ammo.damage_type == HALLOSS || Proj.damage <= 0 || ammo_flags == AMMO_ENERGY)
		return 0

	if(!not_damageable) //Impossible to destroy
		health -= Proj.damage
	..()
	healthcheck(user = Proj.firer)
	return 1

/obj/structure/window/ex_act(severity, explosion_direction, source, mob/source_mob)
	if(not_damageable) //Impossible to destroy
		return

	health -= severity * EXPLOSION_DAMAGE_MULTIPLIER_WINDOW

	switch(health)
		if(0 to INFINITY)
			healthcheck(0, 1, user = source_mob)
		if(-2000 to 0)
			var/location = get_turf(src)
			playsound(src, "shatter", 50, 1)
			handle_debris(severity,explosion_direction)
			qdel(src)
			create_shrapnel(location, rand(1,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light/glass)
		else
			handle_debris(severity,explosion_direction)
			qdel(src)
	return

/obj/structure/window/get_explosion_resistance(direction)
	if(not_damageable)
		return 1000000

	if(flags_atom & ON_BORDER)
		if( direction == turn(dir, 90) || direction == turn(dir, -90) )
			return 0

	return health/EXPLOSION_DAMAGE_MULTIPLIER_WINDOW

/obj/structure/window/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(!not_damageable) //Impossible to destroy
		health = max(0, health - tforce)
		if(health <= 7 && !reinf && !static_frame)
			anchored = 0
			update_nearby_icons()
			step(src, get_dir(AM, src))
	healthcheck()

/obj/structure/window/attack_hand(mob/user as mob)
	if(user.a_intent == INTENT_HARM && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, 25)
			return

		if(windowknock_cooldown > world.time)
			return

		playsound(loc, 'sound/effects/glassknock.ogg', 25, 1)
		user.visible_message(SPAN_WARNING("[user] bangs against [src]!"),
		SPAN_WARNING("You bang against [src]!"),
		SPAN_WARNING("You hear a banging sound."))
		windowknock_cooldown = world.time + 100
	else
		if(windowknock_cooldown > world.time)
			return
		playsound(loc, 'sound/effects/glassknock.ogg', 15, 1)
		user.visible_message(SPAN_NOTICE("[user] knocks on [src]."),
		SPAN_NOTICE("You knock on [src]."),
		SPAN_NOTICE("You hear a knocking sound."))
		windowknock_cooldown = world.time + 100

//Used by attack_animal
/obj/structure/window/proc/attack_generic(mob/living/user, damage = 0)
	if(!not_damageable) //Impossible to destroy
		health -= damage
	user.animation_attack_on(src)
	user.visible_message(SPAN_DANGER("[user] smashes into [src]!"))
	healthcheck(1, 1, 1, user)

/obj/structure/window/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/window/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		if(isXeno(user)) return
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing, /mob/living))
			var/mob/living/M = G.grabbed_thing
			var/state = user.grab_level
			user.drop_held_item()
			switch(state)
				if(GRAB_PASSIVE)
					M.visible_message(SPAN_WARNING("[user] slams [M] against \the [src]!"))
					M.apply_damage(7)
					if(!not_damageable) //Impossible to destroy
						health -= 10
				if(GRAB_AGGRESSIVE)
					M.visible_message(SPAN_DANGER("[user] bashes [M] against \the [src]!"))
					if(prob(50))
						M.KnockDown(1)
					M.apply_damage(10)
					if(!not_damageable) //Impossible to destroy
						health -= 25
				if(GRAB_CHOKE)
					M.visible_message(SPAN_DANGER("[user] crushes [M] against \the [src]!"))	
					M.KnockDown(5)
					M.apply_damage(20)
					if(!not_damageable) //Impossible to destroy
						health -= 50
					
			healthcheck(1, 1, 1, M) //The person thrown into the window literally shattered it
		return

	if(W.flags_item & NOBLUDGEON) return

	if(istype(W, /obj/item/tool/screwdriver) && !not_deconstructable)
		if(reinf && state >= 1)
			state = 3 - state
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, (state == 1 ? SPAN_NOTICE("You have unfastened the window from the frame.") : SPAN_NOTICE("You have fastened the window to the frame.")))
		else if(reinf && state == 0 && !static_frame)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, (anchored ? SPAN_NOTICE("You have fastened the frame to the floor.") : SPAN_NOTICE("You have unfastened the frame from the floor.")))
		else if(!reinf && !static_frame)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			to_chat(user, (anchored ? SPAN_NOTICE("You have fastened the window to the floor.") : SPAN_NOTICE("You have unfastened the window.")))
		else if(static_frame && state == 0)
			raiseEvent(GLOBAL_EVENT, EVENT_WINDOW_DESTROYED + "\ref[user]", src.type, get_area(src))
			disassemble_window()
	else if(istype(W, /obj/item/tool/crowbar) && reinf && state <= 1 && !not_deconstructable)
		state = 1 - state
		playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
		to_chat(user, (state ? SPAN_NOTICE("You have pried the window into the frame.") : SPAN_NOTICE("You have pried the window out of the frame.")))
	else
		if(!not_damageable) //Impossible to destroy
			health -= W.force
			if(health <= 7  && !reinf && !static_frame && !not_deconstructable)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		healthcheck(1, 1, 1, user, W)
		..()
	return

/obj/structure/window/proc/is_full_window()
	return !(flags_atom & ON_BORDER)

/obj/structure/window/proc/disassemble_window()
	if(reinf)
		new /obj/item/stack/sheet/glass/reinforced(loc, 2)
	else
		new /obj/item/stack/sheet/glass/reinforced(loc, 2)
	qdel(src)


/obj/structure/window/proc/shatter_window(create_debris)
	if(create_debris)
		handle_debris()
	qdel(src)


/obj/structure/window/verb/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(static_frame || not_deconstructable || !(flags_atom & ON_BORDER))
		return 0

	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor, you can't rotate it!"))
		return 0

	dir = turn(dir, 90)



/obj/structure/window/verb/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(static_frame || not_deconstructable || !(flags_atom & ON_BORDER))
		return 0
	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor, you can't rotate it!"))
		return 0

	dir = turn(dir, 270)



//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/direction in cardinal)
		for(var/obj/structure/window/W in get_step(src, direction))
			W.update_icon()

/obj/structure/window/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		if(!not_damageable)
			health -= round(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A phoron-glass alloy window. It looks insanely tough to break. It appears it's also insanely tough to burn through."
	icon_state = "phoronwindow0"
	shardtype = /obj/item/shard/phoron
	health = 120

/obj/structure/window/phoronbasic/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 32000)
		health -= round(exposed_volume / 1000)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()

/obj/structure/window/phoronbasic/full
	flags_atom = FPRINT
	icon_state = "phoronwindow0"
	basestate = "phoronwindow"
	legacy_full = TRUE


/obj/structure/window/phoronreinforced
	name = "reinforced phoron window"
	desc = "A phoron-glass alloy window with a rod matrice. It looks hopelessly tough to break. It also looks completely fireproof, considering how basic phoron windows are insanely fireproof."
	icon_state = "phoronrwindow0"
	shardtype = /obj/item/shard/phoron
	reinf = 1
	health = 160

/obj/structure/window/phoronreinforced/fire_act(exposed_temperature, exposed_volume)
	return

/obj/structure/window/phoronreinforced/full
	flags_atom = FPRINT
	icon_state = "phoronrwindow0"
	basestate = "phoronrwindow"
	legacy_full = TRUE


/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "A glass window reinforced with bracing rods. It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	health = 40
	reinf = 1

/obj/structure/window/reinforced/toughened
	name = "safety glass"
	desc = "A very tough looking window reinforced with tempered glass and bracing rods, probably bullet proof."
	icon_state = "rwindow"
	basestate = "rwindow"
	health = 300
	reinf = 1



/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "A tinted glass window. It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "privacy window"
	desc = "A glass privacy window. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	health = 30

/obj/structure/window/reinforced/ultra
	name = "ultra-reinforced window"
	desc = "An ultra-reinforced window designed to keep the briefing podium a secure area."
	icon_state = "fwindow"
	basestate = "fwindow"
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/window/reinforced/full
	flags_atom = FPRINT
	icon_state = "rwindow0"
	basestate = "rwindow"
	legacy_full = TRUE

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "A shuttle glass window with a rod matrice specialised for heat resistance. It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/turf/podwindows.dmi'
	icon_state = "window"
	basestate = "window"
	health = 40
	reinf = 1
	flags_atom = FPRINT

/obj/structure/window/shuttle/update_icon() //icon_state has to be set manually
	return

/obj/structure/window/full
	flags_atom = FPRINT
	icon_state = "window0"
	basestate = "window"
	legacy_full = TRUE



//Framed windows

/obj/structure/window/framed
	name = "theoretical window"
	layer = TABLE_LAYER
	static_frame = 1
	flags_atom = FPRINT
	var/window_frame //For perspective windows,so the window frame doesn't magically dissapear
	var/list/tiles_special = list(/obj/structure/machinery/door/airlock,
		/obj/structure/window/framed,
		/obj/structure/girder,
		/obj/structure/window_frame)
	tiles_with = list(/turf/closed/wall)

/obj/structure/window/framed/New()
	spawn(0)
		relativewall()
		relativewall_neighbours()
	..()

/obj/structure/window/framed/Destroy()
	for(var/obj/effect/alien/weeds/weedwall/window/WW in loc)
		qdel(WW)
	. = ..()

/obj/structure/window/framed/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_GLASS)

/obj/structure/window/framed/update_nearby_icons()
	relativewall_neighbours()

/obj/structure/window/framed/update_icon()
	relativewall()

/obj/structure/window/framed/ex_act(severity, explosion_direction, source, mob/source_mob)
	if(not_damageable) //Impossible to destroy
		return

	health -= severity * EXPLOSION_DAMAGE_MULTIPLIER_WINDOW

	switch(health)
		if(0 to INFINITY)
			healthcheck(0, 1, user = source_mob)
		if(-3000 to 0)
			var/location = get_turf(src)
			playsound(src, "shatter", 50, 1)
			handle_debris(severity,explosion_direction)
			shatter_window(0)
			create_shrapnel(location, rand(1,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light/glass)
		else
			qdel(src)
	return


/obj/structure/window/framed/disassemble_window()
	if(window_frame)
		var/obj/structure/window_frame/WF = new window_frame(loc)
		WF.icon_state = "[WF.basestate][junction]_frame"
		WF.dir = dir
	..()

/obj/structure/window/framed/shatter_window(create_debris)
	if(window_frame)
		var/obj/structure/window_frame/new_window_frame = new window_frame(loc, TRUE)
		new_window_frame.icon_state = "[new_window_frame.basestate][junction]_frame"
		new_window_frame.dir = dir
	..()


/obj/structure/window/framed/proc/drop_window_frame()
	if(window_frame)
		var/obj/structure/window_frame/new_window_frame = new window_frame(loc, TRUE)
		new_window_frame.icon_state = "[new_window_frame.basestate][junction]_frame"
		new_window_frame.dir = dir
	qdel(src)

/obj/structure/window/framed/almayer
	name = "reinforced window"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "alm_rwindow0"
	basestate = "alm_rwindow"
	health = 100 //Was 600
	reinf = 1
	dir = 5
	window_frame = /obj/structure/window_frame/almayer

/obj/structure/window/framed/almayer/healthcheck(make_hit_sound = 1, make_shatter_sound = 1, create_debris = 1, mob/user, atom/movable/AM)
	if(health <= 0)
		if(user && z == MAIN_SHIP_Z_LEVEL)
			new /obj/effect/decal/prints(get_turf(src), user, "A small glass piece is found on the fingerprint.")
			if(user.detectable_by_ai())
				ai_silent_announcement("DAMAGE REPORT: Structural damage detected at [get_area(src)], requesting Military Police supervision.")

	. = ..()

/obj/structure/window/framed/almayer/hull
	name = "hull window"
	desc = "A glass window with a special rod matrice inside a wall frame. This one was made out of exotic materials to prevent hull breaches. No way to get through here."
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/almayer/hull/hijack_bustable //I exist to explode after hijack, that is all.

/obj/structure/window/framed/almayer/white
	icon_state = "white_rwindow0"
	basestate = "white_rwindow"
	window_frame = /obj/structure/window_frame/almayer/white

/obj/structure/window/framed/almayer/white/hull
	name = "research window"
	desc = "An ultra-reinforced window designed to keep research a secure area. This one was made out of exotic materials to prevent hull breaches. No way to get through here."
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/colony
	name = "window"
	icon_state = "col_window0"
	basestate = "col_window"
	window_frame = /obj/structure/window_frame/colony

/obj/structure/window/framed/colony/reinforced
	name = "reinforced window"
	icon_state = "col_rwindow0"
	basestate = "col_rwindow"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/colony/reinforced

/obj/structure/window/framed/colony/reinforced/tinted
	name =  "tinted reinforced window"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it. This one is opaque. You have an uneasy feeling someone might be watching from the other side."
	opacity = 1

/obj/structure/window/framed/colony/reinforced/hull
	name = "hull window"
	desc = "A glass window with a special rod matrice inside a wall frame. This one was made out of exotic materials to prevent hull breaches. No way to get through here."
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter



//Chigusa windows

/obj/structure/window/framed/chigusa
	name = "reinforced window"
	icon_state = "chig_rwindow0"
	basestate = "chig_rwindow"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/chigusa


//Desert Dam Windows

/obj/structure/window/framed/hangar
	name = "window"
	icon_state = "hngr_window0"
	basestate = "hngr_window"
	desc = "A glass window inside a wall frame."
	health = 40
	window_frame = /obj/structure/window_frame/hangar

/obj/structure/window/framed/hangar/reinforced
	name = "reinforced window"
	icon_state = "hngr_rwindow0"
	basestate = "hngr_rwindow"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/hangar/reinforced

/obj/structure/window/framed/bunker
	name = "window"
	icon_state = "bnkr_window0"
	basestate = "bnkr_window"
	desc = "A glass window inside a wall frame."
	health = 40
	window_frame = /obj/structure/window_frame/bunker

/obj/structure/window/framed/bunker/reinforced
	name = "reinforced window"
	icon_state = "bnkr_rwindow0"
	basestate = "bnkr_rwindow"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/bunker/reinforced


/obj/structure/window/framed/wood
	name = "window"
	icon_state = "wood_window0"
	basestate = "wood_window"
	window_frame = /obj/structure/window_frame/wood

/obj/structure/window/framed/wood/reinforced
	name = "reinforced window"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	icon_state = "wood_rwindow0"
	basestate = "wood_rwindow"
	window_frame = /obj/structure/window_frame/wood

//Strata windows

/obj/structure/window/framed/strata
	name = "window"
	icon = 'icons/turf/walls/strata_windows.dmi'
	icon_state = "strata_window0"
	basestate = "strata_window"
	desc = "A glass window inside a wall frame."
	health = 40
	window_frame = /obj/structure/window_frame/strata

/obj/structure/window/framed/strata/reinforced
	name = "reinforced window"
	icon_state = "strata_window0"
	basestate = "strata_window"
	desc = "A glass window. Light refracts incorrectly when looking through. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/strata/reinforced

//Kutjevo Windows

/obj/structure/window/framed/kutjevo
	name = "window"
	icon = 'icons/turf/walls/kutjevo/kutjevo_windows.dmi'
	icon_state = "kutjevo_window0"
	basestate = "kutjevo_window"
	desc = "A glass window inside a wall frame."
	health = 40
	window_frame = /obj/structure/window_frame/kutjevo

/obj/structure/window/framed/kutjevo/reinforced
	name = "reinforced window"
	icon_state = "kutjevo_window_alt0"
	basestate = "kutjevo_window_alt"
	desc = "A glass window. Cross bars are visible. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/kutjevo/reinforced

/obj/structure/window/framed/kutjevo/reinforced/hull
	icon_state = "kutjevo_window_hull"
	desc = "A glass window. Something tells you this one is somehow indestructable."
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000

//Solaris windows

/obj/structure/window/framed/solaris
	name = "window"
	icon = 'icons/turf/walls/solaris/solaris_windows.dmi'
	icon_state = "solaris_window0"
	basestate = "solaris_window"
	desc = "A glass window inside a wall frame."
	health = 40
	window_frame = /obj/structure/window_frame/solaris

/obj/structure/window/framed/solaris/reinforced
	name = "reinforced window"
	icon_state = "solaris_rwindow0"
	basestate = "solaris_rwindow"
	desc = "A glass window. The inside is reinforced with a few tempered matrix rods along the base. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/solaris/reinforced

/obj/structure/window/framed/solaris/reinforced/hull
	desc = "A glass window. Something tells you this one is somehow indestructable."
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000

//GREYBOX DEV WINDOWS

/obj/structure/window/framed/dev
	name = "greybox window"
	icon = 'icons/turf/walls/dev/dev_windows.dmi'
	icon_state = "dev_window0"
	basestate = "dev_window"
	desc = "A glass window inside a wall frame. Just like in the orange box!"
	health = 40
	window_frame = /obj/structure/window_frame/dev

/obj/structure/window/framed/dev/reinforced
	name = "greybox reinforced window"
	icon_state = "dev_rwindow0"
	basestate = "dev_rwindow"
	desc = "A glass window inside a reinforced wall frame. Just like in the orange box!"
	health = 100
	reinf = 1
	window_frame = /obj/structure/window_frame/dev/reinforced

/obj/structure/window/framed/dev/reinforced/hull
	desc = "A glass window. Something tells you this one is somehow indestructable."
	not_damageable = 1
	not_deconstructable = 1
	unslashable = TRUE
	unacidable = TRUE
	health = 1000000


//Prison windows


/obj/structure/window/framed/prison
	name = "window"
	icon_state = "prison_window0"
	basestate = "prison_window"
	window_frame = /obj/structure/window_frame/prison

/obj/structure/window/framed/prison/reinforced
	name = "reinforced window"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = 1
	icon_state = "prison_rwindow0"
	basestate = "prison_rwindow"
	window_frame = /obj/structure/window_frame/prison/reinforced

/obj/structure/window/framed/prison/reinforced/hull
	name = "hull window"
	desc = "A glass window with a special rod matrice inside a wall frame. This one has an automatic shutter system to prevent any atmospheric breach."
	health = 200
	//icon_state = "rwindow0_debug" //Uncomment to check hull in the map editor
	var/triggered = 0 //indicates if the shutters have already been triggered

/obj/structure/window/framed/prison/reinforced/hull/Destroy()
	spawn_shutters()
	.=..()

/obj/structure/window/framed/prison/reinforced/hull/proc/spawn_shutters(var/from_dir = 0)
	if(triggered)
		return
	else
		triggered = 1
	for(var/direction in cardinal)
		if(direction == from_dir) continue //doesn't check backwards
		for(var/obj/structure/window/framed/prison/reinforced/hull/W in get_step(src,direction) )
			W.spawn_shutters(turn(direction,180))
	var/obj/structure/machinery/door/poddoor/shutters/almayer/pressure/P = new(get_turf(src))
	switch(junction)
		if(4,5,8,9,12)
			P.dir = 2
		else
			P.dir = 4
	spawn(0)
		P.close()

/obj/structure/window/framed/prison/cell
	name = "cell window"
	icon_state = "prison_cellwindow0"
	basestate = "prison_cellwindow"
	desc = "A glass window with a special rod matrice inside a wall frame."

//Biodome windows

/obj/structure/window/framed/corsat
	name = "reinforced window"
	desc = "A glass window with a special rod matrice inside a wall frame. It looks rather strong. Might take a few good hits to shatter it."
	health = 100
	reinf = TRUE
	icon = 'icons/turf/walls/windows_corsat.dmi'
	icon_state = "padded_rwindow0"
	basestate = "padded_rwindow"
	window_frame = /obj/structure/window_frame/corsat

/obj/structure/window/framed/corsat/research
	desc = "A purple tinted glass window with a special rod matrice inside a wall frame. It looks quite strong. Might take some good hits to shatter it."
	health = 200
	icon_state = "paddedresearch_rwindow0"
	basestate = "paddedresearch_rwindow"
	window_frame = /obj/structure/window_frame/corsat/research

/obj/structure/window/framed/corsat/security
	desc = "A red tinted glass window with a special rod matrice inside a wall frame. It looks very strong."
	health = 300
	icon_state = "paddedsec_rwindow0"
	basestate = "paddedsec_rwindow"
	window_frame = /obj/structure/window_frame/corsat/security

/obj/structure/window/framed/corsat/cell
	name = "cell window"
	icon_state = "padded_cellwindow0"
	basestate = "padded_cellwindow"
	desc = "A glass window with a special rod matrice inside a wall frame. This one was made out of exotic materials to prevent hull breaches. No way to get through here."
	not_damageable = 1
	not_deconstructable = 1
	unacidable = TRUE
	health = 1000000 //Failsafe, shouldn't matter

/obj/structure/window/framed/corsat/cell/research
	icon_state = "paddedresearch_cellwindow0"
	basestate = "paddedresearch_cellwindow"

/obj/structure/window/framed/corsat/cell/security
	icon_state = "paddedsec_cellwindow0"
	basestate = "paddedsec_cellwindow"

/obj/structure/window/framed/corsat/hull
	name = "hull window"
	desc = "A glass window with a special rod matrice inside a wall frame. This one has an automatic shutter system to prevent any atmospheric breach."
	health = 200
	var/triggered = FALSE //indicates if the shutters have already been triggered

/obj/structure/window/framed/corsat/hull/research
	health = 300

/obj/structure/window/framed/corsat/hull/security
	health = 400

/obj/structure/window/framed/corsat/hull/Destroy()
	spawn_shutters()
	.=..()

/obj/structure/window/framed/corsat/hull/proc/spawn_shutters(var/from_dir = 0)
	if(triggered)
		return

	triggered = 1
	for(var/direction in cardinal)
		if(direction == from_dir)
			continue //doesn't check backwards

		for(var/obj/structure/window/framed/corsat/hull/W in get_step(src,direction) )
			W.spawn_shutters(turn(direction,180))

	var/obj/structure/machinery/door/poddoor/shutters/almayer/pressure/P = new(get_turf(src))
	switch(junction)
		if(4,5,8,9,12)
			P.dir = 2
		else
			P.dir = 4
	
	INVOKE_ASYNC(P, /obj/structure/machinery/door.proc/close)