
// Special cases abound, handled below or in subclasses
/obj/vehicle/multitile/attackby(var/obj/item/O, var/mob/user)
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
	if(iscrowbar(O) || ispowerclamp(O))
		uninstall_hardpoint(O, user)
		return

	// Are we trying to repair the frame?
	if(iswelder(O) || iswrench(O))
		handle_repairs(O, user)
		return

	// Are we trying to immobilize the vehicle?
	if(istype(O, /obj/item/vehicle_clamp))
		if(clamped)
			to_chat(user, SPAN_WARNING("[src] already has a [O.name] attached."))
			return

		for(var/obj/item/hardpoint/locomotion/Loco in hardpoints)
			if(skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
				user.visible_message(SPAN_WARNING("[user] starts attaching the vehicle clamp to [src]."), SPAN_NOTICE("You start attaching the vehicle clamp to [src]."))
				if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_BUILD))
					user.visible_message(SPAN_WARNING("[user] stops attaching the vehicle clamp to [src]."), SPAN_WARNING("You stop attaching the vehicle clamp to [src]."))
					return
				user.visible_message(SPAN_WARNING("[user] attaches the vehicle clamp to [src]."), SPAN_NOTICE("You attach the vehicle clamp to [src] and lock the mechanism with your ID."))
				attach_clamp(O, user)
			else
				to_chat(user, SPAN_WARNING("You don't know how to use [O] with [src]."))
			return
		to_chat(user, SPAN_WARNING("There are no treads to attach [O.name] to."))
		return

	// Are we trying to remove a vehicle clamp?
	if(isscrewdriver(O))
		if(!clamped)
			return

		user.visible_message(SPAN_WARNING("[user] starts removing the vehicle clamp from [src]."), SPAN_NOTICE("You start removing the vehicle clamp from [src]."))
		if(skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
			if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user] stops removing the vehicle clamp from [src]."), SPAN_WARNING("You stop removing the vehicle clamp from [src]."))
				return
			user.visible_message(SPAN_WARNING("[user] skillfully removes the vehicle clamp from [src]."), SPAN_NOTICE("You unlock the mechanism with your ID and skillfully remove the vehicle clamp from [src]."))
		else
			if(!do_after(user, SECONDS_30, INTERRUPT_ALL, BUSY_ICON_BUILD))
				user.visible_message(SPAN_WARNING("[user] stops removing the vehicle clamp from [src]."), SPAN_WARNING("You stop removing the vehicle clamp from [src]."))
				return
			user.visible_message(SPAN_WARNING("[user] clumsily removes the vehicle clamp from [src]."), SPAN_NOTICE("You manage to unlock vehicle clamp and take it off [src]."))
		detach_clamp(user)
		return

	if(user.a_intent != INTENT_HARM)
		handle_player_entrance(user)
		return

	take_damage_type(O.force * 0.05, "blunt", user) //Melee weapons from people do very little damage
	. = ..()

