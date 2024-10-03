#define LOW_MODE_RECH			4 SECONDS
#define HALF_MODE_RECH			8 SECONDS
#define FULL_MODE_RECH			16 SECONDS

#define LOW_MODE_CHARGE			60
#define HALF_MODE_CHARGE		120
#define FULL_MODE_CHARGE		180

#define LOW_MODE_DMGHEAL		10
#define HALF_MODE_DMGHEAL		40
#define FULL_MODE_DMGHEAL		120

#define LOW_MODE_HEARTD_LOWER	1
#define HALF_MODE_HEARTD_LOWER	1.5
#define FULL_MODE_HEARTD_LOWER	2
#define LOW_MODE_HEARTD_UPPER	4
#define HALF_MODE_HEARTD_UPPER	9
#define FULL_MODE_HEARTD_UPPER	18

#define FULL_MODE_TOXIN_DMG		30

#define LOW_MODE_DEF			"Low Power Mode"
#define HALF_MODE_DEF			"Half Power Mode"
#define FULL_MODE_DEF			"Full Power Mode"

#define PROB_DMGHEART		33 //%

/obj/item/device/defibrillator
	name = "emergency defibrillator"
	desc = "A handheld emergency defibrillator, used to restore fibrillating patients. Can optionally bring people back from the dead."
	icon = 'core_ru/icons/obj/items/defibs.dmi'
	icon_state = "defib"
	item_state = "defib"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM

	var/icon_state_for_paddles = "defib"

	var/blocked_by_suit = TRUE
	var/heart_damage_to_deal_lower = LOW_MODE_HEARTD_LOWER
	var/heart_damage_to_deal_upper = LOW_MODE_HEARTD_UPPER
	var/damage_heal_threshold = LOW_MODE_DMGHEAL //This is the maximum non-oxy damage the defibrillator will heal to get a patient above -100, in all categories
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	var/charge_cost = LOW_MODE_CHARGE //How much energy is used.
	var/obj/item/cell/dcell = null
	var/datum/effect_system/spark_spread/sparks = new

	var/paddles = /obj/item/device/paddles
	var/obj/item/device/paddles/paddles_type

	var/atom/tether_holder

	var/heart_damage_mult = 1.0 //Don't set on 0, bad move.
	var/additional_charge_cost = 1.0 // 0.5 cost lower
	var/boost_recharge = 1.0 // 0.5 faster
	var/healing_mult = 1.0 // 1.5 heal more

	var/skill_req = SKILL_MEDICAL_MEDIC

	var/range = 2
	var/list/difib_mode_choices = list(LOW_MODE_DEF, HALF_MODE_DEF, FULL_MODE_DEF)
	var/defib_mode = LOW_MODE_DEF
	var/defib_recharge = LOW_MODE_RECH //Recharge defib

/obj/item/device/defibrillator/Initialize(mapload, ...)
	. = ..()

	paddles_type = new paddles(src)

	sparks.set_up(5, 0, src)
	sparks.attach(src)
	dcell = new/obj/item/cell(src)
	RegisterSignal(paddles_type, COMSIG_PARENT_PREQDELETED, PROC_REF(override_delete))
	update_icon()

/obj/item/device/defibrillator/update_icon()
	icon_state = initial(icon_state)
	overlays.Cut()

	update_overlays()

/obj/item/device/defibrillator/proc/update_overlays()
	if(overlays)
		overlays.Cut()

	if(paddles_type.loc == src)
		overlays += image(icon, "+paddles_[icon_state_for_paddles]")

	if(dcell && dcell.charge)
		switch(round(dcell.charge * 100 / dcell.maxcharge))
			if(67 to INFINITY)
				overlays += image(icon, "+full")
			if(34 to 66)
				overlays += image(icon, "+half")
			if(1 to 33)
				overlays += image(icon, "+low")
	else
		overlays += image(icon, "+empty")

//No flying aroun da map, defib is heavy, medic is stupid
/obj/item/device/defibrillator/try_to_throw(mob/living/user)
	if(!paddles_type || paddles_type.loc != src)
		return FALSE
	return TRUE

/obj/item/device/defibrillator/get_examine_text(mob/user)
	. = ..()
	var/maxuses = 0
	var/currentuses = 0
	maxuses = round(dcell.maxcharge / charge_cost)
	currentuses = round(dcell.charge / charge_cost)
	. += SPAN_INFO("It has [currentuses] out of [maxuses] uses left in its internal battery. Currently it is in [defib_mode], and will take [defib_recharge/10] seconds to recharge between shocks.")
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_STRONG_DEFIBS) || !blocked_by_suit)
		. += SPAN_NOTICE("This defibrillator will ignore worn armor.")

