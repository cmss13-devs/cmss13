/obj/item/device/defibrillator
	name = "emergency defibrillator"
	desc = "A handheld emergency defibrillator, used to restore fibrillating patients. Can optionally bring people back from the dead."
	icon_state = "defib_full"
	item_state = "defib"
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON
	flags_equip_slot = SLOT_WAIST
	force = 5
	throwforce = 5
	w_class = SIZE_MEDIUM

	var/ready = 0
	var/damage_threshold = 12 //This is the maximum non-oxy damage the defibrillator will heal to get a patient above -100, in all categories
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	var/charge_cost = 66 //How much energy is used.
	var/obj/item/cell/dcell = null
	var/datum/effect_system/spark_spread/sparks = new
	var/defib_cooldown = 0 //Cooldown for toggling the defib
	
/mob/living/carbon/human/proc/check_tod()
	if(!undefibbable && world.time <= timeofdeath + revive_grace_period)
		return TRUE
	return FALSE

/obj/item/device/defibrillator/New()
	. = ..()
	sparks.set_up(5, 0, src)
	sparks.attach(src)
	dcell = new/obj/item/cell(src)
	update_icon()

/obj/item/device/defibrillator/update_icon()
	icon_state = "defib"
	if(ready)
		icon_state += "_out"
	if(dcell && dcell.charge)
		switch(round(dcell.charge * 100 / dcell.maxcharge))
			if(67 to INFINITY)
				icon_state += "_full"
			if(34 to 66)
				icon_state += "_half"
			if(1 to 33)
				icon_state += "_low"
	else
		icon_state += "_empty"

/obj/item/device/defibrillator/examine(mob/user)
	..()
	var/maxuses = 0
	var/currentuses = 0
	maxuses = round(dcell.maxcharge / charge_cost)
	currentuses = round(dcell.charge / charge_cost)
	to_chat(user, SPAN_INFO("It has [currentuses] out of [maxuses] uses left in its internal battery."))


/obj/item/device/defibrillator/attack_self(mob/living/carbon/human/user)

	if(defib_cooldown > world.time)
		return

	//Job knowledge requirement
	if (istype(user))
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return

	defib_cooldown = world.time + 20 //2 seconds cooldown every time the defib is toggled
	ready = !ready
	user.visible_message(SPAN_NOTICE("[user] turns [src] [ready? "on and takes the paddles out" : "off and puts the paddles back in"]."),
	SPAN_NOTICE("You turn [src] [ready? "on and take the paddles out" : "off and put the paddles back in"]."))
	playsound(get_turf(src), "sparks", 25, 1, 4)
	update_icon()
	add_fingerprint(user)

/mob/living/carbon/human/proc/get_ghost()
	if(client)
		return FALSE

	for(var/mob/dead/observer/G in player_list)
		if(G.mind && G.mind.original == src)
			var/mob/dead/observer/ghost = G
			if(ghost && ghost.client && ghost.can_reenter_corpse)
				return ghost

/mob/living/carbon/human/proc/is_revivable()
	if(isnull(internal_organs_by_name) || isnull(internal_organs_by_name["heart"]))
		return FALSE
	var/datum/internal_organ/heart/heart = internal_organs_by_name["heart"]

	if(!get_limb("head") || !heart || heart.is_broken() || !has_brain() || chestburst || status_flags & PERMANENTLY_DEAD)
		return FALSE
	return TRUE

