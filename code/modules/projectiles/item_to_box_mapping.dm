//Pairing of an item and box that contains a number of a given item
/datum/item_box_pairing
	var/obj/item/item
	var/obj/item/box
	var/items_in_box

//A set of lists that tracks items and their equivalent boxes and vice versa
/datum/item_to_box_mapping
	var/list/item_to_box_list = list()
	var/list/box_to_item_list = list()

/datum/item_to_box_mapping/proc/Init()
	for(var/I in typesof(/obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AB = new I()
		var/datum/item_box_pairing/ibp = new()
		ibp.box = AB
		ibp.item = AB.magazine_type
		ibp.items_in_box = AB.num_of_magazines
		item_to_box_list[ibp.item] = ibp
		box_to_item_list[ibp.box] = ibp
	..()

/proc/init_item_to_box_mapping()
	var/datum/item_to_box_mapping/I = new()
	I.Init()
	return I