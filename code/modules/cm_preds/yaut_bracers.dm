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
	var/cloak_cooldown
	var/upgrades = 0
	var/scimitars = FALSE
	var/mob/living/carbon/human/owner //Pred spawned on, or thrall given to.
	var/obj/item/clothing/gloves/yautja/linked_bracer //Bracer linked to this one (thrall or master).

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
	remove_from_missing_pred_gear(src)
	return ..()

/obj/item/clothing/gloves/yautja/dropped(mob/user)
	STOP_PROCESSING(SSobj, src)
	add_to_missing_pred_gear(src)
	flags_item = initial(flags_item)
	..()

/obj/item/clothing/gloves/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	else
		to_chat(user, SPAN_WARNING("The bracer feels cold against your skin, heavy with an unfamiliar, almost alien weight."))
	..()

/obj/item/clothing/gloves/yautja/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return
	var/mob/living/carbon/human/H = loc

	charge = min(charge + 30, charge_max)
	var/perc_charge = (charge / charge_max * 100)
	H.update_power_display(perc_charge)


//This is the main proc for checking AND draining the bracer energy. It must have M passed as an argument.
//It can take a negative value in amount to restore energy.
//Also instantly updates the yautja power HUD display.
/obj/item/clothing/gloves/yautja/proc/drain_power(var/mob/living/carbon/human/M, var/amount)
	if(!M) return 0
	if(charge < amount)
		to_chat(M, SPAN_WARNING("Your bracers lack the energy. They have only <b>[charge]/[charge_max]</b> remaining and need <B>[amount]</b>."))
		return 0
	charge -= amount
	var/perc = (charge / charge_max * 100)
	M.update_power_display(perc)

	//Non-Yautja have a chance to get stunned with each power drain
	if(!HAS_TRAIT(M, TRAIT_YAUTJA_TECH) && !M.hunter_data.thralled)
		if(prob(15))
			shock_user(M)
	return 1

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
		M.emote("scream")
		//Apply a bit of burn damage
		M.apply_damage(5, BURN, "l_arm", 0, 0, 0, src)
		M.apply_damage(5, BURN, "r_arm", 0, 0, 0, src)


/obj/item/clothing/gloves/yautja/examine(mob/user)
	..()
	to_chat(user, "They currently have [charge] out of [charge_max] charge.")


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

	var/obj/item/weapon/gun/energy/yautja/plasma_caster/caster
	var/blades_active = 0
	var/caster_active = 0
	var/exploding = 0
	var/inject_timer = 0
	var/disc_timer = 0
	var/explosion_type = 1 //0 is BIG explosion, 1 ONLY gibs the user.
	var/name_active = TRUE
	var/translator_type = "Modern"
	var/obj/item/card/id/bracer_chip/embedded_id

/obj/item/clothing/gloves/yautja/hunter/Initialize(mapload, var/new_translator_type)
	. = ..()
	caster = new(src)
	embedded_id = new(src)
	if(new_translator_type)
		translator_type = new_translator_type

/obj/item/clothing/gloves/yautja/hunter/emp_act(severity)
	charge -= (severity * 500)
	if(charge < 0) charge = 0
	if(usr)
		usr.visible_message(SPAN_DANGER("You hear a hiss and crackle!"),SPAN_DANGER("Your bracers hiss and spark!"))
		if(cloaked)
			decloak(usr)

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
	if( ammo_flags & (AMMO_ROCKET|AMMO_ENERGY|AMMO_XENO_ACID) ) //<--- These will auto uncloak.
		decloak(H) //Continue on to damage.
	else if(rand(0,100) < 20)
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
	var/mob/living/carbon/human/H = loc

	if(cloak_timer)
		cloak_timer--
	if(cloaked)
		H.alpha = 10
		charge = max(charge - 10, 0)
		if(charge <= 0)
			decloak(loc)
		//Non-Yautja have a chance to get stunned with each power drain
		if(!isYautja(H))
			if(prob(15))
				shock_user(H)
				decloak(loc)
	else
		return ..()

/obj/item/clothing/gloves/yautja/hunter/dropped(mob/user)
	move_chip_to_bracer()
	..()

