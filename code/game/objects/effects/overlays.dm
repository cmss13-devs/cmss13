/obj/effect/overlay
	name = "overlay"
	unacidable = TRUE
	var/i_attached //Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = FLY_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = FLY_LAYER
	anchored = TRUE

/obj/effect/overlay/coconut
	name = "Coconuts"
	icon = 'icons/turf/floors/beach.dmi'
	icon_state = "coconuts"

/obj/effect/overlay/danger
	name = "Danger"
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "danger"
	layer = ABOVE_FLY_LAYER

	appearance_flags = RESET_COLOR|KEEP_APART

/obj/effect/overlay/temp
	anchored = TRUE
	layer = ABOVE_FLY_LAYER //above mobs
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //can't click to examine it
	var/effect_duration = 10 //in deciseconds

	var/start_on_spawn = TRUE

/obj/effect/overlay/temp/New()
	..()
	flick(icon_state, src)
	if(start_on_spawn)
		QDEL_IN(src, effect_duration)

/obj/effect/overlay/temp/point
	name = "arrow"
	desc = "It's an arrow hanging in mid-air. There may be a wizard about."
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "arrow"
	anchored = TRUE
	effect_duration = 2.5 SECONDS
	var/glide_time = 0.5 SECONDS

	start_on_spawn = FALSE

/obj/effect/overlay/temp/point/Initialize(mapload, mob/M, atom/actual_pointed_atom)
	. = ..()

	if(!M)
		return INITIALIZE_HINT_QDEL

	var/turf/T1 = loc
	var/turf/T2 = M.loc

	if(T2.x && T2.y)
		var/dist_x = (T2.x - T1.x)
		var/dist_y = (T2.y - T1.y)

		pixel_x = dist_x * 32
		pixel_y = dist_y * 32

		var/offset_x = actual_pointed_atom ? get_pixel_position_x(actual_pointed_atom, relative = TRUE) : 0
		var/offset_y = actual_pointed_atom ? get_pixel_position_y(actual_pointed_atom, relative = TRUE) : 0

		animate(src, pixel_x = offset_x, pixel_y = offset_y, time = glide_time, easing = QUAD_EASING)

	QDEL_IN(src, effect_duration + glide_time)

/obj/effect/overlay/temp/point/big
	icon_state = "big_arrow"
	effect_duration = 4 SECONDS

/obj/effect/overlay/temp/point/big/greyscale
	icon_state = "big_arrow_grey"

/obj/effect/overlay/temp/point/big/squad
	icon_state = "big_arrow_grey"

/obj/effect/overlay/temp/point/big/squad/Initialize(mapload, mob/owner, atom/actual_pointed_atom, squad_color)
	. = ..()
	color = squad_color

/obj/effect/overlay/temp/point/big/observer
	icon_state = "big_arrow_grey"
	color = "#1c00f6"
	invisibility = INVISIBILITY_OBSERVER
	plane = GHOST_PLANE

/obj/effect/overlay/temp/point/big/queen
	icon_state = "big_arrow_grey"
	invisibility = INVISIBILITY_MAXIMUM

	var/list/client/clients
	var/image/self_icon

/obj/effect/overlay/temp/point/big/queen/proc/show_to_client(client/C)
	if(!C)
		return

	C.images |= self_icon
	clients |= C


/obj/effect/overlay/temp/point/big/queen/Initialize(mapload, mob/owner)
	. = ..()

	if(!owner)
		return INITIALIZE_HINT_QDEL

	self_icon = image(icon, src, icon_state = icon_state)
	LAZYINITLIST(clients)

	show_to_client(owner.client)

	for(var/i in GLOB.observer_list)
		var/mob/M = i
		show_to_client(M.client)

	for(var/i in GLOB.living_xeno_list)
		var/mob/M = i
		show_to_client(M.client)

/obj/effect/overlay/temp/point/big/queen/Destroy()
	for(var/i in clients)
		var/client/C = i
		if(!C)
			continue

		C.images -= self_icon
		LAZYREMOVE(clients, C)

	clients = null
	self_icon = null

	return ..()

//Special laser for coordinates, not for CAS
/obj/effect/overlay/temp/laser_coordinate
	name = "laser"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_ICON
	light_range = 2
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "laser_target_coordinate"
	effect_duration = 600
	var/obj/item/device/binoculars/range/designator/source_binoc

