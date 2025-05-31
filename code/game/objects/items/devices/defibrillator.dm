/obj/item/device/defibrillator
	name = "emergency defibrillator"
	desc = "A handheld emergency defibrillator, used to restore fibrillating patients. Can optionally bring people back from the dead."
	icon_state = "defib"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	item_state = "defib"
	icon = 'icons/obj/items/medical_tools.dmi'
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM

	///If target's chest is blocked
	var/blocked_by_suit = TRUE
	/// Min damage defib deals to victims' heart
	var/min_heart_damage_dealt = 3
	/// Max damage defib deals to victims' heart
	var/max_heart_damage_dealt = 5
	var/ready = 0
	var/damage_heal_threshold = 12 //This is the maximum non-oxy damage the defibrillator will heal to get a patient above -100, in all categories
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	var/charge_cost = 66 //How much energy is used.
	var/obj/item/cell/dcell = null
	var/datum/effect_system/spark_spread/sparks = new
	var/defib_cooldown = 0 //Cooldown for toggling the defib
	var/shock_cooldown = 0 //cooldown for shocking someone - separate to toggling
	var/base_icon_state = "defib" //used for overlays of charge

	/// Skill requirements.
	var/skill_to_check = SKILL_MEDICAL
	var/skill_level = SKILL_MEDICAL_MEDIC
	var/skill_to_check_alt = null
	var/skill_level_alt = 0
	/// If the defib can be used by anyone.
	var/noskill = FALSE

	/// If defib should produce visual sparks on revive.
	var/should_spark = TRUE

	/// Used for different descriptions and other fluff text.
	var/fluff_tool = "paddles"
	var/fluff_target_part = "chest"
	var/fluff_revive_message = "Defibrillation successful"

	/// Sound sets for different defibs.
	var/sound_charge = 'sound/items/defib_charge.ogg'
	var/sound_charge_skill4 = 'sound/items/defib_charge_skill4.ogg'
	var/sound_charge_skill3 = 'sound/items/defib_charge_skill3.ogg'
	var/sound_failed = 'sound/items/defib_failed.ogg'
	var/sound_success = 'sound/items/defib_success.ogg'
	var/sound_safety_on = 'sound/items/defib_safetyOn.ogg'
	var/sound_safety_off = 'sound/items/defib_safetyOff.ogg'
	var/sound_release = 'sound/items/defib_release.ogg'

/mob/living/carbon/human/proc/check_tod()
	if(!undefibbable && world.time <= timeofdeath + revive_grace_period)
		return TRUE
	return FALSE

/obj/item/device/defibrillator/Initialize(mapload, ...)
	. = ..()

	if(should_spark)
		sparks.set_up(5, 0, src)
		sparks.attach(src)
	dcell = new/obj/item/cell(src)
	update_icon()

/obj/item/device/defibrillator/Destroy()
	QDEL_NULL(dcell)
	if(should_spark)
		QDEL_NULL(sparks)
	return ..()

/obj/item/device/defibrillator/update_icon()
	icon_state = initial(icon_state)
	overlays.Cut()

	if(ready)
		icon_state += "_out"

	if(dcell && dcell.charge)
		switch(floor(dcell.charge * 100 / dcell.maxcharge))
			if(67 to INFINITY)
				overlays += "+[base_icon_state]full"
			if(34 to 66)
				overlays += "+[base_icon_state]half"
			if(3 to 33)
				overlays += "+[base_icon_state]low"
			if(0 to 3)
				overlays += "+[base_icon_state]empty"
	else
		overlays += "+[base_icon_state]empty"

/obj/item/device/defibrillator/get_examine_text(mob/user)
	. = ..()
	var/maxuses = 0
	var/currentuses = 0
	maxuses = floor(dcell.maxcharge / charge_cost)
	currentuses = floor(dcell.charge / charge_cost)
	if(maxuses != 1)
		. += SPAN_INFO("It has [currentuses] out of [maxuses] uses left in its internal battery.")
	if(MODE_HAS_MODIFIER(/datum/gamemode_modifier/defib_past_armor) || !blocked_by_suit  && !istype(src, /obj/item/device/defibrillator/synthetic))
		. += SPAN_NOTICE("This defibrillator will ignore worn armor.")