/obj/item/device/defibrillator/clicked(mob/user, list/mods)
	if(!ishuman(usr))
		return
	if(mods["alt"])
		change_defib_mode(user)
		return 1
	return ..()

/obj/item/device/defibrillator/proc/change_defib_mode(mob/user)
	if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(paddles_type.charged)
		to_chat(user, SPAN_WARNING("Paddles already charged, you don't can change mode."))
		return

	var/difib_modes_to_choise = difib_mode_choices

	defib_mode = tgui_input_list(usr, "Select Defib Mode", "Defib Mode Selecting", difib_modes_to_choise)

	if(!defib_mode)
		return

	switch(defib_mode)
		if(FULL_MODE_DEF)
			heart_damage_to_deal_lower = FULL_MODE_HEARTD_LOWER * heart_damage_mult
			heart_damage_to_deal_upper = FULL_MODE_HEARTD_UPPER * heart_damage_mult
			damage_heal_threshold = FULL_MODE_DMGHEAL * healing_mult
			charge_cost = FULL_MODE_CHARGE * additional_charge_cost
			defib_recharge = FULL_MODE_RECH * boost_recharge
		if(HALF_MODE_DEF)
			heart_damage_to_deal_lower = HALF_MODE_HEARTD_LOWER * heart_damage_mult
			heart_damage_to_deal_upper = HALF_MODE_HEARTD_UPPER * heart_damage_mult
			damage_heal_threshold = HALF_MODE_DMGHEAL * healing_mult
			charge_cost = HALF_MODE_CHARGE * additional_charge_cost
			defib_recharge = HALF_MODE_RECH * boost_recharge
		if(LOW_MODE_DEF)
			heart_damage_to_deal_lower = LOW_MODE_HEARTD_LOWER * heart_damage_mult
			heart_damage_to_deal_upper = LOW_MODE_HEARTD_UPPER * heart_damage_mult
			damage_heal_threshold = LOW_MODE_DMGHEAL * healing_mult
			charge_cost = LOW_MODE_CHARGE * additional_charge_cost
			defib_recharge = LOW_MODE_RECH * boost_recharge

	user.visible_message(SPAN_NOTICE("[user] turns [src] in [defib_mode]."),
	SPAN_NOTICE("You change \the [src]'s mode to [defib_mode], recharging will take [defib_recharge/10] seconds."))
	if(defib_mode == FULL_MODE_DEF)
		to_chat(user, SPAN_WARNING("WARNING! \The [src] is now in high power mode! The increased voltage has the potential to cause severe cardiac damage!"))

	add_fingerprint(user)

/obj/item/device/defibrillator/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user))
		return

	if(!paddles_type || paddles_type.loc != src)
		return

	paddles_type.attack_hand(user)
	to_chat(user, SPAN_PURPLE("[icon2html(src, user)] Picked up a paddles."))
	playsound(get_turf(src), 'sound/items/defib_safetyOff.ogg', 25, 0)

	user.put_in_inactive_hand(paddles_type)
	paddles_type.update_icon()
	update_icon()
	add_fingerprint(usr)
	..()

/obj/item/device/defibrillator/MouseDrop(obj/over_object as obj)
	if(!CAN_PICKUP(usr, src))
		return ..()
	if(!istype(over_object, /atom/movable/screen))
		return ..()
	if(loc != usr)
		return ..()

	switch(over_object.name)
		if("r_hand")
			if(usr.drop_inv_item_on_ground(src))
				usr.put_in_r_hand(src)
		if("l_hand")
			if(usr.drop_inv_item_on_ground(src))
				usr.put_in_l_hand(src)
	add_fingerprint(usr)

/obj/item/device/defibrillator/attackby(obj/item/W, mob/user)
	if(W == paddles_type)
		paddles_type.unwield(user)
		recall_paddles()
		playsound(get_turf(src), 'sound/items/defib_safetyOn.ogg', 25, 0)
	else
		. = ..()

/obj/item/device/defibrillator/proc/set_tether_holder(atom/A)
	tether_holder = A

	if(paddles_type)
		paddles_type.reset_tether()

/obj/item/device/defibrillator/forceMove(atom/dest)
	. = ..()
	if(isturf(dest))
		set_tether_holder(src)
	else
		set_tether_holder(loc)

/obj/item/device/defibrillator/proc/override_delete()
	SIGNAL_HANDLER
	recall_paddles()
	return COMPONENT_ABORT_QDEL

/obj/item/device/defibrillator/proc/recall_paddles()
	if(ismob(paddles_type.loc))
		var/mob/M = paddles_type.loc
		paddles_type.unwield(M)
		M.drop_held_item(paddles_type)
		if(paddles_type.charged)
			playsound(get_turf(src), "sparks", 25, 1, 4)
			paddles_type.charged = FALSE
		paddles_type.update_icon()

	paddles_type.forceMove(src)

	update_icon()

