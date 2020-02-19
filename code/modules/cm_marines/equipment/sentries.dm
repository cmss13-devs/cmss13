//Deployable turrets. They can be either automated, manually fired, or installed with a pAI.
//They are built in stages, and only engineers have access to them.

/obj/effect/turret_trigger
	name = "turret trigger"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	mouse_opacity = 0
	invisibility = INVISIBILITY_MAXIMUM
	var/obj/structure/machinery/marine_turret/linked_turret

/obj/effect/turret_trigger/New(loc, var/obj/structure/machinery/marine_turret/source_turret)
	..()
	linked_turret = source_turret

/obj/effect/turret_trigger/Crossed(atom/movable/A)
	if(!linked_turret) //something went very wrong
		qdel(src)
	linked_turret.get_target(A)

/obj/item/ammo_magazine/sentry
	name = "M30 ammo drum (10x28mm Caseless)"
	desc = "An ammo drum of 500 10x28mm caseless rounds for the UA 571-C Sentry Gun. Just feed it into the sentry gun's ammo port when its ammo is depleted."
	w_class = SIZE_MEDIUM
	icon_state = "ua571c"
	flags_magazine = NO_FLAGS //can't be refilled or emptied by hand
	caliber = "10x28mm"
	max_rounds = 750
	default_ammo = /datum/ammo/bullet/turret
	gun_type = null

/obj/item/storage/box/sentry
	name = "\improper UA-571-C sentry case"
	desc = "A large case containing all you need to set up an automated sentry, minus the tools."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "kit_case"
	w_class = SIZE_HUGE
	storage_slots = 6
	can_hold = list() //Nada. Once you take the stuff out it doesn't fit back in.

/obj/item/storage/box/sentry/update_icon()
	if(overlays.len)
		overlays.Cut()
	if(contents.len)
		icon_state = "kit_case"
		overlays += image(icon, "sentry")
	else
		icon_state = "kit_case_e"

/obj/item/storage/box/sentry/Initialize()
	..()
	var/obj/item/stack/sheet/plasteel/plasteel_stack = new(src)
	plasteel_stack.amount = 20
	var/obj/item/stack/sheet/metal/metal_stack = new(src)
	metal_stack.amount = 10
	new /obj/item/device/turret_top(src)
	new /obj/item/device/turret_sensor(src)
	new /obj/item/cell/high(src)
	new /obj/item/ammo_magazine/sentry(src)
	update_icon()

/obj/structure/machinery/marine_turret_frame
	name = "\improper UA 571-C turret frame"
	desc = "An unfinished turret frame. It requires wrenching, cable coil, a turret piece, a sensor, and metal plating."
	icon = 'icons/obj/structures/turret.dmi'
	icon_state = "sentry_base"
	anchored = 0
	density = 1
	layer = ABOVE_OBJ_LAYER
	var/has_cable = 0
	var/has_top = 0
	var/has_plates = 0
	var/is_welded = 0
	var/has_sensor = 0
	health = 100


/obj/structure/machinery/marine_turret_frame/update_health(damage)
	health -= damage
	if(health <= 0)
		if(has_cable)
			new /obj/item/stack/cable_coil(loc, 10)
		if(has_top)
			new /obj/item/device/turret_top(loc)
		if(has_sensor)
			new /obj/item/device/turret_sensor(loc)
		qdel(src)


/obj/structure/machinery/marine_turret_frame/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) return //Larvae can't do shit
	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"),
	SPAN_DANGER("You slash [src]!"))
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))

/obj/structure/machinery/marine_turret_frame/examine(mob/user as mob)
	..()
	if(!anchored)
		to_chat(user, SPAN_INFO("It must be <B>wrenched</B> to the floor."))
	if(!has_cable)
		to_chat(user, SPAN_INFO("It requires <B>cable coil</B> for wiring."))
	if(!has_top)
		to_chat(user, SPAN_INFO("The <B>main turret</B> is not installed."))
	if(!has_plates)
		to_chat(user, SPAN_INFO("It does not have <B>metal</B> plating installed."))
	if(!is_welded)
		to_chat(user, SPAN_INFO("It requires the metal plating to be <B>welded</B>."))
	if(!has_sensor)
		to_chat(user, SPAN_INFO("It does not have a <b>turret sensor</B> installed."))

