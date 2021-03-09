/datum/tech/droppod/item/combat_implants
	name = "Combat Implants"
	desc = "Marines get access to combat implants to improve their ability to function."

	droppod_name = "Implants"

	flags = TREE_FLAG_MARINE

	required_points = 25
	tier = /datum/tier/two

	droppod_input_message = "Choose a combat implant to retrieve from the droppod."
	options_to_give = 2

/datum/tech/droppod/item/combat_implants/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Nightvision Implant"] = /obj/item/device/implanter/nvg
	.["Self-Revive Implant"] = /obj/item/device/implanter/self_revive
	.["Agility Implant"] = /obj/item/device/implanter/agility
	.["Subdermal Armor"] = /obj/item/device/implanter/subdermal_armor

/datum/tech/droppod/item/combat_implants/get_items_to_give(mob/living/carbon/human/H, obj/structure/droppod/D)
	var/list/chosen_options = ..()

	if(!chosen_options)
		return

	var/obj/item/storage/box/implant/B = new()
	B.storage_slots = options_to_give
	for(var/i in chosen_options)
		new i(B)

	return list(B)

/obj/item/storage/box/implant
	name = "implant box"
	desc = "A box with, typically containing implanters."
	icon_state = "implant"
	storage_slots = 5
	can_hold = list(/obj/item/device/implanter)
	w_class = SIZE_SMALL

/obj/item/device/implanter
	name = "implanter"
	desc = "Used to inject an implant into someone."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "implanter"

	w_class = SIZE_SMALL

	var/implant_type
	var/uses = 1
	var/implant_time = 3 SECONDS

/obj/item/device/implanter/update_icon()
	if(!uses)
		icon_state = "[initial(icon_state)]0"
		return

	icon_state = initial(icon_state)

/obj/item/device/implanter/attack(mob/living/M, mob/living/user, def_zone)
	if(!uses || !implant_type)
		return ..()

	if(LAZYISIN(M.implants, implant_type))
		to_chat(user, SPAN_WARNING("[M] already have this implant!"))
		return

	if(LAZYLEN(M.implants) >= M.max_implants)
		to_chat(user, SPAN_WARNING("[M] can't take any more implants!"))
		return

	if(M != user && !do_after(user, implant_time, INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		return

	implant(M)

/obj/item/device/implanter/proc/implant(var/mob/M)
	if(uses <= 0)
		return

	if(LAZYISIN(M.implants, implant_type))
		QDEL_NULL(M.implants[implant_type])

	var/obj/item/device/implant/I = new implant_type(M)
	LAZYSET(M.implants, implant_type, I)
	I.on_implanted(M)
	uses = max(uses - 1, 0)
	if(!uses)
		garbage = TRUE
	update_icon()

/obj/item/device/implant
	name = "implant"
	desc = "An implant, usually delivered with an implanter."
	icon_state = "implant"

	var/mob/living/host

/obj/item/device/implant/proc/on_implanted(var/mob/living/M)
	SHOULD_CALL_PARENT(TRUE)
	host = M

/obj/item/device/implant/Destroy()
	host = null
	return ..()

/obj/item/device/implanter/nvg
	name = "nightvision implant"
	implant_type = /obj/item/device/implant/nvg

/obj/item/device/implant/nvg/on_implanted(var/mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_UPDATE_SIGHT, .proc/give_nvg)
	give_nvg(M)

/obj/item/device/implant/nvg/proc/give_nvg(var/mob/living/M)
	SIGNAL_HANDLER
	M.see_invisible = SEE_INVISIBLE_MINIMUM

/obj/item/device/implanter/self_revive
	name = "self-revive implant"
	implant_type = /obj/item/device/implant/self_revive

/obj/item/device/implant/self_revive
	// Heal 130 points of damage
	var/heal_amt = 130
	var/temp_pain_reduction = PAIN_REDUCTION_FULL

	var/stimulant_to_inject = "speed_stimulant"
	var/inject_amt = 1

/obj/item/device/implant/self_revive/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), .proc/check_revive)

/obj/item/device/implant/self_revive/proc/check_revive(var/mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if((M.health - damagedata["damage"]) <= HEALTH_THRESHOLD_DEAD)
		UnregisterSignal(M, list(
			COMSIG_MOB_TAKE_DAMAGE,
			COMSIG_HUMAN_TAKE_DAMAGE,
			COMSIG_XENO_TAKE_DAMAGE
		))

		INVOKE_ASYNC(src, .proc/revive, M)

/obj/item/device/implant/self_revive/proc/revive(var/mob/living/M)
	M.apply_damage(-heal_amt, BURN)
	M.apply_damage(-heal_amt, BRUTE)
	M.apply_damage(-M.getOxyLoss(), OXY)

	M.pain.apply_pain_reduction(temp_pain_reduction)
	M.reagents.add_reagent(stimulant_to_inject, inject_amt)

/obj/item/device/implanter/agility
	name = "agility implant"
	implant_type = /obj/item/device/implant/agility

/obj/item/device/implant/agility
	var/move_delay_mult = 0.94

/obj/item/device/implant/agility/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_MOVE_DELAY, .proc/handle_movedelay)

/obj/item/device/implant/agility/proc/handle_movedelay(var/mob/living/M, list/movedata)
	SIGNAL_HANDLER
	movedata["move_delay"] *= move_delay_mult

/obj/item/device/implanter/subdermal_armor
	name = "subdermal armor implant"
	implant_type = /obj/item/device/implant/subdermal_armor

/obj/item/device/implant/subdermal_armor
	var/damage_mult = 0.75

/obj/item/device/implant/subdermal_armor/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), .proc/handle_damage)

/obj/item/device/implant/subdermal_armor/proc/handle_damage(var/mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if(damagetype == BRUTE || damagetype == BURN)
		damagedata["damage"] *= damage_mult