// Frame repairs on the vehicle itself
/obj/vehicle/multitile/proc/handle_repairs(var/obj/item/O, var/mob/user)
	var/max_hp = initial(health)
	if(health == max_hp)
		to_chat(user, SPAN_NOTICE("The frame is fully intact!"))
		return

	// For health < 75%, the frame needs welderwork
	if(health < max_hp * 0.75)
		if(!iswelder(O))
			to_chat(user, SPAN_NOTICE("The frame is way too busted! Try using a welder."))
			return

		var/obj/item/tool/weldingtool/WT = O
		if(!WT.isOn())
			return

		user.visible_message(SPAN_WARNING("[user] begins welding structural struts back in place on \the [src]."), SPAN_NOTICE("You begin welding structural struts back in place on \the [src]."))
		playsound(get_turf(user), 'sound/items/weldingtool_weld.ogg', 25)

		if(!do_after(user, 50 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_BUILD))
			user.visible_message(SPAN_WARNING("[user] stops welding on \the [src]."), SPAN_NOTICE("You stop welding on \the [src]."))
			return

		if(!WT.isOn())
			return

		user.visible_message(SPAN_WARNING("[user] welds structural struts back in place on \the [src]."), SPAN_NOTICE("You weld structural struts back in place on \the [src]."))

		health = min(max_hp * 0.75, health + max_hp * 0.25)
	// For health >= 75% tighten some fuckin' bolts or some shit i don't know i'm not a mechanic
	else
		if(!iswrench(O))
			to_chat(user, SPAN_NOTICE("The frame is structurally sound, but there are a lot of loose nuts and bolts. Try using a wrench."))
			return

		user.visible_message(SPAN_WARNING("[user] begins tightening various nuts and bolts on \the [src]."), SPAN_NOTICE("You begin tightening various nuts and bolts on \the [src]."))

		if(!do_after(user, 60 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|INTERRUPT_CLICK, BUSY_ICON_BUILD))
			user.visible_message(SPAN_WARNING("[user] stops tightening nuts and bolts on \the [src]."), SPAN_NOTICE("You stop tightening nuts and bolts on \the [src]."))
			return

		user.visible_message(SPAN_WARNING("[user] finishes tightening nuts and bolts on \the [src]."), SPAN_NOTICE("You finish tightening nuts and bolts on \the [src]."))

		health = max_hp
		toggle_cameras_status(TRUE)

	update_icon()

//Special case for entering the vehicle without using the verb
/obj/vehicle/multitile/attack_hand(var/mob/user)
	var/mob_x = user.x - src.x
	var/mob_y = user.y - src.y
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			handle_player_entrance(user, entrance)
			return
	. = ..()

/obj/vehicle/multitile/attack_ghost(mob/dead/observer/user)
	if(!interior)
		return ..()

	var/turf/middle = interior.get_middle_turf()
	if(!middle)
		return ..()

	user.forceMove(middle)

/obj/vehicle/multitile/attack_alien(var/mob/living/carbon/Xenomorph/M, var/dam_bonus)
	// If they're on help intent, attempt to enter the vehicle
	if(M.a_intent == INTENT_HELP)
		handle_player_entrance(M)
		return

	// If the vehicle is completely broken, xenos can enter from anywhere
	if(health <= 0)
		handle_player_entrance(M)

	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper) + dam_bonus

	//Frenzy auras stack in a way, then the raw value is multipled by two to get the additive modifier
	if(M.frenzy_aura > 0)
		damage += (M.frenzy_aura * 2)

	M.animation_attack_on(src)

	//Somehow we will deal no damage on this attack
	if(!damage)
		playsound(M.loc, 'sound/weapons/alien_claw_swipe.ogg', 25, 1)
		M.animation_attack_on(src)
		M.visible_message(SPAN_DANGER("\The [M] lunges at [src]!"), \
		SPAN_DANGER("You lunge at [src]!"))
		return 0

	M.visible_message(SPAN_DANGER("\The [M] slashes [src]!"), \
	SPAN_DANGER("You slash [src]!"))
	playsound(M.loc, pick('sound/effects/metalhit.ogg', 'sound/weapons/alien_claw_metal1.ogg', 'sound/weapons/alien_claw_metal2.ogg', 'sound/weapons/alien_claw_metal3.ogg'), 25, 1)

	take_damage_type(damage * ( (M.caste == "Ravager") ? 2 : 1 ), "slash", M) //Ravs do a bitchin double damage

	healthcheck()

//Differentiates between damage types from different bullets
//Applies a linear transformation to bullet damage that will generally decrease damage done
/obj/vehicle/multitile/bullet_act(var/obj/item/projectile/P)
	var/dam_type = "bullet"
	var/damage = P.damage
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	var/penetration = P.ammo.penetration
	var/firer = P.firer

	if(ammo_flags & AMMO_ANTISTRUCT)
		// Multiplier based on tank railgun relationship, so might have to reconsider multiplier for AMMO_SIEGE in general
		damage = round(damage*ANTISTRUCT_DMG_MULT_TANK)
	if(ammo_flags & AMMO_XENO_ACID)
		dam_type = "acid"

	take_damage_type(damage * (0.33 + penetration/100), dam_type, firer)

	healthcheck()

