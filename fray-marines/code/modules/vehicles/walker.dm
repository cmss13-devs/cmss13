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
	var/maxHealth = 1000
	var/repair = FALSE

	var/mob/pilot = null

	var/acid_process_cooldown = null
	var/list/dmg_multipliers = list(
		"all" = 1.0, //for when you want to make it invincible
		"acid" = 1.2,
		"slash" = 0.85,
		"bullet" = 0.2,
		"explosive" = 5.0,
		"blunt" = 0.1,
		"energy" = 1.0,
		"abstract" = 1.0) //abstract for when you just want to hurt it

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
				/obj/vehicle/walker/verb/select_weapon,
				/obj/vehicle/walker/verb/get_stats,
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
	var/integrity = round(health/maxHealth*100)
	switch(integrity)
		if(85 to 100)
			. += "\nIt's fully intact."
		if(65 to 85)
			. += "\nIt's slightly damaged."
		if(45 to 65)
			. += "\nIt's badly damaged."
		if(25 to 45)
			. += "\nIt's heavily damaged."
		else
			. += "\nIt's falling apart."
	. += "\n[left ? left.name : "Nothing"] is placed on its left hardpoint."
	. += "\n[right ? right.name : "Nothing"] is placed on its right hardpoint."

	return .

/obj/vehicle/walker/ex_act(severity)
	switch(severity)
		if (1)
			if(prob(10))									// "- You have three seconds to run before I stab you in the anus!"@ Walker Pilot to rocket spec.
				health = 0
				healthcheck()
				return
			take_damage(20, "explosive")					// 100 damage btw. 2 instance of MT repair. 3-4 minutes standing IDLY near walker.
		if (2)
			take_damage(15, "explosive")
		if (3)
			take_damage(10, "explosive")					// 10 * 5.0 = 50. Maxhealth is 400. Hellova damage