/obj/effect/overlay/temp/laser_coordinate/Destroy()
	if(source_binoc)
		source_binoc.laser_cooldown = world.time + source_binoc.cooldown_duration
		source_binoc.coord = null
		source_binoc = null
	. = ..()

/obj/effect/overlay/temp/laser_target
	name = "laser"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_ICON
	light_range = 2
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "laser_target2"
	effect_duration = 600
	var/target_id
	var/obj/item/device/binoculars/range/designator/source_binoc
	var/datum/cas_signal/signal
	var/mob/living/carbon/human/user

/obj/effect/overlay/temp/laser_target/New(loc, squad_name, _user, tracking_id)
	..()
	user = _user
	if(squad_name)
		name = "[squad_name] laser"
	if(user && user.faction && GLOB.cas_groups[user.faction])
		signal = new(src)
		signal.name = name
		signal.target_id = tracking_id
		signal.linked_cam = new(loc, name)
		GLOB.cas_groups[user.faction].add_signal(signal)


/obj/effect/overlay/temp/laser_target/Destroy()
	if(signal)
		GLOB.cas_groups[user.faction].remove_signal(signal)
		if(signal.linked_cam)
			qdel(signal.linked_cam)
			signal.linked_cam = null
		qdel(signal)
		signal = null
	if(source_binoc)
		source_binoc.laser_cooldown = world.time + source_binoc.cooldown_duration
		source_binoc.laser = null
		source_binoc = null

	. = ..()

/obj/effect/overlay/temp/laser_target/ex_act(severity) //immune to explosions
	return

/obj/effect/overlay/temp/laser_target/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_DANGER("It's a laser to designate artillery targets, get away from it!")


//used to show where dropship ordnance will impact.
/obj/effect/overlay/temp/blinking_laser
	name = "blinking laser"
	anchored = TRUE
	light_range = 2
	effect_duration = 10
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "laser_target3"

/obj/effect/overlay/temp/guidance_laser
	name = "guidance laser"
	anchored = TRUE
	light_range = 2
	effect_duration = 10
	mouse_opacity = MOUSE_OPACITY_ICON
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "yellow_laser"

/obj/effect/overlay/temp/guidance_laser/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_DANGER("It's a guidance laser from a target designation pod, steer clear of it!")

/obj/effect/overlay/temp/emp_sparks
	icon = 'icons/effects/effects.dmi'
	icon_state = "empdisable"
	name = "emp sparks"
	effect_duration = 10
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/overlay/temp/emp_sparks/New(loc)
	setDir(pick(GLOB.cardinals))
	..()

/obj/effect/overlay/temp/emp_pulse
	name = "emp pulse"
	icon = 'icons/effects/effects.dmi'
	icon_state = "emppulse"
	effect_duration = 20

/obj/effect/overlay/temp/elec_arc
	icon = 'icons/effects/effects.dmi'
	icon_state = "electricity"
	name = "electric arc"
	effect_duration = 3 SECONDS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

//gib animation

/obj/effect/overlay/temp/gib_animation
	icon = 'icons/mob/mob.dmi'
	effect_duration = 14

/obj/effect/overlay/temp/gib_animation/New(Loc, mob/source_mob, gib_icon)
	if(!source_mob)
		return

	pixel_x = source_mob.pixel_x
	pixel_y = source_mob.pixel_y
	icon_state = gib_icon
	..()

/obj/effect/overlay/temp/gib_animation/ex_act(severity)
	return


/obj/effect/overlay/temp/gib_animation/animal
	icon = 'icons/mob/animal.dmi'
	effect_duration = 12


/obj/effect/overlay/temp/gib_animation/xeno
	icon = 'icons/mob/xenos/effects.dmi'
	effect_duration = 10

/obj/effect/overlay/temp/gib_animation/xeno/Initialize(mapload, mob/source_mob, gib_icon, new_icon)
	. = ..()
	if(new_icon)
		icon = new_icon

//dust animation

/obj/effect/overlay/temp/dust_animation
	icon = 'icons/mob/mob.dmi'
	effect_duration = 12

/obj/effect/overlay/temp/dust_animation/New(Loc, mob/source_mob, gib_icon)
	if(!source_mob)
		return

	pixel_x = source_mob.pixel_x
	pixel_y = source_mob.pixel_y
	icon_state = gib_icon
	..()

