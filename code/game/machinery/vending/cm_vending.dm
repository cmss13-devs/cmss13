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

	var/vendor_theme = VENDOR_THEME_COMPANY		//sets vendor theme in NanoUI

	var/list/vendor_role = list()	//to be compared with assigned_role to only allow those to use that machine. Converted to list by Jeser 09.05.20
	var/squad_tag = ""				//same to restrict vendor to specified squad

	var/use_points = FALSE			//disabling these two grants unlimited access to items for adminab... I mean, events purposes
	var/use_snowflake_points = FALSE

	var/available_points_to_display = 0
	var/show_points = TRUE

	//squad-specific gear
	var/gloves_type = /obj/item/clothing/gloves/marine
	var/headset_type = /obj/item/device/radio/headset/almayer/marine

	var/vend_delay = 0		//delaying vending of an item (for drinks machines animation, for example). Make sure to synchronize this with animation duration
	var/vend_sound			//use with caution. Potential spam

	var/vend_x_offset = 0
	var/vend_y_offset = 0

	var/list/listed_products = list()
	var/list/initial_product_count = list()

/*
Explanation on stat flags:
BROKEN						vendor is not operational and it's not a power issue
NOPOWER						vendor has no power
MAINT						we have to actually do a maintenance on vendor with tools to fix it
IN_REPAIR(REPAIR_STEPS)		for maintenance repair steps
TIPPED_OVER					for flipped sprite
IN_USE						used for vending/denying
*/

//------------GENERAL PROCS---------------

/obj/structure/machinery/power_change(var/area/master_area = null)
	..()
	update_icon()

/obj/structure/machinery/cm_vending/update_icon()

	//restoring sprite to initial
	overlays.Cut()
	//icon_state = initial(icon_state)	//shouldn't be needed but just in case
	var/matrix/A = matrix()
	apply_transform(A)

	if(stat & NOPOWER || stat & TIPPED_OVER)		//tipping off without breaking uses "_off" sprite
		overlays += image(icon, "[icon_state]_off")
	if(stat & MAINT)		//if we require maintenance, then it is completely "_broken"
		icon_state = "[initial(icon_state)]_broken"
		if(stat & IN_REPAIR)	//if someone started repairs, they unscrewed "_panel"
			overlays += image(icon, "[icon_state]_panel")

	if(stat & TIPPED_OVER)		//finally, if it is tipped over, flip the sprite
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

/obj/structure/machinery/cm_vending/proc/cm_build_inventory(var/list/items, var/name_index=1, var/type_index=3)
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
	if(vend_x_offset != 0 || vend_y_offset != 0)	//this check should be more less expensive than using locate to locate your own tile every vending.
		T = locate(x + vend_x_offset, y + vend_y_offset, z)
	return T

/obj/structure/machinery/cm_vending/get_examine_text(mob/living/carbon/human/user)
	. = ..()

	if(skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI) && hackable)
		. += SPAN_NOTICE("You believe you can hack this one to remove the access requirements.")

/obj/structure/machinery/cm_vending/proc/hack_access(var/mob/user)
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

//------------MAINTENANCE PROCS---------------

/obj/structure/machinery/cm_vending/proc/malfunction()	//proper malfunction, that requires MAINTenance
	if(stat & MAINT)
		return
	stat &= ~WORKING
	stat |= (BROKEN|MAINT)
	update_icon()

/obj/structure/machinery/cm_vending/proc/tip_over()		//tipping over, flipping back is enough, unless vendor was broken before being tipped over
	stat |= TIPPED_OVER
	density = FALSE
	if(!(stat & MAINT))
		stat |= BROKEN
		stat &= ~WORKING
	update_icon()

/obj/structure/machinery/cm_vending/proc/flip_back()
	density = TRUE
	stat &= ~TIPPED_OVER
	if(!(stat & MAINT))		//we fix vendor only if it was tipped over while working. No magic fixing of broken and then tipped over vendors.
		stat &= ~BROKEN
		stat |= WORKING
	update_icon()

/obj/structure/machinery/cm_vending/get_repair_move_text(var/include_name = TRUE)
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

/obj/structure/machinery/cm_vending/attack_alien(mob/living/carbon/Xenomorph/M)
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
	if(istype(M,/mob/living/carbon/Xenomorph/Crusher))
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
		ui_interact(user)
		return

	if(!ishuman(user))
		vend_fail()
		return

	var/has_access = can_access_to_vend(user)
	if (!has_access)
		return

	user.set_interaction(src)
	ui_interact(user)

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

