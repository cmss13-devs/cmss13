/obj/structure/machinery/cm_vending
	name = "\improper Theoretical Marine selector"

	//for the sake of consistency: "small storage" = small limited amount of items (squad req),
	//"big storage" - Req vendors,"colossal storage" - infinite vendors (points and flag-based)
	desc = ""
	icon = 'icons/obj/structures/machinery/vending.dmi'
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	req_access = list()
	req_one_access = list()

	//most vendors are still unacidable, but almost all are slashable and fixable
	unacidable = TRUE
	unslashable = FALSE
	wrenchable = FALSE
	var/hackable = FALSE
	var/hacked = FALSE

	var/vendor_theme = VENDOR_THEME_COMPANY //sets vendor theme in NanoUI

	var/list/vendor_role = list() //to be compared with assigned_role to only allow those to use that machine. Converted to list by Jeser 09.05.20
	var/squad_tag = "" //same to restrict vendor to specified squad

	var/use_points = FALSE //disabling these two grants unlimited access to items for adminab... I mean, events purposes
	var/use_snowflake_points = FALSE

	var/available_points_to_display = 0
	var/show_points = TRUE

	//squad-specific gear
	var/gloves_type = /obj/item/clothing/gloves/marine
	var/headset_type = /obj/item/device/radio/headset/almayer/marine

	var/vend_delay = 0 //delaying vending of an item (for drinks machines animation, for example). Make sure to synchronize this with animation duration
	var/vend_sound //use with caution. Potential spam

	/// X Offset to vend to
	var/vend_x_offset = 0
	/// Y Offset to vend to
	var/vend_y_offset = 0
	/// Vending direction from adjacent users, if not using vend_x_offset or vend_y_offset
	var/vend_dir
	/// Direction to adjacent user from which we're allowed to do offset vending
	var/list/vend_dir_whitelist

	/// The actual inventory for this vendor as a list of lists
	/// 1: name 2: amount 3: type 4: flag
	var/list/listed_products = list()
	/// Partial stacks to hold on to as an associated list of type : amount
	var/list/partial_product_stacks = list()

	// Are points associated with this vendor tied to its instance?
	var/instanced_vendor_points = FALSE
	var/vend_flags = VEND_CLUTTER_PROTECTION

/*
Explanation on stat flags:
BROKEN vendor is not operational and it's not a power issue
NOPOWER vendor has no power
MAINT we have to actually do a maintenance on vendor with tools to fix it
IN_REPAIR(REPAIR_STEPS) for maintenance repair steps
TIPPED_OVER for flipped sprite
IN_USE used for vending/denying
*/

//------------GENERAL PROCS---------------


/obj/structure/machinery/cm_vending/Initialize()
	. = ..()
	cm_build_inventory(get_listed_products(), 1, 3)

/obj/structure/machinery/cm_vending/update_icon()
	//restoring sprite to initial
	overlays.Cut()
	//icon_state = initial(icon_state) //shouldn't be needed but just in case
	var/matrix/A = matrix()
	apply_transform(A)

	if(stat & NOPOWER || stat & TIPPED_OVER) //tipping off without breaking uses "_off" sprite
		overlays += image(icon, "[icon_state]_off")
	if(stat & MAINT) //if we require maintenance, then it is completely "_broken"
		overlays += image(icon, "[initial(icon_state)]_broken")
		if(stat & IN_REPAIR) //if someone started repairs, they unscrewed "_panel"
			overlays += image(icon, "[icon_state]_panel")

	if(stat & TIPPED_OVER) //finally, if it is tipped over, flip the sprite
		A.Turn(90)
		apply_transform(A)

/obj/structure/machinery/cm_vending/ex_act(severity)
	if(explo_proof)
		return

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				tip_over()
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				tip_over()
				malfunction()
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
	return

// Vendor Icon Procs


GLOBAL_LIST_EMPTY(vending_products)

/obj/structure/machinery/cm_vending/proc/cm_build_inventory(list/items, name_index=1, type_index=3)
	for (var/list/item in items)
		// initial item count setup
		var/item_name = item[name_index]
		// icon setup
		var/typepath = item[type_index]
		if (!item_name || item_name == "" || !typepath)
			continue

		if(islist(typepath))
			for(var/path in typepath)
				GLOB.vending_products[path] = 1
		else
			GLOB.vending_products[typepath] = 1

//get which turf the vendor will dispense its products on.
/obj/structure/machinery/cm_vending/proc/get_appropriate_vend_turf(mob/living/carbon/human/user)
	var/turf/turf = loc
	if(vend_x_offset != 0 || vend_y_offset != 0) //this check should be more less expensive than using locate to locate your own tile every vending.
		turf = locate(x + vend_x_offset, y + vend_y_offset, z)
		return turf
	if(vend_dir)
		if(vend_dir_whitelist)
			var/user_dir = get_dir(loc, user)
			if(!(user_dir in vend_dir_whitelist))
				return get_turf(user)
		var/turf/relative_turf = get_step(user, vend_dir)
		if(relative_turf)
			return relative_turf
	return turf

/obj/structure/machinery/cm_vending/get_examine_text(mob/living/carbon/human/user)
	. = ..()

	if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && hackable)
		. += SPAN_NOTICE("You believe you can hack this one to remove the access requirements.")

/obj/structure/machinery/cm_vending/proc/hack_access(mob/user)
	if(!hackable)
		to_chat(user, SPAN_WARNING("[src] cannot be hacked."))
		return

	hacked = !hacked
	if(hacked)
		to_chat(user, SPAN_WARNING("You have successfully removed access restrictions in [src]."))
		if(user && is_mainship_level(z))
			SSclues.create_print(get_turf(user), user, "A small piece of cut wire is found on the fingerprint.")
	else
		to_chat(user, SPAN_WARNING("You have restored access restrictions in [src]."))
	return


//Called when we vend something
/obj/structure/machinery/cm_vending/proc/update_derived_ammo_and_boxes(list/item_being_vended)
	if(!LAZYLEN(item_being_vended))
		return

	update_derived_from_ammo(item_being_vended)
	update_derived_from_boxes(item_being_vended[3])

//Called when we add something in
/obj/structure/machinery/cm_vending/proc/update_derived_ammo_and_boxes_on_add(list/item_being_added)
	if(!LAZYLEN(item_being_added))
		return
	update_derived_from_ammo(item_being_added)
	//We are ADDING a box, so need to INCREASE the number of magazines rather than subtracting it
	update_derived_from_boxes(item_being_added[3], TRUE)

/obj/structure/machinery/cm_vending/proc/update_derived_from_ammo(list/base_ammo_item, add_box = FALSE)
	if(!LAZYLEN(base_ammo_item))
		return
	//Item is a vented magazine / grenade / whatever, update all dependent boxes
	var/datum/item_to_multiple_box_pairing/item_to_box_mapping = GLOB.item_to_box_mapping.get_item_to_box_mapping(base_ammo_item[3])
	if(!item_to_box_mapping)
		return
	var/list/topic_listed_products = get_listed_products(usr)
	for(var/datum/item_box_pairing/item_box_pairing as anything in item_to_box_mapping.item_box_pairings)
		for(var/list/product in topic_listed_products)
			if(product[3] == item_box_pairing.box)
				//We recalculate the amount of boxes we ought to have based on how many magazines we have
				product[2] = floor(base_ammo_item[2] / item_box_pairing.items_in_box)
				break

