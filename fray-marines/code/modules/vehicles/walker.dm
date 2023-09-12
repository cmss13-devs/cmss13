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
	opacity = TRUE
	can_buckle = FALSE
	move_delay = 6
	req_access = list(ACCESS_MARINE_WALKER)

	var/lights = FALSE
	var/lights_power = 8
	var/zoom = FALSE
	var/zoom_size = 14

	pixel_x = -18

	health = 1500
	var/maxHealth = 1500
	var/repair = FALSE

	var/mob/pilot = null

	var/acid_process_cooldown = null
	var/list/dmg_multipliers = list(
		"all" = 1.0, //for when you want to make it invincible
		"acid" = 0.9,
		"slash" = 0.6,
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

/obj/vehicle/walker/Initialize()
	. = ..()

	unacidable = 0

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

/obj/vehicle/walker/relaymove(mob/user, direction)
	if(user.is_mob_incapacitated()) return
	if(seats[VEHICLE_DRIVER] != user) return
	seats[VEHICLE_DRIVER].set_interaction(src)

	if(world.time > l_move_time + move_delay)
		if (zoom)
			unzoom()
		if(dir != direction && reverse_dir[dir] != direction)
			l_move_time = world.time
			dir = direction
			pick(playsound(src.loc, 'sound/mecha/powerloader_turn.ogg', 25, 1), playsound(src.loc, 'sound/mecha/powerloader_turn2.ogg', 25, 1))
			. = TRUE
		else
			var/oldDir = dir
			. = step(src, direction)
			setDir(oldDir)
			if(.)
				pick(playsound(loc, 'sound/mecha/powerloader_step.ogg', 25), playsound(loc, 'sound/mecha/powerloader_step2.ogg', 25))

/obj/vehicle/walker/Bump(atom/obstacle)
	if(istype(obstacle, /obj/structure/machinery/door))
		var/obj/structure/machinery/door/door = obstacle
		if(door.allowed(seats[VEHICLE_DRIVER]))
			door.open()
		else
			flick("door_deny", door)

	else if(ishuman(obstacle))
		step_away(obstacle, src, 0)
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

/obj/vehicle/walker/verb/enter_walker()
	set category = "Object"
	set name = "Enter Into Walker"
	set src in oview(1)

	if(usr.skills.get_skill_level(SKILL_POWERLOADER))
		move_in(usr)
	else
		to_chat(usr, "How to operate it?")

/obj/vehicle/walker/proc/move_in(mob/living/carbon/user)
	set waitfor = FALSE
	if(!ishuman(user))
		return
	if(seats[VEHICLE_DRIVER])
		to_chat(user, "There is someone occupying mecha right now.")
		return
	var/mob/living/carbon/human/H = user
	for(var/ID in list(H.wear_id, H.belt))
		if(operation_allowed(ID))
			seats[VEHICLE_DRIVER] = user
			add_verb(seats[VEHICLE_DRIVER].client, list(
				/obj/vehicle/walker/proc/eject,
				/obj/vehicle/walker/proc/lights,
				/obj/vehicle/walker/proc/zoom,
				/obj/vehicle/walker/proc/select_weapon,
				/obj/vehicle/walker/proc/deploy_magazine,
				/obj/vehicle/walker/proc/get_stats,
			))
			user.loc = src
			seats[VEHICLE_DRIVER].client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
			seats[VEHICLE_DRIVER].set_interaction(src)
			playsound_client(seats[VEHICLE_DRIVER].client, 'sound/mecha/powerup.ogg')
			update_icon()
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), seats[VEHICLE_DRIVER].client, 'sound/mecha/nominalsyndi.ogg'), 5 SECONDS)
			return

	to_chat(user, "Access denied.")

/obj/vehicle/walker/proc/operation_allowed(obj/item/I)
	if(check_access(I))
		return TRUE
	return FALSE

/obj/vehicle/walker/proc/eject()
	set name = "Eject"
	set category = "Vehicle"
	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/walker/W = M.interactee

	if(!W || !istype(W))
		return
	W.move_out()

/obj/vehicle/walker/proc/move_out()
	if(!seats[VEHICLE_DRIVER])
		return FALSE
	if(health <= 0)
		to_chat(seats[VEHICLE_DRIVER], "<span class='danger'>PRIORITY ALERT! Chassis integrity failing. Systems shutting down.</span>")
	if(zoom)
		unzoom()
	if(seats[VEHICLE_DRIVER].client)
		seats[VEHICLE_DRIVER].client.mouse_pointer_icon = initial(seats[VEHICLE_DRIVER].client.mouse_pointer_icon)
	seats[VEHICLE_DRIVER].unset_interaction()
	seats[VEHICLE_DRIVER].loc = src.loc
	remove_verb(seats[VEHICLE_DRIVER].client, list(
				/obj/vehicle/walker/proc/eject,
				/obj/vehicle/walker/proc/lights,
				/obj/vehicle/walker/proc/zoom,
				/obj/vehicle/walker/proc/select_weapon,
				/obj/vehicle/walker/proc/deploy_magazine,
				/obj/vehicle/walker/proc/get_stats,
			))
	seats[VEHICLE_DRIVER] = null
	update_icon()
	return TRUE

