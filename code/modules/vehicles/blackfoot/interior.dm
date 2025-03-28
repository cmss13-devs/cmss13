/obj/structure/prop/vehicle/blackfoot
	name = "blackfoot chassis"

	icon = 'icons/obj/vehicles/interiors/blackfoot_chassis.dmi'
	icon_state = "chassis"
	layer = ABOVE_TURF_LAYER
	mouse_opacity = FALSE

/obj/structure/interior_exit/vehicle/blackfoot
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "door left"
	opacity = FALSE

/obj/structure/interior_exit/vehicle/blackfoot/left
	name = "blackfoot side door"
	icon_state = "door left"

/obj/structure/interior_exit/vehicle/blackfoot/right
	name = "blackfoot side door"
	icon_state = "door right"

/obj/structure/interior_exit/vehicle/blackfoot/back
	name = "blackfoot back door"
	icon_state = "rear door closed"
	flags_atom = NO_ZFALL
	var/open = FALSE

/obj/structure/interior_exit/vehicle/blackfoot/back/Initialize()
	. = ..()
	overlays += image('icons/obj/vehicles/interiors/blackfoot_rear_overlay.dmi', "overlay", pixel_x = -32)

/obj/structure/interior_exit/vehicle/blackfoot/back/proc/toggle_open()
	playsound(loc, 'sound/machines/blastdoor.ogg', 25)
	if(open)
		open = FALSE
		flick("door closing", src)
		icon_state = "rear door closed"
	else
		open = TRUE
		flick("door opening", src)
		icon_state = "rear door open"

/obj/structure/machinery/door_control/blackfoot_rear_door
	var/obj/vehicle/multitile/blackfoot/linked_blackfoot
	icon_state = "blackfoot"

/obj/structure/machinery/door_control/blackfoot_rear_door/attack_hand(mob/user)
	linked_blackfoot.toggle_rear_door()

	. = ..()

/obj/effect/landmark/interior/spawn/chimera_loader/on_load(datum/interior/interior)
	var/obj/structure/chimera_loader/loader = new(get_turf(src))

	loader.name = name
	loader.setDir(dir)
	loader.icon_state = icon_state
	loader.alpha = alpha
	loader.update_icon()
	loader.pixel_x = pixel_x
	loader.pixel_y = pixel_y

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		loader.linked_blackfoot = linked_blackfoot

	qdel(src)

/obj/effect/landmark/interior/spawn/blackfoot_rear_door_button
	name = "rear door button"

/obj/effect/landmark/interior/spawn/blackfoot_rear_door_button/on_load(datum/interior/interior)
	var/obj/structure/machinery/door_control/blackfoot_rear_door/door_control = new(get_turf(src))

	door_control.name = name
	door_control.setDir(dir)
	door_control.alpha = alpha
	door_control.update_icon()
	door_control.pixel_x = pixel_x
	door_control.pixel_y = pixel_y

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		door_control.linked_blackfoot = linked_blackfoot

	qdel(src)

/obj/effect/landmark/interior/spawn/entrance/blackfoot_rear_door
	name = "blackfoot back door"
	pixel_x = 0
	pixel_y = 24
	dir = 1
	offset_y = -1
	exit_type = /obj/structure/interior_exit/vehicle/blackfoot/back

/obj/effect/landmark/interior/spawn/entrance/blackfoot_rear_door/on_load(datum/interior/interior)
	var/obj/structure/interior_exit/vehicle/blackfoot/back_door = ..()

	if(!back_door)
		return

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		linked_blackfoot.back_door = back_door

/obj/structure/bed/chair/vehicle/blackfoot
	name = "passenger seat"
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "seat"

/obj/structure/bed/chair/vehicle/blackfoot/top_right_top
	pixel_x = -12
	pixel_y = 10
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/top_right_bottom
	pixel_x = -12
	pixel_y = -6
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/top_left_top
	pixel_x = 12
	pixel_y = 10
	dir = EAST

/obj/structure/bed/chair/vehicle/blackfoot/top_left_bottom
	pixel_x = 12
	pixel_y = -6
	dir = EAST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_right_top
	pixel_x = -12
	pixel_y = 16
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_right_bottom
	pixel_x = -12
	pixel_y = 3
	dir = WEST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_left_top
	pixel_x = 12
	pixel_y = 16
	dir = EAST

/obj/structure/bed/chair/vehicle/blackfoot/bottom_left_bottom
	pixel_x = 12
	pixel_y = 3
	dir = EAST

/obj/structure/bed/chair/comfy/vehicle/driver/blackfoot
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "pilot-chair"
	skill_to_check = SKILL_PILOT

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/blackfoot
	pixel_y = -5

