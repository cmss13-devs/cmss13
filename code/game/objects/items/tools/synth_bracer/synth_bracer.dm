/obj/item/clothing/gloves/synth
	name = "PK-130 SIMI wrist-mounted computer"
	desc = "Developed by a joint effort between Weyland-Yutani CIART and the USCM R&D Division, the SIMI portable computer is the ultimate solution for situational awareness, personnel monitoring and communication."

	icon = 'icons/obj/items/synth/bracer.dmi'
	icon_state = "bracer_default"
	item_icons = list(
		WEAR_HANDS = 'icons/mob/humans/onmob/synth/bracer.dmi'
	)

	var/base_item_slot_state = "bracer_default"
	item_state_slots = list(
		WEAR_HANDS = "bracer_default"
	)

	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	flags_armor_protection = BODY_FLAG_HANDS
	flags_inventory = CANTSTRIP
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	var/battery_charge = SMARTPACK_MAX_POWER_STORED
	var/battery_charge_max = SMARTPACK_MAX_POWER_STORED
	var/bracer_charging = FALSE

	var/list/ability_chips = list()
	var/ability_chips_max = 2

	var/list/actions_list_inherent = list(
		/datum/action/human_action/synth_bracer/crew_monitor,
		/datum/action/human_action/synth_bracer/deploy_binoculars,
		/datum/action/human_action/synth_bracer/tactical_map,
	)
	var/list/actions_list_added = list()

	var/list/datum/action/human_action/synth_bracer/actions_list_actions = list()
	var/active_ability = SIMI_ACTIVE_NONE
	var/active_utility = SIMI_ACTIVE_NONE

	/// Faction used by Internal Phone & Crew Monitor
	var/faction = FACTION_MARINE

	/// If the bracer is adapted for human use. (No using repair mode etc.)
	var/human_adapted = FALSE

	/// Internal Phone
	var/obj/structure/transmitter/internal/internal_transmitter

	/// Pair of gloves worn underneath the computer.
	var/obj/item/clothing/gloves/underglove
	/// Base color of the bracer. (DEFAULT OR WHITE)
	var/bracer_color = SIMI_COLOR_DEFAULT

	// Capability states used in FORITIFY mode.
	var/saved_melee_allowed
	var/saved_throw_allowed
	var/saved_gun_allowed

	var/mob/living/carbon/human/wearer

	/// Cooldown on abilities that play sounds (and don't internally handle it)
	COOLDOWN_DECLARE(sound_cooldown)

/obj/item/clothing/gloves/synth/Initialize(mapload, ...)
	. = ..()
	update_actions()

	internal_transmitter = new(src)
	internal_transmitter.relay_obj = src
	internal_transmitter.phone_category = "Synth"
	internal_transmitter.enabled = FALSE
	internal_transmitter.range = 2
	internal_transmitter.networks_receive = list(faction)
	internal_transmitter.networks_transmit = list(faction)
	RegisterSignal(internal_transmitter, COMSIG_TRANSMITTER_UPDATE_ICON, PROC_REF(check_for_ringing))

/obj/item/clothing/gloves/synth/Destroy()
	. = ..()
	QDEL_NULL_LIST(actions_list_actions)
	QDEL_NULL(internal_transmitter)
	QDEL_NULL(underglove)

/obj/item/clothing/gloves/synth/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("The current charge reads <b>[battery_charge]/[battery_charge_max]</b>."))
	if(underglove)
		to_chat(user, SPAN_INFO("The wrist-strap is attached to [underglove]."))
	else
		to_chat(user, SPAN_NOTICE("You see a way to attach a pair of gloves to the wrist-strap."))

/obj/item/clothing/gloves/synth/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		update_actions(SIMI_ACTIONS_ADD, user)
		flick("bracer_[bracer_color]_startup", src)

		if(ishuman(user))
			wearer = user
			if(wearer.comm_title)
				internal_transmitter.phone_id = "[wearer.comm_title] [wearer]"
			else if(wearer.job)
				internal_transmitter.phone_id = "[wearer.job] [wearer]"
			else
				internal_transmitter.phone_id = "[wearer]"
			if(wearer.assigned_squad)
				internal_transmitter.phone_id += " ([wearer.assigned_squad.name])"
		else
			internal_transmitter.phone_id = "[user]"
		internal_transmitter.enabled = TRUE

	update_icon()