/obj/vehicle/walker/MouseDrop_T(mob/target, mob/user)
	. = ..()
	var/mob/living/H = user
	if(!istype(H) || target != user) //No making other people climb into walker.
		return

	if(usr.skills.get_skill_level(SKILL_POWERLOADER))
		move_in(H)
	else
		to_chat(H, "How to operate it?")

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
				xeno.apply_damage(round((maxHealth / 100) * VEHICLE_TRAMPLE_DAMAGE_MIN), BRUTE)
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
		F.visible_message("<span class='danger'>[src.name] smashes through [F]!</span>")
		take_damage(5, "abstract")
		F.health = 0
		F.healthcheck()
	else if(istype(obstacle, /obj/structure/surface/table))
		var/obj/structure/surface/table/T = obstacle
		T.visible_message("<span class='danger'>[src.name] crushes [T]!</span>")
		take_damage(5, "abstract")
		T.deconstruct(TRUE)
	else if(istype(obstacle, /obj/structure/showcase))
		var/obj/structure/showcase/S = obstacle
		S.visible_message("<span class='danger'>[src.name] bulldozes over [S]!</span>")
		take_damage(15, "abstract")
		S.deconstruct(TRUE)
	else if(istype(obstacle, /obj/structure/window/framed))
		var/obj/structure/window/framed/W = obstacle
		W.visible_message("<span class='danger'>[src.name] crashes through the [W]!</span>")
		take_damage(20, "abstract")
		W.shatter_window(1)
	else if(istype(obstacle, /obj/structure/window_frame))
		var/obj/structure/window_frame/WF = obstacle
		WF.visible_message("<span class='danger'>[src.name] runs over the [WF]!</span>")
		take_damage(20, "abstract")
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
			add_verb(H, list(
				/obj/vehicle/walker/verb/get_out,
				/obj/vehicle/walker/verb/toggle_lights,
				/obj/vehicle/walker/verb/toggle_zoom,
				/obj/vehicle/walker/verb/eject_magazines,
				/obj/vehicle/walker/verb/select_weapon,
				/obj/vehicle/walker/verb/get_stats,
			))
			user.loc = src
			seats[VEHICLE_DRIVER].client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
			seats[VEHICLE_DRIVER].set_interaction(src)
			RegisterSignal(H, COMSIG_MOB_RESISTED, PROC_REF(move_out))
			to_chat(seats[VEHICLE_DRIVER], SPAN_HELPFUL("Нажмите среднюю кнопку мыши чтобы менять оружие."))
			to_chat(seats[VEHICLE_DRIVER], SPAN_HELPFUL("Нажмите Shift+MMB для сброса боеприпасов с основного орудия."))

			if (selected) {
				if (left && left.automatic) {
					left.register_signals(user)
				}
			} else {
				if (right && right.automatic) {
					right.register_signals(user)
				}
			}

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
	if(!seats[VEHICLE_DRIVER])
		return FALSE
	if(health <= 0)
		to_chat(seats[VEHICLE_DRIVER], "<span class='danger'>PRIORITY ALERT! Chassis integrity failing. Systems shutting down.</span>")
	if(zoom)
		unzoom()
	if(seats[VEHICLE_DRIVER].client)
		seats[VEHICLE_DRIVER].client.mouse_pointer_icon = initial(seats[VEHICLE_DRIVER].client.mouse_pointer_icon)

	var/mob/living/L = seats[VEHICLE_DRIVER]

	if(!do_after(L, 1 SECONDS, INTERRUPT_ALL, null, src, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		return

	L.unset_interaction()
	L.loc = src.loc
	L.reset_view(null)
	remove_verb(L, list(
				/obj/vehicle/walker/verb/get_out,
				/obj/vehicle/walker/verb/toggle_lights,
				/obj/vehicle/walker/verb/toggle_zoom,
				/obj/vehicle/walker/verb/eject_magazines,
				/obj/vehicle/walker/verb/select_weapon,
				/obj/vehicle/walker/verb/get_stats,
			))
	UnregisterSignal(L, COMSIG_MOB_RESISTED)

	if (selected) {
		if (left && left.automatic) {
			left.unregister_signals(L)
		}
	} else {
		if (right && right.automatic) {
			right.unregister_signals(L)
		}
	}
	seats[VEHICLE_DRIVER] = null
	update_icon()
	return TRUE

/obj/vehicle/walker/proc/lights()
	var/mob/M = seats[VEHICLE_DRIVER]

	if(!M || !istype(M))
		return

	if(!lights)
		lights = TRUE
		set_light(lights_power)
	else
		lights = FALSE
		set_light(-lights_power)
	seats[VEHICLE_DRIVER] << sound('sound/machines/click.ogg',volume=50)

/obj/vehicle/walker/proc/deploy_magazine()
	var/mob/M = seats[VEHICLE_DRIVER]

	var/obj/vehicle/walker/W = src

	if(!W || !istype(W))
		return

	if(W.selected)
		if(!W.left || !W.left.ammo)
			return
		else
			W.left.ammo.loc = W.loc
			W.left.ammo = null
			to_chat(M, "<span class='warning'>WARNING! [W.left.name] ammo magazine deployed.</span>")
			visible_message("[W.name]'s systems deployed used magazine.","")
	else
		if(!W.right || !W.right.ammo)
			return
		else
			W.right.ammo.loc = W.loc
			W.right.ammo = null
			to_chat(M, "<span class='warning'>WARNING! [W.right.name] ammo magazine deployed.</span>")
			visible_message("[W.name]'s systems deployed used magazine.","")

// /obj/vehicle/walker/proc/get_stats()
// 	set name = "Status Display"
// 	set category = "Vehicle"

// 	var/mob/M = usr
// 	if(!M || !istype(M))
// 		return

// 	var/obj/vehicle/walker/W = M.interactee

// 	if(!W || !istype(W))
// 		return

// 	if(M != W.seats[VEHICLE_DRIVER])
// 		return
// 	W.statistics(M)

/obj/vehicle/walker/proc/statistics(mob/user)
	if(!user)
		user = seats[VEHICLE_DRIVER]

		if(!user)
			return

	to_chat(user, "<h2>[name] Interface</h2>")
	to_chat(user, "<span class='notice'>Vehicle Status:</span><br>")

	var/danger = "'notice'"

	var/curr_health = round(health/maxHealth*100)
	danger = "'notice'"
	if(curr_health <= 50)
		danger = "'warning'"
	if(curr_health <= 25)
		danger = "'danger'"
	to_chat(user, "<span class='notice'>Overall vehicle integrity: </span><span class=[danger]> [curr_health] percent. [danger == "'danger'" ? "LEVEL CRITICAL!" : ""]</span>")

	to_chat(user, "<span class='notice'>=========</span>\n")

	if(left)
		var/munition = left.ammo ? "[left.ammo.current_rounds]/[left.ammo.max_rounds]" : "<span class='warning'>DEPLETED</span>"
		to_chat(user, "<span class='notice'>Left hardpoint: [left.name].\n Current ammo level: [munition]</span>")
	else
		to_chat(user, "<span class='warning'>LEFT HARDPOINT IS EMPTY!</span>")

	if(right)
		var/munition = right.ammo ? "[right.ammo.current_rounds]/[right.ammo.max_rounds]" : "<span class='warning'>DEPLETED</span>"
		to_chat(user, "<span class='notice'>Right hardpoint: [right.name].\n Current ammo level: [munition]</span>")
	else
		to_chat(user, "<span class='warning'>RIGHT HARDPOINT IS EMPTY!</span>")

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

/obj/vehicle/walker/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_magazine/walker))
		var/obj/item/ammo_magazine/walker/mag = W
		rearm(mag, user)

	else if(istype(W, /obj/item/walker_gun))
		var/obj/item/walker_gun/WG = W
		install_gun(WG, user)

	else if(HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		var/obj/item/tool/wrench/WR = W
		dismount(WR, user)

	else if(iswelder(W))
		var/obj/item/tool/weldingtool/weld = W
		repair_walker(weld, user)

	else
		. = ..()

/obj/vehicle/walker/proc/install_gun(obj/item/walker_gun/W, mob/user as mob)
	if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_MASTER))
		to_chat(user, "You don't know how to mount weapon.")
		return
	var/choice = input("On which hardpoint install gun.") in list("Left", "Right", "Cancel")
	switch(choice)
		if("Cancel")
			return

		if("Left")
			if(left)
				to_chat(user, "This hardpoint is full")
				return
			to_chat(user, "You start mounting [W.name] on left hardpoint.")
			if(do_after(user, 100, TRUE, 5, BUSY_ICON_BUILD))
				user.drop_held_item()
				W.loc = src
				left = W
				left.owner = src
				to_chat(user, "You mount [W.name] on left hardpoint.")
				update_icon()
				return
			return

		if("Right")
			if(right)
				to_chat(user, "This hardpoint is full")
				return
			to_chat(user, "You start mounting [W.name] on right hardpoint.")
			if(do_after(user, 100, TRUE, 5, BUSY_ICON_BUILD))
				user.drop_held_item()
				W.loc = src
				right = W
				right.owner = src
				to_chat(user, "You mount [W] on right hardpoint.")
				update_icon()
				return
			return