/obj/structure/machinery/cm_vending/proc/get_listed_products(var/mob/user)
	return listed_products

/obj/structure/machinery/cm_vending/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	var/list/display_list = list()

	var/buy_flags = NO_FLAGS
	if(use_snowflake_points)
		available_points_to_display = H.marine_snowflake_points
	else if(use_points)
		available_points_to_display = H.marine_points

	buy_flags = H.marine_buy_flags

	var/list/ui_listed_products = get_listed_products(user)
	if(length(ui_listed_products))
		for(var/i in 1 to length(ui_listed_products))
			var/list/myprod = ui_listed_products[i]
			var/p_name = myprod[1]
			var/p_cost = myprod[2]
			if(p_cost > 0)
				p_name += " ([p_cost] points)"

			var/prod_available = FALSE
			var/avail_flag = myprod[4]
			if(available_points_to_display >= p_cost && (!avail_flag || buy_flags & avail_flag))
				prod_available = TRUE

			//place in main list, name, cost, available or not, color.
			display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_available" = prod_available, "prod_color" = myprod[5]))

	var/list/data = list(
		"vendor_name" = name,
		"show_points" = show_points,
		"current_m_points" = available_points_to_display,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "cm_vending.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)	//we don't really need autoupdate for gear/clothing vendors as they ghave infinite


/obj/structure/machinery/cm_vending/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(inoperable())
		return
	if(usr.is_mob_incapacitated())
		return

	if (in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if(href_list["vend"])
			return
		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window

/obj/structure/machinery/cm_vending/proc/handle_topic(mob/user, href, href_list)
	return

/obj/structure/machinery/cm_vending/proc/vend_succesfully()
	return

/obj/structure/machinery/cm_vending/proc/can_access_to_vend(mob/user, var/display=TRUE)
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
	var/list/data = list()
	data["vendor_name"] = name
	data["vendor_type"] = "base"
	data["theme"] = vendor_theme
	return data

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

/obj/structure/machinery/cm_vending/gear/Topic(href, href_list)
	. = ..()
	if(.)
		return TRUE

	handle_topic(usr, href, href_list)

/obj/structure/machinery/cm_vending/gear/handle_topic(mob/user, href, href_list)
	if(in_range(src, user) && isturf(loc) && ishuman(user))
		user.set_interaction(src)
		if(href_list["vend"])

			if(stat & IN_USE)
				return

			var/mob/living/carbon/human/H = user

			var/list/has_access = can_access_to_vend(user)
			if (!has_access)
				return

			var/idx=text2num(href_list["vend"])

			var/list/topic_listed_products = get_listed_products(user)
			var/list/L = topic_listed_products[idx]

			if((!H.assigned_squad && squad_tag) || (!H.assigned_squad?.omni_squad_vendor && (squad_tag && H.assigned_squad.name != squad_tag)))
				to_chat(H, SPAN_WARNING("This machine isn't for your squad."))
				vend_fail()
				return

			var/turf/T = get_appropriate_vend_turf()
			if(T.contents.len > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				vend_fail()
				return

			var/bitf = L[4]
			if(bitf)
				if(bitf == MARINE_CAN_BUY_ESSENTIALS && vendor_role.Find(JOB_SQUAD_SPECIALIST))
					if(H.job != JOB_SQUAD_SPECIALIST)
						to_chat(H, SPAN_WARNING("Only specialists can take specialist sets."))
						vend_fail()
						return
					else if(!H.skills || H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ALL)
						to_chat(H, SPAN_WARNING("You already have a specialization."))
						vend_fail()
						return
					var/p_name = L[1]
					if(!available_specialist_sets.Find(p_name))
						to_chat(H, SPAN_WARNING("That set is already taken."))
						vend_fail()
						return
					var/obj/item/card/id/ID = H.wear_id
					if(!istype(ID) || ID.registered_ref != WEAKREF(user))
						to_chat(user, SPAN_WARNING("You must be wearing your [SPAN_INFO("dog tags")] to select a specialization!"))
						return
					var/specialist_assignment
					switch(p_name)
						if("Scout Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SCOUT)
							specialist_assignment = "Scout"
						if("Sniper Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SNIPER)
							specialist_assignment = "Sniper"
						if("Demolitionist Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_ROCKET)
							specialist_assignment = "Demo"
						if("Heavy Grenadier Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)
							specialist_assignment = "Grenadier"
						if("Pyro Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_PYRO)
							specialist_assignment = "Pyro"
						else
							to_chat(H, SPAN_WARNING("<b>Something bad occured with [src], tell a Dev.</b>"))
							vend_fail()
							return
					ID.set_assignment((H.assigned_squad ? (H.assigned_squad.name + " ") : "") + JOB_SQUAD_SPECIALIST + " ([specialist_assignment])")
					GLOB.data_core.manifest_modify(H.real_name, WEAKREF(H), ID.assignment)
					available_specialist_sets -= p_name


			if(!handle_points(H, L))
				return

			vend_succesfully(L, H, T)

		add_fingerprint(user)
		ui_interact(user) //updates the nanoUI window

/obj/structure/machinery/cm_vending/gear/proc/handle_points(var/mob/living/carbon/human/H, var/list/L)
	. = TRUE
	var/cost = L[2]
	if(use_points)
		if(use_snowflake_points)
			if(H.marine_snowflake_points < cost)
				to_chat(H, SPAN_WARNING("Not enough points."))
				vend_fail()
				return FALSE
			else
				H.marine_snowflake_points -= cost
		else
			if(H.marine_points < cost)
				to_chat(H, SPAN_WARNING("Not enough points."))
				vend_fail()
				return FALSE
			else
				H.marine_points -= cost
	if(L[4])
		if(H.marine_buy_flags & L[4])
			H.marine_buy_flags &= ~L[4]
		else
			to_chat(H, SPAN_WARNING("You can't buy things from this category anymore."))
			vend_fail()
			return FALSE

/obj/structure/machinery/cm_vending/gear/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))	//making sure it's not empty
		if(vend_delay)
			overlays.Cut()
			icon_state = "[initial(icon_state)]_vend"
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2)	//heard only near vendor
			sleep(vend_delay)
		var/prod_type = L[3]
		var/obj/our_item = new prod_type(T)
		H.put_in_any_hand_if_possible(our_item, disable_warning = TRUE)
	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		sleep(15)

	stat &= ~IN_USE
	update_icon()
	return

//------------CLOTHING VENDORS---------------
//clothing vendors automatically put item on user. QoL at it's finest.

/obj/structure/machinery/cm_vending/clothing
	name = "ColMarTech Automated Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue uniform and armor."
	icon_state = "clothing"
	use_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	show_points = FALSE

/obj/structure/machinery/cm_vending/clothing/Initialize()
	. = ..()
	cm_build_inventory(get_listed_products(), 1, 3)

/obj/structure/machinery/cm_vending/clothing/proc/handle_vend(var/list/listed_products, var/mob/living/carbon/human/vending_human)
	if(!(vending_human.marine_buy_flags & listed_products[4]))
		return FALSE

	if(listed_products[4] == (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH))
		if(vending_human.marine_buy_flags & MARINE_CAN_BUY_R_POUCH)
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_R_POUCH
		else
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_L_POUCH
		return TRUE
	if(listed_products[4] == (MARINE_CAN_BUY_COMBAT_R_POUCH|MARINE_CAN_BUY_COMBAT_L_POUCH))
		if(vending_human.marine_buy_flags & MARINE_CAN_BUY_COMBAT_R_POUCH)
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_COMBAT_R_POUCH
		else
			vending_human.marine_buy_flags &= ~MARINE_CAN_BUY_COMBAT_L_POUCH
		return TRUE

	vending_human.marine_buy_flags &= ~listed_products[4]
	return TRUE

/obj/structure/machinery/cm_vending/clothing/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))
		if(vend_delay)
			overlays.Cut()
			icon_state = "[initial(icon_state)]_vend"
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2)	//heard only near vendor
			sleep(vend_delay)

		var/prod_type = L[3]
		if(prod_type == /obj/item/device/radio/headset/almayer/marine)
			prod_type = headset_type
		else if(prod_type == /obj/item/clothing/gloves/marine)
			prod_type = gloves_type

		var/obj/item/O = new prod_type(loc)

		var/bitf = L[4]
		if(bitf)
			if(bitf == MARINE_CAN_BUY_UNIFORM)
				var/obj/item/clothing/under/U = O
				//Gives ranks to the ranked
				if(H.wear_id && H.wear_id.paygrade)
					var/rankpath = get_rank_pins(H.wear_id.paygrade)
					if(rankpath)
						var/obj/item/clothing/accessory/ranks/R = new rankpath()
						U.attach_accessory(H, R)

		if(istype(O, /obj/item) && O.flags_equip_slot != NO_FLAGS)	//auto-equipping feature here
			if(O.flags_equip_slot == SLOT_ACCESSORY)
				if(H.w_uniform)
					var/obj/item/clothing/C = H.w_uniform
					if(C.can_attach_accessory(O))
						C.attach_accessory(H, O)
			else
				H.equip_to_appropriate_slot(O)

	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		sleep(15)
	stat &= ~IN_USE
	update_icon()
	return

/obj/structure/machinery/cm_vending/clothing/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/clothing/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!can_access_to_vend(user, FALSE))
		return UI_CLOSE

/obj/structure/machinery/cm_vending/clothing/ui_static_data(mob/user)
	var/list/data = ..(user)
	data["vendor_type"] = "clothing"
	// list format
	//	(
	// 		name: str
	//		cost
	//		item reference
	//		allowed to buy flag
	//		item priority (mandatory/recommended/regular)
	//	)
	var/list/ui_listed_products = get_listed_products(user)

	var/list/ui_categories = list()
	var/show_points = FALSE
	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i]	//we take one list from listed_products

		var/p_name = myprod[1]					//taking it's name
		var/p_cost = myprod[2]
		var/item_ref = myprod[3]
		var/priority = myprod[5]

		var/result = list()
		var/obj/item/I = item_ref

		var/is_category = item_ref == null

		var/imgid = replacetext(replacetext("[item_ref]", "/obj/item/", ""), "/", "-")
		//forming new list with index, name, amount, available or not, color and add it to display_list

		var/display_item = list(
			"prod_index" = i,
			"prod_name" = p_name,
			"prod_available" = TRUE,
			"prod_color" = priority,
			"prod_initial" = 0,
			"prod_icon" = result,
			"prod_desc" = initial(I.desc),
			"prod_cost" = p_cost,
			"image" = imgid
		)

		show_points = show_points ? show_points : p_cost > 0

		if (is_category == 1)
			ui_categories += list(list(
				"name" = p_name,
				"items" = list()
			))
			continue

		if (!LAZYLEN(ui_categories))
			ui_categories += list(list(
				"name" = "",
				"items" = list()
			))
		var/last_index = LAZYLEN(ui_categories)
		var/last_category = ui_categories[last_index]
		last_category["items"] += list(display_item)
	data["displayed_categories"] = ui_categories
	data["show_points"] = show_points
	return data

