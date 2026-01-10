GLOBAL_DATUM(railgun_eye_location, /datum/coords)

/datum/railgun_computer_location
	var/datum/coords/coords
	var/direction

/obj/effect/landmark/railgun_computer
	name = "Railgun computer landmark"
	icon_state = "computer_spawn"
	desc = "A computer with an orange interface, it's idly blinking, awaiting a password."

/obj/effect/landmark/railgun_computer/Initialize(mapload, ...)
	. = ..()
	var/obj/structure/machinery/computer/railgun/RG = new(loc)
	RG.dir = dir
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/railgun_camera_pos
	name = "Railgun camera position landmark"
	icon_state = "railgun_cam"

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
	var/ammo_recharge_time = 30 SECONDS

	var/fire_cooldown = 1.5 SECONDS
	var/next_fire = 0

	var/power = 900
	var/range = 2

	/// Computer and Railgun can only be used if this variable is cleared
	var/locked = TRUE

/obj/structure/machinery/computer/railgun/Initialize()
	. = ..()

	if(is_admin_level(SSmapping.ground_start) || is_mainship_level(SSmapping.ground_start))
		return

	if(!GLOB.railgun_eye_location)
#ifndef UNIT_TESTS
		stack_trace("Railgun eye location is not initialised! There is no landmark for it on [SSmapping.configs[GROUND_MAP].map_name]")
#endif
		return INITIALIZE_HINT_QDEL
	target_z = GLOB.railgun_eye_location.z_pos

/obj/structure/machinery/computer/railgun/attackby(obj/I as obj, mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/railgun/bullet_act(obj/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/railgun/proc/set_operator(mob/living/carbon/human/H)
	if(!istype(H))
		return
	remove_current_operator()

	operator = H
	RegisterSignal(operator, COMSIG_PARENT_QDELETING, PROC_REF(remove_current_operator))
	RegisterSignal(operator, COMSIG_MOVABLE_MOVED, PROC_REF(remove_current_operator))
	RegisterSignal(operator, COMSIG_MOB_POST_CLICK, PROC_REF(fire_gun))

	if(!last_location)
		if(GLOB.railgun_eye_location)
			last_location = GLOB.railgun_eye_location.get_turf_from_coord()
		else
			last_location = locate(1, 1, target_z)

		start_location = last_location

	eye = new(last_location, operator)
	RegisterSignal(eye, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_and_set_zlevel))
	RegisterSignal(eye, COMSIG_PARENT_QDELETING, PROC_REF(remove_current_operator))

/obj/structure/machinery/computer/railgun/proc/check_and_set_zlevel(mob/hologram/railgun/hologram, turf/NewLoc, direction)
	SIGNAL_HANDLER
	if(!start_location)
		start_location = GLOB.railgun_eye_location.get_turf_from_coord()

	if(!NewLoc || (NewLoc.z != target_z && hologram.z != target_z))
		hologram.forceMove(start_location)
		return COMPONENT_OVERRIDE_MOVE

/obj/structure/machinery/computer/railgun/proc/can_fire(mob/living/carbon/human/H, turf/T)
	if(T.z != target_z)
		return FALSE

	if(locked)
		to_chat(H, SPAN_WARNING("Railgun Safeties are on, unable to fire!"))
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
		addtimer(CALLBACK(src, PROC_REF(recharge_ammo)), ammo_recharge_time, TIMER_UNIQUE|TIMER_OVERRIDE)

	if(operator)
		to_chat(operator, SPAN_NOTICE("[icon2html(src)] Loaded in a shell [SPAN_BOLD("([ammo]/[max_ammo] shells left).")]"))

/obj/effect/warning/railgun
	color = "#0000ff"

/obj/structure/machinery/computer/railgun/proc/fire_gun(mob/living/carbon/human/H, atom/A, mods)
	SIGNAL_HANDLER

	if(!H.client)
		return

	var/turf/T = get_turf(A)
	if(!istype(T))
		return

	if(!can_fire(H, T))
		return

	next_fire = world.time + fire_cooldown

	addtimer(CALLBACK(src, PROC_REF(recharge_ammo)), ammo_recharge_time, TIMER_UNIQUE)
	ammo--

	to_chat(H, SPAN_NOTICE("[icon2html(src)] Firing shell. [SPAN_BOLD("([ammo]/[max_ammo] shells left).")]"))

	var/obj/effect/warning/railgun/warning_zone = new(T)

	var/image/I = image(warning_zone.icon, warning_zone.loc, warning_zone.icon_state, warning_zone.layer)
	I.color = warning_zone.color

	H.client.images += I
	playsound_client(H.client, 'sound/machines/railgun/railgun_shoot.ogg')

	addtimer(CALLBACK(src, PROC_REF(land_shot), T, H.client, warning_zone, I), 10 SECONDS)

/obj/structure/machinery/computer/railgun/proc/land_shot(turf/T, client/firer, obj/effect/warning/droppod/warning_zone, image/to_remove)
	if(warning_zone)
		qdel(warning_zone)

	if(firer)
		firer.images -= to_remove
		playsound(T, 'sound/machines/railgun/railgun_impact.ogg', sound_range = 75)
		cell_explosion(T, power, power/range, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("railgun", firer.mob))

/obj/structure/machinery/computer/railgun/proc/remove_current_operator()
	SIGNAL_HANDLER
	if(!operator)
		return

	if(eye)
		last_location = eye.loc
		if(eye.gc_destroyed)
			eye = null
		else
			QDEL_NULL(eye)

	UnregisterSignal(operator, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOB_POST_CLICK
	))
	operator.update_sight()
	operator = null