/obj/structure/machinery/marine_turret_frame/attackby(var/obj/item/O as obj, mob/user as mob)
	if(!ishuman(user))
		return
	//Rotate/Secure Sentry
	if(istype(O,/obj/item/tool/wrench))
		if(anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] rotates [src]."),
			SPAN_NOTICE("You rotate [src]."))
			switch(dir)
				if(SOUTH)
					dir = WEST
				if(NORTH)
					dir = EAST
				if(EAST)
					dir = SOUTH
				if(WEST)
					dir = NORTH
		else
			if(locate(/obj/structure/machinery/marine_turret) in loc)
				to_chat(user, SPAN_WARNING("There already is a turret in this position."))
				return

			user.visible_message(SPAN_NOTICE("[user] begins securing [src] to the ground."),
			SPAN_NOTICE("You begin securing [src] to the ground."))
			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] secures [src] to the ground."),
				SPAN_NOTICE("You secure [src] to the ground."))
				anchored = 1
		return


	//Install wiring
	if(istype(O,/obj/item/stack/cable_coil))
		if(!anchored)
			to_chat(user, SPAN_WARNING("You must secure [src] to the ground first."))
			return

		var/obj/item/stack/cable_coil/CC = O
		if(has_cable)
			to_chat(user, SPAN_WARNING("[src]'s wiring is already installed."))
			return
		user.visible_message(SPAN_NOTICE("[user] begins installing [src]'s wiring."),
		SPAN_NOTICE("You begin installing [src]'s wiring."))
		if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			if(CC.use(10))
				has_cable = 1
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] installs [src]'s wiring."),
				SPAN_NOTICE("You install [src]'s wiring."))
				icon_state = "sentry_base_wired"
				return
			else
				to_chat(user, SPAN_WARNING("You will need at least ten cable lengths to finish [src]'s wiring."))

	//Install turret head
	if(istype(O, /obj/item/device/turret_top))
		if(!has_cable)
			to_chat(user, SPAN_WARNING("You must install [src]'s wiring first."))
			return
		if(has_top)
			to_chat(user, SPAN_WARNING("[src] already has a turret installed."))
			return
		user.visible_message(SPAN_NOTICE("[user] begins installing [O] on [src]."),
		SPAN_NOTICE("You begin installing [O] on [src]."))
		if(do_after(user, 60, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] installs [O] on [src]."),
			SPAN_NOTICE("You install [O] on [src]."))
			has_top = 1
			icon_state = "sentry_armorless"
			user.drop_held_item()
			qdel(O)
			return

	//Install plating
	if(istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		if(!has_top)
			to_chat(user, SPAN_WARNING("You must install [src]'s turret first."))
			return

		if(has_plates)
			to_chat(user, SPAN_WARNING("[src] already has plates installed."))
			return

		if(M.amount < 10)
			to_chat(user, SPAN_WARNING("[src]'s plating will require at least ten sheets of metal."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins installing [src]'s reinforced plating."),
		SPAN_NOTICE("You begin installing [src]'s reinforced plating."))
		if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			if(!M) return
			if(M.amount >= 10)
				has_plates = 1
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] installs [src]'s reinforced plating."),
				SPAN_NOTICE("You install [src]'s reinforced plating."))
				M.use(10)
				return
			else
				to_chat(user, SPAN_WARNING("[src]'s plating will require at least ten sheets of metal."))
				return

	//Weld plating
	if(istype(O, /obj/item/tool/weldingtool))
		if(!has_plates)
			to_chat(user, SPAN_WARNING("You must install [src]'s plating first."))
			return
		var/obj/item/tool/weldingtool/WT = O
		playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] begins welding [src]'s parts together."),
		SPAN_NOTICE("You begin welding [src]'s parts together."))
		if(do_after(user,60, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			if(!src || !WT || !WT.isOn()) return
			if(WT.remove_fuel(0, user))
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] welds [src]'s plating to the frame."),
				SPAN_NOTICE("You weld [src]'s plating to the frame."))
				is_welded = 1
				icon_state = "sentry_sensor_none"
				return
			else
				to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
				return

	//Install sensor
	if(istype(O, /obj/item/device/turret_sensor))
		if(!is_welded)
			to_chat(user, SPAN_WARNING("You must weld the plating on the [src] first!"))
			return

		if(has_sensor)
			to_chat(user, SPAN_WARNING("[src] already has a sensor installed."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins installing [O] on [src]."),
		SPAN_NOTICE("You begin installing [O] on [src]."))
		if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			has_sensor = 1
			playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] installs [O] on [src]."),
			SPAN_NOTICE("You install [O] on [src]."))
			icon_state = "sentry_off"
			user.drop_held_item()
			qdel(O)

			var/obj/structure/machinery/marine_turret/T = new(loc)  //Bing! Create a new turret.
			T.owner_mob = user
			T.dir = dir
			qdel(src)
			return

	return ..() //Just do normal stuff.

/obj/item/device/turret_sensor
	name = "\improper UA 571-C turret sensor"
	desc = "An AI control and locking sensor for an automated sentry. This must be installed on the final product for it to work."
	unacidable = TRUE
	w_class = SIZE_TINY
	icon = 'icons/obj/structures/turret.dmi'
	icon_state = "sentry_sensor"

/obj/item/device/turret_top
	name = "\improper UA 571-C turret"
	desc = "The turret part of an automated sentry turret. This must be installed on a turret frame and welded together for it to do anything."
	unacidable = TRUE
	w_class = SIZE_HUGE
	icon = 'icons/obj/structures/turret.dmi'
	icon_state = "sentry_head"

#define SENTRY_FUNCTIONAL 		0
#define SENTRY_KNOCKED_DOWN		1
#define SENTRY_DESTROYED	 	2

