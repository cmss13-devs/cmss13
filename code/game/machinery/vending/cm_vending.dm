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

	var/vend_x_offset = 0
	var/vend_y_offset = 0

	var/list/listed_products = list()

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

/obj/structure/machinery/power_change(area/master_area = null)
	..()
	update_icon()

/obj/structure/machinery/cm_vending/update_icon()

	//restoring sprite to initial
	overlays.Cut()
	//icon_state = initial(icon_state) //shouldn't be needed but just in case
	var/matrix/A = matrix()
	apply_transform(A)

	if(stat & NOPOWER || stat & TIPPED_OVER) //tipping off without breaking uses "_off" sprite
		overlays += image(icon, "[icon_state]_off")
	if(stat & MAINT) //if we require maintenance, then it is completely "_broken"
		icon_state = "[initial(icon_state)]_broken"
		if(stat & IN_REPAIR) //if someone started repairs, they unscrewed "_panel"
			overlays += image(icon, "[icon_state]_panel")

	if(stat & TIPPED_OVER) //finally, if it is tipped over, flip the sprite
		A.Turn(90)
		apply_transform(A)

/obj/structure/machinery/cm_vending/ex_act(severity)
	if(indestructible)
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

		GLOB.vending_products[typepath] = 1

//get which turf the vendor will dispense its products on.
/obj/structure/machinery/cm_vending/proc/get_appropriate_vend_turf()
	var/turf/T = loc
	if(vend_x_offset != 0 || vend_y_offset != 0) //this check should be more less expensive than using locate to locate your own tile every vending.
		T = locate(x + vend_x_offset, y + vend_y_offset, z)
	return T

/obj/structure/machinery/cm_vending/get_examine_text(mob/living/carbon/human/user)
	. = ..()

	if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI) && hackable)
		. += SPAN_NOTICE("You believe you can hack this one to remove the access requirements.")

/obj/structure/machinery/cm_vending/proc/hack_access(mob/user)
	if(!hackable)
		to_chat(user, SPAN_WARNING("[src] cannot be hacked."))
		return

	hacked = !hacked
	if(hacked)
		to_chat(user, SPAN_WARNING("You have succesfully removed access restrictions in [src]."))
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
				product[2] = round(base_ammo_item[2] / item_box_pairing.items_in_box)
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
		if(flare_pack.contents.len < flare_pack.max_storage_space)
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
		var/obj/item/weapon/melee/claymore/mercsword/machete/mac = locate(/obj/item/weapon/melee/claymore/mercsword/machete) in item_to_stock
		if(!mac)
			if(user)
				to_chat(user, SPAN_WARNING("\The [item_to_stock] is empty."))
			return FALSE
	//Machete holsters handling
	else if(istype(item_to_stock, /obj/item/clothing/suit/storage/marine))
		var/obj/item/clothing/suit/storage/marine/AR = item_to_stock
		if(AR.pockets && AR.pockets.contents.len)
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
		else if(A.contents.len < A.num_of_magazines)
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
		if(AR.pockets && AR.pockets.contents.len)
			if(user)
				to_chat(user, SPAN_WARNING("\The [AR] has something inside it. Empty it before restocking."))
			return FALSE
	//Marine helmet handling
	else if(istype(item_to_stock, /obj/item/clothing/head/helmet/marine))
		var/obj/item/clothing/head/helmet/marine/H = item_to_stock
		if(H.pockets && H.pockets.contents.len)
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

