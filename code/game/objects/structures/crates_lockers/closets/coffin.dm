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

/obj/structure/closet/coffin/attackby(obj/item/W, mob/living/user)
	if(src.opened)
		if(istype(W, /obj/item/grab))
			if(isXeno(user)) return
			var/obj/item/grab/G = W
			if(G.grabbed_thing)
				src.MouseDrop_T(G.grabbed_thing, user)      //act like they were dragged onto the closet
			return
		if(W.flags_item & ITEM_ABSTRACT)
			return 0
		if(istype(W, /obj/item/tool/weldingtool))
			var/obj/item/tool/weldingtool/WT = W
			if(!WT.remove_fuel(0,user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return
			new /obj/item/stack/sheet/wood(src.loc)
			for(var/mob/M in viewers(src))
				M.show_message(SPAN_NOTICE("\The [src] has been cut apart by [user] with [WT]."), 3, "You hear welding.", 2)
			qdel(src)
			return
		if(isrobot(user))
			return
		user.drop_inv_item_to_loc(W,loc)

	else if(istype(W, /obj/item/packageWrap))
		return
	else if(istype(W, /obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(!WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
		welded = !welded
		update_icon()
		for(var/mob/M in viewers(src))
			M.show_message(SPAN_WARNING("[src] has been [welded?"welded shut":"unwelded"] by [user.name]."), 3, "You hear welding.", 2)
	else
		src.attack_hand(user)
	return


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
