/datum/tech/droppod/item/modular_armor_upgrade
	name = "Modular Armor Upgrade Kits"
	desc = {"Marines get access to plates they can put in their uniforms that act as temporary\
			HP. Ceramic plates will have higher temp HP, but break after 1 use; metal plates\
			break into scrap that can be combined to form improvised plates that are almost\
			as good."}
	icon_state = "combat_plates"
	droppod_name = "Armor Plates"

	flags = TREE_FLAG_MARINE

	required_points = 10
	tier = /datum/tier/one

	droppod_input_message = "Choose a plate to retrieve from the droppod."

/datum/tech/droppod/item/modular_armor_upgrade/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	.["Ceramic Plate"] = /obj/item/clothing/accessory/health/ceramic_plate
	.["Metal Plate"] = /obj/item/clothing/accessory/health

/obj/item/clothing/accessory/health
	name = "armor plate"
	desc = "A durable plate, able to absorb a lot of damage. Attach it to a uniform to use."

	icon = 'icons/obj/items/items.dmi'
	var/base_icon_state
	icon_state = "regular2"

	slot = ACCESSORY_SLOT_ARMOR_C
	var/armor_health = 10
	var/armor_maxhealth = 10

	var/take_slash_damage = TRUE
	var/slash_durability_mult = 0.25
	var/projectile_durability_mult = 0.1

	var/list/health_states = list(
		0,
		50,
		100
	)

	var/scrappable = TRUE

	var/armor_hitsound = 'sound/effects/metalhit.ogg'
	var/armor_shattersound = 'sound/effects/metal_shatter.ogg'

/obj/item/clothing/accessory/health/Initialize(mapload, ...)
	base_icon_state = icon_state
	. = ..()

	update_icon()

/obj/item/clothing/accessory/health/update_icon()
	for(var/health_state in health_states)
		if((armor_health/armor_maxhealth) <= (health_state*0.01))
			icon_state = "[base_icon_state]_[health_state]"
			return

/obj/item/clothing/accessory/health/examine(mob/user)
	. = ..()
	if(armor_health >= armor_maxhealth)
		to_chat(user, SPAN_NOTICE("It is in pristine condition."))
	else if(armor_health >= armor_maxhealth*0.8)
		to_chat(user, SPAN_NOTICE("It is slightly damaged."))
	else if(armor_health >= armor_maxhealth*0.5)
		to_chat(user, SPAN_NOTICE("It is moderately damaged."))
	else if(armor_health >= armor_maxhealth*0.2)
		to_chat(user, SPAN_NOTICE("It is seriously damaged."))
	else if(armor_health > 0)
		to_chat(user, SPAN_NOTICE("It is falling apart!"))
	else
		to_chat(user, SPAN_NOTICE("It is broken."))

/obj/item/clothing/accessory/health/on_attached(obj/item/clothing/S, mob/living/user)
	. = ..()
	if(!.)
		return

	RegisterSignal(S, COMSIG_ITEM_EQUIPPED, .proc/check_to_signal)
	RegisterSignal(S, COMSIG_ITEM_DROPPED, .proc/unassign_signals)

	var/mob/living/carbon/human/H = user
	if(istype(H) && H.w_uniform == S)
		check_to_signal(S, user, WEAR_BODY)

	if(user)
		to_chat(user, SPAN_NOTICE("You attach [src] to [has_suit]."))

/obj/item/clothing/accessory/health/proc/check_to_signal(obj/item/clothing/S, mob/living/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_BODY)
		if(take_slash_damage)
			RegisterSignal(user, COMSIG_HUMAN_XENO_ATTACK, .proc/take_slash_damage)
		RegisterSignal(user, COMSIG_HUMAN_BULLET_ACT, .proc/take_bullet_damage)
	else
		unassign_signals(S, user)

/obj/item/clothing/accessory/health/proc/unassign_signals(obj/item/clothing/S, mob/living/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, list(
		COMSIG_HUMAN_XENO_ATTACK,
		COMSIG_HUMAN_BULLET_ACT
	))

/obj/item/clothing/accessory/health/proc/take_bullet_damage(mob/living/user, damage, ammo_flags)
	SIGNAL_HANDLER
	if(damage <= 0 || (ammo_flags & AMMO_IGNORE_ARMOR))
		return

	var/damage_to_nullify = armor_health
	armor_health = max(armor_health - damage*projectile_durability_mult, 0)

	update_icon()

	if(damage_to_nullify)
		playsound(user, armor_hitsound, 25, 1)
		return COMPONENT_CANCEL_BULLET_ACT

/obj/item/clothing/accessory/health/proc/take_slash_damage(mob/living/user, damage)
	SIGNAL_HANDLER
	var/damage_to_nullify = armor_health
	armor_health = max(armor_health - damage*slash_durability_mult, 0)

	update_icon()
	if(!armor_health && damage_to_nullify)
		user.show_message(SPAN_WARNING("You feel [src] break apart."), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		playsound(user, armor_shattersound, 35, 1)

	if(damage_to_nullify)
		playsound(user, armor_hitsound, 25, 1)
		return COMPONENT_CANCEL_XENO_ATTACK

/obj/item/clothing/accessory/health/on_removed(mob/living/user, obj/item/clothing/C)
	if(!has_suit)
		return

	unassign_signals(C, user)

	UnregisterSignal(C, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))


	has_suit = null
	if(usr)
		usr.put_in_hands(src)
	else
		src.forceMove(get_turf(src))

/obj/item/clothing/accessory/health/attackby(obj/item/I, mob/user)
	if(has_suit || !scrappable)
		return ..()

	if(!istype(I, /obj/item/clothing/accessory/health)) // Only works for matching types
		return ..()

	var/obj/item/clothing/accessory/health/H = I

	if(H.has_suit || !H.scrappable)
		return ..()

	if(!H.armor_health && !armor_health)
		new /obj/item/clothing/accessory/health/scrap(get_turf(user))

		qdel(H)
		qdel(src)

/obj/item/clothing/accessory/health/ceramic_plate
	name = "ceramic plate"
	desc = "A strong plate, able to protect the user from a large amount of bullets. Ineffective against sharp objects."

	icon_state = "ceramic2"

	take_slash_damage = FALSE
	scrappable = FALSE

	armor_health = 100
	armor_maxhealth = 100

	armor_shattersound = 'sound/effects/ceramic_shatter.ogg'

/obj/item/clothing/accessory/health/ceramic_plate/take_bullet_damage(var/mob/living/user, damage, ammo_flags)
	if(ammo_flags & AMMO_XENO_ACID)
		return

	return ..()

/obj/item/clothing/accessory/health/scrap
	name = "scrap metal"
	desc = "A weak plate, only able to protect from a little bit of damage."

	icon_state = "scrap"
	health_states = list(
		0,
		100
	)

	scrappable = FALSE

	armor_health = 7.5
	armor_maxhealth = 7.5

/obj/item/clothing/accessory/health/scrap/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()

	if(!armor_health)
		qdel(src)