/obj/item/clothing/gloves/synth/dropped(mob/user)
	disable_anchor()
	disable_shield()

	update_actions(SIMI_ACTIONS_REMOVE, user)

	if(bracer_charging)
		stop_charging(user)
	update_icon()

	if(internal_transmitter)
		internal_transmitter.phone_id = "[src]"
		internal_transmitter.enabled = FALSE

	wearer = null
	return ..()

/obj/item/clothing/gloves/synth/MouseDrop(obj/over_object as obj)
	if(CAN_PICKUP(usr, src))
		if(!istype(over_object, /atom/movable/screen))
			return ..()

		if(!usr.is_mob_restrained() && !usr.stat)
			switch(over_object.name)
				if("r_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_r_hand(src)
				if("l_hand")
					if(usr.drop_inv_item_on_ground(src))
						usr.put_in_l_hand(src)
			add_fingerprint(usr)

/obj/item/clothing/gloves/synth/attackby(obj/item/attacker, mob/living/carbon/human/user)
	if((istype(attacker, /obj/item/clothing/gloves)) && !(attacker.flags_item & ITEM_PREDATOR))
		if(underglove)
			to_chat(user, SPAN_WARNING("[src] is already attached to [underglove], remove them first."))
			return
		underglove = attacker
		user.drop_inv_item_to_loc(attacker, src)
		to_chat(user, SPAN_NOTICE("You attach the [attacker] to the bracer's wrist-strap."))
		user.update_inv_gloves()
	if(internal_transmitter.attached_to == attacker)
		internal_transmitter.attackby(attacker, user)
		return

	if(istype(attacker, /obj/item/device/simi_chip))
		var/obj/item/device/simi_chip/new_chip = attacker
		var/chips_num = 0
		for(var/obj/item/device/simi_chip/chip in ability_chips)
			if(chip.chip_action == new_chip.chip_action)
				to_chat(user, SPAN_WARNING("[src] already has this circuit chip!"))
				return
			if(!chip.secret)
				chips_num++
		if(chips_num >= ability_chips_max)
			to_chat(user, SPAN_WARNING("[src] can't hold another circuit chip!"))
			return
		if(user.drop_held_item())
			new_chip.forceMove(src)
			ability_chips += new_chip
			to_chat(user, SPAN_NOTICE("You slot [new_chip] into [src]!"))
			playsound(src, 'sound/machines/terminal_processing.ogg', 15, TRUE)
			if(user.gloves && (user.gloves == src))
				update_actions(SIMI_ACTIONS_RELOAD, user)
			else
				update_actions(SIMI_ACTIONS_RELOAD)
		return

	if(HAS_TRAIT(attacker, TRAIT_TOOL_SCREWDRIVER))
		//Remove ability chip - give option or remove all?
		var/turf/T = get_turf(user)
		if(!T)
			to_chat(user, "You cannot do that here.")
			return

		var/removed_chips = FALSE
		for (var/obj/item/device/simi_chip/chip in ability_chips)
			if(chip.secret)
				continue
			chip.forceMove(T)
			ability_chips -= chip
			removed_chips = TRUE
		if(removed_chips)
			if(user.gloves && (user.gloves == src))
				update_actions(SIMI_ACTIONS_RELOAD, user)
			else
				update_actions(SIMI_ACTIONS_RELOAD)
			to_chat(user, SPAN_NOTICE("You pop out the circuit chips from [src]!"))
		else
			to_chat(user, SPAN_NOTICE("There are no removable circuit chips in [src]!"))
		return
	return ..()

/obj/item/clothing/gloves/synth/attack_hand(mob/living/carbon/human/user)
	if(istype(user) && user.gloves == src)
		internal_transmitter.attack_hand(user)
		return
	return ..()

/obj/item/clothing/gloves/synth/forceMove(atom/dest)
	. = ..()
	if(isturf(dest))
		internal_transmitter.set_tether_holder(src)
	else
		internal_transmitter.set_tether_holder(loc)

/obj/item/clothing/gloves/synth/proc/set_active(category = SIMI_SECONDARY_ACTION, set_ability = SIMI_ACTIVE_NONE)
	switch(category)
		if(SIMI_PRIMARY_ACTION)
			active_ability = set_ability
		if(SIMI_SECONDARY_ACTION)
			active_utility = set_ability
	if((active_ability == SIMI_ACTIVE_NONE) && (active_utility == SIMI_ACTIVE_NONE))
		flags_item &= ~NODROP
	else
		flags_item |= NODROP
	update_icon()

/obj/item/clothing/gloves/synth/proc/set_inactive(category = SIMI_SECONDARY_ACTION)
	set_active(category, SIMI_ACTIVE_NONE)

//#############################
//###### ICON HANDLING ########
//#############################
/obj/item/clothing/gloves/synth/update_icon()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer) || wearer.gloves != src)
		overlays.Cut()
		icon_state = "bracer_[bracer_color]"
		return

	icon_state = "bracer_[bracer_color]_blank"

	update_overlays()

