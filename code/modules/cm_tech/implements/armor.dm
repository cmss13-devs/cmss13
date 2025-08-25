
/obj/item/clothing/accessory/health
	name = "armor plate"
	desc = "A metal trauma plate, able to absorb some blows."
	icon = 'icons/obj/items/ceramic_plates.dmi'
	icon_state = "regular2_100"
	var/base_icon_state = "regular2"

	worn_accessory_slot = ACCESSORY_SLOT_ARMOR_C
	w_class = SIZE_MEDIUM
	/// is it *armor* or something different & irrelevant and always passes damage & doesnt take damage to itself?
	var/is_armor = TRUE
	var/armor_health = 10
	var/armor_maxhealth = 10
	var/take_slash_damage = TRUE
	var/slash_durability_mult = 0.25
	var/FF_projectile_durability_mult = 0.1
	var/hostile_projectile_durability_mult = 1

	var/list/health_states = list(
		0,
		50,
		100
	)

	var/scrappable = TRUE
	var/armor_hitsound = 'sound/effects/metalhit.ogg'
	var/armor_shattersound = 'sound/effects/metal_shatter.ogg'

/obj/item/clothing/accessory/health/update_icon()
	for(var/health_state in health_states)
		if(armor_health / armor_maxhealth * 100 <= health_state)
			icon_state = "[base_icon_state]_[health_state]"
			return

/obj/item/clothing/accessory/health/proc/get_damage_status()
	var/percentage = floor(armor_health / armor_maxhealth * 100)
	switch(percentage)
		if(0)
			. = "It is broken."
			if(scrappable)
				. += " If you had two, you could repair it."
		if(1 to 19)
			. = "It is crumbling apart!"
		if(20 to 49)
			. = "It is seriously damaged."
		if(50 to 79)
			. = "It is moderately damaged."
		if(80 to 99)
			. = "It is slightly damaged."
		else
			. = "It is in pristine condition."

/obj/item/clothing/accessory/health/get_examine_text(mob/user)
	. = ..()
	. += "To use it, attach it to your uniform."
	. += SPAN_NOTICE(get_damage_status())

/obj/item/clothing/accessory/health/additional_examine_text()
	. = ..()

	. += "[get_damage_status()]"

/obj/item/clothing/accessory/health/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	if(.)
		RegisterSignal(S, COMSIG_ITEM_EQUIPPED, PROC_REF(check_to_signal))
		RegisterSignal(S, COMSIG_ITEM_DROPPED, PROC_REF(unassign_signals))

		if(istype(user) && user.w_uniform == S)
			check_to_signal(S, user, WEAR_BODY)

/obj/item/clothing/accessory/health/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(.)
		unassign_signals(C, user)
		UnregisterSignal(C, list(
			COMSIG_ITEM_EQUIPPED,
			COMSIG_ITEM_DROPPED
		))

/obj/item/clothing/accessory/health/proc/check_to_signal(obj/item/clothing/S, mob/living/user, slot)
	SIGNAL_HANDLER

	if(slot == WEAR_BODY)
		if(take_slash_damage)
			RegisterSignal(user, COMSIG_HUMAN_XENO_ATTACK, PROC_REF(take_slash_damage))
		RegisterSignal(user, COMSIG_HUMAN_BULLET_ACT, PROC_REF(take_bullet_damage))
	else
		unassign_signals(S, user)

/obj/item/clothing/accessory/health/proc/unassign_signals(obj/item/clothing/S, mob/living/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, list(
		COMSIG_HUMAN_XENO_ATTACK,
		COMSIG_HUMAN_BULLET_ACT
	))

