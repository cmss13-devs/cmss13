/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"
	anchored = 0

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/coffin/attackby(obj/item/Prybar, mob/living/user)
	if(istype(Prybar, /obj/item/tool/crowbar))
		var/obj/item/tool/crowbar/CrB = Prybar
		new /obj/item/stack/sheet/wood(src.loc)
		for(var/mob/Mob in viewers(src))
			Mob.show_message(SPAN_NOTICE("\The [src] has been wrenched apart by [user] with [CrB]."), 3, "You hear wood breaking.", 2)
		qdel(src)
		return
	if(isrobot(user))
		return
	user.drop_inv_item_to_loc(Prybar,loc)

/obj/structure/closet/coffin/predator
	name = "strange coffin"
	desc = "It's a burial receptacle for the dearly departed. Seems to have weird markings on the side..?"
	icon_state = "pred_coffin"
	icon_closed = "pred_coffin"
	icon_opened = "pred_coffin_open"

	open_sound = 'sound/effects/stonedoor_openclose.ogg'
	close_sound = 'sound/effects/stonedoor_openclose.ogg'


/obj/structure/closet/coffin/woodencrate //Subtyped here so Req doesn't sell them
	name = "wooden crate"
	desc = "A wooden crate. Shoddily assembled, spacious and worthless on the ASRS"
	icon_state = "closed_woodcrate"
	icon_opened = "open_woodcrate"
	icon_closed = "closed_woodcrate"
	store_mobs = FALSE
	climbable = TRUE
	throwpass = 1
