#define LIGHT_FLOOR_COLOR_BLUE 0
#define LIGHT_FLOOR_COLOR_RED 1
#define LIGHT_FLOOR_COLOR_GREEN 2
#define LIGHT_FLOOR_COLOR_YELLOW 3
#define LIGHT_FLOOR_COLOR_PURPLE 4
#define LIGHT_FLOOR_COLOR_WHITE 5

/turf/open/floor/light
	name = "light floor"
	desc = "Beware of breakdancing on these tiles, glass shards embedded in the head is not a fun time."
	icon_state = "light_on"
	tile_type = /obj/item/stack/tile/light
	var/on = TRUE
	var/state = LIGHT_FLOOR_COLOR_BLUE

/turf/open/floor/light/get_examine_text(mob/user)
	. = ..()
	. += "[src] is [turf_flags & TURF_BROKEN ? "broken, and requires a replacement lightbulb":"[on ? "on" : "off"]"]."

/turf/open/floor/light/is_light_floor()
	return TRUE

/turf/open/floor/light/update_icon()
	. = ..()
	if(on && !(turf_flags & TURF_BROKEN)) //manages color, I feel like this switch is a sin.
		switch(state)
			if(LIGHT_FLOOR_COLOR_BLUE)
				icon_state = "light_on"
				set_light(5)
			if(LIGHT_FLOOR_COLOR_RED)
				icon_state = "light_on-r"
				set_light(5)
			if(LIGHT_FLOOR_COLOR_GREEN)
				icon_state = "light_on-g"
				set_light(5)
			if(LIGHT_FLOOR_COLOR_YELLOW)
				icon_state = "light_on-y"
				set_light(5)
			if(LIGHT_FLOOR_COLOR_PURPLE)
				icon_state = "light_on-p"
				set_light(5)
			if(LIGHT_FLOOR_COLOR_WHITE,-1) //change this later
				icon_state = "light_on-w"
				set_light(5)
				state = -1
			else
				return //Should never happen ever but what if... returns into the other else which close the light

	else if(turf_flags & TURF_BROKEN)
		icon_state = "light_broken" //It's the same sprite as light off, my artistic skill stops at stickmans anyone feel free to make a better one!
		set_light(0)
	else
		icon_state = "light_off"
		set_light(0)
		on = FALSE

/turf/open/floor/light/attackby(obj/item/item_in_hand, mob/user)
	. = ..()
	if(istype(item_in_hand, /obj/item/light_bulb/bulb)) //changing the light by smacking a bulb on it, voices in my head told me to be kind and not reset the state
		if(turf_flags & TURF_BROKEN)
			qdel(item_in_hand)
			turf_flags &= ~TURF_BROKEN
			update_icon()
			playsound(src, 'sound/machines/click.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You replace the light bulb."))
		else
			to_chat(user, SPAN_NOTICE("The lightbulb seems fine, no need to replace it."))
		return

	if(istype(item_in_hand, /obj/item/device/multitool)) //changing the light color with multitool, can't do if bulb broken, can do while it's off
		if(!(turf_flags & TURF_BROKEN))
			state++
			update_icon()
			to_chat(user, SPAN_NOTICE("You alter the glass panel's settings, changing its color."))
		else
			to_chat(user, SPAN_NOTICE("The bulb inside is shattered, you should get a new one before tuning it."))


/turf/open/floor/light/attack_hand(mob/user as mob) //turning the light on and off
	if(!(turf_flags & TURF_BROKEN))
		on = !on
		update_icon()
		to_chat(user, SPAN_NOTICE("You turn the light [on ? "on" : "off"]."))
	else
		to_chat(user, SPAN_NOTICE("It looks like the bulb inside has been shattered, you should think about replacing it.")) //if the light is broken and you try to turn it off and on

	return ..()

/turf/open/floor/light/attack_alien(mob/living/carbon/xenomorph/xeno_attacker) //Xeno breaking light, this makes them basically flashlight that needs a new bulb to go back on
	if(!(turf_flags & TURF_BROKEN))
		playsound(src, "windowshatter", 25, 1)
		xeno_attacker.animation_attack_on(src)
		xeno_attacker.visible_message(SPAN_DANGER("\The [xeno_attacker] smashes \the [src]!"),
		SPAN_DANGER("You smash \the [src]!"),
		SPAN_DANGER("You hear broken glass!"), 5)
		turf_flags |= TURF_BROKEN
		update_icon()
		return XENO_ATTACK_ACTION

/turf/open/floor/light/red
	icon_state = "light_on-r"
	state = LIGHT_FLOOR_COLOR_RED

/turf/open/floor/light/green
	icon_state = "light_on-g"
	state = LIGHT_FLOOR_COLOR_GREEN

/turf/open/floor/light/yellow
	icon_state = "light_on-y"
	state = LIGHT_FLOOR_COLOR_YELLOW

/turf/open/floor/light/purple
	icon_state = "light_on-p"
	state = LIGHT_FLOOR_COLOR_PURPLE

/turf/open/floor/light/white
	icon_state = "light_on-w"
	state = LIGHT_FLOOR_COLOR_WHITE

/turf/open/floor/light/off
	icon_state = "light_off"
	on = FALSE

/turf/open/floor/light/off/red
	state = LIGHT_FLOOR_COLOR_RED

/turf/open/floor/light/off/green
	state = LIGHT_FLOOR_COLOR_GREEN

/turf/open/floor/light/off/yellow
	state = LIGHT_FLOOR_COLOR_YELLOW

/turf/open/floor/light/off/purple
	state = LIGHT_FLOOR_COLOR_PURPLE

/turf/open/floor/light/off/white
	state = LIGHT_FLOOR_COLOR_WHITE

/turf/open/floor/light/broken
	icon_state = "light_broken"
	turf_flags = parent_type::turf_flags|TURF_BROKEN

/turf/open/floor/light/broken/red
	state = LIGHT_FLOOR_COLOR_RED

/turf/open/floor/light/broken/green
	state = LIGHT_FLOOR_COLOR_GREEN

/turf/open/floor/light/broken/yellow
	state = LIGHT_FLOOR_COLOR_YELLOW

/turf/open/floor/light/broken/purple
	state = LIGHT_FLOOR_COLOR_PURPLE

/turf/open/floor/light/broken/white
	state = LIGHT_FLOOR_COLOR_WHITE

#undef LIGHT_FLOOR_COLOR_BLUE
#undef LIGHT_FLOOR_COLOR_RED
#undef LIGHT_FLOOR_COLOR_GREEN
#undef LIGHT_FLOOR_COLOR_YELLOW
#undef LIGHT_FLOOR_COLOR_PURPLE
#undef LIGHT_FLOOR_COLOR_WHITE