/obj/item/clothing/accessory/health/proc/take_bullet_damage(mob/living/carbon/human/user, damage, ammo_flags, obj/projectile/P)
	SIGNAL_HANDLER
	if(damage <= 0 || (ammo_flags & AMMO_IGNORE_ARMOR))
		return
	if(!is_armor)
		return
	var/damage_to_nullify = armor_health
	var/final_proj_mult = FF_projectile_durability_mult

	var/mob/living/carbon/human/pfirer = P.firer
	if(user.faction != pfirer.faction)
		final_proj_mult = hostile_projectile_durability_mult
	armor_health = max(armor_health - damage*final_proj_mult, 0)

	update_icon()
	if(!armor_health && damage_to_nullify)
		user.show_message(SPAN_WARNING("You feel [src] break apart."), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		playsound(user, armor_shattersound, 35, TRUE)

	if(damage_to_nullify)
		playsound(user, armor_hitsound, 25, TRUE)
		P.play_hit_effect(user)
		return COMPONENT_CANCEL_BULLET_ACT

/obj/item/clothing/accessory/health/proc/take_slash_damage(mob/living/user, list/slashdata)
	SIGNAL_HANDLER
	if(!is_armor)
		return
	var/armor_damage = slashdata["n_damage"]
	var/damage_to_nullify = armor_health
	armor_health = max(armor_health - armor_damage*slash_durability_mult, 0)

	update_icon()
	if(!armor_health && damage_to_nullify)
		user.show_message(SPAN_WARNING("You feel [src] break apart."), null, null, null, CHAT_TYPE_ARMOR_DAMAGE)
		playsound(user, armor_shattersound, 50, TRUE)

	if(damage_to_nullify)
		slashdata["n_damage"] = 0
		slashdata["slash_noise"] = armor_hitsound

/obj/item/clothing/accessory/health/attackby(obj/item/clothing/accessory/health/I, mob/user)
	if(!istype(I, src.type) || !scrappable || has_suit || I.has_suit || !is_armor)
		return

	if(!I.armor_health && !armor_health)
		to_chat(user, SPAN_NOTICE("You use the shards of armor to cobble together an improvised ceramic plate."))
		qdel(I)
		qdel(src)
		user.put_in_active_hand(new /obj/item/clothing/accessory/health/scrap())


/obj/item/clothing/accessory/health/ceramic_plate
	name = "ceramic plate"
	desc = "A strong trauma plate, able to protect the user from a large amount of bullets. Ineffective against sharp objects."
	icon_state = "ceramic2_100"
	base_icon_state = "ceramic2"

	take_slash_damage = FALSE
	scrappable = FALSE
	FF_projectile_durability_mult = 0.3

	armor_health = 100
	armor_maxhealth = 100

	armor_shattersound = 'sound/effects/ceramic_shatter.ogg'

/obj/item/clothing/accessory/health/ceramic_plate/take_bullet_damage(mob/living/user, damage, ammo_flags)
	if(ammo_flags & AMMO_ACIDIC)
		return

	return ..()

/obj/item/clothing/accessory/health/ceramic_plate/take_slash_damage(mob/living/user, list/slashdata)
	return

/obj/item/clothing/accessory/health/scrap
	name = "scrap metal"
	desc = "A weak armor plate, only able to protect from a little bit of damage. Perhaps that will be enough."
	icon_state = "scrap_100"
	base_icon_state = "scrap"
	health_states = list(
		0,
		100,
	)

	scrappable = FALSE

	armor_health = 7.5
	armor_maxhealth = 7.5

/obj/item/clothing/accessory/health/scrap/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(. && !armor_health)
		qdel(src)

/obj/item/clothing/accessory/health/scrap/take_bullet_damage(mob/living/user, damage, ammo_flags)
	if(ammo_flags & AMMO_ACIDIC)
		return

	return ..()

/obj/item/clothing/accessory/health/scrap/take_slash_damage(mob/living/user, list/slashdata)
	return

/obj/item/clothing/accessory/health/research_plate
	name = "experimental uniform attachment"
	desc = "Attachment to the uniform which gives X (this shouldn't be in your handdssss)"
	is_armor = FALSE
	icon_state = "plate_research"
	icon = 'icons/obj/items/devices.dmi'
	ground_offset_x = 8
	ground_offset_y = 8
	var/obj/item/clothing/attached_uni
	///can the plate be recycled after X condition? 0 means it cannot be recycled, otherwise put in the biomass points to refund.
	var/recyclable_value = 0

/obj/item/clothing/accessory/health/research_plate/Destroy()
	attached_uni = null
	. = ..()

/obj/item/clothing/accessory/health/research_plate/on_attached(obj/item/clothing/attached_to, mob/living/carbon/human/user)
	. = ..()
	attached_uni = attached_to
	RegisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED, PROC_REF(on_removed_sig))

/obj/item/clothing/accessory/health/research_plate/proc/can_recycle(mob/living/user) //override this proc for check if you can recycle the plate.
	return FALSE

/obj/item/clothing/accessory/health/research_plate/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)

/obj/item/clothing/accessory/health/research_plate/proc/on_removed_sig(mob/living/user, slot)
	SIGNAL_HANDLER
	if(slot != attached_uni)
		return FALSE
	UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)
	return TRUE

/obj/item/clothing/accessory/health/research_plate/translator
	name = "experimental language translator"
	desc = "Translates any language heard by the microphones on the plate without any linguistical input, allowing to translate languages never heard before and known languages alike."

/obj/item/clothing/accessory/health/research_plate/translator/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("[src] buzzes as it begins to listen for input."))
	user.universal_understand = TRUE

/obj/item/clothing/accessory/health/research_plate/translator/on_removed(mob/living/carbon/human/user, obj/item/clothing/C)
	. = ..()
	if(user.universal_understand)
		to_chat(user, SPAN_NOTICE("[src] makes a sad woop sound as it powers down."))
		attached_uni = null
		if(user.chem_effect_flags & CHEM_EFFECT_HYPER_THROTTLE) // we are currently under effect of simular univeral understand drug.
			return
		user.universal_understand = FALSE

