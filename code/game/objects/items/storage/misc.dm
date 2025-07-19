/obj/item/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

/obj/item/storage/pill_bottle/dice/fill_preset_inventory()
		new /obj/item/toy/dice( src )
		new /obj/item/toy/dice/d20( src )

/*
 * Donut Box
 */

/obj/item/storage/donut_box
	icon = 'icons/obj/items/food/donuts.dmi'
	icon_state = "donutbox"
	name = "\improper Yum! donuts"
	desc = "A box of mouth-watering \"<i>Yum!</i>\" brand donuts."
	storage_slots = 6
	var/startswith = 6
	var/open = 0
	can_hold = list(/obj/item/reagent_container/food/snacks/donut)
	foldable = /obj/item/stack/sheet/cardboard

/obj/item/storage/donut_box/fill_preset_inventory()
	for(var/i=1; i <= startswith; i++)
		new /obj/item/reagent_container/food/snacks/donut/normal(src)

/obj/item/storage/donut_box/attack_self(mob/user as mob)
	var/message = "You [open ? "close [src]. Another time, then." : "open [src]. Mmmmm... donuts."]"
	to_chat(user, message)
	open = !open
	update_icon()
	if(!length(contents))
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
		var/image/img = image('icons/obj/items/food/donuts.dmi', "[D.overlay_state]-[i]")
		overlays += img

/obj/item/storage/donut_box/empty
	icon_state = "donutbox_o"
	startswith = 0

/*
 * Mateba Case
 */

/obj/item/storage/mateba_case
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "matebacase"
	name = "mateba customization kit case"
	desc = "A wooden case used for storing the tools and parts needed to customize a Mateba revolver. Comes with three barrel lengths and the necessary key to swap them out."
	storage_slots = 5
	can_hold = list(/obj/item/attachable/mateba, /obj/item/weapon/gun/revolver/mateba, /obj/item/weapon/mateba_key)

/obj/item/storage/mateba_case/captain/fill_preset_inventory()
	new /obj/item/attachable/mateba/short(src)
	new /obj/item/attachable/mateba(src)
	new /obj/item/attachable/mateba/long(src)
	new /obj/item/weapon/mateba_key(src)

/obj/item/storage/mateba_case/captain/council
	icon_state = "c_matebacase"
	name = "colonel's mateba customization kit case"
	desc = "A black-ebony case used for storing the tools and parts needed to customize a Mateba revolver. This variant is custom-made for colonels."

/obj/item/storage/mateba_case/general
	icon_state = "c_matebacase"
	name = "luxurious mateba customization kit case"
	desc = "A black-ebony case used for storing the tools and parts needed to customize a Mateba revolver. This variant is made for general-grade golden Matebas and comes with golden barrel attachments."

/obj/item/storage/mateba_case/general/fill_preset_inventory()
	new /obj/item/attachable/mateba/short/dark(src)
	new /obj/item/attachable/mateba/dark(src)
	new /obj/item/attachable/mateba/long/dark(src)
	new /obj/item/weapon/mateba_key(src)

//6 pack

/obj/item/storage/beer_pack
	name = "beer pack"
	desc = "A pack of Aspen beer cans."
	icon = 'icons/obj/items/food/drinkcans.dmi'
	icon_state = "6_pack_6"
	item_state = "souto_classic"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_container/food/drinks/cans/aspen)

/obj/item/storage/beer_pack/fill_preset_inventory()
	for(var/i in 1 to 6)
		new /obj/item/reagent_container/food/drinks/cans/aspen(src)

/obj/item/storage/beer_pack/update_icon()
	if(length(contents) == 1)
		var/turf/T = get_turf(src)
		var/obj/item/reagent_container/food/drinks/cans/aspen/B = new(T)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			H.temp_drop_inv_item(src)
			H.put_in_inactive_hand(B)
		qdel(src)
	else
		icon_state = "6_pack_[length(contents)]"

/obj/item/storage/box/clf
	name = "D18-storing box"
	desc = "A fairly decorated and ceremonial box containing a CLF D18 and a single additional magazine for it. I guess those CLF folk really care about their craftsmanship and prose rather than practicality, eh?"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "m43case"
	w_class = SIZE_SMALL
	max_w_class = SIZE_TINY
	storage_slots = 2
	can_hold = list(/obj/item/weapon/gun/pistol/clfpistol, /obj/item/ammo_magazine/pistol/clfpistol)

/obj/item/storage/box/clf/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/clfpistol(src)
	new /obj/item/ammo_magazine/pistol/clfpistol(src)

/obj/item/storage/box/upp //war trophy luger
	name = "Type 73 storing case"
	desc = "A small case containing the once-standard sidearm of the UPP, the Type 73, and two additional magazines. The contained sidearm is probably looted off a dead officer or from a captured stockpile, either way this thing is worth a pretty penny."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "matebacase"
	w_class = SIZE_MEDIUM
	max_w_class = SIZE_MEDIUM
	storage_slots = 3
	can_hold = list(/obj/item/weapon/gun/pistol/t73, /obj/item/ammo_magazine/pistol/t73)

/obj/item/storage/box/upp/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/t73(src)
	new /obj/item/ammo_magazine/pistol/t73(src)
	new /obj/item/ammo_magazine/pistol/t73(src)

/obj/item/storage/box/action
	name = "AC71 'Action' storing case"
	desc = "A small case containing an AC71 Action, a holdout pistol by Spearhead Armory. It was most likely brought by a marine from home, or taken from a colony without permission."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "m43case"
	w_class = SIZE_SMALL
	max_w_class = SIZE_TINY
	storage_slots = 3
	can_hold = list(/obj/item/weapon/gun/pistol/action, /obj/item/ammo_magazine/pistol/action)

/obj/item/storage/box/action/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/action(src)
	new /obj/item/ammo_magazine/pistol/action(src)
	new /obj/item/ammo_magazine/pistol/action(src)

/obj/item/storage/box/plinker
	name = "W62 'Whisper' storing case"
	desc = "A small case containing a W62 Whisper, a .22 ratkiller made by Spearhead Armory. It was most likely brought by a marine from home, or taken from a colony without permission."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "m43case"
	w_class = SIZE_MEDIUM
	max_w_class = SIZE_SMALL
	storage_slots = 3
	can_hold = list(/obj/item/weapon/gun/pistol/holdout, /obj/item/ammo_magazine/pistol/holdout)

/obj/item/storage/box/plinker/fill_preset_inventory()
	new /obj/item/weapon/gun/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol/holdout(src)
	new /obj/item/ammo_magazine/pistol/holdout(src)

/obj/item/storage/box/co2_knife
	name = "M8 cartridge bayonet packaging"
	desc = "Contains one M8 Cartridge Bayonet and two sister CO2 cartridges. Thanks for being a dedicated Boots magazine subscriber!"
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "co2_box"
	foldable = TRUE
	storage_slots = 3
	w_class = SIZE_SMALL
	max_w_class = SIZE_SMALL
	can_hold = list(/obj/item/attachable/bayonet/co2, /obj/item/co2_cartridge)

/obj/item/storage/box/co2_knife/fill_preset_inventory()
	new /obj/item/attachable/bayonet/co2(src)
	new /obj/item/co2_cartridge(src)
	new /obj/item/co2_cartridge(src)
