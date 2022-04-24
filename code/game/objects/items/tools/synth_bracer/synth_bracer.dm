/obj/item/clothing/gloves/synth
	name = "\improper PK-130 SIMI wrist-mounted computer"
	desc = "Developed by a joint effort between Weyland-Yutani and the USCM, the SIMI portable computer is the ultimate solution for situational awareness, personnel monitoring and communication."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "bracer"
	item_icons = list(
		WEAR_HANDS = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
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

	var/list/bracer_actions = list(
		/datum/action/human_action/activable/synth_bracer/rescue_hook,
		/datum/action/human_action/synth_bracer/reflex_overclock,
		/datum/action/human_action/synth_bracer/deploy_ocular_designator,
		/datum/action/human_action/synth_bracer/repair_form
	)

/obj/item/clothing/gloves/synth/examine(mob/user)
	..()
	to_chat(user, SPAN_INFO("The current charge reads <b>[battery_charge]/[initial(battery_charge)]</b>."))

/* -- HANDLING APC CHARGING -- */

/obj/item/clothing/gloves/synth/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		RegisterSignal(user, COMSIG_MOB_APC_ATTACK_HAND, .proc/handle_apc_charge)
		for(var/action in bracer_actions)
			give_action(user, action)

/obj/item/clothing/gloves/synth/dropped(mob/user)
	for(var/action in bracer_actions)
		remove_action(user, action)
	UnregisterSignal(user, COMSIG_MOB_APC_ATTACK_HAND)
	return ..()

/obj/item/clothing/gloves/synth/proc/handle_apc_charge(var/mob/living/carbon/human/user, var/obj/structure/machinery/power/apc/apc)
	SIGNAL_HANDLER

	if(!istype(user))
		return FALSE

	if(!(user.species.flags & IS_SYNTHETIC) || user.a_intent != INTENT_GRAB)
		return FALSE

	if(user.action_busy)
		return FALSE

	INVOKE_ASYNC(src, .proc/complete_apc_charge, user, apc)

	return COMPONENT_APC_HANDLED_HAND

/obj/item/clothing/gloves/synth/proc/complete_apc_charge(var/mob/living/carbon/human/user, var/obj/structure/machinery/power/apc/apc)
	if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
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
				return
			battery_charge += charge_to_use
			to_chat(user, SPAN_NOTICE("You slot your fingers into the APC interface and siphon off some of the stored charge. \The [src] now has <b>[battery_charge]/[initial(battery_charge)]</b>."))
			apc.charging = 1
		else
			to_chat(user, SPAN_WARNING("\The [src] is already fully charged."))
	else
		to_chat(user, SPAN_WARNING("There is no charge to draw from that APC."))

/* -- +++++ +++++ -- */

/obj/item/clothing/gloves/synth/proc/drain_charge(var/mob/user, var/cost)
	battery_charge -= cost
	to_chat(user, SPAN_WARNING("\The [src]'s charge now reads: <b>[battery_charge]/[initial(battery_charge)]</b>."))

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
