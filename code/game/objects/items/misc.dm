/obj/item/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "red_phone"
	force = 3.0
	throwforce = 2.0
	throw_speed = SPEED_FAST
	throw_range = 4
	w_class = SIZE_SMALL
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = SIZE_TINY
	throwforce = 0
	throw_speed = SPEED_VERY_FAST
	throw_range = 20

/obj/item/bananapeel/Crossed(AM as mob|obj)
	if (iscarbon(AM))
		var/mob/living/carbon/C = AM
		C.slip(name, 4, 2)

/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	flags_atom = FPRINT|CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = SIZE_SMALL
	matter = list("metal" = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")



/*
/obj/item/game_kit
	name = "Gaming Kit"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = SIZE_HUGE
*/

/obj/item/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = SIZE_LARGE

/obj/item/staff/gentcane
	name = "Gentlemans Cane"
	desc = "An ebony cane with an ivory tip."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"

/obj/item/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/items/weapons/weapons.dmi'
	icon_state = "stick"
	item_state = "stick"
	force = 3.0
	throwforce = 5.0
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_SMALL
	flags_item = NOSHIELD

/obj/item/research//Makes testing much less of a pain -Sieve
	name = "research"
	icon = 'icons/obj/items/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "A debug item for research."
	
/obj/item/moneybag
	icon = 'icons/obj/items/storage.dmi'
	name = "Money bag"
	icon_state = "moneybag"
	force = 10.0
	throwforce = 2.0
	w_class = SIZE_LARGE





/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "evidenceobj"
	item_state = ""
	w_class = SIZE_SMALL
	var/obj/item/stored_item = null

/obj/item/evidencebag/MouseDrop(var/obj/item/I as obj)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr

	if (!(user.l_hand == src || user.r_hand == src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage))	//in a container.
			var/sdepth = I.storage_depth(user)
			if (sdepth == -1 || sdepth > 1)
				return	//too deeply nested to access

			var/obj/item/storage/U = I.loc
			user.client.screen -= I
			U.contents.Remove(I)
		else if(user.l_hand == I)					//in a hand
			user.drop_l_hand()
		else if(user.r_hand == I)					//in a hand
			user.drop_r_hand()
		else
			return

	if(!istype(I) || I.anchored)
		return

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, SPAN_NOTICE("You find putting an evidence bag in another evidence bag to be slightly absurd."))
		return

	if(I.w_class > SIZE_MEDIUM)
		to_chat(user, SPAN_NOTICE("[I] won't fit in [src]."))
		return

	if(contents.len)
		to_chat(user, SPAN_NOTICE("[src] already has something inside it."))
		return

	user.visible_message("[user] puts [I] into [src]", "You put [I] inside [src].",\
	"You hear a rustle as someone puts something into a plastic bag.")

	icon_state = "evidence"

	var/xx = I.pixel_x	//save the offset of the item
	var/yy = I.pixel_y
	I.pixel_x = 0		//then remove it so it'll stay within the evidence bag
	I.pixel_y = 0
	var/image/img = image("icon"=I, "layer"=FLOAT_LAYER)	//take a snapshot. (necessary to stop the underlays appearing under our inventory-HUD slots ~Carn
	I.pixel_x = xx		//and then return it
	I.pixel_y = yy
	overlays += img
	overlays += "evidence"	//should look nicer for transparent stuff. not really that important, but hey.

	desc = "An evidence bag containing [I]."
	I.loc = src
	stored_item = I
	w_class = I.w_class
	return


/obj/item/evidencebag/attack_self(mob/user as mob)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src]", "You take [I] out of [src].",\
		"You hear someone rustle around in a plastic bag, and remove something.")
		overlays.Cut()	//remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."
	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return

/obj/item/evidencebag/examine(mob/user)
	..()
	if (stored_item) stored_item.examine(user)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."

/obj/item/storage/box/evidence/New()
	..()
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
	new /obj/item/evidencebag(src)