/obj/structure/machinery/cm_vending/attack_alien(mob/living/carbon/xenomorph/M)
	if(stat & TIPPED_OVER || indestructible)
		to_chat(M, SPAN_WARNING("There's no reason to bother with that old piece of trash."))
		return XENO_NO_DELAY_ACTION

	if(M.a_intent == INTENT_HARM && !unslashable)
		M.animation_attack_on(src)
		if(prob(M.melee_damage_lower))
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
			M.visible_message(SPAN_DANGER("[M] smashes [src] beyond recognition!"), \
			SPAN_DANGER("You enter a frenzy and smash [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			malfunction()
			tip_over()
		else
			M.visible_message(SPAN_DANGER("[M] slashes [src]!"), \
			SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
			playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		return XENO_ATTACK_ACTION

	if(M.action_busy)
		return XENO_NO_DELAY_ACTION

	M.visible_message(SPAN_WARNING("[M] begins to lean against [src]."), \
	SPAN_WARNING("You begin to lean against [src]."), null, 5, CHAT_TYPE_XENO_COMBAT)
	var/shove_time = 80
	if(M.mob_size >= MOB_SIZE_BIG)
		shove_time = 30
	if(istype(M,/mob/living/carbon/xenomorph/crusher))
		shove_time = 15

	xeno_attack_delay(M) //Adds delay here and returns nothing because otherwise it'd cause lag *after* finishing the shove.

	if(do_after(M, shove_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		M.animation_attack_on(src)
		M.visible_message(SPAN_DANGER("[M] knocks [src] down!"), \
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

//------------TGUI PROCS---------------

/obj/structure/machinery/cm_vending/ui_data(mob/user)
	return vendor_user_ui_data(src, user)

/obj/structure/machinery/cm_vending/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/user = usr
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
				if(target_turf.contents.len > 25)
					to_chat(usr, SPAN_WARNING("The floor is too cluttered, make some space."))
					vend_fail()
					return FALSE

			if((!user.assigned_squad && squad_tag) || (!user.assigned_squad?.omni_squad_vendor && (squad_tag && user.assigned_squad.name != squad_tag)))
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
							else if(!user.skills || user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ALL)
								to_chat(user, SPAN_WARNING("You already have a specialization."))
								vend_fail()
								return FALSE
							var/p_name = itemspec[1]
							if(!available_specialist_sets.Find(p_name))
								to_chat(user, SPAN_WARNING("That set is already taken."))
								vend_fail()
								return FALSE
							var/obj/item/card/id/ID = user.wear_id
							if(!istype(ID) || ID.registered_ref != WEAKREF(usr))
								to_chat(user, SPAN_WARNING("You must be wearing your [SPAN_INFO("dog tags")] to select a specialization!"))
								return FALSE
							var/specialist_assignment
							switch(p_name)
								if("Scout Set")
									user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SCOUT)
									specialist_assignment = "Scout"
								if("Sniper Set")
									user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SNIPER)
									specialist_assignment = "Sniper"
								if("Demolitionist Set")
									user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_ROCKET)
									specialist_assignment = "Demo"
								if("Heavy Grenadier Set")
									user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)
									specialist_assignment = "Grenadier"
								if("Pyro Set")
									user.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_PYRO)
									specialist_assignment = "Pyro"
								else
									to_chat(user, SPAN_WARNING("<b>Something bad occured with [src], tell a Dev.</b>"))
									vend_fail()
									return FALSE
							ID.set_assignment((user.assigned_squad ? (user.assigned_squad.name + " ") : "") + JOB_SQUAD_SPECIALIST + " ([specialist_assignment])")
							GLOB.data_core.manifest_modify(user.real_name, WEAKREF(user), ID.assignment)
							available_specialist_sets -= p_name
						else if(vendor_role.Find(JOB_SYNTH))
							if(user.job != JOB_SYNTH)
								to_chat(user, SPAN_WARNING("Only USCM Synthetics may vend experimental tool tokens."))
								vend_fail()
								return FALSE

					if(!handle_vend(src, itemspec, user))
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

			vendor_successful_vend(src, itemspec, user)
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
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
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
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
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
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
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
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
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

		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI) && !skillcheckexplicit(user, SKILL_ANTAG, SKILL_ANTAG_AGENT))
			to_chat(user, SPAN_WARNING("You do not understand how tweak access requirements in [src]."))
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

	..()

/obj/structure/machinery/cm_vending/proc/get_listed_products(mob/user)
	return listed_products

/obj/structure/machinery/cm_vending/proc/can_access_to_vend(mob/user, display=TRUE)
	if(!hacked)
		if(!allowed(user))
			if(display)
				to_chat(user, SPAN_WARNING("Access denied."))
				vend_fail()
			return FALSE

		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/I = H.wear_id
		if(!istype(I))
			if(display)
				to_chat(user, SPAN_WARNING("Access denied. No ID card detected"))
				vend_fail()
			return FALSE

		if(I.registered_name != user.real_name)
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
	.["show_points"] = show_points | use_snowflake_points

/obj/structure/machinery/cm_vending/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/spritesheet/vending_products))

//------------GEAR VENDORS---------------
//for special role-related gear

/obj/structure/machinery/cm_vending/gear
	name = "ColMarTech Automated Gear Rack"
	desc = "An automated equipment rack hooked up to a colossal storage of standard-issue gear."
	icon_state = "gear_rack"
	use_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_TO_HAND

/obj/structure/machinery/cm_vending/gear/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "gear"
	.["displayed_categories"] = vendor_user_inventory_list(src, user)

