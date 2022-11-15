/obj/item/clothing/gloves/yautja
	name = "ancient alien bracers"
	desc = "A pair of strange, alien bracers."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "bracer"
	item_icons = list(
		WEAR_HANDS = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_item = ITEM_PREDATOR
	flags_inventory = CANTSTRIP
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	flags_armor_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature
	unacidable = TRUE

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	var/notification_sound = TRUE	// Whether the bracer pings when a message comes or not
	var/charge = 1500
	var/charge_max = 1500
	var/cloaked = 0
	var/cloak_timer = 0
	var/cloak_malfunction = 0

	var/mob/living/carbon/human/owner //Pred spawned on, or thrall given to.
	var/obj/item/clothing/gloves/yautja/linked_bracer //Bracer linked to this one (thrall or mentor).

/obj/item/clothing/gloves/yautja/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		flags_item |= NODROP
		START_PROCESSING(SSobj, src)
		if(isYautja(user))
			to_chat(user, SPAN_WARNING("The bracer clamps securely around your forearm and beeps in a comfortable, familiar way."))
		else
			to_chat(user, SPAN_WARNING("The bracer clamps painfully around your forearm and beeps angrily. It won't come off!"))
		if(!owner)
			owner = user

/obj/item/clothing/gloves/yautja/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(linked_bracer)
		linked_bracer.linked_bracer = null
		linked_bracer = null
	return ..()

/obj/item/clothing/gloves/yautja/dropped(mob/user)
	STOP_PROCESSING(SSobj, src)
	flags_item = initial(flags_item)
	..()

/obj/item/clothing/gloves/yautja/pickup(mob/living/user)
	..()
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("The bracer feels cold against your skin, heavy with an unfamiliar, almost alien weight."))

/obj/item/clothing/gloves/yautja/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return
	var/mob/living/carbon/human/H = loc

	charge = min(charge + 30, charge_max)
	var/perc_charge = (charge / charge_max * 100)
	H.update_power_display(perc_charge)

/// handles decloaking only on HUNTER gloves
/obj/item/clothing/gloves/yautja/proc/decloak()
	return

/*
*This is the main proc for checking AND draining the bracer energy. It must have human passed as an argument.
*It can take a negative value in amount to restore energy.
*Also instantly updates the yautja power HUD display.
*/
/obj/item/clothing/gloves/yautja/proc/drain_power(var/mob/living/carbon/human/human, var/amount)
	if(!human)
		return FALSE
	if(charge < amount)
		to_chat(human, SPAN_WARNING("Your bracers lack the energy. They have only <b>[charge]/[charge_max]</b> remaining and need <B>[amount]</b>."))
		return FALSE

	charge -= amount
	var/perc = (charge / charge_max * 100)
	human.update_power_display(perc)

	//Non-Yautja have a chance to get stunned with each power drain
	if(!HAS_TRAIT(human, TRAIT_YAUTJA_TECH) && !human.hunter_data.thralled)
		if(prob(15))
			if(cloaked)
				decloak(human)
				cloak_timer = world.time + 5 SECONDS
			shock_user(human)
			return FALSE

	return TRUE