/obj/item/device/defibrillator/pickup(obj/item/storage/storage)
	. = ..()
	if(!paddles_type)
		return

	if(paddles_type.loc == loc)
		return

	if(get_dist(paddles_type, src) > range)
		recall_paddles()

/obj/item/device/defibrillator/on_enter_storage(obj/item/storage/storage)
	. = ..()
	if(paddles_type.loc != src)
		recall_paddles()

/obj/item/device/defibrillator/Destroy()
	if(paddles_type)
		if(paddles_type.loc == src)
			UnregisterSignal(paddles_type, COMSIG_PARENT_PREQDELETED)
		else
			paddles_type.attached_to = null
			paddles_type = null

	QDEL_NULL(dcell)
	QDEL_NULL(sparks)
	QDEL_NULL(paddles_type)

	. = ..()

/obj/item/device/defibrillator/proc/remove_attached()
	UnregisterSignal(paddles_type, COMSIG_PARENT_PREQDELETED)
	paddles_type = null

/mob/living/carbon/human/proc/get_ghost(check_client = TRUE, check_can_reenter = TRUE)
	if(client)
		return null

	for(var/mob/dead/observer/G in GLOB.observer_list)
		if(G.mind && G.mind.original == src)
			var/mob/dead/observer/ghost = G
			if(ghost && ghost.client && ghost.can_reenter_corpse)
				return ghost

/mob/living/carbon/human/proc/check_tod()
	if(!undefibbable && world.time <= timeofdeath + revive_grace_period)
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_revivable(ignore_heart = FALSE)
	if(isnull(internal_organs_by_name) || isnull(internal_organs_by_name["heart"]))
		return FALSE
	var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]
	var/obj/limb/head = get_limb("head")

	if(chestburst || !head || head.status & LIMB_DESTROYED || !ignore_heart && (!heart || heart.organ_status >= ORGAN_BROKEN) || !has_brain() || status_flags & PERMANENTLY_DEAD)
		return FALSE
	return TRUE

/obj/item/device/defibrillator/proc/try_to_revive(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/time_pass = world.time - target.timeofdeath
	var/time_remaining = (time_pass - target.revive_grace_period) * (-1)
	return prob(time_remaining / initial(target.revive_grace_period) * 100 + charge_cost / 4)

/obj/item/device/defibrillator/proc/check_revive(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!ishuman(target) || isyautja(target))
		to_chat(user, SPAN_WARNING("You can't defibrilate [target]. You don't even know where to put the paddles!"))
		return
	if(dcell.charge <= charge_cost)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src]'s battery is too low! It needs to recharge."))
		return
	if(target.stat != DEAD)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Vital signs detected. Aborting."))
		return

	if(!target.is_revivable())
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Patient's general condition does not allow reviving."))
		return

	if((blocked_by_suit && defib_mode != FULL_MODE_DEF) && target.wear_suit && (istype(target.wear_suit, /obj/item/clothing/suit/armor) || istype(target.wear_suit, /obj/item/clothing/suit/storage/marine)) && prob(95))
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Paddles registering >100,000 ohms, Possible cause: Suit or Armor interfering."))
		return

	if((!target.check_tod() && !issynth(target))) //synthetic species have no expiration date
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Patient is braindead."))
		return

	return TRUE

/obj/item/device/defibrillator/compact_adv
	name = "advanced compact defibrillator"
	desc = "An advanced compact defibrillator that trades capacity for strong immediate power. Ignores armor and heals strongly and quickly, at the cost of very low charge."
	icon_state = "compact_defib"
	item_state = "defib"
	w_class = SIZE_MEDIUM
	blocked_by_suit = FALSE
	heart_damage_mult = 0.6
	additional_charge_cost = 1.8
	boost_recharge = 0.4
	healing_mult = 1.25
	range = 4
	skill_req = SKILL_MEDICAL_TRAINED

/obj/item/device/defibrillator/compact
	name = "compact defibrillator"
	desc ="This particular defibrillator has halved charge capacity compared to the standard emergency defibrillator, but can fit in your pocket."
	icon_state = "compact_defib"
	item_state = "defib"
	w_class = SIZE_SMALL
	charge_cost = 99
	additional_charge_cost = 1.5
	range = 1

/obj/item/device/defibrillator/upgraded
	name = "upgraded emergency defibrillator"
	icon_state = "defib_adv"
	desc = "An advanced rechargeable defibrillator using induction to deliver shocks through metallic objects, such as armor, and does so with much greater efficiency than the standard variant."

	icon_state_for_paddles = "defib_adv"

	blocked_by_suit = FALSE
	heart_damage_mult = 0.3
	additional_charge_cost = 2.0
	boost_recharge = 0.6
	healing_mult = 1.75
