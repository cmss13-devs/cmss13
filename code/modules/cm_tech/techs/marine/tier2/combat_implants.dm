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
	.["Rejuvenation Implant"] = /obj/item/device/implanter/rejuv
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
	var/implant_string = "Awesome."

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

	var/self_inject = TRUE
	if(M != user)
		self_inject = FALSE
		if(!do_after(user, implant_time, INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			return

	implant(M, self_inject)

/obj/item/device/implanter/attack_self(mob/user)
	implant(user, TRUE)
	return

/obj/item/device/implanter/proc/implant(var/mob/M, var/self_inject)
	if(uses <= 0)
		return

	if(LAZYISIN(M.implants, implant_type))
		QDEL_NULL(M.implants[implant_type])

	if(self_inject)
		to_chat(M, SPAN_NOTICE("You implant yourself with \the [src]. You feel [implant_string]"))
	else
		to_chat(M, SPAN_NOTICE("You've been implanted with \the [src]. You feel [implant_string]"))

	playsound(src, 'sound/items/air_release.ogg', 75, TRUE)
	var/obj/item/device/internal_implant/I = new implant_type(M)
	LAZYSET(M.implants, implant_type, I)
	I.on_implanted(M)
	uses = max(uses - 1, 0)
	if(!uses)
		garbage = TRUE
	update_icon()

/obj/item/device/internal_implant
	name = "implant"
	desc = "An implant, usually delivered with an implanter."
	icon_state = "implant"

	var/mob/living/host

/obj/item/device/internal_implant/proc/on_implanted(var/mob/living/M)
	SHOULD_CALL_PARENT(TRUE)
	host = M

/obj/item/device/internal_implant/Destroy()
	host = null
	return ..()

/obj/item/device/implanter/nvg
	name = "nightvision implant"
	desc = "This implant will give you night vision. These implants get damaged on death."
	implant_type = /obj/item/device/internal_implant/nvg
	implant_string = "your pupils dilating to unsettling levels."

/obj/item/device/internal_implant/nvg
	var/implant_health = 2

/obj/item/device/internal_implant/nvg/on_implanted(var/mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_UPDATE_SIGHT, .proc/give_nvg)
	RegisterSignal(M, COMSIG_MOB_DEATH, .proc/remove_health)
	give_nvg(M)

/obj/item/device/internal_implant/nvg/proc/remove_health(var/mob/living/M)
	SIGNAL_HANDLER
	implant_health -= 1
	if(implant_health <= 0)
		UnregisterSignal(M, list(
			COMSIG_HUMAN_POST_UPDATE_SIGHT,
			COMSIG_MOB_DEATH
		))
		to_chat(M, SPAN_WARNING("Everything feels a lot darker."))
	else
		to_chat(M, SPAN_WARNING("You feel the effects of the nightvision implant waning."))

/obj/item/device/internal_implant/nvg/proc/give_nvg(var/mob/living/M)
	SIGNAL_HANDLER
	M.see_invisible = SEE_INVISIBLE_MINIMUM

/obj/item/device/implanter/rejuv
	name = "rejuvenation implant"
	desc = "This implant will automatically activate at the brink of death. When activated, it will expend itself, greatly healing you, and giving you a stimulant that speeds you up significantly and dulls all pain."
	implant_type = /obj/item/device/internal_implant/rejuv
	implant_string = "something beating next to your heart." //spooky second heart deep lore

/obj/item/device/internal_implant/rejuv
	var/list/stimulant_to_inject = list(
		"speed_stimulant",
		"brain_stimulant",
		"oxycodone"
	)
	var/inject_amt = 3

/obj/item/device/internal_implant/rejuv/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), .proc/check_revive)