/obj/effect/landmark/interior/spawn/vehicle_driver_seat/blackfoot/on_load(datum/interior/I)
	var/obj/structure/bed/chair/comfy/vehicle/driver/blackfoot/S = new(loc)

	S.icon = icon
	S.icon_state = icon_state
	S.layer = layer
	S.vehicle = I.exterior
	S.required_skill = S.vehicle.required_skill
	S.setDir(dir)
	S.alpha = alpha
	S.update_icon()
	S.handle_rotation()
	S.pixel_x = pixel_x
	S.pixel_y = pixel_y

	qdel(src)

/obj/item/device/walkman/blackfoot_cassette
	name = "\improper integrated cassette player"
	desc = "A jury-rigged cassette player system forcibly installed in place of a short-wave communications radio uplink. The buttons are worn from heavy use."
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "cassette-player-open"
	anchored = TRUE
	pixel_y = 0
	pixel_x = -20
	volume = 50
	volume = 15
	var/obj/vehicle/multitile/blackfoot/linked_blackfoot
	var/list/current_listeners = list()
	var/list/listener_data = list()
	/// Time when the cassette was first played
	var/cassette_start_time
	/// How long until the cassette machine tests if its at the end of its playlist
	var/next_song_timer

/obj/effect/landmark/interior/spawn/walkman/blackfoot_cassette
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "cassette-player-open"

/obj/effect/landmark/interior/spawn/walkman/blackfoot_cassette/on_load(datum/interior/interior)
	var/obj/item/device/walkman/blackfoot_cassette/cassette = new(get_turf(src))

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		cassette.linked_blackfoot = linked_blackfoot

	qdel(src)

/obj/item/device/walkman/blackfoot_cassette/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/device/cassette_tape))
		if(!tape)
			insert_tape(W)
			playsound(src,'sound/weapons/handcuffs.ogg',20,1)
			to_chat(user,SPAN_INFO("You insert \the [W] into \the [src]"))
			update_icon()
		else
			to_chat(user,SPAN_WARNING("Remove the other tape first!"))

/obj/item/device/walkman/blackfoot_cassette/update_icon()
	if(!tape)
		icon_state = "cassette-player-open"
	else
		icon_state = "cassette-player"

/obj/item/device/walkman/blackfoot_cassette/attack_hand(mob/user)
	if(!tape)
		to_chat(user,SPAN_WARNING("There is no tape inserted!"))
		return
	var/use_radials = user.client.prefs?.no_radials_preference ? FALSE : TRUE
	var/list/walkman_verbs = list("Play-Pause" = image('icons/mob/hud/actions.dmi', "walkman_playpause"),"Eject Tape" = image(tape.icon, tape.icon_state),"Next Song" = image('icons/mob/hud/actions.dmi', "walkman_next"),"Restart Song" = image('icons/mob/hud/actions.dmi', "walkman_restart"))
	var/used_verb = use_radials ? show_radial_menu(user, src, walkman_verbs) : tgui_input_list(user, "choose what to do with the cassette:", "Cassette Player", walkman_verbs)
	switch(used_verb)
		if("Play-Pause")
			deltimer(next_song_timer)
			play_pause()
		if("Eject Tape")
			deltimer(next_song_timer)
			eject_cassetetape()
			update_icon()
		if("Next Song")
			deltimer(next_song_timer)
			next_pl_song()
		if("Restart Song")
			deltimer(next_song_timer)
			restart_current_song()

/obj/item/device/walkman/blackfoot_cassette/play(mob/user)
	cassette_start_time = world.time
	next_song_timer = addtimer(CALLBACK(src, PROC_REF(next_song), user), 5 MINUTES, TIMER_STOPPABLE)
	if(!current_listener)
		current_listener = user
		START_PROCESSING(SSobj, src)
	..()

/obj/item/device/walkman/blackfoot_cassette/pause(mob/user)
	if(!current_song)
		return
	paused = TRUE
	for(var/mob/passenger in current_listeners)
		update_song(current_song, passenger, SOUND_PAUSED | SOUND_UPDATE)

/obj/item/device/walkman/blackfoot_cassette/restart_song(mob/user)
	if(user.is_mob_incapacitated() || !current_song)
		return
	cassette_start_time = world.time
	deltimer(next_song_timer)
	next_song_timer = addtimer(CALLBACK(src, PROC_REF(next_song), user), 5 MINUTES, TIMER_STOPPABLE)
	for(var/data in listener_data)
		var/sound/child_song = data["child_song"]
		var/mob/listener = data["listener"]
		child_song.offset = 0
		update_song(current_song, listener, 0)
	to_chat(user,SPAN_INFO("You restart the song"))

/obj/item/device/walkman/blackfoot_cassette/next_song(mob/user)
	if(length(current_playlist) == 0)
		return
	if(pl_index + 1 > length(current_playlist))
		break_sound()
		return
	..()