/obj/structure/machinery/cm_vending/proc/update_derived_from_boxes(obj/item/box_being_added_or_removed, add_box = FALSE)
	var/datum/item_box_pairing/item_box_pairing = GLOB.item_to_box_mapping.get_box_to_item_mapping(box_being_added_or_removed)
	if(!item_box_pairing)
		return
	//Item is a vented box, update base ammo count
	//and then update all the relevant boxes based on the new item count by calling this function again with the ammo parameter
	var/list/topic_listed_products = get_listed_products(usr)
	for(var/list/product in topic_listed_products)
		if(product[3] == item_box_pairing.item)
			if(add_box)
				//We increase the amount of available magazines based on how many magazines we vended in a box
				product[2] = product[2] + item_box_pairing.items_in_box
			else
				//We lower the amount of available magazines based on how many magazines we vended in a box
				product[2] = max(product[2] - item_box_pairing.items_in_box, 0) //Just in case some shenanigans happen

			//After we update the magazines, we update the connected boxes
			//Just in case we have a small ammo box and a big ammo box (like say, grenades do)
			update_derived_from_ammo(product)
			return

//A proc that checks all the items if they can be restocked
//AKA if a mag is full, an ammo box is full, flamer mags having the correct fluid and so on
/obj/structure/machinery/cm_vending/proc/check_if_item_is_good_to_restock(obj/item/item_to_stock, mob/user)
	. = FALSE //Item is NOT good to restock

	//Guns handling
	if(isgun(item_to_stock))
		var/obj/item/weapon/gun/G = item_to_stock
		if(G.in_chamber || (G.current_mag && !istype(G.current_mag, /obj/item/ammo_magazine/internal)) || (istype(G.current_mag, /obj/item/ammo_magazine/internal) && G.current_mag.current_rounds > 0) )
			to_chat(user, SPAN_WARNING("[G] is still loaded. Unload it before you can restock it."))
			return
		for(var/obj/item/attachable/A in G.contents) //Search for attachments on the gun. This is the easier method
			if((A.flags_attach_features & ATTACH_REMOVABLE) && !(is_type_in_list(A, G.starting_attachment_types))) //There are attachments that are default and others that can't be removed
				to_chat(user, SPAN_WARNING("[G] has non-standard attachments equipped. Detach them before you can restock it."))
				return
	//various stacks handling
	else if(istype(item_to_stock, /obj/item/stack/folding_barricade))
		var/obj/item/stack/folding_barricade/B = item_to_stock
		if(B.amount != 3)
			to_chat(user, SPAN_WARNING("[B]s are being stored in [SPAN_HELPFUL("stacks of 3")] for convenience. Add to \the [B] stack to make it a stack of 3 before restocking."))
			return
	//M94 flare packs handling
	else if(istype(item_to_stock, /obj/item/storage/box/m94))
		var/obj/item/storage/box/m94/flare_pack = item_to_stock
		if(length(flare_pack.contents) < flare_pack.max_storage_space)
			to_chat(user, SPAN_WARNING("\The [item_to_stock] is not full."))
			return
		var/flare_type
		if(istype(item_to_stock, /obj/item/storage/box/m94/signal))
			flare_type = /obj/item/device/flashlight/flare/signal
		else
			flare_type = /obj/item/device/flashlight/flare
		for(var/obj/item/device/flashlight/flare/F in flare_pack.contents)
			if(F.fuel < 1)
				to_chat(user, SPAN_WARNING("Some flares in \the [F] are used."))
				return
			if(F.type != flare_type)
				to_chat(user, SPAN_WARNING("Some flares in \the [F] are not of the correct type."))
				return
	//Machete holsters handling
	else if(istype(item_to_stock, /obj/item/storage/large_holster/machete))
		var/obj/item/weapon/sword/machete/mac = locate(/obj/item/weapon/sword/machete) in item_to_stock
		if(!mac)
			if(user)
				to_chat(user, SPAN_WARNING("\The [item_to_stock] is empty."))
			return FALSE
	//Machete holsters handling
	else if(istype(item_to_stock, /obj/item/clothing/suit/storage/marine))
		var/obj/item/clothing/suit/storage/marine/AR = item_to_stock
		if(AR.pockets && length(AR.pockets.contents))
			if(user)
				to_chat(user, SPAN_WARNING("\The [AR] has something inside it. Empty it before restocking."))
			return FALSE
	//magazines handling
	else if(istype(item_to_stock, /obj/item/ammo_magazine))
		//flamer fuel tanks handling
		if(istype(item_to_stock, /obj/item/ammo_magazine/flamer_tank))
			var/obj/item/ammo_magazine/flamer_tank/FT = item_to_stock
			if(FT.flamer_chem != initial(FT.flamer_chem))
				to_chat(user, SPAN_WARNING("\The [FT] contains non-standard fuel."))
				return
		var/obj/item/ammo_magazine/A = item_to_stock
		if(A.current_rounds < A.max_rounds)
			to_chat(user, SPAN_WARNING("\The [A] isn't full. You need to fill it before you can restock it."))
			return
	//magazine ammo boxes handling
	else if(istype(item_to_stock, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/A = item_to_stock
		//shotgun shells ammo boxes handling
		if(A.handfuls)
			var/obj/item/ammo_magazine/AM = locate(/obj/item/ammo_magazine) in item_to_stock.contents
			if(!AM)
				to_chat(user, SPAN_WARNING("Something is wrong with \the [A], tell a coder."))
				return
			if(AM.current_rounds != AM.max_rounds)
				to_chat(user, SPAN_WARNING("\The [A] isn't full. You need to fill it before you can restock it."))
				return
		else if(length(A.contents) < A.num_of_magazines)
			to_chat(user, SPAN_WARNING("[A] is not full."))
			return
		else
			for(var/obj/item/ammo_magazine/M in A.contents)
				if(M.current_rounds != M.max_rounds)
					to_chat(user, SPAN_WARNING("Not all magazines in \the [A] are full."))
					return
	//loose rounds ammo box handling
	else if(istype(item_to_stock, /obj/item/ammo_box/rounds))
		var/obj/item/ammo_box/rounds/A = item_to_stock
		if(A.bullet_amount < A.max_bullet_amount)
			to_chat(user, SPAN_WARNING("[A] is not full."))
			return
	//Marine armor handling
	else if(istype(item_to_stock, /obj/item/clothing/suit/storage/marine))
		var/obj/item/clothing/suit/storage/marine/AR = item_to_stock
		if(AR.pockets && length(AR.pockets.contents))
			if(user)
				to_chat(user, SPAN_WARNING("\The [AR] has something inside it. Empty it before restocking."))
			return FALSE
	//Marine helmet handling
	else if(istype(item_to_stock, /obj/item/clothing/head/helmet/marine))
		var/obj/item/clothing/head/helmet/marine/H = item_to_stock
		if(H.pockets && length(H.pockets.contents))
			if(user)
				to_chat(user, SPAN_WARNING("\The [H] has something inside it. Empty it before restocking."))
			return FALSE
	return TRUE //Item IS good to restock!

//------------MAINTENANCE PROCS---------------

/obj/structure/machinery/cm_vending/proc/malfunction() //proper malfunction, that requires MAINTenance
	if(stat & MAINT)
		return
	stat &= ~WORKING
	stat |= (BROKEN|MAINT)
	update_icon()

/obj/structure/machinery/cm_vending/proc/tip_over() //tipping over, flipping back is enough, unless vendor was broken before being tipped over
	stat |= TIPPED_OVER
	density = FALSE
	if(!(stat & MAINT))
		stat |= BROKEN
		stat &= ~WORKING
	update_icon()

/obj/structure/machinery/cm_vending/proc/flip_back()
	density = TRUE
	stat &= ~TIPPED_OVER
	if(!(stat & MAINT)) //we fix vendor only if it was tipped over while working. No magic fixing of broken and then tipped over vendors.
		stat &= ~BROKEN
		stat |= WORKING
	update_icon()

/obj/structure/machinery/cm_vending/get_repair_move_text(include_name = TRUE)
	if(!stat)
		return

	var/possessive = include_name ? "[src]'s" : "Its"
	var/nominative = include_name ? "[src]" : "It"

	if(stat & MAINT)
		return "[possessive] broken panel still needs to be <b>unscrewed</b> and removed."
	else if(stat & REPAIR_STEP_ONE)
		return "[possessive] broken wires still need to be <b>cut</b> and removed from the vendor."
	else if(stat & REPAIR_STEP_TWO)
		return "[nominative] needs to have <b>new wiring</b> installed."
	else if(stat & REPAIR_STEP_THREE)
		return "[nominative] needs to have a <b>metal</b> panel installed."
	else if(stat & REPAIR_STEP_FOUR)
		return "[possessive] new panel needs to be <b>fastened</b> to it."
	else
		return "[nominative] is being affected by some power-related issue."

//------------INTERACTION PROCS---------------

/obj/structure/machinery/cm_vending/attack_alien(mob/living/carbon/xenomorph/user)
	if(stat & TIPPED_OVER || unslashable)
		to_chat(user, SPAN_WARNING("There's no reason to bother with that old piece of trash."))
		return XENO_NO_DELAY_ACTION

	if(user.a_intent == INTENT_HARM && !unslashable)
		user.animation_attack_on(src)
		if(prob(user.melee_damage_lower))
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
			user.visible_message(SPAN_DANGER("[user] smashes [src] beyond recognition!"),
			SPAN_DANGER("You enter a frenzy and smash [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			malfunction()
			tip_over()
		else
			user.visible_message(SPAN_DANGER("[user] slashes [src]!"),
			SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		return XENO_ATTACK_ACTION

	if(user.action_busy)
		return XENO_NO_DELAY_ACTION
	if(user.a_intent == INTENT_HELP && user.IsAdvancedToolUser())
		user.set_interaction(src)
		tgui_interact(user)
		if(!hacked)
			to_chat(user, SPAN_WARNING("You slash open [src]'s front panel, revealing the items within."))
			var/datum/effect_system/spark_spread/spark_system = new
			spark_system.set_up(5, 5, get_turf(src))
			hacked = TRUE
		return XENO_ATTACK_ACTION
	user.visible_message(SPAN_WARNING("[user] begins to lean against [src]."),
	SPAN_WARNING("You begin to lean against [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	var/shove_time = 80
	if(user.mob_size >= MOB_SIZE_BIG)
		shove_time = 30
	if(istype(user,/mob/living/carbon/xenomorph/crusher))
		shove_time = 15

	xeno_attack_delay(user) //Adds delay here and returns nothing because otherwise it'd cause lag *after* finishing the shove.

	if(do_after(user, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		user.animation_attack_on(src)
		user.visible_message(SPAN_DANGER("[user] knocks [src] down!"),
		SPAN_DANGER("You knock [src] down!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		tip_over()
	return XENO_NO_DELAY_ACTION

/obj/structure/machinery/cm_vending/attack_hand(mob/user)
	if(stat & TIPPED_OVER)
		if(user.action_busy)
			return
		user.visible_message(SPAN_NOTICE("[user] begins to heave the vending machine back into place!"),SPAN_NOTICE("You start heaving the vending machine back into place."))
		if(do_after(user, 80, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
			user.visible_message(SPAN_NOTICE("[user] rights \the [src]!"),SPAN_NOTICE("You right \the [src]!"))
			flip_back()
		return

	if(inoperable())
		return

	if(user.client && user.client.remote_control)
		tgui_interact(user)
		return

	if(!ishuman(user))
		vend_fail()
		return

	var/has_access = can_access_to_vend(user)
	if (!has_access)
		return

	user.set_interaction(src)
	tgui_interact(user)

/// Handles redeeming coin tokens.
/obj/structure/machinery/cm_vending/proc/redeem_token(obj/item/coin/marine/token, mob/user)
	var/reward_typepath
	switch(token.token_type)
		if(VEND_TOKEN_VOID)
			to_chat(user, SPAN_WARNING("ERROR: TOKEN NOT RECOGNISED."))
			return FALSE
		if(VEND_TOKEN_SPEC)
			reward_typepath = /obj/item/spec_kit/rifleman
		else
			to_chat(user, SPAN_WARNING("ERROR: INCORRECT TOKEN."))
			return FALSE

	if(reward_typepath && user.drop_inv_item_to_loc(token, src))
		to_chat(user, SPAN_NOTICE("You insert \the [token] into \the [src]."))
		var/obj/new_item = new reward_typepath(get_turf(src))
		user.put_in_any_hand_if_possible(new_item)
		return TRUE
	return FALSE


//------------TGUI PROCS---------------

/obj/structure/machinery/cm_vending/ui_data(mob/user)
	if(vend_flags & VEND_LIMITED_INVENTORY)
		return vendor_inventory_ui_data(user)

	. = list()
	var/list/ui_listed_products = get_listed_products(user)
	// list format
	// (
	// name: str
	// cost
	// item reference
	// allowed to buy flag
	// item priority (mandatory/recommended/regular)
	// )

	var/list/stock_values = list()

	var/mob/living/carbon/human/marine = user
	var/points = 0

	if(instanced_vendor_points)
		points = available_points_to_display
	else
		if(use_snowflake_points)
			points = marine.marine_snowflake_points
		else if(use_points)
			points = marine.marine_points

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/category = myprod[4]
		if(points >= p_cost && (!category || ((category in marine.marine_buyable_categories) && (marine.marine_buyable_categories[category]))))
			prod_available = TRUE
		stock_values += list(prod_available)

	.["stock_listing"] = stock_values
	.["current_m_points"] = points

/obj/structure/machinery/cm_vending/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/human_user
	var/mob/living/carbon/user = ui.user

	if(ishuman(user))
		human_user = usr

	switch (action)
		if ("vend")
			if(stat & IN_USE)
				return
			var/has_access = can_access_to_vend(usr)
			if (!has_access)
				vend_fail()
				return TRUE

			var/index=params["prod_index"]
			var/list/topic_listed_products = get_listed_products(user)
			var/list/itemspec = topic_listed_products[index]

			var/turf/target_turf = get_appropriate_vend_turf(user)
			if(vend_flags & VEND_CLUTTER_PROTECTION)
				if(length(target_turf.contents) > 25)
					to_chat(usr, SPAN_WARNING("The floor is too cluttered, make some space."))
					vend_fail()
					return FALSE
			if(HAS_TRAIT(user,TRAIT_OPPOSABLE_THUMBS)) // the big monster 7 ft with thumbs does not care for squads
				vendor_successful_vend(itemspec, usr)
				add_fingerprint(usr)
				return TRUE
			if((!human_user.assigned_squad && squad_tag) || (!human_user.assigned_squad?.omni_squad_vendor && (squad_tag && human_user.assigned_squad.name != squad_tag)))
				to_chat(user, SPAN_WARNING("This machine isn't for your squad."))
				vend_fail()
				return FALSE

			if(vend_flags & VEND_CATEGORY_CHECK)
				// if the vendor uses flags to control availability
				var/can_buy_flags = itemspec[4]
				if(can_buy_flags)
					if(can_buy_flags == MARINE_CAN_BUY_ESSENTIALS)
						if(vendor_role.Find(JOB_SQUAD_SPECIALIST))
							// handle specalist essential gear assignment
							if(user.job != JOB_SQUAD_SPECIALIST)
								to_chat(user, SPAN_WARNING("Only specialists can take specialist sets."))
								vend_fail()
								return FALSE

							else if(!user.skills || user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_TRAINED)
								to_chat(user, SPAN_WARNING("You already have a specialization."))
								vend_fail()
								return FALSE

							var/p_name = itemspec[1]
							if(!(p_name in GLOB.specialist_set_name_dict))
								return

							if(GLOB.specialist_set_name_dict[p_name].get_available_vendor_num() <= 0)
								to_chat(user, SPAN_WARNING("That set is already taken."))
								vend_fail()
								return FALSE

							var/obj/item/card/id/card = human_user.get_idcard()
							if(!istype(card) || !card.check_biometrics(user))
								to_chat(user, SPAN_WARNING("You must be wearing your [SPAN_INFO("dog tags")] to select a specialization!"))
								return FALSE

							GLOB.specialist_set_name_dict[p_name].redeem_set(human_user)

						else if(vendor_role.Find(JOB_SYNTH))
							if(user.job != JOB_SYNTH)
								to_chat(user, SPAN_WARNING("Only USCM Synthetics may vend experimental tool tokens."))
								vend_fail()
								return FALSE

					if(!handle_vend(itemspec, user))
						to_chat(user, SPAN_WARNING("You can't buy things from this category anymore."))
						vend_fail()
						return FALSE

			if(use_points || use_snowflake_points)
				if(!handle_points(user, itemspec))
					to_chat(user, SPAN_WARNING("Not enough points."))
					vend_fail()
					return FALSE
			else
				// if vendor has no costs and is inventory limited
				var/inventory_count = itemspec[2]
				if(inventory_count <= 0) //to avoid dropping more than one product when there's
					to_chat(usr, SPAN_WARNING("[itemspec[1]] is out of stock."))
					vend_fail()
					return TRUE // one left and the player spam click during a lagspike.

			vendor_successful_vend(itemspec, user)
			return TRUE
	add_fingerprint(user)

/obj/structure/machinery/cm_vending/proc/handle_points(mob/living/carbon/human/user, list/itemspec)
	. = TRUE
	var/cost = itemspec[2]
	if(instanced_vendor_points)
		if(available_points_to_display < cost)
			return FALSE
		else
			available_points_to_display -= cost
	else
		if(use_snowflake_points)
			if(user.marine_snowflake_points < cost)
				return FALSE
			else
				user.marine_snowflake_points -= cost
		else
			if(user.marine_points < cost)
				return FALSE
			else
				user.marine_points -= cost

/obj/structure/machinery/cm_vending/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "VendingSorted", name)
		ui.open()

/obj/structure/machinery/cm_vending/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!can_access_to_vend(user, FALSE))
		return UI_CLOSE

/obj/structure/machinery/cm_vending/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state


/obj/structure/machinery/cm_vending/attackby(obj/item/W, mob/user)
	// Repairing process
	if(stat & TIPPED_OVER)
		to_chat(user, SPAN_WARNING("You need to set [src] back upright first."))
		return
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		else if(stat & MAINT)
			to_chat(user, SPAN_NOTICE("You start to unscrew \the [src]'s broken panel."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop unscrewing \the [src]'s broken panel."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unscrew \the [src]'s broken panel and remove it, exposing many broken wires."))
			stat &= ~MAINT
			stat |= REPAIR_STEP_ONE
			return TRUE
		else if(stat & REPAIR_STEP_FOUR)
			to_chat(user, SPAN_NOTICE("You start to fasten \the [src]'s new panel."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop fastening \the [src]'s new panel."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You fasten \the [src]'s new panel, fully repairing the vendor."))
			stat &= ~(REPAIR_STEP_FOUR|MAINT|BROKEN)
			stat |= WORKING
			update_icon()
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return FALSE
	else if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		else if(stat & REPAIR_STEP_ONE)
			to_chat(user, SPAN_NOTICE("You start to remove \the [src]'s broken wires."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop removing \the [src]'s broken wires."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You remove \the [src]'s broken broken wires."))
			stat &= ~REPAIR_STEP_ONE
			stat |= REPAIR_STEP_TWO
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return FALSE
	else if(iswire(W))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		var/obj/item/stack/cable_coil/CC = W
		if(stat & REPAIR_STEP_TWO)
			if(CC.amount < 5)
				to_chat(user, SPAN_WARNING("You need more cable coil to replace the removed wires."))
			to_chat(user, SPAN_NOTICE("You start to replace \the [src]'s removed wires."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop replacing \the [src]'s removed wires."))
				return FALSE
			if(!CC || !CC.use(5))
				to_chat(user, SPAN_WARNING("You need more cable coil to replace the removed wires."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You remove \the [src]'s broken broken wires."))
			stat &= ~REPAIR_STEP_TWO
			stat |= REPAIR_STEP_THREE
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return
	else if(istype(W, /obj/item/stack/sheet/metal))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		var/obj/item/stack/sheet/metal/M = W
		if(stat & REPAIR_STEP_THREE)
			to_chat(user, SPAN_NOTICE("You start to construct a new panel for \the [src]."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop constructing a new panel for \the [src]."))
				return FALSE
			if(!M || !M.use(1))
				to_chat(user, SPAN_WARNING("You a sheet of metal to construct a new panel."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You construct a new panel for \the [src]."))
			stat &= ~REPAIR_STEP_THREE
			stat |= REPAIR_STEP_FOUR
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return
	else if(HAS_TRAIT(W, TRAIT_TOOL_MULTITOOL))
		var/obj/item/device/multitool/MT = W

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && !skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
			to_chat(user, SPAN_WARNING("You do not understand how to tweak access requirements in [src]."))
			return FALSE
		if(stat != WORKING)
			to_chat(user, SPAN_WARNING("[src] must be in working condition and powered for you to hack it."))
			return FALSE
		if(!hackable)
			to_chat(user, SPAN_WARNING("You are unable to hack access restrictions in [src]."))
			return FALSE
		to_chat(user, SPAN_WARNING("You start tweaking access restrictions in [src]."))
		if(!do_after(user, MT.hack_speed * sqrt(user.get_skill_duration_multiplier(SKILL_ENGINEER)), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
			to_chat(user, SPAN_WARNING("You stop tweaking access restrictions in [src]."))
			return FALSE
		hack_access(user)
		return TRUE

	///If we want to redeem a token
	else if(istype(W, /obj/item/coin/marine))
		if(!can_access_to_vend(user, ignore_hack = TRUE))
			return FALSE
		. = redeem_token(W, user)
		return

	. = ..()

/obj/structure/machinery/cm_vending/proc/get_listed_products(mob/user)
	return listed_products

/obj/structure/machinery/cm_vending/proc/can_access_to_vend(mob/user, display = TRUE, ignore_hack = FALSE)
	if(HAS_TRAIT(user, TRAIT_OPPOSABLE_THUMBS)) // We're just going to skip the mess of access checks assuming xenos with thumbs are human and just allow them to access because it's funny
		return TRUE
	if(!hacked || ignore_hack)
		if(!allowed(user))
			if(display)
				to_chat(user, SPAN_WARNING("Access denied."))
				vend_fail()
			return FALSE

		var/mob/living/carbon/human/human_user = user
		var/obj/item/card/id/idcard = human_user.get_idcard()
		if(!idcard)
			if(display)
				to_chat(user, SPAN_WARNING("Access denied. No ID card detected"))
				vend_fail()
			return FALSE

		if(!idcard.check_biometrics(human_user))
			if(display)
				to_chat(user, SPAN_WARNING("Wrong ID card owner detected."))
				vend_fail()
			return FALSE

		if(LAZYLEN(vendor_role) && !vendor_role.Find(user.job))
			if(display)
				to_chat(user, SPAN_WARNING("This machine isn't for you."))
				vend_fail()
			return FALSE
	return TRUE

/obj/structure/machinery/cm_vending/proc/vend_fail()
	stat |= IN_USE
	if(vend_delay)
		overlays.Cut()
		icon_state = "[initial(icon_state)]_deny"
	sleep(1.5 SECONDS)
	icon_state = initial(icon_state)
	stat &= ~IN_USE
	update_icon()
	return

//-----------TGUI PROCS------------------------
/obj/structure/machinery/cm_vending/ui_static_data(mob/user)
	. = list()
	.["vendor_name"] = name
	.["vendor_type"] = "base"
	.["theme"] = vendor_theme
	if(vend_flags & VEND_FACTION_THEMES)
		.["theme"] = VENDOR_THEME_COMPANY //for potential future PMC version
		var/mob/living/carbon/human/human = user
		switch(human.faction)
			if(FACTION_UPP)
				.["theme"] = VENDOR_THEME_UPP
			if(FACTION_CLF)
				.["theme"] = VENDOR_THEME_CLF
			if(FACTION_YAUTJA)
				.["theme"] = VENDOR_THEME_YAUTJA
	.["show_points"] = show_points | use_snowflake_points

/obj/structure/machinery/cm_vending/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/vending_products))

//------------GEAR VENDORS---------------
//for special role-related gear

/obj/structure/machinery/cm_vending/gear
	name = "ColMarTech Automated Gear Rack"
	desc = "An automated equipment rack hooked up to a colossal storage of standard-issue gear."
	icon_state = "gear"
	use_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_UNIFORM_AUTOEQUIP

/obj/structure/machinery/cm_vending/gear/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "gear"
	.["displayed_categories"] = vendor_user_inventory_list(user)

//------------CLOTHING VENDORS---------------
//clothing vendors automatically put item on user. QoL at it's finest.

/obj/structure/machinery/cm_vending/clothing
	name = "ColMarTech Automated Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue uniform and armor."
	icon_state = "clothing"
	use_points = TRUE
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_UNIFORM_RANKS | VEND_UNIFORM_AUTOEQUIP | VEND_CATEGORY_CHECK

/obj/structure/machinery/cm_vending/clothing/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "clothing"
	.["displayed_categories"] = vendor_user_inventory_list(user)

//------------SORTED VENDORS---------------
//22.06.2019 Modified ex-"marine_selector" system that doesn't use points by Jeser. In theory, should replace all vendors.
//Hacking can be added if we need it. Do we need it, tho?

/obj/structure/machinery/cm_vending/sorted
	name = "\improper ColMarTech generic sorted rack/vendor"
	desc = "This is pure vendor without points system."
	icon_state = "guns"
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND
	show_points = FALSE

	///this here is made to provide ability to restock vendors with different subtypes of same object, like handmade and manually filled ammo boxes.
	var/list/corresponding_types_list
	/**
	 * If using [VEND_STOCK_DYNAMIC], assoc list of product entry to list of (1.0 scale product multiplier, awarded objects) - as seen in [/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list]
	 * This allows us to backtrack and refill the stocks when new players latejoin.
	 *
	 * If NOT using [VEND_STOCK_DYNAMIC], assoc list of product entry to list of (estimated 1.0 scale product multiplier, scaled product multiplier) - as seen in [/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list]
	 * This allows us to know the original amounts to know if the vendor is full of an item.
	 * The 1.0 scale is estimated because it is a divided by the scale rather than repopulating the list at 1.0 scale - anything that is a fixed amount won't necessarily be correct.
	 */
	var/list/list/dynamic_stock_multipliers
	///indicates someone is performing a restock that isn't instant
	var/being_restocked = FALSE

/obj/structure/machinery/cm_vending/sorted/Initialize()
	. = ..()
	populate_product_list_and_boxes(1.2)
	cm_build_inventory(get_listed_products(), 1, 3)
	corresponding_types_list = GLOB.cm_vending_gear_corresponding_types_list
	GLOB.cm_vending_vendors += src

/obj/structure/machinery/cm_vending/sorted/Destroy()
	GLOB.cm_vending_vendors -= src
	return ..()

///this proc, well, populates product list based on roundstart amount of players
/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list_and_boxes(scale)
	dynamic_stock_multipliers = list()
	if(vend_flags & VEND_STOCK_DYNAMIC)
		populate_product_list(1.0)
		for(var/list/vendspec in listed_products)
			var/multiplier = vendspec[2]
			if(multiplier > 0)
				var/awarded = round(multiplier * scale, 1) // Starting amount
				//Record the multiplier and how many have actually been given out
				dynamic_stock_multipliers[vendspec] = list(multiplier, awarded)
				vendspec[2] = awarded // Override starting amount
	else
		populate_product_list(scale)
		for(var/list/vendspec in listed_products)
			var/amount = vendspec[2]
			if(amount > -1)
				var/multiplier = ceil(amount / scale)
				//Record the multiplier and how many have actually been given out
				dynamic_stock_multipliers[vendspec] = list(multiplier, amount)

	if(vend_flags & VEND_LOAD_AMMO_BOXES)
		populate_ammo_boxes()

	partial_product_stacks = list()
	for(var/list/vendspec in listed_products)
		var/current_type = vendspec[3]
		if(ispath(current_type, /obj/item/stack))
			partial_product_stacks[current_type] = 0

///Updates the vendor stock when the [/datum/game_mode/var/marine_tally] has changed and we're using [VEND_STOCK_DYNAMIC]
///Assumes the scale can only increase!!! Don't take their items away!
/obj/structure/machinery/cm_vending/sorted/proc/update_dynamic_stock(new_scale)
	if(!(vend_flags & VEND_STOCK_DYNAMIC))
		return
	for(var/list/vendspec in dynamic_stock_multipliers)
		var/list/metadata = dynamic_stock_multipliers[vendspec]
		var/multiplier = metadata[1] // How much do we multiply scales by
		var/previous_max_amount = metadata[2] // How many we already handed out at old scale
		var/projected_max_amount = round(new_scale * multiplier, 1) // How much we would have had total now in total
		var/amount_to_add = round(projected_max_amount - previous_max_amount, 1) // Rounding just in case
		if(amount_to_add > 0)
			metadata[2] += amount_to_add
			vendspec[2] += amount_to_add
			update_derived_ammo_and_boxes_on_add(vendspec)

///this proc, well, populates product list based on roundstart amount of players
///do not rely on scale here if you use VEND_STOCK_DYNAMIC because it's already taken into account
///this is here for historical reasons and should ONLY be called by populate_product_list_and_boxes if you want dynamic stocks and ammoboxes to work
/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list(scale)
	return

/obj/structure/machinery/cm_vending/sorted/proc/populate_ammo_boxes()
	var/list/tmp_list = list()
	for(var/list/L as anything in listed_products)
		if(!L[3])
			continue
		var/datum/item_to_multiple_box_pairing/IMBP = GLOB.item_to_box_mapping.get_item_to_box_mapping(L[3])
		if(!IMBP)
			continue
		for(var/datum/item_box_pairing/IBP as anything in IMBP.item_box_pairings)
			tmp_list += list(list(initial(IBP.box.name), floor(L[2] / IBP.items_in_box), IBP.box, VENDOR_ITEM_REGULAR))

	//For every item that goes into a box, check if the box is already listed in the vendor and if so, update its amount
	var/list/box_list = list()
	if(length(tmp_list))
		for(var/list/tmp_item as anything in tmp_list)
			var/item_found = FALSE
			for(var/list/product as anything in listed_products)
				if(tmp_item[3] == product[3]) //We found a box we already have!
					product[2] = tmp_item[2] //Update box amount
					item_found = TRUE
					break
			if(!item_found)
				//We will be adding this box item at the end of the list
				box_list += list(tmp_item)

	//Putting Ammo and other boxes on the bottom of the list if they haven't been accounted for already
	if(length(box_list))
		listed_products += list(list("BOXES", -1, null, null))
		for(var/list/L as anything in box_list)
			listed_products += list(L)

/obj/structure/machinery/cm_vending/sorted/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "sorted"
	.["displayed_categories"] = vendor_user_inventory_list(user, null, 4)

/obj/structure/machinery/cm_vending/sorted/MouseDrop_T(atom/movable/A, mob/user)

	if(inoperable())
		return

	if(!isturf(A.loc) && !ishuman(A.loc))
		return

	if(user.stat || user.is_mob_restrained())
		return

	if(get_dist(user, src) > 1 || get_dist(src, A) > 1)
		return

	if(!ishuman(user))
		return

	// Try to bulk restock using a container
	if(istype(A, /obj/item/storage))
		var/obj/item/storage/container = A
		if(!length(container.contents))
			return
		if(being_restocked)
			to_chat(user, SPAN_WARNING("[src] is already being restocked, you will get in the way!"))
			return

		user.visible_message(SPAN_NOTICE("[user] starts stocking a bunch of supplies into [src]."),
		SPAN_NOTICE("You start stocking a bunch of supplies into [src]."))
		being_restocked = TRUE

		for(var/obj/item/item in container.contents)
			if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src))
				being_restocked = FALSE
				user.visible_message(SPAN_NOTICE("[user] stopped stocking [src] with supplies."),
				SPAN_NOTICE("You stop stocking [src] with supplies."))
				return
			if(QDELETED(item) || item.loc != container)
				being_restocked = FALSE
				user.visible_message(SPAN_NOTICE("[user] stopped stocking [src] with supplies."),
				SPAN_NOTICE("You stop stocking [src] with supplies."))
				return
			stock(item, user)

		being_restocked = FALSE
		user.visible_message(SPAN_NOTICE("[user] finishes stocking [src] with supplies."),
		SPAN_NOTICE("You finish stocking [src] with supplies."))
		return

	if(istype(A, /obj/item))
		stock(A, user)

/obj/structure/machinery/cm_vending/sorted/proc/stock(obj/item/item_to_stock, mob/user)
	if(istype(item_to_stock, /obj/item/storage))
		return FALSE

	var/list/stock_listed_products = get_listed_products(user)
	for(var/list/vendspec as anything in stock_listed_products)
		if(item_to_stock.type == vendspec[3])

			var/partial_stacks = 0
			if(istype(item_to_stock, /obj/item/device/defibrillator))
				var/obj/item/device/defibrillator/defib = item_to_stock
				if(!defib.dcell)
					to_chat(user, SPAN_WARNING("[item_to_stock] needs a cell in it to be restocked!"))
					return FALSE
				if(defib.dcell.charge < defib.dcell.maxcharge)
					to_chat(user, SPAN_WARNING("[item_to_stock] needs to be fully charged to restock it!"))
					return FALSE

			else if(istype(item_to_stock, /obj/item/cell))
				var/obj/item/cell/cell = item_to_stock
				if(cell.charge < cell.maxcharge)
					to_chat(user, SPAN_WARNING("[item_to_stock] needs to be fully charged to restock it!"))
					return FALSE

			else if(istype(item_to_stock, /obj/item/stack))
				var/obj/item/stack/item_stack = item_to_stock
				partial_stacks = item_stack.amount % item_stack.max_amount

			if(!additional_restock_checks(item_to_stock, user, vendspec))
				// the error message needs to go in the proc
				return FALSE

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/container = item_to_stock.loc
				container.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks [src] with \a [vendspec[1]]."),
			SPAN_NOTICE("You stock [src] with \a [vendspec[1]]."))
			if(partial_stacks)
				var/obj/item/stack/item_stack = item_to_stock
				var/existing_stacks = partial_product_stacks[item_to_stock.type]
				var/combined_stacks = existing_stacks + partial_stacks
				if(existing_stacks == 0 || combined_stacks > item_stack.max_amount)
					vendspec[2]++
				partial_product_stacks[item_to_stock.type] = combined_stacks % item_stack.max_amount
			else
				vendspec[2]++
			update_derived_ammo_and_boxes_on_add(vendspec)
			updateUsrDialog()
			return TRUE //We found our item, no reason to go on.

	return FALSE

/// additional restocking checks for individual vendor subtypes. Parse in item, do checks, return FALSE to fail. Include error message.
/obj/structure/machinery/cm_vending/sorted/proc/additional_restock_checks(obj/item/item_to_stock, mob/user, list/vendspec)
	var/dynamic_metadata = dynamic_stock_multipliers[vendspec]
	if(dynamic_metadata)
		if(vendspec[2] >= dynamic_metadata[2])
			if(!istype(item_to_stock, /obj/item/stack))
				to_chat(user, SPAN_WARNING("[src] is already full of [vendspec[1]]!"))
				return FALSE
			var/obj/item/stack/item_stack = item_to_stock
			if(partial_product_stacks[item_to_stock.type] == 0)
				to_chat(user, SPAN_WARNING("[src] is already full of [vendspec[1]]!"))
				return FALSE // No partial stack to fill
			if((partial_product_stacks[item_to_stock.type] + item_stack.amount) > item_stack.max_amount)
				to_chat(user, SPAN_WARNING("[src] is already full of [vendspec[1]]!"))
				return FALSE // Exceeds partial stack to fill
	else
		stack_trace("[src] could not find dynamic_stock_multipliers for [vendspec[1]]!")
	return TRUE

//sending an /empty ammo box type path here will return corresponding regular (full) type of this box
//if there is one set in corresponding_box_types or will return FALSE otherwise
/obj/structure/machinery/cm_vending/sorted/proc/return_corresponding_type(unusual_path)
	if(corresponding_types_list.Find(unusual_path))
		return corresponding_types_list[unusual_path]
	return

//------------GEAR VENDORS---------------
//For vendors with their own points available
/obj/structure/machinery/cm_vending/own_points
	name = "\improper ColMarTech generic vendor"
	desc = "This is a vendor with its own points system."
	icon_state = "gear"
	vendor_theme = VENDOR_THEME_USCM
	use_points = TRUE
	use_snowflake_points = FALSE

	var/available_points = MARINE_TOTAL_BUY_POINTS
	available_points_to_display = MARINE_TOTAL_BUY_POINTS
	instanced_vendor_points = TRUE

/obj/structure/machinery/cm_vending/own_points/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "gear"
	.["displayed_categories"] = vendor_user_inventory_list(user)

//------------ESSENTIALS SETS AND RANDOM GEAR SPAWNER---------------

/obj/effect/essentials_set
	var/list/spawned_gear_list

/obj/effect/essentials_set/New(loc)
	..()
	for(var/typepath in spawned_gear_list)
		if(spawned_gear_list[typepath])
			new typepath(loc, spawned_gear_list[typepath])
		else
			new typepath(loc)
	qdel(src)

//same thing, but spawns only 1 item from the list
/obj/effect/essentials_set/random/New(loc)
	if(!spawned_gear_list)
		return

	var/typepath = pick(spawned_gear_list)
	if(ispath(typepath, /obj/item/weapon/gun))
		new typepath(loc, TRUE)
	else
		new typepath(loc)
	qdel(src)


//---helper glob data
GLOBAL_LIST_INIT(cm_vending_gear_corresponding_types_list, list(
		/obj/item/ammo_box/magazine/mod88/empty = /obj/item/ammo_box/magazine/mod88,
		/obj/item/ammo_box/magazine/m4a3/empty = /obj/item/ammo_box/magazine/m4a3,
		/obj/item/ammo_box/magazine/m4a3/ap/empty = /obj/item/ammo_box/magazine/m4a3/ap,
		/obj/item/ammo_box/magazine/m4a3/hp/empty = /obj/item/ammo_box/magazine/m4a3/hp,
		/obj/item/ammo_box/magazine/su6/empty = /obj/item/ammo_box/magazine/su6,
		/obj/item/ammo_box/magazine/vp78/empty = /obj/item/ammo_box/magazine/vp78,

		/obj/item/ammo_box/magazine/m44/empty = /obj/item/ammo_box/magazine/m44,
		/obj/item/ammo_box/magazine/m44/heavy/empty = /obj/item/ammo_box/magazine/m44/heavy,
		/obj/item/ammo_box/magazine/m44/marksman/empty = /obj/item/ammo_box/magazine/m44/marksman,

		/obj/item/ammo_box/magazine/m39/empty = /obj/item/ammo_box/magazine/m39,
		/obj/item/ammo_box/magazine/m39/ext/empty = /obj/item/ammo_box/magazine/m39/ext,
		/obj/item/ammo_box/magazine/m39/ap/empty = /obj/item/ammo_box/magazine/m39/ap,
		/obj/item/ammo_box/magazine/m39/incen/empty = /obj/item/ammo_box/magazine/m39/incen,
		/obj/item/ammo_box/magazine/m39/le/empty = /obj/item/ammo_box/magazine/m39/le,

		/obj/item/ammo_box/magazine/m4ra/empty = /obj/item/ammo_box/magazine/m4ra,
		/obj/item/ammo_box/magazine/m4ra/ap/empty = /obj/item/ammo_box/magazine/m4ra/ap,
		/obj/item/ammo_box/magazine/m4ra/incen/empty = /obj/item/ammo_box/magazine/m4ra/incen,

		/obj/item/ammo_box/magazine/l42a/empty = /obj/item/ammo_box/magazine/l42a,
		/obj/item/ammo_box/magazine/l42a/ap/empty = /obj/item/ammo_box/magazine/l42a/ap,
		/obj/item/ammo_box/magazine/l42a/ext/empty = /obj/item/ammo_box/magazine/l42a/ext,
		/obj/item/ammo_box/magazine/l42a/incen/empty = /obj/item/ammo_box/magazine/l42a/incen,
		/obj/item/ammo_box/magazine/l42a/le/empty = /obj/item/ammo_box/magazine/l42a/le,

		/obj/item/ammo_box/magazine/empty = /obj/item/ammo_box/magazine,
		/obj/item/ammo_box/magazine/ap/empty = /obj/item/ammo_box/magazine/ap,
		/obj/item/ammo_box/magazine/explosive/empty = /obj/item/ammo_box/magazine/explosive,
		/obj/item/ammo_box/magazine/ext/empty = /obj/item/ammo_box/magazine/ext,
		/obj/item/ammo_box/magazine/incen/empty = /obj/item/ammo_box/magazine/incen,
		/obj/item/ammo_box/magazine/le/empty = /obj/item/ammo_box/magazine/le,

		/obj/item/ammo_box/magazine/shotgun/beanbag/empty = /obj/item/ammo_box/magazine/shotgun/beanbag,
		/obj/item/ammo_box/magazine/shotgun/buckshot/empty = /obj/item/ammo_box/magazine/shotgun/buckshot,
		/obj/item/ammo_box/magazine/shotgun/flechette/empty = /obj/item/ammo_box/magazine/shotgun/flechette,
		/obj/item/ammo_box/magazine/shotgun/incendiary/empty = /obj/item/ammo_box/magazine/shotgun/incendiary,
		/obj/item/ammo_box/magazine/shotgun/empty = /obj/item/ammo_box/magazine/shotgun,

		/obj/item/ammo_box/magazine/lever_action/empty = /obj/item/ammo_box/magazine/lever_action,
		/obj/item/ammo_box/magazine/lever_action/training/empty = /obj/item/ammo_box/magazine/lever_action/training,
		/obj/item/ammo_box/magazine/lever_action/tracker/empty = /obj/item/ammo_box/magazine/lever_action/tracker,
		/obj/item/ammo_box/magazine/lever_action/marksman/empty = /obj/item/ammo_box/magazine/lever_action/marksman,
		/obj/item/ammo_box/magazine/lever_action/xm88/empty = /obj/item/ammo_box/magazine/lever_action/xm88,

		/obj/item/ammo_box/rounds/smg/empty = /obj/item/ammo_box/rounds/smg,
		/obj/item/ammo_box/rounds/smg/ap/empty = /obj/item/ammo_box/rounds/smg/ap,
		/obj/item/ammo_box/rounds/smg/incen/empty = /obj/item/ammo_box/rounds/smg/incen,
		/obj/item/ammo_box/rounds/smg/le/empty = /obj/item/ammo_box/rounds/smg/le,

		/obj/item/ammo_box/rounds/empty = /obj/item/ammo_box/rounds,
		/obj/item/ammo_box/rounds/ap/empty = /obj/item/ammo_box/rounds/ap,
		/obj/item/ammo_box/rounds/incen/empty = /obj/item/ammo_box/rounds/incen,
		/obj/item/ammo_box/rounds/le/empty = /obj/item/ammo_box/rounds/le,

		/obj/item/ammo_box/magazine/M16/empty = /obj/item/ammo_box/magazine/M16,
		/obj/item/ammo_box/magazine/M16/ap/empty = /obj/item/ammo_box/magazine/M16/ap,

		/obj/item/ammo_box/magazine/misc/mre/empty = /obj/item/ammo_box/magazine/misc/mre,
		/obj/item/ammo_box/magazine/misc/flares/empty = /obj/item/ammo_box/magazine/misc/flares,

		/obj/item/stack/folding_barricade = /obj/item/stack/folding_barricade/three,

		/obj/item/stack/sheet/cardboard = /obj/item/stack/sheet/cardboard/small_stack,
		/obj/item/stack/sheet/cardboard/medium_stack = /obj/item/stack/sheet/cardboard/small_stack,
		/obj/item/stack/sheet/cardboard/full_stack = /obj/item/stack/sheet/cardboard/small_stack,

		/obj/item/stack/barbed_wire = /obj/item/stack/barbed_wire/small_stack,
		/obj/item/stack/barbed_wire/full_stack = /obj/item/stack/barbed_wire/small_stack,

		/obj/item/stack/sheet/metal = /obj/item/stack/sheet/metal/small_stack,
		/obj/item/stack/sheet/metal/med_small_stack = /obj/item/stack/sheet/metal/small_stack,
		/obj/item/stack/sheet/metal/medium_stack = /obj/item/stack/sheet/metal/small_stack,
		/obj/item/stack/sheet/metal/med_large_stack = /obj/item/stack/sheet/metal/small_stack,
		/obj/item/stack/sheet/metal/large_stack = /obj/item/stack/sheet/metal/small_stack,

		/obj/item/stack/sheet/plasteel = /obj/item/stack/sheet/plasteel/small_stack,
		/obj/item/stack/sheet/plasteel/med_small_stack = /obj/item/stack/sheet/plasteel/small_stack,
		/obj/item/stack/sheet/plasteel/medium_stack = /obj/item/stack/sheet/plasteel/small_stack,
		/obj/item/stack/sheet/plasteel/med_large_stack = /obj/item/stack/sheet/plasteel/small_stack,
		/obj/item/stack/sheet/plasteel/large_stack = /obj/item/stack/sheet/plasteel/small_stack,

		/obj/item/stack/sandbags_empty = /obj/item/stack/sandbags_empty/small_stack,
		/obj/item/stack/sandbags_empty/half = /obj/item/stack/sandbags_empty/small_stack,
		/obj/item/stack/sandbags_empty/full = /obj/item/stack/sandbags_empty/small_stack,

		/obj/item/stack/sandbags = /obj/item/stack/sandbags/small_stack,
		/obj/item/stack/sandbags/large_stack = /obj/item/stack/sandbags/small_stack,

		/obj/item/storage/large_holster/machete = /obj/item/storage/large_holster/machete/full,

	))

//---helper procs

/obj/structure/machinery/cm_vending/proc/vendor_user_inventory_list(mob/user, cost_index=2, priority_index=5)
	. = list()
	// default list format
	// (
	// name: str
	// cost
	// item reference
	// allowed to buy flag
	// item priority (mandatory/recommended/regular)
	// )
	var/list/ui_listed_products = get_listed_products(user)

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products

		var/p_name = myprod[1] //taking it's name
		var/p_cost = cost_index == null ? 0 : myprod[cost_index]
		var/obj/item/item_ref = myprod[3]
		var/priority = myprod[priority_index]
		if(islist(item_ref)) // multi-vending
			var/list/ref_list = item_ref
			item_ref = ref_list[1]
		var/icon/image_icon = icon(initial(item_ref.icon), initial(item_ref.icon_state))
		var/image_size = "[image_icon.Width()]x[image_icon.Height()]"

		var/is_category = item_ref == null

		var/imgid = replacetext(replacetext("[item_ref]", "/obj/item/", ""), "/", "-")
		//forming new list with index, name, amount, available or not, color and add it to display_list

		var/display_item = list(
			"prod_index" = i,
			"prod_name" = p_name,
			"prod_color" = priority,
			"prod_desc" = initial(item_ref.desc),
			"prod_cost" = p_cost,
			"image" = imgid,
			"image_size" = image_size,
		)

		if (is_category == 1)
			. += list(list(
				"name" = p_name,
				"items" = list()
			))
			continue

		if (!LAZYLEN(.))
			. += list(list(
				"name" = "",
				"items" = list()
			))
		var/last_index = LAZYLEN(.)
		var/last_category = .[last_index]
		last_category["items"] += list(display_item)

/obj/structure/machinery/cm_vending/proc/vendor_inventory_ui_data(mob/user)
	. = list()
	var/list/products = get_listed_products(user)
	var/list/product_amounts = list()
	var/list/product_partials = list()

	for(var/i in 1 to length(products))
		var/list/cur_prod = products[i] //we take one list from listed_products
		product_amounts += list(cur_prod[2]) //amount left
		var/cur_type = cur_prod[3]
		var/cur_amount_partial = 0
		if(cur_type in partial_product_stacks)
			cur_amount_partial = partial_product_stacks[cur_type]
		product_partials += list(cur_amount_partial)
	.["stock_listing"] = product_amounts
	.["stock_listing_partials"] = product_partials

/obj/structure/machinery/cm_vending/proc/vendor_successful_vend(list/itemspec, mob/living/carbon/human/user)
	if(stat & IN_USE)
		return
	stat |= IN_USE

	var/turf/target_turf = get_appropriate_vend_turf(user)
	if(LAZYLEN(itemspec)) //making sure it's not empty
		if(vend_delay)
			overlays.Cut()
			flick("[initial(icon_state)]_vend", src)
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2) //heard only near vendor
			sleep(vend_delay)

		var/prod_type = itemspec[3]
		var/stack_amount = 0
		if(vend_flags & VEND_LIMITED_INVENTORY)
			itemspec[2]--
			if(itemspec[2] == 0)
				stack_amount = partial_product_stacks[prod_type]
				partial_product_stacks[prod_type] = 0
			if(vend_flags & VEND_LOAD_AMMO_BOXES)
				update_derived_ammo_and_boxes(itemspec)

		if(islist(prod_type))
			for(var/each_type in prod_type)
				vendor_successful_vend_one(each_type, user, target_turf, itemspec[4] == MARINE_CAN_BUY_UNIFORM, stack_amount)
				SEND_SIGNAL(src, COMSIG_VENDOR_SUCCESSFUL_VEND, src, itemspec, user)
		else
			vendor_successful_vend_one(prod_type, user, target_turf, itemspec[4] == MARINE_CAN_BUY_UNIFORM, stack_amount)
			SEND_SIGNAL(src, COMSIG_VENDOR_SUCCESSFUL_VEND, src, itemspec, user)

	else
		to_chat(user, SPAN_WARNING("ERROR: itemspec is missing. Please report this to admins."))
		sleep(15)

	stat &= ~IN_USE
	icon_state = initial(icon_state)
	update_icon()

/obj/structure/machinery/cm_vending/proc/vendor_successful_vend_one(prod_type, mob/living/carbon/human/user, turf/target_turf, insignas_override, stack_amount)
	var/obj/item/new_item
	if(vend_flags & VEND_PROPS)
		new_item = new /obj/item/prop/replacer(target_turf, prod_type)
	else if(ispath(prod_type, /obj/item))
		if(ispath(prod_type, /obj/item/weapon/gun))
			new_item = new prod_type(target_turf, TRUE)
		else
			if(prod_type == /obj/item/device/radio/headset/almayer/marine)
				prod_type = headset_type
			else if(prod_type == /obj/item/clothing/gloves/marine)
				prod_type = gloves_type
			if(stack_amount > 0 && ispath(prod_type, /obj/item/stack))
				new_item = new prod_type(target_turf, stack_amount)
			else
				new_item = new prod_type(target_turf)

		new_item.add_fingerprint(user)
	else
		new_item = new prod_type(target_turf)

	if(vend_flags & VEND_UNIFORM_RANKS)
		if(insignas_override)
			var/obj/item/clothing/under/underclothes = new_item
			var/obj/item/card/id/card = user.get_idcard()

			//Gives ranks to the ranked
			if(istype(underclothes) && card?.paygrade)
				var/rankpath = get_rank_pins(card.paygrade)
				if(rankpath)
					var/obj/item/clothing/accessory/ranks/rank_insignia = new rankpath()
					var/obj/item/clothing/accessory/patch/uscmpatch = new()
					underclothes.attach_accessory(user, rank_insignia)
					underclothes.attach_accessory(user, uscmpatch)

	if(vend_flags & VEND_UNIFORM_AUTOEQUIP)
		// autoequip
		if(istype(new_item, /obj/item) && new_item.flags_equip_slot != NO_FLAGS) //auto-equipping feature here
			if(new_item.flags_equip_slot == SLOT_ACCESSORY)
				if(user.w_uniform)
					var/obj/item/clothing/clothing = user.w_uniform
					if(clothing.can_attach_accessory(new_item))
						clothing.attach_accessory(user, new_item)
			else
				user.equip_to_appropriate_slot(new_item)

	if(vend_flags & VEND_TO_HAND)
		if(user.client?.prefs && (user.client?.prefs?.toggle_prefs & TOGGLE_VEND_ITEM_TO_HAND))
			if(Adjacent(user))
				user.put_in_any_hand_if_possible(new_item, disable_warning = TRUE)

	new_item.post_vendor_spawn_hook(user)

/obj/structure/machinery/cm_vending/proc/handle_vend(list/listed_products, mob/living/carbon/human/vending_human)
	if(vend_flags & VEND_USE_VENDOR_FLAGS)
		return TRUE
	var/buying_category = listed_products[4]
	if(buying_category)
		if(!(buying_category in vending_human.marine_buyable_categories))
			return FALSE
		if(!vending_human.marine_buyable_categories[buying_category])
			return FALSE
		vending_human.marine_buyable_categories[buying_category] -= 1
	return TRUE

// Unload ALL the items throwing them around randomly, optionally destroying the vendor
/obj/structure/machinery/cm_vending/proc/catastrophic_failure(throw_objects = TRUE, destroy = FALSE)
	stat |= IN_USE
	var/list/products = get_listed_products()
	var/i = 1
	while(i <= length(products))
		sleep(0.5)
		var/list/itemspec = products[i]
		var/itemspec_item = itemspec[3]
		if(!itemspec[2] || itemspec[2] <= 0)
			i++
			continue
		itemspec[2]--
		var/list/spawned = list()
		if(islist(itemspec_item))
			for(var/path in itemspec_item)
				spawned += new path(loc)
		else if(itemspec_item)
			if(itemspec[2] == 0 && partial_product_stacks[itemspec_item] > 0 && ispath(itemspec_item, /obj/item/stack))
				var/stack_amount = partial_product_stacks[itemspec_item]
				partial_product_stacks[itemspec_item] = 0
				spawned += new itemspec_item(loc, stack_amount)
			else
				spawned += new itemspec_item(loc)
		if(throw_objects)
			for(var/atom/movable/spawned_atom in spawned)
				INVOKE_ASYNC(spawned_atom, TYPE_PROC_REF(/atom/movable, throw_atom), pick(ORANGE_TURFS(4, src)), 4, SPEED_FAST)
	stat &= ~IN_USE
	if(destroy)
		qdel(src)
