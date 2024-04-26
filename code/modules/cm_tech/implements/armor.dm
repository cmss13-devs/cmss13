
/obj/item/clothing/accessory/health
	name = "armor plate"
	desc = "A metal trauma plate, able to absorb some blows."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "regular2_100"
	var/base_icon_state = "regular2"

	slot = ACCESSORY_SLOT_ARMOR_C
	var/is_armor = TRUE // is it *armor* or something different & irrelevant and always passes damage & doesnt take damage to itself?
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
	var/percentage = round(armor_health / armor_maxhealth * 100)
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
	return ". [get_damage_status()]"

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
		to_chat(user, SPAN_NOTICE("You use the shards of armor to cobble together an improvised trauma plate."))
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

/obj/item/clothing/accessory/health/research_plate
	name = "Experimental Uniform Attachment"
	desc = "Attachment to the uniform which gives X(this shouldnt be in your handdssss)"
	is_armor = FALSE
	var/obj/item/clothing/attached_uni

/obj/item/clothing/accessory/health/research_plate/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	attached_uni = S

/obj/item/clothing/accessory/health/research_plate/translator
	name = "Exprimental Language Translator"
	desc = "Translates any language heard by the microphones on the plate without any linguistical input, allowing to translate languages never heard before and known languages alike."

/obj/item/clothing/accessory/health/research_plate/translator/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("Translator Buzzes as it begins to listen for input"))
	RegisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED, PROC_REF(on_removed_sig))
	user.universal_understand = TRUE

/obj/item/clothing/accessory/health/research_plate/translator/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()
	if(user.universal_understand)
		to_chat(user, SPAN_NOTICE("Translator makes a sad woop sound as its powering down."))
		user.universal_understand = FALSE
		UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)

/obj/item/clothing/accessory/health/research_plate/translator/proc/on_removed_sig(mob/living/user, slot)
	if(slot == attached_uni && user.universal_understand)
		to_chat(user, SPAN_NOTICE("Plate makes a woop sound as it is powered down."))
		user.universal_understand = FALSE
		UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)

/obj/item/clothing/accessory/health/research_plate/coagulator
	name = "Experimental Blood Coagulator"
	desc = "Stops bleedings by coordinated effort of multiple sensors and radioation emmiters. FDA requires to disclose the radiation is the most potent way to gain tumors, cancer, and death."

/obj/item/clothing/accessory/health/research_plate/coagulator/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	if (user.chem_effect_flags & CHEM_EFFECT_NO_BLEEDING)
		return
	user.chem_effect_flags |= CHEM_EFFECT_NO_BLEEDING
	RegisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED, PROC_REF(on_removed_sig))
	to_chat(user, SPAN_NOTICE("You feel tickling as you activate the coagulator"))

/obj/item/clothing/accessory/health/research_plate/coagulator/on_removed(mob/living/carbon/human/user, obj/item/clothing/C)
	. = ..()
	if (user.chem_effect_flags & CHEM_EFFECT_NO_BLEEDING)
		user.chem_effect_flags &= CHEM_EFFECT_NO_BLEEDING
		to_chat(user, SPAN_NOTICE("You feel coagulator peeling off from your skin."))
		UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)

/obj/item/clothing/accessory/health/research_plate/coagulator/proc/on_removed_sig(mob/living/carbon/human/user, slot)
	if(slot == attached_uni && user.chem_effect_flags & CHEM_EFFECT_NO_BLEEDING )
		to_chat(user, SPAN_NOTICE("You feel coagulator peeling off from your skin."))
		user.chem_effect_flags &= CHEM_EFFECT_NO_BLEEDING
		UnregisterSignal(user, COMSIG_MOB_ITEM_UNEQUIPPED)

/obj/item/clothing/accessory/health/research_plate/emergency_injector
	name = "Emergency Chemical Plate"
	desc = "One-time disposable research plate packing all kinds of chemicals injected at user will by pressing two buttons on the sides simultaniously. The injection is painless, instant and packs more chemicals than your normal emergency injector. Features OD Protection."
	var/od_protection = TRUE
	var/datum/action/item_action/activation
	var/mob/living/wearer
	var/used = FALSE

/obj/item/clothing/accessory/health/research_plate/emergency_injector/get_examine_text(mob/user)
	. = ..()
	. += SPAN_INFO("ALT-Clicking the plate will toggle overdose protection")
	. += SPAN_INFO("Overdose protection seems to be [od_protection ? "on" : "off"]")

/obj/item/clothing/accessory/health/research_plate/emergency_injector/clicked(mob/user, list/mods)
	if(mods["alt"])
		od_protection = !od_protection

/obj/item/clothing/accessory/health/research_plate/emergency_injector/on_attached(obj/item/clothing/S, mob/living/carbon/human/user)
	. = ..()
	wearer = user
	activation = new /datum/action/item_action/emergency_plate/inject_chemicals(src, attached_uni)
	activation.give_to(wearer)

/obj/item/clothing/accessory/health/research_plate/emergency_injector/on_removed(mob/living/user, obj/item/clothing/C)
	. = ..()

/datum/action/item_action/emergency_plate/inject_chemicals/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle Far Sight"
	action_icon_state = "far_sight"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/emergency_plate/inject_chemicals/action_activate()
	. = ..()
	var/obj/item/clothing/accessory/health/research_plate/emergency_injector/inj = holder_item
	to_world(inj.wearer)
	to_world("asdasdasdasdsa")
	if(inj.used)
		return
	inj.wearer.reagents.add_reagent("toxin", 100)

/obj/item/clothing/accessory/health/research_plate/emergency_injector/ui_action_click(mob/owner, obj/item/holder)
	to_world(wearer)
	to_world("asdasdasdasdsa")