/obj/item/clothing/gloves/synth/proc/get_bracer_status()
	if(battery_charge <= 0)
		internal_transmitter.enabled = FALSE
		return SIMI_STATUS_NOPOWER
	if(battery_charge <= battery_charge_max * 0.1)
		return SIMI_STATUS_LOWPOWER
	var/mob/living/carbon/human/wearer = loc
	if(!issynth(wearer) && !human_adapted)
		internal_transmitter.enabled = FALSE
		return SIMI_STATUS_NOACCESS
	internal_transmitter.enabled = TRUE
	return SIMI_STATUS_IDLE

/obj/item/clothing/gloves/synth/proc/update_overlays()
	overlays.Cut()

	var/image/idle_image = image(icon, src, SIMI_STATUS_IDLE)
	idle_image.appearance_flags = RESET_COLOR|KEEP_APART
	var/current_status = get_bracer_status()
	var/image/status_image
	if(current_status != SIMI_STATUS_IDLE)
		status_image = image(icon, src, current_status)
		status_image.appearance_flags = RESET_COLOR|KEEP_APART

	var/phone_status
	if(internal_transmitter && internal_transmitter.attached_to)
		if(internal_transmitter.do_not_disturb >= PHONE_DND_ON)
			phone_status = "dnd"
		else if(internal_transmitter.attached_to.loc != internal_transmitter)
			phone_status = "listening"
		else if(internal_transmitter.caller)
			phone_status = "ringing"

	var/image/phone_image = image(icon, src, "phone_[phone_status]")
	phone_image.appearance_flags = RESET_COLOR|KEEP_APART

	var/image/secondary_image = image(icon, src, "secondary_[active_utility]")
	secondary_image.appearance_flags = RESET_COLOR|KEEP_APART

	var/image/primary_image = image(icon, src, "primary_[active_ability]")
	primary_image.appearance_flags = RESET_COLOR|KEEP_APART

	if(motion_detector_active)
		var/image/motion_image = image(icon, src, "motion_active")
		motion_image.appearance_flags = RESET_COLOR|KEEP_APART
		overlays += motion_image

	overlays += idle_image
	overlays += phone_image
	overlays += secondary_image
	overlays += primary_image
	overlays += status_image


/obj/item/clothing/gloves/synth/proc/check_for_ringing()
	SIGNAL_HANDLER
	update_overlays()

/obj/item/clothing/gloves/synth/get_mob_overlay(mob/user_mob, slot)
	var/image/overlay = ..()

	if((slot != WEAR_HANDS) || !underglove)
		return overlay

	overlay = underglove.get_mob_overlay(user_mob, slot)

	var/image/bracer_img = overlay_image('icons/mob/humans/onmob/synth/bracer.dmi', get_icon_state(user_mob, slot), null, RESET_COLOR|NO_CLIENT_COLOR)
	overlay.overlays += bracer_img

	return overlay

/obj/item/clothing/gloves/synth/verb/swap_hands()
	set name = "Swap Hands"
	set src in usr

	if(base_item_slot_state == "bracer_[bracer_color]")
		base_item_slot_state = "bracer_[bracer_color]_r"
	else
		base_item_slot_state = "bracer_[bracer_color]"
	item_state_slots[WEAR_HANDS] = base_item_slot_state

	to_chat(usr, SPAN_NOTICE("You shift \the [src] over to your [base_item_slot_state == "bracer_[bracer_color]" ? "left arm" : "right arm"]."))
	usr.update_inv_gloves()

/obj/item/clothing/gloves/synth/verb/remove_gloves()
	set name = "Remove Gloves"
	set src in usr

	if(!underglove)
		return FALSE

	to_chat(usr, SPAN_NOTICE("You remove [underglove] from the wrist-strap."))
	underglove.forceMove(get_turf(usr))
	underglove = null

	usr.update_inv_gloves()

