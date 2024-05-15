/obj/item/device/defibrillator
	name = "emergency defibrillator"
	desc = "A handheld emergency defibrillator, used to restore fibrillating patients. Can optionally bring people back from the dead."
	icon_state = "defib"
	item_state = "defib"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM

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

/mob/living/carbon/human/proc/check_tod()
	if(!undefibbable && world.time <= timeofdeath + revive_grace_period)
		return TRUE
	return FALSE

/obj/item/device/defibrillator/Initialize(mapload, ...)
	. = ..()

	sparks.set_up(5, 0, src)
	sparks.attach(src)
	dcell = new/obj/item/cell(src)
	update_icon()

/obj/item/device/defibrillator/Destroy()
	QDEL_NULL(dcell)
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
				overlays += "+full"
			if(34 to 66)
				overlays += "+half"
			if(3 to 33)
				overlays += "+low"
			if(0 to 3)
				overlays += "+empty"
	else
		overlays += "+empty"

/obj/item/device/defibrillator/get_examine_text(mob/user)
	. = ..()
	var/maxuses = 0
	var/currentuses = 0
	maxuses = floor(dcell.maxcharge / charge_cost)
	currentuses = floor(dcell.charge / charge_cost)
	. += SPAN_INFO("It has [currentuses] out of [maxuses] uses left in its internal battery.")
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_STRONG_DEFIBS) || !blocked_by_suit)
		. += SPAN_NOTICE("This defibrillator will ignore worn armor.")

/obj/item/device/defibrillator/attack_self(mob/living/carbon/human/user)
	..()

	if(defib_cooldown > world.time) //cooldown only to prevent spam toggling
		return

	//Job knowledge requirement
	if (istype(user))
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return

	defib_cooldown = world.time + 10 //1 second cooldown every time the defib is toggled
	ready = !ready
	user.visible_message(SPAN_NOTICE("[user] turns [src] [ready? "on and takes the paddles out" : "off and puts the paddles back in"]."),
	SPAN_NOTICE("You turn [src] [ready? "on and take the paddles out" : "off and put the paddles back in"]."))
	playsound(get_turf(src), "sparks", 15, 1, 0)
	if(ready)
		w_class = SIZE_LARGE
		playsound(get_turf(src), 'sound/items/defib_safetyOn.ogg', 25, 0)
	else
		w_class = initial(w_class)
		playsound(get_turf(src), 'sound/items/defib_safetyOff.ogg', 25, 0)
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

/mob/living/carbon/human/proc/is_revivable()
	if(isnull(internal_organs_by_name) || isnull(internal_organs_by_name["heart"]))
		return FALSE
	var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]
	var/obj/limb/head = get_limb("head")

	if(chestburst || !head || head.status & LIMB_DESTROYED || !heart || heart.organ_status >= ORGAN_BROKEN || !has_brain() || status_flags & PERMANENTLY_DEAD)
		return FALSE
	return TRUE

/obj/item/device/defibrillator/proc/check_revive(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(!ishuman(H) || isyautja(H))
		to_chat(user, SPAN_WARNING("You can't defibrilate [H]. You don't even know where to put the paddles!"))
		return
	if(!ready)
		to_chat(user, SPAN_WARNING("Take [src]'s paddles out first."))
		return
	if(dcell.charge <= charge_cost)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src]'s battery is too low! It needs to recharge."))
		return
	if(H.stat != DEAD)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Vital signs detected. Aborting."))
		return

	if(!H.is_revivable())
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Patient's general condition does not allow reviving."))
		return

	if((!MODE_HAS_TOGGLEABLE_FLAG(MODE_STRONG_DEFIBS) && blocked_by_suit) && H.wear_suit && (istype(H.wear_suit, /obj/item/clothing/suit/armor) || istype(H.wear_suit, /obj/item/clothing/suit/storage/marine)) && prob(95))
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Paddles registering >100,000 ohms, Possible cause: Suit or Armor interfering."))
		return

	if((!H.check_tod() && !issynth(H))) //synthetic species have no expiration date
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Patient is braindead."))
		return

	return TRUE

