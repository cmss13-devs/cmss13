GLOBAL_LIST_EMPTY_TYPED(railgun_computer_turf_position, /datum/railgun_computer_location)
GLOBAL_DATUM(railgun_eye_location, /datum/coords)

/datum/tech/railgun
	name = "Enable Stellar Vessel Armements"
	desc = "Enables the two railguns attached to CIC, allowing for bombardment of enemy positions."
	icon_state = "railgun"

	flags = TREE_FLAG_MARINE

	required_points = 20
	tier = /datum/tier/three
	var/obj/structure/machinery/computer/railgun/railgun_type = /obj/structure/machinery/computer/railgun

/datum/tech/railgun/ui_static_data(mob/user)
	. = ..()
	.["stats"] += list(
		list(
			"content" = "Maximum Ammo: [initial(railgun_type.max_ammo)]",
			"color" = "green",
			"icon" = "warehouse"
		),
		list(
			"content" = "Ammo Recharge Time: [DisplayTimeText(initial(railgun_type.ammo_recharge_time), 1)]",
			"color" = "green",
			"icon" = "battery-three-quarters"
		),
		list(
			"content" = "Devastation Range: [initial(railgun_type.range)]",
			"color" = "red",
			"icon" = "bomb"
		)
	)

/datum/tech/railgun/on_unlock()
	. = ..()

	for(var/a in GLOB.railgun_computer_turf_position)
		var/datum/railgun_computer_location/RCL = a
		var/turf/T = RCL.coords.get_turf_from_coord()
		if(!T)
			continue

		var/obj/structure/machinery/computer/railgun/RG = new railgun_type(T)
		RG.dir = RCL.direction

/datum/railgun_computer_location
	var/datum/coords/coords
	var/direction

/obj/effect/landmark/railgun_computer
	name = "Railgun computer landmark"

/obj/effect/landmark/railgun_computer/Initialize(mapload, ...)
	. = ..()
	var/datum/railgun_computer_location/RCL = new()
	RCL.coords = new(loc)
	RCL.direction = dir

	GLOB.railgun_computer_turf_position.Add(RCL)

	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/railgun_camera_pos
	name = "Railgun camera position landmark"

/obj/effect/landmark/railgun_camera_pos/Initialize(mapload, ...)
	. = ..()

	GLOB.railgun_eye_location = new(loc)

	return INITIALIZE_HINT_QDEL

/obj/structure/machinery/computer/railgun
	name = "railgun computer"

	icon_state = "terminal"

	var/mob/hologram/railgun/eye
	var/turf/last_location
	var/turf/start_location
	var/target_z

	var/max_ammo = 10
	var/ammo = 10
	var/ammo_recharge_time = 15 SECONDS

	var/fire_cooldown = 1.5 SECONDS
	var/next_fire = 0

	var/power = 900
	var/range = 2

/obj/structure/machinery/computer/railgun/Initialize()
	. = ..()
	if(!GLOB.railgun_eye_location)
		stack_trace("Railgun eye location is not initialised! There is no landmark for it on [SSmapping.configs[GROUND_MAP].map_name]")
		return INITIALIZE_HINT_QDEL

	target_z = GLOB.railgun_eye_location.z_pos

