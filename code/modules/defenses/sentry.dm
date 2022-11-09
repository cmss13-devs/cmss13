#define SENTRY_FIREANGLE 	135
#define SENTRY_RANGE 		5
#define SENTRY_MUZZLELUM	3

/obj/structure/machinery/defenses/sentry
	name = "\improper UA 571-C sentry gun"
	icon = 'icons/obj/structures/machinery/defenses/sentry.dmi'
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an M30 Autocannon and a 500-round drum magazine."
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_ENGPREP, ACCESS_MARINE_LEADER)
	var/list/targets = list() // Lists of current potential targets
	var/list/other_targets = list() //List of special target types to shoot at, if needed.
	var/atom/movable/target = null
	var/datum/shape/rectangle/range_bounds
	var/datum/effect_system/spark_spread/spark_system //The spark system, used for generating... sparks?
	var/last_fired = 0
	var/fire_delay = 4
	var/immobile = FALSE //Used for prebuilt ones.
	var/obj/item/ammo_magazine/ammo = new /obj/item/ammo_magazine/sentry
	var/sentry_type = "sentry" //Used for the icon
	display_additional_stats = TRUE

	var/omni_directional = FALSE
	var/sentry_range = SENTRY_RANGE

	var/damage_mult = 1
	var/accuracy_mult = 1
	handheld_type = /obj/item/defenses/handheld/sentry

/obj/structure/machinery/defenses/sentry/Initialize()
	. = ..()
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	if(turned_on)
		start_processing()
		set_range()
	update_icon()

/obj/structure/machinery/defenses/sentry/Destroy() //Clear these for safety's sake.
	targets = null
	other_targets = null
	target = null
	QDEL_NULL(range_bounds)
	QDEL_NULL(spark_system)
	QDEL_NULL(ammo)
	stop_processing()
	SetLuminosity(0)
	. = ..()

/obj/structure/machinery/defenses/sentry/process()
	if(!turned_on)
		stop_processing()
		return

	if(!range_bounds)
		set_range()
	targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(!targets)
		return FALSE

	if(!target && targets.len)
		target = pick(targets)

	get_target(target)
	return TRUE

/obj/structure/machinery/defenses/sentry/proc/set_range()
	if(omni_directional)
		range_bounds = RECT(x, y, 8, 8)
		return
	switch(dir)
		if(EAST)
			range_bounds = RECT(x + 4, y, 7, 7)
		if(WEST)
			range_bounds = RECT(x - 4, y, 7, 7)
		if(NORTH)
			range_bounds = RECT(x, y + 4, 7, 7)
		if(SOUTH)
			range_bounds = RECT(x, y - 4, 7, 7)

/obj/structure/machinery/defenses/sentry/proc/unset_range()
	qdel(range_bounds)

/obj/structure/machinery/defenses/sentry/update_icon()
	..()

	overlays.Cut()
	if(stat == DEFENSE_DAMAGED)
		overlays += "[defense_type] uac_[sentry_type]_destroyed"
		return

	if(!ammo || ammo && !ammo.current_rounds)
		overlays += "[defense_type] uac_[sentry_type]_noammo"
		return
	if(turned_on)
		overlays += "[defense_type] uac_[sentry_type]_on"
	else
		overlays += "[defense_type] uac_[sentry_type]"


/obj/structure/machinery/defenses/sentry/attack_hand_checks(var/mob/user)
	if(immobile)
		to_chat(user, SPAN_WARNING("[src]'s panel is completely locked, you can't do anything."))
		return FALSE

	return TRUE

/obj/structure/machinery/defenses/sentry/get_examine_text(mob/user)
	. = ..()
	if(ammo)
		. += SPAN_NOTICE("[src] has [ammo.current_rounds]/[ammo.max_rounds] round\s loaded.")
	else
		. += SPAN_NOTICE("[src] is empty and needs to be refilled with ammo.")

