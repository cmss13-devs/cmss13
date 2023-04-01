/obj/item/prop
	name = "prop"
	desc = "Some kind of prop."

/obj/item/prop/laz_top
	name = "lazertop"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "laptop-gun"
	item_state = ""
	desc = "A Rexim RXF-M5 EVA pistol compressed down into a laptop! Also known as the Laz-top. Part of a line of discreet assassination weapons developed for Greater Argentina and the United States covert programs respectively."
	w_class = SIZE_SMALL
	garbage = TRUE

/obj/item/prop/tableflag
	name = "United Americas table flag"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "uaflag"
	force = 0.5
	w_class = SIZE_SMALL
	desc = "A miniature table flag of the United Americas, representing all of North, South, and Central America."

/obj/item/prop/tableflag/uscm
	name = "USCM table flag"
	icon_state = "uscmflag"
	desc = "A miniature table flag of the United States Colonial Marines. 'Semper Fi' is written on the flag's bottom."

/obj/item/prop/tableflag/uscm2
	name = "USCM historical table flag"
	icon_state = "uscmflag2"
	desc = "A miniature historical table flag of the United States Colonial Marines, in traditional scarlet and gold. The USCM logo sits in the center; an eagle is perched atop it and an anchor rests behind it."

/obj/item/prop/flower_vase
	name = "flower vase"
	icon_state = "flowervase"
	w_class = SIZE_SMALL
	desc = "An empty glass flower vase."

/obj/item/prop/flower_vase/bluewhiteflowers
	name = "vase of blue and white flowers"
	icon_state = "bluewhiteflowers"
	desc = "A flower vase filled with blue and white roses."

/obj/item/prop/flower_vase/redwhiteflowers
	name = "vase of red and white flowers"
	icon_state = "redwhiteflowers"
	desc = "A flower vase filled with red and white roses."

/obj/item/prop/colony/usedbandage
	name = "dirty bandages"
	desc = "Some used gauze."
	icon_state = "bandages_prop"
	icon = 'icons/monkey_icos.dmi'

/obj/item/prop/colony/folded_bedroll
	name = "folded bedroll"
	desc = "a folded up bedroll"
	icon_state = "bedroll"
	icon = 'icons/monkey_icos.dmi'

/obj/item/prop/colony/used_flare
	name = "flare"
	desc = "A used USCM issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	icon_state = "flare-empty"
	icon = 'icons/obj/items/lighting.dmi'

/obj/item/prop/colony/canister
	name = "fuel can"
	desc = "A jerry can. In space! Or maybe a colony."
	icon_state = "canister"
	icon = 'icons/obj/items/tank.dmi'

/obj/item/prop/colony/proptag
	name = "information dog tag"
	desc = "A fallen marine's information dog tag. It reads,(BLANK)"
	icon_state = "dogtag_taken"
	icon = 'icons/obj/items/card.dmi'

/obj/item/prop/colony/game
	name = "portable game kit"
	desc = "A ThinkPad Systems Game-Bro Handheld (TSGBH, shortened). It can play chess, checkers, tri-d chess, and it also runs Byond! Except this one is out of batteries."
	icon_state = "game_kit"
	icon = 'icons/obj/items/items.dmi'

/// Xeno-specific props

/obj/item/prop/alien/hugger
	name = "????"
	desc = "It has some sort of a tube at the end of its tail. What the hell is this thing?"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "facehugger_impregnated"
