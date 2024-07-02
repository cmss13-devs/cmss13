/obj/structure/machinery/colony_floodlight_switch/hydro_floodlight_switch
	name = "biodome floodlight switch"
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "panelnopower"
	desc = "This switch controls the floodlights surrounding the archaeology complex. It only functions when there is power."
	machinery_type_whitelist = list(/obj/structure/machinery/hydro_floodlight)

/obj/structure/machinery/colony_floodlight_switch/hydro_floodlight_switch/update_icon()
	if(!ispowered)
		icon_state = "panelnopower"
	else if(is_on)
		icon_state = "panelon"
	else
		icon_state = "paneloff"

/obj/structure/machinery/hydro_floodlight // TODO: Repath under /obj/structure/machinery/colony_floodlight
	name = "biodome floodlight"
	icon = 'icons/obj/structures/machinery/big_floodlight.dmi'
	icon_state = "flood_s_off"
	density = TRUE
	anchored = TRUE
	layer = WINDOW_LAYER
	unslashable = TRUE
	unacidable = TRUE
	use_power = USE_POWER_NONE //It's the switch that uses the actual power, not the lights
	needs_power = FALSE
	is_on = FALSE
	active_power_usage = 800 //The power each floodlight takes up per process
	///Whether it has been smashed by xenos
	var/damaged = FALSE
	var/lum_value = 7

/obj/structure/machinery/hydro_floodlight/update_icon()
	if(damaged)
		icon_state = "flood_s_dmg"
	else if(is_on)
		icon_state = "flood_s_on"
	else
		icon_state = "flood_s_off"

/obj/structure/machinery/hydro_floodlight/proc/set_damaged()
	playsound(src, "glassbreak", 70, 1)
	damaged = TRUE
	if(is_on)
		set_light(0)
	update_icon()

/obj/structure/machinery/hydro_floodlight/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/tool/weldingtool/welder = W
	if(istype(welder))
		if(!damaged)
			return
		if(!HAS_TRAIT(welder, TRAIT_TOOL_BLOWTORCH))
			to_chat(user, SPAN_WARNING("You need a stronger blowtorch!"))
			return
		if(welder.remove_fuel(0, user))
			playsound(src.loc, 'sound/items/weldingtool_weld.ogg', 25)
			user.visible_message(SPAN_NOTICE("[user] starts welding [src]'s damage."), \
				SPAN_NOTICE("You start welding [src]'s damage."))
			if(do_after(user, 200 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				playsound(get_turf(src), 'sound/items/Welder2.ogg', 25, 1)
				if(!src || !welder.isOn()) return
				damaged = FALSE
				user.visible_message(SPAN_NOTICE("[user] finishes welding [src]'s damage."), \
					SPAN_NOTICE("You finish welding [src]'s damage."))
				if(is_on)
					set_light(lum_value)
				update_icon()
				return TRUE
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return FALSE
	..()
	return FALSE

/obj/structure/machinery/hydro_floodlight/attack_hand(mob/user as mob)
	if(ishuman(user))
		to_chat(user, SPAN_WARNING("Nothing happens. Looks like it's powered elsewhere."))
		return FALSE
	else if(!is_on)
		to_chat(user, SPAN_WARNING("Why bother? It's just some weird metal thing."))
		return FALSE
	else
		if(damaged)
			to_chat(user, SPAN_WARNING("It's already damaged."))
			return FALSE
		else
			if(islarva(user))
				return //Larvae can't do shit
			if(user.get_active_hand())
				to_chat(user, SPAN_WARNING("You need your claws empty for this!"))
				return FALSE
			user.visible_message(SPAN_DANGER("[user] starts to slash and claw away at [src]!"),
			SPAN_DANGER("You start slashing and clawing at [src]!"))
			if(do_after(user, 50, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && !damaged) //Not when it's already damaged.
				if(!src) return FALSE
				damaged = TRUE
				set_light(0)
				user.visible_message(SPAN_DANGER("[user] slashes up [src]!"),
				SPAN_DANGER("You slash up [src]!"))
				playsound(src, 'sound/weapons/blade1.ogg', 25, 1)
				update_icon()
				return FALSE
	..()