/obj/item/device/defibrillator/attack_self(mob/living/carbon/human/user)
	..()

	if(defib_cooldown > world.time) //cooldown only to prevent spam toggling
		return

	//Job knowledge requirement
	if(user.skills && !noskill)
		if(!skillcheck(user, skill_to_check, skill_level))
			if(!skill_to_check_alt || (!skillcheck(user, skill_to_check_alt, skill_level_alt)))
				to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
				return

	defib_cooldown = world.time + 10 //1 second cooldown every time the defib is toggled
	ready = !ready
	user.visible_message(SPAN_NOTICE("[user] turns [src] [ready? "on and takes the [fluff_tool] out" : "off and puts the [fluff_tool] back in"]."),
	SPAN_NOTICE("You turn [src] [ready? "on and take the [fluff_tool] out" : "off and put the [fluff_tool] back in"]."))
	if(should_spark)
		playsound(get_turf(src), "sparks", 15, 1, 0)
	if(ready)
		w_class = SIZE_LARGE
		playsound(get_turf(src), sound_safety_on, 25, 0)
	else
		w_class = initial(w_class)
		playsound(get_turf(src), sound_safety_off, 25, 0)
	update_icon()
	add_fingerprint(user)

/mob/living/carbon/human/proc/get_ghost(check_client = TRUE, check_can_reenter = TRUE)
	if(client)
		return null

	for(var/mob/dead/observer/G in GLOB.observer_list)
		if(G.mind && G.mind.original == src)
			var/mob/dead/observer/ghost = G
			if(ghost && (!check_client || ghost.client) && (!check_can_reenter || ghost.can_reenter_corpse))
				return ghost

/mob/living/carbon/human/proc/is_revivable(ignore_heart = FALSE)
	if(isnull(internal_organs_by_name) || isnull(internal_organs_by_name["heart"]))
		return FALSE
	var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]
	var/obj/limb/head = get_limb("head")

	if(chestburst || !head || head.status & LIMB_DESTROYED || !ignore_heart && (!heart || heart.organ_status >= ORGAN_BROKEN) || !has_brain() || status_flags & PERMANENTLY_DEAD)
		return FALSE
	return TRUE

/obj/item/device/defibrillator/proc/check_revive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!ishuman(H) || isyautja(H))
		to_chat(user, SPAN_WARNING("You can't defibrilate [H]. You don't even know where to put the [fluff_tool]!"))
		return
	if(issynth(H))
		to_chat(user, SPAN_WARNING("You can't defibrilate [H]. You need a synthetic reset key for reboot!"))
		return
	if(!ready)
		balloon_alert(user, "take out the [fluff_tool].")
		to_chat(user, SPAN_WARNING("Take [src]'s [fluff_tool] out first."))
		return
	if(dcell.charge < charge_cost)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src]'s battery is too low! It needs to recharge."))
		return
	if(H.stat != DEAD)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Vital signs detected. Aborting."))
		return

	if(!H.is_revivable())
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Patient's general condition does not allow reviving."))
		return

	if((!MODE_HAS_MODIFIER(/datum/gamemode_modifier/defib_past_armor) && blocked_by_suit) && H.wear_suit && (istype(H.wear_suit, /obj/item/clothing/suit/armor) || istype(H.wear_suit, /obj/item/clothing/suit/storage/marine)) && prob(95))
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Paddles registering >100,000 ohms, Possible cause: Suit or Armor interfering."))
		return

	if(!H.check_tod())
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Patient is braindead."))
		return

	return TRUE