/obj/structure/machinery/marine_turret
	name = "\improper UA 571-C sentry gun"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an M30 Autocannon and a 500-round drum magazine."
	icon = 'icons/obj/structures/turret.dmi'
	icon_state = "sentry_off"
	anchored = 1
	unacidable = TRUE
	density = 1
	layer = ABOVE_MOB_LAYER //So you can't hide it under corpses
	use_power = 0
	flags_atom = RELAY_CLICK
	req_one_access = list(ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_ENGPREP, ACCESS_MARINE_LEADER)
	var/list/atom/movable/targets = list() // Lists of current potential targets
	var/list/obj/effect/turret_trigger/turret_triggers = list()
	var/iff_signal = ACCESS_IFF_MARINE // Either a single IFF signal or a list of signals
	var/rounds = 750
	var/rounds_max = 750
	var/locked = 0
	var/atom/movable/target = null
	var/manual_override = 0
	var/on = FALSE
	health = 200
	var/health_max = 200
	stat = SENTRY_FUNCTIONAL
	var/datum/effect_system/spark_spread/spark_system //The spark system, used for generating... sparks?
	var/obj/item/cell/high/cell = null
	var/obj/structure/machinery/camera/camera = null
	var/fire_delay = 1.5
	var/last_sound = 0
	var/last_fired = 0
	var/range = 8
	var/muzzle_flash_lum = 3 //muzzle flash brightness
	var/obj/item/turret_laptop/laptop = null
	var/immobile = 0 //Used for prebuilt ones.
	var/datum/ammo/bullet/turret/ammo = /datum/ammo/bullet/turret
	var/obj/item/projectile/in_chamber = null
	var/angle = 1
	var/list/angle_list = list(180,135,90,60,30)
	var/list/other_targets = list() //List of special target types to shoot at, if needed.
	var/owner_mob

/obj/structure/machinery/marine_turret/New()
	spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	cell = new (src)
	camera = new (src)
	camera.network = list("military")
	camera.c_tag = "[name] ([rand(0, 1000)])"
	ammo = ammo_list[ammo]
	stat = SENTRY_FUNCTIONAL
	if(on)
		create_turret_triggers()

/obj/structure/machinery/marine_turret/power_change()
	return

/obj/structure/machinery/marine_turret/Dispose() //Clear these for safety's sake.
	if(operator)
		operator.unset_interaction()
		operator = null
	if(camera)
		qdel(camera)
		camera = null
	if(cell)
		qdel(cell)
		cell = null
	target = null
	targets = null
	delete_turret_triggers()
	. = ..()

/obj/structure/machinery/marine_turret/attack_hand(mob/user as mob)
	if(isYautja(user))
		to_chat(user, SPAN_WARNING("You punch [src] but nothing happens."))
		return
	add_fingerprint(user)

	if(!cell || cell.charge <= 0)
		to_chat(user, SPAN_WARNING("You try to activate [src] but nothing happens. The cell must be empty."))
		return

	if(!anchored)
		to_chat(user, SPAN_WARNING("It must be anchored to the ground before you can activate it."))
		return

	if(immobile)
		to_chat(user, SPAN_WARNING("[src]'s panel is completely locked, you can't do anything."))
		return

	if(stat & SENTRY_KNOCKED_DOWN)
		user.visible_message(SPAN_NOTICE("[user] begins to set [src] upright."),
		SPAN_NOTICE("You begin to set [src] upright."))
		if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
			user.visible_message(SPAN_NOTICE("[user] sets [src] upright."),
			SPAN_NOTICE("You set [src] upright."))
			stat &= ~SENTRY_KNOCKED_DOWN
			on = TRUE
			update_icon()
			update_health()
		return

	if(locked)
		to_chat(user, SPAN_WARNING("[src]'s control panel is locked! Only a Squad Leader or Engineer can unlock it now."))
		return

	user.set_interaction(src)
	ui_interact(user)

	return

/obj/structure/machinery/marine_turret/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	var/list/data = list(
		"self_ref" = "\ref[src]",
		"name" = copytext(name, 2),
		"is_on" = on,
		"rounds" = rounds,
		"rounds_max" = rounds_max,
		"health" = health,
		"health_max" = health_max,
		"has_cell" = (cell ? 1 : 0),
		"cell_charge" = cell ? cell.charge : 0,
		"cell_maxcharge" = cell ? cell.maxcharge : 0,
		"dir" = dir,
		"manual_override" = manual_override,
		"angle" = angle_list[angle],
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cm_sentry.tmpl", "[name] UI", 625, 525)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/structure/machinery/marine_turret/Topic(href, href_list)
	if(usr.stat)
		return

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return

	if(get_dist(loc, user.loc) > 1 || user.is_mob_incapacitated())
		return

	user.set_interaction(src)
	switch(href_list["op"])
		if("angle")
			var/angle_selected = input(user, "Please select a FoF:", "Field of Fire", null) in angle_list
			angle = angle_list.Find(angle_selected)
			visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] The [name] beeps [angle+1] times, confirming the field of fire is set to [angle_selected] degrees."))

		if("power")
			target = null
			if(!on)
				user.visible_message(SPAN_NOTICE("[user] activates [src]."),
				SPAN_NOTICE("You activate [src]."))
				visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] The [name] hums to life and emits several beeps."))
				visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] The [name] buzzes in a monotone voice: 'Default systems initiated'."))
				create_turret_triggers()
				on = TRUE
				SetLuminosity(7)
				if(!camera)
					camera = new /obj/structure/machinery/camera(src)
					camera.network = list("military")
					camera.c_tag = name
				update_icon()
				get_target()
			else
				on = FALSE
				user.visible_message(SPAN_NOTICE("[user] deactivates [src]."),
				SPAN_NOTICE("You deactivate [src]."))
				visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] The [name] powers down and goes silent."))
				delete_turret_triggers()
				update_icon()
	attack_hand(user)

