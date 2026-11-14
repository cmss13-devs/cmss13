/obj/structure/vulture_spotter_tripod/tactical
	name = "tactical laser designator"
	desc = "A stabilized laser designator. Capable of lasing into dense or obstructed roofed areas. Drag it onto yourself to look ahead. Ctrl + Click a living target to track it for laser guided munitions, or a turf to lase normally. Ctrl + Click anywhere again to stop lasing."
	icon_state = "rangefinder_scope_deployed"
	skillless = TRUE
	scope_attached = TRUE
	flags_atom = FPRINT|CONDUCT|RELAY_CLICK
	/// Forward zoom range
	var/view_offset = 10
	/// Maximum additional zoom range
	var/max_extra_range = 6
	var/datum/action/tactical_designator_range/range_action
	/// Base lase time at JTAC 1
	var/acquisition_delay = 2 SECONDS
	var/tracking_id
	var/acquiring = FALSE
	/// Invalidates pending lase when it's canceled
	var/acquisition_serial = 0
	var/obj/effect/overlay/temp/laser_target/tactical/laser
	COOLDOWN_DECLARE(cas_acknowledgment_cooldown)

/obj/structure/vulture_spotter_tripod/tactical/Initialize(mapload)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("snow")
			icon_state = "s_" + initial(icon_state)
		if("desert")
			icon_state = "d_" + initial(icon_state)
		if("classic")
			icon_state = "c_" + initial(icon_state)
		if("urban")
			icon_state = "u_" + initial(icon_state)
	desc = initial(desc)
	tracking_id = ++GLOB.cas_tracking_id_increment

/obj/structure/vulture_spotter_tripod/tactical/Destroy()
	QDEL_NULL(laser)
	QDEL_NULL(range_action)
	return ..()

/obj/structure/vulture_spotter_tripod/tactical/deconstruct(disassembled)
	if(disassembled)
		new /obj/item/device/vulture_spotter_tripod(get_turf(src))
		new /obj/item/device/vulture_spotter_scope/designator(get_turf(src))
	else
		playsound(src, 'sound/effects/metal_crash.ogg', 25, TRUE)
	density = FALSE
	qdel(src)

/obj/structure/vulture_spotter_tripod/tactical/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(islarva(xeno) || unslashable)
		return XENO_NO_DELAY_ACTION
	xeno.visible_message(SPAN_DANGER("[xeno] has slashed [src]!"), SPAN_DANGER("You slash [src]!"))
	xeno.animation_attack_on(src)
	xeno.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	health -= rand(xeno.melee_damage_lower, xeno.melee_damage_upper)
	if(health <= 0)
		deconstruct(FALSE)
	return XENO_ATTACK_ACTION

/obj/structure/vulture_spotter_tripod/tactical/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("CAS tracking ID: [tracking_id].")

/obj/structure/vulture_spotter_tripod/tactical/on_screwdriver(mob/user)
	playsound(src, 'sound/items/Screwdriver.ogg', 25, TRUE)
	user.visible_message(SPAN_NOTICE("[user] unscrews the camera from [src] before detaching it."), SPAN_NOTICE("You unscrew the camera from [src], detaching it."))
	do_unscope()
	new /obj/item/device/vulture_spotter_scope/designator(get_turf(src))
	var/obj/structure/vulture_spotter_tripod/tripod = new(get_turf(src))
	tripod.setDir(dir)
	qdel(src)

/obj/structure/vulture_spotter_tripod/tactical/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr && ishuman(usr) && Adjacent(usr))
		try_scope(usr)

/obj/structure/vulture_spotter_tripod/tactical/try_scope(mob/living/carbon/human/user)
	if(scope_using || !user.client || !Adjacent(user) || user.is_mob_incapacitated() || user.body_position != STANDING_UP)
		return
	if(!skillcheck(user, SKILL_JTAC, SKILL_JTAC_BEGINNER))
		to_chat(user, SPAN_WARNING("You don't understand what any of the readings mean!"))
		return
	if(user.l_hand || user.r_hand)
		to_chat(user, SPAN_WARNING("Your hands must be free to use the optics."))
		return
	user.set_interaction(src)