/obj/item/device/internal_implant/rejuv/proc/check_revive(var/mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if((M.health - damagedata["damage"]) <= HEALTH_THRESHOLD_CRIT)
		UnregisterSignal(M, list(
			COMSIG_MOB_TAKE_DAMAGE,
			COMSIG_HUMAN_TAKE_DAMAGE,
			COMSIG_XENO_TAKE_DAMAGE
		))

		INVOKE_ASYNC(src, .proc/revive, M)

/obj/item/device/internal_implant/rejuv/proc/revive(var/mob/living/M)
	M.heal_all_damage()

	for(var/i in stimulant_to_inject)
		M.reagents.add_reagent(i, inject_amt)

/obj/item/device/implanter/agility
	name = "agility implant"
	desc = "This implant will make you more agile, allowing you to vault over structures extremely quickly and allowing you to fireman carry other people."
	implant_type = /obj/item/device/internal_implant/agility
	implant_string = "your heartrate increasing significantly and your pupils dilating."

/obj/item/device/implanter/agility/examine(user)
	..()
	to_chat(user, SPAN_NOTICE("To fireman carry someone, aggresive-grab them and drag their sprite to yours."))

/obj/item/device/internal_implant/agility
	var/move_delay_mult  = 0.94
	var/climb_delay_mult = 0.20
	var/carry_delay_mult = 0.25
	var/grab_delay_mult  = 0.30

/obj/item/device/internal_implant/agility/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_HUMAN_POST_MOVE_DELAY, .proc/handle_movedelay)
	RegisterSignal(M, COMSIG_LIVING_CLIMB_STRUCTURE, .proc/handle_climbing)
	RegisterSignal(M, COMSIG_HUMAN_CARRY, .proc/handle_fireman)
	RegisterSignal(M, COMSIG_MOB_GRAB_UPGRADE, .proc/handle_grab)

/obj/item/device/internal_implant/agility/proc/handle_movedelay(var/mob/living/M, list/movedata)
	SIGNAL_HANDLER
	movedata["move_delay"] *= move_delay_mult

/obj/item/device/internal_implant/agility/proc/handle_climbing(var/mob/living/M, list/climbdata)
	SIGNAL_HANDLER
	climbdata["climb_delay"] *= climb_delay_mult

/obj/item/device/internal_implant/agility/proc/handle_fireman(var/mob/living/M, list/carrydata)
	SIGNAL_HANDLER
	carrydata["carry_delay"] *= carry_delay_mult
	return COMPONENT_CARRY_ALLOW

/obj/item/device/internal_implant/agility/proc/handle_grab(var/mob/living/M, list/grabdata)
	SIGNAL_HANDLER
	grabdata["grab_delay"] *= grab_delay_mult
	return TRUE

/obj/item/device/implanter/subdermal_armor
	name = "subdermal armor implant"
	desc = "This implant will grant you armor under the skin, reducing incoming damage by a quarter."
	implant_type = /obj/item/device/internal_implant/subdermal_armor
	implant_string = "your skin becoming significantly harder.. That's going to hurt in a decade."

/obj/item/device/internal_implant/subdermal_armor
	var/burn_damage_mult = 0.9
	var/brute_damage_mult = 0.85
	var/bone_break_mult = 0.25

/obj/item/device/internal_implant/subdermal_armor/on_implanted(mob/living/M)
	. = ..()
	RegisterSignal(M, list(
		COMSIG_MOB_TAKE_DAMAGE,
		COMSIG_HUMAN_TAKE_DAMAGE,
		COMSIG_XENO_TAKE_DAMAGE
	), .proc/handle_damage)
	RegisterSignal(M, COMSIG_HUMAN_BONEBREAK_PROBABILITY, .proc/handle_bonebreak)

/obj/item/device/internal_implant/subdermal_armor/proc/handle_damage(var/mob/living/M, list/damagedata, damagetype)
	SIGNAL_HANDLER
	if(damagetype == BRUTE)
		damagedata["damage"] *= brute_damage_mult
	else if(damagetype == BURN)
		damagedata["damage"] *= burn_damage_mult

/obj/item/device/internal_implant/subdermal_armor/proc/handle_bonebreak(var/mob/living/M, list/bonedata)
	SIGNAL_HANDLER
	bonedata["bonebreak_probability"] *= bone_break_mult