//Manual override turns off automatically once the user no longer interacts with the turret.
/obj/structure/machinery/marine_turret/on_unset_interaction(mob/user)
	..()
	if(manual_override && operator == user)
		operator = null
		manual_override = 0

/obj/structure/machinery/marine_turret/check_eye(mob/user)
	if(user.is_mob_incapacitated() || get_dist(user, src) > 1 || user.blinded || user.lying || !user.client)
		user.unset_interaction()

/obj/structure/machinery/marine_turret/attackby(var/obj/item/O as obj, mob/user as mob)
	if(!ishuman(user))
		return ..()

	if(isnull(O)) return

	//Panel access
	if(istype(O, /obj/item/card/id))
		if(allowed(user))
			locked = !locked
			user.visible_message(SPAN_NOTICE("[user] [locked ? "locks" : "unlocks"] [src]'s panel."),
			SPAN_NOTICE("You [locked ? "lock" : "unlock"] [src]'s panel."))
			if(locked)
				if(user.interactee == src)
					user.unset_interaction()
					close_browser(user, "turret")
			else
				if(user.interactee == src)
					attack_hand(user)
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return


	//Securing/Unsecuring
	if(iswrench(O))
		if(immobile)
			to_chat(user, SPAN_WARNING("[src] is completely welded in place. You can't move it without damaging it."))
			return

		//Unsecure
		if(anchored)
			if(on)
				to_chat(user, SPAN_WARNING("[src] is currently active. The motors will prevent you from unanchoring it safely."))
				return

			user.visible_message(SPAN_NOTICE("[user] begins unanchoring [src] from the ground."),
			SPAN_NOTICE("You begin unanchoring [src] from the ground."))

			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				user.visible_message(SPAN_NOTICE("[user] unanchors [src] from the ground."),
				SPAN_NOTICE("You unanchor [src] from the ground."))
				anchored = 0
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			return

		//Secure
		if(loc) //Just to be safe.
			user.visible_message(SPAN_NOTICE("[user] begins securing [src] to the ground."),
			SPAN_NOTICE("You begin securing [src] to the ground."))

			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				user.visible_message(SPAN_NOTICE("[user] secures [src] to the ground."),
				SPAN_NOTICE("You secure [src] to the ground."))
				anchored = 1
				playsound(loc, 'sound/items/Ratchet.ogg', 25, 1)
			return


	// Rotation
	if(isscrewdriver(O))

		if(immobile)
			to_chat(user, SPAN_WARNING("[src] is completely welded in place. You can't move it without damaging it."))
			return

		if(on)
			to_chat(user, SPAN_WARNING("[src] is currently active. The motors will prevent you from rotating it safely."))
			return

		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] rotates [src]."),
		SPAN_NOTICE("You rotate [src]."))
		if(dir == NORTH)
			dir = EAST
		else if(dir == EAST)
			dir = SOUTH
		else if(dir == SOUTH)
			dir = WEST
		else if(dir == WEST)
			dir = NORTH
		return


	if(istype(O, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = O
		if(health < 0 || stat)
			to_chat(user, SPAN_WARNING("[src]'s internal circuitry is ruined, there's no way you can salvage this on the go."))
			return

		if(health >= health_max)
			to_chat(user, SPAN_WARNING("[src] isn't in need of repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing [src]."),
			SPAN_NOTICE("You begin repairing [src]."))
			if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				user.visible_message(SPAN_NOTICE("[user] repairs [src]."),
				SPAN_NOTICE("You repair [src]."))
				update_health(-50)
				playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
		return

	if(iscrowbar(O))

		//Remove battery if possible
		if(anchored || immobile)
			if(cell)
				if(on)
					to_chat(user, SPAN_WARNING("Turn off [src] before attempting to remove the battery!"))
					return

				user.visible_message(SPAN_NOTICE("[user] begins removing [src]'s [cell.name]."),
				SPAN_NOTICE("You begin removing [src]'s [cell.name]."))

				if(do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
					user.visible_message(SPAN_NOTICE("[user] removes [src]'s [cell.name]."),
					SPAN_NOTICE("You remove [src]'s [cell.name]."))
					playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
					user.put_in_hands(cell)
					cell = null
					update_icon()
			return

	if(istype(O, /obj/item/cell))
		if(cell)
			to_chat(user, SPAN_WARNING("There is already \a [cell.name] installed in [src]! Remove it with a crowbar first!"))
			return

		user.visible_message(SPAN_NOTICE("[user] begins installing \a [O.name] into [src]."),
		SPAN_NOTICE("You begin installing \a [O.name] into [src]."))
		if(do_after(user, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			user.drop_inv_item_to_loc(O, src)
			user.visible_message(SPAN_NOTICE("[user] installs \a [O.name] into [src]."),
			SPAN_NOTICE("You install \a [O.name] into [src]."))
			cell = O
			update_icon()
		return


	if(istype(O, /obj/item/ammo_magazine/sentry))
		var/obj/item/ammo_magazine/sentry/M = O
		if(!skillcheck(user, SKILL_HEAVY_WEAPONS, SKILL_HEAVY_WEAPONS_TRAINED))
			if(rounds)
				to_chat(user, SPAN_WARNING("You only know how to swap the box magazine when it's empty."))
				return
			user.visible_message(SPAN_NOTICE("[user] begins swapping a new [O.name] into [src]."),
			SPAN_NOTICE("You begin swapping a new [O.name] into [src]."))
			if(user.action_busy) return
			if(!do_after(user, 70, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, src))
				return

		playsound(loc, 'sound/weapons/unload.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] swaps a new [O.name] into [src]."),
		SPAN_NOTICE("You swap a new [O.name] into [src]."))
		user.drop_held_item()
		update_icon()

		if(rounds)
			var/obj/item/ammo_magazine/sentry/S = new(user.loc)
			S.current_rounds = rounds
		rounds = min(rounds + M.current_rounds, rounds_max)
		qdel(O)
		return

	if(O.force)
		update_health(O.force/2)
	return ..()

/obj/structure/machinery/marine_turret/update_icon()
	if(stat & SENTRY_KNOCKED_DOWN && health > 0) //Knocked over
		icon_state = "sentry_fallen"
		return

	if(!cell)
		icon_state = "sentry_battery_none"
		return

	if(!rounds)
		icon_state = "sentry_ammo_none"
		return

	if(on)
		icon_state = "sentry_on"
	else
		icon_state = "sentry_off"

/obj/structure/machinery/marine_turret/update_health(var/damage) //Negative damage restores health.
	health -= damage
	if(health <= 0 && stat != 2)
		stat |= SENTRY_DESTROYED
		visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] The [name] starts spitting out sparks and smoke!"))
		playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
		for(var/i = 1 to 6)
			dir = pick(1, 2, 3, 4)
			sleep(2)
		spawn(10)
			if(src && loc)
				explosion(loc, -1, -1, 2, 0, , , , "sentry explosion")
				//new /obj/structure/machinery/marine_turret_frame(loc) // disabling this because why -spookydonut
				if(!disposed)
					qdel(src)
		return

	if(health > health_max)
		health = health_max
	if(!stat && damage > 0 && !immobile)
		if(prob(10))
			spark_system.start()
		if(prob(5 + round(damage/5)))
			visible_message(SPAN_DANGER("[htmlicon(src, viewers(src))] The [name] is knocked over!"))
			stat |= SENTRY_KNOCKED_DOWN
			on = FALSE
	if(stat & SENTRY_KNOCKED_DOWN)
		density = 0
	else
		density = initial(density)
	update_icon()

/obj/structure/machinery/marine_turret/proc/check_power(var/power)
	if (!cell)
		icon_state = "sentry_battery_none"
		return 0

	if(!on || stat)
		on = FALSE
		icon_state = "sentry_off"
		return 0

	if(cell.charge - power <= 0)
		cell.charge = 0
		visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] [src] emits a low power warning and immediately shuts down!"))
		playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)
		on = FALSE
		update_icon()
		SetLuminosity(0)
		icon_state = "sentry_battery_dead"
		return 0

	cell.charge -= power
	return 1

/obj/structure/machinery/marine_turret/emp_act(severity)
	if(cell)
		check_power(-(rand(100, 500)))
	if(on)
		if(prob(50))
			visible_message(SPAN_DANGER("[htmlicon(src, viewers(src))] [src] beeps and buzzes wildly, flashing odd symbols on its screen before shutting down!"))
			playsound(loc, 'sound/mecha/critdestrsyndi.ogg', 25, 1)
			for(var/i = 1 to 6)
				dir = pick(1, 2, 3, 4)
				sleep(2)
			on = FALSE
	if(health > 0)
		update_health(25)
	return

/obj/structure/machinery/marine_turret/ex_act(severity)
	if(health <= 0)
		return
	update_health(severity)

/obj/structure/machinery/marine_turret/attack_alien(mob/living/carbon/Xenomorph/M)
	if(isXenoLarva(M)) return //Larvae can't do shit
	M.visible_message(SPAN_DANGER("[M] has slashed [src]!"),
	SPAN_DANGER("You slash [src]!"))
	M.animation_attack_on(src)
	M.flick_attack_overlay(src, "slash")
	playsound(loc, "alien_claw_metal", 25)
	if(prob(10))
		if(!locate(/obj/effect/decal/cleanable/blood/oil) in loc)
			new /obj/effect/decal/cleanable/blood/oil(loc)
	update_health(rand(M.melee_damage_lower,M.melee_damage_upper))

/obj/structure/machinery/marine_turret/bullet_act(var/obj/item/projectile/Proj)
	bullet_ping(Proj)
	visible_message(SPAN_WARNING("[src] is hit by the [Proj.name]!"))
	var/ammo_flags = Proj.ammo.flags_ammo_behavior | Proj.projectile_override_flags
	if(ammo_flags & AMMO_XENO_ACID) //Fix for xenomorph spit doing baby damage.
		update_health(round(Proj.damage/3))
	else
		update_health(round(Proj.damage/10))
	return 1

//Update this to care about angle
/obj/structure/machinery/marine_turret/proc/get_turret_trigger_turfs()
	return orange(src, range)

/obj/structure/machinery/marine_turret/proc/create_turret_triggers()
	var/list/turf/trigger_spots = get_turret_trigger_turfs()
	for(var/turf/T in trigger_spots)
		for(var/atom/movable/A in T)
			if((isliving(A) && !isrobot(A)) || (A.type in other_targets))
				targets.Add(A)
		turret_triggers.Add(new /obj/effect/turret_trigger(T, src))

/obj/structure/machinery/marine_turret/proc/delete_turret_triggers()
	targets = list()
	for(var/obj/effect/turret_trigger/T in turret_triggers)
		turret_triggers.Remove(T)
		qdel(T)

/obj/structure/machinery/marine_turret/proc/load_into_chamber()
	if(in_chamber)
		return 1 //Already set!
	if(!on || !cell || rounds == 0 || stat)
		return 0

	in_chamber = new /obj/item/projectile(initial(name), null, loc) //New bullet!
	in_chamber.generate_bullet(ammo)
	return 1

/obj/structure/machinery/marine_turret/proc/fire_shot()
	if(isnull(target) || !ammo || !target || !on || !anchored || !check_power(2) || world.time - last_fired <= fire_delay)
		return

	var/turf/my_loc = get_turf(src)
	var/turf/targloc = get_turf(target)

	if(!istype(my_loc) || !istype(target))
		return

	if(!check_power(2)) return

	if(get_dir(src, targloc) & turn(dir, 180))
		return

	if(!load_into_chamber())
		return
	if(istype(in_chamber,/obj/item/projectile))
		var/initial_angle = Get_Angle(my_loc, targloc)
		var/final_angle = initial_angle
		var/total_scatter_angle = in_chamber.ammo.scatter

		if(total_scatter_angle > 0)
			final_angle += rand(-total_scatter_angle, total_scatter_angle)
			target = get_angle_target_turf(my_loc, final_angle, 30)

		in_chamber.ammo.accurate_range = 1 + angle

		//Setup projectile
		in_chamber.original = target
		in_chamber.dir = dir
		in_chamber.accuracy = round(in_chamber.accuracy * (config.base_hit_accuracy_mult - config.med_hit_accuracy_mult)) //This is gross but needed to make accuracy behave like the minigun's
		in_chamber.def_zone = pick("chest", "chest", "chest", "head")
		in_chamber.weapon_source_mob = owner_mob

		//Shoot at the thing
		if(last_sound > world.time + 6)
			playsound(loc, 'sound/weapons/gun_sentry.ogg', 75, 1)
			last_sound = world.time
		in_chamber.fire_at(target, src, null, ammo.max_range, ammo.shell_speed)
		muzzle_flash(final_angle)
		in_chamber = null
		rounds--
		if(rounds == 0)
			visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] The [name] beeps steadily and its ammo light blinks red."))
			playsound(loc, 'sound/weapons/smg_empty_alarm.ogg', 25, 1)

	update_icon()
	if(targets.len && !operator && !manual_override)
		var/shot_delay = fire_delay
		if(world.time - last_fired >= SECONDS_30) //if we haven't fired for a while, beep first
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			shot_delay = 3
		add_timer(CALLBACK(src, /obj/structure/machinery/marine_turret/proc/get_target), shot_delay)
	last_fired = world.time

//Mostly taken from gun code.
/obj/structure/machinery/marine_turret/proc/muzzle_flash(var/angle)
	if(isnull(angle)) return

	SetLuminosity(muzzle_flash_lum)
	spawn(10)
		SetLuminosity(-muzzle_flash_lum)

	var/image_layer = layer + 0.1
	var/offset = 13

	var/image/I = image('icons/obj/items/weapons/projectiles.dmi',src,"muzzle_flash",image_layer)
	var/matrix/rotate = matrix() //Change the flash angle.
	rotate.Translate(0, offset)
	rotate.Turn(angle)
	I.transform = rotate
	I.flick_overlay(src, 3)

/obj/structure/machinery/marine_turret/proc/get_target(var/atom/movable/new_target)
	if(!targets.Find(new_target))
		targets.Add(new_target)

	if(!targets.len || !anchored || !ammo || !on || operator || manual_override || world.time - last_fired <= fire_delay)
		return

	var/list/conscious_targets = list()
	var/list/unconscious_targets = list()
	var/list/inanimate_targets = list()

	for(var/atom/movable/A in targets)
		if(isliving(A))
			var/mob/living/M = A
			if(M.stat & DEAD)
				if(A == target)
					target = null
				targets.Remove(A)
				continue
		else if(!(A.type in other_targets))
			if(A == target)
				target = null
			targets.Remove(A)
			continue

		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.get_target_lock(iff_signal) || H.invisibility)
				if(A == target)
					target = null
				targets.Remove(H)
				continue

		if(angle <= 0)
			target = null
			return
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
		if(adj < 0)
			if(A == target)
				target = null
			targets.Remove(A)
			continue

		if((angledegree*2) > angle_list[angle])
			if(A == target)
				target = null
			targets.Remove(A)
			continue

		var/list/turf/path = getline2(src, A, include_from_atom = FALSE)

		if(!path.len || get_dist(src, A) > range)
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
			if(blocked)
				break
		if(blocked)
			if(A == target)
				target = null
			targets.Remove(A)
			continue
		if(!isliving(A))
			inanimate_targets += A
		else
			var/mob/living/M = A
			if(M.stat & UNCONSCIOUS)
				unconscious_targets += M
			else
				conscious_targets += M

	if(conscious_targets.len)
		target = pick(conscious_targets)
	else if(unconscious_targets.len)
		target = pick(unconscious_targets)
	else if(inanimate_targets.len)
		target = pick(inanimate_targets)
	
	if(!target) //No targets, don't bother firing
		return

	fire_shot()

