#define BACKPACK_LIGHT_LEVEL 6
#define PROTECTIVE_COST 150
#define REPAIR_COST 100
#define IMMOBILE_COST 20

#define EXOSKELETON_ON_FILTER_SIZE 0.5
#define EXOSKELETON_OFF_FILTER_SIZE 1

#define PROTECTIVE_FORM_COLOR "#369E2B"
#define IMMOBILE_FORM_COLOR "#2B719E"

/obj/item/storage/backpack/marine/smartpack
	name = "\improper S-V42 prototype smartpack"
	desc = "A joint project between the USCM and Wey-Yu. It is said to be top-class engineering and state of the art technology. Given to USCM deployed synthetic units and the intended usage involve assisting in battlefield support. Can be recharged by grabbing onto an APC and completing the circuit with one's fingers (procedure not advised for non-synthetic personnel). WARNING - User is advised to take precautions."
	item_state = "smartpack"
	icon_state = "smartpack"
	has_gamemode_skin = FALSE
	max_storage_space = 14
	worn_accessible = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	xeno_types = null

	var/show_exoskeleton = TRUE

	var/battery_charge = SMARTPACK_MAX_POWER_STORED //How much power are we storing
	var/activated_form = FALSE
	var/immobile_form = FALSE
	var/repair_form = FALSE
	var/repairing = FALSE
	var/changed_icon = FALSE

	var/protective_form_cooldown = 120
	var/immobile_form_cooldown = 10
	var/repair_form_cooldown = 180

	var/saved_melee_allowed = TRUE
	var/saved_throw_allowed = TRUE
	var/saved_gun_allowed = TRUE

/obj/item/storage/backpack/marine/smartpack/verb/toggle_exoskeleton()
	set name = "Toggle Exoskeleton"
	set category = "Object"
	set src in usr

	if(!issynth(usr))
		to_chat(usr, SPAN_WARNING("You have no idea how to do that!"))
		return

	show_exoskeleton = !show_exoskeleton
	to_chat(usr, SPAN_NOTICE("\The [src] will [show_exoskeleton ? "now" : "no longer"] have an exoskeleton."))
	playsound(src, 'sound/machines/click.ogg', 15, TRUE)
	update_icon(usr)

/obj/item/storage/backpack/marine/smartpack/clicked(mob/user, list/mods)
	if(mods["ctrl"] && CAN_PICKUP(user, src))
		toggle_exoskeleton()
		return TRUE
	return ..()

/obj/item/storage/backpack/marine/smartpack/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/backpack/marine/smartpack/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]")

