#define GUN_RIGHT 0
#define GUN_LEFT 1

/////////////////
// Walker
/////////////////

/obj/vehicle/walker
	name = "CW13 \"Enforcer\" Assault Walker"
	desc = "Relatively new combat walker of \"Enforcer\"-series. Unlike its predecessor, \"Carharodon\"-series, slower, but relays on its tough armor and rapid-firing weapons."
	icon = 'fray-marines/icons/obj/vehicles/mech.dmi'
	icon_state = "mech_open"
	layer = BIG_XENO_LAYER
	opacity = FALSE
	can_buckle = FALSE
	move_delay = 6
	req_access = list(ACCESS_MARINE_WALKER)
	unacidable = TRUE

	var/lights = FALSE
	var/lights_power = 8
	var/zoom = FALSE
	var/zoom_size = 14

	pixel_x = -18

	health = 1000
	var/max_health = 1000
	var/repair = FALSE

	var/acid_process_cooldown = null
	var/list/dmg_multipliers = list(
		"all" = 1.0, //for when you want to make it invincible
		"acid" = 1.2,
		"slash" = 0.85,
		"bullet" = 0.2,
		"explosive" = 5.0,
		"blunt" = 0.1,
		"energy" = 1.0,
		"abstract" = 1.0
	) //abstract for when you just want to hurt it

	var/max_angle = 45
	var/obj/item/walker_gun/left = null
	var/obj/item/walker_gun/right = null
	var/obj/item/walker_armor/armor_module = null
	var/selected = GUN_LEFT

	var/list/verb_list = list(
		/obj/vehicle/walker/verb/get_out,
		/obj/vehicle/walker/verb/toggle_lights,
		/obj/vehicle/walker/verb/toggle_zoom,
		/obj/vehicle/walker/verb/eject_magazines,
		/obj/vehicle/walker/verb/select_weapon
//				/obj/vehicle/walker/verb/get_stats
	)

	var/list/step_sounds = list(
		'fray-marines/sound/vehicle/walker/mecha_step1.ogg',
		'fray-marines/sound/vehicle/walker/mecha_step2.ogg',
		'fray-marines/sound/vehicle/walker/mecha_step3.ogg',
		'fray-marines/sound/vehicle/walker/mecha_step4.ogg',
		'fray-marines/sound/vehicle/walker/mecha_step5.ogg'
	)
	var/list/turn_sounds = list(
		'fray-marines/sound/vehicle/walker/mecha_turn1.ogg',
		'fray-marines/sound/vehicle/walker/mecha_turn2.ogg',
		'fray-marines/sound/vehicle/walker/mecha_turn3.ogg',
		'fray-marines/sound/vehicle/walker/mecha_turn4.ogg'
	)
	flags_atom = FPRINT|USES_HEARING

	//used for IFF stuff. Determined by driver. It will remember faction of a last driver. IFF-compatible rounds won't damage vehicle.
	var/vehicle_faction = ""

/obj/vehicle/walker/Initialize()
	. = ..()

/obj/vehicle/walker/prebuilt/Initialize()
	. = ..()

	left = new /obj/item/walker_gun/smartgun()
	right = new /obj/item/walker_gun/flamer()
	left.ammo = new left.magazine_type()
	right.ammo = new right.magazine_type()
	left.owner = src
	right.owner = src

	update_icon()

/obj/vehicle/walker/update_icon()
	overlays.Cut()

	if(seats[VEHICLE_DRIVER] != null)
		icon_state = "mech_prep"
	else
		icon_state = "mech_open"

	if(left)
		var/image/left_gun = left.get_icon_image("_l_hand")
		overlays += left_gun
	if(right)
		var/image/right_gun = right.get_icon_image("_r_hand")
		overlays += right_gun

/obj/vehicle/walker/get_examine_text(mob/user)
	. = ..()
	switch(round(100 * health / max_health))
		if(85 to 100)
			. += "It's fully intact."
		if(65 to 85)
			. += "It's slightly damaged."
		if(45 to 65)
			. += "It's badly damaged."
		if(25 to 45)
			. += "It's heavily damaged."
		else
			. += "It's falling apart."
	. += "[left ? left.name : "Nothing"] is placed on its left hardpoint."
	. += "[right ? right.name : "Nothing"] is placed on its right hardpoint."