//Direct replacement to new proc. Everything works.
/obj/structure/machinery/marine_turret/handle_click(mob/living/carbon/human/user, atom/A, params)
	if(!operator || !istype(user)) return HANDLE_CLICK_UNHANDLED
	if(operator != user) return HANDLE_CLICK_UNHANDLED
	if(istype(A, /obj/screen)) return HANDLE_CLICK_UNHANDLED
	if(!manual_override) return HANDLE_CLICK_UNHANDLED
	if(operator.interactee != src) return HANDLE_CLICK_UNHANDLED
	if(get_dist(user, src) > 1 || user.is_mob_incapacitated())
		user.visible_message(SPAN_NOTICE("[user] lets go of [src]"),
		SPAN_NOTICE("You let go of [src]"))
		visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] The [name] buzzes: AI targeting re-initialized."))
		user.unset_interaction()
		return HANDLE_CLICK_UNHANDLED
	if(user.get_active_hand() != null)
		to_chat(usr, SPAN_WARNING("You need a free hand to shoot [src]."))
		return HANDLE_CLICK_UNHANDLED

	target = A
	if(!istype(target))
		return HANDLE_CLICK_UNHANDLED

	if(target.z != z || target.z == 0 || z == 0 || isnull(operator.loc) || isnull(loc))
		return HANDLE_CLICK_UNHANDLED

	if(get_dist(target, loc) > 10)
		return HANDLE_CLICK_UNHANDLED

	var/list/modifiers = params2list(params) //Only single clicks.
	if(modifiers["middle"] || modifiers["shift"] || modifiers["alt"] || modifiers["ctrl"])
		return HANDLE_CLICK_PASS_THRU

	var/dx = target.x - x
	var/dy = target.y - y //Calculate which way we are relative to them. Should be 90 degree cone..
	var/direct

	if(abs(dx) < abs(dy))
		if(dy > 0)	direct = NORTH
		else		direct = SOUTH
	else
		if(dx > 0)	direct = EAST
		else		direct = WEST

	if(direct == dir && target.loc != loc && target.loc != operator.loc)
		fire_shot()
		return HANDLE_CLICK_HANDLED

	return HANDLE_CLICK_UNHANDLED
