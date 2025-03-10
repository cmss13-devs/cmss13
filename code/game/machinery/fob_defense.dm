/obj/structure/machinery/fob
	name = "fob defense"
	desc = "go away don't look at this."
	icon_state = "terminal"
	icon = 'icons/obj/structures/machinery/fob_machinery/service_terminal.dmi'
	unacidable = TRUE
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = NONE
	active_power_usage = NONE
	needs_power = FALSE
	var/is_transformer_on = FALSE
	var/is_inside_lz = FALSE
	var/backup_generator_on = FALSE
	var/obj/structure/machinery/fob/terminal/linked_terminal

/obj/structure/machinery/fob/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_TRANSFORMER_ON, PROC_REF(transformer_turn_on))
	RegisterSignal(SSdcs, COMSIG_GLOB_TRANSFORMER_OFF, PROC_REF(transformer_turn_off))
	RegisterSignal(SSdcs, COMSIG_GLOB_BACKUP_GENERATOR_ON, PROC_REF(generator_turn_on))
	RegisterSignal(SSdcs, COMSIG_GLOB_BACKUP_GENERATOR_OFF, PROC_REF(generator_turn_off))

/obj/structure/machinery/fob/Destroy()
	. = ..()
	if(linked_terminal)
		linked_terminal.linked_machinery -= src

/obj/structure/machinery/fob/proc/transformer_turn_on()
	SIGNAL_HANDLER

	is_transformer_on = TRUE
	update_power()

/obj/structure/machinery/fob/proc/transformer_turn_off()
	SIGNAL_HANDLER
	is_transformer_on = FALSE
	update_power()

/obj/structure/machinery/fob/proc/generator_turn_on()
	SIGNAL_HANDLER
	backup_generator_on = TRUE
	update_power()

/obj/structure/machinery/fob/proc/generator_turn_off()
	SIGNAL_HANDLER
	backup_generator_on = FALSE
	update_power()

/obj/structure/machinery/fob/proc/update_power()
	if(is_inside_lz && (is_transformer_on || backup_generator_on) && linked_terminal)
		is_on = TRUE
	else
		is_on = FALSE
	update_icon()