/obj/item/clothing/accessory/health/research_plate/translator/on_removed_sig(mob/living/carbon/human/user, slot)
	. = ..()
	if(. == FALSE)
		return
	if(user.universal_understand)
		to_chat(user, SPAN_NOTICE("[src] makes a woop sound as it is powered down."))
		if(user.chem_effect_flags & CHEM_EFFECT_HYPER_THROTTLE) // we are currently under effect of simular univeral understand drug.
			return
		attached_uni = null
		user.universal_understand = FALSE

/obj/item/clothing/accessory/health/research_plate/coagulator
	name = "experimental blood coagulator"
	desc = "A device that encourages clotting through the coordinated effort of multiple sensors and radiation emitters. The Surgeon General warns that continuous exposure to radiation may be hazardous to your health."

/obj/item/clothing/accessory/health/research_plate/coagulator/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	RegisterSignal(user, COMSIG_BLEEDING_PROCESS, PROC_REF(cancel_bleeding))
	to_chat(user, SPAN_NOTICE("You feel tickling as you activate [src]."))

/obj/item/clothing/accessory/health/research_plate/coagulator/proc/cancel_bleeding()
	SIGNAL_HANDLER
	return COMPONENT_BLEEDING_CANCEL

/obj/item/clothing/accessory/health/research_plate/coagulator/on_removed(mob/living/carbon/human/user, obj/item/clothing/C)
	. = ..()
	to_chat(user, SPAN_NOTICE("You feel [src] peeling off from your skin."))
	UnregisterSignal(user, COMSIG_BLEEDING_PROCESS)
	attached_uni = null

/obj/item/clothing/accessory/health/research_plate/coagulator/on_removed_sig(mob/living/carbon/human/user, slot)
	. = ..()
	if(. == FALSE)
		return
	UnregisterSignal(user, COMSIG_BLEEDING_PROCESS)
	attached_uni = null

/obj/item/clothing/accessory/health/research_plate/emergency_injector
	name = "emergency chemical plate"
	desc = "One-time disposable research plate packing all kinds of chemicals injected at the will of the user by pressing two buttons on the sides simultaneously. The injection is painless, instant and packs much more chemicals than your normal emergency injector. Features OD Protection in three modes."
	var/od_protection_mode = EMERGENCY_PLATE_OD_PROTECTION_DYNAMIC
	var/datum/action/item_action/activation
	var/mob/living/wearer
	var/used = FALSE
	/// 1 means the player overdosed with OD_OFF mode. 2 means the plate adjusted the chemicals injected.
	var/warning_type = FALSE
	var/list/chemicals_to_inject = list(
		"oxycodone" = 20,
		"bicaridine" = 30,
		"kelotane" = 30,
		"meralyne" = 15,
		"dermaline" = 15,
		"dexalinp" = 1,
		"inaprovaline" = 30,
	)
	recyclable_value = 100

/obj/item/clothing/accessory/health/research_plate/emergency_injector/Destroy()
	wearer = null
	if(!QDELETED(activation))
		QDEL_NULL(activation)
	. = ..()

/obj/item/clothing/accessory/health/research_plate/emergency_injector/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("ALT-Clicking the plate will toggle overdose protection")
	. += SPAN_INFO("Overdose protection seems to be [od_protection_mode == 1 ? "ON" : od_protection_mode == 2 ? "DYNAMIC" : "OFF"]")
	if(used)
		. += SPAN_WARNING("It is already used!")

/obj/item/clothing/accessory/health/research_plate/emergency_injector/clicked(mob/user, list/mods)
	. = ..()
	if(mods[ALT_CLICK])
		var/text = "You toggle overdose protection "
		if(od_protection_mode == EMERGENCY_PLATE_OD_PROTECTION_DYNAMIC)
			od_protection_mode = EMERGENCY_PLATE_OD_PROTECTION_OFF
			text += "to OVERRIDE. Overdose protection is now offline."
		else
			od_protection_mode++
			if(od_protection_mode == EMERGENCY_PLATE_OD_PROTECTION_DYNAMIC)
				text += "to DYNAMIC. Overdose subsystems will inject chemicals but will not go above overdose levels."
			else
				text += "to STRICT. Overdose subsystems will refuse to inject if any of chemicals will overdose."
		to_chat(user, SPAN_NOTICE(text))
		return TRUE
	return

/obj/item/clothing/accessory/health/research_plate/emergency_injector/can_recycle(mob/living/user)
	if(used)
		return TRUE
	return FALSE

