//switch this out to use a database at some point
//list of ckey/ real_name and item paths
//gives item to specific people when they join if it can
//for multiple items just add mutliple entries, unless i change it to be a listlistlist
//yes, it has to be an item, you can't pick up nonitems

GLOBAL_LIST_FILE_LOAD(custom_items, "config/custom_items.txt")

/proc/EquipCustomItems(mob/living/carbon/human/M)
	for(var/line in GLOB.custom_items)
		// split & clean up
		var/list/Entry = splittext(line, ":")
		for(var/i = 1 to length(Entry))
			Entry[i] = trim(Entry[i])

		if(length(Entry) < 2)
			continue;

		if(Entry[1] == M.ckey)
			var/list/Paths = splittext(Entry[2], ",")
			for(var/P in Paths)
				var/ok = FALSE  // TRUE if the item was placed successfully
				P = trim(P)
				var/path = text2path(P)
				if(!path) continue

				var/obj/item/Item = new path()
				for(var/obj/item/storage/S in M.contents) // Try to place it in any item that can store stuff, on the mob.
					if (S.handle_item_insertion(Item, TRUE))
						ok = TRUE
						break

				if (ok == FALSE) // Finally, since everything else failed, place it on the ground
					Item.forceMove(get_turf(M.loc))
