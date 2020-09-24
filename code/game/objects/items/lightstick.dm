

//Lightsticks----------
//Blue
/obj/item/lightstick
	name = "blue lightstick"
	desc = "You can stick them in the ground"
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "lightstick_blue0"
	var/s_color = "blue"

	Crossed(var/mob/living/O)
		if(anchored && prob(20))
			if(!istype(O,/mob/living/carbon/Xenomorph/Larva))
				visible_message(SPAN_DANGER("[O] tramples the [src]!"))
				playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
				if(istype(O,/mob/living/carbon/Xenomorph))
					if(prob(40))
						qdel(src)
					else
						anchored = 0
						icon_state = "lightstick_[s_color][anchored]"
						SetLuminosity(0)
						pixel_x = 0
						pixel_y = 0
				else
					anchored = 0
					icon_state = "lightstick_[s_color][anchored]"
					SetLuminosity(0)
					pixel_x = 0
					pixel_y = 0

	//Removing from turf
	attack_hand(mob/user)
		..()
		if(!anchored)//If planted
			return

		to_chat(user, "You start pulling out \the [src].")
		if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			return

		anchored = 0
		user.visible_message("[user.name] removes \the [src] from the ground.","You remove the [src] from the ground.")
		icon_state = "lightstick_[s_color][anchored]"
		SetLuminosity(0)
		pixel_x = 0
		pixel_y = 0
		playsound(user, 'sound/weapons/Genhit.ogg', 25, 1)

	//Remove lightsource
/obj/item/lightstick/Destroy()
	SetLuminosity(0)
	return ..()

//Red
/obj/item/lightstick/red
	name = "red lightstick"
	icon_state = "lightstick_red0"
	s_color = "red"