/obj/structure/machinery/cm_vending/clothing/ui_data(mob/user)
	var/list/data = list()

	var/list/ui_listed_products = get_listed_products(user)
	// list format
	//	(
	// 		name: str
	//		cost
	//		item reference
	//		allowed to buy flag
	//		item priority (mandatory/recommended/regular)
	//	)

	var/list/stock_values = list()

	var/mob/living/carbon/human/H = user
	var/buy_flags = NO_FLAGS
	if(use_snowflake_points)
		available_points_to_display = H.marine_snowflake_points
	else if(use_points)
		available_points_to_display = H.marine_points
	buy_flags = H.marine_buy_flags

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i]	//we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/avail_flag = myprod[4]
		if(available_points_to_display >= p_cost && (!avail_flag || buy_flags & avail_flag))
			prod_available = TRUE
		stock_values += list(prod_available)


	data["stock_listing"] = stock_values
	data["current_m_points"] = available_points_to_display
	return data

/obj/structure/machinery/cm_vending/clothing/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/H = usr
	switch (action)
		if ("vend")
			if(stat & IN_USE)
				return

			var/idx=params["prod_index"]

			var/list/topic_listed_products = get_listed_products(usr)
			var/list/L = topic_listed_products[idx]
			var/cost = L[2]

			if((!H.assigned_squad && squad_tag) || (!H.assigned_squad?.omni_squad_vendor && (squad_tag && H.assigned_squad.name != squad_tag)))
				to_chat(H, SPAN_WARNING("This machine isn't for your squad."))
				vend_fail()
				return
			var/turf/T = get_appropriate_vend_turf(H)
			if(T.contents.len > 25)
				to_chat(usr, SPAN_WARNING("The floor is too cluttered, make some space."))
				vend_fail()
				return TRUE
			var/bitf = L[4]
			if(bitf)
				if(bitf == MARINE_CAN_BUY_ESSENTIALS && vendor_role.Find(JOB_SYNTH))
					if(H.job != JOB_SYNTH)
						to_chat(H, SPAN_WARNING("Only USCM Synthetics may vend experimental tool tokens."))
						vend_fail()
						return

			if(use_points)
				if(use_snowflake_points)
					if(H.marine_snowflake_points < cost)
						to_chat(H, SPAN_WARNING("Not enough points."))
						vend_fail()
						return
					else
						H.marine_snowflake_points -= cost
				else
					if(H.marine_points < cost)
						to_chat(H, SPAN_WARNING("Not enough points."))
						vend_fail()
						return
					else
						H.marine_points -= cost

			if(L[4])
				if(!handle_vend(L, H))
					to_chat(H, SPAN_WARNING("You can't buy things from this category anymore."))
					vend_fail()
					return

			vend_succesfully(L, H, T)
		if("cancel")
			SStgui.close_uis(src)
			return TRUE

	add_fingerprint(usr)