//------------CLOTHING VENDORS---------------
//clothing vendors automatically put item on user. QoL at it's finest.

/obj/structure/machinery/cm_vending/clothing
	name = "ColMarTech Automated Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue uniform and armor."
	icon_state = "clothing"
	use_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	show_points = FALSE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_UNIFORM_RANKS | VEND_UNIFORM_AUTOEQUIP | VEND_CATEGORY_CHECK

/obj/structure/machinery/cm_vending/clothing/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "clothing"
	.["displayed_categories"] = vendor_user_inventory_list(src, user)

//------------SORTED VENDORS---------------
//22.06.2019 Modified ex-"marine_selector" system that doesn't use points by Jeser. In theory, should replace all vendors.
//Hacking can be added if we need it. Do we need it, tho?

/obj/structure/machinery/cm_vending/sorted
	name = "\improper ColMarTech generic sorted rack/vendor"
	desc = "This is pure vendor without points system."
	icon_state = "guns_rack"
	vendor_theme = VENDOR_THEME_USCM
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND
	show_points = FALSE

	//this here is made to provide ability to restock vendors with different subtypes of same object, like handmade and manually filled ammo boxes.
	var/list/corresponding_types_list

/obj/structure/machinery/cm_vending/sorted/Initialize()
	. = ..()
	populate_product_list_and_boxes(1.2)
	cm_build_inventory(get_listed_products(), 1, 3)
	corresponding_types_list = GLOB.cm_vending_gear_corresponding_types_list
	GLOB.cm_vending_vendors += src

/obj/structure/machinery/cm_vending/sorted/Destroy()
	GLOB.cm_vending_vendors -= src
	return ..()

//this proc, well, populates product list based on roundstart amount of players
/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list_and_boxes(scale)
	populate_product_list(scale)
	if(vend_flags & VEND_LOAD_AMMO_BOXES)
		populate_ammo_boxes()
	return

//this proc, well, populates product list based on roundstart amount of players
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
			tmp_list += list(list(initial(IBP.box.name), round(L[2] / IBP.items_in_box), IBP.box, VENDOR_ITEM_REGULAR))

	//Putting Ammo and other boxes on the bottom of the list as per player preferences
	if(tmp_list.len > 0)
		listed_products += list(list("BOXES", -1, null, null))
		for(var/list/L as anything in tmp_list)
			listed_products += list(L)

/obj/structure/machinery/cm_vending/sorted/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "sorted"
	.["displayed_categories"] = vendor_user_inventory_list(src, user, null, 4)

/obj/structure/machinery/cm_vending/sorted/MouseDrop_T(atom/movable/A, mob/user)

	if(inoperable())
		return

	if(user.stat || user.is_mob_restrained() || user.lying)
		return

	if(get_dist(user, src) > 1 || get_dist(src, A) > 1)
		return

	if(istype(A, /obj/item))
		var/obj/item/I = A
		stock(I, user)

/obj/structure/machinery/cm_vending/sorted/proc/stock(obj/item/item_to_stock, mob/user)
	var/list/R
	var/list/stock_listed_products = get_listed_products(user)
	for(R in (stock_listed_products))
		if(item_to_stock.type == R[3] && !istype(item_to_stock,/obj/item/storage))

			if(istype(item_to_stock, /obj/item/device/defibrillator))
				var/obj/item/device/defibrillator/D = item_to_stock
				if(!D.dcell)
					to_chat(user, SPAN_WARNING("\The [item_to_stock] needs a cell in it to be restocked!"))
					return
				if(D.dcell.charge < D.dcell.maxcharge)
					to_chat(user, SPAN_WARNING("\The [item_to_stock] needs to be fully charged to restock it!"))
					return

			if(istype(item_to_stock, /obj/item/cell))
				var/obj/item/cell/C = item_to_stock
				if(C.charge < C.maxcharge)
					to_chat(user, SPAN_WARNING("\The [item_to_stock] needs to be fully charged to restock it!"))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks [src] with \a [R[1]]."),
			SPAN_NOTICE("You stock [src] with \a [R[1]]."))
			R[2]++
			update_derived_ammo_and_boxes_on_add(R)
			updateUsrDialog()
			return //We found our item, no reason to go on.

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
	icon_state = "guns_rack"
	vendor_theme = VENDOR_THEME_USCM
	use_points = TRUE
	use_snowflake_points = FALSE

	var/available_points = MARINE_TOTAL_BUY_POINTS
	available_points_to_display = MARINE_TOTAL_BUY_POINTS
	instanced_vendor_points = TRUE