//acid pool splash animation

/obj/effect/overlay/temp/acid_pool_splash
	name = "acid splash"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "pool_splash"
	effect_duration = 10 SECONDS

/obj/effect/overlay/temp/dropship_reticle
	name = "Targeting Reticle"
	desc = "A targeting reticle for a dropship's HUD."
	icon = 'icons/mob/hud/dropship_hud.dmi'
	icon_state = "direct_fire_reticle"
	anchored = TRUE
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	effect_duration = 600

	var/target_x = null
	var/target_y = null
	var/target_z = null
	var/image/reticle_image = null

	var/shuttle_tag = null

/obj/effect/overlay/temp/dropship_reticle/proc/update_visibility_for_mob(mob/M)
	var/show_reticle = FALSE
	if(GLOB.huds[MOB_HUD_DROPSHIP] && (M in GLOB.huds[MOB_HUD_DROPSHIP].hudusers))
		show_reticle = TRUE
	if(show_reticle)
		var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
		if(dropship_hud)
			dropship_hud.add_hud_to(M, src)
		if(M.client)
			M.client.images += src.get_reticle_image()
	else
		var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
		if(dropship_hud)
			dropship_hud.remove_hud_from(M, src)
		if(M.client)
			M.client.images -= src.get_reticle_image()

/obj/effect/overlay/temp/dropship_reticle/proc/get_reticle_image()
	if(!reticle_image)
		var/turf/T = locate(target_x, target_y, target_z)
		reticle_image = image(icon, T, icon_state, layer)
		reticle_image.plane = ABOVE_LIGHTING_PLANE
	return reticle_image

/obj/effect/overlay/temp/dropship_reticle/proc/update_target(x, y, z)
	target_x = x
	target_y = y
	target_z = z
	reticle_image = null

	// motion detector pulse for boilers
	var/turf/T = locate(x, y, z)
	if(T)
		// Only ping when the dropship is actually in flight
		var/obj/docking_port/mobile/marine_dropship/dropship = shuttle_tag ? SSshuttle.getShuttle(shuttle_tag) : null
		if(istype(dropship) && dropship.mode == SHUTTLE_CALL)
			xeno_psy_ping(T)

/obj/effect/overlay/temp/dropship_reticle/proc/remove_from_all_clients()
	var/image/I = src.get_reticle_image()
	var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
	if(dropship_hud)
		for(var/mob/M in dropship_hud.hudusers)
			if(M.client)
				M.client.images -= I
			dropship_hud.remove_hud_from(M, src)
	for(var/mob/living/carbon/human/M in GLOB.alive_human_list)
		if(M.client)
			M.client.images -= I

/obj/effect/overlay/temp/dropship_reticle/bellygunner
	name = "Belly Gun Targeting Reticle"
	desc = "A targeting reticle for a dropship's belly gun system."
	icon_state = "bellygunner_reticle"

// --- Protection Flag Overlays ---
/obj/effect/overlay/temp/protection_flag
	name = "Protection Flag"
	desc = "Indicates turf protection status."
	icon = 'icons/mob/hud/dropship_hud.dmi'
	anchored = TRUE
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effect_duration = -1
	start_on_spawn = FALSE
	invisibility = INVISIBILITY_MAXIMUM
	var/image/flag_image

/obj/effect/overlay/temp/protection_flag/New(turf/T)
	..()
	if(T)
		forceMove(T)
		update_all_dropship_users()

/obj/effect/overlay/temp/protection_flag/Destroy()
	if(flag_image)
		for(var/client/C in GLOB.clients)
			if(C.images && (flag_image in C.images))
				C.images -= flag_image
	..()

/obj/effect/overlay/temp/protection_flag/proc/get_flag_image()
	if(!flag_image)
		flag_image = image(icon, src, icon_state, layer)
		flag_image.plane = plane
	return flag_image

/obj/effect/overlay/temp/protection_flag/proc/update_all_dropship_users()
	var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
	if(dropship_hud)
		var/image/flag_img = get_flag_image()
		for(var/mob/user in dropship_hud.hudusers)
			if(user.client)
				user.client.images += flag_img

/obj/effect/overlay/temp/protection_flag/antiair
	name = "Anti-Air Protection"
	desc = "This area is protected by anti-air defenses."
	icon_state = "danger_reticle"

