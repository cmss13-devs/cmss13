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
	var/list/datum/item_to_multiple_box_pairing/item_to_box_list = list()
	var/list/datum/item_box_pairing/box_to_item_list = list()

//Adding an item-box pairing
/datum/item_to_box_mapping/proc/add_pairing(datum/item_box_pairing/item_box_pairing)
	//Box always maps to one item
	box_to_item_list[item_box_pairing.box] = item_box_pairing

	//BUT an item can be in many boxes
	if(!item_to_box_list[item_box_pairing.item])
		//Create a new structure holding a list of boxes for the given item
		item_to_box_list[item_box_pairing.item] = new /datum/item_to_multiple_box_pairing()
		item_to_box_list[item_box_pairing.item].item = item_box_pairing.item
	//Add ONE mapping of item to a box, there may be more later...
	item_to_box_list[item_box_pairing.item].item_box_pairings += item_box_pairing

/datum/item_to_box_mapping/New()
	//Ammo magazine boxes, minus loose ammo boxes
	for(var/obj/item/ammo_box/magazine/ammo_box as anything in typesof(/obj/item/ammo_box/magazine) - /obj/item/ammo_box/magazine/misc - /obj/item/ammo_box/magazine/shotgun/light)
		if(initial(ammo_box.empty))
			//Ignore all the empty boxes
			continue
		var/datum/item_box_pairing/item_box_pairing = new()
		item_box_pairing.box = ammo_box
		item_box_pairing.item = initial(ammo_box.magazine_type)
		if(!item_box_pairing.item)
			//if the item is null somehow
			continue
		if(initial(ammo_box.handfuls))
			//If we are using handfuls we need to do some wonky conversion
			item_box_pairing.items_in_box = initial(ammo_box.num_of_magazines) / initial(ammo_box.magazine_type.max_rounds)
		else
			item_box_pairing.items_in_box = initial(ammo_box.num_of_magazines)
		add_pairing(item_box_pairing)

	//Grenade packets
	for(var/obj/item/storage/box/packet/ammo_box as anything in typesof(/obj/item/storage/box/packet))
		if(!initial(ammo_box.content_type))
			//Ignore all the empty boxes
			continue
		var/datum/item_box_pairing/item_box_pairing = new()
		item_box_pairing.box = ammo_box
		item_box_pairing.item = initial(ammo_box.content_type)
		if(!item_box_pairing.item)
			//if the item is null somehow
			continue
		item_box_pairing.items_in_box = initial(ammo_box.storage_slots)
		add_pairing(item_box_pairing)

	//Big grenade boxes
	for(var/obj/item/storage/box/nade_box/ammo_box as anything in typesof(/obj/item/storage/box/nade_box))
		if(!initial(ammo_box.grenade_type))
			//Ignore all the empty boxes
			continue
		var/datum/item_box_pairing/item_box_pairing = new()
		item_box_pairing.box = ammo_box
		item_box_pairing.item = initial(ammo_box.grenade_type)
		if(!item_box_pairing.item)
			//if the item is null somehow
			continue
		item_box_pairing.items_in_box = initial(ammo_box.storage_slots)
		add_pairing(item_box_pairing)

	//*******Snowflakes*******//
	//Mine box
	var/datum/item_box_pairing/item_box_pairing = new()
	item_box_pairing.box = /obj/item/storage/box/explosive_mines
	item_box_pairing.item = /obj/item/explosive/mine
	item_box_pairing.items_in_box = 5
	add_pairing(item_box_pairing)

	..()

//For fetching item->boxes mapping
/datum/item_to_box_mapping/proc/get_item_to_box_mapping(I)
	return item_to_box_list[I]

//For fetching box->item mapping
/datum/item_to_box_mapping/proc/get_box_to_item_mapping(I)
	return box_to_item_list[I]


/proc/init_item_to_box_mapping()
	var/datum/item_to_box_mapping/I = new()
	return I