/obj/item/clothing/gloves/yautja/proc/shock_user(var/mob/living/carbon/human/M)
	if(!HAS_TRAIT(M, TRAIT_YAUTJA_TECH) && !M.hunter_data.thralled)
		//Spark
		playsound(M, 'sound/effects/sparks2.ogg', 60, 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		M.visible_message(SPAN_WARNING("[src] beeps and sends a shock through [M]'s body!"))
		//Stun and knock out, scream in pain
		M.Stun(2)
		M.KnockDown(2)
		if(M.pain.feels_pain)
			M.emote("scream")
		//Apply a bit of burn damage
		M.apply_damage(5, BURN, "l_arm", 0, 0, 0, src)
		M.apply_damage(5, BURN, "r_arm", 0, 0, 0, src)

//We use this to determine whether we should activate the given verb, or a random verb
//0 - do nothing, 1 - random function, 2 - this function
/obj/item/clothing/gloves/yautja/hunter/proc/check_random_function(var/mob/living/carbon/human/user, var/forced = FALSE, var/always_delimb = FALSE)
	if(!istype(user))
		return TRUE

	if(forced || HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		return FALSE

	if(user.is_mob_incapacitated()) //let's do this here to avoid to_chats to dead guys
		return TRUE

	var/workingProbability = 20
	var/randomProbability = 10
	if(isSynth(user)) // Synths are smart, they can figure this out pretty well
		workingProbability = 40
		randomProbability = 4
	else if(isResearcher(user)) // Researchers are sort of smart, they can sort of figure this out
		workingProbability = 25
		randomProbability = 7

	to_chat(user, SPAN_NOTICE("You press a few buttons..."))
	//Add a little delay so the user wouldn't be just spamming all the buttons
	user.next_move = world.time + 3
	if(do_after(usr, 3, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 1))
		if(prob(randomProbability))
			return activate_random_verb(user)
		if(!prob(workingProbability))
			to_chat(user, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return TRUE

	if(always_delimb)
		return delimb_user(user)

	return FALSE

/obj/item/clothing/gloves/yautja/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("They currently have <b>[charge]/[charge_max]</b> charge.")


// Toggle the notification sound
/obj/item/clothing/gloves/yautja/verb/toggle_notification_sound()
	set name = "Toggle Bracer Sound"
	set desc = "Toggle your bracer's notification sound."
	set src in usr

	notification_sound = !notification_sound
	to_chat(usr, SPAN_NOTICE("The bracer's sound is now turned [notification_sound ? "on" : "off"]."))


/obj/item/clothing/gloves/yautja/thrall
	name = "thrall bracers"
	desc = "A pair of strange alien bracers, adapted for human biology."

	color = "#b85440"


/obj/item/clothing/gloves/yautja/hunter
	name = "clan bracers"
	desc = "An extremely complex, yet simple-to-operate set of armored bracers worn by the Yautja. It has many functions, activate them to use some."

	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

	charge = 3000
	charge_max = 3000

	var/exploding = 0
	var/inject_timer = 0
	var/healing_capsule_timer = 0
	var/disc_timer = 0
	var/explosion_type = 1 //0 is BIG explosion, 1 ONLY gibs the user.
	var/name_active = TRUE
	var/translator_type = "Modern"
	var/caster_material = "ebony"

	var/obj/item/card/id/bracer_chip/embedded_id


	var/caster_deployed = FALSE
	var/obj/item/weapon/gun/energy/yautja/plasma_caster/caster

	var/wristblades_deployed = FALSE
	var/obj/item/weapon/wristblades/left_wristblades
	var/obj/item/weapon/wristblades/right_wristblades

/obj/item/clothing/gloves/yautja/hunter/Initialize(mapload, var/new_translator_type, var/new_caster_material)
	. = ..()
	embedded_id = new(src)
	if(new_translator_type)
		translator_type = new_translator_type
	if(new_caster_material)
		caster_material = new_caster_material
	caster = new(src, FALSE, caster_material)
	left_wristblades = new(src)
	right_wristblades = new(src)

/obj/item/clothing/gloves/yautja/hunter/emp_act(severity)
	charge = max(charge - (severity * 500), 0)
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(wearer.gloves == src)
			wearer.visible_message(SPAN_DANGER("You hear a hiss and crackle!"), SPAN_DANGER("Your bracers hiss and spark!"), SPAN_DANGER("You hear a hiss and crackle!"))
			if(cloaked)
				decloak(wearer)
		else
			var/turf/our_turf = get_turf(src)
			our_turf.visible_message(SPAN_DANGER("You hear a hiss and crackle!"), SPAN_DANGER("You hear a hiss and crackle!"))

/obj/item/clothing/gloves/yautja/hunter/equipped(mob/user, slot)
	. = ..()
	if(slot != WEAR_HANDS)
		move_chip_to_bracer()
	else
		if(embedded_id.registered_name)
			embedded_id.set_user_data(user)

//Any projectile can decloak a predator. It does defeat one free bullet though.
/obj/item/clothing/gloves/yautja/hunter/proc/bullet_hit(mob/living/carbon/human/H, obj/item/projectile/P)
	SIGNAL_HANDLER

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_ROCKET|AMMO_ENERGY|AMMO_XENO_ACID)) //<--- These will auto uncloak.
		decloak(H) //Continue on to damage.
	else if(prob(20))
		decloak(H)
		return COMPONENT_CANCEL_BULLET_ACT //Absorb one free bullet.

/obj/item/clothing/gloves/yautja/hunter/toggle_notification_sound()
	set category = "Yautja.Misc"
	..()

/obj/item/clothing/gloves/yautja/hunter/Destroy()
	QDEL_NULL(caster)
	QDEL_NULL(embedded_id)
	return ..()

/obj/item/clothing/gloves/yautja/hunter/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/carbon/human/human = loc

	if(cloaked)
		charge = max(charge - 10, 0)
		if(charge <= 0)
			decloak(loc)
		//Non-Yautja have a chance to get stunned with each power drain
		if(!isYautja(human))
			if(prob(15))
				decloak(human)
				shock_user(human)
		return
	return ..()

/obj/item/clothing/gloves/yautja/hunter/dropped(mob/user)
	move_chip_to_bracer()
	if(cloaked)
		decloak(user)
	..()

/obj/item/clothing/gloves/yautja/hunter/on_enter_storage(obj/item/storage/S)
	if(ishuman(loc))
		var/mob/living/carbon/human/human = loc
		if(cloaked)
			decloak(human)
	. = ..()

//We use this to activate random verbs for non-Yautja
/obj/item/clothing/gloves/yautja/hunter/proc/activate_random_verb(var/mob/caller)
	var/option = rand(1, 11)
	//we have options from 1 to 8, but we're giving the user a higher probability of being punished if they already rolled this bad
	switch(option)
		if(1)
			. = wristblades_internal(caller, TRUE)
		if(2)
			. = track_gear_internal(caller, TRUE)
		if(3)
			. = cloaker_internal(caller, TRUE)
		if(4)
			. = caster_internal(caller, TRUE)
		if(5)
			. = injectors_internal(caller, TRUE)
		if(6)
			. = call_disk_internal(caller, TRUE)
		if(7)
			. = translate_internal(caller, TRUE)
		if(8)
			. = call_combi_internal(caller, TRUE)
		else
			. = delimb_user(caller)

//This is used to punish people that fiddle with technology they don't understand
/obj/item/clothing/gloves/yautja/hunter/proc/delimb_user(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(isYautja(user))
		return

	var/obj/limb/O = user.get_limb(check_zone("r_arm"))
	O.droplimb()
	O = user.get_limb(check_zone("l_arm"))
	O.droplimb()

	to_chat(user, SPAN_NOTICE("The device emits a strange noise and falls off... Along with your arms!"))
	playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)
	return TRUE

// Toggle the notification sound
/obj/item/clothing/gloves/yautja/hunter/toggle_notification_sound()
	set category = "Yautja.Misc"

//Should put a cool menu here, like ninjas.
/obj/item/clothing/gloves/yautja/hunter/verb/wristblades()
	set name = "Use Wrist Blades"
	set desc = "Extend your wrist blades. They cannot be dropped, but can be retracted."
	set category = "Yautja.Weapons"
	set src in usr
	. = wristblades_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/wristblades_internal(var/mob/living/carbon/human/caller, var/forced = FALSE)
	if(!caller.loc || !caller.canmove || caller.stat || !ishuman(caller))
		return

	. = check_random_function(caller, forced)
	if(.)
		return

	if(wristblades_deployed)
		if(left_wristblades.loc == caller)
			caller.drop_inv_item_to_loc(left_wristblades, src, FALSE, TRUE)
		if(right_wristblades.loc == caller)
			caller.drop_inv_item_to_loc(right_wristblades, src, FALSE, TRUE)
		wristblades_deployed = FALSE
		to_chat(caller, SPAN_NOTICE("You retract your [left_wristblades.name]."))
		playsound(caller, 'sound/weapons/wristblades_off.ogg', 15, TRUE)
	else
		if(!drain_power(caller, 50))
			return
		var/deploying_into_left_hand = caller.hand ? TRUE : FALSE
		if(caller.get_active_hand())
			to_chat(caller, SPAN_WARNING("Your hand must be free to activate your wristblade!"))
			return
		var/obj/limb/hand = caller.get_limb(deploying_into_left_hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(caller, SPAN_WARNING("You can't hold that!"))
			return
		var/is_offhand_full = FALSE
		var/obj/limb/off_hand = caller.get_limb(deploying_into_left_hand ? "r_hand" : "l_hand")
		if(caller.get_inactive_hand() || (!istype(off_hand) || !off_hand.is_usable()))
			is_offhand_full = TRUE
		if(deploying_into_left_hand)
			caller.put_in_active_hand(left_wristblades)
			if(!is_offhand_full)
				caller.put_in_inactive_hand(right_wristblades)
		else
			caller.put_in_active_hand(right_wristblades)
			if(!is_offhand_full)
				caller.put_in_inactive_hand(left_wristblades)
		wristblades_deployed = TRUE
		to_chat(caller, SPAN_NOTICE("You activate your [left_wristblades.plural_name]."))
		playsound(caller, 'sound/weapons/wristblades_on.ogg', 15, TRUE)

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/track_gear()
	set name = "Track Yautja Gear"
	set desc = "Find Yauja Gear."
	set category = "Yautja.Tracker"
	set src in usr
	. = track_gear_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/track_gear_internal(var/mob/caller, var/forced = FALSE)
	. = check_random_function(caller, forced)
	if(.)
		return

	var/mob/living/carbon/human/M = caller

	var/dead_on_planet = 0
	var/dead_on_almayer = 0
	var/dead_low_orbit = 0
	var/gear_on_planet = 0
	var/gear_on_almayer = 0
	var/gear_low_orbit = 0
	var/closest = 10000
	var/direction = -1
	var/atom/areaLoc = null
	for(var/obj/item/I as anything in GLOB.loose_yautja_gear)
		var/atom/loc = get_true_location(I)
		if(I.anchored)
			continue
		if(is_honorable_carrier(recursive_holder_check(I)))
			continue
		if(istype(get_area(I), /area/yautja))
			continue
		if(is_loworbit_level(loc.z))
			gear_low_orbit++
		else if(is_mainship_level(loc.z))
			gear_on_almayer++
		else if(is_ground_level(loc.z))
			gear_on_planet++
		if(M.z == loc.z)
			var/dist = get_dist(M,loc)
			if(dist < closest)
				closest = dist
				direction = get_dir(M,loc)
				areaLoc = loc
	for(var/mob/living/carbon/human/Y as anything in GLOB.yautja_mob_list)
		if(Y.stat != DEAD)
			continue
		if(istype(get_area(Y), /area/yautja))
			continue
		if(is_loworbit_level(Y.z))
			dead_low_orbit++
		else if(is_mainship_level(Y.z))
			dead_on_almayer++
		else if(is_ground_level(Y.z))
			dead_on_planet++
		if(M.z == Y.z)
			var/dist = get_dist(M,Y)
			if(dist < closest)
				closest = dist
				direction = get_dir(M,Y)
				areaLoc = loc

	var/output = FALSE
	if(dead_on_planet || dead_on_almayer || dead_low_orbit)
		output = TRUE
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of deceased Yautja bio signatures[dead_on_planet ? ", <b>[dead_on_planet]</b> in the hunting grounds" : ""][dead_on_almayer ? ", <b>[dead_on_almayer]</b> in orbit" : ""][dead_low_orbit ? ", <b>[dead_low_orbit]</b> in low orbit" : ""]."))
	if(gear_on_planet || gear_on_almayer || gear_low_orbit)
		output = TRUE
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of Yautja technology signatures[gear_on_planet ? ", <b>[gear_on_planet]</b> in the hunting grounds" : ""][gear_on_almayer ? ", <b>[gear_on_almayer]</b> in orbit" : ""][gear_low_orbit ? ", <b>[gear_low_orbit]</b> in low orbit" : ""]."))
	if(closest < 900)
		output = TRUE
		var/areaName = get_area_name(areaLoc)
		if(closest == 0)
			to_chat(M, SPAN_NOTICE("You are directly on top of the closest signature."))
		else
			to_chat(M, SPAN_NOTICE("The closest signature is [closest > 10 ? "approximately <b>[round(closest, 10)]</b>" : "<b>[closest]</b>"] paces <b>[dir2text(direction)]</b> in <b>[areaName]</b>."))
	if(!output)
		to_chat(M, SPAN_NOTICE("There are no signatures that require your attention."))
	return TRUE


/obj/item/clothing/gloves/yautja/hunter/verb/cloaker()
	set name = "Toggle Cloaking Device"
	set desc = "Activate your suit's cloaking device. It will malfunction if the suit takes damage or gets excessively wet."
	set category = "Yautja.Utility"
	set src in usr
	. = cloaker_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/cloaker_internal(var/mob/caller, var/forced = FALSE)
	. = check_random_function(caller, forced)
	if(.)
		return

	var/mob/living/carbon/human/M = caller

	if(!istype(M) || M.is_mob_incapacitated())
		return FALSE

	if(cloaked) //Turn it off.
		if(cloak_timer > world.time)
			to_chat(M, SPAN_WARNING("Your cloaking device is busy! Time left: <B>[max(round((cloak_timer - world.time) / 10), 1)]</b> seconds."))
			return FALSE
		decloak(caller)
	else //Turn it on!
		if(exploding)
			to_chat(M, SPAN_WARNING("Your bracer is much too busy violently exploding to activate the cloaking device."))
			return FALSE

		if(cloak_malfunction > world.time)
			to_chat(M, SPAN_WARNING("Your cloak is malfunctioning and can't be enabled right now!"))
			return FALSE

		if(cloak_timer > world.time)
			to_chat(M, SPAN_WARNING("Your cloaking device is still recharging! Time left: <B>[max(round((cloak_timer - world.time) / 10), 1)]</b> seconds."))
			return FALSE

		if(!drain_power(M, 50))
			return FALSE

		cloaked = TRUE

		RegisterSignal(M, COMSIG_HUMAN_EXTINGUISH, .proc/wrapper_fizzle_camouflage)
		RegisterSignal(M, COMSIG_HUMAN_PRE_BULLET_ACT, .proc/bullet_hit)

		cloak_timer = world.time + 1.5 SECONDS

		log_game("[key_name_admin(usr)] has enabled their cloaking device.")
		M.visible_message(SPAN_WARNING("[M] vanishes into thin air!"), SPAN_NOTICE("You are now invisible to normal detection."))
		playsound(M.loc,'sound/effects/pred_cloakon.ogg', 15, 1)
		animate(M, alpha = 10, time = 1.5 SECONDS, easing = SINE_EASING|EASE_OUT)

		var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
		SA.remove_from_hud(M)
		var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
		XI.remove_from_hud(M)
		anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/wrapper_fizzle_camouflage()
	SIGNAL_HANDLER

	var/mob/wearer = src.loc
	wearer.visible_message(SPAN_DANGER("[wearer]'s cloak fizzles out!"), SPAN_DANGER("Your cloak fizzles out!"))

	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(5, 4, src)
	sparks.start()

	decloak(wearer, TRUE)

/obj/item/clothing/gloves/yautja/hunter/decloak(var/mob/user, forced)
	if(!user)
		return

	UnregisterSignal(user, COMSIG_HUMAN_EXTINGUISH)
	UnregisterSignal(user, COMSIG_HUMAN_PRE_BULLET_ACT)

	if(forced)
		cloak_malfunction = world.time + 10 SECONDS

	cloaked = FALSE
	log_game("[key_name_admin(usr)] has disabled their cloaking device.")
	user.visible_message(SPAN_WARNING("[user] shimmers into existence!"), SPAN_WARNING("Your cloaking device deactivates."))
	playsound(user.loc, 'sound/effects/pred_cloakoff.ogg', 15, 1)
	user.alpha = initial(user.alpha)
	cloak_timer = world.time + 5 SECONDS

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(user)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(user)

	anim(user.loc, user, 'icons/mob/mob.dmi', null, "uncloak", null, user.dir)


/obj/item/clothing/gloves/yautja/hunter/verb/caster()
	set name = "Use Plasma Caster"
	set desc = "Activate your plasma caster. If it is dropped it will retract back into your armor."
	set category = "Yautja.Weapons"
	set src in usr
	. = caster_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/caster_internal(var/mob/living/carbon/human/caller, var/forced = FALSE)
	if(!caller.loc || !caller.canmove || caller.stat || !ishuman(caller))
		return

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caster_deployed)
		if(caster.loc == caller)
			caller.drop_inv_item_to_loc(caster, src, FALSE, TRUE)
		caster_deployed = FALSE
	else
		if(!drain_power(caller, 50))
			return
		if(caller.get_active_hand())
			to_chat(caller, SPAN_WARNING("Your hand must be free to activate your wristblade!"))
			return
		var/obj/limb/hand = caller.get_limb(caller.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(caller, SPAN_WARNING("You can't hold that!"))
			return
		caller.put_in_active_hand(caster)
		caster_deployed = TRUE
		to_chat(caller, SPAN_NOTICE("You activate your plasma caster. It is in [caster.mode] mode."))
		playsound(src, 'sound/weapons/pred_plasmacaster_on.ogg', 15, TRUE)

	return TRUE


/obj/item/clothing/gloves/yautja/hunter/proc/explode(var/mob/living/carbon/victim)
	set waitfor = 0

	if (exploding)
		return

	exploding = 1
	var/turf/T = get_turf(src)
	if(explosion_type == SD_TYPE_BIG && victim.stat == CONSCIOUS && is_ground_level(T.z))
		playsound(src, 'sound/voice/pred_deathlaugh.ogg', 100, 0, 17, status = 0)

	playsound(src, 'sound/effects/pred_countdown.ogg', 100, 0, 17, status = 0)
	message_staff(FONT_SIZE_XL("<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];admincancelpredsd=1;bracer=\ref[src];victim=\ref[victim]'>CLICK TO CANCEL THIS PRED SD</a>"))
	do_after(victim, rand(72, 80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	T = get_turf(src)
	if(istype(T) && exploding)
		victim.apply_damage(50,BRUTE,"chest")
		if(victim)
			victim.gib() // kills the pred
			qdel(victim)
		var/datum/cause_data/cause_data = create_cause_data("yautja self-destruct", victim)
		if(explosion_type == SD_TYPE_BIG && is_ground_level(T.z))
			cell_explosion(T, 600, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //Dramatically BIG explosion.
		else
			cell_explosion(T, 800, 550, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)

/obj/item/clothing/gloves/yautja/hunter/verb/change_explosion_type()
	set name = "Change Explosion Type"
	set desc = "Changes your bracer explosion to either only gib you or be a big explosion."
	set category = "Yautja.Misc"
	set src in usr

	if(explosion_type == SD_TYPE_SMALL && exploding)
		to_chat(usr, SPAN_WARNING("Why would you want to do this?"))
		return

	if(alert("Which explosion type do you want?","Explosive Bracers", "Small", "Big") == "Big")
		explosion_type = SD_TYPE_BIG
		log_attack("[key_name_admin(usr)] has changed their Self-Destruct to Large")
	else
		explosion_type = SD_TYPE_SMALL
		log_attack("[key_name_admin(usr)] has changed their Self-Destruct to Small")
		return

/obj/item/clothing/gloves/yautja/hunter/verb/activate_suicide()
	set name = "Final Countdown (!)"
	set desc = "Activate the explosive device implanted into your bracers. You have failed! Show some honor!"
	set category = "Yautja.Misc"
	set src in usr
	. = activate_suicide_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/activate_suicide_internal(var/mob/caller, var/forced = FALSE)
	. = check_random_function(caller, forced, TRUE)
	if(.)
		return

	var/mob/living/carbon/human/M = caller

	if(cloaked)
		to_chat(M, SPAN_WARNING("Not while you're cloaked. It might disrupt the sequence."))
		return
	if(M.stat == DEAD)
		to_chat(M, SPAN_WARNING("Little too late for that now!"))
		return
	if(M.health < HEALTH_THRESHOLD_CRIT)
		to_chat(M, SPAN_WARNING("As you fall into unconsciousness you fail to activate your self-destruct device before you collapse."))
		return
	if(M.stat)
		to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
		return

	var/obj/item/grab/G = M.get_active_hand()
	if(istype(G))
		var/mob/living/carbon/human/victim = G.grabbed_thing
		if(isYautja(victim) && victim.stat == DEAD)
			var/obj/item/clothing/gloves/yautja/hunter/bracer = victim.gloves
			if(istype(bracer))
				if(forced || alert("Are you sure you want to send this [victim.species] into the great hunting grounds?","Explosive Bracers", "Yes", "No") == "Yes")
					if(M.get_active_hand() == G && victim && victim.gloves == bracer && !bracer.exploding)
						var/area/A = get_area(M)
						var/turf/T = get_turf(M)
						if(A)
							message_staff(FONT_SIZE_HUGE("ALERT: [M] ([M.key]) triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)</font>"))
							log_attack("[key_name(M)] triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name]")
						if (!bracer.exploding)
							bracer.explode(victim)
						M.visible_message(SPAN_WARNING("[M] presses a few buttons on [victim]'s wrist bracer."),SPAN_DANGER("You activate the timer. May [victim]'s final hunt be swift."))
						message_all_yautja("[M.real_name] has triggered [victim.real_name]'s bracer's self-destruction sequence.")
			else
				to_chat(M, SPAN_WARNING("<b>This [victim.species] does not have a bracer attached.</b>"))
			return

	if(M.gloves != src && !forced)
		return

	if(exploding)
		if(forced || alert("Are you sure you want to stop the countdown?","Bracers", "Yes", "No") == "Yes")
			if(M.gloves != src)
				return
			if(M.stat == DEAD)
				to_chat(M, SPAN_WARNING("Little too late for that now!"))
				return
			if(M.stat)
				to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
				return
			exploding = FALSE
			to_chat(M, SPAN_NOTICE("Your bracers stop beeping."))
			message_staff("[M] ([M.key]) has deactivated their Self-Destruct.")
		return
	if(istype(M.wear_mask,/obj/item/clothing/mask/facehugger) || (M.status_flags & XENO_HOST))
		to_chat(M, SPAN_WARNING("Strange...something seems to be interfering with your bracer functions..."))
		return
	if(forced || alert("Detonate the bracers? Are you sure?","Explosive Bracers", "Yes", "No") == "Yes")
		if(M.gloves != src)
			return
		if(M.stat == DEAD)
			to_chat(M, SPAN_WARNING("Little too late for that now!"))
			return
		if(M.stat)
			to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
			return
		if(exploding)
			return
		to_chat(M, SPAN_DANGER("You set the timer. May your journey to the great hunting grounds be swift."))
		var/area/A = get_area(M)
		var/turf/T = get_turf(M)
		message_staff(FONT_SIZE_HUGE("ALERT: [M] ([M.key]) triggered their predator self-destruct sequence [A ? "in [A.name]":""] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)"))
		log_attack("[key_name(M)] triggered their predator self-destruct sequence in [A ? "in [A.name]":""]")
		message_all_yautja("[M.real_name] has triggered their bracer's self-destruction sequence.")
		explode(M)
	return 1



/obj/item/clothing/gloves/yautja/hunter/verb/injectors()
	set name = "Create Stabilising Crystal"
	set category = "Yautja.Utility"
	set desc = "Create a focus crystal to energize your natural healing processes."
	set src in usr
	. = injectors_internal(usr, FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/injectors_internal(var/mob/caller, var/forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caller.get_active_hand())
		to_chat(caller, SPAN_WARNING("Your active hand must be empty!"))
		return FALSE

	if(inject_timer)
		to_chat(caller, SPAN_WARNING("You recently activated the stabilising crystal. Be patient."))
		return FALSE

	if(!drain_power(caller, 1000))
		return FALSE

	inject_timer = TRUE
	addtimer(CALLBACK(src, .proc/injectors_ready), 2 MINUTES)

	to_chat(caller, SPAN_NOTICE("You feel a faint hiss and a crystalline injector drops into your hand."))
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(caller)
	caller.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/injectors_ready()
	if(ismob(loc))
		to_chat(loc, SPAN_NOTICE("Your bracers beep faintly and inform you that a new stabilising crystal is ready to be created."))
	inject_timer = FALSE

/obj/item/clothing/gloves/yautja/hunter/verb/healing_capsule()
	set name = "Create Healing Capsule"
	set category = "Yautja.Utility"
	set desc = "Create a healing capsule for your healing gun."
	set src in usr
	. = healing_capsule_internal(usr, FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/healing_capsule_internal(var/mob/caller, var/forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caller.get_active_hand())
		to_chat(caller, SPAN_WARNING("Your active hand must be empty!"))
		return FALSE

	if(healing_capsule_timer)
		to_chat(usr, SPAN_WARNING("Your bracer is still generating a new healing capsule!"))
		return FALSE

	if(!drain_power(caller, 800))
		return FALSE

	healing_capsule_timer = TRUE
	addtimer(CALLBACK(src, .proc/healing_capsule_ready), 4 MINUTES)

	to_chat(caller, SPAN_NOTICE("You feel your bracer churn as it pops out a healing capsule."))
	var/obj/item/tool/surgery/healing_gel/O = new(caller)
	caller.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/healing_capsule_ready()
	if(ismob(loc))
		to_chat(loc, SPAN_NOTICE("Your bracers beep faintly and inform you that a new healing capsule is ready to be created."))
	healing_capsule_timer = FALSE

/obj/item/clothing/gloves/yautja/hunter/verb/call_disk()
	set name = "Call Smart-Disc"
	set category = "Yautja.Weapons"
	set desc = "Call back your smart-disc, if it's in range. If not you'll have to go retrieve it."
	set src in usr
	. = call_disk_internal(usr, FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/call_disk_internal(var/mob/caller, var/forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	if(disc_timer)
		to_chat(caller, SPAN_WARNING("Your bracers need some time to recuperate first."))
		return FALSE

	if(!drain_power(caller, 70))
		return FALSE

	disc_timer = TRUE
	addtimer(VARSET_CALLBACK(src, disc_timer, FALSE), 10 SECONDS)

	for(var/mob/living/simple_animal/hostile/smartdisc/S in range(7))
		to_chat(caller, SPAN_WARNING("The [S] skips back towards you!"))
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(S.loc)
		qdel(S)

	for(var/obj/item/explosive/grenade/spawnergrenade/smartdisc/D in range(10))
		if(isturf(D.loc))
			D.boomerang(caller)

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/remove_tracked_item()
	set name = "Remove Item from Tracker"
	set desc = "Remove an item from the Yautja tracker."
	set category = "Yautja.Tracker"
	set src in usr
	. = remove_tracked_item_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/remove_tracked_item_internal(var/mob/caller, var/forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	var/obj/item/tracked_item = caller.get_active_hand()
	if(!tracked_item)
		to_chat(caller, SPAN_WARNING("You need the item in your active hand to remove it from the tracker!"))
		return FALSE
	if(!(tracked_item in GLOB.tracked_yautja_gear))
		to_chat(caller, SPAN_WARNING("\The [tracked_item] isn't on the tracking system."))
		return FALSE
	tracked_item.RemoveElement(/datum/element/yautja_tracked_item)
	to_chat(caller, SPAN_NOTICE("You remove \the <b>[tracked_item]</b> from the tracking system."))
	return TRUE


/obj/item/clothing/gloves/yautja/hunter/verb/add_tracked_item()
	set name = "Add Item to Tracker"
	set desc = "Add an item to the Yautja tracker."
	set category = "Yautja.Tracker"
	set src in usr
	. = add_tracked_item_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/add_tracked_item_internal(var/mob/caller, var/forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	var/obj/item/untracked_item = caller.get_active_hand()
	if(!untracked_item)
		to_chat(caller, SPAN_WARNING("You need the item in your active hand to remove it from the tracker!"))
		return FALSE
	if(untracked_item in GLOB.tracked_yautja_gear)
		to_chat(caller, SPAN_WARNING("\The [untracked_item] is already being tracked."))
		return FALSE
	untracked_item.AddElement(/datum/element/yautja_tracked_item)
	to_chat(caller, SPAN_NOTICE("You add \the <b>[untracked_item]</b> to the tracking system."))
	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/call_combi()
	set name = "Yank combi-stick"
	set category = "Yautja.Weapons"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."
	set src in usr
	. = call_combi_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/call_combi_internal(var/mob/caller, var/forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	for(var/obj/item/weapon/melee/yautja/combistick/C in range(7))
		if(caller.put_in_active_hand(C))//Try putting it in our active hand, or, if it's full...
			if(!drain_power(caller, 70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return TRUE
			caller.visible_message(SPAN_WARNING("<b>[caller] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
		else if(caller.put_in_inactive_hand(C))///...Try putting it in our inactive hand.
			if(!drain_power(caller, 70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return TRUE
			caller.visible_message(SPAN_WARNING("<b>[caller] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
		else //If neither hand can hold it, you must not have a free hand.
			to_chat(caller, SPAN_WARNING("You need a free hand to do this!</b>"))

/obj/item/clothing/gloves/yautja/hunter/verb/translate()
	set name = "Translator"
	set desc = "Emit a message from your bracer to those nearby."
	set category = "Yautja.Utility"
	set src in usr
	. = translate_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/translate_internal(var/mob/caller, var/forced = FALSE)
	if(!caller || caller.stat)
		return

	. = check_random_function(caller, forced)
	if(.)
		return

	caller.set_typing_indicator(TRUE, "translator")
	var/msg = sanitize(input(caller, "Your bracer beeps and waits patiently for you to input your message.", "Translator", "") as text)
	caller.set_typing_indicator(FALSE, "translator")
	if(!msg || !caller.client)
		return

	if(!drain_power(caller, 50))
		return

	log_say("[caller.name != "Unknown" ? caller.name : "([caller.real_name])"] \[Yautja Translator\]: [msg] (CKEY: [caller.key]) (JOB: [caller.job])")

	var/list/heard = get_mobs_in_view(7, caller)
	for(var/mob/M in heard)
		if(M.ear_deaf)
			heard -= M

	var/overhead_color = "#ff0505"
	var/span_class = "yautja_translator"
	if(translator_type != "Modern")
		if(translator_type == "Retro")
			overhead_color = "#FFFFFF"
			span_class = "retro_translator"
		msg = replacetext(msg, "a", "@")
		msg = replacetext(msg, "e", "3")
		msg = replacetext(msg, "i", "1")
		msg = replacetext(msg, "o", "0")
		msg = replacetext(msg, "s", "5")
		msg = replacetext(msg, "l", "1")

	caller.langchat_speech(msg, heard, GLOB.all_languages, overhead_color, TRUE)

	var/voice_name = "A strange voice"
	if(caller.name == caller.real_name && caller.alpha == initial(caller.alpha))
		voice_name = "<b>[caller.name]</b>"
	for(var/mob/Q as anything in heard)
		if(Q.stat && !isobserver(Q))
			continue //Unconscious
		to_chat(Q, "[SPAN_INFO("[voice_name] says,")] <span class='[span_class]'>'[msg]'</span>")

/obj/item/clothing/gloves/yautja/hunter/verb/bracername()
	set name = "Toggle Bracer Name"
	set desc = "Toggle whether fellow Yautja that examine you will be able to see your name."
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	name_active = !name_active
	to_chat(usr, SPAN_NOTICE("\The [src] will [name_active ? "now" : "no longer"] show your name when fellow Yautja examine you."))

/obj/item/clothing/gloves/yautja/hunter/verb/idchip()
	set name = "Toggle ID Chip"
	set desc = "Reveal/Hide your embedded bracer ID chip."
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	var/mob/living/carbon/human/H = usr
	if(!istype(H) || !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("You do not know how to use this."))
		return

	if(H.wear_id == embedded_id)
		to_chat(H, SPAN_NOTICE("You retract your ID chip."))
		move_chip_to_bracer()
	else if(H.wear_id)
		to_chat(H, SPAN_WARNING("Something is obstructing the deployment of your ID chip!"))
	else
		to_chat(H, SPAN_NOTICE("You expose your ID chip."))
		if(!H.equip_to_slot_if_possible(embedded_id, WEAR_ID))
			to_chat(H, SPAN_WARNING("Something went wrong during your chip's deployment! (Make a Bug Report about this)"))
			move_chip_to_bracer()

/obj/item/clothing/gloves/yautja/hunter/proc/move_chip_to_bracer()
	if(!embedded_id || !embedded_id.loc)
		return

	if(embedded_id.loc == src)
		return

	if(ismob(embedded_id.loc))
		var/mob/M = embedded_id.loc
		M.u_equip(embedded_id, src, FALSE, TRUE)
	else
		embedded_id.forceMove(src)
