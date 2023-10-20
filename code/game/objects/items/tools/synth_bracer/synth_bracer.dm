/obj/item/clothing/gloves/synth
	name = "\improper PK-130 SIMI wrist-mounted computer"
	desc = "Developed by a joint effort between Weyland-Yutani and the USCM, the SIMI portable computer is the ultimate solution for situational awareness, personnel monitoring and communication."

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
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	var/battery_charge = SMARTPACK_MAX_POWER_STORED

	var/list/actions_list = list(
		/datum/action/human_action/activable/synth_bracer/rescue_hook,
		//datum/action/human_action/synth_bracer/reflex_overclock,
		/datum/action/human_action/synth_bracer/deploy_ocular_designator,
		/datum/action/human_action/synth_bracer/repair_form,
		/datum/action/human_action/synth_bracer/tactical_map
	)

	var/list/bracer_actions = list()

/obj/item/clothing/gloves/synth/Initialize(mapload, ...)
	. = ..()
	for(var/action_type in actions_list)
		bracer_actions += new action_type

/obj/item/clothing/gloves/synth/Destroy()
	. = ..()
	QDEL_NULL_LIST(bracer_actions)

/obj/item/clothing/gloves/synth/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("The current charge reads <b>[battery_charge]/[initial(battery_charge)]</b>."))

/obj/item/clothing/gloves/synth/update_icon()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer) || wearer.gloves != src)
		icon_state = "bracer"
		return
	if(!issynth(wearer))
		icon_state = "bracer_unauthorized"
	else if(battery_charge <= initial(battery_charge) * 0.1)
		icon_state = "bracer_nobattery"
	else
		icon_state = "bracer_idle"

/obj/item/clothing/gloves/synth/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		for(var/datum/action/human_action/action as anything in bracer_actions)
			action.give_to(user)
		flick("bracer_startup", src)
	update_icon()

/obj/item/clothing/gloves/synth/dropped(mob/user)
	for(var/datum/action/human_action/action as anything in bracer_actions)
		action.remove_from(user)
	update_icon()
	return ..()

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
	user.update_inv_gloves()

/obj/item/clothing/gloves/synth/proc/stop_charging(mob/user)
	item_state_slots[WEAR_HANDS] = base_item_slot_state
	user.update_inv_gloves()

/obj/item/clothing/gloves/synth/proc/drain_charge(mob/user, cost)
	battery_charge -= cost
	to_chat(user, SPAN_WARNING("\The [src]'s charge now reads: <b>[battery_charge]/[initial(battery_charge)]</b>."))
	update_icon()

/obj/item/clothing/gloves/synth/MouseDrop(obj/over_object as obj)
	if(CAN_PICKUP(usr, src))
		if(!istype(over_object, /obj/screen))
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