/*
/obj/item/turret_laptop
	name = "UA 571-C Turret Control Laptop"
	desc = "A small device used for remotely controlling sentry turrets."
	w_class = SIZE_LARGE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "turret_off"
	unslashable = TRUE
	unacidable = TRUE
	var/linked_turret = null
	var/on = 0
	var/mob/living/carbon/human/user = null
	var/obj/structure/machinery/camera/current = null

	check_eye(var/mob/user as mob)
		if (user.z == 0 || user.stat || ((get_dist(user, src) > 1 || user.blinded) && !issilicon(user))) //user can't see - not sure why canmove is here.
			return null
		if(!linked_turret || isnull(linked_turret.camera))
			return null
		user.reset_view(linked_turret.camera)
		return 1

	attack_self(mob/living/user as mob)
		if(!linked_turret)
*/
/obj/structure/machinery/marine_turret/premade
	name = "UA-577 Gauss Turret"
	immobile = 1
	on = TRUE
	rounds = 750
	rounds_max = 750
	icon_state = "sentry_on"

/obj/structure/machinery/marine_turret/premade/New()
	..()
	var/obj/item/cell/super/H = new(src) //Better cells in these ones.
	cell = H

/obj/structure/machinery/marine_turret/premade/dumb
	name = "Modified UA-577 Gauss Turret"
	desc = "A deployable, semi-automated turret with AI targeting capabilities. Armed with an M30 Autocannon and a high-capacity drum magazine. This one's IFF system has been disabled, and it will open fire on any targets within range."
	iff_signal = 0
	rounds = 1000000
	ammo = /datum/ammo/bullet/turret/dumb