/obj/vehicle/walker/ex_act(severity)
	take_damage_type(severity * 0.5, "explosive")
	take_damage_type(severity * 0.1, "slash")

	healthcheck()

/obj/vehicle/walker/MouseDrop_T(mob/target, mob/living/user)
	. = ..()
	if(!istype(user) || target != user) //No making other people climb into walker.
		return

	if(user.skills.get_skill_level(SKILL_POWERLOADER))
		move_in(user)
	else
		to_chat(user, "How to operate it?")

/obj/vehicle/walker/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated()) return
	if(seats[VEHICLE_DRIVER] != user) return
	seats[VEHICLE_DRIVER].set_interaction(src)

	if(world.time > l_move_time + move_delay)
		if (zoom)
			unzoom()
		if(dir != direction && GLOB.reverse_dir[dir] != direction)
			l_move_time = world.time
			dir = direction
			playsound(src.loc, pick(turn_sounds), 70, 1)
			. = TRUE
		else
			var/oldDir = dir
			. = step(src, direction)
			setDir(oldDir)
			if(.)
				playsound(src.loc, pick(step_sounds), 60, 1)

/obj/vehicle/walker/Bump(atom/obstacle)
	if(isxeno(obstacle))
		var/mob/living/carbon/xenomorph/xeno = obstacle

		if (xeno.mob_size >= MOB_SIZE_IMMOBILE)
			xeno.visible_message(SPAN_DANGER("\The [xeno] digs it's claws into the ground, anchoring itself in place and halting \the [src] in it's tracks!"),
				SPAN_DANGER("You dig your claws into the ground, stopping \the [src] in it's tracks!")
			)
			return

		switch(xeno.tier)
			if(1)
				xeno.visible_message(
					SPAN_DANGER("\The [src] smashes at [xeno], bringing him down!"),
					SPAN_DANGER("You got smashed by walking metal box!")
				)
				xeno.AdjustKnockDown(0.5 SECONDS)
				xeno.apply_damage(round((max_health / 100) * VEHICLE_TRAMPLE_DAMAGE_MIN), BRUTE)
				xeno.last_damage_data = create_cause_data("[initial(name)] roadkill", seats[VEHICLE_DRIVER])
				var/mob/living/driver = seats[VEHICLE_DRIVER]
				log_attack("[key_name(xeno)] was rammed by [key_name(driver)] with [src].")
			if(2)
				xeno.visible_message(
					SPAN_DANGER("\The [src] smashes at [xeno], shoving it away!"),
					SPAN_DANGER("You got smashed by walking metal box!")
				)
				var/direction_taken = pick(45, 0, -45)
				var/mob_moved = step(xeno, turn(last_move_dir, direction_taken))

				if(!mob_moved)
					mob_moved = step(xeno, turn(last_move_dir, -direction_taken))
			if(3)
				xeno.visible_message(SPAN_DANGER("\The [xeno] digs it's claws into the ground, anchoring itself in place and halting \the [src] in it's tracks!"),
					SPAN_DANGER("You dig your claws into the ground, stopping \the [src] in it's tracks!")
				)
		return
	if(istype(obstacle, /obj/structure/machinery/door))
		var/obj/structure/machinery/door/door = obstacle
		if(door.allowed(seats[VEHICLE_DRIVER]))
			door.open()
		else
			flick("door_deny", door)

	else if(ishuman(obstacle))
		step_away(obstacle, src, 0)
		return

	else if(istype(obstacle, /obj/structure/barricade))
		playsound(src.loc, pick(step_sounds), 60, 1)
		var/obj/structure/barricade/cade = obstacle
		var/new_dir = get_dir(src, cade) ? get_dir(src, cade) : cade.dir
		var/turf/new_loc = get_step(loc, new_dir)
		if(!new_loc.density) forceMove(new_loc)
		return

