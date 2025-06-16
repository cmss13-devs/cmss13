#define STATE_UNDEPLOYED "undeployed"
#define STATE_ON "on"
#define STATE_OFF "off"

/obj/structure/machinery/weapons_platform
	name = "\improper UH-02 Systems Platform"
	desc = "Large weapons system platform designed to deploy multiple types of automated defense systems, such as the UH-46 Heavy Sentry Gun and the UH-99 Smart Rocket Launcher."
	icon = 'icons/obj/structures/machinery/fob_machinery/weapons_platform.dmi'
	icon_state = "platform_undeployed"
	density = TRUE
	anchored = FALSE
	pixel_x = -16
	pixel_y = -16
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	needs_power = FALSE
	var/state = STATE_UNDEPLOYED
	var/obj/structure/machinery/linked_weapon

/obj/structure/machinery/weapons_platform/Initialize(mapload, ...)
	. = ..()

	AddComponent(/datum/component/fob_defense, CALLBACK(src, PROC_REF(turn_on)), CALLBACK(src, PROC_REF(turn_off)))

/obj/structure/machinery/weapons_platform/proc/turn_off()
	if(state == STATE_ON)
		state = STATE_OFF
		update_icon()
		if(istype(linked_weapon, /obj/structure/machinery/rocket_launcher))
			linked_weapon?.icon_state = "rocket_launcher_off"

/obj/structure/machinery/weapons_platform/proc/turn_on()
	if(state == STATE_OFF)
		state = STATE_ON
		update_icon()
		if(istype(linked_weapon, /obj/structure/machinery/rocket_launcher))
			linked_weapon?.icon_state = "rocket_launcher"
		START_PROCESSING(SSobj, src)

/obj/rocket_animation_holder
	name = "rocket"
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "missile"
	layer = ABOVE_MOB_LAYER

/obj/rocket_animation_holder/Initialize(mapload, index)
	var/barrel = index % 4

	switch (barrel)
		if(0)
			pixel_x = 32
			pixel_y = 55
		if(1)
			pixel_x = 38
			pixel_y = 55
		if(2)
			pixel_x = 32
			pixel_y = 51
		if(3)
			pixel_x = 38
			pixel_y = 51

	. = ..()

/obj/structure/machinery/weapons_platform/process(delta_time)
	if(state != STATE_ON)
		STOP_PROCESSING(SSobj, src)
		return

	if(istype(linked_weapon, /obj/structure/machinery/rocket_launcher))
		if(!SSsensors.targets)
			return

		var/index = 0
		for(var/mob/living/carbon/xenomorph/target in SSsensors.targets)
			if(index >= 4)
				break

			index++
			if(target.get_target_lock(FACTION_LIST_MARINE))
				continue

			if(target.stat == DEAD || HAS_TRAIT(target, TRAIT_ABILITY_BURROWED) || target.is_ventcrawling)
				continue

			var/obj/rocket_animation_holder/holder = new(loc, index)
			animate(holder, pixel_y = 256, easing = CUBIC_EASING|EASE_IN, time = 3 SECONDS)
			var/image/lockon_icon = image(icon = 'icons/effects/Targeted.dmi', icon_state = "lockon_sensor")
			var/x_offset =  -target.pixel_x + target.base_pixel_x
			var/y_offset = (target.icon_size - world.icon_size) * 0.5 - target.pixel_y + target.base_pixel_y
			lockon_icon.pixel_x = x_offset
			lockon_icon.pixel_y = y_offset
			target.overlays += lockon_icon
			to_chat(target, SPAN_XENOHIGHDANGER("Something is wrong... You should turn back."))
			QDEL_IN(holder, 3 SECONDS)
			playsound(src, 'sound/weapons/gun_rocketlauncher.ogg', 40, TRUE, 10)
			addtimer(VARSET_LIST_REMOVE_CALLBACK(target.overlays, lockon_icon), 3 SECONDS)
			addtimer(CALLBACK(src, PROC_REF(fire_at), target), 3 SECONDS)
	else if (istype(linked_weapon, /obj/structure/machinery/sentry))
		var/obj/structure/machinery/sentry/weapon = linked_weapon
		var/list/mob/targets = SSquadtree.players_in_range(weapon.range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)

		for(var/mob/target in targets)
			if(ishuman(target))
				targets.Remove(target)
				continue

			if(isliving(target))
				var/mob/living/living_mob = target
				if(living_mob.stat & DEAD)
					targets.Remove(living_mob)
					continue

				if(living_mob.get_target_lock(FACTION_LIST_MARINE) || living_mob.invisibility || HAS_TRAIT(living_mob, TRAIT_ABILITY_BURROWED) || living_mob.is_ventcrawling)
					targets.Remove(living_mob)
					continue

			var/list/turf/path = get_line(src, target, include_start_atom = FALSE)
			if(!length(path))
				targets.Remove(target)
				continue

			var/blocked = FALSE
			for(var/turf/cur_turf in path)
				if(cur_turf.density || cur_turf.opacity)
					blocked = TRUE
					break

				for(var/obj/structure/cur_structure in cur_turf)
					if(cur_structure.opacity)
						blocked = TRUE
						break

				for(var/obj/vehicle/multitile/cur_vehicle in cur_turf)
					blocked = TRUE
					break

				for(var/obj/effect/particle_effect/smoke/smoke in cur_turf)
					blocked = TRUE
					break

			if(blocked)
				targets.Remove(target)
				continue

		if(!length(targets))
			return

		var/mob/target = pick(targets)

		if(!target)
			return

		for(var/index in 1 to 4)
			addtimer(CALLBACK(src, PROC_REF(fire_at), target), 0.2 SECONDS * index)

