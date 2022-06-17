/turf/open/floor/light
	name = "light floor"
	desc = "Beware of breakdancing on these tiles, glass shards embedded in the head is not a fun time."
	var/on = FALSE
	var/state = 0

/turf/open/floor/light/is_light_floor()
	return TRUE

/turf/open/floor/light/update_icon()
	. = ..()
	if(on)
		switch(state)
			if(0)
				icon_state = "light_on"
				SetLuminosity(5)
			if(1)
				var/num = pick("1", "2", "3", "4")
				icon_state = "light_on_flicker[num]"
				SetLuminosity(5)
			if(2)
				icon_state = "light_on_broken"
				SetLuminosity(5)
			if(3)
				icon_state = "light_off"
				SetLuminosity(0)
	else
		SetLuminosity(0)
		icon_state = "light_off"

/turf/open/floor/light/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/light_bulb/bulb))
		if(state)
			qdel(C)
			state = C //Fixing it by bashing it with a light bulb, fun eh?
			update_icon()
			to_chat(user, SPAN_NOTICE("You replace the light bulb."))
		else
			to_chat(user, SPAN_NOTICE("The lightbulb seems fine, no need to replace it."))
		return
	return ..()