/obj/structure/machinery/marine_turret/premade/dumb/attack_hand(mob/user as mob)
	if(isYautja(user))
		to_chat(user, SPAN_WARNING("You punch [src] but nothing happens."))
		return
	add_fingerprint(user)

	if(!cell || cell.charge <= 0)
		to_chat(user, SPAN_WARNING("You try to activate [src] but nothing happens. The cell must be empty."))
		return

	if(!anchored)
		to_chat(user, SPAN_WARNING("It must be anchored to the ground before you can activate it."))
		return

	target = null
	if(!on)
		to_chat(user, "You turn on the [src].")
		visible_message(SPAN_NOTICE("[src] hums to life and emits several beeps."))
		visible_message("[htmlicon(src, viewers(src))] [src] buzzes in a monotone: 'Default systems initiated.'")
		on = TRUE
		SetLuminosity(7)
		if(!camera)
			camera = new /obj/structure/machinery/camera(src)
			camera.network = list("military")
			camera.c_tag = name
		update_icon()
		get_target()
	else
		on = FALSE
		user.visible_message(SPAN_NOTICE("[user] deactivates [src]."),
		SPAN_NOTICE("You deactivate [src]."))
		visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] The [name] powers down and goes silent."))
		update_icon()

//the turret inside a static sentry deployment system
/obj/structure/machinery/marine_turret/premade/deployable
	name = "UA-633 Static Gauss Turret"
	desc = "An fully-automated defence turret with mid-range targeting capabilities. Armed with a modified M32-S Autocannon and an internal belt feed."
	density = 1
	angle = -1
	rounds = 1000000
	iff_signal = ACCESS_IFF_MARINE
	locked = 1
	fire_delay = 1
	range = 10
	muzzle_flash_lum = 4 //muzzle flash brightness
	use_power = 1
	var/obj/structure/machinery/sentry_holder/deployment_system