//Breaking stuff
	else if(istype(obstacle, /obj/structure/fence))
		var/obj/structure/fence/F = obstacle
		F.visible_message(SPAN_DANGER("[src.name] smashes through [F]!"))
		take_damage_type(5, "blunt", obstacle)
		F.health = 0
		F.healthcheck()
	else if(istype(obstacle, /obj/structure/surface/table))
		var/obj/structure/surface/table/T = obstacle
		T.visible_message(SPAN_DANGER("[src.name] crushes [T]!"))
		take_damage_type(5, "blunt", obstacle)
		T.deconstruct(TRUE)
	else if(istype(obstacle, /obj/structure/showcase))
		var/obj/structure/showcase/S = obstacle
		S.visible_message(SPAN_DANGER("[src.name] bulldozes over [S]!"))
		take_damage_type(15, "blunt", obstacle)
		S.deconstruct(TRUE)
	else if(istype(obstacle, /obj/structure/window/framed))
		var/obj/structure/window/framed/W = obstacle
		W.visible_message(SPAN_DANGER("[src.name] crashes through the [W]!"))
		take_damage_type(20, "blunt", obstacle)
		W.shatter_window(1)
	else if(istype(obstacle, /obj/structure/window_frame))
		var/obj/structure/window_frame/WF = obstacle
		WF.visible_message(SPAN_DANGER("[src.name] runs over the [WF]!"))
		take_damage_type(20, "blunt", obstacle)
		WF.deconstruct()
	else
		..()

/obj/vehicle/walker/proc/move_in(mob/living/carbon/user)
	set waitfor = FALSE
	if(!ishuman(user))
		return
	if(seats[VEHICLE_DRIVER])
		to_chat(user, "There is someone occupying mecha right now.")
		return
	var/mob/living/carbon/human/H = user

	if (!do_after(H, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src, INTERRUPT_MOVED))
		return
	for(var/ID in list(H.wear_id, H.belt))
		if(operation_allowed(ID))
			seats[VEHICLE_DRIVER] = H
			add_verb(H, verb_list)
			user.loc = src
			vehicle_faction = user.faction
			seats[VEHICLE_DRIVER].client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
			seats[VEHICLE_DRIVER].set_interaction(src)
			RegisterSignal(H, COMSIG_MOB_RESISTED, PROC_REF(move_out))
			to_chat(seats[VEHICLE_DRIVER], SPAN_HELPFUL("Нажмите среднюю кнопку мыши чтобы менять оружие."))
			to_chat(seats[VEHICLE_DRIVER], SPAN_HELPFUL("Нажмите Shift+MMB для сброса боеприпасов с основного орудия."))

			if(selected)
				if(left && left.automatic)
					left.register_signals(user)
			else
				if (right && right.automatic)
					right.register_signals(user)

			playsound_client(seats[VEHICLE_DRIVER].client, 'fray-marines/sound/vehicle/walker/mecha_start.ogg', 60)
			update_icon()
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), seats[VEHICLE_DRIVER].client, 'fray-marines/sound/vehicle/walker/mecha_online.ogg', 60), 2 SECONDS)
			return

	to_chat(user, "Access denied.")

/obj/vehicle/walker/proc/operation_allowed(obj/item/I)
	if(check_access(I))
		return TRUE
	return FALSE

// /obj/vehicle/walker/proc/eject()
// 	set name = "Eject"
// 	set category = "Vehicle"
// 	var/mob/M = usr

// 	if(!M || !istype(M))
// 		return

// 	var/obj/vehicle/walker/W = M.interactee

// 	if(!W || !istype(W))
// 		return
// 	W.move_out()