/obj/structure/machinery/cm_vending/clothing/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "VendingSorted", name)
		ui.open()

/obj/structure/machinery/cm_vending/clothing/attack_hand(mob/user)
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

	tgui_interact(user)


//------------SORTED VENDORS---------------
//22.06.2019 Modified ex-"marine_selector" system that doesn't use points by Jeser. In theory, should replace all vendors.
//Hacking can be added if we need it. Do we need it, tho?

/obj/structure/machinery/cm_vending/sorted
	name = "\improper ColMarTech generic sorted rack/vendor"
	desc = "This is pure vendor without points system."
	icon_state = "guns_rack"
	vendor_theme = VENDOR_THEME_USCM

	//this here is made to provide ability to restock vendors with different subtypes of same object, like handmade and manually filled ammo boxes.
	var/list/corresponding_types_list = list(
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

	)

/obj/structure/machinery/cm_vending/sorted/Initialize()
	. = ..()
	populate_product_list(1.2)
	cm_build_inventory(get_listed_products())

//this proc, well, populates product list based on roundstart amount of players
/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(inoperable())
		return UI_CLOSE
	if(!can_access_to_vend(user, FALSE))
		return UI_CLOSE

/obj/structure/machinery/cm_vending/sorted/attack_hand(mob/user)
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

	var/list/has_access = can_access_to_vend(user)
	if (!has_access)
		return
	tgui_interact(user)

