/obj/effect/overlay
	name = "overlay"
	unacidable = TRUE
	var/i_attached //Added for possible image attachments to objects. For hallucinations and the like.

/obj/effect/overlay/palmtree_r
	name = "Palm tree"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "palm1"
	density = TRUE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE

/obj/effect/overlay/palmtree_l
	name = "Palm tree"
	icon = 'icons/turf/beach2.dmi'
	icon_state = "palm2"
	density = TRUE
	layer = ABOVE_MOB_LAYER
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

// firemission shadow overlay appears over open/glass roofs only
/proc/show_cas_exit_shadow(turf/start, direction, mission_length, duration, obj/docking_port/mobile/marine_dropship/dropship)
	if(!start || !is_ground_level(start.z) || !(direction in GLOB.cardinals) || !dropship || dropship.cas_shadow_alpha <= 0)
		return
	var/icon/silhouette = dropship.get_cas_shadow_icon(direction)
	if(!silhouette)
		return

	var/dx = (direction == EAST) - (direction == WEST)
	var/dy = (direction == NORTH) - (direction == SOUTH)
	// clear the entire silhouette before entering/leaving the strike corridor.
	var/flight_length = dx ? silhouette.Width() : silhouette.Height()
	var/flight_margin = CEILING(flight_length / world.icon_size / 2, 1) + 1
	var/start_x = start.x - dx * flight_margin
	var/start_y = start.y - dy * flight_margin
	var/end_x = start.x + dx * (mission_length + flight_margin)
	var/end_y = start.y + dy * (mission_length + flight_margin)
	var/radius_x = CEILING(silhouette.Width() / world.icon_size / 2, 1)
	var/radius_y = CEILING(silhouette.Height() / world.icon_size / 2, 1)
	var/turf/lower = locate(max(1, min(start_x, end_x) - radius_x), max(1, min(start_y, end_y) - radius_y), start.z)
	var/turf/upper = locate(min(world.maxx, max(start_x, end_x) + radius_x), min(world.maxy, max(start_y, end_y) + radius_y), start.z)
	var/canvas_width = (upper.x - lower.x + 1) * world.icon_size
	var/canvas_height = (upper.y - lower.y + 1) * world.icon_size
	var/icon/canvas = icon(silhouette)
	canvas.Crop(1, 1, canvas_width, canvas_height)
	canvas.DrawBox("#00000000", 1, 1, canvas_width, canvas_height)
	var/icon/roof_mask = icon(canvas)
	var/has_exposed_ground = FALSE
	for(var/turf/open/ground in block(lower, upper))
		var/area/ground_area = get_area(ground)
		if(ground_area.ceiling != CEILING_NONE && ground_area.ceiling != CEILING_GLASS)
			continue
		var/mask_x = (ground.x - lower.x) * world.icon_size + 1
		var/mask_y = (ground.y - lower.y) * world.icon_size + 1
		roof_mask.DrawBox(COLOR_WHITE, mask_x, mask_y, mask_x + world.icon_size - 1, mask_y + world.icon_size - 1)
		has_exposed_ground = TRUE
	if(!has_exposed_ground)
		return

	// layer filters use offsets from the canvas center
	var/center_x = lower.x + (upper.x - lower.x) / 2
	var/center_y = lower.y + (upper.y - lower.y) / 2
	return new /obj/effect/overlay/temp/cas_exit_shadow(lower, canvas, silhouette, roof_mask, (start_x - center_x) * world.icon_size, (start_y - center_y) * world.icon_size, (end_x - center_x) * world.icon_size, (end_y - center_y) * world.icon_size, duration, dropship.cas_shadow_alpha)

/obj/effect/overlay/temp/cas_exit_shadow
	name = "dropship shadow"
	layer = ABOVE_BLOOD_LAYER
	alpha = 70

/obj/effect/overlay/temp/cas_exit_shadow/New(loc, icon/canvas, icon/silhouette, icon/roof_mask, start_x, start_y, end_x, end_y, duration, peak_alpha)
	effect_duration = duration
	alpha = clamp(peak_alpha, 0, 255)
	icon = canvas
	bound_width = canvas.Width()
	bound_height = canvas.Height()
	. = ..()
	add_filter("aircraft", 1, layering_filter(icon = silhouette, x = start_x, y = start_y, color = "#00000000", transform = matrix()))
	add_filter("roof", 2, alpha_mask_filter(icon = roof_mask))
	var/aircraft = get_filter("aircraft")
	animate(aircraft, x = start_x + (end_x - start_x) * 0.1, y = start_y + (end_y - start_y) * 0.1, color = COLOR_BLACK, time = duration * 0.1, easing = LINEAR_EASING)
	animate(x = start_x + (end_x - start_x) * 0.55, y = start_y + (end_y - start_y) * 0.55, time = duration * 0.45, easing = LINEAR_EASING)
	animate(x = end_x, y = end_y, transform = matrix().Scale(0.45), color = "#00000000", time = duration * 0.45, easing = LINEAR_EASING)

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

//animation of the OB shell actually hitting the ground
/obj/effect/overlay/temp/ob_impact
	name = "ob impact animation"
	effect_duration = 12
	var/atom/shell
	var/size_mod = 1

/obj/effect/overlay/temp/ob_impact/Initialize(mapload, atom/owner, size)
	. = ..()
	if (!owner)
		log_debug("Created a [type] without `owner`")
		qdel(src)
		return
	shell = owner
	size_mod = size
	appearance = shell.appearance
	transform = matrix().Turn(-90)
	transform *= size_mod
	add_filter("motionblur", 1, motion_blur_filter(x = 5, y = 0)) //either im stupid and dont know what its supposed to look like or it needs to be x because it got rotated
	layer = initial(layer)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_y = 6000
	animate(src, pixel_y = -100, time=10)
	animate(icon_state=null, icon=null, time=2) // to vanish it immediately

//same as above but for mortar shells
/obj/effect/overlay/temp/mortar_impact
	name = "mortar impact animation"
	effect_duration = 22
	var/atom/shell

/obj/effect/overlay/temp/mortar_impact/Initialize(mapload, atom/owner)
	. = ..()
	if (!owner)
		log_debug("Created a [type] without `owner`")
		qdel(src)
		return
	shell = owner
	appearance = shell.appearance
	transform = matrix().Turn(-180)
	add_filter("motionblur", 1, motion_blur_filter(x = 0, y = 1))
	layer = initial(layer)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_y = 3000
	animate(src, pixel_y = -50, time=2 SECONDS)
	animate(icon_state=null, icon=null, time=2) // to vanish it immediately

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