/obj/structure/vulture_spotter_tripod/tactical/on_set_interaction(mob/living/user)
	scope_user = WEAKREF(user)
	scope_using = TRUE
	user.forceMove(loc)
	user.setDir(dir)
	user.client.change_view(scope_zoom, src)
	update_scope_view(user)
	user.overlay_fullscreen("tactical_designator", /atom/movable/screen/fullscreen/tactical_designator)
	RegisterSignal(user.client, COMSIG_PARENT_QDELETING, PROC_REF(do_unscope))
	RegisterSignal(user, list(COMSIG_MOB_PICKUP_ITEM, COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING), PROC_REF(do_unscope))
	ADD_TRAIT(user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Tactical designator"))
	user.status_flags |= IMMOBILE_ACTION
	update_pixels(TRUE)
	give_action(user, /datum/action/vulture_tripod_unscope, null, null, src)
	range_action = give_action(user, /datum/action/tactical_designator_range, null, null, src)
	to_chat(user, SPAN_NOTICE("Use Adjust Scope Range to move the view up to [max_extra_range] tiles farther ahead."))
	to_chat(user, SPAN_NOTICE("Ctrl + Click a living target to mark it for direct CAS fire, or a turf for a standard laser signal. Ctrl + Click anywhere again to stop lasing or cancel acquisition."))

/obj/structure/vulture_spotter_tripod/tactical/on_unset_interaction(mob/living/user)
	acquisition_serial++
	QDEL_NULL(laser)
	QDEL_NULL(range_action)
	user.clear_fullscreen("tactical_designator", FALSE)
	UnregisterSignal(user, list(COMSIG_MOB_PICKUP_ITEM, COMSIG_MOB_RESISTED, COMSIG_MOB_DEATH, COMSIG_LIVING_SET_BODY_POSITION, COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	if(user.client)
		UnregisterSignal(user.client, COMSIG_PARENT_QDELETING)
		user.client.change_view(GLOB.world_view_size, src)
		user.client.set_pixel_x(0)
		user.client.set_pixel_y(0)
	REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Tactical designator"))
	user.status_flags &= ~IMMOBILE_ACTION
	user.reset_view(null)
	update_pixels(FALSE)
	remove_action(user, /datum/action/vulture_tripod_unscope)
	scope_user = null
	scope_using = FALSE

/obj/structure/vulture_spotter_tripod/tactical/proc/update_scope_view(mob/living/user)
	user.client?.set_pixel_x((dir == EAST ? view_offset : (dir == WEST ? -view_offset : 0)) * world.icon_size)
	user.client?.set_pixel_y((dir == NORTH ? view_offset : (dir == SOUTH ? -view_offset : 0)) * world.icon_size)

/obj/structure/vulture_spotter_tripod/tactical/proc/adjust_scope_range(mob/living/user)
	if(scope_user?.resolve() != user || user.interactee != src || !user.client || user.is_mob_incapacitated())
		return
	var/extra_range = tgui_input_number(user, "Additional forward view offset in tiles (0-[max_extra_range]).", "Adjust Scope Range", view_offset - initial(view_offset), max_extra_range, 0)
	if(isnull(extra_range) || QDELETED(src) || QDELETED(user) || scope_user?.resolve() != user || user.interactee != src || !user.client || user.is_mob_incapacitated())
		return
	view_offset = initial(view_offset) + clamp(round(extra_range), 0, max_extra_range)
	update_scope_view(user)
	// Drop an existing designation immediately if it leaves the adjusted view.
	laser?.update_target()
	to_chat(user, SPAN_NOTICE("Scope range set to [view_offset - initial(view_offset)] additional tiles."))

/obj/structure/vulture_spotter_tripod/tactical/clicked(mob/user, list/mods)
	if(mods[CTRL_CLICK] && scope_user?.resolve() == user)
		acquisition_serial++
		QDEL_NULL(laser)
		return TRUE
	return ..()

/// Restrict marks to the forward optic view and an unobstructed laser path.
/obj/structure/vulture_spotter_tripod/tactical/proc/can_designate(atom/target, check_line_of_sight = TRUE)
	var/mob/living/user = scope_user?.resolve()
	if(!user || user.interactee != src || user.is_mob_incapacitated() || !user.client || get_turf(user) != loc)
		return FALSE
	if(!skillcheck(user, SKILL_JTAC, SKILL_JTAC_BEGINNER))
		return FALSE
	if(QDELETED(target) || target.z != z || !is_ground_level(z) || (!isturf(target) && !isturf(target.loc)))
		return FALSE
	var/center_x = x + (dir == EAST ? view_offset : (dir == WEST ? -view_offset : 0))
	var/center_y = y + (dir == NORTH ? view_offset : (dir == SOUTH ? -view_offset : 0))
	if(abs(target.x - center_x) > scope_zoom || abs(target.y - center_y) > scope_zoom || target.invisibility > user.see_invisible)
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(protected_by_pylon(TURF_PROTECTION_CAS, target_turf))
		return FALSE
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target == user || living_target.stat == DEAD || HAS_TRAIT(living_target, TRAIT_ABILITY_BURROWED) || living_target.is_ventcrawling)
			return FALSE
	if(!check_line_of_sight)
		return TRUE
	for(var/turf/path_turf in get_line(src, target, include_start_atom = FALSE))
		if(path_turf.opacity)
			return FALSE
		for(var/atom/blocker in path_turf)
			if(blocker.opacity)
				return FALSE
	return TRUE

/obj/structure/vulture_spotter_tripod/tactical/handle_click(mob/living/carbon/human/user, atom/targeted_atom, list/mods)
	if(!mods[CTRL_CLICK] || mods[CLICK_CATCHER] || scope_user?.resolve() != user)
		return FALSE
	if(laser || acquiring || targeted_atom == src)
		acquisition_serial++
		QDEL_NULL(laser)
		to_chat(user, SPAN_NOTICE("Designation cancelled."))
		return TRUE
	if(!isliving(targeted_atom))
		targeted_atom = get_turf(targeted_atom)
	if(!can_designate(targeted_atom))
		return TRUE
	acquire_target(targeted_atom, user)
	return TRUE

/obj/structure/vulture_spotter_tripod/tactical/proc/acquire_target(atom/target, mob/living/carbon/human/user)
	set waitfor = FALSE
	acquiring = TRUE
	var/current_acquisition = ++acquisition_serial
	playsound(src, 'sound/effects/nightvision.ogg', 35)
	var/jtac_level = clamp(user.skills.get_skill_level(SKILL_JTAC), SKILL_JTAC_BEGINNER, SKILL_JTAC_MAX)
	var/acquisition_time = max(0.5 SECONDS, acquisition_delay - (jtac_level - SKILL_JTAC_BEGINNER) * (0.5 SECONDS))
	var/acquired = do_after(user, acquisition_time, INTERRUPT_ALL, BUSY_ICON_GENERIC, src)
	acquiring = FALSE
	if(!acquired || current_acquisition != acquisition_serial || laser || scope_user?.resolve() != user || !can_designate(target))
		return
	var/laser_name = "[user.assigned_squad ? user.assigned_squad.name : "X"]-[tracking_id]"
	laser = new(get_turf(target), laser_name, user, tracking_id, src, isliving(target) ? target : null)
	if(laser.signal)
		laser.signal.designator_ref = WEAKREF(src)
	playsound(src, 'sound/effects/binoctarget.ogg', 35)
	log_game("Tactical laser [laser_name] designated by [key_name(user)] at ([target.x], [target.y], [target.z]).")
	to_chat(user, SPAN_NOTICE("Target acquired. Keep the target in sight to maintain designation. Ctrl + Click anywhere to stop lasing."))

/obj/structure/vulture_spotter_tripod/tactical/proc/acknowledge_cas_target(obj/structure/machinery/computer/dropship_weapons/console)
	if(!COOLDOWN_FINISHED(src, cas_acknowledgment_cooldown) || !send_cas_target_feedback(src, laser, console))
		return FALSE
	COOLDOWN_START(src, cas_acknowledgment_cooldown, 1 SECONDS)
	return TRUE

/// The marker stays on turf so the CAS camera can view it
/obj/effect/overlay/temp/laser_target/tactical
	var/obj/structure/vulture_spotter_tripod/tactical/designator
	var/mob/living/marked_target
	var/image/mark_overlay
	var/image/direction_overlay
	/// Cached rendering state; unchanged processing ticks must not rebuild overlays.
	var/overlays_initialized = FALSE
	var/last_arrow_angle
	/// Number of guided missiles still tracking this designation.
	var/incoming_missiles = 0

/obj/effect/overlay/temp/laser_target/tactical/New(loc, squad_name, mob/living/carbon/human/user, tracking_id, obj/structure/vulture_spotter_tripod/tactical/designator, mob/living/marked_target)
	if(marked_target)
		icon_state = ""
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	..(loc, squad_name, user, tracking_id)
	src.designator = designator
	src.marked_target = marked_target
	if(signal)
		signal.penetrates_roof = TRUE
		signal.direct_fire_only = !!marked_target
		if(marked_target)
			signal.name += " (direct fire only)"
	if(marked_target)
		mark_overlay = image('icons/effects/Targeted.dmi', icon_state = "laser_lockon")
		direction_overlay = image(icon('icons/effects/Targeted.dmi', "laser_lockon_direction", NORTH))
		direction_overlay.appearance_flags = RESET_TRANSFORM
		update_mark_overlays()
		RegisterSignal(marked_target, COMSIG_MOVABLE_MOVED, PROC_REF(update_target))
		RegisterSignal(marked_target, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH), PROC_REF(target_lost))
	START_PROCESSING(SSobj, src)

/obj/effect/overlay/temp/laser_target/tactical/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(marked_target)
		marked_target.overlays -= mark_overlay
		marked_target.overlays -= direction_overlay
		UnregisterSignal(marked_target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING, COMSIG_MOB_DEATH))
	marked_target = null
	mark_overlay = null
	direction_overlay = null
	if(designator?.laser == src)
		designator.laser = null
	designator = null
	return ..()

