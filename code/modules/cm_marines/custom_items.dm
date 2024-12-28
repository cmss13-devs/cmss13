GLOBAL_LIST_INIT(donator_items, generate_donor_kits(FALSE))
GLOBAL_LIST_INIT(random_personal_possessions, generate_random_possessions())

/proc/generate_donor_kits(assign_to_glob = TRUE)
	. = list()

	var/list/custom_items = file2list("config/custom_items.txt")
	for(var/current_line in custom_items)
		if(!length(current_line)) //empty line
			continue
		if(copytext(current_line, 1, 2) == "#") //comment line
			continue

		var/donor_key
		var/list/kit_gear = list()
		var/kit_name = "Default"

		var/split_line = splittext(current_line, ":")

		donor_key = ckey(trim(split_line[1]))
		if(length(split_line) > 2) //if someone has multiple kits, name them
			kit_name = trim(split_line[2])

		for(var/current_item in splittext(split_line[length(split_line)], ","))
			var/current_path = text2path(trim(current_item))
			if(!current_path)
				stack_trace("Missing typepath in Donator Gear. [donor_key] has an invalid typepath for [current_item].")
				continue
			kit_gear += current_path

		if(!length(kit_gear)) //shouldnt let them get empty kits
			stack_trace("Missing gear in Donator Gear. [donor_key] has an empty Donator Kit.")
			continue

		if(kit_name in .[donor_key]) //multiple kits with same name
			stack_trace("Duplicate kit in Donator Gear. [donor_key] has multiple [kit_name] Donator Kits.")
			continue

		.[donor_key] += list("[kit_name]" = kit_gear)

	if(assign_to_glob)
		GLOB.donator_items = .

	return .

/proc/generate_random_possessions()
	. = list()

	for(var/datum/gear/current_gear as anything in subtypesof(/datum/gear))
		if(!initial(current_gear.display_name))
			continue
		. += initial(current_gear.path)

	return .

/obj/structure/machinery/personal_gear_vendor
	name = "personal gear vendor"
	desc = "A console that allows the user to retrieve their personal possessions from the ASRS."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "cellconsole"
	density = TRUE
	unacidable = TRUE
	unslashable = TRUE
	///assoc list of ckeys to list of kits redeemed
	var/static/list/ckeys_redeemed_kits = list()

/obj/structure/machinery/personal_gear_vendor/attack_hand(mob/living/user)
	if(..())
		return TRUE

	if(!ishuman(user))
		return FALSE

	var/list/possible_kits = list()
	if(user.ckey in GLOB.donator_items)
		possible_kits += GLOB.donator_items[user.ckey]

	if(user.ckey in ckeys_redeemed_kits)
		if(length(ckeys_redeemed_kits[user.ckey]) >= length(possible_kits))
			// They are a donator but have gotten everything
			to_chat(user, SPAN_NOTICE("You have already retrieved your kit(s)."))
			return TRUE

	if(length(possible_kits) == 0) //if no donor kit they can get something else
		var/random_item_path = pick(GLOB.random_personal_possessions)
		var/random_item = new random_item_path(get_turf(src))
		user.put_in_any_hand_if_possible(random_item)
		to_chat(user, SPAN_NOTICE("You take [random_item] from [src]."))
		LAZYADD(ckeys_redeemed_kits[user.ckey], random_item_path)
		return TRUE

	// Remove any kits already grabbed
	for(var/item in ckeys_redeemed_kits[user.ckey])
		possible_kits -= item

	if(length(possible_kits) == 1)
		user.put_in_any_hand_if_possible(new /obj/item/storage/box/donator_kit(get_turf(src), user.ckey, possible_kits[possible_kits[1]]))
		to_chat(user, SPAN_NOTICE("You retrieve your kit from [src]."))
		LAZYADD(ckeys_redeemed_kits[user.ckey], possible_kits[1])
		return TRUE

	if(length(possible_kits) >= 2)
		var/kit_choice = tgui_input_list(user, "Pick a kit to take:", "Donation Kit Selection", possible_kits)
		if(!kit_choice)
			to_chat(user, SPAN_NOTICE("You choose not to take any kits."))
			return TRUE
		if(!user.Adjacent(src))
			to_chat(user, SPAN_NOTICE("You are too far from [src]."))
			return TRUE
		user.put_in_any_hand_if_possible(new /obj/item/storage/box/donator_kit(get_turf(src), user.ckey, possible_kits[kit_choice]))
		to_chat(user, SPAN_NOTICE("You retrieve your kit from [src]."))
		LAZYADD(ckeys_redeemed_kits[user.ckey], kit_choice)
		return TRUE

/obj/structure/machinery/personal_gear_vendor/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/storage/box/donator_kit))
		return ..()

	var/obj/item/storage/box/donator_kit/kit = attacking_item
	if(!kit.allowed(user))
		to_chat(user, SPAN_WARNING("[src] denies [kit]."))
		return TRUE
	to_chat(user, SPAN_NOTICE("You return [kit] to [src]."))
	user.drop_held_item(kit)
	kit.forceMove(src)
	qdel(kit)
	return TRUE

/obj/item/storage/box/donator_kit
	name = "personal gear kit"
	desc = "A cardboard box stamped with a dollar sign and filled with trinkets. It contains someones personal possessions.."
	icon = 'icons/obj/items/storage/kits.dmi'
	icon_state = "donator_kit"
	item_state = "giftbag"
	max_w_class = SIZE_TINY
	var/linked_ckey

/obj/item/storage/box/donator_kit/get_examine_text(mob/user)
	. = ..()
	if(linked_ckey && user.ckey == linked_ckey)
		. += SPAN_INFO("This kit can only be opened by you.")
		. += SPAN_INFO("This kit can be deleted by returning it to the personal gear vendor.")

/obj/item/storage/box/donator_kit/Initialize(mapload, owner_ckey, list/selected_kit)
	. = ..()
	if(owner_ckey)
		linked_ckey = owner_ckey

	for(var/current_item in selected_kit)
		new current_item(src)

/obj/item/storage/box/donator_kit/open(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_NOTICE("You do not have access to [src]."))
		return
	return ..()

/obj/item/storage/box/donator_kit/empty(mob/user, turf/drop_to)
	if(!allowed(user))
		to_chat(user, SPAN_NOTICE("You do not have access to [src]."))
		return
	return ..()

/obj/item/storage/box/donator_kit/allowed(mob/user)
	if(linked_ckey && user.ckey != linked_ckey)
		return FALSE
	return TRUE