/obj/item/storage/backpack/marine/smartpack/update_icon(mob/user)
	overlays.Cut()

	if(show_exoskeleton)
		if(immobile_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_i")
		else if(activated_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_p")
		else if(repair_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_e")
		else
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state))
	else
		LAZYSET(item_state_slots, WEAR_BACK, initial(item_state))

	if(light_on)
		overlays += "+lamp_on"
	else
		overlays += "+lamp_off"

	if(user)
		user.update_inv_back()

	for(var/datum/action/A in actions)
		A.update_button_icon()

	if(issynth(user))
		var/mob/living/M = user
		for(var/datum/action/A in M.actions)
			A.update_button_icon()

	if(content_watchers) //If someone's looking inside it, don't close the flap.
		return

	var/sum_storage_cost = 0
	for(var/obj/item/I in contents)
		sum_storage_cost += I.get_storage_cost()
	if(!sum_storage_cost)
		return
	else if(sum_storage_cost <= max_storage_space * 0.5)
		overlays += "+[icon_state]_half"
	else
		overlays += "+[icon_state]_full"

/obj/item/storage/backpack/marine/smartpack/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()

	var/light = "+lamp_on"
	if(!light_on)
		light = "+lamp_off"

	var/image/lamp = overlay_image('icons/mob/humans/onmob/back.dmi', light, color, RESET_COLOR)
	ret.overlays += lamp

	return ret

/obj/item/storage/backpack/marine/smartpack/pickup(mob/living/M)
	if(issynth(M))
		for(var/action_type in subtypesof(/datum/action/human_action/smartpack))
			if(locate(action_type) in M.actions)
				continue

			give_action(M, action_type)
	else
		to_chat(M, SPAN_DANGER("[name] beeps, \"Unathorized user!\""))

	..()

/obj/item/storage/backpack/marine/smartpack/dropped(mob/living/M)
	for(var/datum/action/human_action/smartpack/S in M.actions)
		S.remove_from(M)

	if(light_on && loc != M)
		turn_light(M, toggle_on = FALSE)

	if(immobile_form)
		immobile_form = FALSE
		M.status_flags |= CANPUSH
		M.anchored = FALSE
		REMOVE_TRAIT(M, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
	..()

/obj/item/storage/backpack/marine/smartpack/attack_self(mob/user)
	..()

	if(!isturf(user.loc) || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.back != src)
		return

	turn_light(user, toggle_on = !light_on)
	return TRUE

/obj/item/storage/backpack/marine/smartpack/turn_light(mob/user, toggle_on, cooldown, sparks, forced, light_again)
	. = ..()
	if(. != CHECKS_PASSED)
		return

	if(toggle_on)
		set_light_range(BACKPACK_LIGHT_LEVEL)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)
		playsound(src, 'sound/handling/click_2.ogg', 50, TRUE)

	playsound(src, 'sound/handling/light_on_1.ogg', 50, TRUE)
	update_icon(user)

/obj/item/storage/backpack/marine/smartpack/proc/protective_form(mob/living/carbon/human/user)
	if(!istype(user) || activated_form || immobile_form)
		return

	if(battery_charge < PROTECTIVE_COST)
		to_chat(user, SPAN_DANGER("There is a lack of charge for that action. Charge: [battery_charge]/[PROTECTIVE_COST]"))
		return

	activated_form = TRUE
	flags_item |= NODROP
	flags_inventory |= CANTSTRIP
	LAZYSET(user.brute_mod_override, src, 0.2)
	LAZYSET(user.burn_mod_override, src, 0.2)
	saved_melee_allowed = user.melee_allowed
	saved_gun_allowed = user.allow_gun_usage
	saved_throw_allowed = user.throw_allowed
	user.melee_allowed = FALSE
	user.allow_gun_usage = FALSE
	user.throw_allowed = FALSE
	to_chat(user, SPAN_DANGER("[name] beeps, \"You are now protected, but unable to attack.\""))
	battery_charge -= PROTECTIVE_COST
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	to_chat(user, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	update_icon(user)

	var/filter_color = PROTECTIVE_FORM_COLOR
	var/filter_size = EXOSKELETON_OFF_FILTER_SIZE
	if(show_exoskeleton)
		filter_size = EXOSKELETON_ON_FILTER_SIZE
	user.add_filter("synth_protective_form", priority = 1, params = list("type" = "outline", "color" = filter_color, "size" = filter_size))

	addtimer(CALLBACK(src, PROC_REF(protective_form_cooldown), user), protective_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/protective_form_cooldown(mob/living/carbon/human/user)
	activated_form = FALSE
	flags_item &= ~NODROP
	flags_inventory &= ~CANTSTRIP
	user.melee_allowed = saved_melee_allowed
	user.throw_allowed = saved_throw_allowed
	user.allow_gun_usage = saved_gun_allowed
	LAZYREMOVE(user.brute_mod_override, src)
	LAZYREMOVE(user.burn_mod_override, src)
	to_chat(user, SPAN_DANGER("[name] beeps, \"The protection wears off.\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	update_icon(user)
	user.remove_filter("synth_protective_form")


/obj/item/storage/backpack/marine/smartpack/proc/immobile_form(mob/living/user)
	if(activated_form)
		return

	if(battery_charge < IMMOBILE_COST && !immobile_form)
		to_chat(user, SPAN_DANGER("There is a lack of charge for that action. Charge: [battery_charge]/[IMMOBILE_COST]"))
		return

	immobile_form = !immobile_form
	if(immobile_form)
		battery_charge -= IMMOBILE_COST
		user.status_flags &= ~CANPUSH
		user.anchored = TRUE
		ADD_TRAIT(user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
		to_chat(user, SPAN_DANGER("[name] beeps, \"You are anchored in place and cannot be moved.\""))
		to_chat(user, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))

		var/filter_color = IMMOBILE_FORM_COLOR
		var/filter_size = EXOSKELETON_OFF_FILTER_SIZE
		if(show_exoskeleton)
			filter_size = EXOSKELETON_ON_FILTER_SIZE
		user.add_filter("synth_immobile_form", priority = 1, params = list("type" = "outline", "color" = filter_color, "size" = filter_size))
	else
		user.status_flags |= CANPUSH
		user.anchored = FALSE
		REMOVE_TRAIT(user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
		to_chat(user, SPAN_DANGER("[name] beeps, \"You can now move again.\""))
		user.remove_filter("synth_immobile_form")

	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	update_icon(user)
	activated_form = TRUE

	addtimer(CALLBACK(src, PROC_REF(immobile_form_cooldown), user), immobile_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/immobile_form_cooldown(mob/user)
	activated_form = FALSE


/obj/item/storage/backpack/marine/smartpack/proc/repair_form(mob/user)
	if(!ishuman(user) || activated_form || repairing)
		return

	if(battery_charge < REPAIR_COST)
		to_chat(user, SPAN_DANGER("There is a lack of charge for that action. Charge: [battery_charge]/[REPAIR_COST]"))
		return

	var/mob/living/carbon/human/H = user

	if(H.getBruteLoss() <= 0 && H.getFireLoss() <= 0)
		to_chat(user, SPAN_DANGER("[name] beeps, \"No noticeable damage. Procedure cancelled.\""))
		return

	repair_form = TRUE
	repairing = TRUE
	update_icon(user)

	H.visible_message(SPAN_WARNING("[name] beeps, \"Engaging the repairing process.\""), \
		SPAN_WARNING("[name] beeps, \"Beginning to carefully examine your sustained damage.\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	if(!do_after(H, 100, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		repair_form = FALSE
		repairing = FALSE
		update_icon(user)
		to_chat(user, SPAN_DANGER("[name] beeps, \"Repair process was cancelled.\""))
		return

	playsound(loc, 'sound/items/Welder2.ogg', 25, TRUE)
	battery_charge -= REPAIR_COST
	H.heal_overall_damage(50, 50, TRUE)
	H.pain.recalculate_pain()
	repair_form = FALSE
	update_icon(user)
	to_chat(user, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	H.visible_message(SPAN_DANGER("[name] beeps, \"Completed the repairing process. Charge now reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED].\""))

	addtimer(CALLBACK(src, PROC_REF(repair_form_cooldown), user), repair_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/repair_form_cooldown(mob/user)
	repairing = FALSE
	update_icon(user)


/obj/item/storage/backpack/marine/smartpack/green
	item_state = "g_smartpack"
	icon_state = "g_smartpack"

/obj/item/storage/backpack/marine/smartpack/tan
	item_state = "t_smartpack"
	icon_state = "t_smartpack"

/obj/item/storage/backpack/marine/smartpack/black
	item_state = "b_smartpack"
	icon_state = "b_smartpack"

/obj/item/storage/backpack/marine/smartpack/white
	item_state = "w_smartpack"
	icon_state = "w_smartpack"


#undef BACKPACK_LIGHT_LEVEL
#undef PROTECTIVE_COST
#undef REPAIR_COST
#undef IMMOBILE_COST

#undef EXOSKELETON_ON_FILTER_SIZE
#undef EXOSKELETON_OFF_FILTER_SIZE

#undef PROTECTIVE_FORM_COLOR
#undef IMMOBILE_FORM_COLOR