/obj/effect/overlay/temp/laser_target/tactical/process()
	update_target()

/obj/effect/overlay/temp/laser_target/tactical/proc/target_lost()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/overlay/temp/laser_target/tactical/proc/update_target()
	SIGNAL_HANDLER
	if(!can_track_target())
		qdel(src)
		return
	if(marked_target)
		var/turf/target_turf = get_turf(marked_target)
		if(loc != target_turf)
			forceMove(target_turf)
			signal?.linked_cam?.forceMove(loc)
		update_mark_overlays()

/obj/effect/overlay/temp/laser_target/tactical/proc/can_track_target()
	return designator?.can_designate(marked_target ? marked_target : get_turf(src), check_line_of_sight = !!marked_target)

/// Switch between locked on and incoming missile target effects.
/obj/effect/overlay/temp/laser_target/tactical/proc/change_incoming_missiles(amount)
	var/was_incoming = incoming_missiles > 0
	incoming_missiles = max(0, incoming_missiles + amount)
	if(was_incoming != (incoming_missiles > 0))
		update_mark_overlays()

/obj/effect/overlay/temp/laser_target/tactical/proc/update_mark_overlays()
	if(QDELETED(marked_target) || !mark_overlay || !direction_overlay)
		return
	var/next_state = incoming_missiles ? "laser_fired" : "laser_lockon"
	var/offset_x = -marked_target.pixel_x + marked_target.base_pixel_x
	var/offset_y = (marked_target.icon_size - world.icon_size) * 0.5 - marked_target.pixel_y + marked_target.base_pixel_y
	var/position_changed = mark_overlay.pixel_x != offset_x || mark_overlay.pixel_y != offset_y
	if(!overlays_initialized || position_changed || mark_overlay.icon_state != next_state)
		marked_target.overlays -= mark_overlay
		mark_overlay.icon_state = next_state
		mark_overlay.pixel_x = offset_x
		mark_overlay.pixel_y = offset_y
		marked_target.overlays += mark_overlay

	var/arrow_angle = Get_Angle(marked_target, user ? user : designator)
	if(!overlays_initialized || position_changed || last_arrow_angle != arrow_angle)
		marked_target.overlays -= direction_overlay
		direction_overlay.pixel_x = offset_x
		direction_overlay.pixel_y = offset_y
		if(!overlays_initialized || last_arrow_angle != arrow_angle)
			var/matrix/arrow_rotation = matrix()
			arrow_rotation.Turn(arrow_angle)
			direction_overlay.transform = arrow_rotation
			last_arrow_angle = arrow_angle
		marked_target.overlays += direction_overlay
	overlays_initialized = TRUE