//We use this to activate random verbs for non-Yautja
/obj/item/clothing/gloves/yautja/hunter/proc/activate_random_verb()
	var/option = rand(1, 11)
	//we have options from 1 to 8, but we're giving the user a higher probability of being punished if they already rolled this bad
	switch(option)
		if(1)
			. = wristblades_internal(TRUE)
		if(2)
			. = track_gear_internal(TRUE)
		if(3)
			. = cloaker_internal(TRUE)
		if(4)
			. = caster_internal(TRUE)
		if(5)
			. = injectors_internal(TRUE)
		if(6)
			. = call_disk_internal(TRUE)
		if(7)
			. = translate_internal(TRUE)
		if(8)
			. = call_combi(TRUE)
		else
			. = delimb_user()

	return

//We use this to determine whether we should activate the given verb, or a random verb
//0 - do nothing, 1 - random function, 2 - this function
/obj/item/clothing/gloves/yautja/hunter/proc/should_activate_random_or_this_function()
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return 0

	var/workingProbability = 20
	var/randomProbability = 10
	if (isSynth(user))
		//Synths are smart, they can figure this out pretty well
		workingProbability = 40
		randomProbability = 4
	else
		//Researchers are sort of smart, they can sort of figure this out
		if (isResearcher(user))
			workingProbability = 25
			randomProbability = 7


	to_chat(user, SPAN_NOTICE("You press a few buttons..."))
	//Add a little delay so the user wouldn't be just spamming all the buttons
	user.next_move = world.time + 3
	if(do_after(usr, 3, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 1))
		var/chance = rand(1, 100)
		if(chance <= randomProbability)
			return 1
		chance-=randomProbability
		if(chance <= workingProbability)
			return 2
	return 0


//This is used to punish people that fiddle with technology they don't understand
/obj/item/clothing/gloves/yautja/hunter/proc/delimb_user()
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(isYautja(usr)) return

	var/obj/limb/O = user.get_limb(check_zone("r_arm"))
	O.droplimb()
	O = user.get_limb(check_zone("l_arm"))
	O.droplimb()

	to_chat(user, SPAN_NOTICE("The device emits a strange noise and falls off... Along with your arms!"))
	playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)
	return 1

// Toggle the notification sound
/obj/item/clothing/gloves/yautja/hunter/toggle_notification_sound()
	set category = "Yautja.Misc"

//Should put a cool menu here, like ninjas.
/obj/item/clothing/gloves/yautja/hunter/verb/wristblades()
	set name = "Use Wrist Blades"
	set desc = "Extend your wrist blades. They cannot be dropped, but can be retracted."
	set category = "Yautja.Weapons"
	set src in usr
	. = wristblades_internal(FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/wristblades_internal(var/forced = FALSE)
	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	var/obj/item/weapon/wristblades/R = user.get_active_hand()
	var/obj/item/weapon/wristblades/L = user.get_inactive_hand()
	var/is_lefthand_full = FALSE
	if(R && istype(R)) //Turn it off.
		if(scimitars)
			to_chat(user, SPAN_NOTICE("You retract your scimitars."))
		else
			to_chat(user, SPAN_NOTICE("You retract your wrist blades."))
		playsound(user.loc,'sound/weapons/wristblades_off.ogg', 15, 1)
		blades_active = 0
		qdel(R)
		if(L && istype(L)) //If they have one in the off hand as well turn it off.
			qdel(L)
		return
	else
		if(!drain_power(user,50)) return

		if(R)
			to_chat(user, SPAN_WARNING("Your hand must be free to activate your wristblade!"))
			return
		if(L)
			to_chat(user, SPAN_WARNING("Your other hand must be free to activate your off-hand wristblade!"))
			is_lefthand_full = TRUE
		var/obj/limb/hand = user.get_limb(user.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("You can't hold that!"))
			return
		if(scimitars)
			var/obj/item/weapon/wristblades/scimitar/N = new()
			user.put_in_active_hand(N)
			if(!is_lefthand_full)
				var/obj/item/weapon/wristblades/scimitar/W = new()
				user.put_in_inactive_hand(W)
		else
			var/obj/item/weapon/wristblades/blades/N = new()
			user.put_in_active_hand(N)
			if(!is_lefthand_full)
				var/obj/item/weapon/wristblades/blades/W = new()
				user.put_in_inactive_hand(W)
		blades_active = 1
		if(scimitars)
			to_chat(user, SPAN_NOTICE("You activate your scimitars."))
		else
			to_chat(user, SPAN_NOTICE("You activate your wrist blades."))
		playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)

	return 1