/obj/structure/machinery/computer/railgun/attack_hand(mob/living/carbon/human/H)
	if(..())
		return

	if(!istype(H))
		return

	if(locked)
		to_chat(H, SPAN_WARNING("The railgun safeties prevent you from using the firing system!"))
		return FALSE

	if(operator && operator.stat == CONSCIOUS)
		to_chat(H, SPAN_WARNING("Someone is already using this computer!"))
		return

	#define INPUT_COORD "Input Co-ordinates"
	if(tgui_alert(H, "View a specific co-ordinate, or continue without inputting a co-ordinate?", \
		"Railgun Computer", list(INPUT_COORD, "Continue without inputting a co-ordinate")) == INPUT_COORD)
		var/x_coord = tgui_input_real_number(H, "Longitude")
		var/y_coord = tgui_input_real_number(H, "Latitude")

		if(!x_coord || !y_coord)
			return

		last_location = locate(deobfuscate_x(x_coord), deobfuscate_y(y_coord), target_z)
	#undef INPUT_COORD

	set_operator(H)

/mob/hologram/railgun
	name = "Camera"
	density = FALSE

/mob/hologram/railgun/handle_view(mob/M, atom/target)
	. = ..()

	if(M.client?.prefs?.custom_cursors)
		M.client.mouse_pointer_icon = 'icons/effects/mouse_pointer/mecha_mouse.dmi'

/mob/hologram/railgun/Initialize(mapload, mob/M)
	. = ..()

	if(!M)
		return

	if(allow_turf_entry(src, loc) & COMPONENT_TURF_DENY_MOVEMENT)
		loc = GLOB.railgun_eye_location.get_turf_from_coord()
		to_chat(M, SPAN_WARNING("[icon2html(src)] Observation area was blocked. Switched to a viewable location."))

	RegisterSignal(M, COMSIG_HUMAN_UPDATE_SIGHT, PROC_REF(see_only_turf))
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTER, PROC_REF(allow_turf_entry))
	M.update_sight()

/mob/hologram/railgun/Destroy()
	if(linked_mob)
		UnregisterSignal(linked_mob, COMSIG_HUMAN_UPDATE_SIGHT)
		linked_mob.update_sight()

	return ..()

/mob/hologram/railgun/proc/see_only_turf(mob/living/carbon/human/H)
	SIGNAL_HANDLER

	H.see_in_dark = 50
	H.sight = (SEE_TURFS|BLIND)
	H.see_invisible = SEE_INVISIBLE_MINIMUM
	return COMPONENT_OVERRIDE_UPDATE_SIGHT

/mob/hologram/railgun/proc/allow_turf_entry(mob/self, turf/to_enter)
	SIGNAL_HANDLER

	if(protected_by_pylon(TURF_PROTECTION_OB, to_enter))
		to_chat(linked_mob, SPAN_WARNING("[icon2html(src)] This area is too reinforced to enter."))
		return COMPONENT_TURF_DENY_MOVEMENT

	if(istype(to_enter, /turf/closed/wall))
		var/turf/closed/wall/W = to_enter
		if(W.turf_flags & TURF_HULL)
			return COMPONENT_TURF_DENY_MOVEMENT

	return COMPONENT_TURF_ALLOW_MOVEMENT

