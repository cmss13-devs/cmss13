

//Lightsticks----------
//Blue
/obj/item/lightstick
	name = "blue lightstick"
	desc = "You can stick them in the ground"
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "lightstick_blue0"
	var/s_color = "blue"
	var/trample_chance = 30
	var/can_trample = TRUE

/obj/item/lightstick/Crossed(mob/living/O)
	if(anchored && prob(trample_chance) && can_trample)
		if(!istype(O,/mob/living/carbon/xenomorph/larva))
			visible_message(SPAN_DANGER("[O] tramples the [src]!"))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			if(istype(O,/mob/living/carbon/xenomorph))
				if(prob(40))
					deconstruct(FALSE)
				else
					anchored = FALSE
					icon_state = "lightstick_[s_color][anchored]"
					SetLuminosity(0)
					pixel_x = 0
					pixel_y = 0
			else
				anchored = FALSE
				icon_state = "lightstick_[s_color][anchored]"
				SetLuminosity(0)
				pixel_x = 0
				pixel_y = 0

	//Removing from turf
/obj/item/lightstick/attack_hand(mob/user)
	..()
	if(!anchored)//If planted
		return

	to_chat(user, "You start pulling out \the [src].")
	if(!do_after(user,20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return

	anchored = FALSE
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
/obj/item/lightstick/planted
	icon_state = "lightstick_blue1"
	anchored = TRUE
	luminosity = 2

/obj/item/lightstick/red
	name = "red lightstick"
	icon_state = "lightstick_red0"
	s_color = "red"

/obj/item/lightstick/red/planted
	icon_state = "lightstick_red1"
	anchored = TRUE
	luminosity = 2

/obj/item/lightstick/red/spoke
	name = "red lightstick"
	icon_state = "lightstick_spoke0"
	s_color = "red"
	can_trample = FALSE

/obj/item/lightstick/red/spoke/planted
	icon_state = "lightstick_spoke1"
	anchored = TRUE
	luminosity = 2

/obj/item/lightstick/red/variant
	name = "red lightstick"
	icon_state = "lightstick_red_variant0"
	s_color = "red"

/obj/item/lightstick/red/variant/planted
	icon_state = "lightstick_red_variant1"
	anchored = TRUE
	luminosity = 2

/obj/item/lightstick/variant //blue
	name = "blue lightstick"
	icon_state = "lightstick_blue_variant0"
	s_color = "blue"

/obj/item/lightstick/variant/planted
	icon_state = "lightstick_blue_variant1"
	anchored = TRUE
	luminosity = 2
