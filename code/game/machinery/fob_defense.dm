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
	var/linked_to_terminal = FALSE

/obj/structure/machinery/fob/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_TRANSFORMER_ON, PROC_REF(transformer_turn_on))
	RegisterSignal(SSdcs, COMSIG_GLOB_TRANSFORMER_OFF, PROC_REF(transformer_turn_off))
	RegisterSignal(SSdcs, COMSIG_GLOB_BACKUP_GENERATOR_ON, PROC_REF(generator_turn_on))
	RegisterSignal(SSdcs, COMSIG_GLOB_BACKUP_GENERATOR_OFF, PROC_REF(generator_turn_off))


/obj/structure/machinery/fob/proc/transformer_turn_on()
	SIGNAL_HANDLER

	is_transformer_on = TRUE
	update_icon()

/obj/structure/machinery/fob/proc/transformer_turn_off()
	SIGNAL_HANDLER
	is_transformer_on = FALSE
	update_icon()

/obj/structure/machinery/fob/proc/generator_turn_on()
	SIGNAL_HANDLER
	backup_generator_on = TRUE
	update_icon()
/obj/structure/machinery/fob/proc/generator_turn_off()
	SIGNAL_HANDLER
	backup_generator_on = FALSE
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
			user.balloon_alert(user, "You do not know how to link your multitool to the [src.name].")
			return
		else if(do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			if(tool.is_terminal_linked)
				if(linked_to_terminal)
					linked_to_terminal = FALSE
					user.balloon_alert(user, "You unlink the [src.name] from the terminal.")
					update_icon()
				else
					linked_to_terminal = TRUE
					user.balloon_alert(user, "You link the [src.name] to the terminal.")
					update_icon()
			else if(!tool.is_terminal_linked)
				user.balloon_alert(user, "Your multitool is not linked to a terminal!")


/obj/structure/machinery/fob/power_change()
	var/area/machine_area = get_area(src)
	var/area/lz_area = get_area(SSticker.mode.active_lz)
	if(machine_area == lz_area)
		is_inside_lz = TRUE
	else
		is_inside_lz = FALSE
	update_icon()

/obj/structure/machinery/fob/update_icon()
	if(is_inside_lz && (is_transformer_on || backup_generator_on) && linked_to_terminal)
		is_on = TRUE
		icon_state = initial(icon_state)
	else
		is_on = FALSE
		icon_state = "[initial(icon_state)]_off"

//****************************************** TERMINAL ************************************************//

/obj/structure/machinery/fob/terminal
	name = "\improper UE-09 Service Terminal"
	desc = "A terminal used to monitor the power levels of marine defenses. Use a multitool to link defenses to the grid."
	icon_state = "terminal"
	icon = 'icons/obj/structures/machinery/service_terminal.dmi'
	layer = ABOVE_FLY_LAYER
	linked_to_terminal = TRUE
	var/generator_time


/obj/structure/machinery/fob/terminal/attackby(obj/item/item, mob/user)

	if(istype(item, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/clamp = item
		if(!clamp.linked_powerloader)
			qdel(clamp)
			return FALSE
		clamp.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
		return

	if(!is_on)
		user.balloon_alert(user, "The [src.name] has no power!")
		return

	if(HAS_TRAIT(item, TRAIT_TOOL_MULTITOOL))
		var/obj/item/device/multitool/tool = item
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "You do not know how to link your multitool to the [src.name].")
			return
		else if(do_after(usr, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
			if(tool.is_terminal_linked)
				tool.is_terminal_linked = FALSE
				user.balloon_alert(user, "You unlink the your multitool from the [src.name].")
			else if(!tool.is_terminal_linked)
				tool.is_terminal_linked = TRUE
				user.balloon_alert(user, "You link your multitool to the [src.name].")



/obj/structure/machinery/fob/terminal/attack_hand(mob/user)

	if(!is_inside_lz)
		user.balloon_alert(user, "The [src.name] is too far from the LZ to recieve power!")
		return

	if(!is_on)
		user.balloon_alert(user, "The [src.name] has no power!")
		return
	if(!ishuman(user))
		return

	if(is_transformer_on)
		user.balloon_alert(user, "The [src.name] displays power information: The colony transformer is online. All linked structers online.")
		return

	if(!is_transformer_on && backup_generator_on)
		user.balloon_alert(user, "The [src.name] displays power information: The colony transformer is offline! Backup generator online. Time before generator depletion: [duration2text_sec(5 MINUTES + (generator_time - world.time))]!")

/obj/structure/machinery/fob/terminal/generator_turn_on()
	. = ..()
	generator_time = world.time




//****************************************** GENERATOR ************************************************//

/obj/structure/machinery/fob/backup_generator
	name = "\improper UE-11 Generator Unit"
	desc = "A special power module designed to be a backup generator in the event of a transformer malfunction. This generator can only provide power for a short time before being used up."
	icon_state = "backup_generator"
	icon = 'icons/obj/structures/machinery/backup_generator.dmi'
	is_on = FALSE
	var/has_power_remaining = TRUE
	//how long the generator can power the FOB for
	var/power_duration = 5 MINUTES



/obj/structure/machinery/fob/backup_generator/attackby(obj/item/item, mob/user)
	if(is_on)
		user.balloon_alert(user, "The [src.name] is activated! It's probably not a good idea to touch it right now.")
		return
	. = ..()



/obj/structure/machinery/fob/backup_generator/attack_hand(mob/user)

	if(!ishuman(user))
		return

	if(!is_on)
		if(!has_power_remaining)
			user.balloon_alert(user, "The [src.name] has been depleted!")
			return
		if(!is_inside_lz)
			user.balloon_alert(user, "The [src.name] is too far from the LZ to distribute power!")
			return
		if(!linked_to_terminal)
			user.balloon_alert(user, "The [src.name] is not linked to a terminal!")
			return
		if(is_transformer_on)
			user.balloon_alert(user, "The colony transformer is online already. Turning this on now would only waste power.")
			return
		if(backup_generator_on)
			user.balloon_alert(user, "Another backup generator is already online. Turning this one on would waste power.")
			return
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			user.balloon_alert(user, "You have no idea how to turn this thing on.")
			return
		is_on = TRUE
		user.balloon_alert(user, "You activate the [src.name].")
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_BACKUP_GENERATOR_ON)
		addtimer(CALLBACK(src, PROC_REF(deplete_generator)), power_duration)
		update_icon()
		return

	if(is_on)
		user.balloon_alert(user, "You cannot deactivate the [src.name] once it has been activated.")
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
