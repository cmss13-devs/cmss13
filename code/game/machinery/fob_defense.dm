/obj/structure/machinery/fob
	name = "fob defense"
	desc = "go away don't look at this."
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
	desc = "atom terminal used to monitor the power levels of marine defenses. Use a multitool to link defenses to the grid."
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
	desc = "atom special power module designed to be a backup generator in the event of a transformer malfunction. This generator can only provide power for a short time before being used up."
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
	icon_state = "platform"
	icon = 'icons/obj/structures/machinery/fob_machinery/rocket_launcher.dmi'
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

//****************************************** SENZOR ARRAY ************************************************//
/obj/structure/machinery/fob/sentrygun/senzor
	diameter = 13

/obj/structure/machinery/fob/sentrygun/sentrygun/update_power()
	return //we do not want to process... I should have use brain first code later

/obj/structure/machinery/fob/sentrygun/senzor/obtain_targets()
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

/obj/structure/machinery/fob/sentrygun/senzor/update_power()
	set_area()

/obj/structure/machinery/fob/sentrygun/senzor/set_area()
	range_bounds = SQUARE(x, y, diameter)


//****************************************** SENTRYGUN PLASMA ************************************************//

/obj/structure/machinery/fob/sentrygun/plasma
	name = "\improper UE-09 Service Terminal"
	desc = "atom terminal used to monitor the power levels of marine defenses. Use a multitool to link defenses to the grid."
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
	name = "\improper UE-09 Service Terminal"
	desc = "atom terminal used to monitor the power levels of marine defenses. Use a multitool to link defenses to the grid."
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
	for(var/obj/structure/machinery/fob/sentrygun/senzor/senzor in linked_platform.linked_terminal.linked_machinery)
		var/list/new_targets = senzor.obtain_targets()
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
	var/on_light_range = 18
	icon = "icons/obj/structures/machinery/fob_machinery/illuminator.dmi"
	icon_state = "floodlight"

/obj/structure/machinery/fob/floodlight/power_change()
	. = ..()
	set_light(on_light_range)
	/*if(is_on && is_inside_lz)
		set_light(on_light_range)
	else
		set_light(0)*/