//#############################
//######## CHARGING ###########
//#############################
/obj/item/clothing/gloves/synth/proc/handle_apc_charge(mob/living/carbon/human/user, obj/structure/machinery/power/apc/apc)
	if(!istype(user))
		return FALSE

	if(!(user.species.flags & IS_SYNTHETIC) || user.a_intent != INTENT_GRAB)
		return FALSE

	if(user.action_busy)
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(complete_apc_charge), user, apc)

/obj/item/clothing/gloves/synth/proc/complete_apc_charge(mob/living/carbon/human/user, obj/structure/machinery/power/apc/apc)
	start_charging(user)

	if(!do_after(user, 6 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		stop_charging(user)
		return
	if(!user.Adjacent(apc) || (user.gloves != src))
		stop_charging(user)
		return

	playsound(apc.loc, 'sound/effects/sparks2.ogg', 25, 1)

	if(apc.stat & BROKEN)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, apc)
		s.start()
		to_chat(user, SPAN_DANGER("The APC's power currents surge eratically, damaging your chassis!"))
		user.apply_damage(10, 0, BURN)
	else if(apc.cell?.charge > 0)
		if(battery_charge < battery_charge_max)
			var/charge_to_use = min(apc.cell.charge, battery_charge_max - battery_charge)
			if(!(apc.cell.use(charge_to_use)))
				stop_charging(user)
				return
			battery_charge += charge_to_use
			to_chat(user, SPAN_NOTICE("You slot your fingers into the APC interface and siphon off some of the stored charge. \The [src] now has <b>[battery_charge]/[battery_charge_max]</b>."))
			apc.charging = 1 //APC_CHARGING
		else
			to_chat(user, SPAN_WARNING("\The [src] is already fully charged."))
	else
		to_chat(user, SPAN_WARNING("There is no charge to draw from that APC."))
	stop_charging(user)

/obj/item/clothing/gloves/synth/proc/start_charging(mob/user)
	bracer_charging = TRUE
	item_state_slots[WEAR_HANDS] += "_charging"

	var/image/charge_image = image(icon, src, SIMI_STATUS_CHARGING)
	charge_image.appearance_flags = RESET_COLOR|KEEP_APART
	overlays += charge_image

	user.update_inv_gloves()

/obj/item/clothing/gloves/synth/proc/stop_charging(mob/user)
	bracer_charging = FALSE
	item_state_slots[WEAR_HANDS] = base_item_slot_state
	update_icon()
	user.update_inv_gloves()

/obj/item/clothing/gloves/synth/proc/drain_charge(mob/user, cost, report_charge = TRUE)
	battery_charge = max(0, battery_charge -= cost)
	if(report_charge)
		to_chat(user, SPAN_WARNING("\The [src]'s charge now reads: <b>[battery_charge]/[battery_charge_max]</b>."))
	update_icon()

//#############################
//##### ACTION HANDLING #######
//#############################
/obj/item/clothing/gloves/synth/proc/update_actions(mode = SIMI_ACTIONS_LOAD, mob/user)
	if((!user) && ((mode != SIMI_ACTIONS_LOAD) && (mode != SIMI_ACTIONS_RELOAD)))
		return FALSE

	switch(mode)
		if(SIMI_ACTIONS_LOAD)
			for(var/action_type in actions_list_inherent)
				actions_list_actions += new action_type
			for(var/action_type in actions_list_added)
				actions_list_actions += new action_type

		if(SIMI_ACTIONS_RELOAD)
			actions_list_added.Cut()
			for(var/obj/item/device/simi_chip/chip in ability_chips)
				actions_list_added += chip.chip_action
			if(user)
				for(var/datum/action/human_action/action as anything in actions_list_actions)
					action.remove_from(user)
			for(var/datum/action/human_action/action in actions_list_actions)
				actions_list_actions -= action
				qdel(action)
			update_actions(SIMI_ACTIONS_LOAD)
			if(user)
				for(var/datum/action/human_action/action as anything in actions_list_actions)
					action.give_to(user)

		if(SIMI_ACTIONS_ADD)
			for(var/datum/action/human_action/action as anything in actions_list_actions)
				action.remove_from(user)
			for(var/datum/action/human_action/action as anything in actions_list_actions)
				action.give_to(user)

		if(SIMI_ACTIONS_REMOVE)
			for(var/datum/action/human_action/action as anything in actions_list_actions)
				action.remove_from(user)
		else
			return FALSE
	return TRUE