//the turret inside a static sentry deployment system
/obj/structure/machinery/marine_turret/premade/deployable/colony
	iff_signal = list(ACCESS_IFF_MARINE, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/marine_turret/premade/dropship/Dispose()
	if(deployment_system)
		deployment_system.deployed_turret = null
		deployment_system = null
	. = ..()

//the turret inside the shuttle sentry deployment system
/obj/structure/machinery/marine_turret/premade/dropship
	density = 1
	angle = -1
	var/obj/structure/dropship_equipment/sentry_holder/deployment_system

/obj/structure/machinery/marine_turret/premade/dropship/Dispose()
	if(deployment_system)
		deployment_system.deployed_turret = null
		deployment_system = null
	. = ..()

#undef SENTRY_FUNCTIONAL
#undef SENTRY_KNOCKED_DOWN
#undef SENTRY_DESTROYED

/obj/structure/machinery/sentry_holder
	name = "sentry deployment system"
	desc = "A box that deploys a sentry turret."
	density = 0
	anchored = 1
	unslashable = TRUE
	unacidable = TRUE
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "sentry_system_installed"
	active_power_usage = 5000
	idle_power_usage = 1000
	power_channel = 1
	use_power = 1
	machine_processing = 1
	var/deployment_cooldown
	var/turret_path = /obj/structure/machinery/marine_turret/premade/deployable // Path of the turret used
	var/obj/structure/machinery/marine_turret/premade/deployable/deployed_turret
	var/ox = 0
	var/oy = 0
	var/ind = FALSE

/obj/structure/machinery/sentry_holder/initialize()
	if(!deployed_turret)
		deployed_turret = new turret_path(src)
		deployed_turret.deployment_system = src
		ox = pixel_x
		oy = pixel_y
	..()

/obj/structure/machinery/sentry_holder/New()
	if(!deployed_turret)
		deployed_turret = new turret_path(src)
		deployed_turret.deployment_system = src
		ox = pixel_x
		oy = pixel_y
	..()

/obj/structure/machinery/sentry_holder/examine(mob/user)
	..()
	if(!deployed_turret)
		to_chat(user, "Its offline.")

/obj/structure/machinery/sentry_holder/attack_hand(mob/user)
	if(deployed_turret)
		if(deployment_cooldown > world.time)
			to_chat(user, SPAN_WARNING("[src] is busy."))
			return //prevents spamming deployment/undeployment
		if(deployed_turret.loc == src) //not deployed
			if(stat & NOPOWER)
				to_chat(user, SPAN_WARNING("[src] is non-functional."))
			else
				to_chat(user, SPAN_NOTICE("You deploy [src]."))
				deploy_sentry()
		else
			to_chat(user, SPAN_NOTICE("You retract [src]."))
			undeploy_sentry()
	else
		to_chat(user, SPAN_WARNING("[src] is unresponsive."))

/obj/structure/machinery/sentry_holder/process()
	if(stat & NOPOWER)
		if(deployed_turret)
			undeploy_sentry()
			ind = FALSE
		else
			icon_state = "sentry_system_destroyed"
	else
		update_use_power(1)
		if(!ind)
			deploy_sentry()
			ind = TRUE

/obj/structure/machinery/sentry_holder/proc/deploy_sentry()
	if(deployed_turret)
		playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
		deployment_cooldown = world.time + 50
		deployed_turret.on = 1
		deployed_turret.loc = loc
		icon_state = "sentry_system_deployed"

		for(var/mob/M in deployed_turret.loc)
			if(deployed_turret.loc == loc)
				step( M, deployed_turret.dir )
			else
				step( M, get_dir(src,deployed_turret) )

		if(deployed_turret)
			deployed_turret.dir = dir
			deployed_turret.pixel_x = 0
			deployed_turret.pixel_y = 0

/obj/structure/machinery/sentry_holder/proc/undeploy_sentry()
	if(deployed_turret)
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		deployment_cooldown = world.time + 50
		deployed_turret.loc = src
		deployed_turret.on = 0
		pixel_x = ox
		pixel_y = oy
		icon_state = "sentry_system_installed"

/obj/structure/machinery/sentry_holder/colony
	desc = "A box that deploys a sentry turret that protects the residents of the area."
	turret_path = /obj/structure/machinery/marine_turret/premade/deployable/colony