/obj/vehicle/walker/proc/lights()
	set name = "Lights on/off"
	set category = "Vehicle"
	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/walker/W = M.interactee


	if(!W || !istype(W))
		return
	W.handle_lights()

/obj/vehicle/walker/proc/handle_lights()
	if(!lights)
		lights = TRUE
		set_light(lights_power)
	else
		lights = FALSE
		set_light(-lights_power)
	seats[VEHICLE_DRIVER] << sound('sound/machines/click.ogg',volume=50)

/obj/vehicle/walker/proc/deploy_magazine()
	set name = "Deploy Magazine"
	set category = "Vehicle"
	var/mob/M = usr

	var/obj/vehicle/walker/W = M.interactee

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

/obj/vehicle/walker/proc/get_stats()
	set name = "Status Display"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/walker/W = M.interactee

	if(!W || !istype(W))
		return

	if(M != W.seats[VEHICLE_DRIVER])
		return
	W.statistics(M)

/obj/vehicle/walker/proc/statistics(mob/user)
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
		to_chat(user, "<span class='notice'>Right hardpoint: [left.name].\n Current ammo level: [munition]</span>")
	else
		to_chat(user, "<span class='warning'>RIGHT HARDPOINT IS EMPTY!</span>")

/obj/vehicle/walker/proc/select_weapon()
	set name = "Select Weapon"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/walker/W = M.interactee

	if(!W || !istype(W))
		return

	if(W.selected)
		if(!W.right)
			return
		W.selected = !W.selected
	else
		if(!W.left)
			return
		W.selected = !W.selected
	to_chat(M, "Selected [W.selected ? "[W.left]" : "[W.right]"]")

/obj/vehicle/walker/handle_click(mob/living/user, atom/A, list/mods)
	if(!firing_arc(A))
		var/newDir = get_cardinal_dir(src, A)
		l_move_time = world.time
		dir = newDir
		pick(playsound(src.loc, 'sound/mecha/powerloader_turn.ogg', 25, 1), playsound(src.loc, 'sound/mecha/powerloader_turn2.ogg', 25, 1))
		return
	if(selected)
		if(!left)
			to_chat(usr, "<span class='warning'>WARNING! Hardpoint is empty.</span>")
			return
		left.active_effect(A)
	else
		if(!right)
			to_chat(usr, "<span class='warning'>WARNING! Hardpoint is empty.</span>")
			return
		right.active_effect(A)

/obj/vehicle/walker/proc/firing_arc(atom/A)
	var/turf/T = get_turf(A)
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

/obj/vehicle/walker/proc/zoom()
	set name = "Zoom on/off"
	set category = "Vehicle"

	var/mob/M = usr
	if(!M || !istype(M))
		return

	var/obj/vehicle/walker/W = M.interactee

	if(!W || !istype(W))
		return

	W.zoom_activate()

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
		user.client.change_view(world_view_size, src)
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
	var/repair_time = 20 SECONDS

	to_chat(user, "You start repairing broken part of [src.name]'s armor...")
	if(do_after(user, repair_time, TRUE, 5, BUSY_ICON_BUILD))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, "You haphazardly weld together chunks of broken armor.")
			health += 100
			healthcheck()
		else
			health += 250
			healthcheck()
			to_chat(user, "You repair broken part of the armor.")
		playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)
		if(seats[VEHICLE_DRIVER])
			to_chat(seats[VEHICLE_DRIVER], "Notification.Armor partly restored.")
		repair = FALSE
		return
	else
		to_chat(user, "Repair has been interrupted.")
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
	take_damage(M.melee_vehicle_damage + rand(-5,5), "slash")

	return XENO_ATTACK_ACTION

/obj/vehicle/walker/healthcheck()
	if(health > maxHealth)
		health = maxHealth
		return
	if(health <= 0)
		move_out()
		new /obj/structure/walker_wreckage(src.loc)
		playsound(loc, 'sound/effects/metal_crash.ogg', 75)
		qdel(src)

/obj/vehicle/walker/bullet_act(obj/item/projectile/Proj)
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
	if(damage <= 10)
		to_chat(seats[VEHICLE_DRIVER], "<span class='danger'>ALERT! Hostile incursion detected. Deflected.</span>")
		return

	health -= damage
	to_chat(seats[VEHICLE_DRIVER], "<span class='danger'>ALERT! Hostile incursion detected. Chassis taking damage.</span>")
	if(seats[VEHICLE_DRIVER] && damage >= 50)
		seats[VEHICLE_DRIVER] << sound('sound/mecha/critdestrsyndi.ogg',volume=50)
	healthcheck()



/obj/structure/walker_wreckage
	name = "CW13 wreckage"
	desc = "Remains of some unfortunate walker. Completely unrepairable."
	icon = 'fray-marines/icons/obj/vehicles/mech.dmi'
	icon_state = "mech_broken"
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	pixel_x = -18
