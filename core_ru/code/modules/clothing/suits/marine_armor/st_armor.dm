#define ENRAGE_CD 1200
#define ENRAGE_FORM_COLOR "#be020265"

/obj/item/clothing/suit/storage/marine/m40
	name = "\improper M40 experimental armor"
	desc = "A custom set of M40 armor designed for use by USCM stormtrooper. Contains thick kevlar shielding and integrated experimental injectors of adrenaline with portative-protective dialysis device."
	item_icons = list(WEAR_JACKET = 'core_ru/icons/mob/humans/onmob/suit_1.dmi')
	icon = 'core_ru/icons/obj/items/clothing/cm_suits.dmi'
	icon_state = "st_armor"
	armor_melee = CLOTHING_ARMOR_HIGH
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROT
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_cold_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_heat_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS|BODY_FLAG_LEGS|BODY_FLAG_FEET
	flags_item = MOB_LOCK_ON_EQUIP|NO_CRYO_STORE
	specialty = "M40 stormtrooper"
	actions_types = list(/datum/action/item_action/toggle, /datum/action/item_action/specialist/enrage)
	unacidable = TRUE
	var/enrage_active = FALSE
	var/enrage_activable = TRUE
	var/saved_agu = TRUE
	var/saved_feels = TRUE
	var/saved_flags = DEFAULT_MOB_STATUS_FLAGS

/obj/item/clothing/suit/storage/marine/m40/verb/enrage()
	set name = "Activate Enrage"
	set desc = "Activate your M40 experimental armor protocol, give you rush of adrenaline for a short duration."
	set category = "Stormtrooper"
	set src in usr
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr

	if(H.wear_suit != src)
		to_chat(H, SPAN_WARNING("You must be wearing the M40 experimental armor to activate ENRAGE protocol!"))
		return

	if(!skillcheck(H, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_ST)
		to_chat(H, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(enrage_active)
		to_chat(H, SPAN_WARNING("You already have ENRAGE protocol activated!"))
		return

	if(!enrage_activable)
		to_chat(H, SPAN_WARNING("ENRAGE protocol was recently activated, Wait for the end of dialysis to be reused."))
		return

	to_chat(H, SPAN_DANGER("M40 experimental armor beeps, \"You feel adrenaline rush in your blood.\""))
	playsound(H, 'sound/items/hypospray.ogg', 25, TRUE)
	enrage_active = TRUE
	enrage_activable = FALSE
	src.flags_item |= NODROP
	src.flags_inventory |= CANTSTRIP
	LAZYSET(H.brute_mod_override, src, 0.6)
	src.slowdown = SLOWDOWN_ARMOR_NONE
	saved_agu = H.allow_gun_usage
	H.allow_gun_usage = FALSE
	saved_flags = H.status_flags
	H.status_flags &= ~(CANPUSH | CANKNOCKOUT)
	saved_feels = H.pain.feels_pain
	H.pain.feels_pain = FALSE
	H.pain.current_pain = 0
	H.add_filter("enrage_form", priority = 1, params = list("type" = "outline", "color" = ENRAGE_FORM_COLOR, "size" = 1))
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()
	addtimer(CALLBACK(src, PROC_REF(end_enrage), H), 15 SECONDS)

/obj/item/clothing/suit/storage/marine/m40/proc/end_enrage(mob/living/carbon/human/H)
	enrage_active = FALSE
	src.flags_item &= ~NODROP
	src.flags_inventory &= ~CANTSTRIP
	src.slowdown = SLOWDOWN_ARMOR_MEDIUM
	H.allow_gun_usage = saved_agu
	H.status_flags |= saved_flags
	H.pain.feels_pain = saved_feels
	LAZYREMOVE(H.brute_mod_override, src)
	to_chat(H, SPAN_DANGER("M40 experimental armor beeps, \"Protective dialysis has been activated.\""))
	playsound(H, 'core_ru/sound/effects/hearth_attack.ogg', 25, TRUE)
	H.remove_filter("enrage_form")

	addtimer(CALLBACK(src, PROC_REF(activable_enrage), H), ENRAGE_CD)

/obj/item/clothing/suit/storage/marine/m40/proc/activable_enrage(mob/living/carbon/human/user)
	if(!istype(user))
		return
	to_chat(user, SPAN_NOTICE("ENRAGE protocol can be activated again."))
	enrage_activable = TRUE

	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

	#undef ENRAGE_CD
	#undef ENRAGE_FORM_COLOR

/datum/action/item_action/specialist/enrage
	ability_primacy = SPEC_PRIMARY_ACTION_2

/datum/action/item_action/specialist/enrage/New(mob/living/user, obj/item/holder)
	..()
	name = "Activate Enrage"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('core_ru/icons/mob/hud/actions.dmi', button, "Stormtrooper")
	button.overlays += IMG

/datum/action/item_action/specialist/enrage/action_cooldown_check()
	var/obj/item/clothing/suit/storage/marine/m40/armor = holder_item
	if (!istype(armor))
		return FALSE

	return !armor.enrage_activable

///datum/action/item_action/specialist/enrage/can_use_action()
//	var/mob/living/carbon/human/H = owner
//	if(istype(H) && !H.is_mob_incapacitated() && H.wear_suit == holder_item)
//		return TRUE
//  (Если захотим сделать так, что бы нельзя было использовать в стане)
//  (Тут же будет и лок на броню и молот)

/datum/action/item_action/specialist/enrage/action_activate()
	var/obj/item/clothing/suit/storage/marine/m40/armor = holder_item
	if (!istype(armor))
		return

	armor.enrage()
