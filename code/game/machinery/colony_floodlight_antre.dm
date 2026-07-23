/obj/structure/machinery/colony_floodlight_switch/antre
	name = "containment floodlight switch"
	icon_state = "panelynopower"
	desc = "This switch controls the floodlights surrounding the containment complex. It only functions when there is power."
	machinery_type_whitelist = list(/obj/structure/machinery/colony_floodlight/industrial)
	///Whether it has been smashed by xenos
	var/damaged = FALSE
	///Are we alarming?
	var/alarming = FALSE

/obj/structure/machinery/colony_floodlight_switch/antre/LateInitialize()
	. = ..()
	alarming = TRUE
	toggle_is_on()
	toggle_machines()
	update_icon()

/obj/structure/machinery/colony_floodlight_switch/antre/update_icon()
	if(damaged)
		icon_state = "panelybroken"
		set_light(0)
		return
	if(!ispowered)
		icon_state = "panelynopower"
		set_light(0)
		return
	if(is_on)
		if(!alarming)
			icon_state = "panelyon"
			set_light(1, 0.5, LIGHT_COLOR_CANDLE)
			return
		else
			icon_state = "panelyalarming"
			set_light(1, 0.5, LIGHT_COLOR_FLARE)
			return
	icon_state = "panelyoff"
	set_light(1, 0.5, LIGHT_COLOR_FLARE)

/obj/structure/machinery/colony_floodlight_switch/antre/attack_hand(mob/user as mob)
	if(damaged)
		to_chat(user, "The [src] is broken!")
		return FALSE
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

/obj/structure/machinery/colony_floodlight_switch/antre/attackby(obj/item/I, mob/user)
	if(damaged)
		if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You have no clue how to repair [src]."))
				return FALSE
			playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("[user] starts screwing [src]'s screen back in place."),
			SPAN_NOTICE("You start screwing [src]'s screen back in place."))
			if(do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				if(QDELETED(src) || !damaged)
					return
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
				damaged = FALSE
				update_icon()
				user.visible_message(SPAN_NOTICE("[user] screws [src]'s screen back in place."),
				SPAN_NOTICE("You screw [src]'s screen back in place."))
				return TRUE
	return ..()

/////////////////////////////////////////////////////

/obj/structure/machinery/colony_floodlight/industrial
	name = "industrial floodlight"
	icon_state = "flood_yellow_off"
	health = 200
	lum_value = 10

/obj/structure/machinery/colony_floodlight/industrial/update_icon()
	if(damaged)
		icon_state = "flood_yellow_dmg"
	else if(is_on)
		icon_state = "flood_yellow_on"
	else
		icon_state = "flood_yellow_off"