/obj/vehicle/walker/proc/move_out()
	var/mob/living/driver = seats[VEHICLE_DRIVER]
	if(!driver)
		return FALSE
	if(health <= 0)
		to_chat(driver, "<span class='danger'>PRIORITY ALERT! Chassis integrity failing. Systems shutting down.</span>")
	if(zoom)
		unzoom()
	if(driver.client)
		driver.client.mouse_pointer_icon = initial(driver.client.mouse_pointer_icon)

	if(!do_after(driver, 1 SECONDS, INTERRUPT_ALL, null, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		return

	driver.unset_interaction()
	driver.loc = src.loc
	driver.reset_view(null)
	remove_verb(driver, verb_list)
	UnregisterSignal(driver, COMSIG_MOB_RESISTED)

	if(selected && left && left.automatic)
		left.unregister_signals(driver)
	else if(right && right.automatic)
		right.unregister_signals(driver)

	seats[VEHICLE_DRIVER] = null
	update_icon()
	return TRUE

/obj/vehicle/walker/proc/lights()
	var/mob/living/driver = seats[VEHICLE_DRIVER]

	if(!driver || !istype(driver))
		return

	if(!lights)
		lights = TRUE
		set_light(lights_power)
	else
		lights = FALSE
		set_light(-lights_power)

	playsound_client(driver, 'sound/machines/click.ogg', 50)

/obj/vehicle/walker/proc/deploy_magazine()
	var/mob/living/driver = seats[VEHICLE_DRIVER]
	var/obj/item/walker_gun/selected_gun
	if(selected)
		selected_gun = left
	else
		selected_gun = right

	if(selected_gun && selected_gun.ammo)
		selected_gun.ammo.forceMove(get_turf(src))
		selected_gun.ammo = null
		to_chat(driver, "<span class='warning'>WARNING! [selected_gun.name] ammo magazine deployed.</span>")
		visible_message("[name]'s systems deployed used magazine.","")

/obj/vehicle/walker/ui_status(mob/user)
	. = ..()
	if(get_dist(get_turf(user), get_turf(src)) > 0)
		return UI_CLOSE

/obj/vehicle/walker/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Walker")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/vehicle/walker/ui_data(mob/user)
	. = list()

	//simply solution
	.["text"] = "<h2>[name] Interface</h2>"
	.["text"] += "<span class='notice'>Vehicle Status:</span><br>"
	var/danger = "'notice'"
	var/curr_health = round(health/max_health*100)
	danger = "'notice'"
	if(curr_health <= 50)
		danger = "'warning'"
	if(curr_health <= 25)
		danger = "'danger'"
	.["text"] += "<span class='notice'>Overall vehicle integrity: </span><span class=[danger]> [curr_health] percent. [danger == "'danger'" ? "LEVEL CRITICAL!" : ""]</span>"
	.["text"] += "<span class='notice'>=========</span>"
	if(left)
		var/munition = left.ammo ? "[left.ammo.current_rounds]/[left.ammo.max_rounds]" : "<span class='warning'>DEPLETED</span>"
		.["text"] += "<span class='notice'>Left hardpoint: [left.name].\n Current ammo level: [munition]</span>"
	else
		.["text"] += "<span class='warning'>LEFT HARDPOINT IS EMPTY!</span>"

	if(right)
		var/munition = right.ammo ? "[right.ammo.current_rounds]/[right.ammo.max_rounds]" : "<span class='warning'>DEPLETED</span>"
		.["text"] += "<span class='notice'>Right hardpoint: [right.name].\n Current ammo level: [munition]</span>"
	else
		.["text"] += "<span class='warning'>RIGHT HARDPOINT IS EMPTY!</span>"

/obj/vehicle/walker/proc/cycle_weapons(mob/M)
	if(!M)
		M = seats[VEHICLE_DRIVER]

		if(!M)
			return

	var/obj/vehicle/walker/W = src

	if(!W || !istype(W))
		return

	if(W.selected)
		if(!W.right)
			return
		W.selected = !W.selected
		W.right.register_signals(M)
		W.left.unregister_signals(M)
	else
		if(!W.left)
			return
		W.selected = !W.selected
		W.left.register_signals(M)
		W.right.unregister_signals(M)
	to_chat(M, "Selected [W.selected ? "[W.left]" : "[W.right]"]")

/obj/vehicle/walker/proc/handle_click_mods(list/mods)
	if (mods["middle"] && mods["shift"])
		deploy_magazine()
		return TRUE
	if (mods["middle"])
		cycle_weapons()
		return TRUE

	return !mods["left"]

/obj/vehicle/walker/handle_click(mob/living/user, atom/A, list/mods)
	var/special_click = handle_click_mods(mods)

	if (special_click)
		return

	if(istype(A, /atom/movable/screen) || A.z != src.z)
		return
	if(!firing_arc(A))
		if (left)
			SEND_SIGNAL(left, COMSIG_GUN_STOP_FIRE)
		if (right)
			SEND_SIGNAL(right, COMSIG_GUN_STOP_FIRE)
		var/newDir = get_cardinal_dir(src, A)
		l_move_time = world.time
		if(dir != newDir)
			playsound(src.loc, pick(turn_sounds), 70, 1)
		dir = newDir
		return
	if(selected)
		if(!left)
			to_chat(usr, "<span class='warning'>WARNING! Hardpoint is empty.</span>")
			return
		if (left.automatic)
			return
		left.active_effect(A, user)
	else
		if(!right)
			to_chat(usr, "<span class='warning'>WARNING! Hardpoint is empty.</span>")
			return
		if (right.automatic)
			return
		right.active_effect(A, user)

/obj/vehicle/walker/proc/firing_arc(atom/A)
	if (!A)
		return FALSE

	var/turf/T = get_turf(A)

	if(!T)
		return FALSE

	var/dx = T.x - x
	var/dy = T.y - y
	var/deg = 0
	switch(src.dir)
		if(EAST) deg = 0
		if(NORTH) deg = -90
		if(WEST) deg = -180
		if(SOUTH) deg = -270

	var/nx = dx * cos(deg) - dy * sin(deg)
	var/ny = dx * sin(deg) + dy * cos(deg)
	if(nx == 0)
		return max_angle >= 180
	var/angle = arctan(ny/nx)
	if(nx < 0)
		angle += 180
	return abs(angle) <= max_angle

/obj/vehicle/walker/proc/zoom_activate()
	if (zoom)
		unzoom()
	else
		do_zoom()

/obj/vehicle/walker/proc/do_zoom(viewsize = 12)
	var/mob/living/carbon/user = seats[VEHICLE_DRIVER]
	if(user.client)
		zoom = TRUE
		user.client.change_view(viewsize, src)

		// zoom_initial_mob_dir = user.dir

		var/tilesize = 32
		var/viewoffset = tilesize * zoom_size

		switch(dir)
			if(NORTH)
				user.client.pixel_x = 0
				user.client.pixel_y = viewoffset
			if(SOUTH)
				user.client.pixel_x = 0
				user.client.pixel_y = -viewoffset
			if(EAST)
				user.client.pixel_x = viewoffset
				user.client.pixel_y = 0
			if(WEST)
				user.client.pixel_x = -viewoffset
				user.client.pixel_y = 0

	to_chat(seats[VEHICLE_DRIVER], "Notification. Cameras zooming [zoom ? "activated" : "deactivated"].")

/obj/vehicle/walker/proc/unzoom()
	var/mob/living/carbon/user = seats[VEHICLE_DRIVER]

	zoom = !zoom
	//General reset in case anything goes wrong, the view will always reset to default unless zooming in.
	if(user.client)
		user.client.change_view(GLOB.world_view_size, src)
		user.client.pixel_x = 0
		user.client.pixel_y = 0


/////////////////
// Attackby
/////////////////

/obj/vehicle/walker/attackby(obj/item/held_item, mob/user as mob)
	if(istype(held_item, /obj/item/ammo_magazine/walker))
		if(left && !left.ammo && istype(held_item, left.magazine_type))
			rearm(held_item, user, left)
		else if(right && !right.ammo && istype(held_item, right.magazine_type))
			rearm(held_item, user, right)
		else
			to_chat(user, "You cannot fit that magazine in any weapon.")
			return

	else if(istype(held_item, /obj/item/walker_gun))
		var/slot = tgui_alert(user, "On which hardpoint install gun.", "Hardpoint", list("Left", "Right", "Cancel"))
		if(slot && slot != "Cancel")
			install_gun(held_item, user, slot)

	else if(HAS_TRAIT(held_item, TRAIT_TOOL_WRENCH))
		var/slot = tgui_alert(user, "Which hardpoint should be dismounted.", "Hardpoint", list("Left", "Right", "Cancel"))
		if(slot && slot != "Cancel")
			dismount(held_item, user, slot)

	else if(iswelder(held_item))
		repair_walker(held_item, user)

	else
		. = ..()

/obj/vehicle/walker/proc/rearm(obj/item/ammo_magazine/walker/mag, mob/user, obj/item/walker_gun/selected_gun)
	if(!do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
		to_chat(user, "Your action was interrupted.")
		return

	user.drop_inv_item_to_loc(mag, selected_gun)
	selected_gun.ammo = mag
	to_chat(user, "You load magazine in [selected_gun.name].")

/obj/vehicle/walker/proc/install_gun(obj/item/walker_gun/gun, mob/user, slot)
	if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_MASTER))
		to_chat(user, "You don't know how to mount weapon.")
		return

	if((slot == "Left" && left) || (slot == "Right" && right))
		to_chat(user, "This [lowertext(slot)] hardpoint is full")
		return

	to_chat(user, "You start mounting [gun.name] on [lowertext(slot)] hardpoint.")
	if(do_after(user, 100, TRUE, 5, BUSY_ICON_BUILD))
		user.drop_inv_item_to_loc(gun, src)
		gun.owner = src
		if(slot == "Left")
			left = gun
		else
			right = gun

		to_chat(user, "You mount [gun.name] on [lowertext(slot)] hardpoint.")
		update_icon()
	else
		to_chat(user, "Mounting has been interrupted.")

/obj/vehicle/walker/proc/dismount(obj/item/tool, mob/user, slot)
	if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_MASTER))
		to_chat(user, "You don't know how to mount weapon.")
		return

	if((slot == "Left" && !left) || (slot == "Right" && !right))
		to_chat(user, "This [lowertext(slot)] hardpoint is empty")
		return

	to_chat(user, "You start dismounting [lowertext(slot)] hardpoint.")
	if(do_after(user, 100, TRUE, 5, BUSY_ICON_BUILD))
		if(slot == "Left")
			left.forceMove(get_turf(src))
			left.owner = null
			left = null
		else
			right.forceMove(get_turf(src))
			right.owner = null
			right = null

		to_chat(user, "You dismount [lowertext(slot)] hardpoint.")
		update_icon()
	else
		to_chat(user, "Dismounting has been interrupted.")

