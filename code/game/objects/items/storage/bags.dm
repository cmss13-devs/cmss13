/*
 * These absorb the functionality of the plant bag, ore satchel, etc.
 * They use the use_to_pickup, quick_gather, and quick_empty functions
 * that were already defined in weapon/storage, but which had been
 * re-implemented in other classes.
 *
 * Contains:
 * Trash Bag
 * Mining Satchel
 * Plant Bag
 * Sheet Snatcher
 * Cash Bag
 *
 * -Sayu
 */

//  Generic non-item
/obj/item/storage/bag
	storage_flags = STORAGE_FLAGS_BAG
	flags_equip_slot = SLOT_WAIST

// -----------------------------
//   Trash bag
// -----------------------------
/obj/item/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashbag0"
	item_state = "trashbag"

	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	storage_slots = null
	max_storage_space = 21 //equivalent to an IMP backpack
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear, /obj/item/weapon/throwing_knife)

	storage_flags = STORAGE_GATHER_SIMULTAENOUSLY|STORAGE_QUICK_GATHER|STORAGE_CLICK_GATHER
	flags_equip_slot = NONE

/obj/item/storage/bag/trash/update_icon()
	var/sum_storage_cost = 0
	for(var/obj/item/item in contents)
		sum_storage_cost += item.get_storage_cost()

	if(!sum_storage_cost)
		icon_state = "trashbag0"
	else if(sum_storage_cost < floor(max_storage_space * 0.35))
		icon_state = "trashbag1"
	else if(sum_storage_cost < floor(max_storage_space * 0.7))
		icon_state = "trashbag2"
	else
		icon_state = "trashbag3"

// -----------------------------
// Plastic Bag
// -----------------------------

/obj/item/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/items/trash.dmi'
	icon_state = "plasticbag"
	item_state = "plasticbag"

	w_class = SIZE_LARGE
	max_w_class = SIZE_SMALL
	storage_slots = 21
	can_hold = list() // any
	cant_hold = list(/obj/item/disk/nuclear, /obj/item/weapon/throwing_knife)

// -----------------------------
// Mining Satchel
// -----------------------------

/obj/item/storage/bag/ore
	name = "Mining Satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "satchel"
	flags_equip_slot = SLOT_WAIST|SLOT_STORE
	w_class = SIZE_MEDIUM
	storage_slots = 50
	max_storage_space = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * ore.w_class
	max_w_class = SIZE_MEDIUM
	storage_flags = STORAGE_FLAGS_BAG | STORAGE_CONTENT_NUM_DISPLAY
	can_hold = list(/obj/item/ore)


// -----------------------------
//   Plant bag
// -----------------------------

/obj/item/storage/bag/plants
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "plantbag"
	name = "Plant Bag"
	storage_slots = 50; //the number of plant pieces it can carry.
	max_storage_space = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * plants.w_class
	max_w_class = SIZE_MEDIUM
	w_class = SIZE_SMALL
	storage_flags = STORAGE_FLAGS_BAG | STORAGE_CONTENT_NUM_DISPLAY
	can_hold = list(
		/obj/item/reagent_container/food/snacks/grown,
		/obj/item/seeds,
		/obj/item/grown,
	)


// -----------------------------
// Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/storage/bag/sheetsnatcher
	icon = 'icons/obj/structures/props/mining.dmi'
	icon_state = "sheetsnatcher"
	name = "Sheet Snatcher"
	desc = "A patented Yutani storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = SIZE_MEDIUM

	storage_flags = STORAGE_FLAGS_BAG | STORAGE_CONTENT_NUM_DISPLAY

/obj/item/storage/bag/sheetsnatcher/Initialize()
	. = ..()

