/obj/item/clothing/gloves/synth
	name = "\improper PK-130 SIMI wrist-mounted computer"
	desc = "Developed by a joint effort between Weyland-Yutani CIART and the USCM R&D Division, the SIMI portable computer is the ultimate solution for situational awareness, personnel monitoring and communication."

	icon = 'icons/obj/items/synth/bracer.dmi'
	icon_state = "bracer"
	item_icons = list(
		WEAR_HANDS = 'icons/mob/humans/onmob/synth/bracer.dmi'
	)

	var/base_item_slot_state = "bracer"
	item_state_slots = list(
		WEAR_HANDS = "bracer"
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

	var/list/actions_list_inherent = list(
		/datum/action/human_action/synth_bracer/repair_form,
		/datum/action/human_action/synth_bracer/protective_form,
		/datum/action/human_action/synth_bracer/crew_monitor,
		/datum/action/human_action/synth_bracer/deploy_binoculars,
		/datum/action/human_action/synth_bracer/tactical_map,
		//datum/action/human_action/activable/synth_bracer/rescue_hook,
		//datum/action/human_action/synth_bracer/reflex_overclock,
	)
	var/list/actions_list_added = list()

	var/list/actions_list_actions = list()
	var/active_ability = SIMI_ACTIVE_NONE
	var/active_utility = SIMI_ACTIVE_NONE

	/// Faction used by Internal Phone & Crew Monitor
	var/faction = FACTION_MARINE

	/// Internal Phone
	var/obj/structure/transmitter/internal/internal_transmitter

	/// Pair of gloves worn underneath the computer.
	var/obj/item/clothing/gloves/underglove

	// Capability states used in FORITIFY mode.
	var/saved_melee_allowed
	var/saved_throw_allowed
	var/saved_gun_allowed

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
	RegisterSignal(internal_transmitter, COMSIG_TRANSMITTER_UPDATE_ICON, .proc/check_for_ringing)

/obj/item/clothing/gloves/synth/Destroy()
	. = ..()
	QDEL_NULL_LIST(actions_list_actions)
	QDEL_NULL(internal_transmitter)
	QDEL_NULL(underglove)

/obj/item/clothing/gloves/synth/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("The current charge reads <b>[battery_charge]/[initial(battery_charge)]</b>."))
	if(underglove)
		to_chat(user, SPAN_INFO("The wrist-strap is attached to [underglove]."))
	else
		to_chat(user, SPAN_NOTICE("You see a way to attach a pair of gloves to the wrist-strap."))

/obj/item/clothing/gloves/synth/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		update_actions(SIMI_ACTIONS_ADD, user)
		flick("bracer_startup", src)

		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			if(human_user.comm_title)
				internal_transmitter.phone_id = "[human_user.comm_title] [human_user]"
			else if(human_user.job)
				internal_transmitter.phone_id = "[human_user.job] [human_user]"
			else
				internal_transmitter.phone_id = "[human_user]"
			if(human_user.assigned_squad)
				internal_transmitter.phone_id += " ([human_user.assigned_squad.name])"
		else
			internal_transmitter.phone_id = "[user]"
		internal_transmitter.enabled = TRUE

	update_icon()

/obj/item/clothing/gloves/synth/dropped(mob/user)
	update_actions(SIMI_ACTIONS_REMOVE, user)
	update_icon()

	if(internal_transmitter)
		internal_transmitter.phone_id = "[src]"
		internal_transmitter.enabled = FALSE

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

/obj/item/clothing/gloves/synth/attackby(obj/item/attacker, mob/user)
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
//#############################
//###### ICON HANDLING ########
//#############################
/obj/item/clothing/gloves/synth/update_icon()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer) || wearer.gloves != src)
		icon_state = "bracer"
		return

	if(battery_charge <= 0)
		icon_state = "bracer_off"
		return
	if(battery_charge <= initial(battery_charge) * 0.1)
		icon_state = "bracer_nobattery"
		return

	if(!issynth(wearer))
		icon_state = "bracer_unauthorized"

	else
		icon_state = "bracer_idle"
	update_overlays()

/obj/item/clothing/gloves/synth/proc/update_overlays()
	overlays.Cut()

	var/phone_status
	if(internal_transmitter && internal_transmitter.attached_to)
		if(internal_transmitter.do_not_disturb >= PHONE_DND_ON)
			phone_status = "phone_dnd"
		else if(internal_transmitter.attached_to.loc != internal_transmitter)
			phone_status = "phone_ear"
		else if(internal_transmitter.caller)
			phone_status = "phone_ringing"

	var/image/phone_image = image(icon, src, phone_status)
	phone_image.appearance_flags = RESET_COLOR|KEEP_APART

	var/image/ability_image = image(icon, src, "ability_[active_ability]")
	ability_image.appearance_flags = RESET_COLOR|KEEP_APART

	overlays += phone_image
	overlays += ability_image

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

	if(base_item_slot_state == "bracer")
		base_item_slot_state = "bracer_r"
	else
		base_item_slot_state = "bracer"
	item_state_slots[WEAR_HANDS] = base_item_slot_state

	to_chat(usr, SPAN_NOTICE("You shift \the [src] over to your [base_item_slot_state == "bracer" ? "right arm" : "left arm"]."))
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

	INVOKE_ASYNC(src, .proc/complete_apc_charge, user, apc)

/obj/item/clothing/gloves/synth/proc/complete_apc_charge(mob/living/carbon/human/user, obj/structure/machinery/power/apc/apc)
	start_charging(user)

	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
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
		if(battery_charge < initial(battery_charge))
			var/charge_to_use = min(apc.cell.charge, initial(battery_charge) - battery_charge)
			if(!(apc.cell.use(charge_to_use)))
				stop_charging(user)
				return
			battery_charge += charge_to_use
			to_chat(user, SPAN_NOTICE("You slot your fingers into the APC interface and siphon off some of the stored charge. \The [src] now has <b>[battery_charge]/[initial(battery_charge)]</b>."))
			apc.charging = 1
		else
			to_chat(user, SPAN_WARNING("\The [src] is already fully charged."))
	else
		to_chat(user, SPAN_WARNING("There is no charge to draw from that APC."))
	stop_charging(user)

/obj/item/clothing/gloves/synth/proc/start_charging(mob/user)
	item_state_slots[WEAR_HANDS] += "_charging"
	icon_state = "bracer_charging"
	user.update_inv_gloves()

/obj/item/clothing/gloves/synth/proc/stop_charging(mob/user)
	item_state_slots[WEAR_HANDS] = base_item_slot_state
	update_icon()
	user.update_inv_gloves()

/obj/item/clothing/gloves/synth/proc/drain_charge(mob/user, cost)
	battery_charge -= cost
	to_chat(user, SPAN_WARNING("\The [src]'s charge now reads: <b>[battery_charge]/[initial(battery_charge)]</b>."))
	update_icon()

//########
/obj/item/clothing/gloves/synth/proc/update_actions(mode = SIMI_ACTIONS_LOAD, mob/user)
	if((!user) && (mode != SIMI_ACTIONS_LOAD))
		return FALSE

	switch(mode)
		if(SIMI_ACTIONS_LOAD)
			for(var/action_type in actions_list_inherent)
				actions_list_actions += new action_type
			for(var/action_type in actions_list_added)
				actions_list_actions += new action_type

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