/obj/effect/overlay/temp/protection_flag/antiair/update_all_dropship_users()
	// Exclude observers
	var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
	if(dropship_hud)
		var/image/flag_img = get_flag_image()
		for(var/mob/user in dropship_hud.hudusers)
			if(user.client && !isobserver(user))
				user.client.images += flag_img

/obj/effect/overlay/temp/protection_flag/antiair/Destroy()
	if(flag_image)
		var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
		if(dropship_hud)
			for(var/mob/user in dropship_hud.hudusers)
				if(user.client && !isobserver(user))
					user.client.images -= flag_image
	return ..()

/obj/effect/overlay/temp/protection_flag/chaff
	name = "Chaff Protection"
	desc = "This area is protected by chaff countermeasures."
	icon_state = "warning_reticle"

/obj/effect/overlay/temp/protection_flag/chaff/update_all_dropship_users()
	// Exclude observers
	var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
	if(dropship_hud)
		var/image/flag_img = get_flag_image()
		for(var/mob/user in dropship_hud.hudusers)
			if(user.client && !isobserver(user))
				user.client.images += flag_img

/obj/effect/overlay/temp/protection_flag/chaff/Destroy()
	if(flag_image)
		var/datum/mob_hud/dropship/dropship_hud = GLOB.huds[MOB_HUD_DROPSHIP]
		if(dropship_hud)
			for(var/mob/user in dropship_hud.hudusers)
				if(user.client && !isobserver(user))
					user.client.images -= flag_image
	return ..()

/obj/effect/overlay/temp/dropship_reticle/direct
	name = "Impact Reticle"
	desc = "The projected suborbital impact zone for a dropship's HUD."
	icon = 'icons/mob/hud/dropship_hud.dmi'
	icon_state = "impact_reticle"

/obj/effect/overlay/temp/dropship_reticle/direct/proc/spawn_reticle(x, y, z)
	var/obj/effect/overlay/temp/dropship_reticle/direct/O = new()
	O.target_x = x
	O.target_y = y
	O.target_z = z
	O.reticle_image = null
	return O

/obj/effect/overlay/temp/dropship_reticle/direct/New(loc)
	if(loc)
		qdel(src)
		return
	..()

// --- Firemission Reticle ---
/obj/effect/overlay/temp/dropship_reticle/firemission
	name = "Firemission Reticle"
	desc = "The projected firemission target zone for a dropship's HUD."
	icon = 'icons/mob/hud/dropship_hud.dmi'
	icon_state = "firemission_reticle"

/obj/effect/overlay/temp/dropship_reticle/firemission/proc/spawn_reticle(x, y, z)
	var/obj/effect/overlay/temp/dropship_reticle/firemission/O = new()
	O.target_x = x
	O.target_y = y
	O.target_z = z
	O.reticle_image = null
	return O

/obj/effect/overlay/temp/dropship_reticle/firemission/New(loc)
	if(loc)
		qdel(src)
		return
	..()

// --- Xeno Psychic Blip ---

/obj/effect/overlay/temp/psychic_blip
	name = "Psychic Pulse"
	icon = 'icons/mob/hud/xeno_markers.dmi'
	icon_state = "blip"
	anchored = TRUE
	layer = BELOW_FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	effect_duration = 6

/obj/effect/overlay/temp/psychic_blip/proc/get_blip_image()
	var/image/I = image(icon, src, icon_state, layer)
	I.plane = plane
	return I

// dispatches motion detector pings to boily/queen eye whenever dropship reticle moves
/proc/xeno_psy_ping(turf/T)
	if(!T)
		return
	var/area/TA = get_area(T)
	if(!TA)
		return
	for(var/mob/living/carbon/xenomorph/boiler/B in GLOB.living_xeno_list)
		if(QDELETED(B) || !B.is_zoomed)
			continue
		var/area/BA = get_area(B)
		if(BA == TA && B.psychic_pulse_ready())
			B.show_psychic_blip(T)

	for(var/mob/hologram/queen/QE as anything in GLOB.hologram_list)
		if(QDELETED(QE))
			continue
		var/area/QA = get_area(QE)
		if(QA != TA)
			continue
		if(QE.psychic_pulse_ready())
			QE.show_psychic_blip(T)