/obj/structure/machinery/computer/railgun/attackby(var/obj/I as obj, var/mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/railgun/bullet_act(var/obj/item/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/railgun/proc/set_operator(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	remove_current_operator()

	operator = H
	RegisterSignal(operator, COMSIG_PARENT_QDELETING, .proc/remove_current_operator)
	RegisterSignal(operator, COMSIG_MOVABLE_MOVED, .proc/remove_current_operator)
	RegisterSignal(operator, COMSIG_MOB_POST_CLICK, .proc/fire_gun)

	if(!last_location)
		if(GLOB.railgun_eye_location)
			last_location = GLOB.railgun_eye_location.get_turf_from_coord()
		else
			last_location = locate(1, 1, target_z)

		start_location = last_location

	eye = new(last_location, operator)
	RegisterSignal(eye, COMSIG_MOVABLE_PRE_MOVE, .proc/check_and_set_zlevel)
	RegisterSignal(eye, COMSIG_PARENT_QDELETING, .proc/remove_current_operator)

/obj/structure/machinery/computer/railgun/proc/check_and_set_zlevel(var/mob/hologram/railgun/H, var/turf/NewLoc, var/direction)
	SIGNAL_HANDLER
	if(!start_location)
		start_location = GLOB.railgun_eye_location.get_turf_from_coord()

	if(!NewLoc || (NewLoc.z != target_z && H.z != target_z))
		H.loc = start_location
		return COMPONENT_OVERRIDE_MOVE

/obj/structure/machinery/computer/railgun/proc/can_fire(var/mob/living/carbon/human/H, var/turf/T)
	if(T.z != target_z)
		return FALSE

	if(istype(T, /turf/open/space)) // No firing into space
		return FALSE

	if(protected_by_pylon(TURF_PROTECTION_OB, T))
		to_chat(H, SPAN_WARNING("[icon2html(src)] This area is too reinforced to fire into."))
		return FALSE

	if(next_fire > world.time)
		to_chat(H, SPAN_WARNING("[icon2html(src)] The barrel is still hot! Wait [SPAN_BOLD((next_fire - world.time)/10)] more seconds before firing."))
		return FALSE

	if(ammo <= 0)
		to_chat(H, SPAN_WARNING("[icon2html(src)] No more shells remaining in the barrel. Please wait for automatic reloading. [SPAN_BOLD("([ammo]/[max_ammo])")]"))
		return FALSE

	return TRUE

/obj/structure/machinery/computer/railgun/proc/recharge_ammo()
	ammo = min(ammo + 1, max_ammo)

	if(ammo < max_ammo)
		addtimer(CALLBACK(src, .proc/recharge_ammo), ammo_recharge_time, TIMER_UNIQUE|TIMER_OVERRIDE)

	if(operator)
		to_chat(operator, SPAN_NOTICE("[icon2html(src)] Loaded in a shell [SPAN_BOLD("([ammo]/[max_ammo] shells left).")]"))

/obj/effect/warning/railgun
	color = "#0000ff"

/obj/structure/machinery/computer/railgun/proc/fire_gun(var/mob/living/carbon/human/H, var/atom/A, var/mods)
	SIGNAL_HANDLER

	if(!H.client)
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	if(!can_fire(H, T))
		return

	next_fire = world.time + fire_cooldown

	addtimer(CALLBACK(src, .proc/recharge_ammo), ammo_recharge_time, TIMER_UNIQUE)
	ammo -= 1

	to_chat(H, SPAN_NOTICE("[icon2html(src)] Firing shell. [SPAN_BOLD("([ammo]/[max_ammo] shells left).")]"))

	var/obj/effect/warning/railgun/warning_zone = new(T)

	var/image/I = image(warning_zone.icon, warning_zone.loc, warning_zone.icon_state, warning_zone.layer)
	I.color = warning_zone.color

	H.client.images += I
	playsound_client(H.client, 'sound/machines/railgun/railgun_shoot.ogg')

	addtimer(CALLBACK(src, .proc/land_shot, T, H.client, warning_zone, I), 10 SECONDS)

/obj/structure/machinery/computer/railgun/proc/land_shot(var/turf/T, var/client/firer, var/obj/effect/warning/droppod/warning_zone, var/image/to_remove)
	if(warning_zone)
		qdel(warning_zone)

	if(firer)
		firer.images -= to_remove
		playsound(T, 'sound/machines/railgun/railgun_impact.ogg', sound_range = 75)
		cell_explosion(T, power, power/range, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, "railgun", firer.mob)

/obj/structure/machinery/computer/railgun/proc/remove_current_operator()
	SIGNAL_HANDLER
	if(!operator) return

	if(eye)
		last_location = eye.loc
		if(eye.gc_destroyed)
			eye = null
		else
			QDEL_NULL(eye)

	UnregisterSignal(operator, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_PRE_MOVE,
		COMSIG_MOB_POST_CLICK
	))
	operator.update_sight()
	operator = null

/obj/structure/machinery/computer/railgun/attack_hand(var/mob/living/carbon/human/H)
	if(..())
		return

	if(!istype(H))
		return

	if(operator && operator.stat == CONSCIOUS)
		to_chat(H, SPAN_WARNING("Someone is already using this computer!"))
		return

	#define INPUT_COORD "Input Co-ordinates"
	if(tgui_alert(H, "View a specific co-ordinate, or continue without inputting a co-ordinate?", \
		"Railgun Computer", list(INPUT_COORD, "Continue without inputting a co-ordinate")) == INPUT_COORD)
		var/x_coord = input(H, "Longitude") as num|null
		var/y_coord = input(H, "Latitude") as num|null

		if(!x_coord || !y_coord)
			return

		last_location = locate(deobfuscate_x(x_coord), deobfuscate_y(y_coord), target_z)
	#undef INPUT_COORD

	set_operator(H)

/mob/hologram/railgun
	name = "Camera"
	density = FALSE
	mouse_icon = 'icons/effects/mouse_pointer/mecha_mouse.dmi'

/mob/hologram/railgun/Initialize(mapload, mob/M)
	. = ..(mapload, M)

	if(allow_turf_entry(src, loc) & COMPONENT_TURF_DENY_MOVEMENT)
		loc = GLOB.railgun_eye_location.get_turf_from_coord()
		to_chat(M, SPAN_WARNING("[icon2html(src)] Observation area was blocked. Switched to a viewable location."))

	RegisterSignal(M, COMSIG_HUMAN_UPDATE_SIGHT, .proc/see_only_turf)
	RegisterSignal(src, COMSIG_TURF_ENTER, .proc/allow_turf_entry)
	M.update_sight()

/mob/hologram/railgun/Destroy()
	UnregisterSignal(linked_mob, COMSIG_HUMAN_UPDATE_SIGHT)
	linked_mob.update_sight()

	return ..()

/mob/hologram/railgun/proc/see_only_turf(var/mob/living/carbon/human/H)
	SIGNAL_HANDLER

	H.see_in_dark = 50
	H.sight = (SEE_TURFS|BLIND)
	H.see_invisible = SEE_INVISIBLE_MINIMUM
	return COMPONENT_OVERRIDE_UPDATE_SIGHT

/mob/hologram/railgun/proc/allow_turf_entry(var/mob/self, var/turf/to_enter)
	SIGNAL_HANDLER

	if(protected_by_pylon(TURF_PROTECTION_OB, to_enter))
		to_chat(linked_mob, SPAN_WARNING("[icon2html(src)] This area is too reinforced to enter."))
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(to_enter, /turf/closed/wall))
		var/turf/closed/wall/W = to_enter
		if(W.hull)
			return COMPONENT_TURF_DENY_MOVEMENT

	return COMPONENT_TURF_ALLOW_MOVEMENT