/obj/structure/machinery/weapons_platform/proc/fire_at(mob/living/carbon/xenomorph/target)
	if(istype(linked_weapon, /obj/structure/machinery/rocket_launcher))
		target.remove_filter("target_lock")
		if(!(target in SSsensors.targets))
			return

		if(target.stat == DEAD || HAS_TRAIT(target, TRAIT_ABILITY_BURROWED) || target.is_ventcrawling)
			return

		if(islesserdrone(target) || isfacehugger(target))
			playsound(get_turf(target), 'sound/effects/explosionfar.ogg', 25, 1, 7)
			target.gib()
		else
			new /obj/effect/warning/explosive(get_turf(target), 0.1 SECONDS)
			if(target.small_explosives_stun)
				cell_explosion(get_turf(target), 199, 199)
			else
				cell_explosion(get_turf(target), 350, 350)
	else
		if(get_dist(src, target) > 7)
			return

		var/obj/structure/machinery/sentry/linked_sentry = linked_weapon
		linked_weapon.dir = get_dir(src, target)
		update_icon()
		var/datum/ammo/ammo_datum = new linked_sentry.ammo_type()

		var/obj/projectile/proj = new(loc, create_cause_data(ammo_datum, src))
		proj.generate_bullet(ammo_datum)
		GIVE_BULLET_TRAIT(proj, /datum/element/bullet_trait_iff, FACTION_MARINE)
		proj.fire_at(target, src, src, proj.ammo.max_range, proj.ammo.shell_speed)

/obj/structure/machinery/weapons_platform/attackby(obj/item/attack_item, mob/user)
	if(istype(attack_item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = attack_item
		if(!clamp.loaded && state == STATE_UNDEPLOYED)
			clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
			return

	switch (state)
		if(STATE_UNDEPLOYED)
			if(!HAS_TRAIT(attack_item, TRAIT_TOOL_WRENCH))
				return

			var/area/current_area = get_area(src)
			if(!current_area.is_landing_zone)
				to_chat(user, SPAN_WARNING("[src] can only be deployed at the landing zone."))
				return

			to_chat(user, SPAN_INFO("You start deploying [src]."))
			if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
				to_chat(user, SPAN_WARNING("You were interrupted."))
				return

			to_chat(user, SPAN_INFO("You deploy [src]."))

			if(GLOB.transformer.is_active())
				state = STATE_ON
			else
				state = STATE_OFF
			anchored = TRUE
			bound_width = 64
			bound_height = 64
			pixel_x = 0
			pixel_y = 0
			update_icon()
		if(STATE_ON, STATE_OFF)
			if(linked_weapon)
				if(!istype(attack_item, /obj/item/powerloader_clamp))
					return

				var/obj/item/powerloader_clamp/clamp = attack_item

				if(clamp.loaded)
					return

				clamp.grab_object(user, linked_weapon, "ds_gear", 'sound/machines/hydraulics_1.ogg')
				linked_weapon = null
				STOP_PROCESSING(SSobj, src)
				update_icon()
			else
				if(HAS_TRAIT(attack_item, TRAIT_TOOL_WRENCH))
					to_chat(user, SPAN_INFO("You start folding [src]."))
					if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_BUILD))
						to_chat(user, SPAN_WARNING("You were interrupted."))
						return

					to_chat(user, SPAN_INFO("You folding [src]."))

					state = STATE_UNDEPLOYED
					update_icon()
					bound_width = 32
					bound_height = 32
					pixel_x = -16
					pixel_y = -16
					anchored = FALSE
					return

				if(!istype(attack_item, /obj/item/powerloader_clamp))
					return

				var/obj/item/powerloader_clamp/clamp = attack_item

				if(!istype(clamp.loaded, /obj/structure/machinery/rocket_launcher) && !istype(clamp.loaded, /obj/structure/machinery/sentry))
					return

				var/obj/structure/machinery/weapon = clamp.loaded
				clamp.loaded = null
				clamp.update_icon()
				weapon.forceMove(src)
				linked_weapon = weapon
				if(istype(weapon, /obj/structure/machinery/sentry))
					var/obj/structure/machinery/sentry/linked_sentry = weapon
					linked_sentry.icon_state = "sentry"
					linked_sentry.range_bounds = SQUARE(x, y, 15)
				else
					weapon.icon_state = "rocket_launcher"
				START_PROCESSING(SSobj, src)
				update_icon()

/obj/structure/machinery/weapons_platform/update_icon()
	overlays.Cut()

	switch (state)
		if(STATE_UNDEPLOYED)
			icon_state = "platform_undeployed"
		if(STATE_ON)
			icon_state = "platform"
		if(STATE_OFF)
			icon_state = "platform_off"

	switch (state)
		if(STATE_ON, STATE_OFF)
			if(!linked_weapon)
				return

			overlays += image(linked_weapon.icon, linked_weapon.icon_state, dir = linked_weapon.dir)

#undef STATE_UNDEPLOYED
#undef STATE_ON
#undef STATE_OFF
