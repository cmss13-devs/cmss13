//Pairing of an item and box that contains a number of a given item
/datum/item_box_pairing
	var/obj/item/item
	var/obj/item/box
	var/items_in_box

//You can have the same item in multiple boxes though...
/datum/item_to_multiple_box_pairing
	var/obj/item/item
	var/list/datum/item_box_pairing/item_box_pairings = list()

//A set of lists that tracks items and their equivalent boxes and vice versa
/datum/item_to_box_mapping
	var/list/item_to_box_list = list()
	var/list/box_to_item_list = list()

/datum/item_to_box_mapping/proc/Init()
	for(var/obj/item/ammo_box/magazine/AB as anything in typesof(/obj/item/ammo_box/magazine))
		if(initial(AB.empty))
			//Ignore all the empty boxes
			continue
		var/datum/item_box_pairing/ibp = new()
		ibp.box = AB
		ibp.item = initial(AB.magazine_type)
		if(!ibp.item)
			//if the item is null somehow
			continue
		ibp.items_in_box = initial(AB.num_of_magazines)
		box_to_item_list[ibp.box] = ibp
		if(!item_to_box_list[ibp.item])
			item_to_box_list[ibp.item] = new /datum/item_to_multiple_box_pairing()
			item_to_box_list[ibp.item].item = ibp.item
		item_to_box_list[ibp.item].item_box_pairings += ibp
	..()

/datum/item_to_box_mapping/proc/get_item_to_box_mapping(var/I)
	return item_to_box_list[I]

/datum/item_to_box_mapping/proc/get_box_to_item_mapping(var/I)
	return box_to_item_list[I]


/proc/init_item_to_box_mapping()
	var/datum/item_to_box_mapping/I = new()
	I.Init()
	return I


/client/verb/debug_verb()
	set name = "DEBUG"
	set category = "DEBUG"

	to_world("[GLOB.item_to_box_mapping.item_to_box_list.len]")
	var/datum/item_to_multiple_box_pairing/IBP = GLOB.item_to_box_mapping.get_item_to_box_mapping(/obj/item/ammo_magazine/rifle)

	to_world("IBP - [IBP]")
	if(IBP)
		to_world("[IBP.item], [IBP.item_box_pairings.len]")
		for(var/datum/item_box_pairing/I in IBP.item_box_pairings)
			to_world("[I.item], [I.box], [I.items_in_box]")