/obj/item/clothing/accessory/health/research_plate/emergency_injector/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	wearer = user
	activation = new /datum/action/item_action/toggle/emergency_plate/inject_chemicals(src, attached_uni)
	activation.give_to(wearer)

/obj/item/clothing/accessory/health/research_plate/emergency_injector/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	QDEL_NULL(activation)
	attached_uni = null

/obj/item/clothing/accessory/health/research_plate/emergency_injector/on_removed_sig(mob/living/carbon/human/user, slot)
	. = ..()
	if(. == FALSE)
		return
	QDEL_NULL(activation)
	attached_uni = null

//Action buttons
/datum/action/item_action/toggle/emergency_plate/inject_chemicals/New(Target, obj/item/holder)
	. = ..()
	name = "Inject Emergency Plate"
	action_icon_state = "plate_research"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/obj/items/devices.dmi', button, action_icon_state)

/obj/item/clothing/accessory/health/research_plate/emergency_injector/ui_action_click(mob/owner, obj/item/holder)
	if(used)
		to_chat(wearer, SPAN_DANGER("[src]'s inner reserve is empty, replace the plate!"))
		return
	for(var/chemical in chemicals_to_inject)
		var/datum/reagent/reag = GLOB.chemical_reagents_list[chemical]
		if(wearer.reagents.get_reagent_amount(chemical) + chemicals_to_inject[chemical] > reag.overdose)
			if(od_protection_mode == EMERGENCY_PLATE_OD_PROTECTION_STRICT)
				to_chat(wearer, SPAN_DANGER("You hold the two buttons, but the plate buzzes and refuses to inject, indicating the potential overdose!"))
				return
			if (od_protection_mode == EMERGENCY_PLATE_OD_PROTECTION_DYNAMIC)
				var/adjust_volume_to_inject = reag.overdose - wearer.reagents.get_reagent_amount(chemical)
				chemicals_to_inject[chemical] = adjust_volume_to_inject
				warning_type = EMERGENCY_PLATE_ADJUSTED_WARNING
		if(wearer.reagents.get_reagent_amount(chemical) + chemicals_to_inject[chemical] > reag.overdose && od_protection_mode == EMERGENCY_PLATE_OD_PROTECTION_OFF)
			warning_type = EMERGENCY_PLATE_OD_WARNING
		wearer.reagents.add_reagent(chemical, chemicals_to_inject[chemical])
	if(warning_type == EMERGENCY_PLATE_OD_WARNING)
		to_chat(wearer, SPAN_DANGER("You hold the two buttons, and the plate injects the chemicals, but makes a worrying beep, indicating overdose!"))
	if(warning_type == EMERGENCY_PLATE_ADJUSTED_WARNING)
		to_chat(wearer, SPAN_DANGER("You hold the two buttons, and the plate injects the chemicals, but makes a relieving beep, indicating it adjusted amounts it injected to prevent overdose!"))
	playsound(loc, "sound/items/air_release.ogg", 100, TRUE)
	used = TRUE

/obj/item/clothing/accessory/health/research_plate/anti_decay
	name = "experimental preservation plate"
	desc = "preservation plate which activates once the user is dead, uses variety of different substances and sensors to slow down the decay and increase the time before the user is permanently dead to around 9 minutes instead of 5"
	var/mob/living/carbon/human/wearer


/obj/item/clothing/accessory/health/research_plate/anti_decay/Destroy()
	. = ..()
	wearer = null

/obj/item/clothing/accessory/health/research_plate/anti_decay/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	wearer = user
	RegisterSignal(user, COMSIG_MOB_DEATH, PROC_REF(begin_preserving))
	user.revive_grace_period += 4 MINUTES

/obj/item/clothing/accessory/health/research_plate/anti_decay/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	wearer = null
	attached_uni = null

/obj/item/clothing/accessory/health/research_plate/anti_decay/on_removed_sig(mob/living/user, slot)
	. = ..()
	if(. == FALSE)
		return
	wearer = null
	attached_uni = null

/obj/item/clothing/accessory/health/research_plate/anti_decay/proc/begin_preserving()
	SIGNAL_HANDLER
	UnregisterSignal(wearer, COMSIG_MOB_DEATH)
	to_chat(wearer, SPAN_NOTICE("The [src] detects your death and starts injecting various chemicals to slow down your final demise!"))
	RegisterSignal(wearer, COMSIG_HUMAN_REVIVED, PROC_REF(reset_use))

/obj/item/clothing/accessory/health/research_plate/anti_decay/proc/reset_use()
	SIGNAL_HANDLER
	UnregisterSignal(wearer, COMSIG_HUMAN_REVIVED)
	to_chat(wearer, SPAN_NOTICE("[icon2html(src, viewers(src))] \The <b>[src]</b> beeps: Registering user life signs, halting preservation efforts"))
	wearer.revive_grace_period = 9 MINUTES