/obj/vehicle/walker/proc/repair_walker(obj/item/tool/weldingtool/weld  as obj, mob/user as mob)
	if(!weld.isOn())
		return
	if(health >= max_health)
		to_chat(user, "Armor seems fully intact.")
		return
	if(repair)
		to_chat(user, "Someone already reparing this vehicle.")
		return
	repair = TRUE
	var/repair_time = 1 SECONDS

	to_chat(user, SPAN_NOTICE("You start repairing broken part of [src.name]'s armor..."))
	playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)

	while (weld.get_fuel() > 1)
		if(!(world.time % 3))
			playsound(get_turf(user), 'sound/items/weldingtool_weld.ogg', 25)
		if(!do_after(user, repair_time, INTERRUPT_ALL, BUSY_ICON_BUILD))
			break
		if(!skillcheckexplicit(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_NOTICE("You haphazardly weld together chunks of broken armor."))
			health += 5
			healthcheck()
		else
			health += 25
			healthcheck()
			to_chat(user, SPAN_NOTICE("You repair broken part of the armor."))
		if(seats[VEHICLE_DRIVER])
			to_chat(seats[VEHICLE_DRIVER], SPAN_NOTICE("Notification.Armor partly restored."))

		weld.remove_fuel(1, user)

		if (health >= max_health)
			health = max_health
			to_chat(user, SPAN_NOTICE("You've finished repairing the walker"))
			break

		if(!weld.isOn())
			break;

	repair = FALSE


/////////
//Attack_alien
/////////

/obj/vehicle/walker/attack_alien(mob/living/carbon/xenomorph/X)
	// If they're on help intent, attempt to enter the vehicle
	if(X.a_intent == INTENT_HELP)
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
		X.visible_message(SPAN_DANGER("\The [X] swipes at \the [src] to no effect!"), \
		SPAN_DANGER("We swipe at \the [src] to no effect!"))
		return XENO_ATTACK_ACTION

	X.visible_message(SPAN_DANGER("\The [X] slashes \the [src]!"), \
	SPAN_DANGER("We slash \the [src]!"))
	playsound(X.loc, pick('sound/effects/metalhit.ogg', "alien_claw_metal"), 25, 1)

	take_damage_type(damage * damage_mult, "slash", X)

	healthcheck()
	return XENO_ATTACK_ACTION

/obj/vehicle/walker/healthcheck()
	if(health > max_health)
		health = max_health
	else if(!health)
		move_out()
		new /obj/structure/walker_wreckage(src.loc)
		playsound(loc, 'fray-marines/sound/vehicle/walker/mecha_dead.ogg', 75)
		qdel(src)

//Differentiates between damage types from different bullets
//Applies a linear transformation to bullet damage that will generally decrease damage done
/obj/vehicle/walker/bullet_act(obj/projectile/P)
	var/dam_type = "bullet"
	var/damage = P.damage
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	var/penetration = P.ammo.penetration
	var/firer = P.firer

	//IFF bullets magically stop themselves short of hitting friendly vehicles,
	//because both sentries and smartgun users keep trying to shoot through them
	if(P.runtime_iff_group && get_target_lock(P.runtime_iff_group))
		return

	if(ammo_flags & AMMO_ANTISTRUCT|AMMO_ANTIVEHICLE)
		// Multiplier based on tank railgun relationship, so might have to reconsider multiplier for AMMO_SIEGE in general
		damage = round(damage*ANTISTRUCT_DMG_MULT_TANK)
	if(ammo_flags & AMMO_ACIDIC)
		dam_type = "acid"

	bullet_ping(P)

	take_damage_type(damage * (0.33 + penetration/100), dam_type, firer)

	healthcheck()

/obj/vehicle/walker/proc/take_damage_type(damage, type, atom/attacker)
	damage = damage * get_dmg_multi(type)
	if(damage <= 3)
		to_chat(, SPAN_DANGER("ALERT! Hostile incursion detected. Deflected."))
		return

	health = max(0, health - damage)

	to_chat(seats[VEHICLE_DRIVER], SPAN_DANGER("ALERT! Hostile incursion detected. Chassis taking damage.</span>"))
	if(ismob(attacker))
		var/mob/M = attacker
		log_attack("[src] took [damage] [type] damage from [M] ([M.client ? M.client.ckey : "disconnected"]).")
	else
		log_attack("[src] took [damage] [type] damage from [attacker].")
	healthcheck()

//Returns the ratio of damage to take, just a housekeeping thing
/obj/vehicle/walker/proc/get_dmg_multi(type)
	if(!dmg_multipliers || !dmg_multipliers.Find(type))
		return 1
	return dmg_multipliers[type] * dmg_multipliers["all"]

/obj/vehicle/walker/Collided(atom/A)
	. = ..()

	var/mob/living/carbon/xenomorph/crusher/crusher = A
	if(istype(crusher))
		if(!crusher.throwing)
			return

		if(health > 0)
			take_damage_type(250, "blunt", crusher)
			visible_message(SPAN_DANGER("\The [crusher] rams \the [src]!"))
			Move(get_step(src, crusher.dir))
		playsound(loc, 'fray-marines/sound/vehicle/walker/mecha_crusher.ogg', 35)

/obj/vehicle/walker/hear_talk(mob/living/M as mob, msg, verb = "says", datum/language/speaking, italics = 0)
	var/mob/driver = seats[VEHICLE_DRIVER]
	if (driver == null)
		return
	else if (driver != M)
		driver.hear_say(msg, verb, speaking, "", italics, M)
	else
		var/list/mob/listeners = get_mobs_in_view(9,src)

		var/list/mob/langchat_long_listeners = list()
		listeners += driver
		for(var/mob/listener in listeners)
			if(!ishumansynth_strict(listener) && !isobserver(listener))
				listener.show_message("[src] broadcasts something, but you can't understand it.")
				continue
			listener.show_message("<B>[src]</B> broadcasts, [FONT_SIZE_LARGE("\"[msg]\"")]", SHOW_MESSAGE_AUDIBLE) // 2 stands for hearable message
			langchat_long_listeners += listener
		langchat_long_speech(msg, langchat_long_listeners, driver.get_default_language())

//to handle IFF bullets
/obj/vehicle/walker/proc/get_target_lock(access_to_check)
	if(isnull(access_to_check) || !vehicle_faction)
		return FALSE

	if(!islist(access_to_check))
		return access_to_check == vehicle_faction

	return vehicle_faction in access_to_check

/obj/structure/walker_wreckage
	name = "CW13 wreckage"
	desc = "Remains of some unfortunate walker. Completely unrepairable."
	icon = 'fray-marines/icons/obj/vehicles/mech.dmi'
	icon_state = "mech_broken"
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	pixel_x = -18
