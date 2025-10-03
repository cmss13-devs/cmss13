/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	material = MATERIAL_WOOD
	anchored = FALSE
	layer = BETWEEN_OBJECT_ITEM_LAYER

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/coffin/uscm
	name = "\improper USCM coffin"
	desc = "A burial receptacle for dearly departed Marines, adorned in red and finished with the Corps' emblem on the interior. Semper fi."
	icon_state = "uscm_coffin"
	icon_closed = "uscm_coffin"
	icon_opened = "uscm_coffin_open"

/obj/structure/closet/coffin/predator
	name = "strange coffin"
	desc = "It's a burial receptacle for the dearly departed. Seems to have weird markings on the side..?"
	icon_state = "pred_coffin"
	icon_closed = "pred_coffin"
	icon_opened = "pred_coffin_open"

	open_sound = 'sound/effects/stonedoor_openclose.ogg'
	close_sound = 'sound/effects/stonedoor_openclose.ogg'

/// Ancient Stone Sarcophagus

/obj/structure/closet/coffin/predator/ancient_stone
	name = "ancient stone sarcophagus"
	desc = "A colossal stone sarcophagus, its surface scarred with the glyphs of the Hunt. Time and tradition have sealed whatever lies within..."
	icon = 'icons/obj/structures/props/hunter/sarcophagus.dmi'
	icon_state = "ancient_coffin"
	icon_closed = "ancient_coffin"
	icon_opened = "ancient_coffin_open"
	anchored = TRUE

	open_sound = 'sound/effects/stonedoor_openclose.ogg'
	close_sound = 'sound/effects/stonedoor_openclose.ogg'

/obj/structure/closet/coffin/predator/ancient_stone/deco
	icon_state = "ancient_coffin_deco"
	icon_closed = "ancient_coffin_deco"
	icon_opened = "ancient_coffin_deco_open"

/obj/structure/closet/coffin/predator/ancient_stone/mummy
	icon_state = "ancient_coffin"
	icon_closed = "ancient_coffin"
	icon_opened = "ancient_coffin_mumified_open"

/obj/structure/closet/coffin/predator/ancient_stone/mummy/deco
	icon_state = "ancient_coffin_deco"
	icon_closed = "ancient_coffin_deco"
	icon_opened = "ancient_coffin_mumified_deco_open"

/obj/structure/closet/coffin/woodencrate //Subtyped here so Req doesn't sell them
	name = "wooden crate"
	desc = "A wooden crate. Shoddily assembled, spacious and worthless on the ASRS"
	icon_state = "closed_woodcrate"
	icon_opened = "open_woodcrate"
	icon_closed = "closed_woodcrate"
	material = MATERIAL_WOOD
	store_mobs = FALSE
	climbable = TRUE
	throwpass = 1
