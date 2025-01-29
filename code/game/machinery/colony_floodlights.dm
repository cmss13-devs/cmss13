GLOBAL_LIST_INIT(all_breaker_switches, list())

/obj/structure/machinery/colony_floodlight_switch // TODO: Repath to just breaker_switch
	name = "colony floodlight switch"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "panelnopower"
	desc = "This switch controls the floodlights surrounding the archaeology complex. It only functions when there is power."
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	unslashable = TRUE
	unacidable = TRUE
	power_machine = TRUE
	idle_power_usage = 0
	is_on = FALSE
	var/ispowered = FALSE
	///All machinery under our control
	var/list/machinery_list = list()
	///The types of machinery we control (define this)
	var/list/machinery_type_whitelist = list(/obj/structure/machinery/colony_floodlight)
	///The types of machinery we don't control (generated automatically)
	var/list/machinery_type_blacklist = list()

/obj/structure/machinery/colony_floodlight_switch/Initialize(mapload, ...)
	. = ..()
	for(var/obj/structure/machinery/colony_floodlight_switch/other_switch as anything in GLOB.all_breaker_switches)
		// blacklist anything other switches whitelist if theres subtype overlap
		for(var/other_whitelisted in other_switch.machinery_type_whitelist)
			if(is_path_in_list(other_whitelisted, machinery_type_whitelist))
				machinery_type_blacklist |= other_whitelisted
		for(var/our_whitelisted in machinery_type_whitelist)
			if(is_path_in_list(our_whitelisted, other_switch.machinery_type_whitelist))
				other_switch.machinery_type_blacklist |= our_whitelisted

	GLOB.all_breaker_switches += src
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/colony_floodlight_switch/LateInitialize()
	. = ..()
	if(length(machinery_type_whitelist))
		for(var/obj/structure/machinery/machine as anything in GLOB.machines)
			if(machine.breaker_switch != null)
				continue
			if(!is_type_in_list(machine, machinery_type_whitelist))
				continue
			if(is_type_in_list(machine, machinery_type_blacklist))
				continue
			machinery_list += machine
			machine.breaker_switch = src
	start_processing()

/obj/structure/machinery/colony_floodlight_switch/Destroy()
	for(var/obj/structure/machinery/machine as anything in machinery_list)
		if(machine.breaker_switch == src)
			machine.breaker_switch = null
	machinery_list = null
	GLOB.all_breaker_switches -= src
	return ..()