/obj/item/device/walkman/blackfoot_cassette/break_sound()
	var/sound/break_sound = sound(null, 0, 0, SOUND_CHANNEL_WALKMAN)
	break_sound.priority = 255
	for(var/data in listener_data)
		data["child_song"] = break_sound
		update_song(break_sound, data["listener"], 0)
	current_listener = null
	current_listeners = list()
	listener_data = list()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/walkman/blackfoot_cassette/proc/update_listener_data(mob/listener)
	var/sound/song_child
	for(var/data in listener_data)
		if(listener == data["listener"])
			song_child = data["child_song"]
			song_child.offset = ((world.time - cassette_start_time) / 10)
			current_listeners += listener
	if(listener in current_listeners)
		update_song(song_child, listener)
		return
	song_child = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
	song_child.status = SOUND_STREAM
	song_child.offset = ((world.time - cassette_start_time) / 10)
	var/list/new_listener_data = list(list("listener" = listener, "child_song" = song_child))
	listener_data += new_listener_data
	current_listeners += listener
	update_song(song_child, listener, SOUND_STREAM)

/obj/item/device/walkman/blackfoot_cassette/update_song(sound/song, mob/listener, flags = SOUND_UPDATE)
	if(!listener)
		return
	if(listener.ear_deaf)
		flags |= SOUND_MUTE
	for(var/list/data in listener_data)
		if(listener == data["listener"])
			var/sound/child_song = data["child_song"]
			child_song.status = flags
			child_song.volume = src.volume
			child_song.channel = SOUND_CHANNEL_WALKMAN
			sound_to(listener, child_song)

/obj/item/device/walkman/blackfoot_cassette/process()
	for(var/mob/living/passenger in linked_blackfoot.interior.get_passengers())
		if(!(passenger in current_listeners))
			update_listener_data(passenger)
	for(var/mob/living/carbon/human/mob in current_listeners)
		if((mob.stat & DEAD) || !(mob in linked_blackfoot.interior.get_passengers()))
			current_listeners -= mob
			update_song(current_song, mob, SOUND_MUTE | SOUND_UPDATE)
	if(!length(current_listeners))
		if(current_song)
			current_song = null
		break_sound()
		update_icon()
		STOP_PROCESSING(SSobj, src)
		return

