
// Special cases abound, handled below or in subclasses
/obj/vehicle/multitile/attackby(obj/item/O, mob/user)
	// Are we trying to install stuff?
	if(istype(O, /obj/item/hardpoint))
		var/obj/item/hardpoint/HP = O
		install_hardpoint(HP, user)
		return

	if(ispowerclamp(O))
		var/obj/item/powerloader_clamp/PC = O
		if(PC.linked_powerloader && PC.loaded && istype(PC.loaded, /obj/item/hardpoint))
			install_hardpoint(PC, user)
			return

	// Are we trying to remove stuff?
	if(HAS_TRAIT(O, TRAIT_TOOL_CROWBAR) || ispowerclamp(O))
		uninstall_hardpoint(O, user)
		return

	// Are we trying to repair the frame?
	if(iswelder(O) || HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		handle_repairs(O, user)
		return

	// Are we trying to immobilize the vehicle?
	if(istype(O, /obj/item/vehicle_clamp))
		if(clamped)
			to_chat(user, SPAN_WARNING("[src] already has a [O.name] attached."))
			return

		//only can clamp friendly vehicles
		if(!get_target_lock(user.faction_group))
			to_chat(user, SPAN_WARNING("You can attach clamp to vehicles of your faction only."))
			return

		if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			to_chat(user, SPAN_WARNING("You don't know how to use \the [O.name]."))
			return

		for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
			user.visible_message(SPAN_WARNING("[user] attaches the vehicle clamp to \the [src]."), SPAN_NOTICE("You attach the vehicle clamp to \the [src] and lock the mechanism."))
			attach_clamp(O, user)
			return

		to_chat(user, SPAN_WARNING("There are no treads or wheels to attach \the [O.name] to."))
		return

	// Are we trying to remove a vehicle clamp?
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		if(!clamped)
			return

		user.visible_message(SPAN_WARNING("[user] starts removing the vehicle clamp from [src]."), SPAN_NOTICE("You start removing the vehicle clamp from [src]."))
		if(skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user] stops removing the vehicle clamp from [src]."), SPAN_WARNING("You stop removing the vehicle clamp from [src]."))
				return
			user.visible_message(SPAN_WARNING("[user] swiftly removes the vehicle clamp from [src]."), SPAN_NOTICE("You skillfully unlock the mechanism and swiftly remove the vehicle clamp from [src]."))
		else
			if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user] stops removing the vehicle clamp from [src]."), SPAN_WARNING("You stop removing the vehicle clamp from [src]."))
				return
			user.visible_message(SPAN_WARNING("[user] clumsily removes the vehicle clamp from [src]."), SPAN_NOTICE("You manage to unlock vehicle clamp and take it off [src]."))
		detach_clamp(user)
		return

	//try to fit something in vehicle without getting in ourselves
	if(istype(O, /obj/item/grab) && ishuman(user)) //only humans are allowed to fit dragged stuff inside
		if(user.a_intent == INTENT_HELP)
			var/mob_x = user.x - src.x
			var/mob_y = user.y - src.y
			for(var/entrance in entrances)
				var/entrance_coord = entrances[entrance]
				if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
					var/obj/item/grab/G = O
					var/atom/dragged_atom = G.grabbed_thing
					if(istype(/obj/item/explosive/grenade, dragged_atom))
						var/obj/item/explosive/grenade/nade = dragged_atom
						if(!nade.active) //very creative, but no.
							break

					handle_fitting_pulled_atom(user, dragged_atom)
					return
		else
			to_chat(user, SPAN_INFO("Use [SPAN_HELPFUL("HELP")] intent to put a pulled object or creature into the vehicle without getting inside yourself."))
			handle_player_entrance(user)
			return

	if(istype(O, /obj/item/device/motiondetector))
		if(!interior)
			to_chat(user, SPAN_WARNING("It appears that [O] cannot establish borders of space inside \the [src]. (PLEASE, TELL A DEV, SOMETHING BROKE)"))
			return
		var/obj/item/device/motiondetector/MD = O

		if(!MD.active)
			to_chat(user, SPAN_WARNING("\The [MD] must be activated in order to scan \the [src]'s interior."))
			return

		user.visible_message(SPAN_WARNING("[user] fumbles with \the [MD] aimed at \the [src]."), SPAN_NOTICE("You start recalibrating \the [MD] to scan \the [src]'s interior for signatures."))
		if(!do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			user.visible_message(SPAN_WARNING("[user] stops fumbling with \the [MD]."), SPAN_WARNING("You stop trying to scan \the [src]'s interior."))
			return
		if(get_dist(src, user) > 2)
			to_chat(user, SPAN_WARNING("You are too far from \the [src]."))
			return

		user.visible_message(SPAN_WARNING("[user] finishes fumbling with \the [MD]."), SPAN_NOTICE("You finish recalibrating \the [MD] and scanning \the [src]'s interior for signatures."))

		interior.update_passenger_count()

		var/humans_inside = 0
		if(length(interior.role_reserved_slots))
			for(var/datum/role_reserved_slots/RRS in interior.role_reserved_slots)
				humans_inside += RRS.taken
		humans_inside += interior.passengers_taken_slots

		var/msg = ""
		if(humans_inside || interior.xenos_taken_slots)
			msg += "\The [MD] shows [humans_inside ? ("approximately [SPAN_HELPFUL(humans_inside)] signatures") : "no signatures"] of unknown affiliation\
			[interior.xenos_taken_slots ? (" and about [SPAN_HELPFUL(interior.xenos_taken_slots)] abnormal signatures") : ""] inside of \the [src]."
			MD.show_blip(user, src)
			playsound(user, pick('sound/items/detector_ping_1.ogg', 'sound/items/detector_ping_2.ogg', 'sound/items/detector_ping_3.ogg', 'sound/items/detector_ping_4.ogg'), 60, FALSE, 7, 2)
			to_chat(user, SPAN_NOTICE(msg))
		else
			playsound(user, 'sound/items/detector.ogg', 60, FALSE, 7, 2)
			to_chat(user, SPAN_WARNING("\The [MD] can't pick up any signatures, so the vehicle should be empty. In theory."))
		return

	if(user.a_intent != INTENT_HARM)
		handle_player_entrance(user)
		return

	take_damage_type(O.force * 0.05, "blunt", user) //Melee weapons from people do very little damage

// Frame repairs on the vehicle itself
/obj/vehicle/multitile/proc/handle_repairs(obj/item/O, mob/user)
	if(user.action_busy)
		return
	var/max_hp = initial(health)
	if(health > max_hp)
		health = max_hp
		to_chat(user, SPAN_NOTICE("The hull is fully intact."))
		for(var/obj/item/hardpoint/holder/H in hardpoints)
			if(H.health > 0)
				if(!iswelder(O))
					to_chat(user, SPAN_WARNING("You need welding tool to repair \the [H.name]."))
					return
				if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
					to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
					return
				H.handle_repair(O, user)
				update_icon()
				return
			else
				to_chat(user, SPAN_WARNING("[H] is beyond repairs!"))
				return

	var/repair_message = "welding structural struts back in place"
	var/sound_file = 'sound/items/weldingtool_weld.ogg'
	var/obj/item/tool/weldingtool/WT

	// For health < 75%, the frame needs welderwork, otherwise wrench
	if(health < max_hp * 0.75)
		if(!iswelder(O))
			to_chat(user, SPAN_NOTICE("The frame is way too busted! Try using a [SPAN_HELPFUL("welder")]."))
			return

		if(!HAS_TRAIT(O, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_NOTICE("You need a more powerful blowtorch!"))
			return

		WT = O
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [WT] needs to be on!"))
			return

	else
		if(!HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
			to_chat(user, SPAN_NOTICE("The frame is structurally sound, but there are a lot of loose nuts and bolts. Try using a [SPAN_HELPFUL("wrench")]."))
			return

		repair_message = "tightening various nuts and bolts on"
		sound_file = 'sound/items/Ratchet.ogg'

	var/amount_fixed_adjustment = user.get_skill_duration_multiplier(SKILL_ENGINEER)
	user.visible_message(SPAN_WARNING("[user] [repair_message] on \the [src]."), SPAN_NOTICE("You begin [repair_message] on \the [src]."))
	playsound(get_turf(user), sound_file, 25)

	while(health < max_hp)
		if(!(world.time % 3))
			playsound(get_turf(user), sound_file, 25)

		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
			user.visible_message(SPAN_WARNING("[user] stops [repair_message] on \the [src]."), SPAN_NOTICE("You stop [repair_message] on \the [src]. Hull integrity is at [SPAN_HELPFUL(100.0*health/max_hp)]%."))
			return

		health = min(health + max_hp/100 * (5 / amount_fixed_adjustment), max_hp)
		if(!lighting_holder.light)
			lighting_holder.set_light_on(TRUE)

		if(WT)
			WT.remove_fuel(1, user)
			if(WT.get_fuel() < 1)
				user.visible_message(SPAN_WARNING("[user] stops [repair_message] on \the [src]."), SPAN_NOTICE("You stop [repair_message] on \the [src]. Hull integrity is at [SPAN_HELPFUL(100.0*health/max_hp)]%."))
				return
			if(health >= max_hp * 0.75)
				user.visible_message(SPAN_WARNING("[user] finishes [repair_message] on \the [src]."), SPAN_NOTICE("You finish [repair_message] on \the [src]. The frame is structurally sound now, but there are a lot of loose nuts and bolts. Try using a [SPAN_HELPFUL("wrench")]."))
				return

		to_chat(user, SPAN_NOTICE("Hull integrity is at [SPAN_HELPFUL(100.0*health/max_hp)]%."))

	health = initial(health)
	lighting_holder.set_light_range(vehicle_light_range)
	toggle_cameras_status(TRUE)
	update_icon()
	user.visible_message(SPAN_NOTICE("[user] finishes [repair_message] on \the [src]."), SPAN_NOTICE("You finish [repair_message] on \the [src]. Hull integrity is at [SPAN_HELPFUL(100.0*health/max_hp)]%. "))
	return

//Special case for entering the vehicle without using the verb
/obj/vehicle/multitile/attack_hand(mob/user)
	var/mob_x = user.x - src.x
	var/mob_y = user.y - src.y
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			handle_player_entrance(user)
			return
	. = ..()

/obj/vehicle/multitile/attack_ghost(mob/dead/observer/user)
	if(!interior)
		return ..()

	var/turf/middle = interior.get_middle_turf()
	if(!middle)
		return ..()

	user.forceMove(middle)

/obj/vehicle/multitile/attack_alien(mob/living/carbon/xenomorph/X)
	// If they're on help intent, attempt to enter the vehicle
	if(X.a_intent == INTENT_HELP)
		handle_player_entrance(X)
		return XENO_NO_DELAY_ACTION

	// If the vehicle is completely broken, xenos can enter from anywhere
	if(health <= 0)
		handle_player_entrance(X)
		return XENO_NO_DELAY_ACTION

	if(X.mob_size < mob_size_required_to_hit)
		to_chat(X, SPAN_XENOWARNING("We're too small to do any significant damage to this vehicle!"))
		return XENO_NO_DELAY_ACTION

	var/damage = (X.melee_vehicle_damage + rand(-5,5)) * XENO_UNIVERSAL_VEHICLE_DAMAGEMULT

	var/damage_mult = 1
	//Ravs, as designated vehicles fighters do a heckin double damage
	//Queen, being Queen, does x2 damage to discourage blocking her
	if(X.caste == XENO_CASTE_RAVAGER || X.caste == XENO_CASTE_QUEEN)
		damage_mult = 2

	//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
	if(X.frenzy_aura > 0)
		damage += (X.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER)

	X.animation_attack_on(src)

	//Somehow we will deal no damage on this attack
	if(!damage)
		playsound(X.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
		X.visible_message(SPAN_DANGER("\The [X] swipes at \the [src] to no effect!"),
		SPAN_DANGER("We swipe at \the [src] to no effect!"))
		return XENO_ATTACK_ACTION

	X.visible_message(SPAN_DANGER("\The [X] slashes \the [src]!"),
	SPAN_DANGER("We slash \the [src]!"))
	playsound(X.loc, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	take_damage_type(damage * damage_mult, "slash", X)

	healthcheck()
	return XENO_ATTACK_ACTION

//Differentiates between damage types from different bullets
//Applies a linear transformation to bullet damage that will generally decrease damage done
/obj/vehicle/multitile/bullet_act(obj/projectile/P)
	var/dam_type = "bullet"
	var/damage = P.damage
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	var/penetration = P.ammo.penetration
	var/firer = P.firer

	//IFF bullets magically stop themselves short of hitting friendly vehicles,
	//because both sentries and smartgun users keep trying to shoot through them
	if(P.runtime_iff_group && get_target_lock(P.runtime_iff_group))
		return

	if(ammo_flags & (AMMO_ANTISTRUCT|AMMO_ANTIVEHICLE))
		// Multiplier based on tank railgun relationship, so might have to reconsider multiplier for AMMO_SIEGE in general
		damage = floor(damage*ANTISTRUCT_DMG_MULT_TANK)
	if(ammo_flags & AMMO_ACIDIC)
		dam_type = "acid"

	// trust me bro
	var/pixel_x_offset = 64 + ((P.x - x) * 32)
	if(pixel_x_offset > 0 && (dir == NORTH || dir == SOUTH))
		pixel_x_offset -= 32
	var/pixel_y_offset = 64 + ((P.y - y) * 32)
	if(pixel_y_offset > 0 && (dir == EAST || dir == WEST))
		pixel_y_offset -= 32
	bullet_ping(P, pixel_x_offset, pixel_y_offset)

	take_damage_type(damage * (0.33 + penetration/100), dam_type, firer)

	healthcheck()

//to handle IFF bullets
/obj/vehicle/multitile/proc/get_target_lock(access_to_check)
	if(isnull(access_to_check) || !vehicle_faction)
		return FALSE

	if(!islist(access_to_check))
		return access_to_check == vehicle_faction

	return vehicle_faction in access_to_check

/obj/vehicle/multitile/ex_act(severity)
	take_damage_type(severity * 0.5, "explosive")
	take_damage_type(severity * 0.1, "slash")

	healthcheck()

/obj/vehicle/multitile/on_set_interaction(mob/user)
	RegisterSignal(user, COMSIG_MOB_MOUSEDOWN, PROC_REF(crew_mousedown))
	RegisterSignal(user, COMSIG_MOB_MOUSEDRAG, PROC_REF(crew_mousedrag))
	RegisterSignal(user, COMSIG_MOB_MOUSEUP, PROC_REF(crew_mouseup))

/obj/vehicle/multitile/on_unset_interaction(mob/user)
	UnregisterSignal(user, list(COMSIG_MOB_MOUSEUP, COMSIG_MOB_MOUSEDOWN, COMSIG_MOB_MOUSEDRAG))

	var/obj/item/hardpoint/hardpoint = get_mob_hp(user)
	if(hardpoint)
		SEND_SIGNAL(hardpoint, COMSIG_GUN_INTERRUPT_FIRE) //abort fire when crew leaves

/// Relays crew mouse release to active hardpoint.
/obj/vehicle/multitile/proc/crew_mouseup(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER
	var/obj/item/hardpoint/hardpoint = get_mob_hp(source)
	if(!hardpoint)
		return

	hardpoint.stop_fire(source, object, location, control, params)

/// Relays crew mouse movement to active hardpoint.
/obj/vehicle/multitile/proc/crew_mousedrag(datum/source, atom/src_object, atom/over_object, turf/src_location, turf/over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	var/obj/item/hardpoint/hardpoint = get_mob_hp(source)
	if(!hardpoint)
		return

	hardpoint.change_target(source, src_object, over_object, src_location, over_location, src_control, over_control, params)

/// Checks for special control keybinds, else relays crew mouse press to active hardpoint.
/obj/vehicle/multitile/proc/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK]) //don't step on examine, point, etc
		return

	var/seat = get_mob_seat(source)
	switch(seat)
		if(VEHICLE_DRIVER)
			if(modifiers[LEFT_CLICK] && modifiers[CTRL_CLICK])
				activate_horn()
				return
		if(VEHICLE_GUNNER)
			if(modifiers[LEFT_CLICK] && modifiers[ALT_CLICK])
				toggle_gyrostabilizer()
				return

	var/obj/item/hardpoint/hardpoint = get_mob_hp(source)
	if(!hardpoint)
		to_chat(source, SPAN_WARNING("Please select an active hardpoint first."))
		return

	hardpoint.start_fire(source, object, location, control, params)

/obj/vehicle/multitile/proc/handle_player_entrance(mob/M)
	if(!M || M.client == null)
		return

	var/mob_x = M.x - src.x
	var/mob_y = M.y - src.y
	var/entrance_used = null
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			entrance_used = entrance
			break

	var/enter_time = 0
	// door locks break when hull is destroyed. Xenos enter slower, but their speed is not affected by anything and they ignore locks
	if(isxeno(M))
		enter_time = 3 SECONDS
	else
		if(door_locked && health > 0) //check if lock on and actually works
			if(ishuman(M))
				var/mob/living/carbon/human/user = M
				if(!allowed(user) || !get_target_lock(user.faction_group)) //if we are human, we check access and faction
					to_chat(user, SPAN_WARNING("\The [src] is locked!"))
					return
			else
				to_chat(M, SPAN_WARNING("\The [src] is locked!")) //animals are not allowed inside without supervision
				return


	// Only xenos can force their way in without doors, and only when the frame is completely broken
	if(!entrance_used && health > 0)
		return
	else if(!entrance_used && !isxeno(M))
		return

	var/enter_msg = "We start climbing into \the [src]..."
	if(health <= 0 && isxeno(M))
		enter_msg = "We start prying away loose plates, squeezing into \the [src]..."

	// Check if drag anything
	var/atom/dragged_atom
	if(istype(M.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_inactive_hand()
		dragged_atom = G.grabbed_thing
	else if(istype(M.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = M.get_active_hand()
		dragged_atom = G.grabbed_thing

	if(!enter_time)
		enter_time = entrance_speed
		if(dragged_atom)
			enter_time = 2 SECONDS

	to_chat(M, SPAN_NOTICE(enter_msg))
	if(!do_after(M, enter_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return

	if(entrance_used)
		var/entrance_coord = entrances[entrance_used]
		mob_x = M.x - src.x
		mob_y = M.y - src.y
		if(mob_x != entrance_coord[1] || mob_y != entrance_coord[2])
			to_chat(M, SPAN_WARNING("\The [src] moved!"))
			return

	//Dragged stuff comes with us only if properly waited 2 seconds. No cheating!
	if(dragged_atom)
		dragged_atom = null
		if(istype(M.get_inactive_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_inactive_hand()
			dragged_atom = G.grabbed_thing
		else if(istype(M.get_active_hand(), /obj/item/grab))
			var/obj/item/grab/G = M.get_active_hand()
			dragged_atom = G.grabbed_thing

	// Transfer them to the interior
	interior.enter(M, entrance_used)

	// We try to make the dragged thing enter last so that the mob who actually entered takes precedence
	if(dragged_atom)
		var/success = interior.enter(dragged_atom, entrance_used)
		if(!success)
			to_chat(M, SPAN_WARNING("You fail to fit [dragged_atom] inside \the [src] and leave [ismob(dragged_atom) ? "them" : "it"] outside."))

//try to fit something into the vehicle
/obj/vehicle/multitile/proc/handle_fitting_pulled_atom(mob/living/carbon/human/user, atom/dragged_atom)
	if(!ishuman(user))
		return
	if(door_locked && health > 0 && (!allowed(user) || !get_target_lock(user.faction_group)))
		to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return

	var/mob_x = user.x - x
	var/mob_y = user.y - y
	var/entrance_used = null
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			entrance_used = entrance
			break

	to_chat(user, SPAN_NOTICE("You start trying to fit [dragged_atom] into \the [src]..."))
	if(!do_after(user, 1 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return
	if(mob_x != user.x - x || mob_y != user.y - y)
		return

	var/atom/currently_dragged

	if(istype(user.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = user.get_inactive_hand()
		currently_dragged = G.grabbed_thing
	else if(istype(user.get_active_hand(), /obj/item/grab))
		var/obj/item/grab/G = user.get_active_hand()
		currently_dragged = G.grabbed_thing

	if(currently_dragged != dragged_atom)
		to_chat(user, SPAN_WARNING("You stop fiting [dragged_atom] inside \the [src]!"))
		return

	var/success = interior.enter(dragged_atom, entrance_used)
	if(success)
		to_chat(user, SPAN_NOTICE("You successfully fit [dragged_atom] inside \the [src]."))
	else
		to_chat(user, SPAN_WARNING("You fail to fit [dragged_atom] inside \the [src]! It's either too big or vehicle is out of space!"))
	return

//CLAMP procs, unsafe proc, checks are done before calling it
/obj/vehicle/multitile/proc/attach_clamp(obj/item/vehicle_clamp/O, mob/user)
	user.temp_drop_inv_item(O, 0)
	clamped = TRUE
	move_delay = VEHICLE_SPEED_STATIC
	next_move = world.time + move_delay
	qdel(O)
	update_icon()
	message_admins("[key_name(user)] ([user.job]) attached vehicle clamp to [src]")

/obj/vehicle/multitile/proc/detach_clamp(mob/user)
	clamped = FALSE
	move_delay = initial(move_delay)

	var/obj/item/hardpoint/locomotion/Loco
	for(Loco in hardpoints)
		Loco.on_install(src) //we restore speed respective to wheels/treads if any installed

	next_move = world.time + move_delay
	var/obj/item/vehicle_clamp/O = new(get_turf(src))
	if(user)
		O.forceMove(get_turf(user))
		message_admins("[key_name(user)] ([user.job]) detached vehicle clamp from \the [src]")
	else
		O.forceMove(get_turf(src))
		message_admins("Vehicle clamp was detached from \the [src].")
	update_icon()