/obj/structure/machinery/cm_vending/sorted/ui_static_data(mob/user)
	var/list/data = ..(user)
	data["vendor_type"] = "sorted"

	var/list/ui_listed_products = get_listed_products(user)

	var/list/ui_categories = list()
	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i]	//we take one list from listed_products

		var/p_name = myprod[1]					//taking it's name
		var/p_amount = myprod[2]				//amount left
		var/item_ref = myprod[3]
		var/prod_available = p_amount > 0		//checking if it's available
		var/list/initial_vals = initial_product_count

		var/result = list()

		var/initial_amount = initial_vals[p_name]
		var/is_category = p_amount < 0

		var/imgid = replacetext(replacetext("[item_ref]", "/obj/item/", ""), "/", "-")


		//forming new list with index, name, amount, available or not, color and add it to display_list
		var/obj/item/I = item_ref
		var/display_item = list(
			"prod_index" = i,
			"prod_name" = p_name,
			"prod_available" = prod_available,
			"prod_color" = myprod[4],
			"prod_initial" = initial_amount,
			"prod_icon" = result,
			"prod_desc" = initial(I.desc),
			"prod_cost" = 0,
			"image" = imgid
		)

		if (is_category == 1)
			ui_categories += list(list(
				"name" = p_name,
				"items" = list()
			))
			continue

		if (!LAZYLEN(ui_categories))
			ui_categories += list(list(
				"name" = "",
				"items" = list()
			))
		var/last_index = LAZYLEN(ui_categories)
		var/last_category = ui_categories[last_index]
		last_category["items"] += list(display_item)
	data["displayed_categories"] = ui_categories
	return data

/obj/structure/machinery/cm_vending/sorted/ui_data(mob/user)
	var/list/data = list()

	var/list/ui_listed_products = get_listed_products(user)

	var/list/ui_categories = list()

	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i]	//we take one list from listed_products
		var/p_amount = myprod[2]				//amount left
		ui_categories += list(p_amount)
	data["stock_listing"] = ui_categories
	return data

/obj/structure/machinery/cm_vending/sorted/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "VendingSorted", name)
		ui.open()