/obj/item/device/defibrillator/proc/can_defib(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(shock_cooldown > world.time) //cooldown is only for shocking, this is so that you can immediately shock when you take the paddles out - stan_albatross
		return FALSE

	shock_cooldown = world.time + 20 //2 second cooldown before you can try shocking again

	if(user.action_busy) //Currently deffibing
		return FALSE

	//job knowledge requirement
	if(user.skills && !noskill)
		if(!skillcheck(user, skill_to_check, skill_level))
			if(!skill_to_check_alt || (!skillcheck(user, skill_to_check_alt, skill_level_alt)))
				to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
				return

	if(!check_revive(target, user))
		return FALSE

	var/mob/dead/observer/G = target.get_ghost()
	if(istype(G) && G.client)
		playsound_client(G.client, 'sound/effects/adminhelp_new.ogg')
		to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Someone is trying to revive your body. Return to it if you want to be resurrected! \
			(Verbs -> Ghost -> Re-enter corpse, or <a href='byond://?src=\ref[G];reentercorpse=1'>click here!</a>)")))

	user.visible_message(SPAN_NOTICE("[user] starts setting up the [fluff_tool] on [target]'s [fluff_target_part]"),
		SPAN_HELPFUL("You start <b>setting up</b> the [fluff_tool] on <b>[target]</b>'s [fluff_target_part]."))
	if(user.get_skill_duration_multiplier(SKILL_MEDICAL) == 0.35)
		playsound(get_turf(src), sound_charge_skill4, 25, 0)
	else if(user.get_skill_duration_multiplier(SKILL_MEDICAL) == 0.75)
		playsound(get_turf(src), sound_charge_skill3, 25, 0)
	else
		playsound(get_turf(src), sound_charge, 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds

	//Taking square root not to make defibs too fast...
	if(!do_after(user, (4 + (3 * user.get_skill_duration_multiplier(SKILL_MEDICAL))) SECONDS, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, target, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		user.visible_message(SPAN_WARNING("[user] stops setting up the [fluff_tool] on [target]'s [fluff_target_part]."),
		SPAN_WARNING("You stop setting up the [fluff_tool] on [target]'s [fluff_target_part]."))
		return FALSE

	if(!check_revive(target, user))
		return FALSE

	return TRUE

/obj/item/device/defibrillator/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	if(!can_defib(target, user))
		return FALSE

	//Do this now, order doesn't matter
	sparks.start()
	dcell.use(charge_cost)
	update_icon()
	playsound(get_turf(src), sound_release, 25, 1)
	user.visible_message(SPAN_NOTICE("[user] shocks [target] with the [fluff_tool]."),
		SPAN_HELPFUL("You shock <b>[target]</b> with the [fluff_tool]."))
	target.visible_message(SPAN_DANGER("[target]'s body convulses a bit."))
	shock_cooldown = world.time + 10 //1 second cooldown before you can shock again

	var/datum/internal_organ/heart/heart = target.internal_organs_by_name["heart"]

	if(!target.is_revivable())
		playsound(get_turf(src), sound_failed, 25, 0)
		if(heart && heart.organ_status >= ORGAN_BROKEN)
			user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's heart is too damaged. Immediate surgery is advised."))
			msg_admin_niche("[key_name_admin(user)] failed an attempt to revive [key_name_admin(target)] with [src] because of heart damage.")
			return
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's general condition does not allow reviving."))
		msg_admin_niche("[key_name_admin(user)] failed an attempt to revive [key_name_admin(target)] with [src].")
		return

	if(!target.client && !(target.status_flags & FAKESOUL)) //Freak case, no client at all. This is a braindead mob (like a colonist)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: No soul detected, Attempting to revive..."))

	if(isobserver(target.mind?.current) && !target.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
		target.mind.transfer_to(target, TRUE)


	//At this point, the defibrillator is ready to work
	target.apply_damage(-damage_heal_threshold, BRUTE)
	target.apply_damage(-damage_heal_threshold, BURN)
	target.apply_damage(-damage_heal_threshold, TOX)
	target.apply_damage(-damage_heal_threshold, CLONE)
	target.apply_damage(-target.getOxyLoss(), OXY)
	target.updatehealth() //Needed for the check to register properly

	if(!(target.species?.flags & NO_CHEM_METABOLIZATION))
		for(var/datum/reagent/R in target.reagents.reagent_list)
			var/datum/chem_property/P = R.get_property(PROPERTY_ELECTROGENETIC)//Adrenaline helps greatly at restarting the heart
			if(P)
				P.trigger(target)
				target.reagents.remove_reagent(R.id, 1)
				break
	if(target.health > HEALTH_THRESHOLD_DEAD)
		user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] \The [src] beeps: [fluff_revive_message]."))
		msg_admin_niche("[key_name_admin(user)] successfully revived [key_name_admin(target)] with [src].")
		playsound(get_turf(src), sound_success, 25, 0)
		user.track_life_saved(user.job)
		if(!user.statistic_exempt && ishuman(target))
			user.life_revives_total++
		target.handle_revive()
		if(heart)
			heart.take_damage(rand(min_heart_damage_dealt, max_heart_damage_dealt), TRUE) // Make death and revival leave lasting consequences

		to_chat(target, SPAN_NOTICE("You suddenly feel a spark and your consciousness returns, dragging you back to the mortal plane."))
		if(target.client?.prefs.toggles_flashing & FLASH_CORPSEREVIVE)
			window_flash(target.client)
	else
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Vital signs are too weak, repair damage and try again.")) //Freak case
		msg_admin_niche("[key_name_admin(user)] failed an attempt to revive [key_name_admin(target)] with [src] because of weak vitals.")
		playsound(get_turf(src), sound_failed, 25, 0)
		if(heart && prob(25))
			heart.take_damage(rand(min_heart_damage_dealt, max_heart_damage_dealt), TRUE) // Make death and revival leave lasting consequences

/obj/item/device/defibrillator/low_charge/Initialize(mapload, ...) //for survivors and such
	. = ..()
	dcell.charge = 100
	update_icon()

/obj/item/device/defibrillator/upgraded
	name = "upgraded emergency defibrillator"
	icon_state = "adv_defib"
	item_state = "adv_defib"
	desc = "An advanced rechargeable defibrillator using induction to deliver shocks through metallic objects, such as armor, and does so with much greater efficiency than the standard variant, not damaging the heart."

	blocked_by_suit = FALSE
	min_heart_damage_dealt = 0
	max_heart_damage_dealt = 0
	damage_heal_threshold = 35

/obj/item/device/defibrillator/compact_adv
	name = "advanced compact defibrillator"
	desc = "An advanced compact defibrillator that trades capacity for strong immediate power. Ignores armor and heals strongly and quickly, at the cost of very low charge. It does not damage the heart."
	icon = 'icons/obj/items/medical_tools.dmi'
	icon_state = "compact_defib"
	item_state = "defib"
	base_icon_state = "compact_defib"
	w_class = SIZE_MEDIUM
	blocked_by_suit = FALSE
	min_heart_damage_dealt = 0
	max_heart_damage_dealt = 0
	damage_heal_threshold = 40
	charge_cost = 198

/obj/item/device/defibrillator/compact
	name = "compact defibrillator"
	desc ="This particular defibrillator has halved charge capacity compared to the standard emergency defibrillator, but can fit in your pocket."
	icon = 'icons/obj/items/medical_tools.dmi'
	icon_state = "compact_defib"
	item_state = "defib"
	base_icon_state = "compact_defib"
	w_class = SIZE_SMALL
	charge_cost = 99


/obj/item/device/defibrillator/synthetic
	name = "W-Y synthetic reset key"
	desc = "Result of collaboration between Hyperdyne and Weyland-Yutani, this device can fix major glitches or programming errors of synthetic units, as well as being able to restart a synthetic that has suffered critical failure. It can only be used once before being reset."
	icon = 'icons/obj/items/synth/synth_reset_key.dmi'
	icon_state = "reset_key"
	item_state = "synth_reset_key"
	w_class = SIZE_SMALL
	charge_cost = 1000
	force = 0
	throwforce = 0
	skill_to_check = SKILL_ENGINEER
	skill_level = SKILL_ENGINEER_NOVICE
	blocked_by_suit = FALSE
	should_spark = FALSE

	var/synthetic_type_locked = null

	fluff_tool = "electrodes"
	fluff_target_part = "insertion port"
	fluff_revive_message = "Reset complete"

	sound_charge = 'sound/mecha/powerup.ogg'
	sound_charge_skill4 = 'sound/mecha/powerup.ogg'
	sound_charge_skill3 = 'sound/mecha/powerup.ogg'
	sound_failed = 'sound/items/synth_reset_key/shortbeep.ogg'
	sound_success = 'sound/items/synth_reset_key/boot_on.ogg'
	sound_safety_on = 'sound/machines/click.ogg'
	sound_safety_off = 'sound/machines/click.ogg'
	sound_release = 'sound/items/synth_reset_key/release.ogg'

/obj/item/device/defibrillator/synthetic/update_icon()
	icon_state = initial(icon_state)
	overlays.Cut()
	if(ready)
		icon_state += "_on"

/obj/item/device/defibrillator/synthetic/get_examine_text(mob/user)
	. = ..()
	if(!noskill)
		. += SPAN_NOTICE("You need some knowledge of electronics and circuitry to use this.")

/obj/item/device/defibrillator/synthetic/check_revive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!issynth(H))
		to_chat(user, SPAN_WARNING("You can't use a [src] on a living being!"))
		return FALSE
	if(!ready)
		balloon_alert(user, "activate it first!")
		to_chat(user, SPAN_WARNING("You need to activate [src] first."))
		return FALSE
	if(synthetic_type_locked && !istype(H.assigned_equipment_preset, synthetic_type_locked))
		to_chat(user, SPAN_WARNING("You can't use [src] on this type of synthetic!"))
		return FALSE
	if(dcell.charge < charge_cost)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] has already been used! It needs to be recharged."))
		return FALSE
	if(H.stat != DEAD)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Function signs detected. Aborting."))
		return FALSE

	if(!H.is_revivable())
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Unit's general condition does not allow reactivation."))
		return FALSE

	return TRUE

/obj/item/device/defibrillator/synthetic/noskill
	name = "SMART W-Y synthetic reset key"
	desc = "Result of collaboration between Hyperdyne and Weyland-Yutani, this device can fix major glitches or programming errors of synthetic units, as well as being able to restart a synthetic that has suffered critical failure. It can only be used once before being reset. This one has a microfunction AI and can be operated by anyone."
	icon_state = "reset_key_ns"
	noskill = TRUE

/obj/item/device/defibrillator/synthetic/hyperdyne
	name = "Hyperdyne synthetic reset key"
	desc = "An independant Hyperdyne design, based on a previous collaboration with Weyland-Yutani, this device can fix major glitches or programming errors of synthetic units, as well as being able to restart a synthetic that has suffered critical failure. It can only be used once before being reset."
	icon_state = "hyper_reset_key"

/obj/item/device/defibrillator/synthetic/hyperdyne/noskill
	name = "SMART Hyperdyne synthetic reset key"
	desc = "An independant Hyperdyne design, based on a previous collaboration with Weyland-Yutani, this device can fix major glitches or programming errors of synthetic units, as well as being able to restart a synthetic that has suffered critical failure. It can only be used once before being reset. This one has a microfunction AI and can be operated by anyone."
	icon_state = "hyper_reset_ns_key"
	noskill = TRUE

/obj/item/device/defibrillator/synthetic/seegson
	name = "Seegson Working Joe reboot key"
	desc = "Seegson tool required in a repair of Working Joe units that suffered critical failures, reboots unit system to a factory settings. Isn't compatible with sythetics of Hyperdyne, Weyland-Yutani and other designs. It can only be used once before being reset."
	icon_state = "seeg_reset_key"
	sound_success = 'sound/items/synth_reset_key/seegson_revive.ogg'
	synthetic_type_locked = /datum/equipment_preset/synth/working_joe

/obj/item/device/defibrillator/synthetic/makeshift
	name = "makeshift synthetic sparker"
	desc = "A tool resembling a synthetic reset key, but extremely crude and made from spare parts, only capable of rebooting the system of a synthetic, with a small chance of corrupting that system. It can only be used once before being reset."
	icon_state = "makeshift_key"
	should_spark = TRUE
	sound_success = "sparks"