/obj/vehicle/multitile/ex_act(var/severity)
	take_damage_type(severity * 0.5, "explosive")
	take_damage_type(severity * 0.1, "slash")

	healthcheck()

/obj/vehicle/multitile/handle_click(var/mob/living/user, var/atom/A, var/list/mods)

	var/seat
	for(var/vehicle_seat in seats)
		if(seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(istype(A, /obj/screen) || !seat)
		return

	if(seat == VEHICLE_DRIVER)
		if(mods["shift"] && !mods["alt"])
			A.examine(user)
			return

		if(mods["ctrl"] && !mods["alt"])
			activate_horn()
			return

	if(seat == VEHICLE_GUNNER)
		if(mods["shift"] && !mods["middle"])
			if(vehicle_flags & TOGGLE_SHIFT_CLICK_GUNNER)
				shoot_other_weapon(user, seat, A)
			else
				A.examine(user)
			return
		if(mods["middle"] && !mods["shift"])
			if(!(vehicle_flags & TOGGLE_SHIFT_CLICK_GUNNER))
				shoot_other_weapon(user, seat, A)
			return
		if(mods["alt"])
			toggle_gyrostabilizer()
			return
		if(mods["ctrl"])
			activate_support_module(user, seat, A)
			return

		var/obj/item/hardpoint/HP = active_hp[seat]
		if(!HP)
			to_chat(user, SPAN_WARNING("Please select an active hardpoint first."))
			return

		if(!HP.can_activate(user, A))
			return

		HP.activate(user, A)

/obj/vehicle/multitile/proc/handle_player_entrance(var/mob/M)
	if(!M || M.client == null) return

	// xenos bypass door locks
	if(door_locked && !allowed(M) && !isXeno(M))
		to_chat(M, SPAN_DANGER("\The [src] is locked!"))
		return

	var/mob_x = M.x - src.x
	var/mob_y = M.y - src.y
	var/entrance_used = null
	for(var/entrance in entrances)
		var/entrance_coord = entrances[entrance]
		if(mob_x == entrance_coord[1] && mob_y == entrance_coord[2])
			entrance_used = entrance
			break

	// Only xenos can force their way in without doors, and only when the frame is completely broken
	if(!entrance_used && health > 0)
		return
	else if(!entrance_used && !isXeno(M))
		return

	var/enter_msg = "You start climbing into \the [src]..."
	if(health <= 0 && isXeno(M))
		enter_msg = "You start prying away loose plates, squeezing into \the [src]..."

	to_chat(M, SPAN_NOTICE(enter_msg))
	if(!do_after(M, SECONDS_2, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return

	if(mob_x != M.x - src.x || mob_y != M.y - src.y)
		return

	// Dragged stuff comes with
	var/atom/dragged_atom
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
			to_chat(M, SPAN_NOTICE("You fail to fit [dragged_atom] inside \the [src] and leave [ismob(dragged_atom) ? "them" : "it"] outside."))

//CLAMP procs, unsafe proc, checks are done before calling it
/obj/vehicle/multitile/proc/attach_clamp(obj/item/vehicle_clamp/O, mob/user)
	user.temp_drop_inv_item(O, 0)
	O.loc = src
	clamped = TRUE
	move_delay = 50000
	next_move = world.time + move_delay
	update_icon()
	message_admins("[key_name(user)] ([user.job]) attached vehicle clamp to [src]")

/obj/vehicle/multitile/proc/detach_clamp(mob/user)
	clamped = FALSE
	move_delay = initial(move_delay)

	var/obj/item/hardpoint/locomotion/Loco
	for(Loco in hardpoints)
		Loco.on_install(src)	//we restore speed respective to wheels/treads if any installed

	next_move = world.time + move_delay
	for(var/obj/item/vehicle_clamp/TC in src)
		if(user)
			TC.Move(get_turf(user))
			message_admins("[key_name(user)] ([user.job]) detached vehicle clamp from [src]")
		else
			TC.Move(get_turf(src))
	update_icon()