/obj/item/storage/bag/sheetsnatcher/can_be_inserted(obj/item/W, mob/user, stop_messages = FALSE)
	if(!istype(W,/obj/item/stack/sheet) || istype(W,/obj/item/stack/sheet/mineral/sandstone) || istype(W,/obj/item/stack/sheet/wood))
		if(!stop_messages)
			to_chat(usr, "The snatcher does not accept [W].")
		return 0 //I don't care, but the existing code rejects them for not being "sheets" *shrug* -Sayu
	var/current = 0
	for(var/obj/item/stack/sheet/S in contents)
		current += S.amount
	if(capacity == current)//If it's full, you're done
		if(!stop_messages)
			to_chat(usr, SPAN_DANGER("The snatcher is full."))
		return 0
	return 1


// Modified handle_item_insertion & _item_insertion.  Would prefer not to, but...
/obj/item/storage/bag/sheetsnatcher/handle_item_insertion(obj/item/W, prevent_warning = 0, mob/user)
	var/obj/item/stack/sheet/S = W
	if(!istype(S)) return 0

	var/amount
	var/inserted = 0
	var/current = 0
	for(var/obj/item/stack/sheet/S2 in contents)
		current += S2.amount
	if(capacity < current + S.amount)//If the stack will fill it up
		amount = capacity - current
	else
		amount = S.amount

	for(var/obj/item/stack/sheet/sheet in contents)
		if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
			sheet.amount += amount // they should only be removed through procs in this file, which split them up.
			S.amount -= amount
			inserted = 1
			break

	if(!inserted || !S.amount)
		if(user && W.loc == user)
			user.temp_drop_inv_item(S)
		if(!S.amount)
			qdel(S)
		else
			S.forceMove(src)

	orient2hud()
	for(var/mob/M in can_see_content())
		show_to(M)

	update_icon()
	return 1


// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken

//Turned numbered display on. Appears to work as intended, despite above comment -- Vanagandr.

/obj/item/storage/bag/sheetsnatcher/orient2hud()
	var/adjusted_contents = length(contents)

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if (storage_flags & STORAGE_CONTENT_NUM_DISPLAY)
		numbered_contents = list()
		adjusted_contents = 0
		for (var/obj/item/stack/sheet/I in contents)
			adjusted_contents++
			var/datum/numbered_display/D = new/datum/numbered_display(I)
			D.number = I.amount
			numbered_contents.Add( D )

	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (adjusted_contents > 7)
		row_num = floor((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	slot_orient_objs(row_num, col_count, numbered_contents)
	return


// Modified quick_empty verb drops appropriate sized stacks
/obj/item/storage/bag/sheetsnatcher/empty(mob/user)
	var/location = get_turf(src)
	for(var/obj/item/stack/sheet/S in contents)
		while(S.amount)
			var/obj/item/stack/sheet/N = new S.type(location)
			var/stacksize = min(S.amount,N.max_amount)
			N.amount = stacksize
			S.amount -= stacksize
		if(!S.amount)
			qdel(S) // todo: there's probably something missing here
	storage_close(user)
	update_icon()

// modified remove_from_storage and _item_removal.
/obj/item/storage/bag/sheetsnatcher/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/stack/sheet/S = W
	if(!istype(S)) return 0

	//I would prefer to drop a new stack, but the item/attack_hand code
	// that calls this can't receive a different object than you clicked on.
	//Therefore, make a new stack internally that has the remainder.
	// -Sayu

	if(S.amount > S.max_amount)
		var/obj/item/stack/sheet/temp = new S.type(src)
		temp.amount = S.amount - S.max_amount
		S.amount = S.max_amount

	return ..(S,new_location)

// -----------------------------
// Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/bag/sheetsnatcher/borg
	name = "Sheet Snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization

// -----------------------------
//    Cash Bag
// -----------------------------

/obj/item/storage/bag/cash
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "cashbag"
	name = "Cash bag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	storage_slots = 50; //the number of cash pieces it can carry.
	max_storage_space = 200 //Doesn't matter what this is, so long as it's more or equal to storage_slots * cash.w_class
	max_w_class = SIZE_MEDIUM
	w_class = SIZE_SMALL
	can_hold = list(/obj/item/coin,/obj/item/spacecash)
