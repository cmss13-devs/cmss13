/obj/structure/sign/double/barsign
	icon = 'icons/obj/structures/props/wall_decorations/barsigns.dmi'
	icon_state = "empty"
	anchored = TRUE

/obj/structure/sign/double/barsign/New()
	..()
	ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum", "meadbay", "thedamnwall", "thecavern", "cindikate", "theorchard", "thesaucyclown", "theclownshead", "whiskeyimplant", "carpecarp", "robustroadhouse", "greytide", "theredshirt"))
	return

/obj/structure/sign/double/barsign/proc/ChangeSign(Text)
	src.icon_state = "[Text]"
	//on = 0
	//brightness_on = 4 //uncomment these when the lighting fixes get in
	return

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		var/obj/item/card/id/card = I
		if(ACCESS_CIVILIAN_PUBLIC in card.GetAccess())
			var/sign_type = tgui_input_list(user, "What would you like to change the barsign to?", "Bar Sign", list("Off", "Pink Flamingo", "Magma Sea", "Limbo", "Rusty Axe", "Armok Bar", "Broken Drum", "Mead Bay", "The Damn Wall", "The Cavern", "Cindi Kate", "The Orchard", "The Saucy Clown", "The Clowns Head", "Whiskey Implant", "Carpe Carp", "Robust Roadhouse", "Greytide", "The Redshirt"))
			if(sign_type == null)
				return
			else
				sign_type = replacetext(lowertext(sign_type), " ", "") // lowercase, strip spaces - along with choices for user options, avoids huge if-else-else
				src.ChangeSign(sign_type)
				to_chat(user, "You change the barsign.")