/obj/vehicle/walker/proc/rearm(obj/item/ammo_magazine/walker/mag  as obj, mob/user as mob)
	if(left && !left.ammo && istype(mag, left.magazine_type))
		if(!do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
			to_chat(user, "Your action was interrupted.")
			return
		else
			user.drop_held_item()
			mag.loc = left
			left.ammo = mag
			to_chat(user, "You install magazine in [left.name].")
			return

	else if(right && !right.ammo && istype(mag, right.magazine_type))
		if(!do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
			to_chat(user, "Your action was interrupted.")
			return
		else
			user.drop_held_item()
			mag.loc = right
			right.ammo = mag
			to_chat(user, "You install magazine in [right.name].")
			return

	else
		to_chat(user, "You cannot fit that magazine in any weapon.")
		return

/obj/vehicle/walker/proc/dismount(obj/item/tool/wrench/WR  as obj, mob/user as mob)
	if(!left && !right)
		return
	var/choice = input("Which hardpoint should be dismounted.") in list("Left", "Right", "Cancel")
	switch(choice)
		if("Cancel")
			return

		if("Left")
			if(!left)
				to_chat(user, "Left hardpoint is empty.")
				return
			to_chat(user, "You start dismounting [left.name] from walker.")
			if(do_after(user, 100, TRUE, 5, BUSY_ICON_BUILD))
				left.loc = loc
				left = null
				update_icon()
				return
			else
				to_chat(user, "Dismounting has been interrupted.")

		if("Right")
			if(!right)
				to_chat(user, "Right hardpoint is empty.")
				return
			to_chat(user, "You start dismounting [right.name] from walker.")
			if(do_after(user, 100, TRUE, 5, BUSY_ICON_BUILD))
				right.loc = loc
				right = null
				update_icon()
				return
			else
				to_chat(user, "Dismounting has been interrupted.")

/obj/vehicle/walker/proc/repair_walker(obj/item/tool/weldingtool/weld  as obj, mob/user as mob)
	if(!weld.isOn())
		return
	if(health >= maxHealth)
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

		if (health >= maxHealth)
			health = maxHealth
			to_chat(user, SPAN_NOTICE("You've finished repairing the walker"))
			break

		if(!weld.isOn())
			break;

	repair = FALSE


/////////
//Attack_alien
/////////

/obj/vehicle/walker/attack_alien(mob/living/carbon/xenomorph/M)
	if(M.a_intent == INTENT_HELP)
		return XENO_NO_DELAY_ACTION

	// if(M.mob_size < MOB_SIZE_XENO)
	// 	to_chat(M, SPAN_XENOWARNING("You're too small to do any significant damage to this vehicle!"))
	// 	return XENO_NO_DELAY_ACTION

	M.animation_attack_on(src)
	playsound(loc, "alien_claw_metal", 25, 1)
	M.visible_message(SPAN_DANGER("[M] slashes [src]!"), SPAN_DANGER("You slash [src]!"))
	take_damage(M.melee_vehicle_damage + rand(-5,5) + rand(5, 10) * (M.claw_type - 1), "slash")

	return XENO_ATTACK_ACTION

/obj/vehicle/walker/healthcheck()
	if(health > maxHealth)
		health = maxHealth
		return
	if(health <= 0)
		move_out()
		new /obj/structure/walker_wreckage(src.loc)
		playsound(loc, 'fray-marines/sound/vehicle/walker/mecha_dead.ogg', 75)
		qdel(src)

/obj/vehicle/walker/bullet_act(obj/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.ammo.damage_type)
		if(BRUTE)
			if(Proj.ammo.flags_ammo_behavior & AMMO_ROCKET)
				take_damage(Proj.damage, "explosive")
			else
				take_damage(Proj.damage, "bullet")
		if(BURN)
			if(Proj.ammo.flags_ammo_behavior & AMMO_XENO)
				take_damage(Proj.damage, "acid")
			else
				take_damage(Proj.damage, "energy")
		if(TOX, OXY, CLONE)
			return

/obj/vehicle/walker/proc/take_damage(dam, damtype = "blunt")
	if(!dam || dam <= 0)
		return
	if(!(damtype in list("explosive", "acid", "energy", "blunt", "slash", "bullet", "all", "abstract")))
		return
	var/damage = dam * dmg_multipliers[damtype]
	if(damage <= 3)
		to_chat(seats[VEHICLE_DRIVER], "<span class='danger'>ALERT! Hostile incursion detected. Deflected.</span>")
		return

	health -= damage
	to_chat(seats[VEHICLE_DRIVER], "<span class='danger'>ALERT! Hostile incursion detected. Chassis taking damage.</span>")
	if(seats[VEHICLE_DRIVER] && damage >= 50)
		seats[VEHICLE_DRIVER] << sound('fray-marines/sound/vehicle/walker/mecha_alarm.ogg',volume=50)
	healthcheck()

/obj/vehicle/walker/Collided(atom/A)
	. = ..()

	if(iscrusher(A))
		var/mob/living/carbon/xenomorph/crusher/C = A
		if(!C.throwing)
			return

		if(health > 0)
			take_damage(250, "abstract")
			visible_message(SPAN_DANGER("\The [A] rams \the [src]!"))
			Move(get_step(src, A.dir))
		playsound(loc, 'fray-marines/sound/vehicle/walker/mecha_crusher.ogg', 35)

/obj/vehicle/walker/hear_talk(mob/living/M as mob, msg, verb="says", datum/language/speaking, italics = 0)
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

/obj/structure/walker_wreckage
	name = "CW13 wreckage"
	desc = "Remains of some unfortunate walker. Completely unrepairable."
	icon = 'fray-marines/icons/obj/vehicles/mech.dmi'
	icon_state = "mech_broken"
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	pixel_x = -18
