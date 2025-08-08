/datum/asset/spritesheet/stack_receipts
	name = "stack-receipts"

/datum/asset/spritesheet/stack_receipts/register()
	// initialising the list of items we need
	var/target_items = list()
	var/big_list = list()

	big_list = mergeLists(big_list, GLOB.sandstone_recipes) //kill me plz
	big_list = mergeLists(big_list, GLOB.runedsandstone_recipes)
	big_list = mergeLists(big_list, GLOB.silver_recipes)
	big_list = mergeLists(big_list, GLOB.diamond_recipes)
	big_list = mergeLists(big_list, GLOB.uranium_recipes)
	big_list = mergeLists(big_list, GLOB.gold_recipes)
	big_list = mergeLists(big_list, GLOB.phoron_recipes)
	big_list = mergeLists(big_list, GLOB.plastic_recipes)
	big_list = mergeLists(big_list, GLOB.iron_recipes)
	big_list = mergeLists(big_list, GLOB.metal_recipes)
	big_list = mergeLists(big_list, GLOB.plasteel_recipes)
	big_list = mergeLists(big_list, GLOB.wood_recipes)
	big_list = mergeLists(big_list, GLOB.cardboard_recipes)
	big_list = mergeLists(big_list, GLOB.aluminium_recipes)
	big_list = mergeLists(big_list, GLOB.copper_recipes)
	big_list = mergeLists(big_list, GLOB.glass_recipes)
	big_list = mergeLists(big_list, GLOB.glass_reinforced_recipes)
	big_list = mergeLists(big_list, GLOB.phoronrglass_recipes)
	big_list = mergeLists(big_list, GLOB.phoronglass_recipes)


	for(var/each in big_list)
		if (istype(each, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = each
			for (var/sub_rec in srl.recipes)
				if (istype(sub_rec, /datum/stack_recipe))
					var/datum/stack_recipe/recipe = sub_rec
					target_items |= recipe.result_type
		else if (istype(each, /datum/stack_recipe))
			var/datum/stack_recipe/recipe = each
			if(!recipe)
				continue
			target_items |= recipe.result_type

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