/obj/structure/machinery/defenses/sentry/power_on_action()
	target = null
	SetLuminosity(7)

	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] hums to life and emits several beeps.")]")
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] buzzes in a monotone voice: 'Default systems initiated'")]")
	start_processing()
	set_range()

/obj/structure/machinery/defenses/sentry/power_off_action()
	SetLuminosity(0)
	visible_message("[icon2html(src, viewers(src))] [SPAN_NOTICE("The [name] powers down and goes silent.")]")
	stop_processing()
	unset_range()

/obj/structure/machinery/defenses/sentry/attackby(var/obj/item/O, var/mob/user)
	if(QDELETED(O) || QDELETED(user))
		return

	//Securing/Unsecuring
	if(HAS_TRAIT(O, TRAIT_TOOL_WRENCH))
		if(immobile)
			to_chat(user, SPAN_WARNING("[src] is completely welded in place. You can't move it without damaging it."))
			return

	if(!..())
		return

	// Rotation
	if(HAS_TRAIT(O, TRAIT_TOOL_SCREWDRIVER))
		if(immobile)
			to_chat(user, SPAN_WARNING("[src] is completely welded in place. You can't move it without damaging it."))
			return

		if(turned_on)
			to_chat(user, SPAN_WARNING("[src] is currently active. The motors will prevent you from rotating it safely."))
			return

		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] rotates [src]."), SPAN_NOTICE("You rotate [src]."))
		setDir(turn(dir, -90))
		return

	if(istype(O, ammo))
		var/obj/item/ammo_magazine/M = O
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI) || user.action_busy)
			return

		if(ammo.current_rounds)
			to_chat(user, SPAN_WARNING("You only know how to swap [M.name] when it's empty."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins swapping a new [O.name] into [src]."),
		SPAN_NOTICE("You begin swapping a new [O.name] into [src]."))
		if(!do_after(user, 70 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			return

		playsound(loc, 'sound/weapons/unload.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] swaps a new [O.name] into [src]."),
		SPAN_NOTICE("You swap a new [O.name] into [src]."))

		ammo = O
		user.drop_held_item(O)
		O.forceMove(src)
		update_icon()
		return

	if(O.force)
		update_health(O.force/2)
	return ..()

/obj/structure/machinery/defenses/sentry/destroyed_action()
	visible_message("[icon2html(src, viewers(src))] [SPAN_WARNING("The [name] starts spitting out sparks and smoke!")]")
	playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
	for(var/i = 1 to 6)
		setDir(pick(NORTH, EAST, SOUTH, WEST))
		sleep(2)

	cell_explosion(loc, 10, 10, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("sentry explosion", owner_mob))
	if(!QDELETED(src))
		qdel(src)

/obj/structure/machinery/defenses/sentry/damaged_action(var/damage)
	if(prob(10))
		spark_system.start()
	..()


/obj/structure/machinery/defenses/sentry/proc/fire(var/atom/A)
	if(!(world.time-last_fired >= fire_delay) || !turned_on || !ammo || QDELETED(target))
		return

	if(world.time-last_fired >= 300) //if we haven't fired for a while, beep first
		playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
		sleep(3)

	if(ammo && ammo.current_rounds <= 0)
		to_chat(usr, SPAN_WARNING("[name] does not have any ammo."))
		return

	last_fired = world.time

	if(QDELETED(owner_mob))
		owner_mob = src

	if(omni_directional)
		setDir(get_dir(src, A))

	actual_fire(A)

	if(targets.len)
		addtimer(CALLBACK(src, .proc/get_target), fire_delay)

/obj/structure/machinery/defenses/sentry/proc/actual_fire(var/atom/A)
	var/obj/item/projectile/P = new(src, create_cause_data(initial(name), owner_mob, src))
	P.generate_bullet(new ammo.default_ammo)
	P.damage *= damage_mult
	P.accuracy *= accuracy_mult
	GIVE_BULLET_TRAIT(P, /datum/element/bullet_trait_iff, faction_group)
	P.fire_at(A, src, owner_mob, P.ammo.max_range, P.ammo.shell_speed, null, FALSE)
	muzzle_flash(Get_Angle(get_turf(src), A))
	ammo.current_rounds--
	track_shot()
	if(ammo.current_rounds == 0)
		handle_empty()

/obj/structure/machinery/defenses/sentry/proc/handle_empty()
	visible_message("[icon2html(src, viewers(src))] <span class='warning'>The [name] beeps steadily and its ammo light blinks red.</span>")
	playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)
	update_icon()

//Mostly taken from gun code.
/obj/structure/machinery/defenses/sentry/proc/muzzle_flash(var/angle)
	if(isnull(angle))
		return

	SetLuminosity(SENTRY_MUZZLELUM)
	addtimer(CALLBACK(src, /atom.proc/SetLuminosity, -SENTRY_MUZZLELUM), 10)

	var/image_layer = layer + 0.1
	var/offset = 13

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',src,"muzzle_flash",image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(0, offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(src, 3)

/obj/structure/machinery/defenses/sentry/proc/get_target(var/atom/movable/new_target)
	if(!islist(targets))
		return
	if(!targets.Find(new_target))
		targets.Add(new_target)

	if(!targets.len)
		return

	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()

	for(var/atom/movable/A in targets) // orange allows sentry to fire through gas and darkness
		if(isliving(A))
			var/mob/living/M = A
			if(M.stat & DEAD)
				if(A == target)
					target = null
				targets.Remove(A)
				continue

			if(M.get_target_lock(faction_group) || M.invisibility)
				if(M == target)
					target = null
				targets.Remove(M)
				continue

		else if(!(A.type in other_targets))
			if(A == target)
				target = null
			targets.Remove(A)
			continue

		if(!omni_directional)
			var/opp
			var/adj
			switch(dir)
				if(NORTH)
					opp = x-A.x
					adj = A.y-y
				if(SOUTH)
					opp = x-A.x
					adj = y-A.y
				if(EAST)
					opp = y-A.y
					adj = A.x-x
				if(WEST)
					opp = y-A.y
					adj = x-A.x

			var/r = 9999
			if(adj != 0)
				r = abs(opp/adj)
			var/angledegree = arcsin(r/sqrt(1+(r*r)))
			if(adj < 0 || (angledegree*2) > SENTRY_FIREANGLE)
				if(A == target)
					target = null
				targets.Remove(A)
				continue

		var/list/turf/path = getline2(src, A, include_from_atom = FALSE)
		if(!path.len || get_dist(src, A) > sentry_range)
			if(A == target)
				target = null
			targets.Remove(A)
			continue

		var/blocked = FALSE
		for(var/turf/T in path)
			if(T.density || T.opacity)
				blocked = TRUE
				break

			for(var/obj/structure/S in T)
				if(S.opacity)
					blocked = TRUE
					break

			for(var/obj/vehicle/multitile/V in T)
				blocked = TRUE
				break

			for(var/obj/effect/particle_effect/smoke/S in T)
				blocked = TRUE
				break

		if(!omni_directional)
			var/turf/F = get_step(src, src.dir)
			if(F.density || F.opacity)
				blocked = TRUE

			for(var/obj/structure/S in F)
				if(F.opacity)
					blocked = TRUE
					break

			for(var/obj/vehicle/multitile/V in F)
				blocked = TRUE
				break

		if(blocked)
			if(A == target)
				target = null
			targets.Remove(A)
			continue

		if(isliving(A))
			var/mob/living/M = A
			if(M.stat & UNCONSCIOUS)
				unconscious_targets += M
			else
				conscious_targets += M

	if(conscious_targets.len)
		target = pick(conscious_targets)
	else if(unconscious_targets.len)
		target = pick(unconscious_targets)

	if(!target) //No targets, don't bother firing
		return

	fire(target)

/obj/structure/machinery/defenses/sentry/premade
	name = "UA-577 Gauss Turret"
	immobile = TRUE
	turned_on = TRUE
	icon_state = "premade" //for the map editor only
	faction_group = FACTION_LIST_MARINE
	static = TRUE

/obj/structure/machinery/defenses/sentry/premade/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It seems this one's bolts have been securely welded into the floor, and the access panel locked. You can't interact with it.")

/obj/structure/machinery/defenses/sentry/premade/attackby(var/obj/item/O, var/mob/user)
	return

/obj/structure/machinery/defenses/sentry/premade/power_on()
	return

/obj/structure/machinery/defenses/sentry/premade/power_off()
	return

obj/structure/machinery/defenses/sentry/premade/damaged_action()
	return

/obj/structure/machinery/defenses/sentry/premade/dumb
	name = "Modified UA-577 Gauss Turret"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an M30 Autocannon and a high-capacity drum magazine. This one's IFF system has been disabled, and it will open fire on any targets within range."
	faction_group = null
	ammo = new /obj/item/ammo_magazine/sentry/premade/dumb

//the turret inside a static sentry deployment system
/obj/structure/machinery/defenses/sentry/premade/deployable
	name = "UA-633 Static Gauss Turret"
	desc = "A fully-automated defence turret with mid-range targeting capabilities. Armed with a modified M32-S Autocannon and an internal belt feed."
	density = TRUE
	faction_group = FACTION_LIST_MARINE
	fire_delay = 1
	ammo = new /obj/item/ammo_magazine/sentry/premade
	var/obj/structure/machinery/sentry_holder/deployment_system

/obj/structure/machinery/defenses/sentry/premade/deployable/Destroy()
	if(deployment_system)
		deployment_system.deployed_turret = null
		deployment_system = null
	. = ..()

/obj/structure/machinery/defenses/sentry/premade/deployable/colony
	faction_group = list(FACTION_MARINE, FACTION_COLONIST)

//the turret inside the shuttle sentry deployment system
/obj/structure/machinery/defenses/sentry/premade/dropship
	density = TRUE
	faction_group = FACTION_LIST_MARINE
	omni_directional = TRUE
	var/obj/structure/dropship_equipment/sentry_holder/deployment_system

/obj/structure/machinery/defenses/sentry/premade/dropship/Destroy()
	if(deployment_system)
		deployment_system.deployed_turret = null
		deployment_system = null
	. = ..()

#define SENTRY_SNIPER_RANGE 20
/obj/structure/machinery/defenses/sentry/dmr
	name = "UA 725-D Sniper Sentry"
	desc = "A fully-automated defence turret with long-range targeting capabilities. Armed with a modified M32-S Autocannon and an internal belt feed."
	defense_type = "DMR"
	health = 150
	health_max = 150
	fire_delay = 2 SECONDS
	ammo = new /obj/item/ammo_magazine/sentry
	sentry_range = SENTRY_SNIPER_RANGE
	accuracy_mult = 5
	damage_mult = 2
	handheld_type = /obj/item/defenses/handheld/sentry/dmr

/obj/structure/machinery/defenses/sentry/dmr/set_range()
	switch(dir)
		if(EAST)
			range_bounds = RECT(x + (SENTRY_SNIPER_RANGE/2), y, SENTRY_SNIPER_RANGE, SENTRY_SNIPER_RANGE)
		if(WEST)
			range_bounds = RECT(x - (SENTRY_SNIPER_RANGE/2), y, SENTRY_SNIPER_RANGE, SENTRY_SNIPER_RANGE)
		if(NORTH)
			range_bounds = RECT(x, y + (SENTRY_SNIPER_RANGE/2), SENTRY_SNIPER_RANGE, SENTRY_SNIPER_RANGE)
		if(SOUTH)
			range_bounds = RECT(x, y - (SENTRY_SNIPER_RANGE/2), SENTRY_SNIPER_RANGE, SENTRY_SNIPER_RANGE)

#undef SENTRY_SNIPER_RANGE
/obj/structure/machinery/defenses/sentry/shotgun
	name = "UA 12-G Shotgun Sentry"
	defense_type = "Shotgun"
	health = 250
	health_max = 250
	fire_delay = 2 SECONDS
	sentry_range = 3
	ammo = new /obj/item/ammo_magazine/sentry/shotgun

	accuracy_mult = 2 // Misses a lot since shotgun ammo has low accuracy, this should ensure a lot of shots actually hit.
	handheld_type = /obj/item/defenses/handheld/sentry/shotgun
	disassemble_time = 1.5 SECONDS

/obj/structure/machinery/defenses/sentry/shotgun/attack_alien(mob/living/carbon/Xenomorph/M)
	. = ..()
	if(. == XENO_ATTACK_ACTION && turned_on)
		M.visible_message(SPAN_DANGER("The sentry's steel tusks cut into [M]!"),
		SPAN_DANGER("The sentry's steel tusks cut into you!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		M.apply_damage(20)

/obj/structure/machinery/defenses/sentry/shotgun/hitby(atom/movable/AM)
	if(AM.throwing && turned_on)
		if(ismob(AM))
			var/mob/living/L = AM
			L.apply_damage(20)
			playsound(L, "bonk", 75, FALSE)
			L.visible_message(SPAN_DANGER("The sentry's steel tusks impale [L]!"),
			SPAN_DANGER("The sentry's steel tusks impale you!"))
			if(L.mob_size <= MOB_SIZE_XENO_SMALL)
				L.KnockDown(1)

/obj/structure/machinery/defenses/sentry/mini
	name = "UA 512-M mini sentry"
	defense_type = "Mini"
	fire_delay = 0.15 SECONDS
	health = 150
	health_max = 150
	damage_mult = 0.4
	density = FALSE
	disassemble_time = 0.75 SECONDS
	handheld_type = /obj/item/defenses/handheld/sentry/mini
	composite_icon = FALSE

/obj/structure/machinery/defenses/sentry/launchable
	name = "\improper UA 571-O sentry post"
	desc = "A deployable, omni-directional automated turret with AI targeting capabilities. Armed with an M30 Autocannon and a 1500-round drum magazine.  Due to the deployment method it is incapable of being moved."
	ammo = new /obj/item/ammo_magazine/sentry/dropped
	faction_group = FACTION_LIST_MARINE
	omni_directional = TRUE
	immobile = TRUE
	static = TRUE
	var/obj/structure/machinery/camera/cas/linked_cam
	var/static/sentry_count = 1
	var/sentry_number

/obj/structure/machinery/defenses/sentry/launchable/Initialize()
	. = ..()
	sentry_number = sentry_count
	sentry_count++

/obj/structure/machinery/defenses/sentry/launchable/Destroy()
	QDEL_NULL(linked_cam)
	. = ..()

/obj/structure/machinery/defenses/sentry/launchable/power_on_action()
	. = ..()
	linked_cam = new(loc, "[name] [sentry_number] at [get_area(src)] ([obfuscate_x(x)], [obfuscate_y(y)])")

/obj/structure/machinery/defenses/sentry/launchable/power_off_action()
	. = ..()
	QDEL_NULL(linked_cam)


/obj/structure/machinery/defenses/sentry/launchable/attack_hand_checks(var/mob/user)
	return TRUE // We want to be able to turn it on / off while keeping it immobile

/obj/structure/machinery/defenses/sentry/launchable/handle_empty()
	visible_message("[icon2html(src, viewers(src))] <span class='warning'>The [name] beeps steadily and its ammo light blinks red. It rapidly deconstructs itself!</span>")
	playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)
	new /obj/item/stack/sheet/metal/medium_stack(loc)
	new /obj/item/stack/sheet/plasteel/medium_stack(loc)
	qdel(src)

#undef SENTRY_FIREANGLE
#undef SENTRY_RANGE
#undef SENTRY_MUZZLELUM