/obj/item/device/defibrillator/attack(mob/living/carbon/human/H, mob/living/carbon/human/user)

	if(defib_cooldown > world.time) //Both for pulling the paddles out (2 seconds) and shocking (1 second)
		return
	defib_cooldown = world.time + 20 //2 second cooldown before you can try shocking again

	if(user.action_busy) //Currently deffibing
		return

	//job knowledge requirement
	if(user.skills)
		if(!skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
			to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
			return

	if(!ishuman(H) || isYautja(H))
		to_chat(user, SPAN_WARNING("You can't defibrilate [H]. You don't even know where to put the paddles!"))
		return
	if(!ready)
		to_chat(user, SPAN_WARNING("Take [src]'s paddles out first."))
		return
	if(dcell.charge <= charge_cost)
		user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Internal battery depleted. Cannot analyze nor administer shock."))
		return
	if(H.stat != DEAD)
		user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Vital signs detected. Aborting."))
		return

	if(!H.is_revivable())
		user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Patient's general condition does not allow reviving."))
		return

	if(H.wear_suit && (istype(H.wear_suit, /obj/item/clothing/suit/armor) || istype(H.wear_suit, /obj/item/clothing/suit/storage/marine)) && prob(95))
		user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Paddles registering >100,000 ohms, Possible cause: Suit or Armor interferring."))
		return

	if((!H.check_tod() && !isSynth(H))) //synthetic species have no expiration date
		user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Patient is braindead."))
		return

	var/mob/dead/observer/G = H.get_ghost()
	if(istype(G))
		G << 'sound/effects/adminhelp_new.ogg'
		to_chat(G, SPAN_BOLDNOTICE(FONT_SIZE_LARGE("Someone is trying to revive your body. Return to it if you want to be resurrected! \
			(Verbs -> Ghost -> Re-enter corpse, or <a href='?src=\ref[G];reentercorpse=1'>click here!</a>)")))
	else if(!H.client)
		//We couldn't find a suitable ghost, this means the person is not returning
		user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Patient has a DNR."))
		return

	user.visible_message(SPAN_NOTICE("[user] starts setting up the paddles on [H]'s chest"), \
		SPAN_HELPFUL("You start <b>setting up</b> the paddles on <b>[H]</b>'s chest."))
	playsound(get_turf(src),'sound/items/defib_charge.ogg', 25, 0) //Do NOT vary this tune, it needs to be precisely 7 seconds

	//Taking square root not to make defibs too fast...
	if(do_after(user, 70 * sqrt(user.get_skill_duration_multiplier(SKILL_MEDICAL)), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, H, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))

		//Do this now, order doesn't matter
		sparks.start()
		dcell.use(charge_cost)
		update_icon()
		playsound(get_turf(src), 'sound/items/defib_release.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] shocks [H] with the paddles."),
			SPAN_HELPFUL("You shock <b>[H]</b> with the paddles."))
		H.visible_message(SPAN_DANGER("[H]'s body convulses a bit."))
		defib_cooldown = world.time + 10 //1 second cooldown before you can shock again

		if(H.wear_suit && (istype(H.wear_suit, /obj/item/clothing/suit/armor) || istype(H.wear_suit, /obj/item/clothing/suit/storage/marine)) && prob(95))
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Defibrillation failed: Paddles registering >100,000 ohms, Possible cause: Suit or Armor interferring."))
			return

		var/datum/internal_organ/heart/heart = H.internal_organs_by_name["heart"]
		if(heart && prob(25))
			heart.damage += 5 //Allow the defibrilator to possibly worsen heart damage. Still rare enough to just be the "clone damage" of the defib

		if(!H.is_revivable())
			if(heart && heart.is_broken())
				user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's heart is too damaged. Immediate surgery is advised."))
				return
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's general condition does not allow reviving."))
			return

		if((!H.check_tod() && !isSynth(H))) //synthetic species have no expiration date
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Patient's brain has decayed too much."))
			return

		if(!H.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: No soul detected, Attempting to revive..."))

		if(H.mind && !H.client) //Let's call up the correct ghost! Also, bodies with clients only, thank you.
			G = H.get_ghost()
			if(istype(G))
				user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Patient's soul has almost departed, please try again."))
				return
			//We couldn't find a suitable ghost, this means the person is not returning
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Patient has a DNR."))
			return


		if(!H.client) //Freak case, no client at all. This is a braindead mob (like a colonist)
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Defibrillation failed. No soul detected."))
			return
			
		//At this point, the defibrillator is ready to work
		H.apply_damage(-damage_threshold, BRUTE)
		H.apply_damage(-damage_threshold, BURN)
		H.apply_damage(-damage_threshold, TOX)
		H.apply_damage(-damage_threshold, CLONE)
		H.apply_damage(-H.getOxyLoss(), OXY)
		H.updatehealth() //Needed for the check to register properly

		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/datum/chem_property/P = R.get_property(PROPERTY_ELECTROGENETIC)//Adrenaline helps greatly at restarting the heart
			if(P)
				P.trigger(H)
				H.reagents.remove_reagent(R.id, P.level)
				break
		if(H.health > HEALTH_THRESHOLD_DEAD)
			user.visible_message(SPAN_NOTICE("[htmlicon(src, viewers(src))] \The [src] beeps: Defibrillation successful."))
			user.track_life_saved(user.job)
			SEND_SIGNAL(H, COMSIG_HUMAN_REVIVED)
			H.handle_revive()
			to_chat(H, SPAN_NOTICE("You suddenly feel a spark and your consciousness returns, dragging you back to the mortal plane."))
		else
			user.visible_message(SPAN_WARNING("[htmlicon(src, viewers(src))] \The [src] buzzes: Defibrillation failed. Vital signs are too weak, repair damage and try again.")) //Freak case
	else
		user.visible_message(SPAN_WARNING("[user] stops setting up the paddles on [H]'s chest"), \
		SPAN_WARNING("You stop setting up the paddles on [H]'s chest"))