/obj/structure/bed/chair/vehicle/blackfoot/buckle_mob(mob/M, mob/user)
	if (!ismob(M) || (get_dist(src, user) > 1) || user.stat || buckled_mob || M.buckled || !isturf(user.loc))
		return

	if (user.is_mob_incapacitated() || HAS_TRAIT(user, TRAIT_IMMOBILIZED) || HAS_TRAIT(user, TRAIT_FLOORED))
		to_chat(user, SPAN_WARNING("You can't do this right now."))
		return

	if (isxeno(user) && !HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do that, try a nest."))
		return

	if (iszombie(user))
		return

	if(M.loc != loc)
		M.forceMove(loc) //buckle if you're right next to it

		. = buckle_mob(M)

	if (M.mob_size <= MOB_SIZE_XENO)
		if ((M.stat == DEAD && istype(src, /obj/structure/bed/roller) || HAS_TRAIT(M, TRAIT_OPPOSABLE_THUMBS)))
			do_buckle(M, user)
			return
	if ((M.mob_size > MOB_SIZE_HUMAN))
		to_chat(user, SPAN_WARNING("[M] is too big to buckle in."))
		return
	do_buckle(M, user)

/obj/structure/bed/chair/vehicle/blackfoot/afterbuckle(mob/user)
	. = ..()

	if(buckled_mob)
		return

	user.forceMove(get_step(user, dir))

/obj/structure/blackfoot_doorgun
	name = "M866 Automatic Grenade Launcher"
	desc = "A belt-fed blowback operated automatic grenade launcher system, mounted directly to the aft end of the Blackfoot. The superstructure is hydraulically assisted so that the operator can adjust the gun with minimal force input. The gun fires 20mm Hornet-type grenades that disperse smaller caliber projectiles over a wide area, useful for incapacitating a large group of soft targets. "
	icon = 'icons/obj/vehicles/interiors/blackfoot_64x64.dmi'
	icon_state = "doorgun"
	bound_width = 96
	density = FALSE

	var/deployed = FALSE
	var/mob/gunner
	var/obj/vehicle/multitile/blackfoot/linked_blackfoot
	var/user_old_x
	var/user_old_y

/obj/structure/blackfoot_doorgun/update_icon()
	if(deployed)
		icon_state = "doorgun-deployed"
	else
		icon_state = "doorgun"

/obj/structure/blackfoot_doorgun/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You begin [deployed ? "retracting" : "deploying"] the door gun."))

	if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
		return

	to_chat(user, SPAN_NOTICE("You [deployed ? "retract" : "deploy"] the door gun."))

	if(deployed)
		on_unset_interaction(gunner)

	deployed = !deployed
	update_icon()
	density = !density

/obj/structure/blackfoot_doorgun/MouseDrop_T(atom/dropping, mob/user)
	if(!deployed || gunner)
		return

	if(!linked_blackfoot)
		return

	if(dropping != user)
		return

	on_set_interaction(user)

/obj/structure/blackfoot_doorgun/attackby(obj/item/item, mob/user)
	if(!deployed)
		return

	if(!istype(item, /obj/item/ammo_magazine/hardpoint/doorgun_ammo))
		return

	var/obj/item/ammo_magazine/hardpoint/doorgun_ammo/ammo = item
	var/obj/item/hardpoint/secondary/doorgun/doorgun = locate() in linked_blackfoot.hardpoints

	if(!doorgun)
		return

	doorgun.try_add_clip(ammo, user)

/obj/structure/blackfoot_doorgun/proc/update_pixels(mob/user, mounting = TRUE)
	if(mounting)
		var/diff_x = 0
		var/diff_y = 0
		var/tilesize = 32
		var/viewoffset = tilesize * 2
		switch(dir)
			if(NORTH)
				diff_y = -16 + user_old_y
				if(user.client)
					user.client.pixel_x = 0
					user.client.pixel_y = viewoffset
			if(SOUTH)
				diff_y = 16 + user_old_y
				if(user.client)
					user.client.pixel_x = 0
					user.client.pixel_y = -viewoffset
			if(EAST)
				diff_x = -16 + user_old_x
				if(user.client)
					user.client.pixel_x = viewoffset
					user.client.pixel_y = 0
			if(WEST)
				diff_x = 16 + user_old_x
				if(user.client)
					user.client.pixel_x = -viewoffset
					user.client.pixel_y = 0

		animate(user, pixel_x=diff_x, pixel_y=diff_y, 0.4 SECONDS)
	else
		if(user.client)
			user.client.change_view(GLOB.world_view_size)
			user.client.pixel_x = 0
			user.client.pixel_y = 0
		animate(user, pixel_x=user_old_x, pixel_y=user_old_y, 4, 1)

/obj/structure/blackfoot_doorgun/on_set_interaction(mob/user)
	ADD_TRAIT(user, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	user.setDir(dir)
	user.status_flags |= IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] mans [src]."), SPAN_NOTICE("You man [src], locked and loaded!"))
	user_old_x = user.pixel_x
	user_old_y = user.pixel_y
	update_pixels(user)

	RegisterSignal(user, list(COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION), PROC_REF(exit_interaction))
	linked_blackfoot.set_seated_mob(VEHICLE_GUNNER, user)
	if(user && user.client)
		user.client.change_view(8, linked_blackfoot)
	gunner = user

/obj/structure/blackfoot_doorgun/proc/exit_interaction(mob/user)
	SIGNAL_HANDLER

	on_unset_interaction(user)

/obj/structure/blackfoot_doorgun/on_unset_interaction(mob/user)
	REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, INTERACTION_TRAIT)
	user.setDir(dir)
	user.reset_view(null)
	user.status_flags &= ~IMMOBILE_ACTION
	user.visible_message(SPAN_NOTICE("[user] lets go of [src]."), SPAN_NOTICE("You let go of [src], letting the gun rest."))
	user_old_x = 0
	user_old_y = 0
	update_pixels(user, FALSE)
	user.remove_temp_pass_flags(PASS_MOB_THRU)

	UnregisterSignal(user, list(
		COMSIG_MOB_RESISTED,
		COMSIG_MOB_DEATH,
		COMSIG_LIVING_SET_BODY_POSITION,
	))

	if(gunner == user)
		gunner = null

	user.unset_interaction()
	linked_blackfoot.set_seated_mob(VEHICLE_GUNNER, null)

/obj/effect/landmark/interior/spawn/blackfoot_doorgun
	icon = 'icons/obj/vehicles/interiors/blackfoot_64x64.dmi'
	icon_state = "doorgun"

/obj/effect/landmark/interior/spawn/blackfoot_doorgun/on_load(datum/interior/interior)
	var/obj/structure/blackfoot_doorgun/doorgun = new(get_turf(src))

	doorgun.setDir(dir)
	doorgun.alpha = alpha
	doorgun.update_icon()
	doorgun.pixel_x = pixel_x
	doorgun.pixel_y = pixel_y

	if(istype(interior.exterior, /obj/vehicle/multitile/blackfoot))
		var/obj/vehicle/multitile/blackfoot/linked_blackfoot = interior.exterior
		doorgun.linked_blackfoot = linked_blackfoot

	qdel(src)

/turf/open/floor/transparent
	icon_state = "transparent"
