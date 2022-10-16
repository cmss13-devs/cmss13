#define BACKPACK_LIGHT_LEVEL	6
#define PROTECTIVE_COST			50
#define REPAIR_COST				100
#define IMMOBILE_COST			20

/obj/item/storage/backpack/marine/smartpack
	name = "\improper S-V42 prototype smartpack"
	desc = "A joint project between the USCM and Wey-Yu. It is said to be top-class engineering and state of the art technology. Given to USCM deployed Synthetic units and the intended usage involve assisting in battlefield support. Can be recharged by grabbing onto an APC and completing the circuit with one's fingers (procedure not advised for non-synthetic personnel). WARNING - User is advised to take precautions."
	item_state = "smartpack"
	icon_state = "smartpack"
	has_gamemode_skin = FALSE
	max_storage_space = 14
	worn_accessible = TRUE
	actions_types = list(/datum/action/item_action/toggle)

	var/show_exoskeleton = FALSE

	var/flashlight_cooldown = 0 			//Cooldown for toggling the light
	var/light_state = FALSE					//Is the light on or off

	var/battery_charge = SMARTPACK_MAX_POWER_STORED	//How much power are we storing
	var/activated_form = FALSE
	var/immobile_form = FALSE
	var/repairing = FALSE
	var/changed_icon = FALSE

	var/protective_form_cooldown = 120
	var/immobile_form_cooldown = 10
	var/repair_form_cooldown = 180

	var/saved_melee_allowed = TRUE
	var/saved_gun_allowed = TRUE

/obj/item/storage/backpack/marine/smartpack/verb/toggle_exoskeleton()
	set name = "Toggle Exoskeleton"
	set category = "Object"
	set src in usr

	if(!isSynth(usr))
		to_chat(usr, SPAN_WARNING("You have no idea how to do that!"))
		return

	show_exoskeleton = !show_exoskeleton
	to_chat(usr, SPAN_NOTICE("\The [src] will [show_exoskeleton ? "now" : "no longer"] have an exoskeleton."))
	update_icon(usr)


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
		else if(activated_form && !immobile_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_p")
		else if(!activated_form && !immobile_form)
			LAZYSET(item_state_slots, WEAR_BACK, initial(item_state) + "_e")
	else
		LAZYSET(item_state_slots, WEAR_BACK, initial(item_state))

	if(light_state)
		overlays += "+lamp_on"
	else
		overlays += "+lamp_off"

	if(user)
		user.update_inv_back()

	for(var/datum/action/A in actions)
		A.update_button_icon()

	if(isSynth(user))
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
	if(!light_state)
		light = "+lamp_off"

	var/image/lamp = overlay_image('icons/mob/humans/onmob/back.dmi', light, color, RESET_COLOR)
	ret.overlays += lamp

	return ret

/obj/item/storage/backpack/marine/smartpack/pickup(var/mob/living/M)
	if(isSynth(M))
		for(var/action_type in subtypesof(/datum/action/human_action/smartpack))
			if(locate(action_type) in M.actions)
				continue

			give_action(M, action_type)
	else
		to_chat(M, SPAN_DANGER("[name] beeps, \"Unathorized user!\""))

	if(light_state && loc != M)
		M.SetLuminosity(BACKPACK_LIGHT_LEVEL, FALSE, src)
		SetLuminosity(0)
	..()

/obj/item/storage/backpack/marine/smartpack/dropped(var/mob/living/M)
	for(var/datum/action/human_action/smartpack/S in M.actions)
		S.remove_from(M)

	if(light_state && loc != M)
		toggle_light(M)

	if(immobile_form)
		immobile_form = FALSE
		M.status_flags |= CANPUSH
		M.anchored = FALSE
		M.unfreeze()
	..()

/obj/item/storage/backpack/marine/smartpack/Destroy()
	if(ismob(loc))
		loc.SetLuminosity(0, FALSE, src)
	else
		SetLuminosity(0)
	. = ..()

/obj/item/storage/backpack/marine/smartpack/attack_self(mob/user)
	..()

	if(!isturf(user.loc) || flashlight_cooldown > world.time || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.back != src)
		return

	toggle_light(user)
	return TRUE

/obj/item/storage/backpack/marine/smartpack/proc/toggle_light(mob/user)
	flashlight_cooldown = world.time + 20 //2 seconds cooldown every time the light is toggled
	if(light_state) //Turn it off.
		if(user)
			user.SetLuminosity(0, FALSE, src)
		else
			SetLuminosity(0)
		playsound(src, 'sound/handling/click_2.ogg', 50, TRUE)
	else //Turn it on.
		if(user)
			user.SetLuminosity(BACKPACK_LIGHT_LEVEL, FALSE, src)
		else
			SetLuminosity(BACKPACK_LIGHT_LEVEL)

	light_state = !light_state

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
	user.melee_allowed = FALSE
	user.allow_gun_usage = FALSE
	to_chat(user, SPAN_DANGER("[name] beeps, \"You are now protected, but unable to attack.\""))
	battery_charge -= PROTECTIVE_COST
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	to_chat(user, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	update_icon(user)

	addtimer(CALLBACK(src, .proc/protective_form_cooldown, user), protective_form_cooldown)

/obj/item/storage/backpack/marine/smartpack/proc/protective_form_cooldown(var/mob/living/carbon/human/H)
	activated_form = FALSE
	flags_item &= ~NODROP
	flags_inventory &= ~CANTSTRIP
	H.melee_allowed = saved_melee_allowed
	H.allow_gun_usage = saved_gun_allowed
	LAZYREMOVE(H.brute_mod_override, src)
	LAZYREMOVE(H.burn_mod_override, src)
	to_chat(H, SPAN_DANGER("[name] beeps, \"The protection wears off.\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	update_icon(H)


/obj/item/storage/backpack/marine/smartpack/proc/immobile_form(mob/user)
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
		user.frozen = TRUE
		to_chat(user, SPAN_DANGER("[name] beeps, \"You are anchored in place and cannot be moved.\""))
		to_chat(user, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	else
		user.status_flags |= CANPUSH
		user.anchored = FALSE
		user.unfreeze()
		to_chat(user, SPAN_DANGER("[name] beeps, \"You can now move again.\""))

	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	update_icon(user)
	activated_form = TRUE

	addtimer(CALLBACK(src, .proc/immobile_form_cooldown, user), immobile_form_cooldown)

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

	repairing = TRUE
	update_icon(user)

	H.visible_message(SPAN_WARNING("[name] beeps, \"Engaging the repairing process.\""), \
		SPAN_WARNING("[name] beeps, \"Beginning to carefully examine your sustained damage.\""))
	playsound(loc, 'sound/mecha/mechmove04.ogg', 25, TRUE)
	if(!do_after(H, 100, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		repairing = FALSE
		update_icon(user)
		to_chat(user, SPAN_DANGER("[name] beeps, \"Repair process was cancelled.\""))
		return

	playsound(loc, 'sound/items/Welder2.ogg', 25, TRUE)
	battery_charge -= REPAIR_COST
	H.heal_overall_damage(50, 50, TRUE)
	H.pain.recalculate_pain()
	to_chat(user, SPAN_INFO("The current charge reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED]"))
	H.visible_message(SPAN_DANGER("[name] beeps, \"Completed the repairing process. Charge now reads [battery_charge]/[SMARTPACK_MAX_POWER_STORED].\""))

	addtimer(CALLBACK(src, .proc/repair_form_cooldown, user), repair_form_cooldown)

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