/obj/structure/machinery/colony_floodlight_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(is_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/colony_floodlight_switch/process()
	var/machinepower = calculate_current_power_usage()
	for(var/obj/structure/machinery/machine as anything in machinery_list)
		if(!machine.is_on)
			continue
		machinepower += machine.active_power_usage
	use_power(machinepower)

/obj/structure/machinery/colony_floodlight_switch/power_change()
	..()
	if((stat & NOPOWER))
		if(ispowered && is_on)
			toggle_machines()
		ispowered = FALSE
		set_is_on(FALSE)
	else
		ispowered = TRUE
		update_icon()

/obj/structure/machinery/colony_floodlight_switch/proc/toggle_machines()
	for(var/obj/structure/machinery/machine as anything in machinery_list)
		addtimer(CALLBACK(machine, TYPE_PROC_REF(/obj/structure/machinery, toggle_is_on)), rand(0, 5 SECONDS))

/obj/structure/machinery/colony_floodlight_switch/attack_hand(mob/user as mob)
	if(!ishuman(user))
		to_chat(user, "Nice try.")
		return FALSE
	if(!ispowered)
		to_chat(user, "Nothing happens.")
		return FALSE
	playsound(src,'sound/items/Deconstruct.ogg', 30, 1)
	use_power(5)
	toggle_is_on()
	toggle_machines()
	return TRUE


#define FLOODLIGHT_REPAIR_UNSCREW 0
#define FLOODLIGHT_REPAIR_CROWBAR 1
#define FLOODLIGHT_REPAIR_WELD 2
#define FLOODLIGHT_REPAIR_CABLE 3
#define FLOODLIGHT_REPAIR_SCREW 4

/obj/structure/machinery/colony_floodlight
	name = "colony floodlight"
	icon = 'icons/obj/structures/machinery/big_floodlight.dmi'
	icon_state = "flood_s_off"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_XENO_LAYER
	unslashable = TRUE
	unacidable = TRUE
	use_power = USE_POWER_NONE //It's the switch that uses the actual power, not the lights
	needs_power = FALSE
	is_on = FALSE //Whether the floodlight is switched to on or off. Does not necessarily mean it emits light.
	health = 150
	active_power_usage = 50 //The power each floodlight takes up per process
	///Whether it has been smashed by xenos
	var/damaged = FALSE
	var/lum_value = 7
	var/repair_state = FLOODLIGHT_REPAIR_UNSCREW

/obj/structure/machinery/colony_floodlight/update_icon()
	if(damaged)
		icon_state = "flood_s_dmg"
	else if(is_on)
		icon_state = "flood_s_on"
	else
		icon_state = "flood_s_off"

/obj/structure/machinery/colony_floodlight/attackby(obj/item/I, mob/user)
	if(damaged)
		if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_UNSCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts unscrewing [src]'s maintenance hatch."),
				SPAN_NOTICE("You start unscrewing [src]'s maintenance hatch."))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_UNSCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_CROWBAR
					user.visible_message(SPAN_NOTICE("[user] unscrews [src]'s maintenance hatch."),
					SPAN_NOTICE("You unscrew [src]'s maintenance hatch."))

			else if(repair_state == FLOODLIGHT_REPAIR_SCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts screwing [src]'s maintenance hatch closed."),
				SPAN_NOTICE("You start screwing [src]'s maintenance hatch closed."))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_SCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					damaged = FALSE
					repair_state = FLOODLIGHT_REPAIR_UNSCREW
					health = initial(health)
					user.visible_message(SPAN_NOTICE("[user] screws [src]'s maintenance hatch closed."),
					SPAN_NOTICE("You screw [src]'s maintenance hatch closed."))
					if(is_on)
						set_light(lum_value)
					update_icon()
			return TRUE

		else if(HAS_TRAIT(I, TRAIT_TOOL_CROWBAR))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_CROWBAR)
				playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts prying [src]'s damaged lighting assembly out."),
				SPAN_NOTICE("You start prying [src]'s damaged lighting assembly out."))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CROWBAR)
						return
					playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_WELD
					user.visible_message(SPAN_NOTICE("[user] pries [src]'s damaged lighting assembly out."),
					SPAN_NOTICE("You pry [src]'s damaged lighting assembly out."))
			return TRUE

		else if(iswelder(I))
			if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
				to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
				return
			var/obj/item/tool/weldingtool/welder = I

			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_WELD)
				if(welder.remove_fuel(1, user))
					playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
					user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s damage."),
					SPAN_NOTICE("You start welding [src]'s damage."))
					if(do_after(user, 4 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(QDELETED(src) || !welder.isOn() || repair_state != FLOODLIGHT_REPAIR_WELD)
							return
						playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_CABLE
						user.visible_message(SPAN_NOTICE("[user] welds [src]'s damage."),
						SPAN_NOTICE("You weld [src]'s damage."))
						return TRUE
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return TRUE

		else if(iscoil(I))
			var/obj/item/stack/cable_coil/coil = I
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_CABLE)
				if(coil.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two coils of wire to replace the damaged cables."))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts replacing [src]'s damaged cables."),
				SPAN_NOTICE("You start replacing [src]'s damaged cables."))
				if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CABLE)
						return
					if(coil.use(2))
						playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_SCREW
						user.visible_message(SPAN_NOTICE("[user] replaces [src]'s damaged cables."),
						SPAN_NOTICE("You replace [src]'s damaged cables."))
			return TRUE

		else if(istype(I, /obj/item/device/lightreplacer))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return FALSE

			if(repair_state == FLOODLIGHT_REPAIR_UNSCREW)
				to_chat(user, SPAN_WARNING("You need to unscrew [src]'s maintenance hatch."))
				return FALSE
			if(repair_state == FLOODLIGHT_REPAIR_SCREW)
				to_chat(user, SPAN_WARNING("You need to screw [src]'s maintenance hatch."))
				return FALSE

			var/obj/item/device/lightreplacer/replacer = I
			if(!replacer.CanUse(user))
				to_chat(user, replacer.failmsg)
				return FALSE
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts replacing [src]'s damaged lighting assembly."),
			SPAN_NOTICE("You start replacing [src]'s damaged lighting assembly."))
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
				if(QDELETED(src) || repair_state == FLOODLIGHT_REPAIR_SCREW)
					return
				replacer.Use(user)
				repair_state = FLOODLIGHT_REPAIR_SCREW
				user.visible_message(SPAN_NOTICE("[user] replaces [src]'s damaged lighting assembly."),
				SPAN_NOTICE("You replace [src]'s damaged lighting assembly."))
			return TRUE

	return ..()

/obj/structure/machinery/colony_floodlight/attack_hand(mob/user)
	if(ishuman(user))
		if(damaged)
			to_chat(user, SPAN_WARNING("[src] is damaged."))
		else if(!is_on)
			to_chat(user, SPAN_WARNING("Nothing happens. Looks like it's powered elsewhere."))
		return FALSE
	return ..()

/obj/structure/machinery/colony_floodlight/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		if(damaged)
			. += SPAN_WARNING("It is damaged.")
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				switch(repair_state)
					if(FLOODLIGHT_REPAIR_UNSCREW) . += SPAN_INFO("You must first unscrew its maintenance hatch.")
					if(FLOODLIGHT_REPAIR_CROWBAR) . += SPAN_INFO("You must crowbar its lighting assembly out or use a light replacer.")
					if(FLOODLIGHT_REPAIR_WELD) . += SPAN_INFO("You must weld the damage to it.")
					if(FLOODLIGHT_REPAIR_CABLE) . += SPAN_INFO("You must replace its damaged cables.")
					if(FLOODLIGHT_REPAIR_SCREW) . += SPAN_INFO("You must screw its maintenance hatch closed.")
		else if(!is_on)
			. += SPAN_INFO("It doesn't seem powered.")

/obj/structure/machinery/colony_floodlight/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(25))
				set_damaged()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				set_damaged()
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			set_damaged()
			return

/obj/structure/machinery/colony_floodlight/proc/set_damaged()
	playsound(src, "glassbreak", 70, 1)
	damaged = TRUE
	if(is_on)
		set_light(0)
	update_icon()

/obj/structure/machinery/colony_floodlight/toggle_is_on()
	. = ..()
	if(!damaged)
		set_light(is_on ? lum_value : 0)
	return .

#undef FLOODLIGHT_REPAIR_UNSCREW
#undef FLOODLIGHT_REPAIR_CROWBAR
#undef FLOODLIGHT_REPAIR_WELD
#undef FLOODLIGHT_REPAIR_CABLE
#undef FLOODLIGHT_REPAIR_SCREW