/obj/structure/machinery/cm_vending/own_points/ui_static_data(mob/user)
	. = ..(user)
	.["vendor_type"] = "gear"
	.["displayed_categories"] = vendor_user_inventory_list(src, user)

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

/proc/vendor_user_inventory_list(vendor, mob/user, cost_index=2, priority_index=5)
	. = list()
	// default list format
	// (
	// name: str
	// cost
	// item reference
	// allowed to buy flag
	// item priority (mandatory/recommended/regular)
	// )
	var/obj/structure/machinery/cm_vending/vending_machine = vendor
	var/list/ui_listed_products = vending_machine.get_listed_products(user)

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products

		var/p_name = myprod[1] //taking it's name
		var/p_cost = cost_index == null ? 0 : myprod[cost_index]
		var/item_ref = myprod[3]
		var/priority = myprod[priority_index]

		var/obj/item/I = item_ref

		var/is_category = item_ref == null

		var/imgid = replacetext(replacetext("[item_ref]", "/obj/item/", ""), "/", "-")
		//forming new list with index, name, amount, available or not, color and add it to display_list

		var/display_item = list(
			"prod_index" = i,
			"prod_name" = p_name,
			"prod_color" = priority,
			"prod_desc" = initial(I.desc),
			"prod_cost" = p_cost,
			"image" = imgid
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

/proc/vendor_inventory_ui_data(vendor, mob/user)
	. = list()
	var/obj/structure/machinery/cm_vending/vending_machine = vendor
	var/list/ui_listed_products = vending_machine.get_listed_products(user)
	var/list/ui_categories = list()

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/p_amount = myprod[2] //amount left
		ui_categories += list(p_amount)
	.["stock_listing"] = ui_categories

/proc/vendor_user_ui_data(obj/structure/machinery/cm_vending/vending_machine, mob/user)
	if(vending_machine.vend_flags & VEND_LIMITED_INVENTORY)
		return vendor_inventory_ui_data(vending_machine, user)

	. = list()
	var/list/ui_listed_products = vending_machine.get_listed_products(user)
	// list format
	// (
	// name: str
	// cost
	// item reference
	// allowed to buy flag
	// item priority (mandatory/recommended/regular)
	// )

	var/list/stock_values = list()

	var/mob/living/carbon/human/H = user
	var/buy_flags = H.marine_buy_flags
	var/points = 0

	if(vending_machine.instanced_vendor_points)
		points = vending_machine.available_points_to_display
	else
		if(vending_machine.use_snowflake_points)
			points = H.marine_snowflake_points
		else if(vending_machine.use_points)
			points = H.marine_points

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/avail_flag = myprod[4]
		if(points >= p_cost && (!avail_flag || buy_flags & avail_flag))
			prod_available = TRUE
		stock_values += list(prod_available)

	.["stock_listing"] = stock_values
	.["current_m_points"] = points

/proc/vendor_successful_vend(obj/structure/machinery/cm_vending/vendor, list/itemspec, mob/living/carbon/human/user)
	if(vendor.stat & IN_USE)
		return
	vendor.stat |= IN_USE

	var/vend_flags = vendor.vend_flags

	var/turf/target_turf = vendor.get_appropriate_vend_turf(user)
	if(LAZYLEN(itemspec)) //making sure it's not empty
		if(vendor.vend_delay)
			vendor.overlays.Cut()
			vendor.icon_state = "[initial(vendor.icon_state)]_vend"
			if(vendor.vend_sound)
				playsound(vendor.loc, vendor.vend_sound, 25, 1, 2) //heard only near vendor
			sleep(vendor.vend_delay)

		var/prod_type = itemspec[3]

		var/obj/item/new_item
		if(ispath(prod_type, /obj/item))
			if(ispath(prod_type, /obj/item/weapon/gun))
				new_item = new prod_type(target_turf, TRUE)
			else
				if(prod_type == /obj/item/device/radio/headset/almayer/marine)
					prod_type = vendor.headset_type
				else if(prod_type == /obj/item/clothing/gloves/marine)
					prod_type = vendor.gloves_type
				new_item = new prod_type(target_turf)
			new_item.add_fingerprint(user)
		else
			new_item = new prod_type(target_turf)

		if(vend_flags & VEND_LIMITED_INVENTORY)
			itemspec[2]--
			if(vend_flags & VEND_LOAD_AMMO_BOXES)
				vendor.update_derived_ammo_and_boxes(itemspec)

		if(vend_flags & VEND_UNIFORM_RANKS)
			// apply ranks to clothing
			var/bitf = itemspec[4]
			if(bitf)
				if(bitf == MARINE_CAN_BUY_UNIFORM)
					var/obj/item/clothing/under/underclothes = new_item
					//Gives ranks to the ranked
					if(user.wear_id && user.wear_id.paygrade)
						var/rankpath = get_rank_pins(user.wear_id.paygrade)
						if(rankpath)
							var/obj/item/clothing/accessory/ranks/rank_insignia = new rankpath()
							underclothes.attach_accessory(user, rank_insignia)

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
				if(vendor.Adjacent(user))
					user.put_in_any_hand_if_possible(new_item, disable_warning = TRUE)
	else
		to_chat(user, SPAN_WARNING("ERROR: itemspec is missing. Please report this to admins."))
		sleep(15)

	vendor.stat &= ~IN_USE
	vendor.update_icon()

/proc/handle_vend(obj/structure/machinery/cm_vending/vendor, list/listed_products, mob/living/carbon/human/vending_human)
	if(vendor.vend_flags & VEND_USE_VENDOR_FLAGS)
		return TRUE
	var/can_buy_flags = listed_products[4]
	if(!(vending_human.marine_buy_flags & can_buy_flags))
		return FALSE

	if(can_buy_flags == (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH))
		if(vending_human.marine_buy_flags & MARINE_CAN_BUY_R_POUCH)
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_R_POUCH
		else
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_L_POUCH
		return TRUE
	if(can_buy_flags == (MARINE_CAN_BUY_COMBAT_R_POUCH|MARINE_CAN_BUY_COMBAT_L_POUCH))
		if(vending_human.marine_buy_flags & MARINE_CAN_BUY_COMBAT_R_POUCH)
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_COMBAT_R_POUCH
		else
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_COMBAT_L_POUCH
		return TRUE

	vending_human.marine_buy_flags &= ~can_buy_flags
	return TRUE


//------------HACKING---------------

//Hacking code from old vendors, in case someone will actually would like to add complex hacking in future. For now, simple access hacking I believe sufficient.
/*
/obj/structure/machinery/vending/proc/get_wire_descriptions()
	return list(
		VENDING_WIRE_EXTEND = "Inventory control computer",
		VENDING_WIRE_IDSCAN = "ID scanner",
		VENDING_WIRE_SHOCK  = "Ground safety",
		VENDING_WIRE_SHOOT_INV = "Dispenser motor control"
	)

/obj/structure/machinery/vending/proc/isWireCut(wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/vending/proc/cut(wire)
	wires ^= getWireFlag(wire)

	switch(wire)
		if(VENDING_WIRE_EXTEND)
			src.extended_inventory = 0
			visible_message(SPAN_NOTICE("A weak yellow light turns off underneath \the [src]."))
		if(VENDING_WIRE_SHOCK)
			src.seconds_electrified = -1
			visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src]!"))
		if (VENDING_WIRE_SHOOT_INV)
			if(!src.shoot_inventory)
				src.shoot_inventory = TRUE
				visible_message(SPAN_WARNING("\The [src] begins whirring noisily."))

/obj/structure/machinery/vending/proc/mend(wire)
	wires |= getWireFlag(wire)

	switch(wire)
		if(VENDING_WIRE_EXTEND)
			src.extended_inventory = 1
			visible_message(SPAN_NOTICE("A weak yellow light turns on underneath \the [src]."))
		if(VENDING_WIRE_SHOCK)
			src.seconds_electrified = 0
		if (VENDING_WIRE_SHOOT_INV)
			src.shoot_inventory = FALSE
			visible_message(SPAN_NOTICE("\The [src] stops whirring."))

/obj/structure/machinery/vending/proc/pulse(wire)
	switch(wire)
		if(VENDING_WIRE_EXTEND)
			src.extended_inventory = !src.extended_inventory
			visible_message(SPAN_NOTICE("A weak yellow light turns [extended_inventory ? "on" : "off"] underneath \the [src]."))
		if (VENDING_WIRE_SHOCK)
			src.seconds_electrified = 30
			visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src]!"))
		if (VENDING_WIRE_SHOOT_INV)
			src.shoot_inventory = !src.shoot_inventory
			if(shoot_inventory)
				visible_message(SPAN_WARNING("\The [src] begins whirring noisily."))
			else
				visible_message(SPAN_NOTICE("\The [src] stops whirring."))
*/
