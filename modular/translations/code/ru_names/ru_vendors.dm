/obj/structure/machinery/cm_vending/sorted/populate_product_list_and_boxes(scale)
	. = ..()
	translate_vendor_entries_to_ru(listed_products)

// [1] = Name
// [2] = Amount
// [3] = Item path
// [4] = Flags
// [5] = something, I dunno, sometimes it exists
// ["english_name"] = Original Name (NEW)

/proc/translate_vendor_entries_to_ru(list/entries)
	if(!length(entries))
		return
	for(var/list/product_entry in entries)
		if(!length(product_entry))
			return
		// Add original name for searching purposes
		if(!product_entry["english_name"])
			product_entry["english_name"] = product_entry[1]
		var/new_name = declent_ru_initial(product_entry[1])
		// We have override name for this, such as "Flare Pouch (Full)"
		if(!isnull(new_name))
			product_entry[1] = capitalize(new_name)
			continue
		// Try to get translated item name
		if(product_entry[3] && ispath(product_entry[3], /atom))
			var/atom/product_entry_item = product_entry[3]
			new_name = declent_ru_initial(product_entry_item::name)
			// Use untranslated name then
			if(isnull(new_name))
				continue
			product_entry[1] = capitalize(new_name)
