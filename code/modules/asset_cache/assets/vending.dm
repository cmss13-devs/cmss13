/datum/asset/spritesheet/vending
	name = "goods-vending"

/datum/asset/spritesheet/vending/register()
	// initialising the list of items we need
	var/target_items = list()
	for(var/obj/structure/machinery/vending/vendor as anything in typesof(/obj/structure/machinery/vending))
		vendor = new vendor() // It seems `initial(list var)` has nothing. need to make a type.
		for(var/each in list(vendor.products, vendor.premium, vendor.contraband))
			target_items |= each
		qdel(vendor)

	// building icons for each item
	for (var/k in target_items)
		var/atom/item = k
		if (!ispath(item, /atom))
			continue

		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)

		if (PERFORM_ALL_TESTS(focus_only/invalid_vending_machine_icon_states))
			var/icon_states_list = icon_states(icon_file)
			if (!(icon_state in icon_states_list))
				var/icon_states_string
				for (var/an_icon_state in icon_states_list)
					if (!icon_states_string)
						icon_states_string = "[json_encode(an_icon_state)]([text_ref(an_icon_state)])"
					else
						icon_states_string += ", [json_encode(an_icon_state)]([text_ref(an_icon_state)])"

				stack_trace("[item] does not have a valid icon state, icon=[icon_file], icon_state=[json_encode(icon_state)]([text_ref(icon_state)]), icon_states=[icon_states_string]")
				continue

		var/icon/I = icon(icon_file, icon_state, SOUTH)
		var/c = initial(item.color)
		if (!isnull(c) && c != "#FFFFFF")
			I.Blend(c, ICON_MULTIPLY)

		var/imgid = replacetext(replacetext("[item]", "/obj/item/", ""), "/", "-")

		Insert(imgid, I)
	return ..()
