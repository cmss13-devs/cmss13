//Putting these here since it's power-related
/obj/structure/machinery/colony_floodlight_switch
	name = "Colony Floodlight Switch"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "panelnopower"
	desc = "This switch controls the floodlights surrounding the archaeology complex. It only functions when there is power."
	density = FALSE
	anchored = TRUE
	var/ispowered = FALSE
	var/turned_on = 0 //has to be toggled in engineering
	use_power = USE_POWER_IDLE
	unslashable = TRUE
	unacidable = TRUE
	var/list/floodlist = list() // This will save our list of floodlights on the map
	power_machine = TRUE

/obj/structure/machinery/colony_floodlight_switch/Initialize(mapload, ...)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/colony_floodlight_switch/LateInitialize()
	. = ..()
	for(var/obj/structure/machinery/colony_floodlight/F in GLOB.machines)
		floodlist += F
		F.fswitch = src
	start_processing()

/obj/structure/machinery/colony_floodlight_switch/Destroy()
	for(var/obj/structure/machinery/colony_floodlight/floodlight as anything in floodlist)
		floodlight.fswitch = null
	floodlist = null
	return ..()


/obj/structure/machinery/colony_floodlight_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(turned_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/colony_floodlight_switch/process()
	var/lightpower = 0
	for(var/obj/structure/machinery/colony_floodlight/C in floodlist)
		if(!C.is_lit)
			continue
		lightpower += C.power_tick
	use_power(lightpower)

/obj/structure/machinery/colony_floodlight_switch/power_change()
	..()
	if((stat & NOPOWER))
		if(ispowered && turned_on)
			toggle_lights()
		ispowered = FALSE
		turned_on = 0
		update_icon()
	else
		ispowered = TRUE
		update_icon()

/obj/structure/machinery/colony_floodlight_switch/proc/toggle_lights()
	for(var/obj/structure/machinery/colony_floodlight/F in floodlist)
		spawn(rand(0,50))
			F.is_lit = !F.is_lit
			if(!F.damaged)
				if(F.is_lit) //Shut it down
					F.set_light(F.lum_value)
				else
					F.set_light(0)
			F.update_icon()
	return 0

/obj/structure/machinery/colony_floodlight_switch/attack_hand(mob/user as mob)
	if(!ishuman(user))
		to_chat(user, "Nice try.")
		return 0
	if(!ispowered)
		to_chat(user, "Nothing happens.")
		return 0
	playsound(src,'sound/items/Deconstruct.ogg', 30, 1)
	use_power(5)
	toggle_lights()
	turned_on = !(src.turned_on)
	update_icon()
	return 1


#define FLOODLIGHT_REPAIR_UNSCREW 0
#define FLOODLIGHT_REPAIR_CROWBAR 1
#define FLOODLIGHT_REPAIR_WELD 2
#define FLOODLIGHT_REPAIR_CABLE 3
#define FLOODLIGHT_REPAIR_SCREW 4

/obj/structure/machinery/colony_floodlight
	name = "Colony Floodlight"
	icon = 'icons/obj/structures/machinery/big_floodlight.dmi'
	icon_state = "flood_s_off"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_XENO_LAYER
	var/damaged = 0 //Can be smashed by xenos
	var/is_lit = 0 //whether the floodlight is switched to on or off. Does not necessarily mean it emits light.
	unslashable = TRUE
	unacidable = TRUE
	var/power_tick = 50 // power each floodlight takes up per process
	use_power = USE_POWER_NONE //It's the switch that uses the actual power, not the lights
	var/obj/structure/machinery/colony_floodlight_switch/fswitch = null //Reverse lookup for power grabbing in area
	var/lum_value = 7
	var/repair_state = 0
	health = 150

/obj/structure/machinery/colony_floodlight/Destroy()
	if(fswitch)
		fswitch.floodlist -= src
		fswitch = null
	. = ..()

/obj/structure/machinery/colony_floodlight/update_icon()
	if(damaged)
		icon_state = "flood_s_dmg"
	else if(is_lit)
		icon_state = "flood_s_on"
	else
		icon_state = "flood_s_off"

/obj/structure/machinery/colony_floodlight/attackby(obj/item/I, mob/user)
	if(damaged)
		if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_UNSCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts unscrewing [src]'s maintenance hatch."), \
				SPAN_NOTICE("You start unscrewing [src]'s maintenance hatch."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_UNSCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_CROWBAR
					user.visible_message(SPAN_NOTICE("[user] unscrews [src]'s maintenance hatch."), \
					SPAN_NOTICE("You unscrew [src]'s maintenance hatch."))

			else if(repair_state == FLOODLIGHT_REPAIR_SCREW)
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts screwing [src]'s maintenance hatch closed."), \
				SPAN_NOTICE("You start screwing [src]'s maintenance hatch closed."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_SCREW)
						return
					playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
					damaged = 0
					repair_state = FLOODLIGHT_REPAIR_UNSCREW
					health = initial(health)
					user.visible_message(SPAN_NOTICE("[user] screws [src]'s maintenance hatch closed."), \
					SPAN_NOTICE("You screw [src]'s maintenance hatch closed."))
					if(is_lit)
						set_light(lum_value)
					update_icon()
			return TRUE

		else if(HAS_TRAIT(I, TRAIT_TOOL_CROWBAR))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_CROWBAR)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts prying [src]'s maintenance hatch open."),\
				SPAN_NOTICE("You start prying [src]'s maintenance hatch open."))
				if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CROWBAR)
						return
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, 1)
					repair_state = FLOODLIGHT_REPAIR_WELD
					user.visible_message(SPAN_NOTICE("[user] pries [src]'s maintenance hatch open."),\
					SPAN_NOTICE("You pry [src]'s maintenance hatch open."))
			return TRUE

		else if(iswelder(I))
			if(!HAS_TRAIT(I, TRAIT_TOOL_BLOWTORCH))
				to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
				return
			var/obj/item/tool/weldingtool/WT = I

			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_WELD)
				if(WT.remove_fuel(1, user))
					playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
					user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s damage."),
					SPAN_NOTICE("You start welding [src]'s damage."))
					if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						if(QDELETED(src) || !WT.isOn() || repair_state != FLOODLIGHT_REPAIR_WELD)
							return
						playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_CABLE
						user.visible_message(SPAN_NOTICE("[user] welds [src]'s damage."),
						SPAN_NOTICE("You weld [src]'s damage."))
						return 1
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return TRUE

		else if(iscoil(I))
			var/obj/item/stack/cable_coil/C = I
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return 0

			if(repair_state == FLOODLIGHT_REPAIR_CABLE)
				if(C.get_amount() < 2)
					to_chat(user, SPAN_WARNING("You need two coils of wire to replace the damaged cables."))
					return
				playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] starts replacing [src]'s damaged cables."),\
				SPAN_NOTICE("You start replacing [src]'s damaged cables."))
				if(do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
					if(QDELETED(src) || repair_state != FLOODLIGHT_REPAIR_CABLE)
						return
					if(C.use(2))
						playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
						repair_state = FLOODLIGHT_REPAIR_SCREW
						user.visible_message(SPAN_NOTICE("[user] starts replaces [src]'s damaged cables."),\
						SPAN_NOTICE("You replace [src]'s damaged cables."))
			return TRUE


	..()
	return 0

/obj/structure/machinery/colony_floodlight/attack_hand(mob/user)
	if(ishuman(user))
		if(damaged)
			to_chat(user, SPAN_WARNING("[src] is damaged."))
		else if(!is_lit)
			to_chat(user, SPAN_WARNING("Nothing happens. Looks like it's powered elsewhere."))
		return 0
	..()

/obj/structure/machinery/colony_floodlight/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		if(damaged)
			. += SPAN_WARNING("It is damaged.")
			if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				switch(repair_state)
					if(FLOODLIGHT_REPAIR_UNSCREW) . += SPAN_INFO("You must first unscrew its maintenance hatch.")
					if(FLOODLIGHT_REPAIR_CROWBAR) . += SPAN_INFO("You must crowbar its maintenance hatch open.")
					if(FLOODLIGHT_REPAIR_WELD) . += SPAN_INFO("You must weld the damage to it.")
					if(FLOODLIGHT_REPAIR_CABLE) . += SPAN_INFO("You must replace its damaged cables.")
					if(FLOODLIGHT_REPAIR_SCREW) . += SPAN_INFO("You must screw its maintenance hatch closed.")
		else if(!is_lit)
			. += SPAN_INFO("It doesn't seem powered.")

#undef FLOODLIGHT_REPAIR_UNSCREW
#undef FLOODLIGHT_REPAIR_CROWBAR
#undef FLOODLIGHT_REPAIR_WELD
#undef FLOODLIGHT_REPAIR_CABLE
#undef FLOODLIGHT_REPAIR_SCREW
