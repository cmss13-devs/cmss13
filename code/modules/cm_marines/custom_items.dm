GLOBAL_LIST_FILE_LOAD(custom_items, "config/custom_items.txt")
GLOBAL_LIST_EMPTY(donator_items)

/obj/structure/machinery/personal_gear_vendor
	name = "personal gear vendor"
	desc = "A console that allows the user to retrieve their personal possessions from the ASRS."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "cellconsole"
	density = TRUE
	unacidable = TRUE
	unslashable = TRUE
	///a random item that can be claimed if there is no valid kit
	var/static/list/random_personal_possessions = list()
	///list of ckeys of ckeys who redeemed kits
	var/static/list/ckeys_redeemed_kits = list()

/obj/structure/machinery/personal_gear_vendor/Initialize(mapload, ...)
	. = ..()
	if(!length(GLOB.donator_items))
		generate_donor_kits()

	if(!length(random_personal_possessions))
		generate_random_possessions()

/obj/structure/machinery/personal_gear_vendor/proc/generate_donor_kits(regenerate_kits = FALSE)
	if(regenerate_kits)
		GLOB.donator_items = list()

	for(var/current_line in GLOB.custom_items)
		if(!length(current_line)) //empty line
			continue
		if(copytext(current_line, 1, 2) == "#") //comment line
			continue

		var/donor_key
		var/list/kit_gear = list()
		var/kit_name = "Default"

		var/split_line = splittext(current_line, ":")

		donor_key = trim(split_line[1])
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

		if(kit_name in GLOB.donator_items[donor_key]) //multiple kits with same name
			stack_trace("Duplicate kit in Donator Gear. [donor_key] has multiple [kit_name] Donator Kits.")
			continue

		GLOB.donator_items[donor_key] += list("[kit_name]" = kit_gear)

/obj/structure/machinery/personal_gear_vendor/proc/generate_random_possessions(regenerate_kits = FALSE)
	if(regenerate_kits)
		random_personal_possessions = list()

	for(var/datum/gear/current_gear as anything in subtypesof(/datum/gear))
		if(!initial(current_gear.display_name))
			continue
		random_personal_possessions += initial(current_gear.path)

/obj/structure/machinery/personal_gear_vendor/attack_hand(mob/living/user)
	. = ..()
	if(!ishuman(user))
		return

	if(user.ckey in ckeys_redeemed_kits)
		to_chat(user, SPAN_NOTICE("You have already retrieved your kit."))
		return

	var/list/possible_kits = list()
	if(user.ckey in GLOB.donator_items)
		possible_kits += GLOB.donator_items[user.ckey]

	if(length(possible_kits) == 0) //if no donor kit they can get something else
		var/random_item = pick(random_personal_possessions)
		user.put_in_any_hand_if_possible(new random_item(get_turf(src)))
		to_chat(user, SPAN_NOTICE("You take [random_item] from [src]."))
		ckeys_redeemed_kits += user.ckey
		return

	if(length(possible_kits) == 1)
		user.put_in_any_hand_if_possible(new /obj/item/storage/box/donator_kit(get_turf(src), user.ckey, possible_kits[possible_kits[1]]))
		to_chat(user, SPAN_NOTICE("You retrieve your kit from [src]."))
		ckeys_redeemed_kits += user.ckey
		return

	if(length(possible_kits) >= 2)
		var/kit_choice = tgui_input_list(user, "Pick a kit to take:", "Donation Kit Selection", possible_kits)
		if(!kit_choice)
			to_chat(user, SPAN_NOTICE("You choose not to take any kits."))
			return
		if(!user.Adjacent(src))
			to_chat(user, SPAN_NOTICE("You are too far from [src]."))
			return
		user.put_in_any_hand_if_possible(new /obj/item/storage/box/donator_kit(get_turf(src), user.ckey, possible_kits[kit_choice]))
		to_chat(user, SPAN_NOTICE("You retrieve your kit from [src]."))
		ckeys_redeemed_kits += user.ckey

/obj/structure/machinery/personal_gear_vendor/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(!istype(attacking_item, /obj/item/storage/box/donator_kit))
		return

	var/obj/item/storage/box/donator_kit/kit = attacking_item
	if(kit.linked_ckey && kit.linked_ckey != user.ckey)
		to_chat(user, SPAN_WARNING("[src] denies [kit]."))
		return
	to_chat(user, SPAN_NOTICE("You return [kit] to [src]."))
	user.drop_held_item(kit)
	kit.forceMove(src)
	qdel(kit)

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
	if(linked_ckey && user.ckey != linked_ckey)
		to_chat(user, SPAN_NOTICE("You do not have access to [src]."))
		return
	. = ..()

/obj/item/storage/box/donator_kit/empty(mob/user, turf/drop_to)
	if(linked_ckey && user.ckey != linked_ckey)
		to_chat(user, SPAN_NOTICE("You do not have access to [src]."))
		return
	. = ..()