/obj/structure/machinery/cm_vending/sorted/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/H = usr
	switch (action)
		if ("vend")
			if(stat & IN_USE)
				return
			var/has_access = can_access_to_vend(usr)
			if (!has_access)
				return TRUE

			var/idx=params["prod_index"]
			var/list/topic_listed_products = get_listed_products(usr)
			var/list/L = topic_listed_products[idx]

			var/turf/T = get_appropriate_vend_turf(H)
			if(T.contents.len > 25)
				to_chat(usr, SPAN_WARNING("The floor is too cluttered, make some space."))
				vend_fail()
				return TRUE

			if(L[2] <= 0)	//to avoid dropping more than one product when there's
				to_chat(usr, SPAN_WARNING("[L[1]] is out of stock."))
				vend_fail()
				return TRUE		// one left and the player spam click during a lagspike.

			vend_succesfully(L, H, T)
		if ("cancel")
			SStgui.close_uis(src)
			return TRUE

	add_fingerprint(usr)
	return TRUE

/obj/structure/machinery/cm_vending/sorted/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))
		if(vend_delay)
			overlays.Cut()
			icon_state = "[initial(icon_state)]_vend"
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2)	//heard only near vendor
			sleep(vend_delay)
		var/prod_path = L[3]
		if(ispath(prod_path, /obj/item/weapon/gun))
			new prod_path(T, TRUE)
		else
			new prod_path(T)
		L[2]--		//taking 1 from amount of products in vendor

	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		sleep(15)
	stat &= ~IN_USE
	update_icon()
	return

/obj/structure/machinery/cm_vending/sorted/MouseDrop_T(var/atom/movable/A, mob/user)

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
			updateUsrDialog()
			return //We found our item, no reason to go on.

//sending an /empty ammo box type path here will return corresponding regular (full) type of this box
//if there is one set in corresponding_box_types or will return FALSE otherwise
/obj/structure/machinery/cm_vending/sorted/proc/return_corresponding_type(var/unusual_path)
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
	use_points = FALSE
	use_snowflake_points = FALSE

	var/available_points = MARINE_TOTAL_BUY_POINTS
	available_points_to_display = MARINE_TOTAL_BUY_POINTS

/obj/structure/machinery/cm_vending/own_points/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.is_mob_incapacitated())
		return

	if(in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if(href_list["vend"])
			if(stat & IN_USE)
				return

			var/list/has_access = can_access_to_vend(usr)
			if (!has_access)
				return

			var/idx=text2num(href_list["vend"])
			var/list/topic_listed_products = get_listed_products(usr)
			var/list/L = topic_listed_products[idx]
			var/cost = L[2]

			var/mob/living/carbon/human/H = usr

			if((!H.assigned_squad && squad_tag) || (!H.assigned_squad?.omni_squad_vendor && (squad_tag && H.assigned_squad.name != squad_tag)))
				to_chat(H, SPAN_WARNING("This machine isn't for your squad."))
				vend_fail()
				return

			var/turf/T = get_appropriate_vend_turf()
			if(T.contents.len > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				vend_fail()
				return

			if(available_points < cost)
				to_chat(H, SPAN_WARNING("Not enough points."))
				vend_fail()
				return
			else
				available_points -= cost
				available_points_to_display = available_points

			vend_succesfully(L, H, T)

		add_fingerprint(usr)
		ui_interact(usr)

/obj/structure/machinery/cm_vending/own_points/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))	//making sure it's not empty
		if(vend_delay)
			overlays.Cut()
			icon_state = "[initial(icon_state)]_vend"
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2)	//heard only near vendor
			sleep(vend_delay)
		var/prod_type = L[3]
		new prod_type(T)
	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		sleep(15)

	stat &= ~IN_USE
	update_icon()
	return

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

//------------HACKING---------------

//Hacking code from old vendors, in case someone will actually would like to add complex hacking in future. For now, simple access hacking I believe sufficient.
/*
/obj/structure/machinery/vending/proc/get_wire_descriptions()
	return list(
		VENDING_WIRE_EXTEND    = "Inventory control computer",
		VENDING_WIRE_IDSCAN    = "ID scanner",
		VENDING_WIRE_SHOCK     = "Ground safety",
		VENDING_WIRE_SHOOT_INV = "Dispenser motor control"
	)

/obj/structure/machinery/vending/proc/isWireCut(var/wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/vending/proc/cut(var/wire)
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

/obj/structure/machinery/vending/proc/mend(var/wire)
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

/obj/structure/machinery/vending/proc/pulse(var/wire)
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