/datum/action/tactical_designator_range
	name = "Adjust Scope Range"
	action_icon_state = "designator_range"
	var/datum/weakref/designator

/datum/action/tactical_designator_range/New(target, override_icon_state, obj/structure/vulture_spotter_tripod/tactical/designator)
	. = ..()
	src.designator = WEAKREF(designator)

/datum/action/tactical_designator_range/action_activate()
	. = ..()
	var/obj/structure/vulture_spotter_tripod/tactical/tripod = designator?.resolve()
	if(tripod && owner)
		tripod.adjust_scope_range(owner)

/// Scout designators share moving CAS marks and warnings, but retain roof restrictions
/obj/effect/overlay/temp/laser_target/tactical/scout
	var/turf/operator_turf

/obj/effect/overlay/temp/laser_target/tactical/scout/New(loc, squad_name, mob/living/carbon/human/user, tracking_id, obj/item/device/binoculars/range/designator/scout/source_binoc, mob/living/marked_target)
	src.source_binoc = source_binoc
	operator_turf = get_turf(user)
	..(loc, squad_name, user, tracking_id, null, marked_target)
	if(signal)
		signal.penetrates_roof = FALSE
	RegisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING), PROC_REF(target_lost))

/obj/effect/overlay/temp/laser_target/tactical/scout/Destroy()
	if(user)
		UnregisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_DEATH, COMSIG_PARENT_QDELETING))
	if(source_binoc)
		SEND_SIGNAL(source_binoc, COMSIG_DESIGNATOR_LASE_OFF)
	operator_turf = null
	return ..()

/obj/effect/overlay/temp/laser_target/tactical/scout/can_track_target()
	var/obj/item/device/binoculars/range/designator/scout/source = source_binoc
	return !QDELETED(source) && get_turf(user) == operator_turf && source.can_designate_target(marked_target, user)