/obj/structure/machinery/fob/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = item
		if(!clamp.linked_powerloader)
			qdel(clamp)
			return FALSE
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/obj/item/device/multitool/tool = item

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you do not know how to link your multitool to the [src.name].")
			return
		else if(do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			if(tool.linked_terminal)
				if(linked_terminal)
					if(linked_terminal == tool.linked_terminal)
						user.balloon_alert(user, " [src.name] is already linked to that terminal.")
						return

					linked_terminal.linked_machinery -= src
					user.balloon_alert(user, "you unlink the [src.name] from the old terminal.")
				linked_terminal = tool.linked_terminal
				linked_terminal.linked_machinery += src
				user.balloon_alert(user, "you link the [src.name] to the new terminal.")
				update_icon()
			else
				user.balloon_alert(user, "your multitool is not linked to a terminal!")


/obj/structure/machinery/fob/power_change()
	var/area/machine_area = get_area(src)
	var/area/lz_area = get_area(SSticker.mode.active_lz)
	if(machine_area == lz_area)
		is_inside_lz = TRUE
	else
		is_inside_lz = FALSE
	update_power()

/obj/structure/machinery/fob/update_icon()
	if(!is_inside_lz)
		icon_state = "[initial(icon_state)]_undeployed"
	else if(is_on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

//****************************************** TERMINAL ************************************************//

/obj/structure/machinery/fob/terminal
	name = "\improper UE-09 Service Terminal"
	desc = "Terminal used to monitor the power levels of marine defenses. Use a multitool to link defenses to the grid."
	icon_state = "terminal"
	icon = 'icons/obj/structures/machinery/fob_machinery/service_terminal.dmi'
	layer = ABOVE_FLY_LAYER
	linked_terminal = null
	var/generator_time
	var/list/linked_multitools = list()
	var/list/linked_machinery = list()

/obj/structure/machinery/fob/terminal/Destroy()
	. = ..()
	for(var/obj/item/device/multitool/tool in linked_multitools)
		tool.linked_terminal = null

/obj/structure/machinery/fob/terminal/attackby(obj/item/item, mob/user)

	if(istype(item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = item
		if(!clamp.linked_powerloader)
			qdel(clamp)
			return FALSE
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return

	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/obj/item/device/multitool/tool = item
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you do not know how to link your multitool to the [src.name].")
			return
		else if(do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			if(tool.linked_terminal == src)
				user.balloon_alert(user, "this tool is already linked to the [src.name].")
			else
				if(tool.linked_terminal)
					tool.linked_terminal.linked_multitools -= tool
				tool.linked_terminal = src
				linked_multitools += tool
				user.balloon_alert(user, "you link your multitool to the [src.name].")

	if(!is_on)
		user.balloon_alert(user, "the [src.name] has no power!")
		return

/obj/structure/machinery/fob/terminal/update_power()
	if(is_inside_lz && (is_transformer_on || backup_generator_on))
		is_on = TRUE
	else
		is_on = FALSE
	update_icon()

/obj/structure/machinery/fob/terminal/attack_hand(mob/user)

	/*if(!is_inside_lz) COMMENTED FOR EASY TESTS
		user.balloon_alert(user, "the [src.name] is too far from the LZ to recieve power!") COMMENTED FOR EASY TESTS
		return*/

	if(!is_on)
		user.balloon_alert(user, "the [src.name] has no power!")
		return

	if(!ishuman(user))
		return

	if(is_transformer_on)
		user.balloon_alert(user, "the [src.name] displays power information: The colony transformer is online. All linked structers online.")
		return

	if(!is_transformer_on && backup_generator_on)
		user.balloon_alert(user, "the [src.name] displays power information: The colony transformer is offline! Backup generator online. Time before generator depletion: [duration2text_sec(5 MINUTES + (generator_time - world.time))]!")

/obj/structure/machinery/fob/terminal/generator_turn_on()
	. = ..()
	generator_time = world.time





//****************************************** GENERATOR ************************************************//

/obj/structure/machinery/fob/backup_generator
	name = "\improper UE-11 Generator Unit"
	desc = "Special power module designed to be a backup generator in the event of a transformer malfunction. This generator can only provide power for a short time before being used up."
	icon_state = "backup_generator"
	icon = 'icons/obj/structures/machinery/fob_machinery/backup_generator.dmi'
	is_on = FALSE
	var/has_power_remaining = TRUE
	//how long the generator can power the FOB for
	var/power_duration = 5 MINUTES



/obj/structure/machinery/fob/backup_generator/attackby(obj/item/item, mob/user)
	if(is_on)
		user.balloon_alert(user, "the [src.name] is activated! It's probably not a good idea to touch it right now.")
		return
	. = ..()



/obj/structure/machinery/fob/backup_generator/attack_hand(mob/user)

	if(!ishuman(user))
		return

	if(!is_on)
		if(!has_power_remaining)
			user.balloon_alert(user, "the [src.name] has been depleted!")
			return
		if(!is_inside_lz)
			user.balloon_alert(user, "the [src.name] is too far from the LZ to distribute power!")
			return
		if(!linked_terminal)
			user.balloon_alert(user, "the [src.name] is not linked to a terminal!")
			return
		if(is_transformer_on)
			user.balloon_alert(user, "the colony transformer is online already. Turning this on now would only waste power.")
			return
		if(backup_generator_on)
			user.balloon_alert(user, "another backup generator is already online. Turning this one on would waste power.")
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you have no idea how to turn this thing on.")
			return
		is_on = TRUE
		user.balloon_alert(user, "you activate the [src.name].")
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BACKUP_GENERATOR_ON)
		addtimer(CALLBACK(src, PROC_REF(deplete_generator)), power_duration)
		update_icon()
		return

	if(is_on)
		user.balloon_alert(user, "you cannot deactivate the [src.name] once it has been activated.")
		update_icon()
		return


/obj/structure/machinery/fob/backup_generator/update_icon()
	if(!has_power_remaining)
		icon_state = "[initial(icon_state)]_depleted"
		return
	if(is_on)
		icon_state = "[initial(icon_state)]_on"
		return
	if(!is_on)
		icon_state = initial(icon_state)
		return

/obj/structure/machinery/fob/backup_generator/proc/deplete_generator()
	is_on = FALSE
	has_power_remaining = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BACKUP_GENERATOR_OFF)
	update_icon()

//****************************************** SENTRYGUN GENERAL ************************************************//
/obj/structure/machinery/fob/weapons_platform
	name = "\improper UH-02 Systems Platform"
	desc = "Large weapons system platform designed to deploy multiple types of automated defense systems, such as the UH-46 Heavy Sentry Gun and the UH-99 Smart Rocket Launcher."
	icon_state = "platform"
	icon = 'icons/obj/structures/machinery/fob_machinery/weapons_platform.dmi'
	var/obj/structure/machinery/fob/sentrygun/linked_gun

/obj/structure/machinery/fob/weapons_platform/attack_hand(mob/living/user)
	return

/obj/structure/machinery/fob/weapons_platform/attackby(obj/item/item, mob/user)

	if(istype(item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/powerloader_clamp = item
		if(linked_gun)
			linked_gun.attackby(powerloader_clamp, user)
			if(linked_gun == powerloader_clamp.loaded)
				linked_gun.linked_platform = null
				linked_gun = null
			return


		if(istype(powerloader_clamp.loaded,/obj/structure/machinery/fob/sentrygun))
			var/obj/structure/machinery/fob/sentrygun/loaded = powerloader_clamp.loaded
			loaded.forceMove(get_turf(src))
			loaded.linked_platform = src
			linked_gun = loaded
			linked_gun.set_area()
			linked_gun.update_icon()
			powerloader_clamp.loaded = null
			powerloader_clamp.update_icon()
			return


	. = ..()

/obj/structure/machinery/fob/weapons_platform/process()
	/*if(!is_on)
		stop_processing() COMMENTED FOR EASY TESTS
		if(linked_gun)
		linked_gun.loose_target()
		return*/

	if(!linked_gun)
		stop_processing()
		return

	linked_gun.check_targets()

	linked_gun.obtain_targets()

	linked_gun.aim()

	return TRUE

/obj/structure/machinery/fob/weapons_platform/start_processing()
	START_PROCESSING(SSdefprocess, src)

/obj/structure/machinery/fob/weapons_platform/stop_processing()
	STOP_PROCESSING(SSdefprocess, src)

/obj/structure/machinery/fob/weapons_platform/update_power()
	.=..()
	/*if(!is_on)
		stop_processing()
		return COMMENTED FOR EASY TESTS*/
	start_processing()
	if(linked_gun)
		linked_gun.set_area()

/obj/structure/machinery/fob/sentrygun
	var/mob/living/target
	var/list/targets = list()
	var/datum/ammo/ammo = /datum/ammo/bullet
	var/faction_group = FACTION_LIST_MARINE
	var/diameter = 13
	var/range_bounds
	var/image/target_indication
	var/sentry_range = 8
	var/obj/structure/machinery/fob/weapons_platform/linked_platform



/obj/structure/machinery/fob/sentrygun/attackby(obj/item/item, mob/user)
	. = ..()
	if(istype(item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/powerloader_clamp = item
		if(powerloader_clamp.loaded == src)
			if(linked_platform)
				linked_platform.linked_gun = null
				linked_platform = null

/obj/structure/machinery/fob/sentrygun/proc/check_targets()
	for(var/target in targets)
		if(!check_valid_target(target))
			loose_target(target)

/obj/structure/machinery/fob/sentrygun/proc/obtain_targets()
	return

/obj/structure/machinery/fob/sentrygun/proc/set_area()
	return

/obj/structure/machinery/fob/sentrygun/proc/fire(/mob/living/chosen_target)
	return

/obj/structure/machinery/fob/sentrygun/proc/lock_target()
	return

/obj/structure/machinery/fob/sentrygun/proc/loose_target(/mob/living/target)
	return

/obj/structure/machinery/fob/sentrygun/proc/check_visibility(atom)
	var/list/turf/path = get_line(src, atom, include_start_atom = FALSE)
	var/visible = TRUE
	if(!length(path) || get_dist(src, atom) > sentry_range)
		visible = FALSE


	for(var/turf/T in path)
		if(T.density || T.opacity)
			visible = FALSE
			break

		for(var/obj/structure/S in T)
			if(S.opacity)
				visible = FALSE
				break

		for(var/obj/vehicle/multitile/V in T)
			visible = FALSE
			break

		for(var/obj/effect/particle_effect/smoke/S in T)
			visible = FALSE
			break
	return visible

/obj/structure/machinery/fob/sentrygun/proc/aim()
	return

/obj/structure/machinery/fob/sentrygun/Initialize(mapload, ...)
	. = ..()
	target_indication = image(icon = 'icons/effects/Targeted.dmi', icon_state = "spotter_lockon")



/obj/structure/machinery/fob/sentrygun/proc/check_valid_target(atom)
	if(isliving(atom))
		var/mob/living/mob = atom

		if(mob.stat & DEAD || mob.get_target_lock(faction_group) || mob.invisibility || HAS_TRAIT(mob, TRAIT_ABILITY_BURROWED) || mob.is_ventcrawling)
			return FALSE
		return TRUE
	return FALSE

//****************************************** SENSOR ARRAY ************************************************//
/obj/structure/machinery/fob/sentrygun/sensor
	name = "\improper UE-04 Grid Sensor"
	desc = "Field deployed sensor unit with the purpose of lasing targets for UH-99 Smart Rocket Launcher system in a wide range."
	icon_state = "sensor"
	icon = 'icons/obj/structures/machinery/fob_machinery/sensor.dmi'
	diameter = 13
	var/placed
	var/mob/owner_mob = null
	var/obj/item/defenses/handheld/sensor/HD



/obj/structure/machinery/fob/sentrygun/sensor/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/obj/item/device/multitool/tool = item

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you do not know how to link your multitool to the [src.name].")
			return

		if(!do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return

		if(!tool.linked_terminal)
			user.balloon_alert(user, "your multitool is not linked to a terminal!")
			return

		if(linked_terminal == tool.linked_terminal)
			user.balloon_alert(user, " [src.name] is already linked to that terminal.")
			return

		if(!linked_terminal)
			linked_terminal = tool.linked_terminal
			linked_terminal.linked_machinery += src

			user.balloon_alert(user, "you link the [src.name] to the new terminal.")
			return

		linked_terminal.linked_machinery -= src
		user.balloon_alert(user, "you unlink the [src.name] from the old terminal.")
	update_icon()


	if(HAS_TRAIT(item, TRAIT_TOOL_WRENCH))

		if(is_on)
			to_chat(user, SPAN_WARNING("[src] is currently active. The motors will prevent you from disassembling it safely."))
			return

		user.visible_message(SPAN_NOTICE("[user] begins disassembling [src]."),
		SPAN_NOTICE("You begin disassembling [src]."))

		if(!do_after(user, 20 * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return

		user.visible_message(SPAN_NOTICE("[user] disassembles the [src]."),
		SPAN_NOTICE("You disassemble the [src]."))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
		var/turf/turf = get_turf(src)
		HD.forceMove(turf)
		transfer_label_component(HD)
		HD.dropped = 1
		placed = 0
		HD.update_icon()
		forceMove(HD)
		return

/obj/structure/machinery/fob/sentrygun/sensor/obtain_targets()
	var/list/targets = list()
	targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)
	if(!length(targets))
		return targets

	if(!length(targets))
		return targets

	for(var/atom/movable/atom in targets) // orange allows sentry to fire through gas and darkness
		if(!check_valid_target(atom))
			targets.Remove(atom)
			continue

		if(!check_visibility(atom))
			targets.Remove(atom)
			continue

		if(isliving(atom))
			var/mob/living/mob = atom
			targets |= mob

	return targets

/obj/structure/machinery/fob/sentrygun/sensor/update_power()
	set_area()

/obj/structure/machinery/fob/sentrygun/sensor/set_area()
	range_bounds = SQUARE(x, y, diameter)

/obj/item/defenses/handheld/sensor
	name = "\improper UE-04 Grid Sensor"
	desc = "Field deployed sensor unit with the purpose of lasing targets for UH-99 Smart Rocket Launcher system in a wide range."
	icon_state = "sensor_undeployed"
	icon = 'icons/obj/structures/machinery/fob_machinery/sensor.dmi'
	defense_type = /obj/structure/machinery/fob/sentrygun/sensor

/obj/item/defenses/handheld/sensor/get_examine_text(mob/user)
	.= ..()
	. += SPAN_INFO("It is ready for deployment.")




//****************************************** SENTRYGUN PLASMA ************************************************//

/obj/structure/machinery/fob/sentrygun/plasma
	name = "\improper UH-46 Heavy Sentry Gun"
	desc = "Massive omni directional dual barrelled 30mm automated heavy sentry gun. When powered it must acquire a lock on enemy units before firing."
	icon_state = "terminal"
	icon = 'icons/obj/structures/machinery/fob_machinery/service_terminal.dmi'
	diameter = 13
	layer = 4
	var/datum/beam/laser_beam
	var/lockon = 0
	var/max_lock = 10




/obj/structure/machinery/fob/sentrygun/plasma/set_area()
	range_bounds = SQUARE(x, y, diameter)

/obj/structure/machinery/fob/sentrygun/plasma/obtain_targets()
	if(check_valid_target(target))
		return
	targets = SSquadtree.players_in_range(range_bounds, z, QTREE_SCAN_MOBS | QTREE_EXCLUDE_OBSERVER)

	if(!islist(targets))
		return

	if(!length(targets))
		return

	for(var/atom/movable/atom in targets) // orange allows sentry to fire through gas and darkness
		if(!check_valid_target(atom))
			targets.Remove(atom)
			continue

		if(!check_visibility(atom))
			targets.Remove(atom)
			continue

		if(isliving(atom))
			var/mob/living/mob = atom
			targets |= mob
	if(!targets)
		return

	lock_target()


/obj/structure/machinery/fob/sentrygun/plasma/lock_target()
	if(!targets)
		return
	else
		target = pick(targets)

	laser_beam = target.beam(src, "laser_beam_spotter", 'icons/effects/beam.dmi', BEAM_INFINITE_DURATION, beam_type = /obj/effect/ebeam/laser)
	target_indication.pixel_x = -target.pixel_x + target.base_pixel_x
	target_indication.pixel_y = (target.icon_size - world.icon_size) * 0.5 - target.pixel_y + target.base_pixel_y
	target.overlays += target_indication

/obj/structure/machinery/fob/sentrygun/plasma/loose_target()
	lockon = 0
	qdel(laser_beam)
	target.overlays -= target_indication
	target = null

/obj/structure/machinery/fob/sentrygun/plasma/aim()
	if(!target)
		return

	if(check_visibility(target))
		lockon = min(max_lock, lockon + 3)
	else
		lockon = max(0, lockon -2)

	if(lockon == max_lock)
		fire(target)
		return

	if(lockon == 0)
		loose_target()

/obj/structure/machinery/fob/sentrygun/plasma/fire(chosen_target)
	var/obj/projectile/new_projectile = new(src, create_cause_data(initial(name), null, src))
	new_projectile.generate_bullet(new ammo)
	//new_projectile.damage *= damage_mult
	//new_projectile.accuracy *= accuracy_mult
	GIVE_BULLET_TRAIT(new_projectile, /datum/element/bullet_trait_iff, faction_group)
	new_projectile.fire_at(chosen_target, null, src, new_projectile.ammo.max_range, new_projectile.ammo.shell_speed, null, FALSE)

//****************************************** SENTRYGUN MISSILE ************************************************//

/obj/structure/machinery/fob/sentrygun/missile
	name = "\improper UH-99 Smart Rocket Launcher"
	desc = "Short range surface-to-surface rocket launcher system firing 60mm AMLE guided smart rockets. This system can be fired from behind cover, but it requires UE-04 Grid Sensors in order to paint targets."
	icon_state = "rocket_launcher"
	icon = 'icons/obj/structures/machinery/fob_machinery/rocket_launcher.dmi'
	ammo = /datum/ammo/rocket
	var/list/locked_on_targets = list()


/obj/structure/machinery/fob/sentrygun/missile/obtain_targets()
	. = ..()
	if(!linked_platform) //this should never happen, we are supposed to be called by the platform
		return
	if(!linked_platform.linked_terminal)
		return
	targets = list()
	for(var/obj/structure/machinery/fob/sentrygun/sensor/sensor in linked_platform.linked_terminal.linked_machinery)
		var/list/new_targets = sensor.obtain_targets()
		if(length(new_targets))
			for(var/mob/living/possible_target in new_targets)
				targets |= possible_target

/obj/structure/machinery/fob/sentrygun/missile/aim()
	. = ..()
	if(!targets)
		return
	for(var/mob/living/chosen_target in targets)
		if(!(chosen_target in locked_on_targets))
			locked_on_targets += chosen_target
			chosen_target.overlays += target_indication
			addtimer(CALLBACK(src, PROC_REF(fire), chosen_target), 2 SECONDS)

/obj/structure/machinery/fob/sentrygun/missile/fire(chosen_target)
	if(!(chosen_target in targets))
		loose_target(chosen_target)
		return
	fire_missile(chosen_target)
	loose_target(chosen_target)

/obj/structure/machinery/fob/sentrygun/missile/loose_target(chosen_target)
	locked_on_targets -= chosen_target
	if(istype(chosen_target,/mob/living))
		var/mob/living/chosen_mob = chosen_target
		chosen_mob.overlays -= target_indication

/obj/structure/machinery/fob/sentrygun/missile/proc/fire_missile(chosen_target)
	var/obj/projectile/new_projectile = new(src, create_cause_data(initial(name), null, src))
	new_projectile.generate_bullet(new ammo)
	//new_projectile.damage *= damage_mult
	//new_projectile.accuracy *= accuracy_mult
	GIVE_BULLET_TRAIT(new_projectile, /datum/element/bullet_trait_iff, faction_group)
	new_projectile.fire_at(chosen_target, null, src, new_projectile.ammo.max_range, new_projectile.ammo.shell_speed, null, FALSE)


/obj/structure/machinery/fob/sentrygun/missile/Destroy()
	. = ..()
	for(var/mob/target in locked_on_targets)
		loose_target(target)


//****************************************** FLOODLIGHT ************************************************//

/obj/structure/machinery/fob/floodlight
	name = "\improper UE-92 Area Illuminator"
	desc = "Large deployable floodlight designed to illuminate large areas."
	icon = 'icons/obj/structures/machinery/fob_machinery/illuminator.dmi'
	icon_state = "floodlight"
	var/on_light_range = 18



/obj/structure/machinery/fob/floodlight/power_change()
	. = ..()
	set_light(on_light_range)
	/*if(is_on && is_inside_lz)
		set_light(on_light_range)
	else
		set_light(0)*/


//****************************************** ELECTRIC FENCE ************************************************//

/obj/structure/fence/electrified/fob_fence
	name = "\improper UE-02 Deployable Fence"
	desc = "Light deployable fencing. While incredibly lacking in durability, it is able to transmit near-lethal electric shocks when powered."
	icon = 'icons/obj/structures/machinery/fob_machinery/electric_fence.dmi'
	icon_state = "fence0_off"
	basestate = "fence"
	throwpass = TRUE
	unacidable = TRUE
	forms_junctions = TRUE
	electrified = FALSE
	var/obj/structure/machinery/fob/terminal/linked_terminal



/obj/structure/fence/electrified/fob_fence/hitby(atom/movable/AM)
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		if(electrified)
			electrocute_mob(AM, get_area(src), src, 0.7)
			to_chat(AM, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
		else
			tforce = 40
	health = max(0, health - tforce)
	healthcheck()

/obj/structure/fence/electrified/fob_fence/attackby(obj/item/item, mob/user)
	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/obj/item/device/multitool/tool = item

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you do not know how to link your multitool to the [src.name].")
			return

		if(!do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return

		if(!tool.linked_terminal)
			user.balloon_alert(user, "your multitool is not linked to a terminal!")
			return

		if(linked_terminal == tool.linked_terminal)
			user.balloon_alert(user, " [src.name] is already linked to that terminal.")
			return

		if(!linked_terminal)
			linked_terminal = tool.linked_terminal
			linked_terminal.linked_machinery += src
			user.balloon_alert(user, "you link the [src.name] to the new terminal.")
			add_nearby_link()
			update_icon()
			return

		remove_nearby_link()
		linked_terminal.linked_machinery -= src
		linked_terminal = null
		user.balloon_alert(user, "you unlink the [src.name] from the old terminal.")
		update_icon()
		return

	if(electrified)
		electrocute_mob(user, get_area(src), src, 0.7)
		to_chat(user, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
		return

	if(HAS_TRAIT(item, TRAIT_TOOL_WIRECUTTERS))

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "you do not know how to disassemble the [src.name].")
			return

		if(electrified)
			user.balloon_alert(user, "you cannot dissassemble the [src.name] while it is electrified.")

		if(!do_after(usr, 5 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			return

		if(linked_terminal)
			linked_terminal.linked_machinery -= src
			linked_terminal = null

		new /obj/item/stack/electric_fence(loc)
		qdel(src)
		return
	. = ..()



/obj/structure/fence/electrified/fob_fence/Collided(atom/movable/AM)
	if(!ismob(AM))
		return
	var/mob/mob = AM
	if(electrified)
		electrocute_mob(mob, get_area(src), src, 0.7)
		to_chat(mob, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))


/obj/structure/fence/electrified/fob_fence/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(electrified)
		electrocute_mob(xeno, get_area(src), src, 0.75)
		to_chat(xeno, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
		return

	xeno.animation_attack_on(src)
	var/damage_dealt = 25
	xeno.visible_message(SPAN_DANGER("[xeno] mangles [src]!"),
	SPAN_DANGER("We mangle [src]!"),
	SPAN_DANGER("We hear twisting metal!"), 5, CHAT_TYPE_XENO_COMBAT)
	health -= damage_dealt
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/fence/electrified/fob_fence/proc/add_nearby_link()
	for(var/direction in GLOB.cardinals)
		for(var/obj/structure/fence/electrified/fob_fence/fence in get_step(src, direction))
			if(fence.linked_terminal != linked_terminal)
				fence.linked_terminal = linked_terminal
				linked_terminal.linked_machinery += fence

/obj/structure/fence/electrified/fob_fence/proc/remove_nearby_link()
	for(var/direction in GLOB.cardinals)
		for(var/obj/structure/fence/electrified/fob_fence/fence in get_step(src, direction))
			if(fence.linked_terminal == linked_terminal)
				fence.linked_terminal.linked_machinery -= fence
				fence.linked_terminal = null

/obj/item/stack/electric_fence
	name = "UE-02 Deployable Fences"
	singular_name = "UE-02 Deployable Fence"
	desc = "Some undeployed UE-02 Electric Fences."
	icon = 'icons/obj/items/marine-items.dmi'
	icon_state = "electric_fence"
	item_state = "electric_fence"
	w_class = SIZE_LARGE
	force = 9
	throwforce = 15
	throw_speed = SPEED_VERY_FAST
	throw_range = 20
	max_amount = 10
	attack_verb = list("hit", "bludgeoned", "whacked")
	stack_id = "electric fences"



/obj/item/stack/electric_fence/attack_self(mob/living/user)
	..()

	if(!isturf(user.loc))
		return
	if(istype(user.loc, /turf/open/shuttle))
		to_chat(user, SPAN_WARNING("No. This area is needed for the dropships and personnel."))
		return
	if(!istype(user.loc, /turf/open))
		var/turf/open/turf = user.loc
		if(!turf.allow_construction)
			to_chat(user, SPAN_WARNING("The [singular_name] must be constructed on a proper surface!"))
			return


	for(var/obj/object in user.loc)
		var/obj/structure/blocker/anti_cade/anti_cade = locate(/obj/structure/blocker/anti_cade) in user.loc
		if(object.density)
			to_chat(user, SPAN_WARNING("You need a clear, open area to build the [singular_name]!"))
			return
		if(anti_cade)
			to_chat(usr, SPAN_WARNING("The [singular_name] cannot be built here!"))
			return

	if(user.action_busy)
		return

	user.visible_message(SPAN_NOTICE("[user] starts assembling a [singular_name]."),
	SPAN_NOTICE("You start assembling a [singular_name]."))

	if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	new /obj/structure/fence/electrified/fob_fence(user.loc)
	user.visible_message(SPAN_NOTICE("[user] assembles a [singular_name]."),
	SPAN_NOTICE("You assemble a [singular_name]."))

	use(1)

/obj/item/stack/electric_fence/full
	amount = STACK_10
