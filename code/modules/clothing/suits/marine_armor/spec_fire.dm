#define FIRE_SHIELD_CD 150

/obj/item/clothing/suit/storage/marine/M35
	name = "\improper M35 pyrotechnician armor"
	desc = "A custom set of M35 armor designed for use by USCM Pyrotechnicians."
	icon_state = "pyro_armor"
	slowdown = SLOWDOWN_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	light_range = 5
	fire_intensity_resistance = BURN_LEVEL_TIER_1
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	specialty = "M35 pyrotechnician"
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/specialist/fire_shield)
	unacidable = TRUE
	var/fire_shield_on = FALSE
	var/can_activate = TRUE

/obj/item/clothing/suit/storage/marine/M35/equipped(mob/user, slot)
	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_LIVING_FLAMER_CROSSED, PROC_REF(flamer_fire_callback))
	..()

/obj/item/clothing/suit/storage/marine/M35/verb/fire_shield()
	set name = "Activate Fire Shield"
	set desc = "Activate your armor's FIREWALK protocol for a short duration."
	set category = "Pyro"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr

	if(H.wear_suit != src)
		to_chat(H, SPAN_WARNING("You must be wearing the M35 pyro armor to activate FIREWALK protocol!"))
		return

	if(!skillcheck(H, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_PYRO)
		to_chat(H, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(fire_shield_on)
		to_chat(H, SPAN_WARNING("You already have FIREWALK protocol activated!"))
		return

	if(!can_activate)
		to_chat(H, SPAN_WARNING("FIREWALK protocol was recently activated, wait before trying to activate it again."))
		return

	to_chat(H, SPAN_NOTICE("FIREWALK protocol has been activated. You will now be immune to fire for 6 seconds!"))
	RegisterSignal(H, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_shield_is_on))
	RegisterSignal(H, list(
		COMSIG_LIVING_FLAMER_FLAMED,
	), PROC_REF(flamer_fire_callback))
	fire_shield_on = TRUE
	can_activate = FALSE
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()
	addtimer(CALLBACK(src, PROC_REF(end_fire_shield), H), 6 SECONDS)

	H.add_filter("firewalk_on", 1, list("type" = "outline", "color" = "#03fcc6", "size" = 1))

/obj/item/clothing/suit/storage/marine/M35/proc/end_fire_shield(mob/living/carbon/human/user)
	if(!istype(user))
		return
	to_chat(user, SPAN_NOTICE("FIREWALK protocol has finished."))
	UnregisterSignal(user, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	fire_shield_on = FALSE

	user.remove_filter("firewalk_on")

	addtimer(CALLBACK(src, PROC_REF(enable_fire_shield), user), FIRE_SHIELD_CD)

/obj/item/clothing/suit/storage/marine/M35/proc/enable_fire_shield(mob/living/carbon/human/user)
	if(!istype(user))
		return
	to_chat(user, SPAN_NOTICE("FIREWALK protocol can be activated again."))
	can_activate = TRUE

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

/// This proc is solely so that IgniteMob() fails
/obj/item/clothing/suit/storage/marine/M35/proc/fire_shield_is_on(mob/living/L)
	SIGNAL_HANDLER

	if(L.fire_reagent?.fire_penetrating)
		return

	return COMPONENT_CANCEL_IGNITION

/obj/item/clothing/suit/storage/marine/M35/proc/flamer_fire_callback(mob/living/L, datum/reagent/R)
	SIGNAL_HANDLER

	if(R.fire_penetrating)
		return

	. = COMPONENT_NO_IGNITE
	if(fire_shield_on)
		. |= COMPONENT_NO_BURN

/obj/item/clothing/suit/storage/marine/M35/dropped(mob/user)
	if (!istype(user))
		return
	UnregisterSignal(user, list(
		COMSIG_LIVING_PREIGNITION,
		COMSIG_LIVING_FLAMER_CROSSED,
		COMSIG_LIVING_FLAMER_FLAMED,
	))
	..()

#undef FIRE_SHIELD_CD

/datum/action/item_action/specialist/fire_shield
	ability_primacy = SPEC_PRIMARY_ACTION_2

/datum/action/item_action/specialist/fire_shield/New(mob/living/user, obj/item/holder)
	..()
	name = "Activate Fire Shield"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/items/clothing/suits/suits_by_map/jungle.dmi', button, "pyro_armor")
	button.overlays += IMG

/datum/action/item_action/specialist/fire_shield/action_cooldown_check()
	var/obj/item/clothing/suit/storage/marine/M35/armor = holder_item
	if (!istype(armor))
		return FALSE

	return armor.can_activate

/datum/action/item_action/specialist/fire_shield/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && H.wear_suit == holder_item)
		return TRUE

/datum/action/item_action/specialist/fire_shield/action_activate()
	. = ..()
	var/obj/item/clothing/suit/storage/marine/M35/armor = holder_item
	if (!istype(armor))
		return

	armor.fire_shield()