/obj/item/device/defibrillator/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)
	if(shock_cooldown > world.time) //cooldown is only for shocking, this is so that you can immediately shock when you take the paddles out - stan_albatross
		return

	shock_cooldown = world.time + 20 //2 second cooldown before you can try shocking again

	if(user.action_busy) //Currently deffibing
		return

	//job knowledge requirement
	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return

	if(!check_revive(H, user))
		return

	var/mob/dead/observer/G = H.get_ghost()
	if(istype(G) && G.client)
		playsound_client(G.client, 'sound/effects/adminhelp_new.ogg')
		to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Someone is trying to revive your body. Return to it if you want to be resurrected! \
			(Verbs -> Ghost -> Re-enter corpse, or <a href='?src=\ref[G];reentercorpse=1'>click here!</a>)")))

	user.visible_message(SPAN_NOTICE("[user] starts setting up the paddles on [H]'s chest"), \
		SPAN_HELPFUL("You start <b>setting up</b> the paddles on <b>[H]</b>'s chest."))
	playsound(get_turf(src),'sound/items/defib_charge.ogg', 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds

	//Taking square root not to make defibs too fast...
	if(!do_after(user, (4 + (3 * user.get_skill_duration_multiplier(SKILL_MEDICAL))) SECONDS, INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, H, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
		user.visible_message(SPAN_WARNING("[user] stops setting up the paddles on [H]'s chest."), \
		SPAN_WARNING("You stop setting up the paddles on [H]'s chest."))
		return

	if(!check_revive(H, user))
		return

	//Do this now, order doesn't matter
	sparks.start()
	dcell.use(charge_cost)
	update_icon()
	playsound(get_turf(src), 'sound/items/defib_release.ogg', 25, 1)
	user.visible_message(SPAN_NOTICE("[user] shocks [H] with the paddles."),
		SPAN_HELPFUL("You shock <b>[H]</b> with the paddles."))
	H.visible_message(SPAN_DANGER("[H]'s body convulses a bit."))
	shock_cooldown = world.time + 10 //1 second cooldown before you can shock again

	var/datum/internal_organ/heart/heart = H.internal_organs_by_name["heart"]

	if(!H.is_revivable())
		playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
		if(heart && heart.organ_status >= ORGAN_BROKEN)
			user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's heart is too damaged. Immediate surgery is advised."))
			return
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's general condition does not allow reviving."))
		return

	if(!H.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: No soul detected, Attempting to revive..."))

	if(isobserver(H.mind?.current) && !H.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
		H.mind.transfer_to(H, TRUE)


	//At this point, the defibrillator is ready to work
	H.apply_damage(-damage_heal_threshold, BRUTE)
	H.apply_damage(-damage_heal_threshold, BURN)
	H.apply_damage(-damage_heal_threshold, TOX)
	H.apply_damage(-damage_heal_threshold, CLONE)
	H.apply_damage(-H.getOxyLoss(), OXY)
	H.updatehealth() //Needed for the check to register properly

	if(!(H.species?.flags & NO_CHEM_METABOLIZATION))
		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/datum/chem_property/P = R.get_property(PROPERTY_ELECTROGENETIC)//Adrenaline helps greatly at restarting the heart
			if(P)
				P.trigger(H)
				H.reagents.remove_reagent(R.id, 1)
				break
	if(H.health > HEALTH_THRESHOLD_DEAD)
		user.visible_message(SPAN_NOTICE("[icon2html(src, viewers(src))] \The [src] beeps: Defibrillation successful."))
		playsound(get_turf(src), 'sound/items/defib_success.ogg', 25, 0)
		user.track_life_saved(user.job)
		user.life_revives_total++
		H.handle_revive()
		if(heart)
			heart.take_damage(rand(min_heart_damage_dealt, max_heart_damage_dealt), TRUE) // Make death and revival leave lasting consequences

		to_chat(H, SPAN_NOTICE("You suddenly feel a spark and your consciousness returns, dragging you back to the mortal plane."))
		if(H.client?.prefs.toggles_flashing & FLASH_CORPSEREVIVE)
			window_flash(H.client)
	else
		user.visible_message(SPAN_WARNING("[icon2html(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Vital signs are too weak, repair damage and try again.")) //Freak case
		playsound(get_turf(src), 'sound/items/defib_failed.ogg', 25, 0)
		if(heart && prob(25))
			heart.take_damage(rand(min_heart_damage_dealt, max_heart_damage_dealt), TRUE) // Make death and revival leave lasting consequences

/obj/item/device/defibrillator/compact_adv
	name = "advanced compact defibrillator"
	desc = "An advanced compact defibrillator that trades capacity for strong immediate power. Ignores armor and heals strongly and quickly, at the cost of very low charge. It does not damage the heart."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "compact_defib"
	item_state = "defib"
	w_class = SIZE_MEDIUM
	blocked_by_suit = FALSE
	min_heart_damage_dealt = 0
	max_heart_damage_dealt = 0
	damage_heal_threshold = 40
	charge_cost = 198

/obj/item/device/defibrillator/compact
	name = "compact defibrillator"
	desc ="This particular defibrillator has halved charge capacity compared to the standard emergency defibrillator, but can fit in your pocket."
	icon = 'icons/obj/items/experimental_tools.dmi'
	icon_state = "compact_defib"
	item_state = "defib"
	w_class = SIZE_SMALL
	charge_cost = 99