/obj/item/clothing/gloves/yautja/hunter/verb/track_gear()
	set name = "Track Yautja Gear"
	set desc = "Find Yauja Gear."
	set category = "Yautja.Tracker"
	set src in usr
	. = track_gear_internal(FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/track_gear_internal(var/forced = FALSE)
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	var/dead_on_planet = 0
	var/dead_on_almayer = 0
	var/dead_low_orbit = 0
	var/gear_on_planet = 0
	var/gear_on_almayer = 0
	var/gear_low_orbit = 0
	var/closest = 10000
	var/direction = -1
	var/atom/areaLoc = null
	for(var/obj/item/I in yautja_gear)
		var/atom/loc = get_true_location(I)
		if (isYautja(loc))
			//it's actually yautja holding the item, ignore!
			continue
		if (ishuman(loc))
			var/mob/living/carbon/human/l = loc
			if((l.hunter_data.honored || l.hunter_data.thralled) && !(l.hunter_data.dishonored || l.stat == DEAD))
			//it's actually a thrall holding the item or a gift, ignore!
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
	for(var/mob/living/carbon/human/Y in GLOB.yautja_mob_list)
		if(Y.stat != DEAD) continue
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

	var/output = 0
	if(dead_on_planet || dead_on_almayer || dead_low_orbit)
		output = 1
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of deceased Yautja bio signatures, [dead_on_planet] in the hunting grounds, [dead_on_almayer] in orbit, [dead_low_orbit] in low orbit."))
	if(gear_on_planet || gear_on_almayer || gear_low_orbit)
		output = 1
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of Yautja technology signatures, [gear_on_planet] in the hunting grounds, [gear_on_almayer] in orbit, [gear_low_orbit] in low orbit."))
	if(closest < 900)
		var/areaName = get_area_name(areaLoc)
		to_chat(M, SPAN_NOTICE("The closest signature is approximately [round(closest,10)] paces [dir2text(direction)] in [areaName]."))
	if(!output)
		to_chat(M, SPAN_NOTICE("There are no signatures that require your attention."))
	return 1


/obj/item/clothing/gloves/yautja/hunter/verb/cloaker()
	set name = "Toggle Cloaking Device"
	set desc = "Activate your suit's cloaking device. It will malfunction if the suit takes damage or gets excessively wet."
	set category = "Yautja.Utility"
	set src in usr
	. = cloaker_internal(FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/cloaker_internal(var/forced = FALSE)
	if(!usr || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			if(cloaked) //Turn it off.
				//We're going to be nice here and say you can turn off the cloak without an issue
				//Otherwise, humans wouldn't have any use for the cloak without being shocked every time they turn it on
				//Since they couldn't turn it off in time afterwards with consistency
				decloak(usr)
				return 1
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(cloaked) //Turn it off.
		decloak(usr)
	else //Turn it on!
		if(exploding)
			to_chat(M, SPAN_WARNING("Your bracer is much too busy violently exploding to activate the cloaking device."))
			return 0

		if(cloak_cooldown && cloak_cooldown > world.time)
			to_chat(M, SPAN_WARNING("Your cloak is malfunctioning and can't be enabled right now!"))
			return

		if(cloak_timer)
			if(prob(50))
				to_chat(M, SPAN_WARNING("Your cloaking device is still recharging! Time left: <B>[cloak_timer]</b> seconds."))
			return 0

		if(!drain_power(M,50))
			return


		cloaked = TRUE

		RegisterSignal(M, COMSIG_HUMAN_EXTINGUISH, .proc/wrapper_fizzle_camouflage)
		RegisterSignal(M, COMSIG_HUMAN_PRE_BULLET_ACT, .proc/bullet_hit)

		to_chat(M, SPAN_NOTICE("You are now invisible to normal detection."))
		log_game("[key_name_admin(usr)] has enabled their cloaking device.")
		for(var/mob/O in oviewers(M))
			O.show_message("[M] vanishes into thin air!",1)
		playsound(M.loc,'sound/effects/pred_cloakon.ogg', 15, 1)
		M.alpha = 25

		var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
		SA.remove_from_hud(M)
		var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
		XI.remove_from_hud(M)
		anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

	return 1

/obj/item/clothing/gloves/yautja/hunter/proc/wrapper_fizzle_camouflage()
	SIGNAL_HANDLER
	var/mob/wearer = src.loc
	wearer.visible_message(SPAN_DANGER("[wearer]'s cloak fizzles out!"), SPAN_DANGER("Your cloak fizzles out!"))
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(5, 4, src)
	sparks.start()
	decloak(wearer, TRUE)

/obj/item/clothing/gloves/yautja/hunter/proc/decloak(var/mob/user, forced)
	if(!user) return

	UnregisterSignal(user, COMSIG_HUMAN_EXTINGUISH)
	UnregisterSignal(user, COMSIG_HUMAN_PRE_BULLET_ACT)

	if(forced)
		cloak_cooldown = world.time + 10 SECONDS

	to_chat(user, "Your cloaking device deactivates.")
	cloaked = 0
	log_game("[key_name_admin(usr)] has disabled their cloaking device.")
	for(var/mob/O in oviewers(user))
		O.show_message("[user.name] shimmers into existence!",1)
	playsound(user.loc,'sound/effects/pred_cloakoff.ogg', 15, 1)
	user.alpha = initial(user.alpha)
	cloak_timer = 5

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(user)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(user)

	if(user)
		anim(user.loc,user,'icons/mob/mob.dmi',,"uncloak",,user.dir)


/obj/item/clothing/gloves/yautja/hunter/verb/caster()
	set name = "Use Plasma Caster"
	set desc = "Activate your plasma caster. If it is dropped it will retract back into your armor."
	set category = "Yautja.Weapons"
	set src in usr
	. = caster_internal(FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/caster_internal(var/forced = FALSE)
	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	var/obj/item/weapon/gun/energy/yautja/plasma_caster/R = usr.r_hand
	var/obj/item/weapon/gun/energy/yautja/plasma_caster/L = usr.l_hand
	if(!istype(R) && !istype(L))
		caster_active = 0
	if(caster_active) //Turn it off.
		var/found = 0
		if(R && istype(R))
			found = 1
			usr.r_hand = null
			if(R)
				M.temp_drop_inv_item(R)
				R.forceMove(src)
			M.update_inv_r_hand()
		if(L && istype(L))
			found = 1
			usr.l_hand = null
			if(L)
				M.temp_drop_inv_item(L)
				L.forceMove(src)
			M.update_inv_l_hand()
		if(found)
			to_chat(usr, SPAN_NOTICE("You deactivate your plasma caster."))
			playsound(src,'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
			caster_active = 0
		return
	else //Turn it on!
		if(usr.get_active_hand())
			to_chat(usr, SPAN_WARNING("Your hand must be free to activate your caster!"))
			return
		if(!drain_power(usr,50)) return

		var/obj/item/weapon/gun/energy/yautja/plasma_caster/W = caster
		if(!istype(W))
			W = new(usr)
		usr.put_in_active_hand(W)
		W.source = src
		caster_active = 1
		to_chat(usr, SPAN_NOTICE("You activate your plasma caster. It is in [W.mode] mode."))
		playsound(src,'sound/weapons/pred_plasmacaster_on.ogg', 15, 1)
	return 1


/obj/item/clothing/gloves/yautja/hunter/proc/explode(var/mob/living/carbon/victim)
	set waitfor = 0

	if (exploding)
		return

	exploding = 1

	playsound(src, 'sound/effects/pred_countdown.ogg', 100, 0, 17, status = 0)
	message_staff(FONT_SIZE_XL("<A HREF='?_src_=admin_holder;admincancelpredsd=1;bracer=\ref[src];victim=\ref[victim]'>CLICK TO CANCEL THIS PRED SD</a>"))
	do_after(victim, rand(72, 80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	var/turf/T = get_turf(src) // The explosion orginates from the bracer, not the pred
	if(istype(T) && exploding)
		victim.apply_damage(50,BRUTE,"chest")
		if(victim)
			victim.gib_animation() // Gibs them but does not drop the limbs so the equipment isn't dropped
			qdel(victim)
		var/datum/cause_data/cause_data = create_cause_data("yautja self destruct", victim)
		if(explosion_type == 0 && is_ground_level(z))
			cell_explosion(T, 600, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //Dramatically BIG explosion.
		else
			cell_explosion(T, 800, 550, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)

/obj/item/clothing/gloves/yautja/hunter/verb/activate_suicide()
	set name = "Final Countdown (!)"
	set desc = "Activate the explosive device implanted into your bracers. You have failed! Show some honor!"
	set category = "Yautja.Misc"
	set src in usr
	. = activate_suicide_internal(FALSE)

/obj/item/clothing/gloves/yautja/hunter/verb/change_explosion_type()
	set name = "Change Explosion Type"
	set desc = "Changes your bracer explosion to either only gib you or be a big explosion."
	set category = "Yautja.Misc"
	set src in usr
	if(alert("Which explosion type do you want?","Explosive Bracers", "Small", "Big") == "Big")
		explosion_type = 0
		log_attack("[key_name_admin(usr)] has changed their Self Destruct to Large")
	else
		explosion_type = 1
		log_attack("[key_name_admin(usr)] has changed their Self Destruct to Small")


/obj/item/clothing/gloves/yautja/hunter/proc/activate_suicide_internal(var/forced = FALSE)
	if(!usr) return
	var/mob/living/carbon/human/M = usr
	if(cloaked)
		to_chat(M, SPAN_WARNING("Not while you're cloaked. It might disrupt the sequence."))
		return
	if(!M.stat == CONSCIOUS)
		to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
		return
	if(M.health < HEALTH_THRESHOLD_CRIT)
		to_chat(M, SPAN_WARNING("As you fall into unconsciousness you fail to activate your self-destruct device before you collapse."))
		return
	if(M.stat == DEAD)
		to_chat(M, SPAN_WARNING("Little too late for that now!"))
		return
	if(!forced && !HAS_TRAIT(M, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

		//Council did not want the humans to trigger SD EVER
		. = delimb_user()
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
							message_staff(FONT_SIZE_HUGE("ALERT: [usr] ([usr.key]) triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)</font>"))
							log_attack("[key_name(usr)] triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name]")
						if (!bracer.exploding)
							bracer.explode(victim)
						M.visible_message(SPAN_WARNING("[M] presses a few buttons on [victim]'s wrist bracer."),SPAN_DANGER("You activate the timer. May [victim]'s final hunt be swift."))
						message_all_yautja("[M] has triggered [victim]'s bracer's self-destruction sequence.")
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
			if(!M.stat == CONSCIOUS)
				to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
				return
			exploding = 0
			to_chat(M, SPAN_NOTICE("Your bracers stop beeping."))
			message_staff("[usr] ([usr.key]) has deactivated their Self Destruct.")
		return
	if((M.wear_mask && istype(M.wear_mask,/obj/item/clothing/mask/facehugger)) || M.status_flags & XENO_HOST)
		to_chat(M, SPAN_WARNING("Strange...something seems to be interfering with your bracer functions..."))
		return
	if(forced || alert("Detonate the bracers? Are you sure?","Explosive Bracers", "Yes", "No") == "Yes")
		if(M.gloves != src)
			return
		if(M.stat == DEAD)
			to_chat(M, SPAN_WARNING("Little too late for that now!"))
			return
		if(!M.stat == CONSCIOUS)
			to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
			return
		if(exploding)
			return
		to_chat(M, SPAN_DANGER("You set the timer. May your journey to the great hunting grounds be swift."))
		var/area/A = get_area(M)
		var/turf/T = get_turf(M)
		message_staff(FONT_SIZE_HUGE("ALERT: [usr] ([usr.key]) triggered their predator self-destruct sequence [A ? "in [A.name]":""] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)"))
		log_attack("[key_name(usr)] triggered their predator self-destruct sequence in [A ? "in [A.name]":""]")

		explode(M)
	return 1



/obj/item/clothing/gloves/yautja/hunter/verb/injectors()
	set name = "Create Self-Heal Crystal"
	set category = "Yautja.Utility"
	set desc = "Create a focus crystal to energize your natural healing processes."
	set src in usr
	. = injectors_internal(FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/injectors_internal(var/forced = FALSE)
	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
		return 0

	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(usr.get_active_hand())
		to_chat(usr, SPAN_WARNING("Your active hand must be empty!"))
		return 0

	if(inject_timer)
		to_chat(usr, SPAN_WARNING("You recently activated the healing crystal. Be patient."))
		return

	if(!drain_power(usr,1000)) return

	inject_timer = TRUE
	addtimer(CALLBACK(src, .proc/injectors_ready), 2 MINUTES)

	to_chat(usr, SPAN_NOTICE(" You feel a faint hiss and a crystalline injector drops into your hand."))
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(usr)
	usr.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return 1

/obj/item/clothing/gloves/yautja/hunter/proc/injectors_ready()
	if(ismob(loc))
		to_chat(loc, SPAN_NOTICE(" Your bracers beep faintly and inform you that a new healing crystal is ready to be created."))
	inject_timer = FALSE

/obj/item/clothing/gloves/yautja/hunter/verb/call_disk()
	set name = "Call Smart-Disc"
	set category = "Yautja.Weapons"
	set desc = "Call back your smart-disc, if it's in range. If not you'll have to go retrieve it."
	set src in usr
	. = call_disk_internal(FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/call_disk_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(disc_timer)
		to_chat(usr, SPAN_WARNING("Your bracers need some time to recuperate first."))
		return 0

	if(!drain_power(usr,70)) return
	disc_timer = 1
	addtimer(VARSET_CALLBACK(src, disc_timer, FALSE), 10 SECONDS)

	for(var/mob/living/simple_animal/hostile/smartdisc/S in range(7))
		to_chat(usr, SPAN_WARNING("The [S] skips back towards you!"))
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(S.loc)
		qdel(S)

	for(var/obj/item/explosive/grenade/spawnergrenade/smartdisc/D in range(10))
		var/datum/launch_metadata/LM = new()
		LM.target = usr
		LM.range = 10
		LM.speed = SPEED_FAST
		LM.thrower = usr
		D.launch_towards(LM)
	return 1

/obj/item/clothing/gloves/yautja/hunter/verb/remove_tracked_item()
	set name = "Remove item from tracker"
	set category = "Yautja.Tracker"
	set desc = "Removes an item from all yautja tracking."
	set src in usr
	. = remove_tracked_item_internal(FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/remove_tracked_item_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(!yautja_gear.len)
		return
	var/obj/item/pickeditem = tgui_input_list(usr, "item to remove", "Remove item", yautja_gear)
	if(pickeditem && !(pickeditem in untracked_yautja_gear))
		untracked_yautja_gear += pickeditem
		remove_from_missing_pred_gear(pickeditem)


/obj/item/clothing/gloves/yautja/hunter/verb/add_tracked_item()
	set name = "Add item to tracker"
	set category = "Yautja.Tracker"
	set desc = "Adds an item to all yautja tracking."
	set src in usr
	. = add_tracked_item_internal(FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/add_tracked_item_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(!untracked_yautja_gear.len)
		return
	var/obj/item/pickeditem = tgui_input_list(usr, "item to add", "Add item", untracked_yautja_gear)
	if(pickeditem && !(pickeditem in yautja_gear))
		untracked_yautja_gear -= pickeditem
		add_to_missing_pred_gear(pickeditem)

/obj/item/clothing/gloves/yautja/hunter/verb/call_combi()
	set name = "Yank Combi-stick"
	set category = "Yautja.Weapons"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."
	set src in usr
	. = call_combi_internal(FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/call_combi_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	for(var/obj/item/weapon/melee/yautja/combistick/C in range(7))
		if(usr.get_active_hand() == C || usr.get_inactive_hand() == C) //Check if THIS combistick is in our hands already.
			continue
		else if(usr.put_in_active_hand(C))//Try putting it in our active hand, or, if it's full...
			if(!drain_power(usr,70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return
			usr.visible_message(SPAN_WARNING("<b>[usr] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
		else if(usr.put_in_inactive_hand(C))///...Try putting it in our inactive hand.
			if(!drain_power(usr,70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return
			usr.visible_message(SPAN_WARNING("<b>[usr] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
		else //If neither hand can hold it, you must not have a free hand.
			to_chat(usr, SPAN_WARNING("You need a free hand to do this!</b>"))

/obj/item/clothing/gloves/yautja/hunter/verb/translate()
	set name = "Translator"
	set desc = "Emit a message from your bracer to those nearby."
	set category = "Yautja.Utility"
	set src in usr
	. = translate_internal(FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/translate_internal(var/forced = FALSE)
	if(!usr || usr.stat) return

	if(!forced && !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	usr.set_typing_indicator(TRUE, "translator")
	var/msg = sanitize(input(usr, "Your bracer beeps and waits patiently for you to input your message.", "Translator", "") as text)
	usr.set_typing_indicator(FALSE, "translator")
	if(!msg || !usr.client)
		return

	if(!drain_power(usr, 50))
		return

	log_say("Yautja Translator/[usr.client.ckey] : [msg]")

	var/list/heard = get_mobs_in_view(7, usr)
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

	usr.langchat_speech(msg, heard, GLOB.all_languages, overhead_color, TRUE)

	var/mob/M = usr
	var/voice_name = "A strange voice"
	if(M.name == M.real_name)
		voice_name = "<b>[M.name]</b>"
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
