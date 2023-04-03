/turf/open/floor/light
	name = "light floor"
	desc = "Beware of breakdancing on these tiles, glass shards embedded in the head is not a fun time."
	tile_type = /obj/item/stack/tile/light
	var/on = TRUE
	var/state = 0

/turf/open/floor/light/is_light_floor()
	return TRUE

/turf/open/floor/light/update_icon()
	. = ..()
	if(on && !broken) //manages color, I feel like this switch is a sin.
		switch(state)
			if(0)
				icon_state = "light_on"
				SetLuminosity(5)
			if(1)
				icon_state = "light_on-r"
				SetLuminosity(5)
			if(2)
				icon_state = "light_on-g"
				SetLuminosity(5)
			if(3)
				icon_state = "light_on-y"
				SetLuminosity(5)
			if(4)
				icon_state = "light_on-p"
				SetLuminosity(5)
			if(5,-1)
				icon_state = "light_on-w"
				SetLuminosity(5)
				state = -1
			else
				return //Should never happen ever but what if... returns into the other else which close the light

	else if(broken)
		icon_state = "light_broken" //It's the same sprite as light off, my artistic skill stops at stickmans anyone feel free to make a better one!
		SetLuminosity(0)
	else
		icon_state = "light_off"
		SetLuminosity(0)
		on = FALSE

/turf/open/floor/light/attackby(obj/item/item_in_hand, mob/user)
	. = ..()
	if(istype(item_in_hand, /obj/item/light_bulb/bulb)) //changing the light by smacking a bulb on it, voices in my head told me to be kind and not reset the state
		if(broken)
			qdel(item_in_hand)
			broken = FALSE
			update_icon()
			playsound(src, 'sound/machines/click.ogg', 25, 1)
			to_chat(user, SPAN_NOTICE("You replace the light bulb."))
		else
			to_chat(user, SPAN_NOTICE("The lightbulb seems fine, no need to replace it."))
		return

	if(istype(item_in_hand, /obj/item/device/multitool)) //changing the light color with multitool, can't do if bulb broken, can do while it's off
		if(!broken)
			state++
			update_icon()
			to_chat(user, SPAN_NOTICE("You alter the glass panel's settings, changing its color."))
		else
			to_chat(user, SPAN_NOTICE("The bulb inside is shattered, you should get a new one before tuning it."))


/turf/open/floor/light/attack_hand(mob/user as mob) //turning the light on and off
	if(!broken)
		on = !on
		update_icon()
		to_chat(user, SPAN_NOTICE("You turn the light [on ? "on" : "off"]."))
	else
		to_chat(user, SPAN_NOTICE("It looks like the bulb inside has been shattered, you should think about replacing it.")) //if the light is broken and you try to turn it off and on

	return ..()

/turf/open/floor/light/attack_alien(mob/living/carbon/xenomorph/xeno_attacker) //Xeno breaking light, this makes them basically flashlight that needs a new bulb to go back on
	if(!broken)
		playsound(src, "windowshatter", 25, 1)
		xeno_attacker.animation_attack_on(src)
		xeno_attacker.visible_message(SPAN_DANGER("\The [xeno_attacker] smashes \the [src]!"), \
		SPAN_DANGER("You smash \the [src]!"), \
		SPAN_DANGER("You hear broken glass!"), 5)
		broken = TRUE
		update_icon()
		return XENO_ATTACK_ACTION
