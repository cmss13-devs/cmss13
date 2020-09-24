/obj/item/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

/obj/item/storage/pill_bottle/dice/Initialize()
		..()
		new /obj/item/toy/dice( src )
		new /obj/item/toy/dice/d20( src )

/*
 * Donut Box
 */

/obj/item/storage/donut_box
	icon = 'icons/obj/items/food.dmi'
	icon_state = "donutbox"
	name = "\improper Yum! donuts"
	desc = "A box of mouth watering \"<i>Yum!</i>\" brand donuts."
	storage_slots = 6
	var/startswith = 6
	var/open = 0
	can_hold = list(/obj/item/reagent_container/food/snacks/donut)
	foldable = /obj/item/stack/sheet/cardboard

/obj/item/storage/donut_box/Initialize()
	. = ..()
	for(var/i=1; i <= startswith; i++)
		new /obj/item/reagent_container/food/snacks/donut/normal(src)
	update_icon()
	return

/obj/item/storage/donut_box/attack_self(mob/user as mob)
	var/message = "You [open ? "close [src]. Another time, then." : "open [src]. Mmmmm... donuts."]"
	to_chat(user, message)
	open = !open
	update_icon()
	if(!contents.len)
		..()
	return

/obj/item/storage/donut_box/update_icon()
	overlays.Cut()
	if(!open)
		icon_state = "donutbox"
		return
	icon_state = "donutbox_o"
	var/i = 0
	for(var/obj/item/reagent_container/food/snacks/donut/D in contents)
		i++
		var/image/img = image('icons/obj/items/food.dmi', "[D.overlay_state]-[i]")
		overlays += img

/obj/item/storage/donut_box/empty
	icon_state = "donutbox_o"
	startswith = 0

/*
 * Mateba Case
 */

/obj/item/storage/mateba_case
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "matebacase"
	name = "mateba customization kit case"
	desc = "A wooden case used for storing the tools and parts needed to customize a mateba revolver. Comes with three barrel lengths and the necessary key to swap them out."
	storage_slots = 4
	can_hold = list(/obj/item/attachable/mateba, /obj/item/weapon/gun/revolver/mateba, /obj/item/weapon/mateba_key)

/obj/item/storage/mateba_case/Initialize()
	. = ..()
	new /obj/item/attachable/mateba/short(src)
	new /obj/item/attachable/mateba/long(src)
	new /obj/item/weapon/mateba_key(src)



//6 pack

/obj/item/storage/beer_pack
	name = "beer pack"
	desc = "A pack of Aspen beer cans."
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "6_pack_6"
	item_state = "souto_classic"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/food/drinks/cans/aspen)

/obj/item/storage/beer_pack/Initialize()
	. = ..()
	for(var/i in 1 to 6)
		new /obj/item/reagent_container/food/drinks/cans/aspen(src)

/obj/item/storage/beer_pack/update_icon()
	if(contents.len == 1)
		var/turf/T = get_turf(src)
		var/obj/item/reagent_container/food/drinks/cans/aspen/B = new(T)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.temp_drop_inv_item(src)
			H.put_in_inactive_hand(B)
		qdel(src)
	else
		icon_state = "6_pack_[contents.len]"
